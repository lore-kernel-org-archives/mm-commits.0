From: akpm@linux-foundation.org
Subject: + backlight-tosa-convert-tosa-to-dev_pm_ops.patch added to -mm tree
Date: Wed, 17 Apr 2013 13:41:31 -0700
Message-ID: <20130417204132.15CAC5AB47A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:48243 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965269Ab3DQUlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Apr 2013 16:41:35 -0400
Received: by mail-yh0-f74.google.com with SMTP id q10so206930yhf.5
        for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2013 13:41:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: tosa: convert tosa to dev_pm_ops
has been added to the -mm tree.  Its filename is
     backlight-tosa-convert-tosa-to-dev_pm_ops.patch

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
Subject: backlight: tosa: convert tosa to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_bl.c  |   18 ++++++++----------
 drivers/video/backlight/tosa_lcd.c |   18 ++++++++----------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff -puN drivers/video/backlight/tosa_bl.c~backlight-tosa-convert-tosa-to-dev_pm_ops drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-tosa-convert-tosa-to-dev_pm_ops
+++ a/drivers/video/backlight/tosa_bl.c
@@ -134,28 +134,27 @@ static int tosa_bl_remove(struct i2c_cli
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int tosa_bl_suspend(struct i2c_client *client, pm_message_t pm)
+#ifdef CONFIG_PM_SLEEP
+static int tosa_bl_suspend(struct device *dev)
 {
-	struct tosa_bl_data *data = i2c_get_clientdata(client);
+	struct tosa_bl_data *data = dev_get_drvdata(dev);
 
 	tosa_bl_set_backlight(data, 0);
 
 	return 0;
 }
 
-static int tosa_bl_resume(struct i2c_client *client)
+static int tosa_bl_resume(struct device *dev)
 {
-	struct tosa_bl_data *data = i2c_get_clientdata(client);
+	struct tosa_bl_data *data = dev_get_drvdata(dev);
 
 	backlight_update_status(data->bl);
 	return 0;
 }
-#else
-#define tosa_bl_suspend NULL
-#define tosa_bl_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(tosa_bl_pm_ops, tosa_bl_suspend, tosa_bl_resume);
+
 static const struct i2c_device_id tosa_bl_id[] = {
 	{ "tosa-bl", 0 },
 	{ },
@@ -165,11 +164,10 @@ static struct i2c_driver tosa_bl_driver
 	.driver = {
 		.name		= "tosa-bl",
 		.owner		= THIS_MODULE,
+		.pm		= &tosa_bl_pm_ops,
 	},
 	.probe		= tosa_bl_probe,
 	.remove		= tosa_bl_remove,
-	.suspend	= tosa_bl_suspend,
-	.resume		= tosa_bl_resume,
 	.id_table	= tosa_bl_id,
 };
 
diff -puN drivers/video/backlight/tosa_lcd.c~backlight-tosa-convert-tosa-to-dev_pm_ops drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-tosa-convert-tosa-to-dev_pm_ops
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -240,19 +240,19 @@ static int tosa_lcd_remove(struct spi_de
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int tosa_lcd_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int tosa_lcd_suspend(struct device *dev)
 {
-	struct tosa_lcd_data *data = spi_get_drvdata(spi);
+	struct tosa_lcd_data *data = dev_get_drvdata(dev);
 
 	tosa_lcd_tg_off(data);
 
 	return 0;
 }
 
-static int tosa_lcd_resume(struct spi_device *spi)
+static int tosa_lcd_resume(struct device *dev)
 {
-	struct tosa_lcd_data *data = spi_get_drvdata(spi);
+	struct tosa_lcd_data *data = dev_get_drvdata(dev);
 
 	tosa_lcd_tg_init(data);
 	if (POWER_IS_ON(data->lcd_power))
@@ -262,20 +262,18 @@ static int tosa_lcd_resume(struct spi_de
 
 	return 0;
 }
-#else
-#define tosa_lcd_suspend	NULL
-#define tosa_lcd_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(tosa_lcd_pm_ops, tosa_lcd_suspend, tosa_lcd_resume);
+
 static struct spi_driver tosa_lcd_driver = {
 	.driver = {
 		.name		= "tosa-lcd",
 		.owner		= THIS_MODULE,
+		.pm		= &tosa_lcd_pm_ops,
 	},
 	.probe		= tosa_lcd_probe,
 	.remove		= tosa_lcd_remove,
-	.suspend	= tosa_lcd_suspend,
-	.resume		= tosa_lcd_resume,
 };
 
 module_spi_driver(tosa_lcd_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
drivers-block-mg_diskc-add-config_pm_sleep-to-suspend-resume-functions.patch
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
backlight-adp8870-add-missing-braces.patch
drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable.patch
drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable-fix.patch
backlight-ld9040-convert-ld9040-to-dev_pm_ops.patch
backlight-lms501kf03-convert-lms501kf03-to-dev_pm_ops.patch
backlight-s6e63m0-convert-s6e63m0-to-dev_pm_ops.patch
backlight-adp5520-convert-adp5520_bl-to-dev_pm_ops.patch
backlight-adp8860-convert-adp8860-to-dev_pm_ops.patch
backlight-adp8870-convert-adp8870-to-dev_pm_ops.patch
backlight-corgi_lcd-convert-corgi_lcd-to-dev_pm_ops.patch
backlight-ep93xx-convert-ep93xx-to-dev_pm_ops.patch
backlight-hp680_bl-convert-hp680bl-to-dev_pm_ops.patch
backlight-kb3886_bl-convert-kb3886bl-to-dev_pm_ops.patch
backlight-lm3533_bl-convert-lm3533_bl-to-dev_pm_ops.patch
backlight-locomolcd-convert-locomolcd-to-dev_pm_ops.patch
backlight-ltv350qv-convert-ltv350qv-to-dev_pm_ops.patch
backlight-tdo24m-convert-tdo24m-to-dev_pm_ops.patch
drivers-video-backlight-kconfig-fix-typo-mach_sam9ek-three-times.patch
drivers-video-backlight-adp5520_blc-fix-compiler-warning-in-adp5520_show.patch
video-backlight-add-ili922x-lcd-driver.patch
backlight-da903x_bl-use-bl_core_suspendresume-option.patch
backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch
drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe.patch
drivers-video-backlight-adp8870_blc-fix-error-return-code-in-adp8870_led_probe.patch
drivers-video-backlight-as3711_blc-add-of-support.patch
backlight-ili9320-use-spi_set_drvdata.patch
backlight-ili922x-use-spi_set_drvdata.patch
drivers-video-backlight-platform_lcdc-introduce-probe-callback.patch
backlight-omap1-convert-omapbl-to-dev_pm_ops.patch
backlight-tosa-convert-tosa-to-dev_pm_ops.patch
backlight-vgg2432a4-convert-vgg2432a4_driver-to-dev_pm_ops.patch
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
rtc-rtc-s3c-convert-s3c_rtc-to-dev_pm_ops.patch
rtc-rtc-ds1307-use-dev_dbg-instead-of-pr_debug.patch
rtc-rtc-fm3130-use-dev_dbg-instead-of-pr_debug.patch
rtc-rtc-ab3100-use-devm_rtc_device_register.patch
rtc-rtc-au1xxx-use-devm_rtc_device_register.patch
rtc-rtc-bq32k-use-devm_rtc_device_register.patch
rtc-rtc-dm355evm-use-devm_rtc_device_register.patch
rtc-rtc-ds1302-use-devm_rtc_device_register.patch
rtc-rtc-ds1672-use-devm_rtc_device_register.patch
rtc-rtc-ds3234-use-devm_rtc_device_register.patch
rtc-rtc-efi-use-devm_rtc_device_register.patch
rtc-rtc-em3027-use-devm_rtc_device_register.patch
rtc-rtc-generic-use-devm_rtc_device_register.patch
rtc-hid-sensor-time-use-devm_rtc_device_register.patch
rtc-rtc-ls1x-use-devm_rtc_device_register.patch
rtc-rtc-m41t93-use-devm_rtc_device_register.patch
rtc-rtc-m41t94-use-devm_rtc_device_register.patch
rtc-rtc-m48t86-use-devm_rtc_device_register.patch
rtc-rtc-max6900-use-devm_rtc_device_register.patch
rtc-rtc-max6902-use-devm_rtc_device_register.patch
rtc-rtc-ps3-use-devm_rtc_device_register.patch
rtc-rtc-r9701-use-devm_rtc_device_register.patch
rtc-rtc-rc5t583-use-devm_rtc_device_register.patch
rtc-rtc-rs5c313-use-devm_rtc_device_register.patch
rtc-rtc-rv3029c2-use-devm_rtc_device_register.patch
rtc-rtc-rx4581-use-devm_rtc_device_register.patch
rtc-rtc-rx8581-use-devm_rtc_device_register.patch
rtc-rtc-starfire-use-devm_rtc_device_register.patch
rtc-rtc-sun4v-use-devm_rtc_device_register.patch
rtc-rtc-test-use-devm_rtc_device_register.patch
rtc-rtc-tile-use-devm_rtc_device_register.patch
rtc-rtc-wm8350-use-devm_rtc_device_register.patch
rtc-rtc-x1205-use-devm_rtc_device_register.patch
rtc-rtc-at91rm9200-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-mxc-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-pxa-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-rc5t583-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-sa1100-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-sh-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-wm8350-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-tps6586x-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-tps65910-switch-to-using-simple_dev_pm_ops.patch
rtc-rtc-tps80031-switch-to-using-simple_dev_pm_ops.patch
rtc-omap-update-to-devm_-api.patch
drivers-rtc-rtc-ds1374c-add-config_pm_sleep-to-suspend-resume-functions.patch
drivers-rtc-rtc-88pm80xc-add-config_pm_sleep-to-suspend-resume-functions.patch
drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch
drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8907c-remove-redundant-code.patch
rtc-rtc-rx4581-use-spi_set_drvdata.patch
rtc-rtc-m41t94-use-spi_set_drvdata.patch
rtc-rtc-r9701-use-spi_set_drvdata.patch
rtc-rtc-ds3234-use-spi_set_drvdata.patch
rtc-rtc-ds1390-use-spi_set_drvdata.patch
rtc-rtc-m41t93-use-spi_set_drvdata.patch
rtc-rtc-max6902-use-spi_set_drvdata.patch
drivers-rtc-rtc-s3cc-use-clk_prepare_enable-and-clk_disable_unprepare.patch
drivers-rtc-rtc-88pm860xc-use-devm_-apis.patch
drivers-rtc-rtc-at32ap700xc-use-devm_-apis.patch
drivers-rtc-rtc-ds1305c-use-devm_-apis.patch
drivers-rtc-rtc-ds1374c-use-devm_-apis.patch
drivers-rtc-rtc-ds3232c-use-devm_-apis.patch
drivers-rtc-rtc-m48t35c-use-devm_-apis.patch
drivers-rtc-rtc-max8925c-use-devm_-apis.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
rtc-rtc-ab8500-use-devm_-functions.patch
rtc-rtc-at91sam9-use-devm_-functions.patch
rtc-rtc-bfin-use-devm_-functions.patch
rtc-rtc-bq4802-use-devm_-functions.patch
rtc-rtc-ds1216-use-devm_-functions.patch
rtc-rtc-ds1286-use-devm_-functions.patch
rtc-rtc-ds1390-use-devm_-functions.patch
rtc-rtc-ds2404-use-devm_-functions.patch
rtc-rtc-fm3130-use-devm_-functions.patch
rtc-rtc-isl12022-use-devm_-functions.patch
rtc-rtc-m41t80-use-devm_-functions.patch
rtc-rtc-max8998-use-devm_-functions.patch
rtc-rtc-mc13xxx-use-devm_-functions.patch
rtc-rtc-msm6242-use-devm_-functions.patch
rtc-rtc-nuc900-use-devm_-functions.patch
rtc-rtc-pcap-use-devm_-functions.patch
rtc-rtc-pcf2123-use-devm_-functions.patch
rtc-rtc-pcf50633-use-devm_-functions.patch
rtc-rtc-pcf8563-use-devm_-functions.patch
rtc-rtc-pcf8583-use-devm_-functions.patch
rtc-rtc-rp5c01-use-devm_-functions.patch
rtc-rtc-rs5c348-use-devm_-functions.patch
rtc-rtc-rs5c372-use-devm_-functions.patch
rtc-rtc-s35390a-use-devm_-functions.patch
rtc-rtc-sa1100-use-devm_-functions.patch
rtc-rtc-stmp3xxx-use-devm_-functions.patch
rtc-rtc-v3020-use-devm_-functions.patch
memstick-r592-make-r592_pm_ops-static.patch

