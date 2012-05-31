From: akpm@linux-foundation.org
Subject: [merged] backlight-ams369fg06-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:04 -0700
Message-ID: <20120531191904.4F8C1A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:51829 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933022Ab2EaTTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:19:06 -0400
Received: by lagr15 with SMTP id r15so75811lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ams369fg06: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-ams369fg06-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ams369fg06: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-devm_-functions drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-use-devm_-functions
+++ a/drivers/video/backlight/ams369fg06.c
@@ -482,7 +482,7 @@ static int __devinit ams369fg06_probe(st
 	struct backlight_device *bd = NULL;
 	struct backlight_properties props;
 
-	lcd = kzalloc(sizeof(struct ams369fg06), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct ams369fg06), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -492,7 +492,7 @@ static int __devinit ams369fg06_probe(st
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&spi->dev, "spi setup failed.\n");
-		goto out_free_lcd;
+		return ret;
 	}
 
 	lcd->spi = spi;
@@ -501,15 +501,13 @@ static int __devinit ams369fg06_probe(st
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL\n");
-		goto out_free_lcd;
+		return -EFAULT;
 	}
 
 	ld = lcd_device_register("ams369fg06", &spi->dev, lcd,
 		&ams369fg06_lcd_ops);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_lcd;
-	}
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
 
 	lcd->ld = ld;
 
@@ -547,8 +545,6 @@ static int __devinit ams369fg06_probe(st
 
 out_lcd_unregister:
 	lcd_device_unregister(ld);
-out_free_lcd:
-	kfree(lcd);
 	return ret;
 }
 
@@ -559,7 +555,6 @@ static int __devexit ams369fg06_remove(s
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
-	kfree(lcd);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

