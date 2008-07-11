From: akpm@linux-foundation.org
Subject: + lcd-add-platform_lcd-driver-fb-fix-platform_lcd-match-entry.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:42:31 -0700
Message-ID: <200807111848.m6BImCDr031147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbYGKStA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, rpurdie@rpsys.net


The patch titled
     FB: Fix platform_lcd match entry
has been added to the -mm tree.  Its filename is
     lcd-add-platform_lcd-driver-fb-fix-platform_lcd-match-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: FB: Fix platform_lcd match entry
From: Ben Dooks <ben-linux@fluff.org>

The platform_lcd driver was matching against the framebuffer device entry, and
not the framebuffer's parent device.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/platform_lcd.c~lcd-add-platform_lcd-driver-fb-fix-platform_lcd-match-entry drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~lcd-add-platform_lcd-driver-fb-fix-platform_lcd-match-entry
+++ a/drivers/video/backlight/platform_lcd.c
@@ -62,7 +62,7 @@ static int platform_lcd_match(struct lcd
 	if (pdata->match_fb)
 		return pdata->match_fb(pdata, info);
 
-	return plcd->us->parent == info->dev;
+	return plcd->us->parent == info->device;
 }
 
 static struct lcd_ops platform_lcd_ops = {
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch
parport-fix-platform-driver-hotplug-coldplug.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
fb-add-support-for-the-ili9320-video-display-controller-fix.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch
lcd-add-platform_lcd-driver-fix.patch
lcd-add-platform_lcd-driver-fb-fix-platform_lcd-match-entry.patch

