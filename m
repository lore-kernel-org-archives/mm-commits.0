From: akpm@linux-foundation.org
Subject: [merged] backlight-cr_bllcdc-fix-a-memory-leak.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:43 -0800
Message-ID: <201012232240.oBNMeVvQ015457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab0LWWkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, alanh@tungstengraphics.com, rpurdie@rpsys.net, thomas@tungstengraphics.com, mm-commits@vger.kernel.org


The patch titled
     backlight: cr_bllcd.c: fix a memory leak
has been removed from the -mm tree.  Its filename was
     backlight-cr_bllcdc-fix-a-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: cr_bllcd.c: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Cc: Alan Hourihane <alanh@tungstengraphics.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/cr_bllcd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/cr_bllcd.c~backlight-cr_bllcdc-fix-a-memory-leak drivers/video/backlight/cr_bllcd.c
--- a/drivers/video/backlight/cr_bllcd.c~backlight-cr_bllcdc-fix-a-memory-leak
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -242,6 +242,7 @@ static int cr_backlight_remove(struct pl
 	backlight_device_unregister(crp->cr_backlight_device);
 	lcd_device_unregister(crp->cr_lcd_device);
 	pci_dev_put(lpc_dev);
+	kfree(crp);
 
 	return 0;
 }
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
leds-leds-pca9532-cleanups.patch
drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
drivers-video-backlight-l4f00242t03c-prevent-unbalanced-calls-to-regulator-enable-disable.patch
drivers-rtc-rtc-omapc-fix-a-memory-leak.patch

