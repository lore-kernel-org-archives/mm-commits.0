From: akpm@linux-foundation.org
Subject: [withdrawn] backlight-check-null-deference-of-name-when-device-is-registered.patch removed from -mm tree
Date: Tue, 08 Jan 2013 12:43:47 -0800
Message-ID: <20130108204347.D4F2582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35257 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3AHUnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 15:43:49 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so126027vbi.3
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 12:43:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, devendra.aaru@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: check null deference of name when device is registered
has been removed from the -mm tree.  Its filename was
     backlight-check-null-deference-of-name-when-device-is-registered.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: check null deference of name when device is registered

Check for a NULL name when the device is registered.  If the name is null,
it will cause a kernel oops in dev_set_name().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Devendra Naga <devendra.aaru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    5 +++++
 drivers/video/backlight/lcd.c       |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN drivers/video/backlight/backlight.c~backlight-check-null-deference-of-name-when-device-is-registered drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-check-null-deference-of-name-when-device-is-registered
+++ a/drivers/video/backlight/backlight.c
@@ -292,6 +292,11 @@ struct backlight_device *backlight_devic
 	struct backlight_device *new_bd;
 	int rc;
 
+	if (name == NULL) {
+		pr_err("backlight name is null\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	pr_debug("backlight_device_register: name=%s\n", name);
 
 	new_bd = kzalloc(sizeof(struct backlight_device), GFP_KERNEL);
diff -puN drivers/video/backlight/lcd.c~backlight-check-null-deference-of-name-when-device-is-registered drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~backlight-check-null-deference-of-name-when-device-is-registered
+++ a/drivers/video/backlight/lcd.c
@@ -207,6 +207,11 @@ struct lcd_device *lcd_device_register(c
 	struct lcd_device *new_ld;
 	int rc;
 
+	if (name == NULL) {
+		pr_err("lcd name is null\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	pr_debug("lcd_device_register: name=%s\n", name);
 
 	new_ld = kzalloc(sizeof(struct lcd_device), GFP_KERNEL);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-ld9040-use-sleep-instead-of-delay.patch
backlight-ld9040-remove-unnecessary-null-deference-check.patch
backlight-ld9040-replace-efault-with-einval.patch
backlight-ld9040-remove-redundant-return-variables.patch
backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch
backlight-s6e63m0-use-lowercase-names-of-structs.patch
backlight-s6e63m0-use-sleep-instead-of-delay.patch
backlight-s6e63m0-remove-unnecessary-null-deference-check.patch
backlight-s6e63m0-replace-efault-with-einval.patch
backlight-s6e63m0-remove-redundant-variable-before_power.patch
backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch
backlight-ams369fg06-use-sleep-instead-of-delay.patch
backlight-ams369fg06-remove-unnecessary-null-deference-check.patch
backlight-ams369fg06-replace-efault-with-einval.patch
backlight-ams369fg06-remove-redundant-variable-before_power.patch
backlight-ams369fg06-reorder-inclusions-of-linux-xxxh.patch
backlight-l4f00242t03-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-ld9040-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-s6e63m0-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-tdo24m-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-lms283gf05-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-vgg2432a4-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-tosa-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-corgi_lcd-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-lms501kf03-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-aat2870-use-bl_get_data-instead-of-dev_get_drvdata.patch
pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-ams369fg06-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-corgi_lcd-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-tosa-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata.patch
backlight-lm3649_backlight-remove-ret-=-eio-at-error-paths-of-probe.patch
drivers-video-backlight-l4f00242t03c-convert-to-devm_regulator_get.patch

