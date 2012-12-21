From: akpm@linux-foundation.org
Subject: + backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata.patch added to -mm tree
Date: Fri, 21 Dec 2012 14:54:32 -0800
Message-ID: <20121221225433.1628582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36237 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LUWye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 17:54:34 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so562678qaq.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 14:54:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: ams369fg06: use spi_get_drvdata and spi_set_drvdata
has been added to the -mm tree.  Its filename is
     backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata.patch

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
Subject: backlight: ams369fg06: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/ams369fg06.c
@@ -513,7 +513,7 @@ static int ams369fg06_probe(struct spi_d
 		lcd->power = FB_BLANK_UNBLANK;
 	}
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	dev_info(&spi->dev, "ams369fg06 panel driver has been probed.\n");
 
@@ -526,7 +526,7 @@ out_lcd_unregister:
 
 static int ams369fg06_remove(struct spi_device *spi)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(lcd->bd);
@@ -538,7 +538,7 @@ static int ams369fg06_remove(struct spi_
 #if defined(CONFIG_PM)
 static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
@@ -551,7 +551,7 @@ static int ams369fg06_suspend(struct spi
 
 static int ams369fg06_resume(struct spi_device *spi)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
@@ -564,7 +564,7 @@ static int ams369fg06_resume(struct spi_
 
 static void ams369fg06_shutdown(struct spi_device *spi)
 {
-	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
+	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
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

