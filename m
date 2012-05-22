From: akpm@linux-foundation.org
Subject: + backlight-initialize-struct-backlight_properties-properly.patch added to -mm tree
Date: Tue, 22 May 2012 13:59:36 -0700
Message-ID: <20120522205936.C5501A0241@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:37076 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab2EVU7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 May 2012 16:59:39 -0400
Received: by faaa25 with SMTP id a25so385650faa.1
        for <mm-commits@vger.kernel.org>; Tue, 22 May 2012 13:59:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corentin.chary@gmail.com, airlied@gmail.com, jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: initialize struct backlight_properties properly
has been added to the -mm tree.  Its filename is
     backlight-initialize-struct-backlight_properties-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Corentin Chary <corentin.chary@gmail.com>
Subject: backlight: initialize struct backlight_properties properly

In all these files, the .power field was never correctly initialized.

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_panel.c              |    1 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 drivers/platform/x86/toshiba_acpi.c             |    1 +
 drivers/video/backlight/da903x_bl.c             |    1 +
 drivers/video/backlight/pcf50633-backlight.c    |    1 +
 drivers/video/backlight/wm831x_bl.c             |    1 +
 drivers/video/omap2/displays/panel-acx565akm.c  |    1 +
 7 files changed, 7 insertions(+)

diff -puN drivers/gpu/drm/i915/intel_panel.c~backlight-initialize-struct-backlight_properties-properly drivers/gpu/drm/i915/intel_panel.c
--- a/drivers/gpu/drm/i915/intel_panel.c~backlight-initialize-struct-backlight_properties-properly
+++ a/drivers/gpu/drm/i915/intel_panel.c
@@ -368,6 +368,7 @@ int intel_panel_setup_backlight(struct d
 	else
 		return -ENODEV;
 
+	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = intel_panel_get_max_backlight(dev);
 	dev_priv->backlight =
diff -puN drivers/gpu/drm/radeon/radeon_legacy_encoders.c~backlight-initialize-struct-backlight_properties-properly drivers/gpu/drm/radeon/radeon_legacy_encoders.c
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c~backlight-initialize-struct-backlight_properties-properly
+++ a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -369,6 +369,7 @@ void radeon_legacy_backlight_init(struct
 		goto error;
 	}
 
+	memset(&props, 0, sizeof(props));
 	props.max_brightness = MAX_RADEON_LEVEL;
 	props.type = BACKLIGHT_RAW;
 	bd = backlight_device_register("radeon_bl", &drm_connector->kdev,
diff -puN drivers/platform/x86/toshiba_acpi.c~backlight-initialize-struct-backlight_properties-properly drivers/platform/x86/toshiba_acpi.c
--- a/drivers/platform/x86/toshiba_acpi.c~backlight-initialize-struct-backlight_properties-properly
+++ a/drivers/platform/x86/toshiba_acpi.c
@@ -1095,6 +1095,7 @@ static int __devinit toshiba_acpi_setup_
 	ret = get_tr_backlight_status(dev, &enabled);
 	dev->tr_backlight_supported = !ret;
 
+	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 
diff -puN drivers/video/backlight/da903x_bl.c~backlight-initialize-struct-backlight_properties-properly drivers/video/backlight/da903x_bl.c
--- a/drivers/video/backlight/da903x_bl.c~backlight-initialize-struct-backlight_properties-properly
+++ a/drivers/video/backlight/da903x_bl.c
@@ -136,6 +136,7 @@ static int da903x_backlight_probe(struct
 		da903x_write(data->da903x_dev, DA9034_WLED_CONTROL2,
 				DA9034_WLED_ISET(pdata->output_current));
 
+	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = max_brightness;
 	bl = backlight_device_register(pdev->name, data->da903x_dev, data,
diff -puN drivers/video/backlight/pcf50633-backlight.c~backlight-initialize-struct-backlight_properties-properly drivers/video/backlight/pcf50633-backlight.c
--- a/drivers/video/backlight/pcf50633-backlight.c~backlight-initialize-struct-backlight_properties-properly
+++ a/drivers/video/backlight/pcf50633-backlight.c
@@ -111,6 +111,7 @@ static int __devinit pcf50633_bl_probe(s
 	if (!pcf_bl)
 		return -ENOMEM;
 
+	memset(&bl_props, 0, sizeof(bl_props));
 	bl_props.type = BACKLIGHT_RAW;
 	bl_props.max_brightness = 0x3f;
 	bl_props.power = FB_BLANK_UNBLANK;
diff -puN drivers/video/backlight/wm831x_bl.c~backlight-initialize-struct-backlight_properties-properly drivers/video/backlight/wm831x_bl.c
--- a/drivers/video/backlight/wm831x_bl.c~backlight-initialize-struct-backlight_properties-properly
+++ a/drivers/video/backlight/wm831x_bl.c
@@ -194,6 +194,7 @@ static int wm831x_backlight_probe(struct
 	data->current_brightness = 0;
 	data->isink_reg = isink_reg;
 
+	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = max_isel;
 	bl = backlight_device_register("wm831x", &pdev->dev, data,
diff -puN drivers/video/omap2/displays/panel-acx565akm.c~backlight-initialize-struct-backlight_properties-properly drivers/video/omap2/displays/panel-acx565akm.c
--- a/drivers/video/omap2/displays/panel-acx565akm.c~backlight-initialize-struct-backlight_properties-properly
+++ a/drivers/video/omap2/displays/panel-acx565akm.c
@@ -532,6 +532,7 @@ static int acx_panel_probe(struct omap_d
 
 	/*------- Backlight control --------*/
 
+	memset(&props, 0, sizeof(props));
 	props.fb_blank = FB_BLANK_UNBLANK;
 	props.power = FB_BLANK_UNBLANK;
 	props.type = BACKLIGHT_RAW;
_
Subject: Subject: backlight: initialize struct backlight_properties properly

Patches currently in -mm which might be from corentin.chary@gmail.com are

backlight-initialize-struct-backlight_properties-properly.patch

