From: akpm@linux-foundation.org
Subject: + davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-disable-end-of-frame-interrupt.patch added to -mm tree
Date: Wed, 16 Sep 2009 14:44:49 -0700
Message-ID: <200909162144.n8GLinko013487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997AbZIPVpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Sep 2009 17:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sudhakar.raj@ti.com, krzysztof.h1@wp.pl, pkiryukhin@ru.mvista.com, schen@mvista.com


The patch titled
     davinci: fb: disable end-of-frame interrupt
has been added to the -mm tree.  Its filename is
     davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-disable-end-of-frame-interrupt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci: fb: disable end-of-frame interrupt
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

Currently end-of-frame interrupt is being used while disabling LCD
controller to wait or the frame being diaplyed to complete.  But when the
LCD is disabled by clearing the LCD Raster Control enable bit in the LCD
Raster Control Register, the LCD allows the current frame to complete
before it is disabled.

Hence disable end-of-frame interrupt and remove waitqueue related code
which was used to handle this interrupt.

Because of above modifications, modify the lcd_disable_raster() and
lcd_reset() functions to return void instead of int.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: Pavel Kiryukhin <pkiryukhin@ru.mvista.com>
Cc: Steve Chen <schen@mvista.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |   36 ++++++++----------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-disable-end-of-frame-interrupt drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-disable-end-of-frame-interrupt
+++ a/drivers/video/da8xx-fb.c
@@ -107,7 +107,6 @@ static inline void lcdc_write(unsigned i
 }
 
 struct da8xx_fb_par {
-	wait_queue_head_t da8xx_wq;
 	resource_size_t p_palette_base;
 	unsigned char *v_palette_base;
 	struct clk *lcdc_clk;
@@ -193,21 +192,13 @@ static struct da8xx_panel known_lcd_pane
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
-		if (ret == 0)
-			ret = -ETIMEDOUT;
-	}
-	return ret;
 }
 
 static void lcd_blit(int load_mode, struct da8xx_fb_par *par)
@@ -255,7 +246,7 @@ static int lcd_cfg_dma(int burst_size)
 	default:
 		return -EINVAL;
 	}
-	lcdc_write(reg | LCD_END_OF_FRAME_INT_ENA, LCD_DMA_CTRL_REG);
+	lcdc_write(reg, LCD_DMA_CTRL_REG);
 
 	return 0;
 }
@@ -450,19 +441,15 @@ static int fb_setcolreg(unsigned regno, 
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
@@ -471,9 +458,7 @@ static int lcd_init(struct da8xx_fb_par 
 	u32 bpp;
 	int ret = 0;
 
-	ret = lcd_reset(par);
-	if (ret != 0)
-		return ret;
+	lcd_reset(par);
 
 	/* Configure the LCD clock divisor. */
 	lcdc_write(LCD_CLK_DIVISOR(panel->pxl_clk) |
@@ -529,7 +514,6 @@ static int lcd_init(struct da8xx_fb_par 
 static irqreturn_t lcdc_irq_handler(int irq, void *arg)
 {
 	u32 stat = lcdc_read(LCD_STAT_REG);
-	struct da8xx_fb_par *par = arg;
 	u32 reg;
 
 	if ((stat & LCD_SYNC_LOST) && (stat & LCD_FIFO_UNDERFLOW)) {
@@ -540,7 +524,6 @@ static irqreturn_t lcdc_irq_handler(int 
 	} else
 		lcdc_write(stat, LCD_STAT_REG);
 
-	wake_up_interruptible(&par->da8xx_wq);
 	return IRQ_HANDLED;
 }
 
@@ -595,13 +578,12 @@ static int fb_check_var(struct fb_var_sc
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
@@ -620,7 +602,7 @@ static int __devexit fb_remove(struct pl
 		release_mem_region(lcdc_regs->start, resource_size(lcdc_regs));
 
 	}
-	return ret;
+	return 0;
 }
 
 static int fb_ioctl(struct fb_info *info, unsigned int cmd,
@@ -774,8 +756,6 @@ static int __init fb_probe(struct platfo
 
 	par->lcdc_clk = fb_clk;
 
-	init_waitqueue_head(&par->da8xx_wq);
