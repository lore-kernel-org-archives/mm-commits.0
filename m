From: akpm@linux-foundation.org
Subject: + davinci-fb-updates-the-driver-in-preparation-for-addition-of-power-management-features.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:00:28 -0800
Message-ID: <200912012200.nB1M0T6q012583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749AbZLAWAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:00:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaithrika@ti.com


The patch titled
     davinci: fb: update the driver in preparation for addition of power management features
has been added to the -mm tree.  Its filename is
     davinci-fb-updates-the-driver-in-preparation-for-addition-of-power-management-features.patch

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
Subject: davinci: fb: update the driver in preparation for addition of power management features
From: Chaithrika U S <chaithrika@ti.com>

Add a helper function to enable raster.  Also add one member in the
private data structure to track the current blank status, another function
pointer which takes in the platform specific callback function to control
panel power.

These updates will help in adding suspend/resume and frame buffer blank
operation features.

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |   43 +++++++++++++++++++++++--------------
 include/video/da8xx-fb.h |    1 
 2 files changed, 28 insertions(+), 16 deletions(-)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-updates-the-driver-in-preparation-for-addition-of-power-management-features drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-updates-the-driver-in-preparation-for-addition-of-power-management-features
+++ a/drivers/video/da8xx-fb.c
@@ -115,9 +115,11 @@ struct da8xx_fb_par {
 	unsigned int databuf_sz;
 	unsigned int palette_sz;
 	unsigned int pxl_clk;
+	int blank;
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 #endif
+	void (*panel_power_ctrl)(int);
 };
 
 /* Variable Screen Information */
@@ -195,8 +197,18 @@ static struct da8xx_panel known_lcd_pane
 	},
 };
 
+/* Enable the Raster Engine of the LCD Controller */
+static inline void lcd_enable_raster(void)
+{
+	u32 reg;
+
+	reg = lcdc_read(LCD_RASTER_CTRL_REG);
+	if (!(reg & LCD_RASTER_ENABLE))
+		lcdc_write(reg | LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
+}
+
 /* Disable the Raster Engine of the LCD Controller */
-static void lcd_disable_raster(struct da8xx_fb_par *par)
+static inline void lcd_disable_raster(void)
 {
 	u32 reg;
 
@@ -448,8 +460,7 @@ static int fb_setcolreg(unsigned regno, 
 static void lcd_reset(struct da8xx_fb_par *par)
 {
 	/* Disable the Raster if previously Enabled */
-	if (lcdc_read(LCD_RASTER_CTRL_REG) & LCD_RASTER_ENABLE)
-		lcd_disable_raster(par);
+	lcd_disable_raster();
 
 	/* DMA has to be disabled */
 	lcdc_write(0, LCD_DMA_CTRL_REG);
@@ -529,13 +540,11 @@ static int lcd_init(struct da8xx_fb_par 
 static irqreturn_t lcdc_irq_handler(int irq, void *arg)
 {
 	u32 stat = lcdc_read(LCD_STAT_REG);
-	u32 reg;
 
 	if ((stat & LCD_SYNC_LOST) && (stat & LCD_FIFO_UNDERFLOW)) {
-		reg = lcdc_read(LCD_RASTER_CTRL_REG);
-		lcdc_write(reg & ~LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
+		lcd_disable_raster();
 		lcdc_write(stat, LCD_STAT_REG);
-		lcdc_write(reg | LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
+		lcd_enable_raster();
 	} else
 		lcdc_write(stat, LCD_STAT_REG);
 
@@ -595,16 +604,13 @@ static int lcd_da8xx_cpufreq_transition(
 				     unsigned long val, void *data)
 {
 	struct da8xx_fb_par *par;
-	unsigned int reg;
 
 	par = container_of(nb, struct da8xx_fb_par, freq_transition);
 	if (val == CPUFREQ_PRECHANGE) {
-		reg = lcdc_read(LCD_RASTER_CTRL_REG);
-		lcdc_write(reg & ~LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
+		lcd_disable_raster();
 	} else if (val == CPUFREQ_POSTCHANGE) {
 		lcd_calc_clk_divider(par);
-		reg = lcdc_read(LCD_RASTER_CTRL_REG);
-		lcdc_write(reg | LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
+		lcd_enable_raster();
 	}
 
 	return 0;
@@ -635,8 +641,10 @@ static int __devexit fb_remove(struct pl
 #ifdef CONFIG_CPU_FREQ
 		lcd_da8xx_cpufreq_deregister(par);
 #endif
-		if (lcdc_read(LCD_RASTER_CTRL_REG) & LCD_RASTER_ENABLE)
-			lcd_disable_raster(par);
+		if (par->panel_power_ctrl)
+			par->panel_power_ctrl(0);
+
+		lcd_disable_raster();
 		lcdc_write(0, LCD_RASTER_CTRL_REG);
 
 		/* disable DMA  */
@@ -777,6 +785,10 @@ static int __init fb_probe(struct platfo
 	par = da8xx_fb_info->par;
 	par->lcdc_clk = fb_clk;
 	par->pxl_clk = lcdc_info->pxl_clk;
+	if (fb_pdata->panel_power_ctrl) {
+		par->panel_power_ctrl = fb_pdata->panel_power_ctrl;
+		par->panel_power_ctrl(1);
+	}
 
 	if (lcd_init(par, lcd_cfg, lcdc_info) < 0) {
 		dev_err(&device->dev, "lcd_init failed\n");
@@ -877,8 +889,7 @@ static int __init fb_probe(struct platfo
 #endif
 
 	/* enable raster engine */
-	lcdc_write(lcdc_read(LCD_RASTER_CTRL_REG) |
-			LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
+	lcd_enable_raster();
 
 	return 0;
 
diff -puN include/video/da8xx-fb.h~davinci-fb-updates-the-driver-in-preparation-for-addition-of-power-management-features include/video/da8xx-fb.h
--- a/include/video/da8xx-fb.h~davinci-fb-updates-the-driver-in-preparation-for-addition-of-power-management-features
+++ a/include/video/da8xx-fb.h
@@ -38,6 +38,7 @@ struct da8xx_lcdc_platform_data {
 	const char manu_name[10];
 	void *controller_data;
 	const char type[25];
+	void (*panel_power_ctrl)(int);
 };
 
 struct lcd_ctrl_config {
_

Patches currently in -mm which might be from chaithrika@ti.com are

origin.patch
linux-next.patch
davinci-mmc-add-cpufreq-support.patch
davinci-fb-calculate-the-clock-divider-from-pixel-clock-info.patch
davinci-fb-add-cpufreq-support.patch
davinci-fb-updates-the-driver-in-preparation-for-addition-of-power-management-features.patch
da850-omap-l138-add-callback-to-control-lcd-panel-power.patch
davinci-fb-add-suspend-resume-suuport-for-da8xx-omap-l1xx-fb-driver.patch
davinci-fb-add-framebuffer-blank-operation.patch

