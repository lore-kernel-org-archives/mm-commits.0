From: akpm@linux-foundation.org
Subject: - lcd-add-platform_lcd-driver-fb-fix-platform_lcd-match-entry.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:39:46 -0700
Message-ID: <200807232352.m6NNqNBA018783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601AbYGWXxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:53:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     FB: Fix platform_lcd match entry
has been removed from the -mm tree.  Its filename was
     lcd-add-platform_lcd-driver-fb-fix-platform_lcd-match-entry.patch

This patch was dropped because it was folded into lcd-add-platform_lcd-driver.patch

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

origin.patch
rtc-rtc-s3c-add-__devexit-and-__devinit-markers.patch
rtc-rtc-s3c-update-irq-handling.patch
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch
lcd-add-platform_lcd-driver-fb-fix-platform_lcd-match-entry.patch

