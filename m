From: akpm@linux-foundation.org
Subject: - ps3fb-use-fb_infopar-properly.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:34 -0700
Message-ID: <200710162045.l9GKjYc6016277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965498AbXJPU5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ps3fb: use fb_info.par properly
has been removed from the -mm tree.  Its filename was
     ps3fb-use-fb_infopar-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: use fb_info.par properly
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Use fb_info.par properly:
  o Move mode-specific fields into struct ps3fb_par
  o Allocate struct ps3fb_par using framebuffer_alloc()
  o Protect access to ps3fb_par in ps3fb_sync() using the console semaphore
    (this semaphore is already held when ps3fb_set_par() is called)
  o Avoid calling ps3av_set_video_mode() if the actual video mode hasn't
    changed

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   92 ++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 35 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-use-fb_infopar-properly drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-use-fb_infopar-properly
+++ a/drivers/video/ps3fb.c
@@ -119,12 +119,10 @@ struct ps3fb_priv {
 	void *xdr_ea;
 	size_t xdr_size;
 	struct gpu_driver_info *dinfo;
-	u32 res_index;
 
 	u64 vblank_count;	/* frame count */
 	wait_queue_head_t wait_vsync;
 
-	u32 num_frames;		/* num of frame buffers */
 	atomic_t ext_flip;	/* on/off flip with vsync */
 	atomic_t f_count;	/* fb_open count */
 	int is_blanked;
@@ -133,6 +131,13 @@ struct ps3fb_priv {
 };
 static struct ps3fb_priv ps3fb;
 
+struct ps3fb_par {
+	u32 pseudo_palette[16];
+	int mode_id, new_mode_id;
+	int res_index;
+	unsigned int num_frames;	/* num of frame buffers */
+};
+
 struct ps3fb_res_table {
 	u32 xres;
 	u32 yres;
@@ -361,18 +366,17 @@ static unsigned int ps3fb_find_mode(cons
 
 	pr_debug("ps3fb_find_mode: mode not found\n");
 	return 0;
-
 }
 
-static const struct fb_videomode *ps3fb_default_mode(void)
+static const struct fb_videomode *ps3fb_default_mode(int id)
 {
-	u32 mode = ps3fb_mode & PS3AV_MODE_MASK;
+	u32 mode = id & PS3AV_MODE_MASK;
 	u32 flags;
 
 	if (mode < 1 || mode > 13)
 		return NULL;
 
-	flags = ps3fb_mode & ~PS3AV_MODE_MASK;
+	flags = id & ~PS3AV_MODE_MASK;
 
 	if (mode <= 10 && flags & PS3FB_FULL_MODE_BIT) {
 		/* Full broadcast mode */
@@ -384,18 +388,22 @@ static const struct fb_videomode *ps3fb_
 
 static int ps3fb_sync(struct fb_info *info, u32 frame)
 {
-	int i, status;
+	struct ps3fb_par *par = info->par;
+	int i, status, error = 0;
 	u32 xres, yres;
 	u64 fb_ioif, offset;
 
-	i = ps3fb.res_index;
+	acquire_console_sem();
+
+	i = par->res_index;
 	xres = ps3fb_res[i].xres;
 	yres = ps3fb_res[i].yres;
 
-	if (frame > ps3fb.num_frames - 1) {
+	if (frame > par->num_frames - 1) {
 		dev_dbg(info->device, "%s: invalid frame number (%u)\n",
 			__func__, frame);
-		return -EINVAL;
+		error = -EINVAL;
+		goto out;
 	}
 	offset = xres * yres * BPP * frame;
 
@@ -428,7 +436,10 @@ static int ps3fb_sync(struct fb_info *in
 			"%s: lv1_gpu_context_attribute FLIP failed: %d\n",
 			__func__, status);
 #endif
-	return 0;
+
+out:
+	release_console_sem();
+	return error;
 }
 
 
@@ -547,6 +558,7 @@ static int ps3fb_check_var(struct fb_var
 
 static int ps3fb_set_par(struct fb_info *info)
 {
+	struct ps3fb_par *par = info->par;
 	unsigned int mode;
 	int i;
 	unsigned long offset;
@@ -560,7 +572,7 @@ static int ps3fb_set_par(struct fb_info 
 		return -EINVAL;
 
 	i = ps3fb_get_res_table(info->var.xres, info->var.yres, mode);
-	ps3fb.res_index = i;
+	par->res_index = i;
 
 	offset = VFB_OFF(i);
 	info->fix.smem_start = virt_to_abs(ps3fb.xdr_ea) + offset;
@@ -568,14 +580,19 @@ static int ps3fb_set_par(struct fb_info 
 	info->screen_base = (char __iomem *)ps3fb.xdr_ea + offset;
 	memset(ps3fb.xdr_ea, 0, ps3fb.xdr_size);
 
-	ps3fb.num_frames = info->fix.smem_len/
-			   (ps3fb_res[i].xres*ps3fb_res[i].yres*BPP);
+	par->num_frames = info->fix.smem_len/
+			  (ps3fb_res[i].xres*ps3fb_res[i].yres*BPP);
 
 	/* Keep the special bits we cannot set using fb_var_screeninfo */
-	ps3fb_mode = (ps3fb_mode & ~PS3AV_MODE_MASK) | mode;
+	par->new_mode_id = (par->new_mode_id & ~PS3AV_MODE_MASK) | mode;
 
-	if (ps3av_set_video_mode(ps3fb_mode))
-		return -EINVAL;
+	if (par->new_mode_id != par->mode_id) {
+		if (ps3av_set_video_mode(par->new_mode_id)) {
+			par->new_mode_id = par->mode_id;
+			return -EINVAL;
+		}
+		par->mode_id = par->new_mode_id;
+	}
 
 	return 0;
 }
@@ -694,7 +711,7 @@ static int ps3fb_ioctl(struct fb_info *i
 		       unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
-	u32 val, old_mode;
+	u32 val;
 	int retval = -EFAULT;
 
 	switch (cmd) {
@@ -724,6 +741,7 @@ static int ps3fb_ioctl(struct fb_info *i
 
 	case PS3FB_IOCTL_SETMODE:
 		{
+			struct ps3fb_par *par = info->par;
 			const struct fb_videomode *mode;
 			struct fb_var_screeninfo var;
 
@@ -737,9 +755,7 @@ static int ps3fb_ioctl(struct fb_info *i
 			}
 			dev_dbg(info->device, "PS3FB_IOCTL_SETMODE:%x\n", val);
 			retval = -EINVAL;
-			old_mode = ps3fb_mode;
-			ps3fb_mode = val;
-			mode = ps3fb_default_mode();
+			mode = ps3fb_default_mode(val);
 			if (mode) {
 				var = info->var;
 				fb_videomode_to_var(&var, mode);
@@ -747,12 +763,11 @@ static int ps3fb_ioctl(struct fb_info *i
 				info->flags |= FBINFO_MISC_USEREVENT;
 				/* Force, in case only special bits changed */
 				var.activate |= FB_ACTIVATE_FORCE;
+				par->new_mode_id = val;
 				retval = fb_set_var(info, &var);
 				info->flags &= ~FBINFO_MISC_USEREVENT;
 				release_console_sem();
 			}
-			if (retval)
-				ps3fb_mode = old_mode;
 			break;
 		}
 
@@ -765,14 +780,15 @@ static int ps3fb_ioctl(struct fb_info *i
 
 	case PS3FB_IOCTL_SCREENINFO:
 		{
+			struct ps3fb_par *par = info->par;
 			struct ps3fb_ioctl_res res;
-			int i = ps3fb.res_index;
+			int i = par->res_index;
 			dev_dbg(info->device, "PS3FB_IOCTL_SCREENINFO:\n");
 			res.xres = ps3fb_res[i].xres;
 			res.yres = ps3fb_res[i].yres;
 			res.xoff = ps3fb_res[i].xoff;
 			res.yoff = ps3fb_res[i].yoff;
-			res.num_frames = ps3fb.num_frames;
+			res.num_frames = par->num_frames;
 			if (!copy_to_user(argp, &res, sizeof(res)))
 				retval = 0;
 			break;
@@ -979,6 +995,7 @@ static int ps3fb_set_sync(struct device 
 static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 {
 	struct fb_info *info;
+	struct ps3fb_par *par;
 	int retval = -ENOMEM;
 	u32 xres, yres;
 	u64 ddr_lpar = 0;
@@ -987,7 +1004,7 @@ static int __devinit ps3fb_probe(struct 
 	u64 lpar_reports = 0;
 	u64 lpar_reports_size = 0;
 	u64 xdr_lpar;
-	int status;
+	int status, res_index;
 	unsigned long offset;
 	struct task_struct *task;
 
@@ -1004,15 +1021,14 @@ static int __devinit ps3fb_probe(struct 
 
 	if (ps3fb_mode > 0 &&
 	    !ps3av_video_mode2res(ps3fb_mode, &xres, &yres)) {
-		ps3fb.res_index = ps3fb_get_res_table(xres, yres, ps3fb_mode);
-		dev_dbg(&dev->core, "res_index:%d\n", ps3fb.res_index);
+		res_index = ps3fb_get_res_table(xres, yres, ps3fb_mode);
+		dev_dbg(&dev->core, "res_index:%d\n", res_index);
 	} else
-		ps3fb.res_index = GPU_RES_INDEX;
+		res_index = GPU_RES_INDEX;
 
 	atomic_set(&ps3fb.f_count, -1);	/* fbcon opens ps3fb */
 	atomic_set(&ps3fb.ext_flip, 0);	/* for flip with vsync */
 	init_waitqueue_head(&ps3fb.wait_vsync);
-	ps3fb.num_frames = 1;
 
 	ps3fb_set_sync(&dev->core);
 
@@ -1062,19 +1078,24 @@ static int __devinit ps3fb_probe(struct 
 	if (retval)
 		goto err_free_irq;
 
-	info = framebuffer_alloc(sizeof(u32) * 16, &dev->core);
+	info = framebuffer_alloc(sizeof(struct ps3fb_par), &dev->core);
 	if (!info)
 		goto err_free_irq;
 
-	offset = VFB_OFF(ps3fb.res_index);
+	par = info->par;
+	par->mode_id = ~ps3fb_mode;	/* != ps3fb_mode, to trigger change */
+	par->new_mode_id = ps3fb_mode;
+	par->res_index = res_index;
+	par->num_frames = 1;
+
+	offset = VFB_OFF(res_index);
 	info->screen_base = (char __iomem *)ps3fb.xdr_ea + offset;
 	info->fbops = &ps3fb_ops;
 
 	info->fix = ps3fb_fix;
 	info->fix.smem_start = virt_to_abs(ps3fb.xdr_ea) + offset;
 	info->fix.smem_len = ps3fb.xdr_size - offset;
-	info->pseudo_palette = info->par;
-	info->par = NULL;
+	info->pseudo_palette = par->pseudo_palette;
 	info->flags = FBINFO_DEFAULT | FBINFO_READS_FAST;
 
 	retval = fb_alloc_cmap(&info->cmap, 256, 0);
@@ -1082,7 +1103,8 @@ static int __devinit ps3fb_probe(struct 
 		goto err_framebuffer_release;
 
 	if (!fb_find_mode(&info->var, info, mode_option, ps3fb_modedb,
-			  ARRAY_SIZE(ps3fb_modedb), ps3fb_default_mode(), 32)) {
+			  ARRAY_SIZE(ps3fb_modedb),
+			  ps3fb_default_mode(par->new_mode_id), 32)) {
 		retval = -EINVAL;
 		goto err_fb_dealloc;
 	}
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
