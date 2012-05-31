From: akpm@linux-foundation.org
Subject: [merged] backlight-s6e63m0-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:18 -0700
Message-ID: <20120531191918.410F0A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45351 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab2EaTTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:19 -0400
Received: by yenl3 with SMTP id l3so138243yen.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, inki.dae@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: s6e63m0: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-s6e63m0-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: s6e63m0: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-use-devm_-functions drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-use-devm_-functions
+++ a/drivers/video/backlight/s6e63m0.c
@@ -741,7 +741,7 @@ static int __devinit s6e63m0_probe(struc
 	struct backlight_device *bd = NULL;
 	struct backlight_properties props;
 
-	lcd = kzalloc(sizeof(struct s6e63m0), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct s6e63m0), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -751,7 +751,7 @@ static int __devinit s6e63m0_probe(struc
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&spi->dev, "spi setup failed.\n");
-		goto out_free_lcd;
+		return ret;
 	}
 
 	lcd->spi = spi;
@@ -760,14 +760,12 @@ static int __devinit s6e63m0_probe(struc
 	lcd->lcd_pd = (struct lcd_platform_data *)spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
-		goto out_free_lcd;
+		return -EFAULT;
 	}
 
 	ld = lcd_device_register("s6e63m0", &spi->dev, lcd, &s6e63m0_lcd_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_lcd;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
 
 	lcd->ld = ld;
 
@@ -824,8 +822,6 @@ static int __devinit s6e63m0_probe(struc
 
 out_lcd_unregister:
 	lcd_device_unregister(ld);
-out_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -838,7 +834,6 @@ static int __devexit s6e63m0_remove(stru
 	device_remove_file(&spi->dev, &dev_attr_gamma_mode);
 	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
-	kfree(lcd);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

