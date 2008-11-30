From: akpm@linux-foundation.org
Subject: + i810-fix-sparse-warnings.patch added to -mm tree
Date: Sat, 29 Nov 2008 19:34:33 -0800
Message-ID: <200811300334.mAU3YXCi021370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498AbYK3Dej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 22:34:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net, krzysztof.h1@poczta.fm


The patch titled
     i810: fix sparse warnings
has been added to the -mm tree.  Its filename is
     i810-fix-sparse-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
hugetlb-fix-sparse-warnings.patch
rtc-ds1511-fix-sparse-warning.patch
rtc-stk17ta8-fix-sparse-warning.patch
nvidia-fix-sparse-warnings.patch
viafb-fix-sparse-warnings.patch
pm3fb-fix-sparse-warning.patch
neofb-fix-sparse-warnings.patch
i810-fix-sparse-warnings.patch
intelfb-fix-sparse-warnings.patch

