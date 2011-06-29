From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-ld9040c-small-fixes.patch added to -mm tree
Date: Wed, 29 Jun 2011 13:41:47 -0700
Message-ID: <201106292041.p5TKfl5L010542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757714Ab1F2UmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 16:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, dh09.lee@samsung.com, rpurdie@rpsys.net


The patch titled
     drivers/video/backlight/ld9040.c: small fixes
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-ld9040c-small-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
drivers-video-backlight-ld9040c-small-fixes.patch
drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch

