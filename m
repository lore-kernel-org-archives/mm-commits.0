From: akpm@linux-foundation.org
Subject: [merged] backlight-ld9040-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:12 -0700
Message-ID: <20120531191912.4156FA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46438 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab2EaTTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:13 -0400
Received: by mail-we0-f202.google.com with SMTP id e53so75955wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, dh09.lee@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ld9040: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-ld9040-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ld9040: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Donghwa Lee <dh09.lee@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040-use-devm_-functions drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040-use-devm_-functions
+++ a/drivers/video/backlight/ld9040.c
@@ -707,7 +707,7 @@ static int ld9040_probe(struct spi_devic
 	struct backlight_device *bd = NULL;
 	struct backlight_properties props;
 
-	lcd = kzalloc(sizeof(struct ld9040), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct ld9040), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -717,7 +717,7 @@ static int ld9040_probe(struct spi_devic
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&spi->dev, "spi setup failed.\n");
-		goto out_free_lcd;
+		return ret;
 	}
 
 	lcd->spi = spi;
@@ -726,7 +726,7 @@ static int ld9040_probe(struct spi_devic
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
-		goto out_free_lcd;
+		return -EFAULT;
 	}
 
 	mutex_init(&lcd->lock);
@@ -734,13 +734,13 @@ static int ld9040_probe(struct spi_devic
 	ret = regulator_bulk_get(lcd->dev, ARRAY_SIZE(supplies), supplies);
 	if (ret) {
 		dev_err(lcd->dev, "Failed to get regulators: %d\n", ret);
-		goto out_free_lcd;
+		return ret;
 	}
 
 	ld = lcd_device_register("ld9040", &spi->dev, lcd, &ld9040_lcd_ops);
 	if (IS_ERR(ld)) {
 		ret = PTR_ERR(ld);
-		goto out_free_lcd;
+		goto out_free_regulator;
 	}
 
 	lcd->ld = ld;
@@ -782,10 +782,9 @@ static int ld9040_probe(struct spi_devic
 
 out_unregister_lcd:
 	lcd_device_unregister(lcd->ld);
-out_free_lcd:
+out_free_regulator:
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 
-	kfree(lcd);
 	return ret;
 }
 
@@ -797,7 +796,6 @@ static int __devexit ld9040_remove(struc
 	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
 	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
-	kfree(lcd);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

