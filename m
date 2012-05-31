From: akpm@linux-foundation.org
Subject: [merged] backlight-ltv350qv-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:16 -0700
Message-ID: <20120531191916.54685A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63242 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab2EaTTR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:17 -0400
Received: by yhgm50 with SMTP id m50so146999yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, hskinnemoen@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ltv350qv: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-ltv350qv-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ltv350qv: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ltv350qv.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff -puN drivers/video/backlight/ltv350qv.c~backlight-ltv350qv-use-devm_-functions drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~backlight-ltv350qv-use-devm_-functions
+++ a/drivers/video/backlight/ltv350qv.c
@@ -232,23 +232,20 @@ static int __devinit ltv350qv_probe(stru
 	struct lcd_device *ld;
 	int ret;
 
-	lcd = kzalloc(sizeof(struct ltv350qv), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct ltv350qv), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
 	lcd->spi = spi;
 	lcd->power = FB_BLANK_POWERDOWN;
-	lcd->buffer = kzalloc(8, GFP_KERNEL);
-	if (!lcd->buffer) {
-		ret = -ENOMEM;
-		goto out_free_lcd;
-	}
+	lcd->buffer = devm_kzalloc(&spi->dev, 8, GFP_KERNEL);
+	if (!lcd->buffer)
+		return -ENOMEM;
 
 	ld = lcd_device_register("ltv350qv", &spi->dev, lcd, &ltv_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_buffer;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
+
 	lcd->ld = ld;
 
 	ret = ltv350qv_power(lcd, FB_BLANK_UNBLANK);
@@ -261,10 +258,6 @@ static int __devinit ltv350qv_probe(stru
 
 out_unregister:
 	lcd_device_unregister(ld);
-out_free_buffer:
-	kfree(lcd->buffer);
-out_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -274,8 +267,6 @@ static int __devexit ltv350qv_remove(str
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->ld);
-	kfree(lcd->buffer);
-	kfree(lcd);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

