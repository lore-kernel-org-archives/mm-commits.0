From: akpm@linux-foundation.org
Subject: + pwm_backlight-add-device-tree-support-for-low-threshold-brightness.patch added to -mm tree
Date: Thu, 27 Sep 2012 14:33:19 -0700
Message-ID: <20120927213320.37FA01E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35402 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab2I0VdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Sep 2012 17:33:21 -0400
Received: by ggnq2 with SMTP id q2so283394ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 27 Sep 2012 14:33:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avinashphilip@ti.com, FlorianSchandinat@gmx.de, grant.likely@secretlab.ca, rpurdie@rpsys.net, thierry.reding@avionic-design.de


The patch titled
     Subject: pwm_backlight: add device tree support for Low Threshold Brightness
has been added to the -mm tree.  Its filename is
     pwm_backlight-add-device-tree-support-for-low-threshold-brightness.patch

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
Subject: pwm_backlight: add device tree support for Low Threshold Brightness

Some backlights perform poorly when driven by a PWM with a short
duty-cycle.  For such devices, the low threshold can be used to specify a
lower bound for the duty-cycle and should be chosen to exclude the
problematic range.

Add device tree probing support for
platform_pwm_backlight_data,lth_brightness, putting
low-threshold-brightness as the optional property's name.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt |   10 ++++++++++
 drivers/video/backlight/pwm_bl.c                                    |    5 +++++
 2 files changed, 15 insertions(+)

diff -puN Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt~pwm_backlight-add-device-tree-support-for-low-threshold-brightness Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt~pwm_backlight-add-device-tree-support-for-low-threshold-brightness
+++ a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -14,6 +14,15 @@ Required properties:
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
+  - low-threshold-brightness: brightness threshold low level. Low threshold
+    brightness set to value so that backlight present on low end of
+    brightness.
+    Some panels, backlight would absent if duty percentage of PWM wave is less
+    than certain level (say 20%). By setting low-threshold-brightness to a
+    value above (percentage of brightness-levels max) 50 (20% of 255, if 255
+    is max). On setting low-threshold-brightness, range of brightness-levels
+    is calculated in a region of low-threshold-brightness to brightness-levels
+    max.
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
@@ -25,4 +34,5 @@ Example:
 
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
+		low-threshold-brightness = <50>;
 	};
diff -puN drivers/video/backlight/pwm_bl.c~pwm_backlight-add-device-tree-support-for-low-threshold-brightness drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~pwm_backlight-add-device-tree-support-for-low-threshold-brightness
+++ a/drivers/video/backlight/pwm_bl.c
@@ -143,6 +143,11 @@ static int pwm_backlight_parse_dt(struct
 
 		data->dft_brightness = value;
 		data->max_brightness--;
+
+		ret = of_property_read_u32(node, "low-threshold-brightness",
+					   &value);
+		if (!ret)
+			data->lth_brightness = value;
 	}
 
 	/*
_

Patches currently in -mm which might be from avinashphilip@ti.com are

linux-next.patch
pwm_backlight-add-device-tree-support-for-low-threshold-brightness.patch
pwm_backlight-add-device-tree-support-for-low-threshold-brightness-fix.patch

