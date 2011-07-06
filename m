From: akpm@linux-foundation.org
Subject: + backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch added to -mm tree
Date: Wed, 06 Jul 2011 13:52:07 -0700
Message-ID: <201107062052.p66Kq7SS030806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529Ab1GFUwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 16:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, anish198519851985@gmail.com, inki.dae@samsung.com, jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module
has been added to the -mm tree.  Its filename is
     backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch

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
linux-next.patch
drivers-video-backlight-ld9040c-small-fixes.patch
backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch
drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch

