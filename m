From: akpm@linux-foundation.org
Subject: - fb-sm501-ensure-console-suspended-before-saving-state.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:20 -0800
Message-ID: <200802070029.m170T1HM007234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934039AbYBGAot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, adaplas@pol.net, vince@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     FB/SM501: ensure console suspended before saving state
has been removed from the -mm tree.  Its filename was
     fb-sm501-ensure-console-suspended-before-saving-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: FB/SM501: ensure console suspended before saving state
From: Ben Dooks <ben-linux@fluff.org>

Move the console suspend to before we save the state of
the framebuffer to ensure that it does not try and change
the fb state again once we have copied it out.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Vincent Sanders <vince@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/video/sm501fb.c~fb-sm501-ensure-console-suspended-before-saving-state drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~fb-sm501-ensure-console-suspended-before-saving-state
+++ a/drivers/video/sm501fb.c
@@ -1698,6 +1698,15 @@ static int sm501fb_suspend_fb(struct sm5
 	if (par->screen.size == 0)
 		return 0;
 
+	/* blank the relevant interface to ensure unit power minimised */
+	(par->ops.fb_blank)(FB_BLANK_POWERDOWN, fbi);
+
+	/* tell console/fb driver we are suspending */
+
+	acquire_console_sem();
+	fb_set_suspend(fbi, 1);
+	release_console_sem();
+
 	/* backup copies in case chip is powered down over suspend */
 
 	par->store_fb = vmalloc(par->screen.size);
@@ -1717,12 +1726,6 @@ static int sm501fb_suspend_fb(struct sm5
 
 	memcpy_fromio(par->store_fb, par->screen.k_addr, par->screen.size);
 	memcpy_fromio(par->store_cursor, par->cursor.k_addr, par->cursor.size);
-	/* blank the relevant interface to ensure unit power minimised */
-	(par->ops.fb_blank)(FB_BLANK_POWERDOWN, fbi);
-
-	acquire_console_sem();
-	fb_set_suspend(fbi, 1);
-	release_console_sem();
 
 	return 0;
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
git-mtd.patch
