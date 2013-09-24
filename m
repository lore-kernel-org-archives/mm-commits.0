From: akpm@linux-foundation.org
Subject: + backlight-adp8870-use-devm_backlight_device_register.patch
 added to -mm tree
Date: Tue, 24 Sep 2013 16:12:07 -0700
Message-ID: <52421c47.sKSdaNnHboC7roaL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3IXXMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 19:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + backlight-adp8870-use-devm_backlight_device_register.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 16:12:07 -0700


The patch titled
     Subject: backlight: adp8870: use devm_backlight_device_register()
has been added to the -mm tree.  Its filename is
     backlight-adp8870-use-devm_backlight_device_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-adp8870-use-devm_backlight_device_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-adp8870-use-devm_backlight_device_register.patch

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
Subject: backlight: adp8870: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/adp8870_bl.c~backlight-adp8870-use-devm_backlight_device_register drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-adp8870-use-devm_backlight_device_register
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -888,8 +888,9 @@ static int adp8870_probe(struct i2c_clie
 	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = props.brightness = ADP8870_MAX_BRIGHTNESS;
-	bl = backlight_device_register(dev_driver_string(&client->dev),
-			&client->dev, data, &adp8870_bl_ops, &props);
+	bl = devm_backlight_device_register(&client->dev,
+				dev_driver_string(&client->dev),
+				&client->dev, data, &adp8870_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&client->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -902,7 +903,7 @@ static int adp8870_probe(struct i2c_clie
 			&adp8870_bl_attr_group);
 		if (ret) {
 			dev_err(&client->dev, "failed to register sysfs\n");
-			goto out1;
+			return ret;
 		}
 	}
 
@@ -925,8 +926,6 @@ out:
 	if (data->pdata->en_ambl_sens)
 		sysfs_remove_group(&data->bl->dev.kobj,
 			&adp8870_bl_attr_group);
-out1:
-	backlight_device_unregister(bl);
 
 	return ret;
 }
@@ -944,8 +943,6 @@ static int adp8870_remove(struct i2c_cli
 		sysfs_remove_group(&data->bl->dev.kobj,
 			&adp8870_bl_attr_group);
 
-	backlight_device_unregister(data->bl);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch
backlight-lp855x_bl-support-new-lp8555-device.patch
backlight-lm3630-apply-chip-revision.patch
backlight-ld9040-staticize-local-variable-gamma_table.patch
backlight-lm3639-dont-mix-different-enum-types.patch
backlight-lp8788-staticize-default_bl_config.patch
backlight-use-dev_get_platdata.patch
backlight-88pm860x_bl-use-devm_backlight_device_register.patch
backlight-aat2870-use-devm_backlight_device_register.patch
backlight-adp5520-use-devm_backlight_device_register.patch
backlight-adp8860-use-devm_backlight_device_register.patch
backlight-adp8870-use-devm_backlight_device_register.patch
backlight-as3711_bl-use-devm_backlight_device_register.patch
backlight-atmel-pwm-bl-use-devm_backlight_device_register.patch
backlight-bd6107-use-devm_backlight_device_register.patch
backlight-da903x_bl-use-devm_backlight_device_register.patch
backlight-da9052_bl-use-devm_backlight_device_register.patch
backlight-ep93xx-use-devm_backlight_device_register.patch
backlight-generic_bl-use-devm_backlight_device_register.patch
backlight-gpio_backlight-use-devm_backlight_device_register.patch
backlight-kb3886_bl-use-devm_backlight_device_register.patch
backlight-lm3533_bl-use-devm_backlight_device_register.patch
backlight-lp855x-use-devm_backlight_device_register.patch
backlight-lv5207lp-use-devm_backlight_device_register.patch
backlight-max8925_bl-use-devm_backlight_device_register.patch
backlight-pandora_bl-use-devm_backlight_device_register.patch
backlight-pcf50633-use-devm_backlight_device_register.patch
backlight-tps65217_bl-use-devm_backlight_device_register.patch
backlight-wm831x_bl-use-devm_backlight_device_register.patch
backlight-hx8357-use-devm_lcd_device_register.patch
backlight-ili922x-use-devm_lcd_device_register.patch
backlight-ili9320-use-devm_lcd_device_register.patch
backlight-lms283gf05-use-devm_lcd_device_register.patch
backlight-lms501kf03-use-devm_lcd_device_register.patch
backlight-ltv350qv-use-devm_lcd_device_register.patch
backlight-platform_lcd-use-devm_lcd_device_register.patch
backlight-tdo24m-use-devm_lcd_device_register.patch
backlight-ams369fg06-use-devm_backlightlcd_device_register.patch
backlight-ld9040-use-devm_backlightlcd_device_register.patch
backlight-corgi_lcd-use-devm_backlightlcd_device_register.patch
backlight-cr_bllcd-use-devm_backlightlcd_device_register.patch
backlight-s6e63m0-use-devm_backlightlcd_device_register.patch
drivers-rtc-rtc-ds1307c-release-irq-on-error.patch
drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
drivers-rtc-rtc-max6900c-remove-redundant-checks.patch
drivers-rtc-rtc-vt8500c-fix-return-value.patch
drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch
drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch
linux-next.patch

