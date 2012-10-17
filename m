From: akpm@linux-foundation.org
Subject: + backlight-jornada720-fix-checkpatch-error-and-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:13:49 -0700
Message-ID: <20121017231350.3ABDC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:64186 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2JQXNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:13:50 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so1006486ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:13:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: jornada720: fix checkpatch error and warning
has been added to the -mm tree.  Its filename is
     backlight-jornada720-fix-checkpatch-error-and-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch
backlight-88pm860x_bl-fix-checkpatch-warning.patch
backlight-atmel-pwm-bl-fix-checkpatch-warning.patch
backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch
backlight-da903x_bl-fix-checkpatch-warning.patch
backlight-generic_bl-fix-checkpatch-warning.patch
backlight-hp680_bl-fix-checkpatch-error-and-warning.patch
backlight-ili9320-fix-checkpatch-error-and-warning.patch
backlight-jornada720-fix-checkpatch-error-and-warning.patch
backlight-l4f00242t03-fix-checkpatch-warning.patch
backlight-lm3630-fix-checkpatch-warning.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-omap1-fix-checkpatch-warning.patch
backlight-pcf50633-fix-checkpatch-warning.patch
backlight-platform_lcd-fix-checkpatch-error.patch
backlight-tdo24m-fix-checkpatch-warning.patch
backlight-tosa-fix-checkpatch-error-and-warning.patch
backlight-vgg2432a4-fix-checkpatch-warning.patch

