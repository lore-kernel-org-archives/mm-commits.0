From: akpm@linux-foundation.org
Subject: [merged] backlight-lms283gf05-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:14 -0800
Message-ID: <20130222204114.965825A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:60103 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3BVUlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:15 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so103871ghb.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lms283gf05: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-lms283gf05-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

