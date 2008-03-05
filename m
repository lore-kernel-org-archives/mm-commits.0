From: akpm@linux-foundation.org
Subject: - sm501fb-fix-timing-limits.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:35 -0800
Message-ID: <200803050744.m257iZ9c021523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759506AbYCEHts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:49:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     sm501fb: fix timing limits
has been removed from the -mm tree.  Its filename was
     sm501fb-fix-timing-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501fb: fix timing limits
From: Ville Syrjala <syrjala@sci.fi>

Vertical sync height register can only hold 6 bits.  Fix the hsync start test
to use > instead of >=.  Also add a few clarifying comments.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Acked-by: Ben Dooks <ben-linux@fluff.org>
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


