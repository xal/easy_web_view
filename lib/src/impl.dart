import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';

class EasyWebViewImpl {
  final String src;
  final num? width, height;
  final bool webAllowFullScreen;
  final bool convertToWidgets;
  final Map<String, String> headers;
  final bool widgetsTextSelectable;
  final void Function() onLoaded;
  final List<CrossWindowEvent> crossWindowEvents;
  final WebNavigationDelegate? webNavigationDelegate;

  const EasyWebViewImpl({
    Key? key,
    required this.src,
    required this.onLoaded,
    this.width,
    this.height,
    this.webAllowFullScreen = true,
    this.convertToWidgets = false,
    this.widgetsTextSelectable = false,
    this.headers = const {},
    this.crossWindowEvents = const [],
    this.webNavigationDelegate,
  });

  static String wrapHtml(String src) {
    if (EasyWebViewImpl.isValidHtml(src)) {
      return """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
$src
</body>
</html>
  """;
    }
    return src;
  }

  static bool isUrl(String src) =>
      src.startsWith('https://') || src.startsWith('http://');

  static bool isValidHtml(String src) =>
      src.contains('<html>') && src.contains('</html>');
}

class OptionalSizedChild extends StatelessWidget {
  final double? width, height;
  final Widget Function(double, double) builder;

  const OptionalSizedChild({
    required this.width,
    required this.height,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (width != null && height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: builder(width!, height!),
      );
    }
    return LayoutBuilder(
      builder: (context, dimens) {
        final w = width ?? dimens.maxWidth;
        final h = height ?? dimens.maxHeight;
        return SizedBox(
          width: w,
          height: h,
          child: builder(w, h),
        );
      },
    );
  }
}
