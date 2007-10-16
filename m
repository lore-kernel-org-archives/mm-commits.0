From: akpm@linux-foundation.org
Subject: - svgalib-mode-selection-updates.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:46 -0700
Message-ID: <200710162045.l9GKjk3P016300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758095AbXJPU5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: santiago@crfreenet.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     svgalib: mode selection updates
has been removed from the -mm tree.  Its filename was
     svgalib-mode-selection-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: svgalib: mode selection updates
From: Ondrej Zajicek <santiago@crfreenet.org>

This patch changes mode selection matching algorithm.  It allows to choose
mode with matching depth even when requested color lengths are greater than
color lengths of every mode with requested color depth.

It also fixes bug in s3fb - wrong error value returned when format is not
supported by chip.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c    |    9 +++++--
 drivers/video/svgalib.c |   47 +++++++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 18 deletions(-)

diff -puN drivers/video/s3fb.c~svgalib-mode-selection-updates drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~svgalib-mode-selection-updates
+++ a/drivers/video/s3fb.c
@@ -403,8 +403,13 @@ static int s3fb_check_var(struct fb_var_
 
 	/* Find appropriate format */
 	rv = svga_match_format (s3fb_formats, var, NULL);
-	if ((rv < 0) || ((par->chip == CHIP_988_VIRGE_VX) ? (rv == 7) : (rv == 6)))
-	{		/* 24bpp on VIRGE VX, 32bpp on others */
+
+	/* 32bpp mode is not supported on VIRGE VX,
+	   24bpp is not supported on others */
+	if ((par->chip == CHIP_988_VIRGE_VX) ? (rv == 7) : (rv == 6))
+		rv = -EINVAL;
+
+	if (rv < 0) {
 		printk(KERN_ERR "fb%d: unsupported mode requested\n", info->node);
 		return rv;
 	}
diff -puN drivers/video/svgalib.c~svgalib-mode-selection-updates drivers/video/svgalib.c
--- a/drivers/video/svgalib.c~svgalib-mode-selection-updates
+++ a/drivers/video/svgalib.c
@@ -598,9 +598,11 @@ void svga_set_timings(const struct svga_
 /* ------------------------------------------------------------------------- */
 
 
-int svga_match_format(const struct svga_fb_format *frm, struct fb_var_screeninfo *var, struct fb_fix_screeninfo *fix)
+static inline int match_format(const struct svga_fb_format *frm,
+			       struct fb_var_screeninfo *var)
 {
 	int i = 0;
+	int stored = -EINVAL;
 
 	while (frm->bits_per_pixel != SVGA_FORMAT_END_VAL)
 	{
@@ -609,25 +611,38 @@ int svga_match_format(const struct svga_
 		    (var->green.length   <= frm->green.length)   &&
 		    (var->blue.length    <= frm->blue.length)    &&
 		    (var->transp.length  <= frm->transp.length)  &&
-		    (var->nonstd	 == frm->nonstd)) {
-		    	var->bits_per_pixel = frm->bits_per_pixel;
-			var->red            = frm->red;
-			var->green          = frm->green;
-			var->blue           = frm->blue;
-			var->transp         = frm->transp;
-			var->nonstd         = frm->nonstd;
-			if (fix != NULL) {
-				fix->type      = frm->type;
-				fix->type_aux  = frm->type_aux;
-				fix->visual    = frm->visual;
-				fix->xpanstep  = frm->xpanstep;
-			}
+		    (var->nonstd	 == frm->nonstd))
 			return i;
-		}
+		if (var->bits_per_pixel == frm->bits_per_pixel)
+			stored = i;
 		i++;
 		frm++;
 	}
-	return -EINVAL;
+	return stored;
+}
+
+int svga_match_format(const struct svga_fb_format *frm,
+		      struct fb_var_screeninfo *var,
+		      struct fb_fix_screeninfo *fix)
+{
+	int i = match_format(frm, var);
+
+	if (i >= 0) {
+		var->bits_per_pixel = frm[i].bits_per_pixel;
+		var->red            = frm[i].red;
+		var->green          = frm[i].green;
+		var->blue           = frm[i].blue;
+		var->transp         = frm[i].transp;
+		var->nonstd         = frm[i].nonstd;
+		if (fix != NULL) {
+			fix->type      = frm[i].type;
+			fix->type_aux  = frm[i].type_aux;
+			fix->visual    = frm[i].visual;
+			fix->xpanstep  = frm[i].xpanstep;
+		}
+	}
+
+	return i;
 }
 
 
_

Patches currently in -mm which might be from santiago@crfreenet.org are

origin.patch
