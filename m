From: akpm@linux-foundation.org
Subject: [merged] backlight-convert-platform_lcd-to-devm_kzalloc.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:04 -0800
Message-ID: <20120111213005.24A8D5C0066@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38500 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab2AKVaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:06 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44287eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, FlorianSchandinat@gmx.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: convert platform_lcd to devm_kzalloc()
has been removed from the -mm tree.  Its filename was
     backlight-convert-platform_lcd-to-devm_kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: backlight: convert platform_lcd to devm_kzalloc()

Saves some error handling code and eliminates a class of leaks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-convert-platform_lcd-to-devm_kzalloc drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-convert-platform_lcd-to-devm_kzalloc
+++ a/drivers/video/backlight/platform_lcd.c
@@ -85,7 +85,8 @@ static int __devinit platform_lcd_probe(
 		return -EINVAL;
 	}
 
-	plcd = kzalloc(sizeof(struct platform_lcd), GFP_KERNEL);
+	plcd = devm_kzalloc(&pdev->dev, sizeof(struct platform_lcd),
+			    GFP_KERNEL);
 	if (!plcd) {
 		dev_err(dev, "no memory for state\n");
 		return -ENOMEM;
@@ -98,7 +99,7 @@ static int __devinit platform_lcd_probe(
 	if (IS_ERR(plcd->lcd)) {
 		dev_err(dev, "cannot register lcd device\n");
 		err = PTR_ERR(plcd->lcd);
-		goto err_mem;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, plcd);
@@ -106,8 +107,7 @@ static int __devinit platform_lcd_probe(
 
 	return 0;
 
- err_mem:
-	kfree(plcd);
+ err:
 	return err;
 }
 
@@ -116,7 +116,6 @@ static int __devexit platform_lcd_remove
 	struct platform_lcd *plcd = platform_get_drvdata(pdev);
 
 	lcd_device_unregister(plcd->lcd);
-	kfree(plcd);
 
 	return 0;
 }
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch

