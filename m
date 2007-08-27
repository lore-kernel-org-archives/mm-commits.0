From: akpm@linux-foundation.org
Subject: + s3c2410fb-source-code-improvements.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:28 -0700
Message-ID: <200708272223.l7RMNSQw031652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55015 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757757AbXH0WXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     s3c2410fb: source code improvements
has been added to the -mm tree.  Its filename is
     s3c2410fb-source-code-improvements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3c2410fb: source code improvements
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch:
- moves more display mode preparations to s3c2410fb_check_var()
- reduces number of fields in s3c2410fb_info
- removes redundant values setting in s3c2410fb_probe()
- removes static mach_info pointer
- releases fb_info structure in s3c2410fb_remove()
- changes s3c2410fb_init to __init from __devinit
- fixes few typos in comments and removes unused includes

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |  186 ++++++++++++++----------------------
 drivers/video/s3c2410fb.h |   14 --
 2 files changed, 76 insertions(+), 124 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-source-code-improvements drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-source-code-improvements
+++ a/drivers/video/s3c2410fb.c
@@ -20,7 +20,7 @@
  *
  * 2004-12-04: Arnaud Patard <arnaud.patard@rtp-net.org>
  *      - Added the possibility to set on or off the
- *      debugging mesaages
+ *      debugging messages
  *      - Replaced 0 and 1 by on or off when reading the
  *      /sys files
  *
@@ -31,7 +31,7 @@
  *	- add pixel clock divisor control
  *
  * 2004-11-11: Arnaud Patard <arnaud.patard@rtp-net.org>
- *	- Removed the use of currcon as it no more exist
+ *	- Removed the use of currcon as it no more exists
  *	- Added LCD power sysfs interface
  *
  * 2004-11-03: Ben Dooks <ben-linux@fluff.org>
@@ -82,13 +82,10 @@
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
-#include <linux/workqueue.h>
-#include <linux/wait.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 
 #include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/div64.h>
 
 #include <asm/mach/map.h>
@@ -102,8 +99,6 @@
 
 #include "s3c2410fb.h"
 
-static struct s3c2410fb_mach_info *mach_info;
-
 /* Debugging stuff */
 #ifdef CONFIG_FB_S3C2410_DEBUG
 static int debug	= 1;
@@ -122,17 +117,16 @@ static int debug	= 0;
 static void s3c2410fb_set_lcdaddr(struct fb_info *info)
 {
 	unsigned long saddr1, saddr2, saddr3;
-	int line_length = info->var.xres * info->var.bits_per_pixel;
 	struct s3c2410fb_info *fbi = info->par;
 	void __iomem *regs = fbi->io;
 
 	saddr1  = info->fix.smem_start >> 1;
 	saddr2  = info->fix.smem_start;
-	saddr2 += (line_length * info->var.yres) / 8;
+	saddr2 += info->fix.line_length * info->var.yres;
 	saddr2 >>= 1;
 
 	saddr3 = S3C2410_OFFSIZE(0) |
-		 S3C2410_PAGEWIDTH((line_length / 16) & 0x3ff);
+		 S3C2410_PAGEWIDTH((info->fix.line_length / 2) & 0x3ff);
 
 	dprintk("LCDSADDR1 = 0x%08lx\n", saddr1);
 	dprintk("LCDSADDR2 = 0x%08lx\n", saddr2);
@@ -153,14 +147,14 @@ static unsigned int s3c2410fb_calc_pixcl
 	unsigned long clk = clk_get_rate(fbi->clk);
 	unsigned long long div;
 
-	/* pixclk is in picoseoncds, our clock is in Hz
+	/* pixclk is in picoseconds, our clock is in Hz
 	 *
 	 * Hz -> picoseconds is / 10^-12
 	 */
 
 	div = (unsigned long long)clk * pixclk;
-	do_div(div, 1000000UL);
-	do_div(div, 1000000UL);
+	div >>= 12;			/* div / 2^12 */
+	do_div(div, 625 * 625UL * 625); /* div / 5^12 */
 
 	dprintk("pixclk %ld, divisor is %ld\n", pixclk, (long)div);
 	return div;
@@ -176,7 +170,7 @@ static int s3c2410fb_check_var(struct fb
 			       struct fb_info *info)
 {
 	struct s3c2410fb_info *fbi = info->par;
-	struct s3c2410fb_mach_info *mach_info = fbi->mach_info;
+	struct s3c2410fb_mach_info *mach_info = fbi->dev->platform_data;
 	struct s3c2410fb_display *display = NULL;
 	unsigned i;
 
@@ -189,7 +183,6 @@ static int s3c2410fb_check_var(struct fb
 		    var->xres == mach_info->displays[i].xres &&
 		    var->bits_per_pixel == mach_info->displays[i].bpp) {
 			display = mach_info->displays + i;
-			fbi->current_display = i;
 			break;
 		}
 
@@ -202,10 +195,22 @@ static int s3c2410fb_check_var(struct fb
 	/* it is always the size as the display */
 	var->xres_virtual = display->xres;
 	var->yres_virtual = display->yres;
+	var->height = display->height;
+	var->width = display->width;
 
 	/* copy lcd settings */
 	var->left_margin = display->left_margin;
 	var->right_margin = display->right_margin;
+	var->upper_margin = display->upper_margin;
+	var->lower_margin = display->lower_margin;
+	var->vsync_len = display->vsync_len;
+	var->hsync_len = display->hsync_len;
+
+	fbi->regs.lcdcon1 = display->lcdcon1;
+	fbi->regs.lcdcon5 = display->lcdcon5;
+	/* set display type */
+	fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_TFT;
+	fbi->regs.lcdcon1 |= display->type;
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
@@ -412,19 +417,13 @@ static void s3c2410fb_activate_var(struc
 {
 	struct s3c2410fb_info *fbi = info->par;
 	void __iomem *regs = fbi->io;
+	int type = fbi->regs.lcdcon1 & S3C2410_LCDCON1_TFT;
 	struct fb_var_screeninfo *var = &info->var;
-	struct s3c2410fb_mach_info *mach_info = fbi->mach_info;
-	struct s3c2410fb_display *display = mach_info->displays +
-					    fbi->current_display;
-
-	/* set display type */
-	fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_TFT;
-	fbi->regs.lcdcon1 |= display->type;
 
 	if (var->pixclock > 0) {
 		int clkdiv = s3c2410fb_calc_pixclk(fbi, var->pixclock);
 
-		if (display->type == S3C2410_LCDCON1_TFT) {
+		if (type == S3C2410_LCDCON1_TFT) {
 			clkdiv = (clkdiv / 2) - 1;
 			if (clkdiv < 0)
 				clkdiv = 0;
@@ -438,7 +437,7 @@ static void s3c2410fb_activate_var(struc
 		fbi->regs.lcdcon1 |=  S3C2410_LCDCON1_CLKVAL(clkdiv);
 	}
 
-	if (display->type == S3C2410_LCDCON1_TFT)
+	if (type == S3C2410_LCDCON1_TFT)
 		s3c2410fb_calculate_tft_lcd_regs(info, &fbi->regs);
 	else
 		s3c2410fb_calculate_stn_lcd_regs(info, &fbi->regs);
@@ -462,6 +461,7 @@ static void s3c2410fb_activate_var(struc
 	/* set lcd address pointers */
 	s3c2410fb_set_lcdaddr(info);
 
+	fbi->regs.lcdcon1 |= S3C2410_LCDCON1_ENVID,
 	writel(fbi->regs.lcdcon1, regs + S3C2410_LCDCON1);
 }
 
@@ -556,9 +556,9 @@ static int s3c2410fb_setcolreg(unsigned 
 		if (regno < 256) {
 			/* currently assume RGB 5-6-5 mode */
 
-			val  = ((red   >>  0) & 0xf800);
-			val |= ((green >>  5) & 0x07e0);
-			val |= ((blue  >> 11) & 0x001f);
+			val  = (red   >>  0) & 0xf800;
+			val |= (green >>  5) & 0x07e0;
+			val |= (blue  >> 11) & 0x001f;
 
 			writel(val, regs + S3C2410_TFTPAL(regno));
 			schedule_palette_update(fbi, regno, val);
@@ -596,9 +596,6 @@ static int s3c2410fb_blank(int blank_mod
 
 	dprintk("blank(mode=%d, info=%p)\n", blank_mode, info);
 
-	if (mach_info == NULL)
-		return -EINVAL;
-
 	if (blank_mode == FB_BLANK_UNBLANK)
 		writel(0x0, regs + S3C2410_TPAL);
 	else {
@@ -614,13 +611,11 @@ static int s3c2410fb_debug_show(struct d
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", debug ? "on" : "off");
 }
+
 static int s3c2410fb_debug_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t len)
 {
-	if (mach_info == NULL)
-		return -EINVAL;
-
 	if (len < 1)
 		return -EINVAL;
 
@@ -663,36 +658,35 @@ static struct fb_ops s3c2410fb_ops = {
 static int __init s3c2410fb_map_video_memory(struct fb_info *info)
 {
 	struct s3c2410fb_info *fbi = info->par;
+	dma_addr_t map_dma;
+	unsigned map_size = PAGE_ALIGN(info->fix.smem_len);
 
 	dprintk("map_video_memory(fbi=%p)\n", fbi);
 
-	fbi->map_size = PAGE_ALIGN(info->fix.smem_len + PAGE_SIZE);
-	fbi->map_cpu  = dma_alloc_writecombine(fbi->dev, fbi->map_size,
-					       &fbi->map_dma, GFP_KERNEL);
+	info->screen_base = dma_alloc_writecombine(fbi->dev, map_size,
+						   &map_dma, GFP_KERNEL);
 
-	fbi->map_size = info->fix.smem_len;
-
-	if (fbi->map_cpu) {
+	if (info->screen_base) {
 		/* prevent initial garbage on screen */
 		dprintk("map_video_memory: clear %p:%08x\n",
-			fbi->map_cpu, fbi->map_size);
-		memset(fbi->map_cpu, 0xf0, fbi->map_size);
+			info->screen_base, map_size);
+		memset(info->screen_base, 0xf0, map_size);
 
-		fbi->screen_dma		= fbi->map_dma;
-		info->screen_base	= fbi->map_cpu;
-		info->fix.smem_start	= fbi->screen_dma;
+		info->fix.smem_start = map_dma;
 
-		dprintk("map_video_memory: dma=%08x cpu=%p size=%08x\n",
-			fbi->map_dma, fbi->map_cpu, info->fix.smem_len);
+		dprintk("map_video_memory: dma=%08lx cpu=%p size=%08x\n",
+			info->fix.smem_start, info->screen_base, map_size);
 	}
 
-	return fbi->map_cpu ? 0 : -ENOMEM;
+	return info->screen_base ? 0 : -ENOMEM;
 }
 
-static inline void s3c2410fb_unmap_video_memory(struct s3c2410fb_info *fbi)
+static inline void s3c2410fb_unmap_video_memory(struct fb_info *info)
 {
-	dma_free_writecombine(fbi->dev, fbi->map_size, fbi->map_cpu,
-			      fbi->map_dma);
+	struct s3c2410fb_info *fbi = info->par;
+
+	dma_free_writecombine(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
+			      info->screen_base, info->fix.smem_start);
 }
 
 static inline void modify_gpio(void __iomem *reg,
@@ -710,6 +704,7 @@ static inline void modify_gpio(void __io
 static int s3c2410fb_init_registers(struct fb_info *info)
 {
 	struct s3c2410fb_info *fbi = info->par;
+	struct s3c2410fb_mach_info *mach_info = fbi->dev->platform_data;
 	unsigned long flags;
 	void __iomem *regs = fbi->io;
 
@@ -726,14 +721,6 @@ static int s3c2410fb_init_registers(stru
 
 	local_irq_restore(flags);
 
-	writel(fbi->regs.lcdcon1, regs + S3C2410_LCDCON1);
-	writel(fbi->regs.lcdcon2, regs + S3C2410_LCDCON2);
-	writel(fbi->regs.lcdcon3, regs + S3C2410_LCDCON3);
-	writel(fbi->regs.lcdcon4, regs + S3C2410_LCDCON4);
-	writel(fbi->regs.lcdcon5, regs + S3C2410_LCDCON5);
-
-	s3c2410fb_set_lcdaddr(info);
-
 	dprintk("LPCSEL    = 0x%08lx\n", mach_info->lpcsel);
 	writel(mach_info->lpcsel, regs + S3C2410_LPCSEL);
 
@@ -742,9 +729,6 @@ static int s3c2410fb_init_registers(stru
 	/* ensure temporary palette disabled */
 	writel(0x00, regs + S3C2410_TPAL);
 
-	/* Enable video by setting the ENVID bit to 1 */
-	fbi->regs.lcdcon1 |= S3C2410_LCDCON1_ENVID;
-	writel(fbi->regs.lcdcon1, regs + S3C2410_LCDCON1);
 	return 0;
 }
 
@@ -798,6 +782,7 @@ static int __init s3c2410fb_probe(struct
 	struct s3c2410fb_info *info;
 	struct s3c2410fb_display *display;
 	struct fb_info *fbinfo;
+	struct s3c2410fb_mach_info *mach_info;
 	struct resource *res;
 	int ret;
 	int irq;
@@ -824,6 +809,8 @@ static int __init s3c2410fb_probe(struct
 	if (!fbinfo)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, fbinfo);
+
 	info = fbinfo->par;
 	info->dev = &pdev->dev;
 
@@ -849,23 +836,14 @@ static int __init s3c2410fb_probe(struct
 		goto release_mem;
 	}
 
-	platform_set_drvdata(pdev, fbinfo);
-
 	dprintk("devinit\n");
 
 	strcpy(fbinfo->fix.id, driver_name);
 
-	info->regs.lcdcon1 = display->lcdcon1;
-	info->regs.lcdcon5 = display->lcdcon5;
-
-	/* Stop the video and unset ENVID if set */
-	info->regs.lcdcon1 &= ~S3C2410_LCDCON1_ENVID;
+	/* Stop the video */
 	lcdcon1 = readl(info->io + S3C2410_LCDCON1);
 	writel(lcdcon1 & ~S3C2410_LCDCON1_ENVID, info->io + S3C2410_LCDCON1);
 
-	info->mach_info		    = pdev->dev.platform_data;
-	info->current_display	    = mach_info->default_display;
-
 	fbinfo->fix.type	    = FB_TYPE_PACKED_PIXELS;
 	fbinfo->fix.type_aux	    = 0;
 	fbinfo->fix.xpanstep	    = 0;
@@ -875,8 +853,6 @@ static int __init s3c2410fb_probe(struct
 
 	fbinfo->var.nonstd	    = 0;
 	fbinfo->var.activate	    = FB_ACTIVATE_NOW;
-	fbinfo->var.height	    = display->height;
-	fbinfo->var.width	    = display->width;
 	fbinfo->var.accel_flags     = 0;
 	fbinfo->var.vmode	    = FB_VMODE_NONINTERLACED;
 
@@ -884,39 +860,6 @@ static int __init s3c2410fb_probe(struct
 	fbinfo->flags		    = FBINFO_FLAG_DEFAULT;
 	fbinfo->pseudo_palette      = &info->pseudo_pal;
 
-	fbinfo->var.xres	    = display->xres;
-	fbinfo->var.xres_virtual    = display->xres;
-	fbinfo->var.yres	    = display->yres;
-	fbinfo->var.yres_virtual    = display->yres;
-	fbinfo->var.bits_per_pixel  = display->bpp;
-	fbinfo->var.left_margin	    = display->left_margin;
-	fbinfo->var.right_margin    = display->right_margin;
-
-	fbinfo->var.upper_margin    = display->upper_margin;
-	fbinfo->var.lower_margin    = display->lower_margin;
-	fbinfo->var.vsync_len	    = display->vsync_len;
-	fbinfo->var.hsync_len	    = display->hsync_len;
-
-	fbinfo->var.red.offset      = 11;
-	fbinfo->var.green.offset    = 5;
-	fbinfo->var.blue.offset     = 0;
-	fbinfo->var.transp.offset   = 0;
-	fbinfo->var.red.length      = 5;
-	fbinfo->var.green.length    = 6;
-	fbinfo->var.blue.length     = 5;
-	fbinfo->var.transp.length   = 0;
-
-	/* find maximum required memory size for display */
-	for (i = 0; i < mach_info->num_displays; i++) {
-		unsigned long smem_len = mach_info->displays[i].xres;
-
-		smem_len *= mach_info->displays[i].yres;
-		smem_len *= mach_info->displays[i].bpp;
-		smem_len >>= 3;
-		if (fbinfo->fix.smem_len < smem_len)
-			fbinfo->fix.smem_len = smem_len;
-	}
-
 	for (i = 0; i < 256; i++)
 		info->palette_buffer[i] = PALETTE_BUFF_CLEAR;
 
@@ -939,6 +882,17 @@ static int __init s3c2410fb_probe(struct
 
 	msleep(1);
 
+	/* find maximum required memory size for display */
+	for (i = 0; i < mach_info->num_displays; i++) {
+		unsigned long smem_len = mach_info->displays[i].xres;
+
+		smem_len *= mach_info->displays[i].yres;
+		smem_len *= mach_info->displays[i].bpp;
+		smem_len >>= 3;
+		if (fbinfo->fix.smem_len < smem_len)
+			fbinfo->fix.smem_len = smem_len;
+	}
+
 	/* Initialize video memory */
 	ret = s3c2410fb_map_video_memory(fbinfo);
 	if (ret) {
@@ -949,6 +903,10 @@ static int __init s3c2410fb_probe(struct
 
 	dprintk("got video memory\n");
 
+	fbinfo->var.xres = display->xres;
+	fbinfo->var.yres = display->yres;
+	fbinfo->var.bits_per_pixel = display->bpp;
+
 	s3c2410fb_init_registers(fbinfo);
 
 	s3c2410fb_check_var(&fbinfo->var, fbinfo);
@@ -969,7 +927,7 @@ static int __init s3c2410fb_probe(struct
 	return 0;
 
 free_video_memory:
-	s3c2410fb_unmap_video_memory(info);
+	s3c2410fb_unmap_video_memory(fbinfo);
 release_clock:
 	clk_disable(info->clk);
 	clk_put(info->clk);
@@ -981,6 +939,7 @@ release_mem:
 	release_resource(info->mem);
 	kfree(info->mem);
 dealloc_fb:
+	platform_set_drvdata(pdev, NULL);
 	framebuffer_release(fbinfo);
 	return ret;
 }
@@ -1010,10 +969,12 @@ static int s3c2410fb_remove(struct platf
 	struct s3c2410fb_info *info = fbinfo->par;
 	int irq;
 
+	unregister_framebuffer(fbinfo);
+
 	s3c2410fb_stop_lcd(info);
 	msleep(1);
 
-	s3c2410fb_unmap_video_memory(info);
+	s3c2410fb_unmap_video_memory(fbinfo);
 
 	if (info->clk) {
 		clk_disable(info->clk);
@@ -1024,10 +985,13 @@ static int s3c2410fb_remove(struct platf
 	irq = platform_get_irq(pdev, 0);
 	free_irq(irq, info);
 
+	iounmap(info->io);
+
 	release_resource(info->mem);
 	kfree(info->mem);
-	iounmap(info->io);
-	unregister_framebuffer(fbinfo);
+
+	platform_set_drvdata(pdev, NULL);
+	framebuffer_release(fbinfo);
 
 	return 0;
 }
@@ -1081,7 +1045,7 @@ static struct platform_driver s3c2410fb_
 	},
 };
 
-int __devinit s3c2410fb_init(void)
+int __init s3c2410fb_init(void)
 {
 	return platform_driver_register(&s3c2410fb_driver);
 }
diff -puN drivers/video/s3c2410fb.h~s3c2410fb-source-code-improvements drivers/video/s3c2410fb.h
--- a/drivers/video/s3c2410fb.h~s3c2410fb-source-code-improvements
+++ a/drivers/video/s3c2410fb.h
@@ -16,7 +16,7 @@
  *
  * 2004-09-07: Arnaud Patard <arnaud.patard@rtp-net.org>
  * 	- Renamed from h1940fb.h to s3c2410fb.h
- * 	- Chenged h1940 to s3c2410
+ * 	- Changed h1940 to s3c2410
  *
  * 2004-07-15: Arnaud Patard <arnaud.patard@rtp-net.org>
  *	- First version
@@ -32,20 +32,8 @@ struct s3c2410fb_info {
 	struct resource		*mem;
 	void __iomem		*io;
 
-	struct s3c2410fb_mach_info *mach_info;
-
-	unsigned current_display;
-
-	/* raw memory addresses */
-	dma_addr_t		map_dma;	/* physical */
-	u_char *		map_cpu;	/* virtual */
-	u_int			map_size;
-
 	struct s3c2410fb_hw	regs;
 
-	/* addresses of pieces placed in raw buffer */
-	u_char *		screen_cpu;	/* virtual address of buffer */
-	dma_addr_t		screen_dma;	/* physical address of buffer */
 	unsigned int		palette_ready;
 
 	/* keep these registers in case we need to re-write palette */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
git-arm-master.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
