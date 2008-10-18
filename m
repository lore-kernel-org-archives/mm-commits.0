From: akpm@linux-foundation.org
Subject: - neofb-reduce-panning-function.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:16:13 -0700
Message-ID: <200810182316.m9INGDYR028769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbYJRXQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     neofb: reduce panning function
has been removed from the -mm tree.  Its filename was
     neofb-reduce-panning-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: neofb: reduce panning function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Reduce panning function by deleting checks done by higher layer and
folding remaining function into the called one.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |   35 +++++------------------------------
 1 file changed, 5 insertions(+), 30 deletions(-)

diff -puN drivers/video/neofb.c~neofb-reduce-panning-function drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-reduce-panning-function
+++ a/drivers/video/neofb.c
@@ -1186,8 +1186,11 @@ static int neofb_set_par(struct fb_info 
 	return 0;
 }
 
-static void neofb_update_start(struct fb_info *info,
-			       struct fb_var_screeninfo *var)
+/*
+ *    Pan or Wrap the Display
+ */
+static int neofb_pan_display(struct fb_var_screeninfo *var,
+			     struct fb_info *info)
 {
 	struct neofb_par *par = info->par;
 	struct vgastate *state = &par->state;
@@ -1216,35 +1219,7 @@ static void neofb_update_start(struct fb
 	vga_wgfx(state->vgabase, 0x0E, (((Base >> 16) & 0x0f) | (oldExtCRTDispAddr & 0xf0)));
 
 	neoLock(state);
-}
-
-/*
- *    Pan or Wrap the Display
- */
-static int neofb_pan_display(struct fb_var_screeninfo *var,
-			     struct fb_info *info)
-{
-	u_int y_bottom;
-
-	y_bottom = var->yoffset;
-
-	if (!(var->vmode & FB_VMODE_YWRAP))
-		y_bottom += var->yres;
-
-	if (var->xoffset > (var->xres_virtual - var->xres))
-		return -EINVAL;
-	if (y_bottom > info->var.yres_virtual)
-		return -EINVAL;
-
-	neofb_update_start(info, var);
