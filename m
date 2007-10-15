From: akpm@linux-foundation.org
Subject: + ps3fb-convert-from-printk-dprintk-to-dev_-pr_.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:36:07 -0700
Message-ID: <200710152136.l9FLa7Kp026124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44620 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363AbXJOVgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: convert from printk()/DPRINTK() to dev_*()/pr_*()
has been added to the -mm tree.  Its filename is
     ps3fb-convert-from-printk-dprintk-to-dev_-pr_.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ps3fb: convert from printk()/DPRINTK() to dev_*()/pr_*()
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Convert ps3fb from printk()/DPRINTK() to dev_*()/pr_*()

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |  183 ++++++++++++++++++++--------------------
 1 file changed, 96 insertions(+), 87 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-convert-from-printk-dprintk-to-dev_-pr_ drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-convert-from-printk-dprintk-to-dev_-pr_
+++ a/drivers/video/ps3fb.c
@@ -48,12 +48,6 @@
 
 #define DEVICE_NAME		"ps3fb"
 
-#ifdef PS3FB_DEBUG
-#define DPRINTK(fmt, args...) printk("%s: " fmt, __func__ , ##args)
-#else
-#define DPRINTK(fmt, args...)
-#endif
-
 #define L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC	0x101
 #define L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP	0x102
 #define L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP	0x600
@@ -316,7 +310,7 @@ static int ps3fb_get_res_table(u32 xres,
 		f = ps3fb_res[i].type;
 
 		if (!x) {
-			DPRINTK("ERROR: ps3fb_get_res_table()\n");
+			pr_debug("ERROR: ps3fb_get_res_table()\n");
 			return -1;
 		}
 
@@ -357,11 +351,11 @@ static unsigned int ps3fb_find_mode(cons
 			/* Full broadcast modes have the full mode bit set */
 			mode = i > 12 ? (i - 12) | PS3FB_FULL_MODE_BIT : i + 1;
 
-			DPRINTK("ps3fb_find_mode: mode %u\n", mode);
+			pr_debug("ps3fb_find_mode: mode %u\n", mode);
 			return mode;
 		}
 
-	DPRINTK("ps3fb_find_mode: mode not found\n");
+	pr_debug("ps3fb_find_mode: mode not found\n");
 	return 0;
 
 }
@@ -384,7 +378,7 @@ static const struct fb_videomode *ps3fb_
 	return &ps3fb_modedb[mode - 1];
 }
 
-static int ps3fb_sync(u32 frame)
+static int ps3fb_sync(struct fb_info *info, u32 frame)
 {
 	int i, status;
 	u32 xres, yres;
@@ -395,8 +389,8 @@ static int ps3fb_sync(u32 frame)
 	yres = ps3fb_res[i].yres;
 
 	if (frame > ps3fb.num_frames - 1) {
-		printk(KERN_WARNING "%s: invalid frame number (%u)\n",
-		       __func__, frame);
+		dev_warn(info->device, "%s: invalid frame number (%u)\n",
+			 __func__, frame);
 		return -EINVAL;
 	}
 	offset = xres * yres * BPP * frame;
@@ -409,26 +403,26 @@ static int ps3fb_sync(u32 frame)
 					   (xres << 16) | yres,
 					   xres * BPP);	/* line_length */
 	if (status)
-		printk(KERN_ERR
-		       "%s: lv1_gpu_context_attribute FB_BLIT failed: %d\n",
-		       __func__, status);
+		dev_err(info->device,
+			"%s: lv1_gpu_context_attribute FB_BLIT failed: %d\n",
+			__func__, status);
 #ifdef HEAD_A
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP,
 					   0, offset, 0, 0);
 	if (status)
-		printk(KERN_ERR
-		       "%s: lv1_gpu_context_attribute FLIP failed: %d\n",
-		       __func__, status);
+		dev_err(info->device,
+			"%s: lv1_gpu_context_attribute FLIP failed: %d\n",
+			__func__, status);
 #endif
 #ifdef HEAD_B
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP,
 					   1, offset, 0, 0);
 	if (status)
-		printk(KERN_ERR
-		       "%s: lv1_gpu_context_attribute FLIP failed: %d\n",
-		       __func__, status);
+		dev_err(info->device,
+			"%s: lv1_gpu_context_attribute FLIP failed: %d\n",
+			__func__, status);
 #endif
 	return 0;
 }
@@ -445,7 +439,7 @@ static int ps3fb_release(struct fb_info 
 	if (atomic_dec_and_test(&ps3fb.f_count)) {
 		if (atomic_read(&ps3fb.ext_flip)) {
 			atomic_set(&ps3fb.ext_flip, 0);
-			ps3fb_sync(0);	/* single buffer */
+			ps3fb_sync(info, 0);	/* single buffer */
 		}
 	}
 	return 0;
@@ -465,8 +459,10 @@ static int ps3fb_check_var(struct fb_var
 	int mode;
 	int i;
 
-	DPRINTK("var->xres:%u info->var.xres:%u\n", var->xres, info->var.xres);
-	DPRINTK("var->yres:%u info->var.yres:%u\n", var->yres, info->var.yres);
+	dev_dbg(info->device, "var->xres:%u info->var.xres:%u\n", var->xres,
+		info->var.xres);
+	dev_dbg(info->device, "var->yres:%u info->var.yres:%u\n", var->yres,
+		info->var.yres);
 
 	/* FIXME For now we do exact matches only */
 	mode = ps3fb_find_mode(var, &line_length);
@@ -487,7 +483,8 @@ static int ps3fb_check_var(struct fb_var
 	/* Virtual screen and panning are not supported */
 	if (var->xres_virtual > var->xres || var->yres_virtual > var->yres ||
 	    var->xoffset || var->yoffset) {
-		DPRINTK("Virtual screen and panning are not supported\n");
+		dev_dbg(info->device,
+			"Virtual screen and panning are not supported\n");
 		return -EINVAL;
 	}
 
@@ -502,7 +499,7 @@ static int ps3fb_check_var(struct fb_var
 	    var->blue.length > 8 || var->transp.length > 8 ||
 	    var->red.msb_right || var->green.msb_right ||
 	    var->blue.msb_right || var->transp.msb_right || var->nonstd) {
-		DPRINTK("We support ARGB8888 only\n");
+		dev_dbg(info->device, "We support ARGB8888 only\n");
 		return -EINVAL;
 	}
 
@@ -522,14 +519,14 @@ static int ps3fb_check_var(struct fb_var
 
 	/* Rotation is not supported */
 	if (var->rotate) {
-		DPRINTK("Rotation is not supported\n");
+		dev_dbg(info->device, "Rotation is not supported\n");
 		return -EINVAL;
 	}
 
 	/* Memory limit */
 	i = ps3fb_get_res_table(var->xres, var->yres, mode);
 	if (ps3fb_res[i].xres*ps3fb_res[i].yres*BPP > ps3fb_videomemory.size) {
-		DPRINTK("Not enough memory\n");
+		dev_dbg(info->device, "Not enough memory\n");
 		return -ENOMEM;
 	}
 
@@ -549,7 +546,7 @@ static int ps3fb_set_par(struct fb_info 
 	int i;
 	unsigned long offset;
 
-	DPRINTK("xres:%d xv:%d yres:%d yv:%d clock:%d\n",
+	dev_dbg(info->device, "xres:%d xv:%d yres:%d yv:%d clock:%d\n",
 		info->var.xres, info->var.xres_virtual,
 		info->var.yres, info->var.yres_virtual, info->var.pixclock);
 
@@ -623,8 +620,8 @@ static int ps3fb_mmap(struct fb_info *in
 			    size, vma->vm_page_prot))
 		return -EAGAIN;
 
-	printk(KERN_DEBUG "ps3fb: mmap framebuffer P(%lx)->V(%lx)\n", offset,
-	       vma->vm_start);
+	dev_dbg(info->device, "ps3fb: mmap framebuffer P(%lx)->V(%lx)\n",
+		offset, vma->vm_start);
 	return 0;
 }
 
@@ -636,7 +633,7 @@ static int ps3fb_blank(int blank, struct
 {
 	int retval;
 
-	DPRINTK("%s: blank:%d\n", __func__, blank);
+	dev_dbg(info->device, "%s: blank:%d\n", __func__, blank);
 	switch (blank) {
 	case FB_BLANK_POWERDOWN:
 	case FB_BLANK_HSYNC_SUSPEND:
@@ -705,7 +702,7 @@ static int ps3fb_ioctl(struct fb_info *i
 	case FBIOGET_VBLANK:
 		{
 			struct fb_vblank vblank;
-			DPRINTK("FBIOGET_VBLANK:\n");
+			dev_dbg(info->device, "FBIOGET_VBLANK:\n");
 			retval = ps3fb_get_vblank(&vblank);
 			if (retval)
 				break;
@@ -718,7 +715,7 @@ static int ps3fb_ioctl(struct fb_info *i
 	case FBIO_WAITFORVSYNC:
 		{
 			u32 crt;
-			DPRINTK("FBIO_WAITFORVSYNC:\n");
+			dev_dbg(info->device, "FBIO_WAITFORVSYNC:\n");
 			if (get_user(crt, (u32 __user *) arg))
 				break;
 
@@ -739,7 +736,7 @@ static int ps3fb_ioctl(struct fb_info *i
 				if (id > 0)
 					val = (val & ~PS3AV_MODE_MASK) | id;
 			}
-			DPRINTK("PS3FB_IOCTL_SETMODE:%x\n", val);
+			dev_dbg(info->device, "PS3FB_IOCTL_SETMODE:%x\n", val);
 			retval = -EINVAL;
 			old_mode = ps3fb_mode;
 			ps3fb_mode = val;
@@ -762,7 +759,7 @@ static int ps3fb_ioctl(struct fb_info *i
 
 	case PS3FB_IOCTL_GETMODE:
 		val = ps3av_get_mode();
-		DPRINTK("PS3FB_IOCTL_GETMODE:%x\n", val);
+		dev_dbg(info->device, "PS3FB_IOCTL_GETMODE:%x\n", val);
 		if (!copy_to_user(argp, &val, sizeof(val)))
 			retval = 0;
 		break;
@@ -771,7 +768,7 @@ static int ps3fb_ioctl(struct fb_info *i
 		{
 			struct ps3fb_ioctl_res res;
 			int i = ps3fb.res_index;
-			DPRINTK("PS3FB_IOCTL_SCREENINFO:\n");
+			dev_dbg(info->device, "PS3FB_IOCTL_SCREENINFO:\n");
 			res.xres = ps3fb_res[i].xres;
 			res.yres = ps3fb_res[i].yres;
 			res.xoff = ps3fb_res[i].xoff;
@@ -783,13 +780,13 @@ static int ps3fb_ioctl(struct fb_info *i
 		}
 
 	case PS3FB_IOCTL_ON:
-		DPRINTK("PS3FB_IOCTL_ON:\n");
+		dev_dbg(info->device, "PS3FB_IOCTL_ON:\n");
 		atomic_inc(&ps3fb.ext_flip);
 		retval = 0;
 		break;
 
 	case PS3FB_IOCTL_OFF:
-		DPRINTK("PS3FB_IOCTL_OFF:\n");
+		dev_dbg(info->device, "PS3FB_IOCTL_OFF:\n");
 		atomic_dec_if_positive(&ps3fb.ext_flip);
 		retval = 0;
 		break;
@@ -798,8 +795,8 @@ static int ps3fb_ioctl(struct fb_info *i
 		if (copy_from_user(&val, argp, sizeof(val)))
 			break;
 
-		DPRINTK("PS3FB_IOCTL_FSEL:%d\n", val);
-		retval = ps3fb_sync(val);
+		dev_dbg(info->device, "PS3FB_IOCTL_FSEL:%d\n", val);
+		retval = ps3fb_sync(info, val);
 		break;
 
 	default:
@@ -811,13 +808,15 @@ static int ps3fb_ioctl(struct fb_info *i
 
 static int ps3fbd(void *arg)
 {
+	struct fb_info *info = arg;
+
 	set_freezable();
 	while (!kthread_should_stop()) {
 		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (ps3fb.is_kicked) {
 			ps3fb.is_kicked = 0;
-			ps3fb_sync(0);	/* single buffer */
+			ps3fb_sync(info, 0);	/* single buffer */
 		}
 		schedule();
 	}
@@ -826,14 +825,15 @@ static int ps3fbd(void *arg)
 
 static irqreturn_t ps3fb_vsync_interrupt(int irq, void *ptr)
 {
+	struct device *dev = ptr;
 	u64 v1;
 	int status;
 	struct display_head *head = &ps3fb.dinfo->display_head[1];
 
 	status = lv1_gpu_context_intr(ps3fb.context_handle, &v1);
 	if (status) {
-		printk(KERN_ERR "%s: lv1_gpu_context_intr failed: %d\n",
-		       __func__, status);
+		dev_err(dev, "%s: lv1_gpu_context_intr failed: %d\n", __func__,
+			status);
 		return IRQ_NONE;
 	}
 
@@ -853,35 +853,35 @@ static irqreturn_t ps3fb_vsync_interrupt
 
 
 static int ps3fb_vsync_settings(struct gpu_driver_info *dinfo,
-				struct ps3_system_bus_device *dev)
+				struct device *dev)
 {
 	int error;
 
-	DPRINTK("version_driver:%x\n", dinfo->version_driver);
-	DPRINTK("irq outlet:%x\n", dinfo->irq.irq_outlet);
-	DPRINTK("version_gpu:%x memory_size:%x ch:%x core_freq:%d mem_freq:%d\n",
+	dev_dbg(dev, "version_driver:%x\n", dinfo->version_driver);
+	dev_dbg(dev, "irq outlet:%x\n", dinfo->irq.irq_outlet);
+	dev_dbg(dev,
+		"version_gpu: %x memory_size: %x ch: %x core_freq: %d "
+		"mem_freq:%d\n",
 		dinfo->version_gpu, dinfo->memory_size, dinfo->hardware_channel,
 		dinfo->nvcore_frequency/1000000, dinfo->memory_frequency/1000000);
 
 	if (dinfo->version_driver != GPU_DRIVER_INFO_VERSION) {
-		printk(KERN_ERR "%s: version_driver err:%x\n", __func__,
-		       dinfo->version_driver);
+		dev_err(dev, "%s: version_driver err:%x\n", __func__,
+			dinfo->version_driver);
 		return -EINVAL;
 	}
 
 	error = ps3_irq_plug_setup(PS3_BINDING_CPU_ANY, dinfo->irq.irq_outlet,
 				   &ps3fb.irq_no);
 	if (error) {
-		printk(KERN_ERR "%s: ps3_alloc_irq failed %d\n", __func__,
-		       error);
+		dev_err(dev, "%s: ps3_alloc_irq failed %d\n", __func__, error);
 		return error;
 	}
 
 	error = request_irq(ps3fb.irq_no, ps3fb_vsync_interrupt, IRQF_DISABLED,
 			    DEVICE_NAME, dev);
 	if (error) {
-		printk(KERN_ERR "%s: request_irq failed %d\n", __func__,
-		       error);
+		dev_err(dev, "%s: request_irq failed %d\n", __func__, error);
 		ps3_irq_plug_destroy(ps3fb.irq_no);
 		return error;
 	}
@@ -891,18 +891,19 @@ static int ps3fb_vsync_settings(struct g
 	return 0;
 }
 
-static int ps3fb_xdr_settings(u64 xdr_lpar)
+static int ps3fb_xdr_settings(u64 xdr_lpar, struct device *dev)
 {
 	int status;
 
 	status = lv1_gpu_context_iomap(ps3fb.context_handle, GPU_IOIF,
 				       xdr_lpar, ps3fb_videomemory.size, 0);
 	if (status) {
-		printk(KERN_ERR "%s: lv1_gpu_context_iomap failed: %d\n",
-		       __func__, status);
+		dev_err(dev, "%s: lv1_gpu_context_iomap failed: %d\n",
+			__func__, status);
 		return -ENXIO;
 	}
-	DPRINTK("video:%p xdr_ea:%p ioif:%lx lpar:%lx phys:%lx size:%lx\n",
+	dev_dbg(dev,
+		"video:%p xdr_ea:%p ioif:%lx lpar:%lx phys:%lx size:%lx\n",
 		ps3fb_videomemory.address, ps3fb.xdr_ea, GPU_IOIF, xdr_lpar,
 		virt_to_abs(ps3fb.xdr_ea), ps3fb_videomemory.size);
 
@@ -911,9 +912,9 @@ static int ps3fb_xdr_settings(u64 xdr_lp
 					   xdr_lpar, ps3fb_videomemory.size,
 					   GPU_IOIF, 0);
 	if (status) {
-		printk(KERN_ERR
-		       "%s: lv1_gpu_context_attribute FB_SETUP failed: %d\n",
-		       __func__, status);
+		dev_err(dev,
+			"%s: lv1_gpu_context_attribute FB_SETUP failed: %d\n",
+			__func__, status);
 		return -ENXIO;
 	}
 	return 0;
@@ -943,7 +944,7 @@ static struct fb_fix_screeninfo ps3fb_fi
 	.accel =	FB_ACCEL_NONE,
 };
 
-static int ps3fb_set_sync(void)
+static int ps3fb_set_sync(struct device *dev)
 {
 	int status;
 
@@ -952,8 +953,10 @@ static int ps3fb_set_sync(void)
 					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC,
 					   0, L1GPU_DISPLAY_SYNC_VSYNC, 0, 0);
 	if (status) {
-		printk(KERN_ERR "%s: lv1_gpu_context_attribute DISPLAY_SYNC "
-		       "failed: %d\n", __func__, status);
+		dev_err(dev,
+			"%s: lv1_gpu_context_attribute DISPLAY_SYNC failed: "
+			"%d\n",
+			__func__, status);
 		return -1;
 	}
 #endif
@@ -963,8 +966,10 @@ static int ps3fb_set_sync(void)
 					   1, L1GPU_DISPLAY_SYNC_VSYNC, 0, 0);
 
 	if (status) {
-		printk(KERN_ERR "%s: lv1_gpu_context_attribute DISPLAY_MODE "
-		       "failed: %d\n", __func__, status);
+		dev_err(dev,
+			"%s: lv1_gpu_context_attribute DISPLAY_SYNC failed: "
+			"%d\n",
+			__func__, status);
 		return -1;
 	}
 #endif
@@ -988,18 +993,19 @@ static int __devinit ps3fb_probe(struct 
 
 	status = ps3_open_hv_device(dev);
 	if (status) {
-		printk(KERN_ERR "%s: ps3_open_hv_device failed\n", __func__);
+		dev_err(&dev->core, "%s: ps3_open_hv_device failed\n",
+			__func__);
 		goto err;
 	}
 
 	if (!ps3fb_mode)
 		ps3fb_mode = ps3av_get_mode();
-	DPRINTK("ps3av_mode:%d\n", ps3fb_mode);
+	dev_dbg(&dev->core, "ps3av_mode:%d\n", ps3fb_mode);
 
 	if (ps3fb_mode > 0 &&
 	    !ps3av_video_mode2res(ps3fb_mode, &xres, &yres)) {
 		ps3fb.res_index = ps3fb_get_res_table(xres, yres, ps3fb_mode);
-		DPRINTK("res_index:%d\n", ps3fb.res_index);
+		dev_dbg(&dev->core, "res_index:%d\n", ps3fb.res_index);
 	} else
 		ps3fb.res_index = GPU_RES_INDEX;
 
@@ -1008,43 +1014,44 @@ static int __devinit ps3fb_probe(struct 
 	init_waitqueue_head(&ps3fb.wait_vsync);
 	ps3fb.num_frames = 1;
 
-	ps3fb_set_sync();
+	ps3fb_set_sync(&dev->core);
 
 	/* get gpu context handle */
 	status = lv1_gpu_memory_allocate(DDR_SIZE, 0, 0, 0, 0,
 					 &ps3fb.memory_handle, &ddr_lpar);
 	if (status) {
-		printk(KERN_ERR "%s: lv1_gpu_memory_allocate failed: %d\n",
-		       __func__, status);
+		dev_err(&dev->core, "%s: lv1_gpu_memory_allocate failed: %d\n",
+			__func__, status);
 		goto err;
 	}
-	DPRINTK("ddr:lpar:0x%lx\n", ddr_lpar);
+	dev_dbg(&dev->core, "ddr:lpar:0x%lx\n", ddr_lpar);
 
 	status = lv1_gpu_context_allocate(ps3fb.memory_handle, 0,
 					  &ps3fb.context_handle,
 					  &lpar_dma_control, &lpar_driver_info,
 					  &lpar_reports, &lpar_reports_size);
 	if (status) {
-		printk(KERN_ERR "%s: lv1_gpu_context_attribute failed: %d\n",
-		       __func__, status);
+		dev_err(&dev->core,
+			"%s: lv1_gpu_context_attribute failed: %d\n", __func__,
+			status);
 		goto err_gpu_memory_free;
 	}
 
 	/* vsync interrupt */
 	ps3fb.dinfo = ioremap(lpar_driver_info, 128 * 1024);
 	if (!ps3fb.dinfo) {
-		printk(KERN_ERR "%s: ioremap failed\n", __func__);
+		dev_err(&dev->core, "%s: ioremap failed\n", __func__);
 		goto err_gpu_context_free;
 	}
 
-	retval = ps3fb_vsync_settings(ps3fb.dinfo, dev);
+	retval = ps3fb_vsync_settings(ps3fb.dinfo, &dev->core);
 	if (retval)
 		goto err_iounmap_dinfo;
 
 	/* xdr frame buffer */
 	ps3fb.xdr_ea = ps3fb_videomemory.address;
 	xdr_lpar = ps3_mm_phys_to_lpar(__pa(ps3fb.xdr_ea));
-	retval = ps3fb_xdr_settings(xdr_lpar);
+	retval = ps3fb_xdr_settings(xdr_lpar, &dev->core);
 	if (retval)
 		goto err_free_irq;
 
@@ -1087,9 +1094,9 @@ static int __devinit ps3fb_probe(struct 
 
 	dev->core.driver_data = info;
 
-	printk(KERN_INFO
-	       "fb%d: PS3 frame buffer device, using %ld KiB of video memory\n",
-	       info->node, ps3fb_videomemory.size >> 10);
+	dev_info(info->device, "%s %s, using %lu KiB of video memory\n",
+		 dev_driver_string(info->dev), info->dev->bus_id,
+		 ps3fb_videomemory.size >> 10);
 
 	task = kthread_run(ps3fbd, info, DEVICE_NAME);
 	if (IS_ERR(task)) {
@@ -1126,7 +1133,7 @@ static int ps3fb_shutdown(struct ps3_sys
 	int status;
 	struct fb_info *info = dev->core.driver_data;
 
-	DPRINTK(" -> %s:%d\n", __func__, __LINE__);
+	dev_dbg(&dev->core, " -> %s:%d\n", __func__, __LINE__);
 
 	ps3fb_flip_ctl(0, &ps3fb);	/* flip off */
 	ps3fb.dinfo->irq.mask = 0;
@@ -1151,14 +1158,16 @@ static int ps3fb_shutdown(struct ps3_sys
 
 	status = lv1_gpu_context_free(ps3fb.context_handle);
 	if (status)
-		DPRINTK("lv1_gpu_context_free failed: %d\n", status);
+		dev_dbg(&dev->core, "lv1_gpu_context_free failed: %d\n",
+			status);
 
 	status = lv1_gpu_memory_free(ps3fb.memory_handle);
 	if (status)
-		DPRINTK("lv1_gpu_memory_free failed: %d\n", status);
+		dev_dbg(&dev->core, "lv1_gpu_memory_free failed: %d\n",
+			status);
 
 	ps3_close_hv_device(dev);
-	DPRINTK(" <- %s:%d\n", __func__, __LINE__);
+	dev_dbg(&dev->core, " <- %s:%d\n", __func__, __LINE__);
 
 	return 0;
 }
@@ -1211,9 +1220,9 @@ static int __init ps3fb_init(void)
 
 static void __exit ps3fb_exit(void)
 {
-	DPRINTK(" -> %s:%d\n", __func__, __LINE__);
+	pr_debug(" -> %s:%d\n", __func__, __LINE__);
 	ps3_system_bus_driver_unregister(&ps3fb_driver);
-	DPRINTK(" <- %s:%d\n", __func__, __LINE__);
+	pr_debug(" <- %s:%d\n", __func__, __LINE__);
 }
 
 module_init(ps3fb_init);
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
