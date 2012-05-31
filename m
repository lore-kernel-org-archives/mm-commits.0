From: akpm@linux-foundation.org
Subject: [merged] backlight-initialize-struct-backlight_properties-properly.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:58 -0700
Message-ID: <20120531191858.5DC2BA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53340 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab2EaTS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:59 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so134798ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corentin.chary@gmail.com, airlied@gmail.com, jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: initialize struct backlight_properties properly
has been removed from the -mm tree.  Its filename was
     backlight-initialize-struct-backlight_properties-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

 drivers/platform/x86/toshiba_acpi.c            |    1 +
 drivers/video/backlight/da903x_bl.c            |    1 +
 drivers/video/backlight/pcf50633-backlight.c   |    1 +
 drivers/video/backlight/wm831x_bl.c            |    1 +
 drivers/video/omap2/displays/panel-acx565akm.c |    1 +
 5 files changed, 5 insertions(+)

diff -puN drivers/platform/x86/toshiba_acpi.c~backlight-initialize-struct-backlight_properties-properly drivers/platform/x86/toshiba_acpi.c
--- a/drivers/platform/x86/toshiba_acpi.c~backlight-initialize-struct-backlight_properties-properly
+++ a/drivers/platform/x86/toshiba_acpi.c
@@ -1104,6 +1104,7 @@ static int __devinit toshiba_acpi_add(st
 
 	mutex_init(&dev->mutex);
 
+	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 	dev->backlight_dev = backlight_device_register("toshiba",
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

Patches currently in -mm which might be from corentin.chary@gmail.com are

origin.patch

