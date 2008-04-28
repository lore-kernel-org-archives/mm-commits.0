From: akpm@linux-foundation.org
Subject: - fbmem-fix-con2fbmap-limit-check.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:52 -0700
Message-ID: <200804282157.m3SLvq5k018434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934655AbYD1V6E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@p12n.org, adaplas@pol.net, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fbmem: fix con2fbmap limit check
has been removed from the -mm tree.  Its filename was
     fbmem-fix-con2fbmap-limit-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbmem: fix con2fbmap limit check
From: Peter Samuelson <peter@p12n.org>

Fix limit check in FBIOPUT_CON2FBMAP ioctl.

Signed-off-by: Peter Samuelson <peter@p12n.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fbmem.c~fbmem-fix-con2fbmap-limit-check drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbmem-fix-con2fbmap-limit-check
+++ a/drivers/video/fbmem.c
@@ -1057,7 +1057,7 @@ fb_ioctl(struct inode *inode, struct fil
 	case FBIOPUT_CON2FBMAP:
 		if (copy_from_user(&con2fb, argp, sizeof(con2fb)))
 			return - EFAULT;
-		if (con2fb.console < 0 || con2fb.console > MAX_NR_CONSOLES)
+		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
 		    return -EINVAL;
 		if (con2fb.framebuffer < 0 || con2fb.framebuffer >= FB_MAX)
 		    return -EINVAL;
_

Patches currently in -mm which might be from peter@p12n.org are

origin.patch

