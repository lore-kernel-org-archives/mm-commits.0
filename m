From: akpm@linux-foundation.org
Subject: [merged] sm501-implement-acceleration-features.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:10 -0800
Message-ID: <200912162036.nBGKaAsI013148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935418AbZLPUgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vince@simtec.co.uk, ben@simtec.co.uk, krzysztof.h1@poczta.fm, linux@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     sm501: implement acceleration features
has been removed from the -mm tree.  Its filename was
     sm501-implement-acceleration-features.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501: implement acceleration features
From: Vincent Sanders <vince@simtec.co.uk>

This patch provides the acceleration entry points for the SM501
framebuffer driver.

This patch provides the sync, copyarea and fillrect entry points, using
the SM501's 2D acceleration engine to perform the operations in-chip
rather than across the bus.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c    |  237 +++++++++++++++++++++++++++++++++--
 include/linux/sm501-regs.h |    2 
 2 files changed, 226 insertions(+), 13 deletions(-)

diff -puN drivers/video/sm501fb.c~sm501-implement-acceleration-features drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501-implement-acceleration-features
+++ a/drivers/video/sm501fb.c
@@ -66,6 +66,7 @@ struct sm501fb_info {
 	struct fb_info		*fb[2];		/* fb info for both heads */
 	struct resource		*fbmem_res;	/* framebuffer resource */
 	struct resource		*regs_res;	/* registers resource */
+	struct resource		*regs2d_res;	/* 2d registers resource */
 	struct sm501_platdata_fb *pdata;	/* our platform data */
 
 	unsigned long		 pm_crt_ctrl;	/* pm: crt ctrl save */
@@ -73,6 +74,7 @@ struct sm501fb_info {
 	int			 irq;
 	int			 swap_endian;	/* set to swap rgb=>bgr */
 	void __iomem		*regs;		/* remapped registers */
+	void __iomem		*regs2d;	/* 2d remapped registers */
 	void __iomem		*fbmem;		/* remapped framebuffer */
 	size_t			 fbmem_len;	/* length of remapped region */
 };
@@ -123,9 +125,9 @@ static inline void sm501fb_sync_regs(str
  * This is an attempt to lay out memory for the two framebuffers and
  * everything else
  *
- * |fbmem_res->start	                                       fbmem_res->end|
- * |                                                                         |
- * |fb[0].fix.smem_start    |         |fb[1].fix.smem_start    |     2K      |
+ * |fbmem_res->start					       fbmem_res->end|
+ * |									     |
+ * |fb[0].fix.smem_start    |	      |fb[1].fix.smem_start    |     2K	     |
  * |-> fb[0].fix.smem_len <-| spare   |-> fb[1].fix.smem_len <-|-> cursors <-|
  *
  * The "spare" space is for the 2d engine data
@@ -1246,7 +1248,173 @@ static ssize_t sm501fb_debug_show_pnl(st
 
 static DEVICE_ATTR(fbregs_pnl, 0444, sm501fb_debug_show_pnl, NULL);
 
-/* framebuffer ops */
+/* acceleration operations */
+static int sm501fb_sync(struct fb_info *info)
+{
+	int count = 1000000;
+	struct sm501fb_par  *par = info->par;
+	struct sm501fb_info *fbi = par->info;
+
+	/* wait for the 2d engine to be ready */
+	while ((count > 0) &&
+	       (readl(fbi->regs + SM501_SYSTEM_CONTROL) &
+		SM501_SYSCTRL_2D_ENGINE_STATUS) != 0)
+		count--;
+
+	if (count <= 0) {
+		dev_err(info->dev, "Timeout waiting for 2d engine sync\n");
+		return 1;
+	}
+	return 0;
+}
+
+static void sm501fb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
+{
+	struct sm501fb_par  *par = info->par;
+	struct sm501fb_info *fbi = par->info;
+	int width = area->width;
+	int height = area->height;
+	int sx = area->sx;
+	int sy = area->sy;
+	int dx = area->dx;
+	int dy = area->dy;
+	unsigned long rtl = 0;
+
+	/* source clip */
+	if ((sx >= info->var.xres_virtual) ||
+	    (sy >= info->var.yres_virtual))
+		/* source Area not within virtual screen, skipping */
+		return;
+	if ((sx + width) >= info->var.xres_virtual)
+		width = info->var.xres_virtual - sx - 1;
+	if ((sy + height) >= info->var.yres_virtual)
+		height = info->var.yres_virtual - sy - 1;
+
+	/* dest clip */
+	if ((dx >= info->var.xres_virtual) ||
+	    (dy >= info->var.yres_virtual))
+		/* Destination Area not within virtual screen, skipping */
+		return;
+	if ((dx + width) >= info->var.xres_virtual)
+		width = info->var.xres_virtual - dx - 1;
+	if ((dy + height) >= info->var.yres_virtual)
+		height = info->var.yres_virtual - dy - 1;
+
+	if ((sx < dx) || (sy < dy)) {
+		rtl = 1 << 27;
+		sx += width - 1;
+		dx += width - 1;
+		sy += height - 1;
+		dy += height - 1;
+	}
+
+	if (sm501fb_sync(info))
+		return;
+
+	/* set the base addresses */
+	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_SOURCE_BASE);
+	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_DESTINATION_BASE);
+
+	/* set the window width */
+	writel((info->var.xres << 16) | info->var.xres,
+	       fbi->regs2d + SM501_2D_WINDOW_WIDTH);
+
+	/* set window stride */
+	writel((info->var.xres_virtual << 16) | info->var.xres_virtual,
+	       fbi->regs2d + SM501_2D_PITCH);
+
+	/* set data format */
+	switch (info->var.bits_per_pixel) {
+	case 8:
+		writel(0, fbi->regs2d + SM501_2D_STRETCH);
+		break;
+	case 16:
+		writel(0x00100000, fbi->regs2d + SM501_2D_STRETCH);
+		break;
+	case 32:
+		writel(0x00200000, fbi->regs2d + SM501_2D_STRETCH);
+		break;
+	}
+
+	/* 2d compare mask */
+	writel(0xffffffff, fbi->regs2d + SM501_2D_COLOR_COMPARE_MASK);
+
+	/* 2d mask */
+	writel(0xffffffff, fbi->regs2d + SM501_2D_MASK);
+
+	/* source and destination x y */
+	writel((sx << 16) | sy, fbi->regs2d + SM501_2D_SOURCE);
+	writel((dx << 16) | dy, fbi->regs2d + SM501_2D_DESTINATION);
+
+	/* w/h */
+	writel((width << 16) | height, fbi->regs2d + SM501_2D_DIMENSION);
+
+	/* do area move */
+	writel(0x800000cc | rtl, fbi->regs2d + SM501_2D_CONTROL);
+}
+
+static void sm501fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
+{
+	struct sm501fb_par  *par = info->par;
+	struct sm501fb_info *fbi = par->info;
+	int width = rect->width, height = rect->height;
+
+	if ((rect->dx >= info->var.xres_virtual) ||
+	    (rect->dy >= info->var.yres_virtual))
+		/* Rectangle not within virtual screen, skipping */
+		return;
+	if ((rect->dx + width) >= info->var.xres_virtual)
+		width = info->var.xres_virtual - rect->dx - 1;
+	if ((rect->dy + height) >= info->var.yres_virtual)
+		height = info->var.yres_virtual - rect->dy - 1;
+
+	if (sm501fb_sync(info))
+		return;
+
+	/* set the base addresses */
+	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_SOURCE_BASE);
+	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_DESTINATION_BASE);
+
+	/* set the window width */
+	writel((info->var.xres << 16) | info->var.xres,
+	       fbi->regs2d + SM501_2D_WINDOW_WIDTH);
+
+	/* set window stride */
+	writel((info->var.xres_virtual << 16) | info->var.xres_virtual,
+	       fbi->regs2d + SM501_2D_PITCH);
+
+	/* set data format */
+	switch (info->var.bits_per_pixel) {
+	case 8:
+		writel(0, fbi->regs2d + SM501_2D_STRETCH);
+		break;
+	case 16:
+		writel(0x00100000, fbi->regs2d + SM501_2D_STRETCH);
+		break;
+	case 32:
+		writel(0x00200000, fbi->regs2d + SM501_2D_STRETCH);
+		break;
+	}
+
+	/* 2d compare mask */
+	writel(0xffffffff, fbi->regs2d + SM501_2D_COLOR_COMPARE_MASK);
+
+	/* 2d mask */
+	writel(0xffffffff, fbi->regs2d + SM501_2D_MASK);
+
+	/* colour */
+	writel(rect->color, fbi->regs2d + SM501_2D_FOREGROUND);
+
+	/* x y */
+	writel((rect->dx << 16) | rect->dy, fbi->regs2d + SM501_2D_DESTINATION);
+
+	/* w/h */
+	writel((width << 16) | height, fbi->regs2d + SM501_2D_DIMENSION);
+
+	/* do rectangle fill */
+	writel(0x800100cc, fbi->regs2d + SM501_2D_CONTROL);
+}
+
 
 static struct fb_ops sm501fb_ops_crt = {
 	.owner		= THIS_MODULE,
@@ -1256,9 +1424,10 @@ static struct fb_ops sm501fb_ops_crt = {
 	.fb_setcolreg	= sm501fb_setcolreg,
 	.fb_pan_display	= sm501fb_pan_crt,
 	.fb_cursor	= sm501fb_cursor,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
+	.fb_fillrect	= sm501fb_fillrect,
+	.fb_copyarea	= sm501fb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
+	.fb_sync	= sm501fb_sync,
 };
 
 static struct fb_ops sm501fb_ops_pnl = {
@@ -1269,9 +1438,10 @@ static struct fb_ops sm501fb_ops_pnl = {
 	.fb_blank	= sm501fb_blank_pnl,
 	.fb_setcolreg	= sm501fb_setcolreg,
 	.fb_cursor	= sm501fb_cursor,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
+	.fb_fillrect	= sm501fb_fillrect,
+	.fb_copyarea	= sm501fb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
+	.fb_sync	= sm501fb_sync,
 };
 
 /* sm501_init_cursor
@@ -1329,7 +1499,8 @@ static int sm501fb_start(struct sm501fb_
 		dev_warn(dev, "no irq for device\n");
 	}
 
-	/* allocate, reserve and remap resources for registers */
+	/* allocate, reserve and remap resources for display
+	 * controller registers */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(dev, "no resource definition for registers\n");
@@ -1354,12 +1525,38 @@ static int sm501fb_start(struct sm501fb_
 		goto err_regs_res;
 	}
 
+	/* allocate, reserve and remap resources for 2d
+	 * controller registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (res == NULL) {
+		dev_err(dev, "no resource definition for 2d registers\n");
+		ret = -ENOENT;
+		goto err_regs_map;
+	}
+
+	info->regs2d_res = request_mem_region(res->start,
+					      resource_size(res),
+					      pdev->name);
+
+	if (info->regs2d_res == NULL) {
+		dev_err(dev, "cannot claim registers\n");
+		ret = -ENXIO;
+		goto err_regs_map;
+	}
+
+	info->regs2d = ioremap(res->start, resource_size(res));
+	if (info->regs2d == NULL) {
+		dev_err(dev, "cannot remap registers\n");
+		ret = -ENXIO;
+		goto err_regs2d_res;
+	}
+
 	/* allocate, reserve resources for framebuffer */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
 	if (res == NULL) {
 		dev_err(dev, "no memory resource defined\n");
 		ret = -ENXIO;
-		goto err_regs_map;
+		goto err_regs2d_map;
 	}
 
 	info->fbmem_res = request_mem_region(res->start,
@@ -1368,7 +1565,7 @@ static int sm501fb_start(struct sm501fb_
 	if (info->fbmem_res == NULL) {
 		dev_err(dev, "cannot claim framebuffer\n");
 		ret = -ENXIO;
-		goto err_regs_map;
+		goto err_regs2d_map;
 	}
 
 	info->fbmem = ioremap(res->start, resource_size(res));
@@ -1389,8 +1586,10 @@ static int sm501fb_start(struct sm501fb_
 	/* enable display controller */
 	sm501_unit_power(dev->parent, SM501_GATE_DISPLAY, 1);
 
-	/* setup cursors */
+	/* enable 2d controller */
+	sm501_unit_power(dev->parent, SM501_GATE_2D_ENGINE, 1);
 
+	/* setup cursors */
 	sm501_init_cursor(info->fb[HEAD_CRT], SM501_DC_CRT_HWC_ADDR);
 	sm501_init_cursor(info->fb[HEAD_PANEL], SM501_DC_PANEL_HWC_ADDR);
 
@@ -1400,6 +1599,13 @@ static int sm501fb_start(struct sm501fb_
 	release_resource(info->fbmem_res);
 	kfree(info->fbmem_res);
 
+ err_regs2d_map:
+	iounmap(info->regs2d);
+
+ err_regs2d_res:
+	release_resource(info->regs2d_res);
+	kfree(info->regs2d_res);
+
  err_regs_map:
 	iounmap(info->regs);
 
@@ -1420,6 +1626,10 @@ static void sm501fb_stop(struct sm501fb_
 	release_resource(info->fbmem_res);
 	kfree(info->fbmem_res);
 
+	iounmap(info->regs2d);
+	release_resource(info->regs2d_res);
+	kfree(info->regs2d_res);
+
 	iounmap(info->regs);
 	release_resource(info->regs_res);
 	kfree(info->regs_res);
@@ -1486,7 +1696,8 @@ static int sm501fb_init_fb(struct fb_inf
 		par->ops.fb_cursor = NULL;
 
 	fb->fbops = &par->ops;
-	fb->flags = FBINFO_FLAG_DEFAULT |
+	fb->flags = FBINFO_FLAG_DEFAULT | FBINFO_READS_FAST |
+		FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT |
 		FBINFO_HWACCEL_XPAN | FBINFO_HWACCEL_YPAN;
 
 	/* fixed data */
diff -puN include/linux/sm501-regs.h~sm501-implement-acceleration-features include/linux/sm501-regs.h
--- a/include/linux/sm501-regs.h~sm501-implement-acceleration-features
+++ a/include/linux/sm501-regs.h
@@ -31,6 +31,8 @@
 #define SM501_SYSCTRL_PCI_SUBSYS_LOCK	(1<<11)
 #define SM501_SYSCTRL_PCI_BURST_READ_EN	(1<<15)
 
+#define SM501_SYSCTRL_2D_ENGINE_STATUS	(1<<19)
+
 /* miscellaneous control */
 
 #define SM501_MISC_CONTROL		(0x000004)
_

Patches currently in -mm which might be from vince@simtec.co.uk are

origin.patch

