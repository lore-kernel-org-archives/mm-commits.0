From: akpm@linux-foundation.org
Subject: [merged] backlight-ili922x-use-devm_lcd_device_register.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:41:32 -0800
Message-ID: <5283e3fc.MMK9D6fOPWXFvjZD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3KMUlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-ili922x-use-devm_lcd_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:32 -0800


The patch titled
     Subject: backlight: ili922x: use devm_lcd_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-ili922x-use-devm_lcd_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ili922x: use devm_lcd_device_register()

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili922x.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/ili922x.c~backlight-ili922x-use-devm_lcd_device_register drivers/video/backlight/ili922x.c
--- a/drivers/video/backlight/ili922x.c~backlight-ili922x-use-devm_lcd_device_register
+++ a/drivers/video/backlight/ili922x.c
@@ -513,8 +513,8 @@ static int ili922x_probe(struct spi_devi
 
 	ili->power = FB_BLANK_POWERDOWN;
 
-	lcd = lcd_device_register("ili922xlcd", &spi->dev, ili,
-				  &ili922x_ops);
+	lcd = devm_lcd_device_register(&spi->dev, "ili922xlcd", &spi->dev, ili,
+					&ili922x_ops);
 	if (IS_ERR(lcd)) {
 		dev_err(&spi->dev, "cannot register LCD\n");
 		return PTR_ERR(lcd);
@@ -530,10 +530,7 @@ static int ili922x_probe(struct spi_devi
 
 static int ili922x_remove(struct spi_device *spi)
 {
-	struct ili922x *ili = spi_get_drvdata(spi);
