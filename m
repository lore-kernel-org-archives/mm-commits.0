From: akpm@linux-foundation.org
Subject: - ps3fb-atomic-fixes.patch removed from -mm tree
Date: Mon, 07 May 2007 00:00:14 -0700
Message-ID: <200705070700.l4770Ewa021002@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbXEGHAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 03:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, mm-commits@vger.kernel.org


The patch titled
     ps3fb: atomic fixes
has been removed from the -mm tree.  Its filename was
     ps3fb-atomic-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: atomic fixes
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Use atomic_dec_if_positive() instead of bogus
atomic_read()/atomic_dec() combinations

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-atomic-fixes drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-atomic-fixes
+++ a/drivers/video/ps3fb.c
@@ -680,13 +680,10 @@ EXPORT_SYMBOL_GPL(ps3fb_wait_for_vsync);
 
 void ps3fb_flip_ctl(int on)
 {
-	if (on) {
-		if (atomic_read(&ps3fb.ext_flip) > 0) {
-			atomic_dec(&ps3fb.ext_flip);
-		}
-	} else {
+	if (on)
+		atomic_dec_if_positive(&ps3fb.ext_flip);
+	else
 		atomic_inc(&ps3fb.ext_flip);
-	}
 }
 
 EXPORT_SYMBOL_GPL(ps3fb_flip_ctl);
@@ -786,8 +783,7 @@ static int ps3fb_ioctl(struct fb_info *i
 
 	case PS3FB_IOCTL_OFF:
 		DPRINTK("PS3FB_IOCTL_OFF:\n");
-		if (atomic_read(&ps3fb.ext_flip) > 0)
-			atomic_dec(&ps3fb.ext_flip);
+		atomic_dec_if_positive(&ps3fb.ext_flip);
 		retval = 0;
 		break;
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
