From: akpm@linux-foundation.org
Subject: [merged] davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:01:14 -0700
Message-ID: <200909232001.n8NK1E9o014761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753866AbZIWUCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudhakar.raj@ti.com, krzysztof.h1@wp.pl, pkiryukhin@ru.mvista.com, schen@mvista.com, mm-commits@vger.kernel.org


The patch titled
     davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4
has been removed from the -mm tree.  Its filename was
     davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

Since the previous version, return values in ioctl() function have been
modified.

[akpm@linux-foundation.org: simplify lcd_disable_raster()]
Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Signed-off-by: Pavel Kiryukhin <pkiryukhin@ru.mvista.com>
Signed-off-by: Steve Chen <schen@mvista.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |   61 ++++++++++++-------------------------
 include/video/da8xx-fb.h |    3 -
 2 files changed, 21 insertions(+), 43 deletions(-)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4 drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4
+++ a/drivers/video/da8xx-fb.c
@@ -107,7 +107,6 @@ static inline void lcdc_write(unsigned i
 }
 
 struct da8xx_fb_par {
-	wait_queue_head_t da8xx_wq;
 	resource_size_t p_palette_base;
 	unsigned char *v_palette_base;
 	struct clk *lcdc_clk;
@@ -158,6 +157,7 @@ struct da8xx_panel {
 	int		vbp;		/* Vertical back porch */
 	int		vsw;		/* Vertical Sync Pulse Width */
 	int		pxl_clk;	/* Pixel clock */
+	unsigned char	invert_pxl_clk;	/* Invert Pixel clock */
 };
 
 static struct da8xx_panel known_lcd_panels[] = {
@@ -173,6 +173,7 @@ static struct da8xx_panel known_lcd_pane
 		.vbp = 2,
 		.vsw = 0,
 		.pxl_clk = 0x10,
+		.invert_pxl_clk = 1,
 	},
 	/* Sharp LK043T1DG01 */
 	[1] = {
@@ -186,29 +187,18 @@ static struct da8xx_panel known_lcd_pane
 		.vbp = 2,
 		.vsw = 10,
 		.pxl_clk = 0x12,
+		.invert_pxl_clk = 0,
 	},
 };
 
 /* Disable the Raster Engine of the LCD Controller */
-static int lcd_disable_raster(struct da8xx_fb_par *par)
+static void lcd_disable_raster(struct da8xx_fb_par *par)
 {
-	int ret = 0;
 	u32 reg;
 
 	reg = lcdc_read(LCD_RASTER_CTRL_REG);
-	if (reg & LCD_RASTER_ENABLE) {
+	if (reg & LCD_RASTER_ENABLE)
 		lcdc_write(reg & ~LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
-		ret = wait_event_interruptible_timeout(par->da8xx_wq,
-						!lcdc_read(LCD_STAT_REG) &
-						LCD_END_OF_FRAME0, WSI_TIMEOUT);
-	}
-
-	if (ret < 0)
-		return ret;
-	if (ret == 0)
-		return -ETIMEDOUT;
-
-	return 0;
 }
 
 static void lcd_blit(int load_mode, struct da8xx_fb_par *par)
@@ -256,7 +246,7 @@ static int lcd_cfg_dma(int burst_size)
 	default:
 		return -EINVAL;
 	}
-	lcdc_write(reg | LCD_END_OF_FRAME_INT_ENA, LCD_DMA_CTRL_REG);
+	lcdc_write(reg, LCD_DMA_CTRL_REG);
 
 	return 0;
 }
@@ -342,11 +332,6 @@ static int lcd_cfg_display(const struct 
 	else
 		reg &= ~LCD_SYNC_EDGE;
 
-	if (cfg->invert_pxl_clock)
-		reg |= LCD_INVERT_PIXEL_CLOCK;
-	else
-		reg &= ~LCD_INVERT_PIXEL_CLOCK;
-
 	if (cfg->invert_line_clock)
 		reg |= LCD_INVERT_LINE_CLOCK;
 	else
@@ -456,19 +441,15 @@ static int fb_setcolreg(unsigned regno, 
 	return 0;
 }
 
-static int lcd_reset(struct da8xx_fb_par *par)
+static void lcd_reset(struct da8xx_fb_par *par)
 {
-	int ret = 0;
-
 	/* Disable the Raster if previously Enabled */
 	if (lcdc_read(LCD_RASTER_CTRL_REG) & LCD_RASTER_ENABLE)
-		ret = lcd_disable_raster(par);
+		lcd_disable_raster(par);
 
 	/* DMA has to be disabled */
 	lcdc_write(0, LCD_DMA_CTRL_REG);
 	lcdc_write(0, LCD_RASTER_CTRL_REG);
-
-	return ret;
 }
 
 static int lcd_init(struct da8xx_fb_par *par, const struct lcd_ctrl_config *cfg,
@@ -477,14 +458,19 @@ static int lcd_init(struct da8xx_fb_par 
 	u32 bpp;
 	int ret = 0;
 
-	ret = lcd_reset(par);
-	if (ret != 0)
-		return ret;
+	lcd_reset(par);
 
 	/* Configure the LCD clock divisor. */
 	lcdc_write(LCD_CLK_DIVISOR(panel->pxl_clk) |
 			(LCD_RASTER_MODE & 0x1), LCD_CTRL_REG);
 
+	if (panel->invert_pxl_clk)
+		lcdc_write((lcdc_read(LCD_RASTER_TIMING_2_REG) |
+			LCD_INVERT_PIXEL_CLOCK), LCD_RASTER_TIMING_2_REG);
+	else
+		lcdc_write((lcdc_read(LCD_RASTER_TIMING_2_REG) &
+			~LCD_INVERT_PIXEL_CLOCK), LCD_RASTER_TIMING_2_REG);
+
 	/* Configure the DMA burst size. */
 	ret = lcd_cfg_dma(cfg->dma_burst_sz);
 	if (ret < 0)
@@ -528,7 +514,6 @@ static int lcd_init(struct da8xx_fb_par 
 static irqreturn_t lcdc_irq_handler(int irq, void *arg)
 {
 	u32 stat = lcdc_read(LCD_STAT_REG);
-	struct da8xx_fb_par *par = arg;
 	u32 reg;
 
 	if ((stat & LCD_SYNC_LOST) && (stat & LCD_FIFO_UNDERFLOW)) {
@@ -539,7 +524,6 @@ static irqreturn_t lcdc_irq_handler(int 
 	} else
 		lcdc_write(stat, LCD_STAT_REG);
 
-	wake_up_interruptible(&par->da8xx_wq);
 	return IRQ_HANDLED;
 }
 
@@ -594,13 +578,12 @@ static int fb_check_var(struct fb_var_sc
 static int __devexit fb_remove(struct platform_device *dev)
 {
 	struct fb_info *info = dev_get_drvdata(&dev->dev);
-	int ret = 0;
 
 	if (info) {
 		struct da8xx_fb_par *par = info->par;
 
 		if (lcdc_read(LCD_RASTER_CTRL_REG) & LCD_RASTER_ENABLE)
-			ret = lcd_disable_raster(par);
+			lcd_disable_raster(par);
 		lcdc_write(0, LCD_RASTER_CTRL_REG);
 
 		/* disable DMA  */
@@ -619,7 +602,7 @@ static int __devexit fb_remove(struct pl
 		release_mem_region(lcdc_regs->start, resource_size(lcdc_regs));
 
 	}
-	return ret;
+	return 0;
 }
 
 static int fb_ioctl(struct fb_info *info, unsigned int cmd,
@@ -634,11 +617,11 @@ static int fb_ioctl(struct fb_info *info
 	case FBIPUT_BRIGHTNESS:
 	case FBIGET_COLOR:
 	case FBIPUT_COLOR:
-		return -EINVAL;
+		return -ENOTTY;
 	case FBIPUT_HSYNC:
 		if (copy_from_user(&sync_arg, (char *)arg,
 				sizeof(struct lcd_sync_arg)))
-			return -EINVAL;
+			return -EFAULT;
 		lcd_cfg_horizontal_sync(sync_arg.back_porch,
 					sync_arg.pulse_width,
 					sync_arg.front_porch);
@@ -646,7 +629,7 @@ static int fb_ioctl(struct fb_info *info
 	case FBIPUT_VSYNC:
 		if (copy_from_user(&sync_arg, (char *)arg,
 				sizeof(struct lcd_sync_arg)))
-			return -EINVAL;
+			return -EFAULT;
 		lcd_cfg_vertical_sync(sync_arg.back_porch,
 					sync_arg.pulse_width,
 					sync_arg.front_porch);
@@ -773,8 +756,6 @@ static int __init fb_probe(struct platfo
 
 	par->lcdc_clk = fb_clk;
 
-	init_waitqueue_head(&par->da8xx_wq);
-
 	par->irq = platform_get_irq(device, 0);
 	if (par->irq < 0) {
 		ret = -ENOENT;
diff -puN include/video/da8xx-fb.h~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4 include/video/da8xx-fb.h
--- a/include/video/da8xx-fb.h~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4
+++ a/include/video/da8xx-fb.h
@@ -67,9 +67,6 @@ struct lcd_ctrl_config {
 	/* Mono 8-bit Mode: 1=D0-D7 or 0=D0-D3 */
 	unsigned char mono_8bit_mode;
 
-	/* Invert pixel clock */
-	unsigned char invert_pxl_clock;
