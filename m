From: akpm@linux-foundation.org
Subject: [merged] backlight-l4f00242t03-use-spi_get_drvdata-and-spi_set_drvdata.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:59 -0800
Message-ID: <20130222204059.A36F331C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:58542 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab3BVUlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:00 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so104251qeb.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: l4f00242t03: use spi_get_drvdata and spi_set_drvdata
has been removed from the -mm tree.  Its filename was
     backlight-l4f00242t03-use-spi_get_drvdata-and-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: l4f00242t03: use spi_get_drvdata and spi_set_drvdata

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-use-spi_get_drvdata-and-spi_set_drvdata drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-use-spi_get_drvdata-and-spi_set_drvdata
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -49,7 +49,7 @@ static void l4f00242t03_reset(unsigned i
 static void l4f00242t03_lcd_init(struct spi_device *spi)
 {
 	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
-	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 	const u16 cmd[] = { 0x36, param(0), 0x3A, param(0x60) };
 
 	dev_dbg(&spi->dev, "initializing LCD\n");
@@ -70,7 +70,7 @@ static void l4f00242t03_lcd_init(struct 
 static void l4f00242t03_lcd_powerdown(struct spi_device *spi)
 {
 	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
-	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "Powering down LCD\n");
 
@@ -168,7 +168,7 @@ static int l4f00242t03_probe(struct spi_
 		return -ENOMEM;
 	}
 
-	dev_set_drvdata(&spi->dev, priv);
+	spi_set_drvdata(spi, priv);
 	spi->bits_per_word = 9;
 	spi_setup(spi);
 
@@ -231,12 +231,12 @@ err1:
 
 static int l4f00242t03_remove(struct spi_device *spi)
 {
-	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(priv->ld);
 
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 
 	regulator_put(priv->io_reg);
 	regulator_put(priv->core_reg);
@@ -246,7 +246,7 @@ static int l4f00242t03_remove(struct spi
 
 static void l4f00242t03_shutdown(struct spi_device *spi)
 {
-	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 
 	if (priv)
 		l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

