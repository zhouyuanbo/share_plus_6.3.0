/// The Windows implementation of `share_plus`.
library share_plus_windows;

import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'package:share_plus/src/windows_version_helper.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

/// The fallback Windows implementation of [SharePlatform], for older Windows versions.
///
class SharePlusWindowsPlugin extends SharePlatform {
  /// If the modern Share UI i.e. `DataTransferManager` is not available, then use this Dart class instead of platform specific implementation.
  ///
  static void registerWith() {
    if (!VersionHelper.instance.isWindows10RS5OrGreater) {
      SharePlatform.instance = SharePlusWindowsPlugin();
    }
  }

  /// Share text.
  @override
  Future<void> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    final queryParameters = {
      if (subject != null) 'subject': subject,
      'body': text,
    };

    // see https://github.com/dart-lang/sdk/issues/43838#issuecomment-823551891
    final uri = Uri(
      scheme: 'mailto',
      query: queryParameters.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&'),
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Unable to share on windows');
    }
  }

  /// Share files.
  @override
  Future<void> shareFiles(
    List<String> paths, {
    List<String>? mimeTypes,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) {
    throw UnimplementedError(
      'shareFiles() is only available for Windows versions higher than 10.0.${VersionHelper.kWindows10RS5BuildNumber}.',
    );
  }

  /// Share [XFile] objects with Result.
  @override
  Future<ShareResult> shareXFiles(
    List<XFile> files, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) {
    throw UnimplementedError(
      'shareXFiles() is only available for Windows versions higher than 10.0.${VersionHelper.kWindows10RS5BuildNumber}.',
    );
  }
}
