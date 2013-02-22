From: akpm@linux-foundation.org
Subject: [merged] backlight-tdo24m-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:11 -0800
Message-ID: <20130222204111.9E8B631C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:58528 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804Ab3BVUlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:12 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so103784yen.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tdo24m: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-tdo24m-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tdo24m: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tdo24m.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/tdo24m.c~backlight-tdo24m-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/tdo24m.c
--- a/drivers/video/backlight/tdo24m.c~backlight-tdo24m-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/tdo24m.c
@@ -390,7 +390,7 @@ static int tdo24m_probe(struct spi_devic
 	if (IS_ERR(lcd->lcd_dev))
 		return PTR_ERR(lcd->lcd_dev);
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 	err = tdo24m_power(lcd, FB_BLANK_UNBLANK);
 	if (err)
 		goto out_unregister;
@@ -404,7 +404,7 @@ out_unregister:
 
 static int tdo24m_remove(struct spi_device *spi)
 {
-	struct tdo24m *lcd = dev_get_drvdata(&spi->dev);
+	struct tdo24m *lcd = spi_get_drvdata(spi);
 
 	tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->lcd_dev);
@@ -415,14 +415,14 @@ static int tdo24m_remove(struct spi_devi
 #ifdef CONFIG_PM
 static int tdo24m_suspend(struct spi_device *spi, pm_message_t state)
 {
-	struct tdo24m *lcd = dev_get_drvdata(&spi->dev);
+	struct tdo24m *lcd = spi_get_drvdata(spi);
 
 	return tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int tdo24m_resume(struct spi_device *spi)
 {
-	struct tdo24m *lcd = dev_get_drvdata(&spi->dev);
+	struct tdo24m *lcd = spi_get_drvdata(spi);
 
 	return tdo24m_power(lcd, FB_BLANK_UNBLANK);
 }
@@ -434,7 +434,7 @@ static int tdo24m_resume(struct spi_devi
 /* Power down all displays on reboot, poweroff or halt */
 static void tdo24m_shutdown(struct spi_device *spi)
 {
-	struct tdo24m *lcd = dev_get_drvdata(&spi->dev);
+	struct tdo24m *lcd = spi_get_drvdata(spi);
 
 	tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

