From: akpm@linux-foundation.org
Subject: + ps3fb-dont-keep-the-borders-for-non-fullscreen-modes-in-xdr-memory.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:36:19 -0700
Message-ID: <200710152136.l9FLaJVe026147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46761 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755840AbXJOVgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: don't keep the borders for non-fullscreen modes in XDR memory
has been added to the -mm tree.  Its filename is
     ps3fb-dont-keep-the-borders-for-non-fullscreen-modes-in-xdr-memory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3fb: don't keep the borders for non-fullscreen modes in XDR memory
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Don't keep the borders for non-fullscreen modes in XDR memory:
  - Extract ps3fb_sync_image()
  - Work around the alignment restrictions of L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT
    by using an offset with L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP
  - Only copy the visible part of the screen on every vblank
  - Always put the real frame buffer at the start of video memory
  - Clear fullscreen DDR memory on mode change

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |  131 ++++++++++++++++++++++------------------
 1 file changed, 75 insertions(+), 56 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-dont-keep-the-borders-for-non-fullscreen-modes-in-xdr-memory drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-dont-keep-the-borders-for-non-fullscreen-modes-in-xdr-memory
+++ a/drivers/video/ps3fb.c
@@ -54,6 +54,7 @@
 #define DDR_SIZE				(0)	/* used no ddr */
 #define GPU_CMD_BUF_SIZE			(64 * 1024)
 #define GPU_IOIF				(0x0d000000UL)
+#define GPU_ALIGN_UP(x)				_ALIGN_UP((x), 64)
 
 #define PS3FB_FULL_MODE_BIT			0x80
 
@@ -136,6 +137,10 @@ struct ps3fb_par {
 	int mode_id, new_mode_id;
 	int res_index;
 	unsigned int num_frames;	/* num of frame buffers */
+	unsigned int width;
+	unsigned int height;
+	unsigned long full_offset;	/* start of fullscreen DDR fb */
+	unsigned long fb_offset;	/* start of actual DDR fb */
 };
 
 struct ps3fb_res_table {
@@ -291,15 +296,6 @@ static const struct fb_videomode ps3fb_m
 /* Start of the virtual frame buffer (relative to fullscreen ) */
 #define VP_OFF(i)	((WIDTH(i) * Y_OFF(i) + X_OFF(i)) * BPP)
 
-/*
- * Start of the virtual frame buffer (relative to start of video memory)
- * This is PAGE_SIZE aligned for easier mmap()
- */
-#define VFB_OFF(i)	PAGE_ALIGN(VP_OFF(i))
-
-/* Start of the fullscreen frame buffer (relative to start of video memory) */
-#define FB_OFF(i)	(-VP_OFF(i) & ~PAGE_MASK)
-
 
 static int ps3fb_mode;
 module_param(ps3fb_mode, int, 0);
@@ -386,63 +382,72 @@ static const struct fb_videomode *ps3fb_
 	return &ps3fb_modedb[mode - 1];
 }
 
-static int ps3fb_sync(struct fb_info *info, u32 frame)
+static void ps3fb_sync_image(struct device *dev, u64 frame_offset,
+			     u64 dst_offset, u64 src_offset, u32 width,
+			     u32 height, u64 line_length)
 {
-	struct ps3fb_par *par = info->par;
-	int i, status, error = 0;
-	u32 xres, yres;
-	u64 fb_ioif, offset;
-
-	acquire_console_sem();
-
-	i = par->res_index;
-	xres = ps3fb_res[i].xres;
-	yres = ps3fb_res[i].yres;
-
-	if (frame > par->num_frames - 1) {
-		dev_dbg(info->device, "%s: invalid frame number (%u)\n",
-			__func__, frame);
-		error = -EINVAL;
-		goto out;
-	}
-	offset = xres * yres * BPP * frame;
+	int status;
 
-	fb_ioif = GPU_IOIF + FB_OFF(i) + offset;
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT,
-					   offset, fb_ioif,
+					   dst_offset, GPU_IOIF + src_offset,
 					   L1GPU_FB_BLIT_WAIT_FOR_COMPLETION |
-					   (xres << 16) | yres,
-					   xres * BPP);	/* line_length */
+					   (width << 16) | height,
+					   line_length);
 	if (status)
-		dev_err(info->device,
+		dev_err(dev,
 			"%s: lv1_gpu_context_attribute FB_BLIT failed: %d\n",
 			__func__, status);
 #ifdef HEAD_A
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP,
-					   0, offset, 0, 0);
+					   0, frame_offset, 0, 0);
 	if (status)
-		dev_err(info->device,
-			"%s: lv1_gpu_context_attribute FLIP failed: %d\n",
+		dev_err(dev, "%s: lv1_gpu_context_attribute FLIP failed: %d\n",
 			__func__, status);
 #endif
 #ifdef HEAD_B
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP,
-					   1, offset, 0, 0);
+					   1, frame_offset, 0, 0);
 	if (status)
-		dev_err(info->device,
-			"%s: lv1_gpu_context_attribute FLIP failed: %d\n",
+		dev_err(dev, "%s: lv1_gpu_context_attribute FLIP failed: %d\n",
 			__func__, status);
 #endif
+}
+
+static int ps3fb_sync(struct fb_info *info, u32 frame)
+{
+	struct ps3fb_par *par = info->par;
+	int i, error = 0;
+	u32 xres, yres;
+	u64 line_length, base;
+
+	acquire_console_sem();
+
+	if (frame > par->num_frames - 1) {
+		dev_dbg(info->device, "%s: invalid frame number (%u)\n",
+			__func__, frame);
+		error = -EINVAL;
+		goto out;
+	}
+
+	i = par->res_index;
+	xres = ps3fb_res[i].xres;
+	yres = ps3fb_res[i].yres;
+
+	line_length = xres * BPP;
+	base = frame * yres * line_length;
+
+	ps3fb_sync_image(info->device, base + par->full_offset,
+			 base + par->fb_offset, base, par->width, par->height,
+			 line_length);
 
 out:
 	release_console_sem();
 	return error;
 }
 
-
 static int ps3fb_open(struct fb_info *info, int user)
 {
 	atomic_inc(&ps3fb.f_count);
@@ -472,7 +477,6 @@ static int ps3fb_check_var(struct fb_var
 {
 	u32 line_length;
 	int mode;
-	int i;
 
 	dev_dbg(info->device, "var->xres:%u info->var.xres:%u\n", var->xres,
 		info->var.xres);
@@ -539,9 +543,7 @@ static int ps3fb_check_var(struct fb_var
 	}
 
 	/* Memory limit */
-	i = ps3fb_get_res_table(var->xres, var->yres, mode);
-	if (ps3fb_res[i].xres*ps3fb_res[i].yres*BPP >
-	    ps3fb.xdr_size - VFB_OFF(i)) {
+	if (var->yres * line_length > ps3fb.xdr_size) {
 		dev_dbg(info->device, "Not enough memory\n");
 		return -ENOMEM;
 	}
@@ -559,9 +561,9 @@ static int ps3fb_check_var(struct fb_var
 static int ps3fb_set_par(struct fb_info *info)
 {
 	struct ps3fb_par *par = info->par;
-	unsigned int mode;
+	unsigned int mode, lines, maxlines;
 	int i;
-	unsigned long offset;
+	unsigned long offset, dst;
 
 	dev_dbg(info->device, "xres:%d xv:%d yres:%d yv:%d clock:%d\n",
 		info->var.xres, info->var.xres_virtual,
@@ -574,11 +576,9 @@ static int ps3fb_set_par(struct fb_info 
 	i = ps3fb_get_res_table(info->var.xres, info->var.yres, mode);
 	par->res_index = i;
 
-	offset = VFB_OFF(i);
-	info->fix.smem_start = virt_to_abs(ps3fb.xdr_ea) + offset;
-	info->fix.smem_len = ps3fb.xdr_size - offset;
-	info->screen_base = (char __iomem *)ps3fb.xdr_ea + offset;
-	memset(ps3fb.xdr_ea, 0, ps3fb.xdr_size);
+	info->fix.smem_start = virt_to_abs(ps3fb.xdr_ea);
+	info->fix.smem_len = ps3fb.xdr_size;
+	info->screen_base = (char __iomem *)ps3fb.xdr_ea;
 
 	par->num_frames = info->fix.smem_len/
 			  (ps3fb_res[i].xres*ps3fb_res[i].yres*BPP);
@@ -586,6 +586,12 @@ static int ps3fb_set_par(struct fb_info 
 	/* Keep the special bits we cannot set using fb_var_screeninfo */
 	par->new_mode_id = (par->new_mode_id & ~PS3AV_MODE_MASK) | mode;
 
+	par->width = info->var.xres;
+	par->height = info->var.yres;
+	offset = VP_OFF(i);
+	par->fb_offset = GPU_ALIGN_UP(offset);
+	par->full_offset = par->fb_offset - offset;
+
 	if (par->new_mode_id != par->mode_id) {
 		if (ps3av_set_video_mode(par->new_mode_id)) {
 			par->new_mode_id = par->mode_id;
@@ -594,6 +600,21 @@ static int ps3fb_set_par(struct fb_info 
 		par->mode_id = par->new_mode_id;
 	}
 
+	/* Clear XDR frame buffer memory */
+	memset(ps3fb.xdr_ea, 0, ps3fb.xdr_size);
+
+	/* Clear DDR frame buffer memory */
+	lines = ps3fb_res[i].yres * par->num_frames;
+	if (par->full_offset)
+		lines++;
+	maxlines = ps3fb.xdr_size / info->fix.line_length;
+	for (dst = 0; lines; dst += maxlines * info->fix.line_length) {
+		unsigned int l = min(lines, maxlines);
+		ps3fb_sync_image(info->device, 0, dst, 0, ps3fb_res[i].xres, l,
+				 info->fix.line_length);
+		lines -= l;
+	}
+
 	return 0;
 }
 
@@ -1005,7 +1026,6 @@ static int __devinit ps3fb_probe(struct 
 	u64 lpar_reports_size = 0;
 	u64 xdr_lpar;
 	int status, res_index;
-	unsigned long offset;
 	struct task_struct *task;
 
 	status = ps3_open_hv_device(dev);
@@ -1088,13 +1108,12 @@ static int __devinit ps3fb_probe(struct 
 	par->res_index = res_index;
 	par->num_frames = 1;
 
-	offset = VFB_OFF(res_index);
-	info->screen_base = (char __iomem *)ps3fb.xdr_ea + offset;
+	info->screen_base = (char __iomem *)ps3fb.xdr_ea;
 	info->fbops = &ps3fb_ops;
 
 	info->fix = ps3fb_fix;
-	info->fix.smem_start = virt_to_abs(ps3fb.xdr_ea) + offset;
-	info->fix.smem_len = ps3fb.xdr_size - offset;
+	info->fix.smem_start = virt_to_abs(ps3fb.xdr_ea);
+	info->fix.smem_len = ps3fb.xdr_size;
 	info->pseudo_palette = par->pseudo_palette;
 	info->flags = FBINFO_DEFAULT | FBINFO_READS_FAST;
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
git-scsi-misc.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
ps3-fix-black-and-white-stripes.patch
ps3fb-fix-spurious-mode-change-failures.patch
ps3av-eliminate-unneeded-temporary-variables.patch
ps3av-eliminate-ps3av_debug.patch
ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch
ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch
ps3av-add-autodetection-for-vesa-modes.patch
ps3av-add-quirk-database-for-broken-monitors.patch
ps3av-remove-unused-ps3av_set_mode.patch
ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch
ps3fb-convert-from-printk-dprintk-to-dev_-pr_.patch
ps3fb-do-not-print-warnings-on-invalid-frame-numbers.patch
ps3fb-clean-up-includes.patch
ps3fb-make-ps3fb_wait_for_vsync-and-ps3fb_flip_ctl-static.patch
ps3fb-fix-possible-overlap-of-gpu-command-buffer-and-frame-buffer.patch
ps3fb-use-fb_infopar-properly.patch
ps3fb-dont-keep-the-borders-for-non-fullscreen-modes-in-xdr-memory.patch
ps3fb-add-virtual-screen-and-panning-support.patch
ps3fb-enhance-horizontal-panning-on-firmware-190-and-up.patch
fb-move-and-rename-extern-declaration-for-global_mode_option.patch
ps3fb-default-to-480p-on-dvi-d-hdmi-if-video=safe.patch
