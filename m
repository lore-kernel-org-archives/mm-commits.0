From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-video-backlight-pwm_blc-add-device-tree-support-for-low-threshold-brightness.patch removed from -mm tree
Date: Wed, 19 Sep 2012 12:13:36 -0700
Message-ID: <20120919191336.9DE5D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:48287 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2ISTNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 15:13:38 -0400
Received: by ghbz15 with SMTP id z15so183428ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 12:13:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avinashphilip@ti.com, FlorianSchandinat@gmx.de, broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca, rob.herring@calxeda.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/pwm_bl.c: add device tree support for Low Threshold Brightness
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-pwm_blc-add-device-tree-support-for-low-threshold-brightness.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Philip, Avinash" <avinashphilip@ti.com>
Subject: drivers/video/backlight/pwm_bl.c: add device tree support for Low Threshold Brightness

Low Threshold Brightness should be configured to have a linear relation in
brightness scale.  This patch adds device tree support for low threshold
brightness as optional one for pwm_backlight.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt |   21 ++++++++++
 drivers/video/backlight/pwm_bl.c                                    |    5 ++
 2 files changed, 26 insertions(+)

diff -puN Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt~drivers-video-backlight-pwm_blc-add-device-tree-support-for-low-threshold-brightness Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt~drivers-video-backlight-pwm_blc-add-device-tree-support-for-low-threshold-brightness
+++ a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,6 +14,8 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - low_threshold_brightness: brightness threshold low level. (get linear
+		 scales in brightness in low end of brightness levels)
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
@@ -26,3 +28,22 @@ Example:
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
 	};
+
+Example for brightness_threshold_level:
+
+	backlight {
+		compatible	= "pwm-backlight";
+		pwms = <&pwm 0 50000>;
+
+		brightness-levels = <0 4 8 16 32 64 128 255>;
+		default-brightness-level = <6>;
+		low_threshold_brightness = <50>;
+	};
+};
+Note:
+Low threshold support is required to have linear brightness scale from
+0 to max. For some panels, backlight absent on low end of brightness
+scale. So support for Low Threshold been required. So that the scale of
+brightness changed from Low Threshold to Max in scales defined in
+brightness-levels. In this example 20% maximum brightness scale should
+be required to turn on panel backlight.
diff -puN drivers/video/backlight/pwm_bl.c~drivers-video-backlight-pwm_blc-add-device-tree-support-for-low-threshold-brightness drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~drivers-video-backlight-pwm_blc-add-device-tree-support-for-low-threshold-brightness
+++ a/drivers/video/backlight/pwm_bl.c
@@ -143,6 +143,11 @@ static int pwm_backlight_parse_dt(struct
 
 		data->dft_brightness = value;
 		data->max_brightness--;
+
+		ret = of_property_read_u32(node, "low_threshold_brightness",
+					   &value);
+		if (!ret)
+			data->lth_brightness = value;
 	}
 
 	/*
_

Patches currently in -mm which might be from avinashphilip@ti.com are

linux-next.patch

