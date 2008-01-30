From: akpm@linux-foundation.org
Subject: + fb-sm501-ensure-console-suspended-before-saving-state.patch added to -mm tree
Date: Tue, 29 Jan 2008 17:46:01 -0800
Message-ID: <200801300145.m0U1jgQW014954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbYA3Bqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 20:46:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, adaplas@pol.net, vince@simtec.co.uk


The patch titled
     FB/SM501: ensure console suspended before saving state
has been added to the -mm tree.  Its filename is
     fb-sm501-ensure-console-suspended-before-saving-state.patch

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

git-alsa.patch
git-arm.patch
git-mtd.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
fb-sm501-ensure-console-suspended-before-saving-state.patch
fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver.patch
fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch
fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch
fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch
