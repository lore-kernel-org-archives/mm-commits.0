From: akpm@linux-foundation.org
Subject: - ps3fb-enhance-horizontal-panning-on-firmware-190-and-up.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:40 -0700
Message-ID: <200710162045.l9GKjejC016289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965812AbXJPU5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ps3fb: enhance horizontal panning on firmware 1.90 and up
has been removed from the -mm tree.  Its filename was
     ps3fb-enhance-horizontal-panning-on-firmware-190-and-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: enhance horizontal panning on firmware 1.90 and up
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Enhance horizontal panning on firmware 1.90 and up:
  - On firmware 1.90 and up, L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT supports copying
    rectangles from XDR to DDR memory with different source and destination
    line lengths. Hence larger horizontal virtual resolutions can be supported
    (up to 16368 pixels).
  - As the actual frame buffer memory layout no longer matches the entries in
    ps3fb_res[], create fake struct ps3fb_ioctl_res data for the
    PS3FB_IOCTL_SCREENINFO ioctl, so user space applications that depend on it
    keep on working.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |  103 +++++++++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 42 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-enhance-horizontal-panning-on-firmware-190-and-up drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-enhance-horizontal-panning-on-firmware-190-and-up
+++ a/drivers/video/ps3fb.c
@@ -55,6 +55,7 @@
 #define GPU_CMD_BUF_SIZE			(64 * 1024)
 #define GPU_IOIF				(0x0d000000UL)
 #define GPU_ALIGN_UP(x)				_ALIGN_UP((x), 64)
+#define GPU_MAX_LINE_LENGTH			(65536 - 64)
 
 #define PS3FB_FULL_MODE_BIT			0x80
 
@@ -335,7 +336,7 @@ static int ps3fb_get_res_table(u32 xres,
 }
 
 static unsigned int ps3fb_find_mode(const struct fb_var_screeninfo *var,
-				    u32 *line_length)
+				    u32 *ddr_line_length, u32 *xdr_line_length)
 {
 	unsigned int i, mode;
 
@@ -350,19 +351,30 @@ static unsigned int ps3fb_find_mode(cons
 		    var->upper_margin == ps3fb_modedb[i].upper_margin &&
 		    var->lower_margin == ps3fb_modedb[i].lower_margin &&
 		    var->sync == ps3fb_modedb[i].sync &&
-		    (var->vmode & FB_VMODE_MASK) == ps3fb_modedb[i].vmode) {
-			/* Cropped broadcast modes use the full line_length */
-			*line_length =
-			    ps3fb_modedb[i < 10 ? i + 13 : i].xres * 4;
-			/* Full broadcast modes have the full mode bit set */
-			mode = i > 12 ? (i - 12) | PS3FB_FULL_MODE_BIT : i + 1;
-
-			pr_debug("ps3fb_find_mode: mode %u\n", mode);
-			return mode;
-		}
+		    (var->vmode & FB_VMODE_MASK) == ps3fb_modedb[i].vmode)
+			goto found;
 
 	pr_debug("ps3fb_find_mode: mode not found\n");
 	return 0;
+
+found:
+	/* Cropped broadcast modes use the full line length */
+	*ddr_line_length = ps3fb_modedb[i < 10 ? i + 13 : i].xres * BPP;
+
+	if (ps3_compare_firmware_version(1, 9, 0) >= 0) {
+		*xdr_line_length = GPU_ALIGN_UP(max(var->xres,
+						    var->xres_virtual) * BPP);
+		if (*xdr_line_length > GPU_MAX_LINE_LENGTH)
+			*xdr_line_length = GPU_MAX_LINE_LENGTH;
+	} else
+		*xdr_line_length = *ddr_line_length;
+
+	/* Full broadcast modes have the full mode bit set */
+	mode = i > 12 ? (i - 12) | PS3FB_FULL_MODE_BIT : i + 1;
+
+	pr_debug("ps3fb_find_mode: mode %u\n", mode);
+
+	return mode;
 }
 
 static const struct fb_videomode *ps3fb_default_mode(int id)
@@ -385,9 +397,15 @@ static const struct fb_videomode *ps3fb_
 
 static void ps3fb_sync_image(struct device *dev, u64 frame_offset,
 			     u64 dst_offset, u64 src_offset, u32 width,
-			     u32 height, u64 line_length)
+			     u32 height, u32 dst_line_length,
+			     u32 src_line_length)
 {
 	int status;
+	u64 line_length;
+
+	line_length = dst_line_length;
+	if (src_line_length != dst_line_length)
+		line_length |= (u64)src_line_length << 32;
 
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT,
@@ -421,8 +439,8 @@ static int ps3fb_sync(struct fb_info *in
 {
 	struct ps3fb_par *par = info->par;
 	int i, error = 0;
-	u32 xres, yres;
-	u64 line_length, base;
+	u32 ddr_line_length, xdr_line_length;
+	u64 ddr_base, xdr_base;
 
 	acquire_console_sem();
 
@@ -434,15 +452,15 @@ static int ps3fb_sync(struct fb_info *in
 	}
 
 	i = par->res_index;
-	xres = ps3fb_res[i].xres;
-	yres = ps3fb_res[i].yres;
-
-	line_length = xres * BPP;
-	base = frame * yres * line_length;
-
-	ps3fb_sync_image(info->device, base + par->full_offset,
-			 base + par->fb_offset, base + par->pan_offset,
-			 par->width, par->height, line_length);
+	xdr_line_length = info->fix.line_length;
+	ddr_line_length = ps3fb_res[i].xres * BPP;
+	xdr_base = frame * info->var.yres_virtual * xdr_line_length;
+	ddr_base = frame * ps3fb_res[i].yres * ddr_line_length;
+
+	ps3fb_sync_image(info->device, ddr_base + par->full_offset,
+			 ddr_base + par->fb_offset, xdr_base + par->pan_offset,
+			 par->width, par->height, ddr_line_length,
+			 xdr_line_length);
 
 out:
 	release_console_sem();
@@ -476,7 +494,7 @@ static int ps3fb_release(struct fb_info 
 
 static int ps3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
-	u32 line_length;
+	u32 xdr_line_length, ddr_line_length;
 	int mode;
 
 	dev_dbg(info->device, "var->xres:%u info->var.xres:%u\n", var->xres,
@@ -485,7 +503,7 @@ static int ps3fb_check_var(struct fb_var
 		info->var.yres);
 
 	/* FIXME For now we do exact matches only */
-	mode = ps3fb_find_mode(var, &line_length);
+	mode = ps3fb_find_mode(var, &ddr_line_length, &xdr_line_length);
 	if (!mode)
 		return -EINVAL;
 
@@ -495,7 +513,7 @@ static int ps3fb_check_var(struct fb_var
 	if (var->yres_virtual < var->yres)
 		var->yres_virtual = var->yres;
 
-	if (var->xres_virtual > line_length / BPP) {
+	if (var->xres_virtual > xdr_line_length / BPP) {
 		dev_dbg(info->device,
 			"Horizontal virtual screen size too large\n");
 		return -EINVAL;
@@ -540,7 +558,7 @@ static int ps3fb_check_var(struct fb_var
 	}
 
 	/* Memory limit */
-	if (var->yres_virtual * line_length > ps3fb.xdr_size) {
+	if (var->yres_virtual * xdr_line_length > ps3fb.xdr_size) {
 		dev_dbg(info->device, "Not enough memory\n");
 		return -ENOMEM;
 	}
@@ -558,15 +576,16 @@ static int ps3fb_check_var(struct fb_var
 static int ps3fb_set_par(struct fb_info *info)
 {
 	struct ps3fb_par *par = info->par;
-	unsigned int mode, line_length, lines, maxlines;
+	unsigned int mode, ddr_line_length, xdr_line_length, lines, maxlines;
 	int i;
-	unsigned long offset, dst;
+	unsigned long offset;
+	u64 dst;
 
 	dev_dbg(info->device, "xres:%d xv:%d yres:%d yv:%d clock:%d\n",
 		info->var.xres, info->var.xres_virtual,
 		info->var.yres, info->var.yres_virtual, info->var.pixclock);
 
-	mode = ps3fb_find_mode(&info->var, &line_length);
+	mode = ps3fb_find_mode(&info->var, &ddr_line_length, &xdr_line_length);
 	if (!mode)
 		return -EINVAL;
 
@@ -577,12 +596,13 @@ static int ps3fb_set_par(struct fb_info 
 	info->fix.smem_len = ps3fb.xdr_size;
 	info->fix.xpanstep = info->var.xres_virtual > info->var.xres ? 1 : 0;
 	info->fix.ypanstep = info->var.yres_virtual > info->var.yres ? 1 : 0;
-	info->fix.line_length = line_length;
+	info->fix.line_length = xdr_line_length;
 
 	info->screen_base = (char __iomem *)ps3fb.xdr_ea;
 
-	par->num_frames = info->fix.smem_len/
-			  (ps3fb_res[i].xres*ps3fb_res[i].yres*BPP);
+	par->num_frames = ps3fb.xdr_size /
+			  max(ps3fb_res[i].yres * ddr_line_length,
+			      info->var.yres_virtual * xdr_line_length);
 
 	/* Keep the special bits we cannot set using fb_var_screeninfo */
 	par->new_mode_id = (par->new_mode_id & ~PS3AV_MODE_MASK) | mode;
@@ -592,7 +612,7 @@ static int ps3fb_set_par(struct fb_info 
 	offset = VP_OFF(i);
 	par->fb_offset = GPU_ALIGN_UP(offset);
 	par->full_offset = par->fb_offset - offset;
-	par->pan_offset = info->var.yoffset * line_length +
+	par->pan_offset = info->var.yoffset * xdr_line_length +
 			  info->var.xoffset * BPP;
 
 	if (par->new_mode_id != par->mode_id) {
@@ -610,11 +630,11 @@ static int ps3fb_set_par(struct fb_info 
 	lines = ps3fb_res[i].yres * par->num_frames;
 	if (par->full_offset)
 		lines++;
-	maxlines = ps3fb.xdr_size / line_length;
-	for (dst = 0; lines; dst += maxlines * line_length) {
+	maxlines = ps3fb.xdr_size / ddr_line_length;
+	for (dst = 0; lines; dst += maxlines * ddr_line_length) {
 		unsigned int l = min(lines, maxlines);
 		ps3fb_sync_image(info->device, 0, dst, 0, ps3fb_res[i].xres, l,
-				 line_length);
+				 ddr_line_length, ddr_line_length);
 		lines -= l;
 	}
 
@@ -816,12 +836,11 @@ static int ps3fb_ioctl(struct fb_info *i
 		{
 			struct ps3fb_par *par = info->par;
 			struct ps3fb_ioctl_res res;
-			int i = par->res_index;
 			dev_dbg(info->device, "PS3FB_IOCTL_SCREENINFO:\n");
-			res.xres = ps3fb_res[i].xres;
-			res.yres = ps3fb_res[i].yres;
-			res.xoff = ps3fb_res[i].xoff;
-			res.yoff = ps3fb_res[i].yoff;
+			res.xres = info->fix.line_length / BPP;
+			res.yres = info->var.yres_virtual;
+			res.xoff = (res.xres - info->var.xres) / 2;
+			res.yoff = (res.yres - info->var.yres) / 2;
 			res.num_frames = par->num_frames;
 			if (!copy_to_user(argp, &res, sizeof(res)))
 				retval = 0;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
