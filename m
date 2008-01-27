From: akpm@linux-foundation.org
Subject: + ps3fb-add-support-for-configurable-black-borders.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:34 -0800
Message-ID: <200801270514.m0R5EVRp031010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbYA0FOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: add support for configurable black borders
has been added to the -mm tree.  Its filename is
     ps3fb-add-support-for-configurable-black-borders.patch

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
Subject: ps3fb: add support for configurable black borders
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Allow all video modes where the visible resolution plus the black borders
matches a native resolution

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   69 ++++++++++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 20 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-add-support-for-configurable-black-borders drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-add-support-for-configurable-black-borders
+++ a/drivers/video/ps3fb.c
@@ -270,32 +270,57 @@ module_param(ps3fb_mode, int, 0);
 
 static char *mode_option __devinitdata;
 
-static unsigned int ps3fb_find_mode(const struct fb_var_screeninfo *var,
+static int ps3fb_cmp_mode(const struct fb_videomode *vmode,
+			  const struct fb_var_screeninfo *var)
+{
+	/* resolution + black border must match a native resolution */
+	if (vmode->left_margin + vmode->xres + vmode->right_margin !=
+	    var->left_margin + var->xres + var->right_margin ||
+	    vmode->upper_margin + vmode->yres + vmode->lower_margin !=
+	    var->upper_margin + var->yres + var->lower_margin)
+		return -1;
+
+	/* minimum limits for margins */
+	if (vmode->left_margin > var->left_margin ||
+	    vmode->right_margin > var->right_margin ||
+	    vmode->upper_margin > var->upper_margin ||
+	    vmode->lower_margin > var->lower_margin)
+		return -1;
+
+	/* these fields must match exactly */
+	if (vmode->pixclock != var->pixclock ||
+	    vmode->hsync_len != var->hsync_len ||
+	    vmode->vsync_len != var->vsync_len ||
+	    vmode->sync != var->sync ||
+	    vmode->vmode != (var->vmode & FB_VMODE_MASK))
+		return -1;
+
+	return 0;
+}
+
+static unsigned int ps3fb_find_mode(struct fb_var_screeninfo *var,
 				    u32 *ddr_line_length, u32 *xdr_line_length)
 {
-	unsigned int i, fi, mode;
+	unsigned int i, mode;
 
-	for (i = 0; i < ARRAY_SIZE(ps3fb_modedb); i++)
-		if (var->xres == ps3fb_modedb[i].xres &&
-		    var->yres == ps3fb_modedb[i].yres &&
-		    var->pixclock == ps3fb_modedb[i].pixclock &&
-		    var->hsync_len == ps3fb_modedb[i].hsync_len &&
-		    var->vsync_len == ps3fb_modedb[i].vsync_len &&
-		    var->left_margin == ps3fb_modedb[i].left_margin &&
-		    var->right_margin == ps3fb_modedb[i].right_margin &&
-		    var->upper_margin == ps3fb_modedb[i].upper_margin &&
-		    var->lower_margin == ps3fb_modedb[i].lower_margin &&
-		    var->sync == ps3fb_modedb[i].sync &&
-		    (var->vmode & FB_VMODE_MASK) == ps3fb_modedb[i].vmode)
+	for (i = PS3AV_MODE_1080P50; i < ARRAY_SIZE(ps3fb_modedb); i++)
+		if (!ps3fb_cmp_mode(&ps3fb_modedb[i], var))
 			goto found;
 
 	pr_debug("ps3fb_find_mode: mode not found\n");
 	return 0;
 
 found:
-	/* Cropped broadcast modes use the full line length */
-	fi = i < PS3AV_MODE_1080P50 ? i + PS3AV_MODE_WUXGA : i;
-	*ddr_line_length = ps3fb_modedb[fi].xres * BPP;
+	*ddr_line_length = ps3fb_modedb[i].xres * BPP;
+
+	if (!var->xres) {
+		var->xres = 1;
+		var->right_margin--;
+	}
+	if (!var->yres) {
+		var->yres = 1;
+		var->lower_margin--;
+	}
 
 	if (ps3_compare_firmware_version(1, 9, 0) >= 0) {
 		*xdr_line_length = GPU_ALIGN_UP(max(var->xres,
@@ -305,10 +330,14 @@ found:
 	} else
 		*xdr_line_length = *ddr_line_length;
 
-	/* Full broadcast modes have the full mode bit set */
 	mode = i+1;
-	if (mode > PS3AV_MODE_WUXGA)
-		mode = (mode - PS3AV_MODE_WUXGA) | PS3AV_MODE_FULL;
+	if (mode > PS3AV_MODE_WUXGA) {
+		mode -= PS3AV_MODE_WUXGA;
+		/* Full broadcast modes have the full mode bit set */
+		if (ps3fb_modedb[i].xres == var->xres &&
+		    ps3fb_modedb[i].yres == var->yres)
+			mode |= PS3AV_MODE_FULL;
+	}
 
 	pr_debug("ps3fb_find_mode: mode %u\n", mode);
 
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
