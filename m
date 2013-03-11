From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-jornada720_c-use-dev_err-dev_info-instead-of-pr_err-pr_info.patch added to -mm tree
Date: Mon, 11 Mar 2013 15:00:52 -0700
Message-ID: <20130311220057.CD0C25A41EC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:62238 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3CKWA6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 18:00:58 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so237344qah.0
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 15:00:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: drivers/video/backlight/jornada720_*.c: use dev_err()/dev_info() instead of pr_err()/pr_info()
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-jornada720_c-use-dev_err-dev_info-instead-of-pr_err-pr_info.patch

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

linux-next.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
backlight-ep93xx_bl-remove-incorrect-__init-annotation.patch
drivers-video-backlight-atmel-pwm-blc-use-module_platform_driver_probe.patch
drivers-video-backlight-atmel-pwm-blc-add-__init-annotation.patch
drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe.patch
drivers-video-backlight-jornada720_c-use-dev_err-dev_info-instead-of-pr_err-pr_info.patch
drivers-video-backlight-omap1_blc-use-dev_info-instead-of-pr_info.patch
drivers-video-backlight-generic_blc-use-dev_info-instead-of-pr_info.patch
rtc-rtc-mv-add-__init-annotation.patch
rtc-rtc-davinci-add-__exit-annotation.patch
rtc-rtc-ds1302-add-__exit-annotation.patch
rtc-rtc-imxdi-add-__init-__exit-annotation.patch
rtc-rtc-nuc900-add-__init-__exit-annotation.patch
rtc-rtc-pcap-add-__init-__exit-annotation.patch
rtc-rtc-tegra-add-__init-__exit-annotation.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-max77686-use-module_platform_driver.patch
rtc-max77686-add-missing-module-author-name.patch
rtc-max77686-use-devm_kzalloc.patch
rtc-max77686-fix-indentation-of-bit-definitions.patch
rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch
rtc-rtc-ab3100-use-module_platform_driver_probe.patch
rtc-rtc-at32ap700x-use-module_platform_driver_probe.patch
rtc-rtc-at91rm9200-use-module_platform_driver_probe.patch
rtc-rtc-au1xxx-use-module_platform_driver_probe.patch
rtc-rtc-coh901331-use-module_platform_driver_probe.patch
rtc-rtc-davinci-use-module_platform_driver_probe.patch
rtc-rtc-ds1302-use-module_platform_driver_probe.patch
rtc-rtc-efi-use-module_platform_driver_probe.patch
rtc-rtc-generic-use-module_platform_driver_probe.patch
rtc-rtc-imxdi-use-module_platform_driver_probe.patch
rtc-rtc-mc13xxx-use-module_platform_driver_probe.patch
rtc-rtc-msm6242-use-module_platform_driver_probe.patch
rtc-rtc-mv-use-module_platform_driver_probe.patch
rtc-rtc-nuc900-use-module_platform_driver_probe.patch
rtc-rtc-omap-use-module_platform_driver_probe.patch
rtc-rtc-pcap-use-module_platform_driver_probe.patch
rtc-rtc-ps3-use-module_platform_driver_probe.patch
rtc-rtc-pxa-use-module_platform_driver_probe.patch
rtc-rtc-rp5c01-use-module_platform_driver_probe.patch
rtc-rtc-sh-use-module_platform_driver_probe.patch
rtc-rtc-starfire-use-module_platform_driver_probe.patch
rtc-rtc-sun4v-use-module_platform_driver_probe.patch
rtc-rtc-tegra-use-module_platform_driver_probe.patch
rtc-rtc-tx4939-use-module_platform_driver_probe.patch
rtc-rtc-88pm80x-use-devm_rtc_device_register.patch
rtc-rtc-coh90133-use-devm_rtc_device_register.patch
rtc-rtc-da9052-use-devm_rtc_device_register.patch
rtc-rtc-da9055-use-devm_rtc_device_register.patch
rtc-rtc-davinci-use-devm_rtc_device_register.patch
rtc-rtc-ds1511-use-devm_rtc_device_register.patch
rtc-rtc-ds1553-use-devm_rtc_device_register.patch
rtc-rtc-ds1742-use-devm_rtc_device_register.patch
rtc-rtc-ep93xx-use-devm_rtc_device_register.patch
rtc-rtc-imxdi-use-devm_rtc_device_register.patch
rtc-rtc-lp8788-use-devm_rtc_device_register.patch
rtc-rtc-lpc32xx-use-devm_rtc_device_register.patch
rtc-rtc-max77686-use-devm_rtc_device_register.patch
rtc-rtc-max8907-use-devm_rtc_device_register.patch
rtc-rtc-max8997-use-devm_rtc_device_register.patch
rtc-rtc-mv-use-devm_rtc_device_register.patch
rtc-rtc-mxc-use-devm_rtc_device_register.patch
rtc-rtc-palmas-use-devm_rtc_device_register.patch
rtc-rtc-pcf8523-use-devm_rtc_device_register.patch
rtc-rtc-s3c-use-devm_rtc_device_register.patch
rtc-rtc-snvs-use-devm_rtc_device_register.patch
rtc-rtc-spear-use-devm_rtc_device_register.patch
rtc-rtc-stk17ta8-use-devm_rtc_device_register.patch
rtc-rtc-tps6586x-use-devm_rtc_device_register.patch
rtc-rtc-tps65910-use-devm_rtc_device_register.patch
rtc-rtc-tps80031-use-devm_rtc_device_register.patch
rtc-rtc-tx4939-use-devm_rtc_device_register.patch
rtc-rtc-vt8500-use-devm_rtc_device_register.patch
rtc-rtc-wm831x-use-devm_rtc_device_register.patch
rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch
rtc-tegra-use-struct-dev_pm_ops-for-power-management.patch
rtc-tegra-set-irq-name-as-device-name.patch
rtc-tegra-use-managed-rtc_device_register.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

