From: akpm@linux-foundation.org
Subject: - i810-fix-sparse-warnings.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:55 -0800
Message-ID: <200901072219.n07MJtTI019193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763236AbZAGWgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:36:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@hanneseder.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     i810: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     i810-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i810: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warnings:

  drivers/video/i810/i810_accel.c:305:3: warning: returning void-valued expression
  drivers/video/i810/i810_accel.c:331:3: warning: returning void-valued expression
  drivers/video/i810/i810_accel.c:370:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/i810/i810_accel.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/video/i810/i810_accel.c~i810-fix-sparse-warnings drivers/video/i810/i810_accel.c
--- a/drivers/video/i810/i810_accel.c~i810-fix-sparse-warnings
+++ a/drivers/video/i810/i810_accel.c
@@ -301,8 +301,10 @@ void i810fb_fillrect(struct fb_info *inf
 	u32 dx, dy, width, height, dest, rop = 0, color = 0;
 
 	if (!info->var.accel_flags || par->dev_flags & LOCKUP ||
-	    par->depth == 4) 
-		return cfb_fillrect(info, rect);
+	    par->depth == 4) {
+		cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (par->depth == 1) 
 		color = rect->color;
@@ -327,8 +329,10 @@ void i810fb_copyarea(struct fb_info *inf
 	u32 sx, sy, dx, dy, pitch, width, height, src, dest, xdir;
 
 	if (!info->var.accel_flags || par->dev_flags & LOCKUP ||
-	    par->depth == 4)
-		return cfb_copyarea(info, region);
+	    par->depth == 4) {
+		cfb_copyarea(info, region);
+		return;
+	}
 
 	dx = region->dx * par->depth;
 	sx = region->sx * par->depth;
@@ -366,8 +370,10 @@ void i810fb_imageblit(struct fb_info *in
 	u32 fg = 0, bg = 0, size, dst;
 	
 	if (!info->var.accel_flags || par->dev_flags & LOCKUP ||
-	    par->depth == 4 || image->depth != 1) 
-		return cfb_imageblit(info, image);
+	    par->depth == 4 || image->depth != 1) {
+		cfb_imageblit(info, image);
+		return;
+	}
 
 	switch (info->var.bits_per_pixel) {
 	case 8:
_

Patches currently in -mm which might be from hannes@hanneseder.net are

origin.patch
linux-next.patch

