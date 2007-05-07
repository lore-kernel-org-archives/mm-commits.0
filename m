From: akpm@linux-foundation.org
Subject: - ps3fb-use-__func__-instead-of-__function__.patch removed from -mm tree
Date: Mon, 07 May 2007 00:00:29 -0700
Message-ID: <200705070700.l4770TSC021020@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114AbXEGHBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 03:01:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ps3fb: Use __func__ instead of __FUNCTION__
has been removed from the -mm tree.  Its filename was
     ps3fb-use-__func__-instead-of-__function__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: Use __func__ instead of __FUNCTION__
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: Replace GNU extension `__FUNCTION__' by C99 `__func__'

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |   54 ++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-use-__func__-instead-of-__function__ drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-use-__func__-instead-of-__function__
+++ a/drivers/video/ps3fb.c
@@ -47,7 +47,7 @@
 #include <asm/ps3.h>
 
 #ifdef PS3FB_DEBUG
-#define DPRINTK(fmt, args...) printk("%s: " fmt, __FUNCTION__ , ##args)
+#define DPRINTK(fmt, args...) printk("%s: " fmt, __func__ , ##args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
@@ -396,7 +396,7 @@ static int ps3fb_sync(u32 frame)
 
 	if (frame > ps3fb.num_frames - 1) {
 		printk(KERN_WARNING "%s: invalid frame number (%u)\n",
-		       __FUNCTION__, frame);
+		       __func__, frame);
 		return -EINVAL;
 	}
 	offset = xres * yres * BPP * frame;
@@ -409,23 +409,26 @@ static int ps3fb_sync(u32 frame)
 					   (xres << 16) | yres,
 					   xres * BPP);	/* line_length */
 	if (status)
-		printk(KERN_ERR "%s: lv1_gpu_context_attribute FB_BLIT failed: %d\n",
-		       __FUNCTION__, status);
+		printk(KERN_ERR
+		       "%s: lv1_gpu_context_attribute FB_BLIT failed: %d\n",
+		       __func__, status);
 #ifdef HEAD_A
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP,
 					   0, offset, 0, 0);
 	if (status)
-		printk(KERN_ERR "%s: lv1_gpu_context_attribute FLIP failed: %d\n",
-		       __FUNCTION__, status);
+		printk(KERN_ERR
+		       "%s: lv1_gpu_context_attribute FLIP failed: %d\n",
+		       __func__, status);
 #endif
 #ifdef HEAD_B
 	status = lv1_gpu_context_attribute(ps3fb.context_handle,
 					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP,
 					   1, offset, 0, 0);
 	if (status)
-		printk(KERN_ERR "%s: lv1_gpu_context_attribute FLIP failed: %d\n",
-		       __FUNCTION__, status);
+		printk(KERN_ERR
+		       "%s: lv1_gpu_context_attribute FLIP failed: %d\n",
+		       __func__, status);
 #endif
 	return 0;
 }
@@ -634,7 +637,7 @@ static int ps3fb_blank(int blank, struct
 {
 	int retval;
 
-	DPRINTK("%s: blank:%d\n", __FUNCTION__, blank);
+	DPRINTK("%s: blank:%d\n", __func__, blank);
 	switch (blank) {
 	case FB_BLANK_POWERDOWN:
 	case FB_BLANK_HSYNC_SUSPEND:
@@ -830,7 +833,7 @@ static irqreturn_t ps3fb_vsync_interrupt
 	status = lv1_gpu_context_intr(ps3fb.context_handle, &v1);
 	if (status) {
 		printk(KERN_ERR "%s: lv1_gpu_context_intr failed: %d\n",
-		       __FUNCTION__, status);
+		       __func__, status);
 		return IRQ_NONE;
 	}
 
@@ -889,7 +892,7 @@ static int ps3fb_vsync_settings(struct g
 		dinfo->nvcore_frequency/1000000, dinfo->memory_frequency/1000000);
 
 	if (dinfo->version_driver != GPU_DRIVER_INFO_VERSION) {
-		printk(KERN_ERR "%s: version_driver err:%x\n", __FUNCTION__,
+		printk(KERN_ERR "%s: version_driver err:%x\n", __func__,
 		       dinfo->version_driver);
 		return -EINVAL;
 	}
@@ -898,7 +901,7 @@ static int ps3fb_vsync_settings(struct g
 	error = ps3_alloc_irq(PS3_BINDING_CPU_ANY, dinfo->irq.irq_outlet,
 			      &ps3fb.irq_no);
 	if (error) {
-		printk(KERN_ERR "%s: ps3_alloc_irq failed %d\n", __FUNCTION__,
+		printk(KERN_ERR "%s: ps3_alloc_irq failed %d\n", __func__,
 		       error);
 		return error;
 	}
@@ -906,7 +909,7 @@ static int ps3fb_vsync_settings(struct g
 	error = request_irq(ps3fb.irq_no, ps3fb_vsync_interrupt, IRQF_DISABLED,
 			    "ps3fb vsync", ps3fb.dev);
 	if (error) {
-		printk(KERN_ERR "%s: request_irq failed %d\n", __FUNCTION__,
+		printk(KERN_ERR "%s: request_irq failed %d\n", __func__,
 		       error);
 		ps3_free_irq(ps3fb.irq_no);
 		return error;
@@ -925,7 +928,7 @@ static int ps3fb_xdr_settings(u64 xdr_lp
 				       xdr_lpar, ps3fb_videomemory.size, 0);
 	if (status) {
 		printk(KERN_ERR "%s: lv1_gpu_context_iomap failed: %d\n",
-		       __FUNCTION__, status);
+		       __func__, status);
 		return -ENXIO;
 	}
 	DPRINTK("video:%p xdr_ea:%p ioif:%lx lpar:%lx phys:%lx size:%lx\n",
@@ -937,8 +940,9 @@ static int ps3fb_xdr_settings(u64 xdr_lp
 					   xdr_lpar, ps3fb_videomemory.size,
 					   GPU_IOIF, 0);
 	if (status) {
-		printk(KERN_ERR "%s: lv1_gpu_context_attribute FB_SETUP failed: %d\n",
-		       __FUNCTION__, status);
+		printk(KERN_ERR
+		       "%s: lv1_gpu_context_attribute FB_SETUP failed: %d\n",
+		       __func__, status);
 		return -ENXIO;
 	}
 	return 0;
@@ -985,7 +989,7 @@ static int __init ps3fb_probe(struct pla
 					 &ps3fb.memory_handle, &ddr_lpar);
 	if (status) {
 		printk(KERN_ERR "%s: lv1_gpu_memory_allocate failed: %d\n",
-		       __FUNCTION__, status);
+		       __func__, status);
 		goto err;
 	}
 	DPRINTK("ddr:lpar:0x%lx\n", ddr_lpar);
@@ -996,14 +1000,14 @@ static int __init ps3fb_probe(struct pla
 					  &lpar_reports, &lpar_reports_size);
 	if (status) {
 		printk(KERN_ERR "%s: lv1_gpu_context_attribute failed: %d\n",
-		       __FUNCTION__, status);
+		       __func__, status);
 		goto err_gpu_memory_free;
 	}
 
 	/* vsync interrupt */
 	ps3fb.dinfo = ioremap(lpar_driver_info, 128 * 1024);
 	if (!ps3fb.dinfo) {
-		printk(KERN_ERR "%s: ioremap failed\n", __FUNCTION__);
+		printk(KERN_ERR "%s: ioremap failed\n", __func__);
 		goto err_gpu_context_free;
 	}
 
@@ -1162,8 +1166,9 @@ int ps3fb_set_sync(void)
 					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC,
 					   0, L1GPU_DISPLAY_SYNC_VSYNC, 0, 0);
 	if (status) {
-		printk(KERN_ERR "%s: lv1_gpu_context_attribute DISPLAY_SYNC failed: %d\n",
-		       __FUNCTION__, status);
+		printk(KERN_ERR
+		       "%s: lv1_gpu_context_attribute DISPLAY_SYNC failed: %d\n",
+		       __func__, status);
 		return -1;
 	}
 #endif
@@ -1173,8 +1178,9 @@ int ps3fb_set_sync(void)
 					   1, L1GPU_DISPLAY_SYNC_VSYNC, 0, 0);
 
 	if (status) {
-		printk(KERN_ERR "%s: lv1_gpu_context_attribute DISPLAY_MODE failed: %d\n",
-		       __FUNCTION__, status);
+		printk(KERN_ERR
+		       "%s: lv1_gpu_context_attribute DISPLAY_MODE failed: %d\n",
+		       __func__, status);
 		return -1;
 	}
 #endif
@@ -1199,7 +1205,7 @@ static int __init ps3fb_init(void)
 
 	error = ps3av_dev_open();
 	if (error) {
-		printk(KERN_ERR "%s: ps3av_dev_open failed\n", __FUNCTION__);
+		printk(KERN_ERR "%s: ps3av_dev_open failed\n", __func__);
 		goto err;
 	}
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
