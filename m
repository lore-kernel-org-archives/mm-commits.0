From: akpm@linux-foundation.org
Subject: [merged] backlight-ili9320-use-devm_lcd_device_register.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:41:34 -0800
Message-ID: <5283e3fe.gwpJpmOuMm1ljDdQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3KMUlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-ili9320-use-devm_lcd_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:34 -0800


The patch titled
     Subject: backlight: ili9320: use devm_lcd_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-ili9320-use-devm_lcd_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ili9320: use devm_lcd_device_register()

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/ili9320.c~backlight-ili9320-use-devm_lcd_device_register drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~backlight-ili9320-use-devm_lcd_device_register
+++ a/drivers/video/backlight/ili9320.c
@@ -235,7 +235,8 @@ int ili9320_probe_spi(struct spi_device
 
 	ili9320_setup_spi(ili, spi);
 
-	lcd = lcd_device_register("ili9320", dev, ili, &ili9320_ops);
+	lcd = devm_lcd_device_register(&spi->dev, "ili9320", dev, ili,
+					&ili9320_ops);
 	if (IS_ERR(lcd)) {
 		dev_err(dev, "failed to register lcd device\n");
 		return PTR_ERR(lcd);
@@ -248,24 +249,16 @@ int ili9320_probe_spi(struct spi_device
 	ret = ili9320_power(ili, FB_BLANK_UNBLANK);
 	if (ret != 0) {
 		dev_err(dev, "failed to set lcd power state\n");
-		goto err_unregister;
+		return ret;
 	}
 
 	return 0;
-
- err_unregister:
-	lcd_device_unregister(lcd);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(ili9320_probe_spi);
 
 int ili9320_remove(struct ili9320 *ili)
 {
 	ili9320_power(ili, FB_BLANK_POWERDOWN);
-
-	lcd_device_unregister(ili->lcd);
