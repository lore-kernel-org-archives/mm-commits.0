From: akpm@linux-foundation.org
Subject: [folded] backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:55:07 -0700
Message-ID: <201107252355.p6PNt7Y5006146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab1GYXzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, anish198519851985@gmail.com, inki.dae@samsung.com, jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module
has been removed from the -mm tree.  Its filename was
     backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch

This patch was dropped because it was folded into backlight-add-ams369fg06-amoled-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module
From: Axel Lin <axel.lin@gmail.com>

unregister backlight device when unloading the module

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: anish singh <anish198519851985@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module
+++ a/drivers/video/backlight/ams369fg06.c
@@ -553,6 +553,7 @@ static int __devexit ams369fg06_remove(s
 	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
 
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
+	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
 	kfree(lcd);
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
drivers-video-backlight-ld9040c-small-fixes.patch
drivers-video-backlight-adp8860_blc-remove-a-redundant-assignment-for-max_brightness.patch
backlight-add-ams369fg06-amoled-driver.patch
backlight-ams369fg06-staticize-ams369fg06_shutdown.patch
backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered.patch
drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch
drivers-leds-leds-netxbig-make-leds_netxbig-depend-on-leds_class.patch

