From: akpm@linux-foundation.org
Subject: + intelfb-fix-sparse-warnings.patch added to -mm tree
Date: Sat, 29 Nov 2008 19:34:36 -0800
Message-ID: <200811300334.mAU3Ya3p021405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754562AbYK3Del (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 22:34:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net, krzysztof.h1@poczta.fm


The patch titled
     intelfb: fix sparse warnings
has been added to the -mm tree.  Its filename is
     intelfb-fix-sparse-warnings.patch

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
Subject: intelfb: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warnings:

  drivers/video/intelfb/intelfbdrv.c:1497:3: warning: returning void-valued expression
  drivers/video/intelfb/intelfbdrv.c:1525:3: warning: returning void-valued expression
  drivers/video/intelfb/intelfbdrv.c:1544:3: warning: returning void-valued expression
  drivers/video/intelfb/intelfbdrv.c:1558:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfbdrv.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN drivers/video/intelfb/intelfbdrv.c~intelfb-fix-sparse-warnings drivers/video/intelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c~intelfb-fix-sparse-warnings
+++ a/drivers/video/intelfb/intelfbdrv.c
@@ -1493,8 +1493,10 @@ static void intelfb_fillrect (struct fb_
 	DBG_MSG("intelfb_fillrect\n");
 #endif
 
-	if (!ACCEL(dinfo, info) || dinfo->depth == 4)
-		return cfb_fillrect(info, rect);
+	if (!ACCEL(dinfo, info) || dinfo->depth == 4) {
+		cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (rect->rop == ROP_COPY)
 		rop = PAT_ROP_GXCOPY;
@@ -1521,8 +1523,10 @@ static void intelfb_copyarea(struct fb_i
 	DBG_MSG("intelfb_copyarea\n");
 #endif
 
-	if (!ACCEL(dinfo, info) || dinfo->depth == 4)
-		return cfb_copyarea(info, region);
+	if (!ACCEL(dinfo, info) || dinfo->depth == 4) {
+		cfb_copyarea(info, region);
+		return;
+	}
 
 	intelfbhw_do_bitblt(dinfo, region->sx, region->sy, region->dx,
 			    region->dy, region->width, region->height,
@@ -1540,8 +1544,10 @@ static void intelfb_imageblit(struct fb_
 #endif
 
 	if (!ACCEL(dinfo, info) || dinfo->depth == 4
-	    || image->depth != 1)
-		return cfb_imageblit(info, image);
+	    || image->depth != 1) {
+		cfb_imageblit(info, image);
+		return;
+	}
 
 	if (dinfo->depth != 8) {
 		fgcolor = dinfo->pseudo_palette[image->fg_color];
@@ -1554,8 +1560,10 @@ static void intelfb_imageblit(struct fb_
 	if (!intelfbhw_do_drawglyph(dinfo, fgcolor, bgcolor, image->width,
 				    image->height, image->data,
 				    image->dx, image->dy,
-				    dinfo->pitch, info->var.bits_per_pixel))
-		return cfb_imageblit(info, image);
+				    dinfo->pitch, info->var.bits_per_pixel)) {
+		cfb_imageblit(info, image);
+		return;
+	}
 }
 
 static int intelfb_cursor(struct fb_info *info, struct fb_cursor *cursor)
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

