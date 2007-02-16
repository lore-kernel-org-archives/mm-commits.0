From: akpm@linux-foundation.org
Subject: + ps3fb-atomic-fixes.patch added to -mm tree
Date: Fri, 16 Feb 2007 13:41:05 -0800
Message-ID: <200702162141.l1GLf5eu010529@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37309 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbXBPVl2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 16:41:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com


The patch titled
     ps3fb: atomic fixes
has been added to the -mm tree.  Its filename is
     ps3fb-atomic-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ps3fb-thread-updates.patch
ps3fb-thread-updates-update.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3fb-atomic-fixes.patch
ps3av-misc-updates.patch
