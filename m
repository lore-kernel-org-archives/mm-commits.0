From: akpm@linux-foundation.org
Subject: + backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata.patch added to -mm tree
Date: Fri, 21 Dec 2012 14:54:58 -0800
Message-ID: <20121221225459.1D6E9100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:35466 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2LUWzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 17:55:00 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so530613qch.4
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 14:54:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: corgi_lcd: use lcd_get_data instead of dev_get_drvdata
has been added to the -mm tree.  Its filename is
     backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata.patch

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
Subject: backlight: corgi_lcd: use lcd_get_data instead of dev_get_drvdata

Use the wrapper function for getting the driver data using lcd_device
instead of using dev_get_drvdata with &ld->dev, so we can directly pass a
struct lcd_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/corgi_lcd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -337,7 +337,7 @@ static void corgi_lcd_power_off(struct c
 
 static int corgi_lcd_set_mode(struct lcd_device *ld, struct fb_videomode *m)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&ld->dev);
+	struct corgi_lcd *lcd = lcd_get_data(ld);
 	int mode = CORGI_LCD_MODE_QVGA;
 
 	if (m->xres == 640 || m->xres == 480)
@@ -364,7 +364,7 @@ static int corgi_lcd_set_mode(struct lcd
 
 static int corgi_lcd_set_power(struct lcd_device *ld, int power)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&ld->dev);
+	struct corgi_lcd *lcd = lcd_get_data(ld);
 
 	if (POWER_IS_ON(power) && !POWER_IS_ON(lcd->power))
 		corgi_lcd_power_on(lcd);
@@ -378,7 +378,7 @@ static int corgi_lcd_set_power(struct lc
 
 static int corgi_lcd_get_power(struct lcd_device *ld)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&ld->dev);
+	struct corgi_lcd *lcd = lcd_get_data(ld);
 
 	return lcd->power;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
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

