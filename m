From: akpm@linux-foundation.org
Subject: + davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v5.patch added to -mm tree
Date: Fri, 31 Jul 2009 16:30:07 -0700
Message-ID: <200907312330.n6VNU7ur002802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbZGaXap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 19:30:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sudhakar.raj@ti.com, krzysztof.h1@wp.pl, pkiryukhin@ru.mvista.com, schen@mvista.com


The patch titled
     davinci: fb: Frame Buffer driver for TI DA8xx/OMAP-L1xx v5
has been added to the -mm tree.  Its filename is
     davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v5.patch

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
Subject: davinci: fb: Frame Buffer driver for TI DA8xx/OMAP-L1xx v5
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

 Following are the changes since the previous version(v4):
 a. An if loop check while returning from lcd_disable_raster()
    function has been removed.
 b. "invert_pxl_clock" variable has been renamed as "invert_pxl_clk"
    and moved from lcd_ctrl_config structure in include/video/da8xx-fb.h
    file to da8xx_panel structure in drivers/video/da8xx-fb.c file.
    Appropriate changes in source code as a result of moving this
    variable has also been done.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: Pavel Kiryukhin <pkiryukhin@ru.mvista.com>
Cc: Steve Chen <schen@mvista.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |   16 ++++++++++------
 include/video/da8xx-fb.h |    3 ---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v5 drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v5
+++ a/drivers/video/da8xx-fb.c
@@ -158,6 +158,7 @@ struct da8xx_panel {
 	int		vbp;		/* Vertical back porch */
 	int		vsw;		/* Vertical Sync Pulse Width */
 	int		pxl_clk;	/* Pixel clock */
+	unsigned char	invert_pxl_clk;	/* Invert Pixel clock */
 };
 
 static struct da8xx_panel known_lcd_panels[] = {
@@ -173,6 +174,7 @@ static struct da8xx_panel known_lcd_pane
 		.vbp = 2,
 		.vsw = 0,
 		.pxl_clk = 0x10,
+		.invert_pxl_clk = 1,
 	},
 	/* Sharp LK043T1DG01 */
 	[1] = {
@@ -186,6 +188,7 @@ static struct da8xx_panel known_lcd_pane
 		.vbp = 2,
 		.vsw = 10,
 		.pxl_clk = 0x12,
+		.invert_pxl_clk = 0,
 	},
 };
 
@@ -204,7 +207,6 @@ static int lcd_disable_raster(struct da8
 		if (ret == 0)
 			ret = -ETIMEDOUT;
 	}
-
 	return ret;
 }
 
@@ -339,11 +341,6 @@ static int lcd_cfg_display(const struct 
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
@@ -482,6 +479,13 @@ static int lcd_init(struct da8xx_fb_par 
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
diff -puN include/video/da8xx-fb.h~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v5 include/video/da8xx-fb.h
--- a/include/video/da8xx-fb.h~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v5
+++ a/include/video/da8xx-fb.h
@@ -67,9 +67,6 @@ struct lcd_ctrl_config {
 	/* Mono 8-bit Mode: 1=D0-D7 or 0=D0-D3 */
 	unsigned char mono_8bit_mode;
 
-	/* Invert pixel clock */
-	unsigned char invert_pxl_clock;
