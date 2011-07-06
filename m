From: akpm@linux-foundation.org
Subject: + backlight-ams369fg06-staticize-ams369fg06_shutdown.patch added to -mm tree
Date: Wed, 06 Jul 2011 14:01:59 -0700
Message-ID: <201107062101.p66L1x0D031344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756284Ab1GFVCm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 17:02:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, anish198519851985@gmail.com, inki.dae@samsung.com, jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     backlight: ams369fg06: Staticize ams369fg06_shutdown
has been added to the -mm tree.  Its filename is
     backlight-ams369fg06-staticize-ams369fg06_shutdown.patch

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
Subject: backlight: ams369fg06: Staticize ams369fg06_shutdown
From: Axel Lin <axel.lin@gmail.com>

It's only used in ams369fg06.c, no need for it to be in the global namespace.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: anish singh <anish198519851985@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-staticize-ams369fg06_shutdown drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-staticize-ams369fg06_shutdown
+++ a/drivers/video/backlight/ams369fg06.c
@@ -605,7 +605,7 @@ static int ams369fg06_resume(struct spi_
 #define ams369fg06_resume	NULL
 #endif
 
-void ams369fg06_shutdown(struct spi_device *spi)
+static void ams369fg06_shutdown(struct spi_device *spi)
 {
 	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered.patch
linux-next.patch
drivers-video-backlight-ld9040c-small-fixes.patch
backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch
backlight-ams369fg06-staticize-ams369fg06_shutdown.patch
drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch

