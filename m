From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-pwm_blc-add-device-tree-support-for-low-threshold-brightness.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:16:28 -0700
Message-ID: <20120814231628.B29391E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:55152 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2HNXQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:16:30 -0400
Received: by obbwc20 with SMTP id wc20so735307obb.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:16:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avinashphilip@ti.com, FlorianSchandinat@gmx.de, broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca, rob.herring@calxeda.com


The patch titled
     Subject: drivers/video/backlight/pwm_bl.c: add device tree support for Low Threshold Brightness
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-pwm_blc-add-device-tree-support-for-low-threshold-brightness.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-video-backlight-pwm_blc-add-device-tree-support-for-low-threshold-brightness.patch

