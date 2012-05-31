From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa_lcd-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:25 -0700
Message-ID: <20120531191925.5B469A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63242 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab2EaTT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:26 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so146999yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, dbaryshkov@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tosa_lcd: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-tosa_lcd-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tosa_lcd: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_lcd.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/tosa_lcd.c~backlight-tosa_lcd-use-devm_-functions drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-tosa_lcd-use-devm_-functions
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -174,7 +174,8 @@ static int __devinit tosa_lcd_probe(stru
 	int ret;
 	struct tosa_lcd_data *data;
 
-	data = kzalloc(sizeof(struct tosa_lcd_data), GFP_KERNEL);
+	data = devm_kzalloc(&spi->dev, sizeof(struct tosa_lcd_data),
+				GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -187,7 +188,7 @@ static int __devinit tosa_lcd_probe(stru
 
 	ret = spi_setup(spi);
 	if (ret < 0)
-		goto err_spi;
+		return ret;
 
 	data->spi = spi;
 	dev_set_drvdata(&spi->dev, data);
@@ -224,8 +225,6 @@ err_gpio_dir:
 	gpio_free(TOSA_GPIO_TG_ON);
 err_gpio_tg:
 	dev_set_drvdata(&spi->dev, NULL);
-err_spi:
-	kfree(data);
 	return ret;
 }
 
@@ -242,7 +241,6 @@ static int __devexit tosa_lcd_remove(str
 
 	gpio_free(TOSA_GPIO_TG_ON);
 	dev_set_drvdata(&spi->dev, NULL);
-	kfree(data);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

