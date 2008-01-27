From: akpm@linux-foundation.org
Subject: + ps3fb-kill-ps3fb_res.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:30 -0800
Message-ID: <200801270514.m0R5ERxb030984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35718 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbYA0FOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: kill ps3fb_res
has been added to the -mm tree.  Its filename is
     ps3fb-kill-ps3fb_res.patch

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
Subject: ps3fb: kill ps3fb_res
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

kill ps3fb_res[], as all information it contains can be obtained in some other
way.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |  108 ++++++++--------------------------------
 1 file changed, 22 insertions(+), 86 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-kill-ps3fb_res drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-kill-ps3fb_res
+++ a/drivers/video/ps3fb.c
@@ -134,42 +134,17 @@ static struct ps3fb_priv ps3fb;
 struct ps3fb_par {
 	u32 pseudo_palette[16];
 	int mode_id, new_mode_id;
-	int res_index;
 	unsigned int num_frames;	/* num of frame buffers */
 	unsigned int width;
 	unsigned int height;
+	unsigned int ddr_line_length;
+	unsigned int ddr_frame_size;
+	unsigned int xdr_frame_size;
 	unsigned long full_offset;	/* start of fullscreen DDR fb */
 	unsigned long fb_offset;	/* start of actual DDR fb */
 	unsigned long pan_offset;
 };
 
-struct ps3fb_res_table {
-	u32 xres;
-	u32 yres;
-	u32 xoff;
-	u32 yoff;
-	u32 type;
-};
-#define PS3FB_RES_FULL 1
-static const struct ps3fb_res_table ps3fb_res[] = {
-	/* res_x,y   margin_x,y  full */
-	{  720,  480,  72,  48 , 0},
-	{  720,  576,  72,  58 , 0},
-	{ 1280,  720,  78,  38 , 0},
-	{ 1920, 1080, 116,  58 , 0},
-	/* full mode */
-	{  720,  480,   0,   0 , PS3FB_RES_FULL},
-	{  720,  576,   0,   0 , PS3FB_RES_FULL},
-	{ 1280,  720,   0,   0 , PS3FB_RES_FULL},
-	{ 1920, 1080,   0,   0 , PS3FB_RES_FULL},
-	/* vesa: normally full mode */
-	{ 1280,  768,   0,   0 , 0},
-	{ 1280, 1024,   0,   0 , 0},
-	{ 1920, 1200,   0,   0 , 0},
-	{    0,    0,   0,   0 , 0} };
-
-/* default resolution */
-#define GPU_RES_INDEX	0		/* 720 x 480 */
 
 static const struct fb_videomode ps3fb_modedb[] = {
     /* 60 Hz broadcast modes (modes "1" to "5") */
@@ -295,37 +270,6 @@ module_param(ps3fb_mode, int, 0);
 
 static char *mode_option __devinitdata;
 
-static int ps3fb_get_res_table(u32 xres, u32 yres, int mode)
-{
-	int full_mode;
-	unsigned int i;
-	u32 x, y, f;
-
-	full_mode = (mode & PS3AV_MODE_FULL) ? PS3FB_RES_FULL : 0;
-	for (i = 0;; i++) {
-		x = ps3fb_res[i].xres;
-		y = ps3fb_res[i].yres;
-		f = ps3fb_res[i].type;
-
-		if (!x) {
-			pr_debug("ERROR: ps3fb_get_res_table()\n");
-			return -1;
-		}
-
-		if (full_mode == PS3FB_RES_FULL && f != PS3FB_RES_FULL)
-			continue;
-
-		if (x == xres && (yres == 0 || y == yres))
-			break;
-
-		x = x - 2 * ps3fb_res[i].xoff;
-		y = y - 2 * ps3fb_res[i].yoff;
-		if (x == xres && (yres == 0 || y == yres))
-			break;
-	}
-	return i;
-}
-
 static unsigned int ps3fb_find_mode(const struct fb_var_screeninfo *var,
 				    u32 *ddr_line_length, u32 *xdr_line_length)
 {
@@ -433,8 +377,7 @@ static void ps3fb_sync_image(struct devi
 static int ps3fb_sync(struct fb_info *info, u32 frame)
 {
 	struct ps3fb_par *par = info->par;
-	int i, error = 0;
-	u32 ddr_line_length, xdr_line_length;
+	int error = 0;
 	u64 ddr_base, xdr_base;
 
 	if (frame > par->num_frames - 1) {
@@ -444,16 +387,13 @@ static int ps3fb_sync(struct fb_info *in
 		goto out;
 	}
 
-	i = par->res_index;
-	xdr_line_length = info->fix.line_length;
-	ddr_line_length = ps3fb_res[i].xres * BPP;
-	xdr_base = frame * info->var.yres_virtual * xdr_line_length;
-	ddr_base = frame * ps3fb_res[i].yres * ddr_line_length;
+	xdr_base = frame * par->xdr_frame_size;
+	ddr_base = frame * par->ddr_frame_size;
 
 	ps3fb_sync_image(info->device, ddr_base + par->full_offset,
 			 ddr_base + par->fb_offset, xdr_base + par->pan_offset,
-			 par->width, par->height, ddr_line_length,
-			 xdr_line_length);
+			 par->width, par->height, par->ddr_line_length,
+			 info->fix.line_length);
 
 out:
 	return error;
@@ -572,8 +512,9 @@ static int ps3fb_set_par(struct fb_info 
 {
 	struct ps3fb_par *par = info->par;
 	unsigned int mode, ddr_line_length, xdr_line_length, lines, maxlines;
-	int i;
+	unsigned int ddr_xoff, ddr_yoff;
 	unsigned long offset;
+	const struct fb_videomode *vmode;
 	u64 dst;
 
 	dev_dbg(info->device, "xres:%d xv:%d yres:%d yv:%d clock:%d\n",
@@ -584,8 +525,7 @@ static int ps3fb_set_par(struct fb_info 
 	if (!mode)
 		return -EINVAL;
 
-	i = ps3fb_get_res_table(info->var.xres, info->var.yres, mode);
-	par->res_index = i;
+	vmode = ps3fb_default_mode(mode | PS3AV_MODE_FULL);
 
 	info->fix.smem_start = virt_to_abs(ps3fb.xdr_ea);
 	info->fix.smem_len = ps3fb.xdr_size;
@@ -595,9 +535,12 @@ static int ps3fb_set_par(struct fb_info 
 
 	info->screen_base = (char __iomem *)ps3fb.xdr_ea;
 
+	par->ddr_line_length = ddr_line_length;
+	par->ddr_frame_size = vmode->yres * ddr_line_length;
+	par->xdr_frame_size = info->var.yres_virtual * xdr_line_length;
+
 	par->num_frames = ps3fb.xdr_size /
-			  max(ps3fb_res[i].yres * ddr_line_length,
-			      info->var.yres_virtual * xdr_line_length);
+			  max(par->ddr_frame_size, par->xdr_frame_size);
 
 	/* Keep the special bits we cannot set using fb_var_screeninfo */
 	par->new_mode_id = (par->new_mode_id & ~PS3AV_MODE_MASK) | mode;
@@ -606,7 +549,9 @@ static int ps3fb_set_par(struct fb_info 
 	par->height = info->var.yres;
 
 	/* Start of the virtual frame buffer (relative to fullscreen) */
-	offset = ps3fb_res[i].yoff * ddr_line_length + ps3fb_res[i].xoff * BPP;
+	ddr_xoff = info->var.left_margin - vmode->left_margin;
+	ddr_yoff = info->var.upper_margin - vmode->upper_margin;
+	offset = ddr_yoff * ddr_line_length + ddr_xoff * BPP;
 
 	par->fb_offset = GPU_ALIGN_UP(offset);
 	par->full_offset = par->fb_offset - offset;
@@ -625,13 +570,13 @@ static int ps3fb_set_par(struct fb_info 
 	memset(ps3fb.xdr_ea, 0, ps3fb.xdr_size);
 
 	/* Clear DDR frame buffer memory */
-	lines = ps3fb_res[i].yres * par->num_frames;
+	lines = vmode->yres * par->num_frames;
 	if (par->full_offset)
 		lines++;
 	maxlines = ps3fb.xdr_size / ddr_line_length;
 	for (dst = 0; lines; dst += maxlines * ddr_line_length) {
 		unsigned int l = min(lines, maxlines);
-		ps3fb_sync_image(info->device, 0, dst, 0, ps3fb_res[i].xres, l,
+		ps3fb_sync_image(info->device, 0, dst, 0, vmode->xres, l,
 				 ddr_line_length, ddr_line_length);
 		lines -= l;
 	}
@@ -1052,14 +997,13 @@ static int __devinit ps3fb_probe(struct 
 	struct fb_info *info;
 	struct ps3fb_par *par;
 	int retval = -ENOMEM;
-	u32 xres, yres;
 	u64 ddr_lpar = 0;
 	u64 lpar_dma_control = 0;
 	u64 lpar_driver_info = 0;
 	u64 lpar_reports = 0;
 	u64 lpar_reports_size = 0;
 	u64 xdr_lpar;
-	int status, res_index;
+	int status;
 	struct task_struct *task;
 	unsigned long max_ps3fb_size;
 
@@ -1079,13 +1023,6 @@ static int __devinit ps3fb_probe(struct 
 		ps3fb_mode = ps3av_get_mode();
 	dev_dbg(&dev->core, "ps3fb_mode: %d\n", ps3fb_mode);
 
-	if (ps3fb_mode > 0 &&
-	    !ps3av_video_mode2res(ps3fb_mode, &xres, &yres)) {
-		res_index = ps3fb_get_res_table(xres, yres, ps3fb_mode);
-		dev_dbg(&dev->core, "res_index:%d\n", res_index);
-	} else
-		res_index = GPU_RES_INDEX;
-
 	atomic_set(&ps3fb.f_count, -1);	/* fbcon opens ps3fb */
 	atomic_set(&ps3fb.ext_flip, 0);	/* for flip with vsync */
 	init_waitqueue_head(&ps3fb.wait_vsync);
@@ -1158,7 +1095,6 @@ static int __devinit ps3fb_probe(struct 
 	par = info->par;
 	par->mode_id = ~ps3fb_mode;	/* != ps3fb_mode, to trigger change */
 	par->new_mode_id = ps3fb_mode;
-	par->res_index = res_index;
 	par->num_frames = 1;
 
 	info->screen_base = (char __iomem *)ps3fb.xdr_ea;
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
