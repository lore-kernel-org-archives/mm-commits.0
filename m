From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-ld9040c-use-devm_regulator_bulk_get-api.patch added to -mm tree
Date: Tue, 08 Jan 2013 12:40:31 -0800
Message-ID: <20130108204032.0AA4682004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:38028 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3AHUkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 15:40:33 -0500
Received: by mail-yh0-f74.google.com with SMTP id w68so125500yhw.5
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 12:40:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, dh09.lee@samsung.com


The patch titled
     Subject: drivers/video/backlight/ld9040.c: use devm_regulator_bulk_get() API
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-ld9040c-use-devm_regulator_bulk_get-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-video-backlight-ld9040c-use-devm_regulator_bulk_get-api.patch
drivers-rtc-use-of_match_ptr-macro.patch

