From: akpm@linux-foundation.org
Subject: + backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata.patch added to -mm tree
Date: Fri, 21 Dec 2012 14:54:25 -0800
Message-ID: <20121221225426.1EAA6820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:38451 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LUWy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 17:54:26 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so219219ghb.4
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 14:54:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: ltv350qv: use spi_get_drvdata and spi_set_drvdata
has been added to the -mm tree.  Its filename is
     backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata.patch

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
Subject: backlight: ltv350qv: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ltv350qv.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/ltv350qv.c~backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/ltv350qv.c
@@ -252,7 +252,7 @@ static int ltv350qv_probe(struct spi_dev
 	if (ret)
 		goto out_unregister;
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	return 0;
 
@@ -263,7 +263,7 @@ out_unregister:
 
 static int ltv350qv_remove(struct spi_device *spi)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->ld);
@@ -274,14 +274,14 @@ static int ltv350qv_remove(struct spi_de
 #ifdef CONFIG_PM
 static int ltv350qv_suspend(struct spi_device *spi, pm_message_t state)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	return ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int ltv350qv_resume(struct spi_device *spi)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	return ltv350qv_power(lcd, FB_BLANK_UNBLANK);
 }
@@ -293,7 +293,7 @@ static int ltv350qv_resume(struct spi_de
 /* Power down all displays on reboot, poweroff or halt */
 static void ltv350qv_shutdown(struct spi_device *spi)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
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

