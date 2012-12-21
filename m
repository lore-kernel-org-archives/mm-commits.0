From: akpm@linux-foundation.org
Subject: + backlight-lms283gf05-use-spi_get_drvdata-and-spi_set_drvdata.patch added to -mm tree
Date: Fri, 21 Dec 2012 14:54:30 -0800
Message-ID: <20121221225431.1F32B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36557 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LUWyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 17:54:32 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so530713vcd.3
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 14:54:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: lms283gf05: use spi_get_drvdata and spi_set_drvdata
has been added to the -mm tree.  Its filename is
     backlight-lms283gf05-use-spi_get_drvdata-and-spi_set_drvdata.patch

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
Subject: backlight: lms283gf05: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/lms283gf05.c
@@ -180,7 +180,7 @@ static int lms283gf05_probe(struct spi_d
 	st->spi = spi;
 	st->ld = ld;
 
-	dev_set_drvdata(&spi->dev, st);
+	spi_set_drvdata(spi, st);
 
 	/* kick in the LCD */
 	if (pdata)
@@ -192,7 +192,7 @@ static int lms283gf05_probe(struct spi_d
 
 static int lms283gf05_remove(struct spi_device *spi)
 {
-	struct lms283gf05_state *st = dev_get_drvdata(&spi->dev);
+	struct lms283gf05_state *st = spi_get_drvdata(spi);
 
 	lcd_device_unregister(st->ld);
 
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

