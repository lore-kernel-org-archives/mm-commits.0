From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa-use-devm_lcd_device_register.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:23 -0800
Message-ID: <52e2b883.cRUXSzLPxzeFut8+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: [merged] backlight-tosa-use-devm_lcd_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:23 -0800


The patch titled
     Subject: backlight: tosa: use devm_lcd_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-tosa-use-devm_lcd_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tosa: use devm_lcd_device_register()

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_lcd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/tosa_lcd.c~backlight-tosa-use-devm_lcd_device_register drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-tosa-use-devm_lcd_device_register
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -206,8 +206,8 @@ static int tosa_lcd_probe(struct spi_dev
 
 	tosa_lcd_tg_on(data);
 
-	data->lcd = lcd_device_register("tosa-lcd", &spi->dev, data,
-			&tosa_lcd_ops);
+	data->lcd = devm_lcd_device_register(&spi->dev, "tosa-lcd", &spi->dev,
+					data, &tosa_lcd_ops);
 
 	if (IS_ERR(data->lcd)) {
 		ret = PTR_ERR(data->lcd);
@@ -226,8 +226,6 @@ static int tosa_lcd_remove(struct spi_de
 {
 	struct tosa_lcd_data *data = spi_get_drvdata(spi);
 
-	lcd_device_unregister(data->lcd);
