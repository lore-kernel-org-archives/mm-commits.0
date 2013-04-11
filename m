From: akpm@linux-foundation.org
Subject: + rtc-rtc-rs5c372-use-devm_-functions.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:48:52 -0700
Message-ID: <20130411234852.C489B5A41BD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:58246 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3DKXsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:48:53 -0400
Received: by mail-vb0-f73.google.com with SMTP id q12so199307vbe.4
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:48:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-rs5c372: use devm_*() functions
has been added to the -mm tree.  Its filename is
     rtc-rtc-rs5c372-use-devm_-functions.patch

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
Subject: rtc: rtc-rs5c372: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c372.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-use-devm_-functions drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-use-devm_-functions
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -579,7 +579,9 @@ static int rs5c372_probe(struct i2c_clie
 		}
 	}
 
-	if (!(rs5c372 = kzalloc(sizeof(struct rs5c372), GFP_KERNEL))) {
+	rs5c372 = devm_kzalloc(&client->dev, sizeof(struct rs5c372),
+				GFP_KERNEL);
+	if (!rs5c372) {
 		err = -ENOMEM;
 		goto exit;
 	}
@@ -594,7 +596,7 @@ static int rs5c372_probe(struct i2c_clie
 
 	err = rs5c_get_regs(rs5c372);
 	if (err < 0)
-		goto exit_kfree;
+		goto exit;
 
 	/* clock may be set for am/pm or 24 hr time */
 	switch (rs5c372->type) {
@@ -617,7 +619,7 @@ static int rs5c372_probe(struct i2c_clie
 		break;
 	default:
 		dev_err(&client->dev, "unknown RTC type\n");
-		goto exit_kfree;
+		goto exit;
 	}
 
 	/* if the oscillator lost power and no other software (like
@@ -629,7 +631,7 @@ static int rs5c372_probe(struct i2c_clie
 	err = rs5c_oscillator_setup(rs5c372);
 	if (unlikely(err < 0)) {
 		dev_err(&client->dev, "setup error\n");
-		goto exit_kfree;
+		goto exit;
 	}
 
 	if (rs5c372_get_datetime(client, &tm) < 0)
@@ -648,38 +650,28 @@ static int rs5c372_probe(struct i2c_clie
 			);
 
 	/* REVISIT use client->irq to register alarm irq ... */
-
-	rs5c372->rtc = rtc_device_register(rs5c372_driver.driver.name,
-				&client->dev, &rs5c372_rtc_ops, THIS_MODULE);
+	rs5c372->rtc = devm_rtc_device_register(&client->dev,
+					rs5c372_driver.driver.name,
+					&rs5c372_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rs5c372->rtc)) {
 		err = PTR_ERR(rs5c372->rtc);
-		goto exit_kfree;
+		goto exit;
 	}
 
 	err = rs5c_sysfs_register(&client->dev);
 	if (err)
-		goto exit_devreg;
+		goto exit;
 
 	return 0;
 
-exit_devreg:
-	rtc_device_unregister(rs5c372->rtc);
-
-exit_kfree:
-	kfree(rs5c372);
-
 exit:
 	return err;
 }
 
 static int rs5c372_remove(struct i2c_client *client)
 {
-	struct rs5c372 *rs5c372 = i2c_get_clientdata(client);
-
-	rtc_device_unregister(rs5c372->rtc);
 	rs5c_sysfs_unregister(&client->dev);
-	kfree(rs5c372);
 	return 0;
 }
 
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

