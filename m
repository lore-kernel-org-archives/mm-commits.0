From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-ld9040c-use-devm_regulator_bulk_get-api.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:59 -0800
Message-ID: <20130222204159.A49235A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:53298 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:00 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so103861vch.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, dh09.lee@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/ld9040.c: use devm_regulator_bulk_get() API
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ld9040c-use-devm_regulator_bulk_get-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/backlight/ld9040.c: use devm_regulator_bulk_get() API

devm_regulator_bulk_get is device managed and saves some cleanup
and exit code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~drivers-video-backlight-ld9040c-use-devm_regulator_bulk_get-api drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~drivers-video-backlight-ld9040c-use-devm_regulator_bulk_get-api
+++ a/drivers/video/backlight/ld9040.c
@@ -710,17 +710,15 @@ static int ld9040_probe(struct spi_devic
 
 	mutex_init(&lcd->lock);
 
-	ret = regulator_bulk_get(lcd->dev, ARRAY_SIZE(supplies), supplies);
+	ret = devm_regulator_bulk_get(lcd->dev, ARRAY_SIZE(supplies), supplies);
 	if (ret) {
 		dev_err(lcd->dev, "Failed to get regulators: %d\n", ret);
 		return ret;
 	}
 
 	ld = lcd_device_register("ld9040", &spi->dev, lcd, &ld9040_lcd_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_regulator;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
 
 	lcd->ld = ld;
 
@@ -762,8 +760,6 @@ static int ld9040_probe(struct spi_devic
 
 out_unregister_lcd:
 	lcd_device_unregister(lcd->ld);
-out_free_regulator:
-	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 
 	return ret;
 }
@@ -775,7 +771,6 @@ static int ld9040_remove(struct spi_devi
 	ld9040_power(lcd, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
-	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 
 	return 0;
 }
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch

