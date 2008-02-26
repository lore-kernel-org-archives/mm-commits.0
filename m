From: akpm@linux-foundation.org
Subject: + sm501fb-fix-timing-limits.patch added to -mm tree
Date: Tue, 26 Feb 2008 11:15:16 -0800
Message-ID: <200802261916.m1QJG8Lc004176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761811AbYBZTQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Feb 2008 14:16:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, ben-linux@fluff.org


The patch titled
     sm501fb: fix timing limits
has been added to the -mm tree.  Its filename is
     sm501fb-fix-timing-limits.patch

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
Subject: sm501fb: fix timing limits
From: Ville Syrjala <syrjala@sci.fi>

Vertical sync height register can only hold 6 bits.  Fix the hsync start test
to use > instead of >=.  Also add a few clarifying comments.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/sm501fb.c~sm501fb-fix-timing-limits drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-fix-timing-limits
+++ a/drivers/video/sm501fb.c
@@ -237,12 +237,14 @@ static int sm501fb_check_var(struct fb_v
 
 	/* check we can fit these values into the registers */
 
-	if (var->hsync_len > 255 || var->vsync_len > 255)
+	if (var->hsync_len > 255 || var->vsync_len > 63)
 		return -EINVAL;
 
-	if ((var->xres + var->right_margin) >= 4096)
+	/* hdisplay end and hsync start */
+	if ((var->xres + var->right_margin) > 4096)
 		return -EINVAL;
 
+	/* vdisplay end and vsync start */
 	if ((var->yres + var->lower_margin) > 2048)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from syrjala@sci.fi are

sm501fb-direct-color-visual-does-not-work.patch
sm501fb-rgb-offsets-are-reversed-in-16bpp-modes.patch
sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch
sm501fb-fix-timing-limits.patch
sm501-remove-a-duplicated-table.patch
sm501-add-support-for-the-sm502-programmable-pll.patch
