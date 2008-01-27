From: akpm@linux-foundation.org
Subject: + ps3fb-cleanup-sweep.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:40 -0800
Message-ID: <200801270514.m0R5Ebbj031020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115AbYA0FO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: cleanup sweep
has been added to the -mm tree.  Its filename is
     ps3fb-cleanup-sweep.patch

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
Subject: ps3fb: cleanup sweep
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

cleanup sweep:
  - Kill ps3fb_priv.xdr_ea and ps3fb_priv.xdr_size, use info->screen_base and
    info->fix.smem_len instead.
  - Kill superfluous assignments to info->fix.smem_start, info->fix.smem_len,
    and info->screen_base in ps3fb_set_par(). Their values never change.
  - Add sparse annotations to casts to kill address space warnings

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   64 ++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-cleanup-sweep drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-cleanup-sweep
+++ a/drivers/video/ps3fb.c
@@ -116,8 +116,6 @@ struct ps3fb_priv {
 	unsigned int irq_no;
 
 	u64 context_handle, memory_handle;
-	void *xdr_ea;
-	size_t xdr_size;
 	struct gpu_driver_info *dinfo;
 
 	u64 vblank_count;	/* frame count */
@@ -598,7 +596,7 @@ static int ps3fb_check_var(struct fb_var
 	}
 
 	/* Memory limit */
-	if (var->yres_virtual * xdr_line_length > ps3fb.xdr_size) {
+	if (var->yres_virtual * xdr_line_length > info->fix.smem_len) {
 		dev_dbg(info->device, "Not enough memory\n");
 		return -ENOMEM;
 	}
@@ -627,19 +625,15 @@ static int ps3fb_set_par(struct fb_info 
 
 	vmode = ps3fb_native_vmode(mode & PS3AV_MODE_MASK);
 
-	info->fix.smem_start = virt_to_abs(ps3fb.xdr_ea);
-	info->fix.smem_len = ps3fb.xdr_size;
 	info->fix.xpanstep = info->var.xres_virtual > info->var.xres ? 1 : 0;
 	info->fix.ypanstep = info->var.yres_virtual > info->var.yres ? 1 : 0;
 	info->fix.line_length = xdr_line_length;
 
-	info->screen_base = (char __iomem *)ps3fb.xdr_ea;
-
 	par->ddr_line_length = ddr_line_length;
 	par->ddr_frame_size = vmode->yres * ddr_line_length;
 	par->xdr_frame_size = info->var.yres_virtual * xdr_line_length;
 
-	par->num_frames = ps3fb.xdr_size /
+	par->num_frames = info->fix.smem_len /
 			  max(par->ddr_frame_size, par->xdr_frame_size);
 
 	/* Keep the special bits we cannot set using fb_var_screeninfo */
@@ -667,13 +661,13 @@ static int ps3fb_set_par(struct fb_info 
 	}
 
 	/* Clear XDR frame buffer memory */
-	memset(ps3fb.xdr_ea, 0, ps3fb.xdr_size);
+	memset((void __force *)info->screen_base, 0, info->fix.smem_len);
 
 	/* Clear DDR frame buffer memory */
 	lines = vmode->yres * par->num_frames;
 	if (par->full_offset)
 		lines++;
-	maxlines = ps3fb.xdr_size / ddr_line_length;
+	maxlines = info->fix.smem_len / ddr_line_length;
 	for (dst = 0; lines; dst += maxlines * ddr_line_length) {
 		unsigned int l = min(lines, maxlines);
 		ps3fb_sync_image(info->device, 0, dst, 0, vmode->xres, l,
@@ -1017,10 +1011,9 @@ static int ps3fb_xdr_settings(u64 xdr_lp
 			__func__, status);
 		return -ENXIO;
 	}
-	dev_dbg(dev,
-		"video:%p xdr_ea:%p ioif:%lx lpar:%lx phys:%lx size:%lx\n",
-		ps3fb_videomemory.address, ps3fb.xdr_ea, GPU_IOIF, xdr_lpar,
-		virt_to_abs(ps3fb.xdr_ea), ps3fb_videomemory.size);
+	dev_dbg(dev, "video:%p ioif:%lx lpar:%lx size:%lx\n",
+		ps3fb_videomemory.address, GPU_IOIF, xdr_lpar,
+		ps3fb_videomemory.size);
 
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP,
@@ -1103,6 +1096,7 @@ static int __devinit ps3fb_probe(struct 
 	u64 lpar_reports = 0;
 	u64 lpar_reports_size = 0;
 	u64 xdr_lpar;
+	void *fb_start;
 	int status;
 	struct task_struct *task;
 	unsigned long max_ps3fb_size;
@@ -1158,7 +1152,7 @@ static int __devinit ps3fb_probe(struct 
 	}
 
 	/* vsync interrupt */
-	ps3fb.dinfo = ioremap(lpar_driver_info, 128 * 1024);
+	ps3fb.dinfo = (void __force *)ioremap(lpar_driver_info, 128 * 1024);
 	if (!ps3fb.dinfo) {
 		dev_err(&dev->core, "%s: ioremap failed\n", __func__);
 		goto err_gpu_context_free;
@@ -1168,22 +1162,10 @@ static int __devinit ps3fb_probe(struct 
 	if (retval)
 		goto err_iounmap_dinfo;
 
-	/* XDR frame buffer */
-	ps3fb.xdr_ea = ps3fb_videomemory.address;
-	xdr_lpar = ps3_mm_phys_to_lpar(__pa(ps3fb.xdr_ea));
-
 	/* Clear memory to prevent kernel info leakage into userspace */
-	memset(ps3fb.xdr_ea, 0, ps3fb_videomemory.size);
-
-	/*
-	 * The GPU command buffer is at the start of video memory
-	 * As we don't use the full command buffer, we can put the actual
-	 * frame buffer at offset GPU_FB_START and save some precious XDR
-	 * memory
-	 */
-	ps3fb.xdr_ea += GPU_FB_START;
-	ps3fb.xdr_size = ps3fb_videomemory.size - GPU_FB_START;
+	memset(ps3fb_videomemory.address, 0, ps3fb_videomemory.size);
 
+	xdr_lpar = ps3_mm_phys_to_lpar(__pa(ps3fb_videomemory.address));
 	retval = ps3fb_xdr_settings(xdr_lpar, &dev->core);
 	if (retval)
 		goto err_free_irq;
@@ -1197,12 +1179,20 @@ static int __devinit ps3fb_probe(struct 
 	par->new_mode_id = ps3fb_mode;
 	par->num_frames = 1;
 
-	info->screen_base = (char __iomem *)ps3fb.xdr_ea;
 	info->fbops = &ps3fb_ops;
-
 	info->fix = ps3fb_fix;
-	info->fix.smem_start = virt_to_abs(ps3fb.xdr_ea);
-	info->fix.smem_len = ps3fb.xdr_size;
+
+	/*
+	 * The GPU command buffer is at the start of video memory
+	 * As we don't use the full command buffer, we can put the actual
+	 * frame buffer at offset GPU_FB_START and save some precious XDR
+	 * memory
+	 */
+	fb_start = ps3fb_videomemory.address + GPU_FB_START;
+	info->screen_base = (char __force __iomem *)fb_start;
+	info->fix.smem_start = virt_to_abs(fb_start);
+	info->fix.smem_len = ps3fb_videomemory.size - GPU_FB_START;
+
 	info->pseudo_palette = par->pseudo_palette;
 	info->flags = FBINFO_DEFAULT | FBINFO_READS_FAST |
 		      FBINFO_HWACCEL_XPAN | FBINFO_HWACCEL_YPAN;
@@ -1227,9 +1217,9 @@ static int __devinit ps3fb_probe(struct 
 
 	dev->core.driver_data = info;
 
-	dev_info(info->device, "%s %s, using %lu KiB of video memory\n",
+	dev_info(info->device, "%s %s, using %u KiB of video memory\n",
 		 dev_driver_string(info->dev), info->dev->bus_id,
-		 ps3fb.xdr_size >> 10);
+		 info->fix.smem_len >> 10);
 
 	task = kthread_run(ps3fbd, info, DEVICE_NAME);
 	if (IS_ERR(task)) {
@@ -1252,7 +1242,7 @@ err_free_irq:
 	free_irq(ps3fb.irq_no, &dev->core);
 	ps3_irq_plug_destroy(ps3fb.irq_no);
 err_iounmap_dinfo:
-	iounmap((u8 __iomem *)ps3fb.dinfo);
+	iounmap((u8 __force __iomem *)ps3fb.dinfo);
 err_gpu_context_free:
 	lv1_gpu_context_free(ps3fb.context_handle);
 err_gpu_memory_free:
@@ -1287,7 +1277,7 @@ static int ps3fb_shutdown(struct ps3_sys
 		framebuffer_release(info);
 		info = dev->core.driver_data = NULL;
 	}
-	iounmap((u8 __iomem *)ps3fb.dinfo);
+	iounmap((u8 __force __iomem *)ps3fb.dinfo);
 
 	status = lv1_gpu_context_free(ps3fb.context_handle);
 	if (status)
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
