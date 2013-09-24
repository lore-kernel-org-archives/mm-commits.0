From: akpm@linux-foundation.org
Subject: + backlight-corgi_lcd-use-devm_backlightlcd_device_register.patch added to -mm tree
Date: Tue, 24 Sep 2013 16:12:35 -0700
Message-ID: <52421c63.KjWcbkJN6rYYM0lD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab3IXXMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 19:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + backlight-corgi_lcd-use-devm_backlightlcd_device_register.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 16:12:35 -0700


The patch titled
     Subject: backlight: corgi_lcd: use devm_{backlight,lcd}_device_register()
has been added to the -mm tree.  Its filename is
     backlight-corgi_lcd-use-devm_backlightlcd_device_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-corgi_lcd-use-devm_backlightlcd_device_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-corgi_lcd-use-devm_backlightlcd_device_register.patch

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
Subject: backlight: corgi_lcd: use devm_{backlight,lcd}_device_register()

Use devm_backlight_device_register() and devm_lcd_device_register() to
make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |   28 ++++++++------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-devm_backlightlcd_device_register drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-devm_backlightlcd_device_register
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -550,8 +550,8 @@ static int corgi_lcd_probe(struct spi_de
 
 	lcd->spi_dev = spi;
 
-	lcd->lcd_dev = lcd_device_register("corgi_lcd", &spi->dev,
-					lcd, &corgi_lcd_ops);
+	lcd->lcd_dev = devm_lcd_device_register(&spi->dev, "corgi_lcd",
+						&spi->dev, lcd, &corgi_lcd_ops);
 	if (IS_ERR(lcd->lcd_dev))
 		return PTR_ERR(lcd->lcd_dev);
 
@@ -561,18 +561,18 @@ static int corgi_lcd_probe(struct spi_de
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = pdata->max_intensity;
-	lcd->bl_dev = backlight_device_register("corgi_bl", &spi->dev, lcd,
-						&corgi_bl_ops, &props);
-	if (IS_ERR(lcd->bl_dev)) {
-		ret = PTR_ERR(lcd->bl_dev);
-		goto err_unregister_lcd;
-	}
+	lcd->bl_dev = devm_backlight_device_register(&spi->dev, "corgi_bl",
+						&spi->dev, lcd, &corgi_bl_ops,
+						&props);
+	if (IS_ERR(lcd->bl_dev))
+		return PTR_ERR(lcd->bl_dev);
+
 	lcd->bl_dev->props.brightness = pdata->default_intensity;
 	lcd->bl_dev->props.power = FB_BLANK_UNBLANK;
 
 	ret = setup_gpio_backlight(lcd, pdata);
 	if (ret)
-		goto err_unregister_bl;
+		return ret;
 
 	lcd->kick_battery = pdata->kick_battery;
 
@@ -583,12 +583,6 @@ static int corgi_lcd_probe(struct spi_de
 	lcd->limit_mask = pdata->limit_mask;
 	the_corgi_lcd = lcd;
 	return 0;
-
-err_unregister_bl:
-	backlight_device_unregister(lcd->bl_dev);
-err_unregister_lcd:
-	lcd_device_unregister(lcd->lcd_dev);
-	return ret;
 }
 
 static int corgi_lcd_remove(struct spi_device *spi)
@@ -598,11 +592,7 @@ static int corgi_lcd_remove(struct spi_d
 	lcd->bl_dev->props.power = FB_BLANK_UNBLANK;
 	lcd->bl_dev->props.brightness = 0;
 	backlight_update_status(lcd->bl_dev);
-	backlight_device_unregister(lcd->bl_dev);
-
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_POWERDOWN);
-	lcd_device_unregister(lcd->lcd_dev);
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

