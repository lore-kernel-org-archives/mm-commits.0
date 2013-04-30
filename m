From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-jornada720_c-use-dev_err-dev_info-instead-of-pr_err-pr_info.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:26 -0700
Message-ID: <20130430185126.7148E31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:54908 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3Sv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:27 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86263vbe.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/jornada720_*.c: use dev_err()/dev_info() instead of pr_err()/pr_info()
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-jornada720_c-use-dev_err-dev_info-instead-of-pr_err-pr_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/jornada720_*.c: use dev_err()/dev_info() instead of pr_err()/pr_info()

dev_err()/dev_info() are preferred to pr_err()/pr_info().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/jornada720_bl.c  |   18 +++++++++---------
 drivers/video/backlight/jornada720_lcd.c |   21 ++++++++++-----------
 2 files changed, 19 insertions(+), 20 deletions(-)

diff -puN drivers/video/backlight/jornada720_bl.c~drivers-video-backlight-jornada720_c-use-dev_err-dev_info-instead-of-pr_err-pr_info drivers/video/backlight/jornada720_bl.c
--- a/drivers/video/backlight/jornada720_bl.c~drivers-video-backlight-jornada720_c-use-dev_err-dev_info-instead-of-pr_err-pr_info
+++ a/drivers/video/backlight/jornada720_bl.c
@@ -9,8 +9,6 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/backlight.h>
 #include <linux/device.h>
 #include <linux/fb.h>
@@ -40,11 +38,13 @@ static int jornada_bl_get_brightness(str
 	ret = jornada_ssp_byte(GETBRIGHTNESS);
 
 	if (jornada_ssp_byte(GETBRIGHTNESS) != TXDUMMY) {
-		pr_err("get brightness timeout\n");
+		dev_err(&bd->dev, "get brightness timeout\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
-	} else /* exchange txdummy for value */
+	} else {
+		/* exchange txdummy for value */
 		ret = jornada_ssp_byte(TXDUMMY);
+	}
 
 	jornada_ssp_end();
 
@@ -61,7 +61,7 @@ static int jornada_bl_update_status(stru
 	if ((bd->props.power != FB_BLANK_UNBLANK) || (bd->props.fb_blank != FB_BLANK_UNBLANK)) {
 		ret = jornada_ssp_byte(BRIGHTNESSOFF);
 		if (ret != TXDUMMY) {
-			pr_info("brightness off timeout\n");
+			dev_info(&bd->dev, "brightness off timeout\n");
 			/* turn off backlight */
 			PPSR &= ~PPC_LDD1;
 			PPDR |= PPC_LDD1;
@@ -72,7 +72,7 @@ static int jornada_bl_update_status(stru
 
 		/* send command to our mcu */
 		if (jornada_ssp_byte(SETBRIGHTNESS) != TXDUMMY) {
-			pr_info("failed to set brightness\n");
+			dev_info(&bd->dev, "failed to set brightness\n");
 			ret = -ETIMEDOUT;
 			goto out;
 		}
@@ -86,7 +86,7 @@ static int jornada_bl_update_status(stru
 		 */
 		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness)
 			!= TXDUMMY) {
-			pr_err("set brightness failed\n");
+			dev_err(&bd->dev, "set brightness failed\n");
 			ret = -ETIMEDOUT;
 		}
 
@@ -120,7 +120,7 @@ static int jornada_bl_probe(struct platf
 
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
-		pr_err("failed to register device, err=%x\n", ret);
+		dev_err(&pdev->dev, "failed to register device, err=%x\n", ret);
 		return ret;
 	}
 
@@ -134,7 +134,7 @@ static int jornada_bl_probe(struct platf
 	jornada_bl_update_status(bd);
 
 	platform_set_drvdata(pdev, bd);
-	pr_info("HP Jornada 700 series backlight driver\n");
+	dev_info(&pdev->dev, "HP Jornada 700 series backlight driver\n");
 
 	return 0;
 }
diff -puN drivers/video/backlight/jornada720_lcd.c~drivers-video-backlight-jornada720_c-use-dev_err-dev_info-instead-of-pr_err-pr_info drivers/video/backlight/jornada720_lcd.c
--- a/drivers/video/backlight/jornada720_lcd.c~drivers-video-backlight-jornada720_c-use-dev_err-dev_info-instead-of-pr_err-pr_info
+++ a/drivers/video/backlight/jornada720_lcd.c
@@ -9,8 +9,6 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/device.h>
 #include <linux/fb.h>
 #include <linux/kernel.h>
@@ -27,7 +25,7 @@
 #define LCD_MAX_CONTRAST	0xff
 #define LCD_DEF_CONTRAST	0x80
 
-static int jornada_lcd_get_power(struct lcd_device *dev)
+static int jornada_lcd_get_power(struct lcd_device *ld)
 {
 	/* LDD2 in PPC = LCD POWER */
 	if (PPSR & PPC_LDD2)
@@ -36,17 +34,17 @@ static int jornada_lcd_get_power(struct
 		return FB_BLANK_POWERDOWN;	/* PW OFF */
 }
 
-static int jornada_lcd_get_contrast(struct lcd_device *dev)
+static int jornada_lcd_get_contrast(struct lcd_device *ld)
 {
 	int ret;
 
-	if (jornada_lcd_get_power(dev) != FB_BLANK_UNBLANK)
+	if (jornada_lcd_get_power(ld) != FB_BLANK_UNBLANK)
 		return 0;
 
 	jornada_ssp_start();
 
 	if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY) {
-		pr_err("get contrast failed\n");
+		dev_err(&ld->dev, "get contrast failed\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	} else {
@@ -56,7 +54,7 @@ static int jornada_lcd_get_contrast(stru
 	}
 }
 
-static int jornada_lcd_set_contrast(struct lcd_device *dev, int value)
+static int jornada_lcd_set_contrast(struct lcd_device *ld, int value)
 {
 	int ret;
 
@@ -67,7 +65,7 @@ static int jornada_lcd_set_contrast(stru
 
 	/* push the new value */
 	if (jornada_ssp_byte(value) != TXDUMMY) {
-		pr_err("set contrast failed\n");
+		dev_err(&ld->dev, "set contrast failed\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	}
@@ -78,13 +76,14 @@ static int jornada_lcd_set_contrast(stru
 	return 0;
 }
 
-static int jornada_lcd_set_power(struct lcd_device *dev, int power)
+static int jornada_lcd_set_power(struct lcd_device *ld, int power)
 {
 	if (power != FB_BLANK_UNBLANK) {
 		PPSR &= ~PPC_LDD2;
 		PPDR |= PPC_LDD2;
-	} else
+	} else {
 		PPSR |= PPC_LDD2;
+	}
 
 	return 0;
 }
@@ -105,7 +104,7 @@ static int jornada_lcd_probe(struct plat
 
 	if (IS_ERR(lcd_device)) {
 		ret = PTR_ERR(lcd_device);
-		pr_err("failed to register device\n");
+		dev_err(&pdev->dev, "failed to register device\n");
 		return ret;
 	}
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

