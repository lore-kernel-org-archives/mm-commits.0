From: akpm@linux-foundation.org
Subject: + davinci-fb-calculate-the-clock-divider-from-pixel-clock-info.patch added to -mm tree
Date: Mon, 23 Nov 2009 13:16:30 -0800
Message-ID: <200911232116.nANLGUu4030799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001AbZKWVfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 16:35:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaithrika@ti.com, schen@mvista.com, sudhakar.raj@ti.com


The patch titled
     davinci: fb: calculate the clock divider from pixel clock info
has been added to the -mm tree.  Its filename is
     davinci-fb-calculate-the-clock-divider-from-pixel-clock-info.patch

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
Subject: davinci: fb: calculate the clock divider from pixel clock info
From: Chaithrika U S <chaithrika@ti.com>

The clock divider value can be calculated from the pixel clock value for
the panel.  This gives more flexiblity to the driver to change the divider
value on the fly as in the case of cpufreq feature- support for which will
be added shortly.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: Steve Chen <schen@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-calculate-the-clock-divider-from-pixel-clock-info drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-calculate-the-clock-divider-from-pixel-clock-info
+++ a/drivers/video/da8xx-fb.c
@@ -113,6 +113,7 @@ struct da8xx_fb_par {
 	unsigned short pseudo_palette[16];
 	unsigned int databuf_sz;
 	unsigned int palette_sz;
+	unsigned int pxl_clk;
 };
 
 /* Variable Screen Information */
@@ -155,7 +156,7 @@ struct da8xx_panel {
 	int		vfp;		/* Vertical front porch */
 	int		vbp;		/* Vertical back porch */
 	int		vsw;		/* Vertical Sync Pulse Width */
-	int		pxl_clk;	/* Pixel clock */
+	unsigned int	pxl_clk;	/* Pixel clock */
 	unsigned char	invert_pxl_clk;	/* Invert Pixel clock */
 };
 
@@ -171,7 +172,7 @@ static struct da8xx_panel known_lcd_pane
 		.vfp = 2,
 		.vbp = 2,
 		.vsw = 0,
-		.pxl_clk = 0x10,
+		.pxl_clk = 4608000,
 		.invert_pxl_clk = 1,
 	},
 	/* Sharp LK043T1DG01 */
@@ -185,7 +186,7 @@ static struct da8xx_panel known_lcd_pane
 		.vfp = 2,
 		.vbp = 2,
 		.vsw = 10,
-		.pxl_clk = 0x12,
+		.pxl_clk = 7833600,
 		.invert_pxl_clk = 0,
 	},
 };
@@ -451,6 +452,18 @@ static void lcd_reset(struct da8xx_fb_pa
 	lcdc_write(0, LCD_RASTER_CTRL_REG);
 }
 
+static void lcd_calc_clk_divider(struct da8xx_fb_par *par)
+{
+	unsigned int lcd_clk, div;
+
+	lcd_clk = clk_get_rate(par->lcdc_clk);
+	div = lcd_clk / par->pxl_clk;
+
+	/* Configure the LCD clock divisor. */
+	lcdc_write(LCD_CLK_DIVISOR(div) |
+			(LCD_RASTER_MODE & 0x1), LCD_CTRL_REG);
+}
+
 static int lcd_init(struct da8xx_fb_par *par, const struct lcd_ctrl_config *cfg,
 		struct da8xx_panel *panel)
 {
@@ -459,9 +472,8 @@ static int lcd_init(struct da8xx_fb_par 
 
 	lcd_reset(par);
 
-	/* Configure the LCD clock divisor. */
-	lcdc_write(LCD_CLK_DIVISOR(panel->pxl_clk) |
-			(LCD_RASTER_MODE & 0x1), LCD_CTRL_REG);
+	/* Calculate the divider */
+	lcd_calc_clk_divider(par);
 
 	if (panel->invert_pxl_clk)
 		lcdc_write((lcdc_read(LCD_RASTER_TIMING_2_REG) |
@@ -721,6 +733,8 @@ static int __init fb_probe(struct platfo
 	}
 
 	par = da8xx_fb_info->par;
+	par->lcdc_clk = fb_clk;
+	par->pxl_clk = lcdc_info->pxl_clk;
 
 	if (lcd_init(par, lcd_cfg, lcdc_info) < 0) {
 		dev_err(&device->dev, "lcd_init failed\n");
@@ -754,8 +768,6 @@ static int __init fb_probe(struct platfo
 	da8xx_fb_fix.smem_len = par->databuf_sz - par->palette_sz;
 	da8xx_fb_fix.line_length = (lcdc_info->width * lcd_cfg->bpp) / 8;
 
-	par->lcdc_clk = fb_clk;
