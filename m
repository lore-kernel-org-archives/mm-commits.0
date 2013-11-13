From: akpm@linux-foundation.org
Subject: [merged] backlight-hx8357-use-devm_lcd_device_register.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:41:30 -0800
Message-ID: <5283e3fa.Sps4uo1mlQXrNzBY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3KMUlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-hx8357-use-devm_lcd_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:30 -0800


The patch titled
     Subject: backlight: hx8357: use devm_lcd_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-hx8357-use-devm_lcd_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: hx8357: use devm_lcd_device_register()

Use devm_lcd_device_register() to make cleanup paths simpler, and remove
unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hx8357.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN drivers/video/backlight/hx8357.c~backlight-hx8357-use-devm_lcd_device_register drivers/video/backlight/hx8357.c
--- a/drivers/video/backlight/hx8357.c~backlight-hx8357-use-devm_lcd_device_register
+++ a/drivers/video/backlight/hx8357.c
@@ -648,7 +648,8 @@ static int hx8357_probe(struct spi_devic
 		lcd->use_im_pins = 0;
 	}
 
-	lcdev = lcd_device_register("mxsfb", &spi->dev, lcd, &hx8357_ops);
+	lcdev = devm_lcd_device_register(&spi->dev, "mxsfb", &spi->dev, lcd,
+					&hx8357_ops);
 	if (IS_ERR(lcdev)) {
 		ret = PTR_ERR(lcdev);
 		return ret;
@@ -660,29 +661,16 @@ static int hx8357_probe(struct spi_devic
 	ret = ((int (*)(struct lcd_device *))match->data)(lcdev);
 	if (ret) {
 		dev_err(&spi->dev, "Couldn't initialize panel\n");
-		goto init_error;
+		return ret;
 	}
 
 	dev_info(&spi->dev, "Panel probed\n");
 
 	return 0;
-
-init_error:
-	lcd_device_unregister(lcdev);
-	return ret;
-}
-
-static int hx8357_remove(struct spi_device *spi)
-{
-	struct lcd_device *lcdev = spi_get_drvdata(spi);
