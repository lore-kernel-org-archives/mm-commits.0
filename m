From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-ld9040c-small-fixes.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:18 -0700
Message-ID: <201107260751.p6Q7pL0d002941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab1GZHwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, dh09.lee@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/ld9040.c: small fixes
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ld9040c-small-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/ld9040.c: small fixes
From: Axel Lin <axel.lin@gmail.com>

- Fix checking of wrong return value for backlight_device_register()

- Properly free allocated resources in ld9040_probe() error path and
  ld9040_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Donghwa Lee <dh09.lee@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~drivers-video-backlight-ld9040c-small-fixes drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~drivers-video-backlight-ld9040c-small-fixes
+++ a/drivers/video/backlight/ld9040.c
@@ -701,9 +701,9 @@ static int ld9040_probe(struct spi_devic
 
 	bd = backlight_device_register("ld9040-bl", &spi->dev,
 		lcd, &ld9040_backlight_ops, NULL);
-	if (IS_ERR(ld)) {
-		ret = PTR_ERR(ld);
-		goto out_free_lcd;
+	if (IS_ERR(bd)) {
+		ret = PTR_ERR(bd);
+		goto out_unregister_lcd;
 	}
 
 	bd->props.max_brightness = MAX_BRIGHTNESS;
@@ -731,6 +731,8 @@ static int ld9040_probe(struct spi_devic
 	dev_info(&spi->dev, "ld9040 panel driver has been probed.\n");
 	return 0;
 
+out_unregister_lcd:
+	lcd_device_unregister(lcd->ld);
 out_free_lcd:
 	kfree(lcd);
 	return ret;
@@ -741,6 +743,7 @@ static int __devexit ld9040_remove(struc
 	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
 
 	ld9040_power(lcd, FB_BLANK_POWERDOWN);
+	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
 	kfree(lcd);
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch
drivers-video-backlight-aat2870_blc-fix-setting-max_current.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch

