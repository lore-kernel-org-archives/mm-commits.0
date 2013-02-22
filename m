From: akpm@linux-foundation.org
Subject: [merged] backlight-vgg2432a4-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:20 -0800
Message-ID: <20130222204120.A0F7C31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40383 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3BVUlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:21 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so103814qcs.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: vgg2432a4: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-vgg2432a4-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: vgg2432a4: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/vgg2432a4.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/vgg2432a4.c~backlight-vgg2432a4-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/vgg2432a4.c
--- a/drivers/video/backlight/vgg2432a4.c~backlight-vgg2432a4-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/vgg2432a4.c
@@ -208,12 +208,11 @@ static int vgg2432a4_lcd_init(struct ili
 #ifdef CONFIG_PM
 static int vgg2432a4_suspend(struct spi_device *spi, pm_message_t state)
 {
-	return ili9320_suspend(dev_get_drvdata(&spi->dev), state);
+	return ili9320_suspend(spi_get_drvdata(spi), state);
 }
-
 static int vgg2432a4_resume(struct spi_device *spi)
 {
-	return ili9320_resume(dev_get_drvdata(&spi->dev));
+	return ili9320_resume(spi_get_drvdata(spi));
 }
 #else
 #define vgg2432a4_suspend	NULL
@@ -242,12 +241,12 @@ static int vgg2432a4_probe(struct spi_de
 
 static int vgg2432a4_remove(struct spi_device *spi)
 {
-	return ili9320_remove(dev_get_drvdata(&spi->dev));
+	return ili9320_remove(spi_get_drvdata(spi));
 }
 
 static void vgg2432a4_shutdown(struct spi_device *spi)
 {
-	ili9320_shutdown(dev_get_drvdata(&spi->dev));
+	ili9320_shutdown(spi_get_drvdata(spi));
 }
 
 static struct spi_driver vgg2432a4_driver = {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

