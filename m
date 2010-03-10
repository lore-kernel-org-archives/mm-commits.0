From: akpm@linux-foundation.org
Subject: [folded] nuc900-lcd-controller-driver-updates.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:51:05 -0800
Message-ID: <201003102251.o2AMp5EI008552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757396Ab0CJWvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:51:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rurality.linux@gmail.com, krzysztof.h1@poczta.fm, mcuos.com@gmail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     nuc900-lcd-controller-driver-updates
has been removed from the -mm tree.  Its filename was
     nuc900-lcd-controller-driver-updates.patch

This patch was dropped because it was folded into nuc900-lcd-controller-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nuc900-lcd-controller-driver-updates
From: Qiang Wang <rurality.linux@gmail.com>

Signed-off-by: Wang Qiang <rurality.linux@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Wang Zongshun <mcuos.com@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-w90x900/dev.c  |    5 -
 drivers/video/Kconfig        |    1 
 drivers/video/nuc900fb.c     |  121 +++++++--------------------------
 drivers/video/sis/sis_main.c |    3 
 4 files changed, 31 insertions(+), 99 deletions(-)

diff -puN arch/arm/mach-w90x900/dev.c~nuc900-lcd-controller-driver-updates arch/arm/mach-w90x900/dev.c
--- a/arch/arm/mach-w90x900/dev.c~nuc900-lcd-controller-driver-updates
+++ a/arch/arm/mach-w90x900/dev.c
@@ -396,8 +396,7 @@ static struct resource nuc900_lcd_resour
 	}
 };
 
-static u64 nuc900_device_lcd_dmamask = 0xffffffffUL;
-
+static u64 nuc900_device_lcd_dmamask = -1;
 struct platform_device nuc900_device_lcd = {
 	.name             = "nuc900-lcd",
 	.id               = -1,
@@ -405,7 +404,7 @@ struct platform_device nuc900_device_lcd
 	.resource         = nuc900_lcd_resource,
 	.dev              = {
 		.dma_mask               = &nuc900_device_lcd_dmamask,
-		.coherent_dma_mask      = 0xffffffffUL
+		.coherent_dma_mask      = -1,
 	}
 };
 
diff -puN drivers/video/Kconfig~nuc900-lcd-controller-driver-updates drivers/video/Kconfig
--- a/drivers/video/Kconfig~nuc900-lcd-controller-driver-updates
+++ a/drivers/video/Kconfig
@@ -1497,7 +1497,6 @@ config FB_VIA
        select FB_CFB_FILLRECT
        select FB_CFB_COPYAREA
        select FB_CFB_IMAGEBLIT
-       select FB_SOFT_CURSOR
        select I2C_ALGOBIT
        select I2C
        help
diff -puN drivers/video/nuc900fb.c~nuc900-lcd-controller-driver-updates drivers/video/nuc900fb.c
--- a/drivers/video/nuc900fb.c~nuc900-lcd-controller-driver-updates
+++ a/drivers/video/nuc900fb.c
@@ -31,10 +31,8 @@
 #include <linux/clk.h>
 #include <linux/cpufreq.h>
 #include <linux/io.h>
-
-#ifdef CONFIG_PM
 #include <linux/pm.h>
-#endif
+#include <linux/device.h>
 
 #include <mach/map.h>
 #include <mach/regs-clock.h>
@@ -44,15 +42,6 @@
 
 #include "nuc900fb.h"
 
-/* Debugging stuff */
-#ifdef CONFIG_FB_NUC900_DEBUG
-static int debug	= 1;
-#define dprintk(msg...)	{ printk(KERN_DEBUG "nuc900 lcd: " msg); }
-#else
-static int debug;
-#define dprintk(msg...)
-#endif
-
 
 /*
  *  Initialize the nuc900 video (dual) buffer address
@@ -62,10 +51,12 @@ static void nuc900fb_set_lcdaddr(struct 
 	struct nuc900fb_info *fbi = info->par;
 	void __iomem *regs = fbi->io;
 	unsigned long vbaddr1, vbaddr2;
+
 	vbaddr1  = info->fix.smem_start;
 	vbaddr2  = info->fix.smem_start;
 	vbaddr2 += info->fix.line_length * info->var.yres;
-	/*set frambuffer start phy addr*/
+
+	/* set frambuffer start phy addr*/
 	writel(vbaddr1, regs + REG_LCM_VA_BADDR0);
 	writel(vbaddr2, regs + REG_LCM_VA_BADDR1);
 
@@ -73,17 +64,6 @@ static void nuc900fb_set_lcdaddr(struct 
 	writel(fbi->regs.lcd_va_scale, regs + REG_LCM_VA_SCALE);
 }
 
-//static void nuc900fb_clk_select(struct fb_info *info, unsigned long pixclk)
-//{
-//	struct nuc900fb_info *fbi = info->par;
-//	int div;
-//	if (clk <= 15 * 1000 * 1000) {
-//		div = (15 * 1000 * 1000)/
-//		nuc900_driver_clksrc_div(fbi->dev, "ext", 0x2);
-//	}
-//
-//}
-
 /*
  *	calculate divider for lcd div
  */
@@ -99,7 +79,7 @@ static unsigned int nuc900fb_calc_pixclk
 	div >>= 12;
 	do_div(div, 625 * 625UL * 625);
 
-	dprintk("pixclk %ld, divisor is %ld\n", pixclk, (long)div);
+	dev_dbg(fbi->dev, "pixclk %ld, divisor is %lld\n", pixclk, div);
 
 	return div;
 }
@@ -117,7 +97,7 @@ static int nuc900fb_check_var(struct fb_
 						   mach_info->default_display;
 	int i;
 
-	dprintk("check_var(var=%p, info=%p)\n", var, info);
+	dev_dbg(fbi->dev, "check_var(var=%p, info=%p)\n", var, info);
 
 	/* validate x/y resolution */
 	/* choose default mode if possible */
@@ -135,7 +115,7 @@ static int nuc900fb_check_var(struct fb_
 			}
 
 	if (display == NULL) {
-		dprintk("wrong resolution or depth %dx%d at %d bit per pixel\n",
+		printk(KERN_ERR "wrong resolution or depth %dx%d at %d bit per pixel\n",
 			var->xres, var->yres, var->bits_per_pixel);
 		return -EINVAL;
 	}
@@ -223,6 +203,7 @@ static void nuc900fb_calculate_lcd_regs(
 	int htt = var->width + var->left_margin + var->right_margin;
 	int hsync = var->width + var->right_margin;
 	int vsync = var->height + var->lower_margin;
+
 	regs->lcd_crtc_size = LCM_CRTC_SIZE_VTTVAL(vtt) |
 			      LCM_CRTC_SIZE_HTTVAL(htt);
 	regs->lcd_crtc_dend = LCM_CRTC_DEND_VDENDVAL(var->height) |
@@ -255,14 +236,14 @@ static void nuc900fb_activate_var(struct
 
 	/* set the new lcd registers*/
 
-	dprintk("new lcd register set:\n");
-	dprintk("dccs           = 0x%08x\n", fbi->regs.lcd_dccs);
-	dprintk("dev_ctl        = 0x%08x\n", fbi->regs.lcd_device_ctrl);
-	dprintk("crtc_size      = 0x%08x\n", fbi->regs.lcd_crtc_size);
-	dprintk("crtc_dend      = 0x%08x\n", fbi->regs.lcd_crtc_dend);
-	dprintk("crtc_hr        = 0x%08x\n", fbi->regs.lcd_crtc_hr);
-	dprintk("crtc_hsync     = 0x%08x\n", fbi->regs.lcd_crtc_hsync);
-	dprintk("crtc_vr        = 0x%08x\n", fbi->regs.lcd_crtc_vr);
+	dev_dbg(fbi->dev, "new lcd register set:\n");
+	dev_dbg(fbi->dev, "dccs       = 0x%08x\n", fbi->regs.lcd_dccs);
+	dev_dbg(fbi->dev, "dev_ctl    = 0x%08x\n", fbi->regs.lcd_device_ctrl);
+	dev_dbg(fbi->dev, "crtc_size  = 0x%08x\n", fbi->regs.lcd_crtc_size);
+	dev_dbg(fbi->dev, "crtc_dend  = 0x%08x\n", fbi->regs.lcd_crtc_dend);
+	dev_dbg(fbi->dev, "crtc_hr    = 0x%08x\n", fbi->regs.lcd_crtc_hr);
+	dev_dbg(fbi->dev, "crtc_hsync = 0x%08x\n", fbi->regs.lcd_crtc_hsync);
+	dev_dbg(fbi->dev, "crtc_vr    = 0x%08x\n", fbi->regs.lcd_crtc_vr);
 
 	writel(fbi->regs.lcd_device_ctrl, regs + REG_LCM_DEV_CTRL);
 	writel(fbi->regs.lcd_crtc_size, regs + REG_LCM_CRTC_SIZE);
@@ -285,8 +266,6 @@ static int nuc900fb_set_par(struct fb_in
 {
 	struct fb_var_screeninfo *var = &info->var;
 
-	dprintk("nuc900fb_set_par\n");
-
 	switch (var->bits_per_pixel) {
 	case 32:
 	case 24:
@@ -353,35 +332,6 @@ static int nuc900fb_blank(int blank_mode
 	return 0;
 }
 
-static int nuc900fb_debug_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%s\n", debug ? "on" : "off");
-}
-
-static int nuc900fb_debug_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t len)
-{
-	if (len < 1)
-		return -EINVAL;
-
-	if (strnicmp(buf, "on", 2) == 0 ||
-	    strnicmp(buf, "1", 1) == 0) {
-		debug = 1;
-	} else if (strnicmp(buf, "off", 3) == 0 ||
-		   strnicmp(buf, "0", 1) == 0) {
-		debug = 0;
-
-	} else {
-		return -EINVAL;
-	}
-
-	return len;
-}
-
-static DEVICE_ATTR(debug, 0666, nuc900fb_debug_show, nuc900fb_debug_store);
-
 static struct fb_ops nuc900fb_ops = {
 	.owner			= THIS_MODULE,
 	.fb_check_var		= nuc900fb_check_var,
@@ -443,23 +393,19 @@ static int __init nuc900fb_map_video_mem
 	dma_addr_t map_dma;
 	unsigned long map_size = PAGE_ALIGN(info->fix.smem_len);
 
-	dprintk("nuc900fb_map_video_memory(fbi=%p) map_size %lu\n",
+	dev_dbg(fbi->dev, "nuc900fb_map_video_memory(fbi=%p) map_size %lu\n",
 		fbi, map_size);
 
 	info->screen_base = dma_alloc_writecombine(fbi->dev, map_size,
 							&map_dma, GFP_KERNEL);
 
-	if (info->screen_base != NULL) {
-		dprintk("nuc900fb_map_video_memory: clear %p:%08lx\n",
-			info->screen_base, map_size);
-		memset(info->screen_base, 0x00, map_size);
-
-		info->fix.smem_start = map_dma;
-		dprintk("nuc900fb_map_video_memory: "
-			"dma=%08lx cpu=%p size=%08lx\n",
-			info->fix.smem_start, info->screen_base, map_size);
-	}
-	return (info->screen_base) ? 0 : -ENOMEM;
+	if (!info->screen_base)
+		return -ENOMEM;
+
+	memset(info->screen_base, 0x00, map_size);
+	info->fix.smem_start = map_dma;
+
+	return 0;
 }
 
 static inline void nuc900fb_unmap_video_memory(struct fb_info *info)
@@ -553,7 +499,7 @@ static inline void nuc900fb_cpufreq_dere
 
 static char driver_name[] = "nuc900fb";
 
-static int __init nuc900fb_probe(struct platform_device *pdev)
+static int __devinit nuc900fb_probe(struct platform_device *pdev)
 {
 	struct nuc900fb_info *fbi;
 	struct nuc900fb_display *display;
@@ -565,7 +511,7 @@ static int __init nuc900fb_probe(struct 
 	int i;
 	int size;
 
-	dprintk("devinit\n");
+	dev_dbg(&pdev->dev, "devinit\n");
 	mach_info = pdev->dev.platform_data;
 	if (mach_info == NULL) {
 		dev_err(&pdev->dev,
@@ -660,7 +606,7 @@ static int __init nuc900fb_probe(struct 
 	}
 
 	clk_enable(fbi->clk);
-	dprintk("got and enabled clock\n");
+	dev_dbg(&pdev->dev, "got and enabled clock\n");
 
 	fbi->clk_rate = clk_get_rate(fbi->clk);
 
@@ -681,7 +627,7 @@ static int __init nuc900fb_probe(struct 
 		goto release_clock;
 	}
 
-	dprintk("got video memory\n");
+	dev_dbg(&pdev->dev, "got video memory\n");
 
 	fbinfo->var.xres = display->xres;
 	fbinfo->var.yres = display->yres;
@@ -704,12 +650,6 @@ static int __init nuc900fb_probe(struct 
 		goto free_cpufreq;
 	}
 
-	/* create device files */
-	ret = device_create_file(&pdev->dev, &dev_attr_debug);
-	if (ret)
-		printk(KERN_ERR "failed to add debug attribute\n");
-
-
 	printk(KERN_INFO "fb%d: %s frame buffer device\n",
 		fbinfo->node, fbinfo->fix.id);
 
@@ -740,12 +680,9 @@ static void nuc900fb_stop_lcd(struct fb_
 {
 	struct nuc900fb_info *fbi = info->par;
 	void __iomem *regs = fbi->io;
-	unsigned long flags;
 
-	local_irq_save(flags);
 	writel((~LCM_DCCS_DISP_INT_EN) | (~LCM_DCCS_VA_EN) | (~LCM_DCCS_OSD_EN),
 		regs + REG_LCM_DCCS);
-	local_irq_restore(flags);
 }
 
 /*
@@ -798,7 +735,7 @@ static int nuc900fb_resume(struct platfo
 	struct fb_info	   *fbinfo = platform_get_drvdata(dev);
 	struct nuc900fb_info *fbi = fbinfo->par;
 
-	dprintk("nuc900fb resume\n");
+	printk(KERN_INFO "nuc900fb resume\n");
 
 	clk_enable(fbi->clk);
 	msleep(1);
diff -puN drivers/video/sis/sis_main.c~nuc900-lcd-controller-driver-updates drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~nuc900-lcd-controller-driver-updates
+++ a/drivers/video/sis/sis_main.c
@@ -1891,9 +1891,6 @@ static struct fb_ops sisfb_ops = {
 	.fb_fillrect	= fbcon_sis_fillrect,
 	.fb_copyarea	= fbcon_sis_copyarea,
 	.fb_imageblit	= cfb_imageblit,
-#ifdef CONFIG_FB_SOFT_CURSOR
-	.fb_cursor	= soft_cursor,
-#endif
 	.fb_sync	= fbcon_sis_sync,
 #ifdef SIS_NEW_CONFIG_COMPAT
 	.fb_compat_ioctl= sisfb_ioctl,
_

Patches currently in -mm which might be from rurality.linux@gmail.com are

nuc900-lcd-controller-driver.patch
nuc900-lcd-controller-driver-updates.patch

