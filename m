From: akpm@linux-foundation.org
Subject: [merged] backlight-jornada720-fix-checkpatch-error-and-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:19 -0800
Message-ID: <20121218200419.D3BE1100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:64736 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:21 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so125654yhr.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: jornada720: fix checkpatch error and warning
has been removed from the -mm tree.  Its filename was
     backlight-jornada720-fix-checkpatch-error-and-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: jornada720: fix checkpatch error and warning

This patch fixes the checkpatch error and warning as below:

WARNING: line over 80 characters
ERROR: return is not a function, parentheses are not required

Also, long comments are fixed for the preferred style.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/jornada720_bl.c  |   34 ++++++++++++---------
 drivers/video/backlight/jornada720_lcd.c |    3 +
 2 files changed, 23 insertions(+), 14 deletions(-)

diff -puN drivers/video/backlight/jornada720_bl.c~backlight-jornada720-fix-checkpatch-error-and-warning drivers/video/backlight/jornada720_bl.c
--- a/drivers/video/backlight/jornada720_bl.c~backlight-jornada720-fix-checkpatch-error-and-warning
+++ a/drivers/video/backlight/jornada720_bl.c
@@ -48,7 +48,7 @@ static int jornada_bl_get_brightness(str
 
 	jornada_ssp_end();
 
-	return (BL_MAX_BRIGHT - ret);
+	return BL_MAX_BRIGHT - ret;
 }
 
 static int jornada_bl_update_status(struct backlight_device *bd)
@@ -58,7 +58,8 @@ static int jornada_bl_update_status(stru
 	jornada_ssp_start();
 
 	/* If backlight is off then really turn it off */
-	if ((bd->props.power != FB_BLANK_UNBLANK) || (bd->props.fb_blank != FB_BLANK_UNBLANK)) {
+	if ((bd->props.power != FB_BLANK_UNBLANK) ||
+		(bd->props.fb_blank != FB_BLANK_UNBLANK)) {
 		ret = jornada_ssp_byte(BRIGHTNESSOFF);
 		if (ret != TXDUMMY) {
 			pr_info("brightness off timeout\n");
@@ -77,18 +78,23 @@ static int jornada_bl_update_status(stru
 			goto out;
 		}
 
-		/* at this point we expect that the mcu has accepted
-		   our command and is waiting for our new value
-		   please note that maximum brightness is 255,
-		   but due to physical layout it is equal to 0, so we simply
-		   invert the value (MAX VALUE - NEW VALUE). */
-		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness) != TXDUMMY) {
+		/*
+		 * at this point we expect that the mcu has accepted
+		 * our command and is waiting for our new value
+		 * please note that maximum brightness is 255,
+		 * but due to physical layout it is equal to 0, so we simply
+		 * invert the value (MAX VALUE - NEW VALUE).
+		 */
+		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness)
+			!= TXDUMMY) {
 			pr_err("set brightness failed\n");
 			ret = -ETIMEDOUT;
 		}
 
-		/* If infact we get an TXDUMMY as output we are happy and dont
-		   make any further comments about it */
+		/*
+		 * If infact we get an TXDUMMY as output we are happy and dont
+		 * make any further comments about it
+		 */
 out:
 	jornada_ssp_end();
 
@@ -121,9 +127,11 @@ static int jornada_bl_probe(struct platf
 
 	bd->props.power = FB_BLANK_UNBLANK;
 	bd->props.brightness = BL_DEF_BRIGHT;
-	/* note. make sure max brightness is set otherwise
-	   you will get seemingly non-related errors when
-	   trying to change brightness */
+	/*
+	 * note. make sure max brightness is set otherwise
+	 * you will get seemingly non-related errors when
+	 * trying to change brightness
+	 */
 	jornada_bl_update_status(bd);
 
 	platform_set_drvdata(pdev, bd);
diff -puN drivers/video/backlight/jornada720_lcd.c~backlight-jornada720-fix-checkpatch-error-and-warning drivers/video/backlight/jornada720_lcd.c
--- a/drivers/video/backlight/jornada720_lcd.c~backlight-jornada720-fix-checkpatch-error-and-warning
+++ a/drivers/video/backlight/jornada720_lcd.c
@@ -101,7 +101,8 @@ static int jornada_lcd_probe(struct plat
 	struct lcd_device *lcd_device;
 	int ret;
 
-	lcd_device = lcd_device_register(S1D_DEVICENAME, &pdev->dev, NULL, &jornada_lcd_props);
+	lcd_device = lcd_device_register(S1D_DEVICENAME, &pdev->dev, NULL,
+					&jornada_lcd_props);
 
 	if (IS_ERR(lcd_device)) {
 		ret = PTR_ERR(lcd_device);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

