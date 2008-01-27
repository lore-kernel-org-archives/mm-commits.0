From: akpm@linux-foundation.org
Subject: + ps3fb-round-up-video-modes.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:38 -0800
Message-ID: <200801270514.m0R5EZ71031017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYA0FOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: round up video modes
has been added to the -mm tree.  Its filename is
     ps3fb-round-up-video-modes.patch

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
Subject: ps3fb: round up video modes
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Round up arbitrary video modes until they fit (if possible)

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |  160 ++++++++++++++++++++++++++++------------
 1 file changed, 114 insertions(+), 46 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-round-up-video-modes drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-round-up-video-modes
+++ a/drivers/video/ps3fb.c
@@ -276,29 +276,49 @@ static char *mode_option __devinitdata;
 static int ps3fb_cmp_mode(const struct fb_videomode *vmode,
 			  const struct fb_var_screeninfo *var)
 {
-	/* resolution + black border must match a native resolution */
-	if (vmode->left_margin + vmode->xres + vmode->right_margin !=
-	    var->left_margin + var->xres + var->right_margin ||
-	    vmode->upper_margin + vmode->yres + vmode->lower_margin !=
-	    var->upper_margin + var->yres + var->lower_margin)
+	long xres, yres, left_margin, right_margin, upper_margin, lower_margin;
+	long dx, dy;
+
+	/* maximum values */
+	if (var->xres > vmode->xres || var->yres > vmode->yres ||
+	    var->pixclock > vmode->pixclock ||
+	    var->hsync_len > vmode->hsync_len ||
+	    var->vsync_len > vmode->vsync_len)
 		return -1;
 
-	/* minimum limits for margins */
-	if (vmode->left_margin > var->left_margin ||
-	    vmode->right_margin > var->right_margin ||
-	    vmode->upper_margin > var->upper_margin ||
-	    vmode->lower_margin > var->lower_margin)
+	/* progressive/interlaced must match */
+	if ((var->vmode & FB_VMODE_MASK) != vmode->vmode)
 		return -1;
 
-	/* these fields must match exactly */
-	if (vmode->pixclock != var->pixclock ||
-	    vmode->hsync_len != var->hsync_len ||
-	    vmode->vsync_len != var->vsync_len ||
-	    vmode->sync != var->sync ||
-	    vmode->vmode != (var->vmode & FB_VMODE_MASK))
+	/* minimum resolution */
+	xres = max(var->xres, 1U);
+	yres = max(var->yres, 1U);
+
+	/* minimum margins */
+	left_margin = max(var->left_margin, vmode->left_margin);
+	right_margin = max(var->right_margin, vmode->right_margin);
+	upper_margin = max(var->upper_margin, vmode->upper_margin);
+	lower_margin = max(var->lower_margin, vmode->lower_margin);
+
+	/* resolution + margins may not exceed native parameters */
+	dx = ((long)vmode->left_margin + (long)vmode->xres +
+	      (long)vmode->right_margin) -
+	     (left_margin + xres + right_margin);
+	if (dx < 0)
 		return -1;
 
-	return 0;
+	dy = ((long)vmode->upper_margin + (long)vmode->yres +
+	      (long)vmode->lower_margin) -
+	     (upper_margin + yres + lower_margin);
+	if (dy < 0)
+		return -1;
+
+	/* exact match */
+	if (!dx && !dy)
+		return 0;
+
+	/* resolution difference */
+	return (vmode->xres - xres) * (vmode->yres - yres);
 }
 
 static const struct fb_videomode *ps3fb_native_vmode(enum ps3av_mode_num id)
@@ -324,33 +344,96 @@ static const struct fb_videomode *ps3fb_
 static unsigned int ps3fb_find_mode(struct fb_var_screeninfo *var,
 				    u32 *ddr_line_length, u32 *xdr_line_length)
 {
-	unsigned int id;
+	unsigned int id, best_id;
+	int diff, best_diff;
 	const struct fb_videomode *vmode;
+	long gap;
 
+	best_id = 0;
+	best_diff = INT_MAX;
+	pr_debug("%s: wanted %u [%u] %u x %u [%u] %u\n", __func__,
+		 var->left_margin, var->xres, var->right_margin,
+		 var->upper_margin, var->yres, var->lower_margin);
 	for (id = PS3AV_MODE_480I; id <= PS3AV_MODE_WUXGA; id++) {
 		vmode = ps3fb_native_vmode(id);
-		if (!ps3fb_cmp_mode(vmode, var))
-			goto found;
+		diff = ps3fb_cmp_mode(vmode, var);
+		pr_debug("%s: mode %u: %u [%u] %u x %u [%u] %u: diff = %d\n",
+			 __func__, id, vmode->left_margin, vmode->xres,
+			 vmode->right_margin, vmode->upper_margin,
+			 vmode->yres, vmode->lower_margin, diff);
+		if (diff < 0)
+			continue;
+		if (diff < best_diff) {
+			best_id = id;
+			if (!diff)
+				break;
+			best_diff = diff;
+		}
 	}
 
-	pr_debug("%s: mode not found\n", __func__);
-	return 0;
+	if (!best_id) {
+		pr_debug("%s: no suitable mode found\n", __func__);
+		return 0;
+	}
+
+	id = best_id;
+	vmode = ps3fb_native_vmode(id);
 
-found:
 	*ddr_line_length = vmode->xres * BPP;
 
-	if (!var->xres) {
+	/* minimum resolution */
+	if (!var->xres)
 		var->xres = 1;
-		var->right_margin--;
-	}
-	if (!var->yres) {
+	if (!var->yres)
 		var->yres = 1;
-		var->lower_margin--;
-	}
+
+	/* minimum virtual resolution */
+	if (var->xres_virtual < var->xres)
+		var->xres_virtual = var->xres;
+	if (var->yres_virtual < var->yres)
+		var->yres_virtual = var->yres;
+
+	/* minimum margins */
+	if (var->left_margin < vmode->left_margin)
+		var->left_margin = vmode->left_margin;
+	if (var->right_margin < vmode->right_margin)
+		var->right_margin = vmode->right_margin;
+	if (var->upper_margin < vmode->upper_margin)
+		var->upper_margin = vmode->upper_margin;
+	if (var->lower_margin < vmode->lower_margin)
+		var->lower_margin = vmode->lower_margin;
+
+	/* extra margins */
+	gap = ((long)vmode->left_margin + (long)vmode->xres +
+	       (long)vmode->right_margin) -
+	      ((long)var->left_margin + (long)var->xres +
+	       (long)var->right_margin);
+	if (gap > 0) {
+		var->left_margin += gap/2;
+		var->right_margin += (gap+1)/2;
+		pr_debug("%s: rounded up H to %u [%u] %u\n", __func__,
+			 var->left_margin, var->xres, var->right_margin);
+	}
+
+	gap = ((long)vmode->upper_margin + (long)vmode->yres +
+	       (long)vmode->lower_margin) -
+	      ((long)var->upper_margin + (long)var->yres +
+	       (long)var->lower_margin);
+	if (gap > 0) {
+		var->upper_margin += gap/2;
+		var->lower_margin += (gap+1)/2;
+		pr_debug("%s: rounded up V to %u [%u] %u\n", __func__,
+			 var->upper_margin, var->yres, var->lower_margin);
+	}
+
+	/* fixed fields */
+	var->pixclock = vmode->pixclock;
+	var->hsync_len = vmode->hsync_len;
+	var->vsync_len = vmode->vsync_len;
+	var->sync = vmode->sync;
 
 	if (ps3_compare_firmware_version(1, 9, 0) >= 0) {
-		*xdr_line_length = GPU_ALIGN_UP(max(var->xres,
-						    var->xres_virtual) * BPP);
+		*xdr_line_length = GPU_ALIGN_UP(var->xres_virtual * BPP);
 		if (*xdr_line_length > GPU_MAX_LINE_LENGTH)
 			*xdr_line_length = GPU_MAX_LINE_LENGTH;
 	} else
@@ -465,22 +548,11 @@ static int ps3fb_check_var(struct fb_var
 	u32 xdr_line_length, ddr_line_length;
 	int mode;
 
-	dev_dbg(info->device, "var->xres:%u info->var.xres:%u\n", var->xres,
-		info->var.xres);
-	dev_dbg(info->device, "var->yres:%u info->var.yres:%u\n", var->yres,
-		info->var.yres);
-
-	/* FIXME For now we do exact matches only */
 	mode = ps3fb_find_mode(var, &ddr_line_length, &xdr_line_length);
 	if (!mode)
 		return -EINVAL;
 
 	/* Virtual screen */
-	if (var->xres_virtual < var->xres)
-		var->xres_virtual = var->xres;
-	if (var->yres_virtual < var->yres)
-		var->yres_virtual = var->yres;
-
 	if (var->xres_virtual > xdr_line_length / BPP) {
 		dev_dbg(info->device,
 			"Horizontal virtual screen size too large\n");
@@ -549,10 +621,6 @@ static int ps3fb_set_par(struct fb_info 
 	const struct fb_videomode *vmode;
 	u64 dst;
 
-	dev_dbg(info->device, "xres:%d xv:%d yres:%d yv:%d clock:%d\n",
-		info->var.xres, info->var.xres_virtual,
-		info->var.yres, info->var.yres_virtual, info->var.pixclock);
-
 	mode = ps3fb_find_mode(&info->var, &ddr_line_length, &xdr_line_length);
 	if (!mode)
 		return -EINVAL;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-powerpc.patch
git-kbuild.patch
git-x86.patch
ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch
ps3-checkpatch-drivers-ps3-ps3-vuartc.patch
ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused.patch
ps3-use-symbolic-names-for-video-modes.patch
ps3fb-kill-ps3fb_full_mode_bit.patch
ps3fb-inline-macros-that-are-used-only-once.patch
ps3fb-kill-ps3fb_res.patch
ps3fb-make-frame-buffer-offsets-unsigned-int.patch
ps3fb-add-support-for-configurable-black-borders.patch
ps3fb-reorganize-modedb-handling.patch
ps3fb-round-up-video-modes.patch
ps3fb-cleanup-sweep.patch
ps3fb-fix-modedb-typos.patch
