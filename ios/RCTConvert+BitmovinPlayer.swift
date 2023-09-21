import Foundation
import BitmovinPlayer
import BitmovinCollector

extension RCTConvert {
    /**
     Utility method to instantiate a `PlayerConfig` from a JS object.
     - Parameter json: JS object
     - Returns: The produced `PlayerConfig` object
     */
    static func playerConfig(_ json: Any?) -> PlayerConfig? {
        let playerConfig = PlayerConfig()
        guard let json = json as? [String: Any?] else {
            return playerConfig
        }
        if let licenseKey = json["licenseKey"] as? String {
            playerConfig.key = licenseKey
        }
        if let playbackConfig = RCTConvert.playbackConfig(json["playbackConfig"]) {
            playerConfig.playbackConfig = playbackConfig
        }
        if let styleConfig = RCTConvert.styleConfig(json["styleConfig"]) {
            playerConfig.styleConfig = styleConfig
        }
        if let tweaksConfig = RCTConvert.tweaksConfig(json["tweaksConfig"]) {
            playerConfig.tweaksConfig = tweaksConfig
        }
        if let advertisingConfig = RCTConvert.advertisingConfig(json["advertisingConfig"]) {
            playerConfig.advertisingConfig = advertisingConfig
        }
        if let adaptationConfig = RCTConvert.adaptationConfig(json["adaptationConfig"]) {
            playerConfig.adaptationConfig = adaptationConfig
        }
        if let remoteControlConfig = RCTConvert.remoteControlConfig(json["remoteControlConfig"]) {
            playerConfig.remoteControlConfig = remoteControlConfig
        }
        return playerConfig
    }

    /**
     Utility method to instantiate a `PlaybackConfig` from a JS object.
     - Parameter json: JS object.
     - Returns: The produced `PlaybackConfig` object.
     */
    static func playbackConfig(_ json: Any?) -> PlaybackConfig? {
        guard let json = json as? [String: Any?] else {
            return nil
        }
        let playbackConfig = PlaybackConfig()
        if let isAutoplayEnabled = json["isAutoplayEnabled"] as? Bool {
            playbackConfig.isAutoplayEnabled = isAutoplayEnabled
        }
        if let isMuted = json["isMuted"] as? Bool {
            playbackConfig.isMuted = isMuted
        }
        if let isTimeShiftEnabled = json["isTimeShiftEnabled"] as? Bool {
            playbackConfig.isTimeShiftEnabled = isTimeShiftEnabled
        }
        if let isBackgroundPlaybackEnabled = json["isBackgroundPlaybackEnabled"] as? Bool {
            playbackConfig.isBackgroundPlaybackEnabled = isBackgroundPlaybackEnabled
        }
        if let isPictureInPictureEnabled = json["isPictureInPictureEnabled"] as? Bool {
            playbackConfig.isPictureInPictureEnabled = isPictureInPictureEnabled
        }
        return playbackConfig
    }

    /**
     Utility method to instantiate a `StyleConfig` from a JS object.
     - Parameter json: JS object.
     - Returns: The produced `StyleConfig` object.
     */
    static func styleConfig(_ json: Any?) -> StyleConfig? {
        guard let json = json as? [String: Any?] else {
            return nil
        }
        let styleConfig = StyleConfig()
        if let isUiEnabled = json["isUiEnabled"] as? Bool {
            styleConfig.isUiEnabled = isUiEnabled
        }
        if let userInterfaceType = userInterfaceType(json["userInterfaceType"]) {
            styleConfig.userInterfaceType = userInterfaceType
        }
#if !os(tvOS)
        if let playerUiCss = json["playerUiCss"] as? String {
            styleConfig.playerUiCss = RCTConvert.nsurl(playerUiCss)
        }
        if let supplementalPlayerUiCss = json["supplementalPlayerUiCss"] as? String {
            styleConfig.supplementalPlayerUiCss = RCTConvert.nsurl(supplementalPlayerUiCss)
        }
        if let playerUiJs = json["playerUiJs"] as? String {
            styleConfig.playerUiJs = RCTConvert.nsurl(playerUiJs)
        }
#endif
        if let scalingMode = json["scalingMode"] as? String {
            switch scalingMode {
            case "Fit":
                styleConfig.scalingMode = .fit
            case "Stretch":
                styleConfig.scalingMode = .stretch
            case "Zoom":
                styleConfig.scalingMode = .zoom
            default:
                styleConfig.scalingMode = .fit
                break
            }
        }
        return styleConfig
    }

    /**
     Utility method to instantiate a `TweaksConfig` from a JS object.
     - Parameter json: JS object.
     - Returns: The produced `TweaksConfig` object.
     */
    static func tweaksConfig(_ json: Any?) -> TweaksConfig? {
        guard let json = json as? [String: Any?] else {
            return nil
        }
        let tweaksConfig = TweaksConfig()
        if let isNativeHlsParsingEnabled = json["isNativeHlsParsingEnabled"] as? Bool {
            tweaksConfig.isNativeHlsParsingEnabled = isNativeHlsParsingEnabled
        }
        if let isCustomHlsLoadingEnabled = json["isCustomHlsLoadingEnabled"] as? Bool {
            tweaksConfig.isCustomHlsLoadingEnabled = isCustomHlsLoadingEnabled
        }
        if let timeChangedInterval = json["timeChangedInterval"] as? NSNumber {
            tweaksConfig.timeChangedInterval = timeChangedInterval.doubleValue
        }
        if let seekToEndThreshold = json["seekToEndThreshold"] as? NSNumber {
            tweaksConfig.seekToEndThreshold = seekToEndThreshold.doubleValue
        }
        if let playbackStartBehaviour = json["playbackStartBehaviour"] as? String {
            switch playbackStartBehaviour {
            case "relaxed":
                tweaksConfig.playbackStartBehaviour = .relaxed
            case "aggressive":
                tweaksConfig.playbackStartBehaviour = .aggressive
            default:
                break
            }
        }
        if let unstallingBehaviour = json["unstallingBehaviour"] as? String {
            switch unstallingBehaviour {
            case "relaxed":
                tweaksConfig.unstallingBehaviour = .relaxed
            case "aggressive":
                tweaksConfig.unstallingBehaviour = .aggressive
            default:
                break
            }
        }
        return tweaksConfig
    }

    /**
     Utility method to instantiate an `AdvertisingConfig` from a JS object.
     - Parameter json: JS object.
     - Returns: The produced `AdvertisingConfig` object.
     */
    static func advertisingConfig(_ json: Any?) -> AdvertisingConfig? {
        guard
            let json = json as? [String: Any?],
            let schedule = json["schedule"] as? [[String: Any?]]
        else {
            return nil
        }
        return AdvertisingConfig(schedule: schedule.compactMap { RCTConvert.adItem($0) })
    }

    /**
     Utility method to instantiate an `AdItem` from a JS object.
     - Parameter json: JS object.
     - Returns: The produced `AdItem` object.
     */
    static func adItem(_ json: Any?) -> AdItem? {
        guard
            let json = json as? [String: Any?],
            let sources = json["sources"] as? [[String: Any?]]
        else {
            return nil
        }
        return AdItem(
            adSources: sources.compactMap { RCTConvert.adSource($0) },
            atPosition: json["position"] as? String
        )
    }

    /**
     Utility method to instantiate an `AdSource` from a JS object.
     - Parameter json: JS object.
     - Returns: The produced `AdSource` object.
     */
    static func adSource(_ json: Any?) -> AdSource? {
        guard
            let json = json as? [String: Any?],
            let tag = RCTConvert.nsurl(json["tag"]),
            let type = RCTConvert.adSourceType(json["type"])
        else {
            return nil
        }
        return AdSource(tag: tag, ofType: type)
    }

    /**
     Utility method to instantiate an `AdSourceType` from a JS object.
     - Parameter json: JS object.
     - Returns: The produced `AdSourceType` object.
     */
    static func adSourceType(_ json: Any?) -> AdSourceType? {
        guard let json = json as? String else {
            return nil
        }
        switch json {
        case "ima":
            return .ima
        case "unknown":
            return .unknown
        case "progressive":
            return .progressive
        default:
            return nil
        }
    }

    /**
     Utility method to instantiate a `SourceConfig` from a JS object.
     - Parameter json: JS object
     - Returns: The produced `SourceConfig` object
     */
    static func sourceConfig(_ json: Any?, drmConfig: DrmConfig? = nil) -> SourceConfig? {
        guard let json = json as? [String: Any?] else {
            return nil
        }
        let sourceConfig = SourceConfig(
            url: RCTConvert.nsurl(json["url"]),
            type: RCTConvert.sourceType(json["type"])
        )
        if let drmConfig = drmConfig {
            sourceConfig.drmConfig = drmConfig
        }
        if let title = json["title"] as? String {
            sourceConfig.title = title
        }
        if let description = json["description"] as? String {
            sourceConfig.sourceDescription = description
        }
        if let poster = json["poster"] as? String {
            sourceConfig.posterSource = RCTConvert.nsurl(poster)
        }
        if let isPosterPersistent = json["isPosterPersistent"] as? Bool {
            sourceConfig.isPosterPersistent = isPosterPersistent
        }
        if let subtitleTracks = json["subtitleTracks"] as? [[String: Any]] {
            subtitleTracks.forEach {
                if let track = RCTConvert.subtitleTrack($0) {
                    sourceConfig.add(subtitleTrack: track)
                }
            }
        }
        if let thumbnailTrack = json["thumbnailTrack"] as? String {
            sourceConfig.thumbnailTrack = RCTConvert.thumbnailTrack(thumbnailTrack)
        }
        if let metadata = json["metadata"] as? [String: String] {
            sourceConfig.metadata = metadata
        }
        if let options = json["options"] as? [String: Any] {
            sourceConfig.options = RCTConvert.sourceOptions(options)
        }
        return sourceConfig
    }

    /**
     Utility method to instantiate a `SourceOptions` from a JS object.
     - Parameter json: JS object
     - Returns: The produced `SourceOptions` object
     */
    static func sourceOptions(_ json: Any?) -> SourceOptions {
        let sourceOptions = SourceOptions()
        guard let json = json as? [String: Any?] else {
            return sourceOptions
        }
        if let startOffset = json["startOffset"] as? NSNumber {
            sourceOptions.startOffset = startOffset.doubleValue
        }
        sourceOptions.startOffsetTimelineReference = RCTConvert.timelineReferencePoint(json["startOffsetTimelineReference"])
        return sourceOptions
    }

    /**
     Utility method to instantiate a `TimelineReferencePoint` from a JS object.
     - Parameter json: JS object
     - Returns: The produced `TimelineReferencePoint` value
     */
    static func timelineReferencePoint(_ json: Any?) -> TimelineReferencePoint {
        guard let stringValue = json as? String else { return .auto }
        switch stringValue {
        case "start": return .start
        case "end": return .end
        default: return .auto
        }
    }

    /**
     Utility method to get a `SourceType` from a JS object.
     - Parameter json: JS object
     - Returns: The associated `SourceType` value
     */
    static func sourceType(_ json: Any?) -> SourceType {
        guard let json = json as? String else {
            return .none
        }
        switch json {
        case "none": return .none
        case "hls": return .hls
        case "dash": return .dash
        case "progressive": return .progressive
        default: return .none
        }
    }

    /**
     Utility method to get a `TimeMode` from a JS object.
     - Parameter json: JS object
     - Returns: The associated `TimeMode` value
     */
    static func timeMode(_ json: Any?) -> TimeMode {
        guard let json = json as? String else {
            return .absoluteTime
        }
        switch json {
        case "absolute": return .absoluteTime
        case "relative": return .relativeTime
        default: return .absoluteTime
        }
    }

    /**
     Utility method to get a `DrmConfig` from a JS object.
     - Parameter json: JS object
     - Returns: The generated `DrmConfig` object
     */
    static func drmConfig(_ json: Any?) -> DrmConfig? {
        guard let json = json as? [String: Any?] else {
            return nil
        }
        if  let fairplayConfig = RCTConvert.fairplayConfig(json["fairplay"]) {
            return fairplayConfig
        }
        if let widevineConfig = RCTConvert.widevineConfig(json["widevine"]) {
            return widevineConfig
        }
        return nil
    }

    /**
     Utility method to get a `FairplayConfig` from a JS object.
     - Parameter json: JS object
     - Returns: The generated `FairplayConfig` object
     */
    static func fairplayConfig(_ json: Any?) -> FairplayConfig? {
        guard let json = json as? [String: Any?],
            let licenseURL = json["licenseUrl"] as? String,
            let certificateURL = json["certificateUrl"] as? String else {
            return nil
        }
        let fairplayConfig = FairplayConfig(
            license: URL(string: licenseURL),
            certificateURL: URL(string: certificateURL)!
        )
        if let licenseRequestHeaders = json["licenseRequestHeaders"] as? [String: String] {
            fairplayConfig.licenseRequestHeaders = licenseRequestHeaders
        }
        if let certificateRequestHeaders = json["certificateRequestHeaders"] as? [String: String] {
            fairplayConfig.certificateRequestHeaders = certificateRequestHeaders
        }
        return fairplayConfig
    }

    /**
     Utility method to get a `WidevineConfig` from a JS object.
     - Parameter json: JS object
     - Returns: The generated `WidevineConfig` object
     */
    static func widevineConfig(_ json: Any?) -> WidevineConfig? {
        guard let json = json as? [String: Any?],
            let licenseURL = json["licenseUrl"] as? String else {
            return nil
        }
        let widevineConfig = WidevineConfig(license: URL(string: licenseURL))
        if let licenseRequestHeaders = json["httpHeaders"] as? [String: String] {
            widevineConfig.licenseRequestHeaders = licenseRequestHeaders
        }
        return widevineConfig
    }

    /**
     Utility method to get a `ThumbnailTrack` instance from a JS object.
     - Parameter url: String.
     - Returns: The generated `ThumbnailTrack`.
     */
    static func thumbnailTrack(_ url: String?) -> ThumbnailTrack? {
        guard
            let url = RCTConvert.nsurl(url)
        else {
            return nil
        }
        return ThumbnailTrack(
            url: url,
            label: "Thumbnails",
            identifier: UUID().uuidString,
            isDefaultTrack: false
        )
    }

    /**
     Utility method to get a json dictionary value from a `AudioTrack` object.
     - Parameter audioTrack: The track to convert to json format.
     - Returns: The generated json dictionary.
     */
    static func audioTrackJson(_ audioTrack: AudioTrack?) -> [AnyHashable: Any]? {
        guard let audioTrack = audioTrack else {
            return nil
        }
        return [
            "url": audioTrack.url?.absoluteString,
            "label": audioTrack.label,
            "isDefault": audioTrack.isDefaultTrack,
            "identifier": audioTrack.identifier,
            "language": audioTrack.language
        ]
    }

    /**
     Utility method to get a `SubtitleTrack` instance from a JS object.
     - Parameter json: JS object.
     - Returns: The generated `SubtitleTrack`.
     */
    static func subtitleTrack(_ json: [String: Any]) -> SubtitleTrack? {
        guard
            let url = RCTConvert.nsurl(json["url"]),
            let label = json["label"] as? String
        else {
            return nil
        }

        let language = json["language"] as? String
        let isDefaultTrack = json["isDefault"] as? Bool ?? false
        let isForced = json["isForced"] as? Bool ?? false
        let identifier = json["identifier"] as? String ?? UUID().uuidString

        if let format = RCTConvert.subtitleFormat(json["format"]) {
            return SubtitleTrack(
                url: url,
                format: format,
                label: label,
                identifier: identifier,
                isDefaultTrack: isDefaultTrack,
                language: language,
                forced: isForced
            )
        }
        return SubtitleTrack(
            url: url,
            label: label,
            identifier: identifier,
            isDefaultTrack: isDefaultTrack,
            language: language,
            forced: isForced
        )
    }

    /**
     Utility method to get a `SubtitleFormat` value from a JS object.
     - Parameter json: JS object.
     - Returns: The associated `SubtitleFormat` value or nil.
     */
    static func subtitleFormat(_ json: Any?) -> SubtitleFormat? {
        guard let json = json as? String else {
            return nil
        }
        switch json {
        case "cea": return .cea
        case "vtt": return .webVtt
        case "ttml": return .ttml
        default: return nil
        }
    }

    /**
     Utility method to get a json dictionary value from a `SubtitleTrack` object.
     - Parameter subtitleTrack: The track to convert to json format.
     - Returns: The generated json dictionary.
     */
    static func subtitleTrackJson(_ subtitleTrack: SubtitleTrack?) -> [AnyHashable: Any]? {
        guard let subtitleTrack = subtitleTrack else {
            return nil
        }
        return [
            "url": subtitleTrack.url?.absoluteString,
            "label": subtitleTrack.label,
            "isDefault": subtitleTrack.isDefaultTrack,
            "identifier": subtitleTrack.identifier,
            "language": subtitleTrack.language,
            "isForced": subtitleTrack.isForced,
            "format": {
                switch subtitleTrack.format {
                case .cea: return "cea"
                case .webVtt: return "vtt"
                case .ttml: return "ttml"
                }
            }(),
        ]
    }

    /**
     Utility method to get a json dictionary value from a `ThumbnailTrack` object.
     - Parameter thumbnailTrack: The `ThumbnailTrack` to convert to json format.
     - Returns: The generated json dictionary.
     */
    static func toJson(thumbnailTrack: ThumbnailTrack?) -> [AnyHashable: Any]? {
        guard let thumbnailTrack = thumbnailTrack else {
            return nil
        }

        return [
            "url": thumbnailTrack.url?.absoluteString,
            "label": thumbnailTrack.label,
            "isDefault": thumbnailTrack.isDefaultTrack,
            "identifier": thumbnailTrack.identifier
        ]
    }

    /**
     Utility method to compute a JS value from an `AdItem` object.
     - Parameter adItem: `AdItem` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(adItem: AdItem?) -> [String: Any?]? {
        guard let adItem = adItem else {
            return nil
        }
        return [
            "position": adItem.position,
            "sources": adItem.sources.compactMap { RCTConvert.toJson(adSource: $0) }
        ]
    }

    /**
     Utility method to compute a JS value from an `AdSource` object.
     - Parameter adSource: `AdSource` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(adSource: AdSource?) -> [String: Any?]? {
        guard let adSource = adSource else {
            return nil
        }
        return [
            "tag": adSource.tag,
            "type": RCTConvert.toJson(adSourceType: adSource.type)
        ]
    }

    /**
     Utility method to compute a JS value from an `AdSourceType` value.
     - Parameter adSourceType: `AdSourceType` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(adSourceType: AdSourceType?) -> String? {
        guard let adSourceType = adSourceType else {
            return nil
        }
        switch adSourceType {
        case .ima:
            return "ima"
        case .unknown:
            return "unknown"
        case .progressive:
            return "progressive"
        default:
            return nil
        }
    }

    /**
     Utility method to compute a JS value from an `AdConfig` object.
     - Parameter adConfig: `AdConfig` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(adConfig: AdConfig?) -> [String: Any?]? {
        guard let adConfig = adConfig else {
            return nil
        }
        return ["replaceContentDuration": adConfig.replaceContentDuration]
    }

    /**
     Utility method to compute a JS string from an `AdQuartile` value.
     - Parameter adQuartile: `AdQuartile` value to be converted.
     - Returns: The produced JS string.
     */
    static func toJson(adQuartile: AdQuartile?) -> String? {
        guard let adQuartile = adQuartile else {
            return nil
        }
        switch adQuartile {
        case .firstQuartile:
            return "first"
        case .midpoint:
            return "mid_point"
        case .thirdQuartile:
            return "third"
        }
    }

    /**
     Utility method to compute a JS value from an `AdBreak` object.
     - Parameter adBreak: `AdBreak` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(adBreak: AdBreak?) -> [String: Any?]? {
        guard let adBreak = adBreak else {
            return nil
        }
        return [
            "ads": adBreak.ads.compactMap { RCTConvert.toJson(ad: $0) },
            "id": adBreak.identifier,
            "scheduleTime": adBreak.scheduleTime
        ]
    }

    /**
     Utility method to compute a JS value from an `Ad` object.
     - Parameter ad: `Ad` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(ad: Ad?) -> [String: Any?]? {
        guard let ad = ad else {
            return nil
        }
        return [
            "clickThroughUrl": ad.clickThroughUrl?.absoluteString,
            "data": RCTConvert.toJson(adData: ad.data),
            "height": ad.height,
            "id": ad.identifier,
            "isLinear": ad.isLinear,
            "mediaFileUrl": ad.mediaFileUrl?.absoluteString,
            "width": ad.width
        ]
    }

    /**
     Utility method to compute a JS value from an `AdData` object.
     - Parameter adData `AdData` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(adData: AdData?) -> [String: Any?]? {
        guard let adData = adData else {
            return nil
        }
        return [
            "bitrate": adData.bitrate,
            "maxBitrate": adData.maxBitrate,
            "mimeType": adData.mimeType,
            "minBitrate": adData.minBitrate
        ]
    }

    /**
     Utility method to get a `BitmovinAnalyticsConfig` value from a JS object.
     - Parameter json: JS object.
     - Returns: The associated `BitmovinAnalyticsConfig` value or nil.
     */
    static func analyticsConfig(_ json: Any?) -> AnalyticsConfig? {
        guard
            let json = json as? [String: Any?],
            let key = json["licenseKey"] as? String
        else {
            return nil
        }
        let randomizeUserId = json["randomizeUserId"] as? Bool
        let adTrackingDisabled = json["adTrackingDisabled"] as? Bool

        let config = AnalyticsConfig(
            licenseKey: key,
            randomizeUserId: randomizeUserId ?? false,
            adTrackingDisabled: adTrackingDisabled ?? false
        )
        return config
    }

    static func analyticsDefaultMetadataFromAnalyticsConfig(_ json: Any?) -> DefaultMetadata? {
        guard
            let analyticsConfigJson = json as? [String: Any?],
            let json = analyticsConfigJson["defaultMetadata"] as? [String: Any?]
        else {
            return nil
        }
        let cdnProvider = json["cdnProvider"] as? String
        let customUserId = json["customUserId"] as? String
        let customData = analyticsCustomData(json)

        return DefaultMetadata(
            cdnProvider: cdnProvider,
            customUserId: customUserId,
            customData: customData ?? CustomData()
        )
    }

    /**
     Utility method to get an analytics `CustomData` value from a JS object.
     - Parameter json: JS object.
     - Returns: The associated `CustomData` value or nil.
     */
    static func analyticsCustomData(_ json: Any?) -> CustomData? {
        guard let json = json as? [String: Any?] else {
            return nil
        }
        return CustomData(
            customData1: json["customData1"] as? String,
            customData2: json["customData2"] as? String,
            customData3: json["customData3"] as? String,
            customData4: json["customData4"] as? String,
            customData5: json["customData5"] as? String,
            customData6: json["customData6"] as? String,
            customData7: json["customData7"] as? String,
            customData8: json["customData8"] as? String,
            customData9: json["customData9"] as? String,
            customData10: json["customData10"] as? String,
            customData11: json["customData11"] as? String,
            customData12: json["customData12"] as? String,
            customData13: json["customData13"] as? String,
            customData14: json["customData14"] as? String,
            customData15: json["customData15"] as? String,
            customData16: json["customData16"] as? String,
            customData17: json["customData17"] as? String,
            customData18: json["customData18"] as? String,
            customData19: json["customData19"] as? String,
            customData20: json["customData20"] as? String,
            customData21: json["customData21"] as? String,
            customData22: json["customData22"] as? String,
            customData23: json["customData23"] as? String,
            customData24: json["customData24"] as? String,
            customData25: json["customData25"] as? String,
            customData26: json["customData26"] as? String,
            customData27: json["customData27"] as? String,
            customData28: json["customData28"] as? String,
            customData29: json["customData29"] as? String,
            customData30: json["customData30"] as? String,
            experimentName: json["experimentName"] as? String
        )
    }

    /**
     Utility method to get a JS value from a `CustomData` object.
     - Parameter analyticsCustomData: Analytics custom data object.
     - Returns: The JS value representing the given object.
     */
    static func toJson(analyticsCustomData: CustomData?) -> [String: Any?]? {
        guard let analyticsCustomData = analyticsCustomData else {
            return nil
        }
        var json: [String: Any?] = [:]
        json["customData1"] = analyticsCustomData.customData1
        json["customData2"] = analyticsCustomData.customData2
        json["customData3"] = analyticsCustomData.customData3
        json["customData4"] = analyticsCustomData.customData4
        json["customData5"] = analyticsCustomData.customData5
        json["customData6"] = analyticsCustomData.customData6
        json["customData7"] = analyticsCustomData.customData7
        json["customData8"] = analyticsCustomData.customData8
        json["customData9"] = analyticsCustomData.customData9
        json["customData10"] = analyticsCustomData.customData10
        json["customData11"] = analyticsCustomData.customData11
        json["customData12"] = analyticsCustomData.customData12
        json["customData13"] = analyticsCustomData.customData13
        json["customData14"] = analyticsCustomData.customData14
        json["customData15"] = analyticsCustomData.customData15
        json["customData16"] = analyticsCustomData.customData16
        json["customData17"] = analyticsCustomData.customData17
        json["customData18"] = analyticsCustomData.customData18
        json["customData19"] = analyticsCustomData.customData19
        json["customData20"] = analyticsCustomData.customData20
        json["customData21"] = analyticsCustomData.customData21
        json["customData22"] = analyticsCustomData.customData22
        json["customData23"] = analyticsCustomData.customData23
        json["customData24"] = analyticsCustomData.customData24
        json["customData25"] = analyticsCustomData.customData25
        json["customData26"] = analyticsCustomData.customData26
        json["customData27"] = analyticsCustomData.customData27
        json["customData28"] = analyticsCustomData.customData28
        json["customData29"] = analyticsCustomData.customData29
        json["customData30"] = analyticsCustomData.customData30
        json["experimentName"] = analyticsCustomData.experimentName
        return json
    }

    /**
     Utility method to get an analytics `SourceMetadata` value from a JS object.
     - Parameter json: JS object.
     - Returns: The associated `SourceMetadata` value or nil.
     */
    static func analyticsSourceMetadata(_ json: Any?) -> SourceMetadata? {
        guard let json = json as? [String: Any?] else {
            return nil
        }

        let customData = analyticsCustomData(json)

        return SourceMetadata(
            videoId: json["videoId"] as? String,
            title: json["title"] as? String,
            path: json["path"] as? String,
            isLive: json["isLive"] as? Bool,
            cdnProvider: json["cdnProvider"] as? String,
            customData: customData ?? CustomData()
        )
    }

    /**
     Utility method to compute a JS value from a `VideoQuality` object.
     - Parameter videoQuality `VideoQuality` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(videoQuality: VideoQuality?) -> [String: Any?]? {
        guard let videoQuality = videoQuality else {
            return nil
        }
        return [
            "id": videoQuality.identifier,
            "label": videoQuality.label,
            "height": videoQuality.height,
            "width": videoQuality.width,
            "codec": videoQuality.codec,
            "bitrate": videoQuality.bitrate,
        ]
    }

    /**
     Utility method to get a `UserInterfaceType` from a JS object.
     - Parameter json: JS object
     - Returns: The associated `UserInterfaceType` value or `nil`
     */
    static func userInterfaceType(_ json: Any?) -> UserInterfaceType? {
        guard let json = json as? String else {
            return .none
        }
        switch json {
#if os(iOS)
        case "Bitmovin": return .bitmovin
#endif
        case "System": return .system
        case "Subtitle": return .subtitle
        default: return nil
        }
    }

#if os(iOS)
    /**
     Utility method to compute a JS value from an `OfflineState` object.
     - Parameter offlineState `OfflineState` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(offlineState: OfflineState?) -> String {
        var notDownloaded = "NotDownloaded"
        guard let offlineState = offlineState else {
            return notDownloaded
        }

        switch offlineState {
        case .downloading: return "Downloading"
        case .downloaded: return "Downloaded"
        case .suspended: return "Suspended"
        default: return notDownloaded
        }
    }

    /**
     Utility method to compute a JS value from an `OfflineTextTrack` object.
     - Parameter offlineTrack `OfflineTextTrack` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(offlineTrack: OfflineTextTrack) -> [String: Any?] {
        return [
            "id": offlineTrack.label,
            "language": offlineTrack.language,
        ]
    }

    /**
     Utility method to compute a JS value from an `OfflineAudioTrack` object.
     - Parameter offlineTrack `OfflineAudioTrack` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(offlineTrack: OfflineAudioTrack) -> [String: Any?] {
        return [
            "id": offlineTrack.label,
            "language": offlineTrack.language,
        ]
    }

    /**
     Utility method to compute a JS value from an `OfflineTrackSelection` object.
     - Parameter offlineTracks `OfflineTrackSelection` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(offlineTracks: OfflineTrackSelection?) -> [String: Any?]? {
        guard let offlineTracks = offlineTracks else {
            return nil
        }

        return [
            "textOptions": offlineTracks.textTracks.compactMap { RCTConvert.toJson(offlineTrack: $0) },
            "audioOptions": offlineTracks.audioTracks.compactMap { RCTConvert.toJson(offlineTrack: $0) }
        ]
    }
#endif

    /**
     Utility method to instantiate a `AdaptationConfig` from a JS object.
     - Parameter json: JS object
     - Returns: The produced `AdaptationConfig` object
     */
    static func adaptationConfig(_ json: Any?) -> AdaptationConfig? {
        guard let json = json as? [String: Any?] else {
            return nil
        }
        let adaptationConfig = AdaptationConfig()
        if let maxSelectableBitrate = json["maxSelectableBitrate"] as? NSNumber {
            adaptationConfig.maxSelectableBitrate = maxSelectableBitrate.uintValue
        }

        return adaptationConfig
    }

    /**
     Utility method to compute a JS value from an `Thumbnail` object.
     - Parameter thumbnail `Thumbnail` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(thumbnail: Thumbnail?) -> [String: Any?]? {
        guard let thumbnail = thumbnail else {
            return nil
        }

        return [
            "start": thumbnail.start,
            "end": thumbnail.end,
            "text": thumbnail.text,
            "url": thumbnail.url.absoluteString,
            "x": thumbnail.x,
            "y": thumbnail.y,
            "width": thumbnail.width,
            "height": thumbnail.height,
        ]
    }

    /**
     Utility method to instantiate a `RemoteControlConfig` from a JS object.
     - Parameter json: JS object
     - Returns: The produced `RemoteControlConfig` object
     */
    static func remoteControlConfig(_ json: Any?) -> RemoteControlConfig? {
        guard let json = json as? [String: Any?] else {
            return nil
        }
        let remoteControlConfig = RemoteControlConfig()
        if let receiverStylesheetUrl = RCTConvert.nsurl(json["receiverStylesheetUrl"]) {
            remoteControlConfig.receiverStylesheetUrl = receiverStylesheetUrl
        }
        if let customReceiverConfig = json["customReceiverConfig"] as? [String: String] {
            remoteControlConfig.customReceiverConfig = customReceiverConfig
        }
        if let isCastEnabled = json["isCastEnabled"] as? Bool {
            remoteControlConfig.isCastEnabled = isCastEnabled
        }
        if let sendManifestRequestsWithCredentials = json["sendManifestRequestsWithCredentials"] as? Bool {
            remoteControlConfig.sendManifestRequestsWithCredentials = sendManifestRequestsWithCredentials
        }
        if let sendSegmentRequestsWithCredentials = json["sendSegmentRequestsWithCredentials"] as? Bool {
            remoteControlConfig.sendSegmentRequestsWithCredentials = sendSegmentRequestsWithCredentials
        }
        if let sendDrmLicenseRequestsWithCredentials = json["sendDrmLicenseRequestsWithCredentials"] as? Bool {
            remoteControlConfig.sendDrmLicenseRequestsWithCredentials = sendDrmLicenseRequestsWithCredentials
        }
        return remoteControlConfig
    }

    /**
     Utility method to instantiate a `BitmovinCastManagerOptions` from a JS object.
     - Parameter json: JS object
     - Returns: The produced `BitmovinCastManagerOptions` object
     */
    static func castManagerOptions(_ json: Any?) -> BitmovinCastManagerOptions? {
        guard let json = json as? [String: Any?] else {
            return nil
        }

        let options = BitmovinCastManagerOptions()
        options.applicationId = json["applicationId"] as? String
        options.messageNamespace = json["messageNamespace"] as? String
        return options
    }

    /**
     Utility method to compute a JS value from an `CastPayload` object.
     - Parameter castPayload `CastPayload` object to be converted.
     - Returns: The produced JS object.
     */
    static func toJson(castPayload: CastPayload) -> [String: Any?] {
        return [
            "currentTime": castPayload.currentTime,
            "deviceName": castPayload.deviceName,
            "type": castPayload.type,
        ]
    }

    static func sourceRemotePlaybackConfig(_ json: Any?) -> SourceRemotePlaybackConfig? {
        guard let json = json as? [String: Any?] else {
            return nil
        }

        let castSourceConfig = RCTConvert.sourceConfig(json["castSourceConfig"])
        if let castSourceConfigJson = json["castSourceConfig"] as? [String: Any?],
           let drmConfig = RCTConvert.drmConfig(castSourceConfigJson["drmConfig"]) {
            castSourceConfig?.drmConfig = drmConfig
        }
        return SourceRemotePlaybackConfig(
            castSourceConfig: castSourceConfig
        )
    }
}
