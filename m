From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-fix-stn-lcd-support.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:09 -0700
Message-ID: <200707230935.l6N9Z9V6016463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759907AbXGWJqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:46:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@rfo.atmel.com, adaplas@gmail.com, andrew@sanpeople.com, hskinnemoen@atmel.com, jan.altenberg@linutronix.de, patrice.vilchez@rfo.atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: Fix STN LCD support
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-fix-stn-lcd-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atmel_lcdfb: Fix STN LCD support
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>

Fixes STN LCD support for the atmel_lcdfb framebuffer driver.

This patch is the result of a work from Jan Altenberg and has
been tested on a Hitachi SP06Q002 on at91sam9261ek.

It adds a Kconfig switch that enables the proper LCD in the
board configuration file (STN or TFT). The switch is used
in arch/arm/mach-at91/at91sam9261_devices.c & board-sam9261ek.c
as an example.

This patch includes the "Fix wrong line_length calculation"
little one from Jan and Haavard (submitted earlier).

AT91 platform informations are directly submitted trough
the at91 maintainer, here :
http://article.gmane.org/gmane.linux.kernel/543158

Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Jan Altenberg <jan.altenberg@linutronix.de>
Cc: Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Cc: Andrew Victor <andrew@sanpeople.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig       |   10 +++++
 drivers/video/atmel_lcdfb.c |   62 +++++++++++++++++++++++++++++-----
 2 files changed, 64 insertions(+), 8 deletions(-)

diff -puN drivers/video/Kconfig~atmel_lcdfb-fix-stn-lcd-support drivers/video/Kconfig
--- a/drivers/video/Kconfig~atmel_lcdfb-fix-stn-lcd-support
+++ a/drivers/video/Kconfig
@@ -849,6 +849,16 @@ config FB_INTSRAM
 	  Say Y if you want to map Frame Buffer in internal SRAM. Say N if you want
 	  to let frame buffer in external SDRAM.
 
+config FB_ATMEL_STN
+	bool "Use a STN display with AT91/AT32 LCD Controller"
+	depends on FB_ATMEL && MACH_AT91SAM9261EK
+	default n
+	help
+	  Say Y if you want to connect a STN LCD display to the AT91/AT32 LCD
+	  Controller. Say N if you want to connect a TFT.
+
+	  If unsure, say N.
+
 config FB_NVIDIA
 	tristate "nVidia Framebuffer Support"
 	depends on FB && PCI
diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-fix-stn-lcd-support drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-fix-stn-lcd-support
+++ a/drivers/video/atmel_lcdfb.c
@@ -79,6 +79,29 @@ static struct fb_fix_screeninfo atmel_lc
 	.accel		= FB_ACCEL_NONE,
 };
 
+static unsigned long compute_hozval(unsigned long xres, unsigned long lcdcon2)
+{
+	unsigned long value;
+
+	if (!(cpu_is_at91sam9261() || cpu_is_at32ap7000()))
+		return xres;
+
+	value = xres;
+	if ((lcdcon2 & ATMEL_LCDC_DISTYPE) != ATMEL_LCDC_DISTYPE_TFT) {
+		/* STN display */
+		if ((lcdcon2 & ATMEL_LCDC_DISTYPE) == ATMEL_LCDC_DISTYPE_STNCOLOR) {
+			value *= 3;
+		}
+		if ( (lcdcon2 & ATMEL_LCDC_IFWIDTH) == ATMEL_LCDC_IFWIDTH_4
+		   || ( (lcdcon2 & ATMEL_LCDC_IFWIDTH) == ATMEL_LCDC_IFWIDTH_8
+		      && (lcdcon2 & ATMEL_LCDC_SCANMOD) == ATMEL_LCDC_SCANMOD_DUAL ))
+			value = DIV_ROUND_UP(value, 4);
+		else
+			value = DIV_ROUND_UP(value, 8);
+	}
+
+	return value;
+}
 
 static void atmel_lcdfb_update_dma(struct fb_info *info,
 			       struct fb_var_screeninfo *var)
@@ -181,6 +204,7 @@ static int atmel_lcdfb_check_var(struct 
 	var->xoffset = var->yoffset = 0;
 
 	switch (var->bits_per_pixel) {
+	case 1:
 	case 2:
 	case 4:
 	case 8:
@@ -228,8 +252,10 @@ static int atmel_lcdfb_check_var(struct 
 static int atmel_lcdfb_set_par(struct fb_info *info)
 {
 	struct atmel_lcdfb_info *sinfo = info->par;
+	unsigned long hozval_linesz;
 	unsigned long value;
 	unsigned long clk_value_khz;
+	unsigned long bits_per_line;
 
 	dev_dbg(info->device, "%s:\n", __func__);
 	dev_dbg(info->device, "  * resolution: %ux%u (%ux%u virtual)\n",
@@ -241,12 +267,15 @@ static int atmel_lcdfb_set_par(struct fb
 
 	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, 0);
 
-	if (info->var.bits_per_pixel <= 8)
+	if (info->var.bits_per_pixel == 1)
+		info->fix.visual = FB_VISUAL_MONO01;
+	else if (info->var.bits_per_pixel <= 8)
 		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
 	else
 		info->fix.visual = FB_VISUAL_TRUECOLOR;
 
-	info->fix.line_length = info->var.xres_virtual * (info->var.bits_per_pixel / 8);
+	bits_per_line = info->var.xres_virtual * info->var.bits_per_pixel;
+	info->fix.line_length = DIV_ROUND_UP(bits_per_line, 8);
 
 	/* Re-initialize the DMA engine... */
 	dev_dbg(info->device, "  * update DMA engine\n");
@@ -262,18 +291,21 @@ static int atmel_lcdfb_set_par(struct fb
 	/* Set pixel clock */
 	clk_value_khz = clk_get_rate(sinfo->lcdc_clk) / 1000;
 
-	value = clk_value_khz / PICOS2KHZ(info->var.pixclock);
-
-	if (clk_value_khz % PICOS2KHZ(info->var.pixclock))
-		value++;
+	value = DIV_ROUND_UP(clk_value_khz, PICOS2KHZ(info->var.pixclock));
 
 	value = (value / 2) - 1;
+	dev_dbg(info->device, "  * programming CLKVAL = 0x%08lx\n", value);
 
 	if (value <= 0) {
 		dev_notice(info->device, "Bypassing pixel clock divider\n");
 		lcdc_writel(sinfo, ATMEL_LCDC_LCDCON1, ATMEL_LCDC_BYPASS);
-	} else
+	} else {
 		lcdc_writel(sinfo, ATMEL_LCDC_LCDCON1, value << ATMEL_LCDC_CLKVAL_OFFSET);
+		info->var.pixclock = KHZ2PICOS(clk_value_khz / (2 * (value + 1)));
+		dev_dbg(info->device, "  updated pixclk:     %lu KHz\n",
+					PICOS2KHZ(info->var.pixclock));
+	}
+
 
 	/* Initialize control register 2 */
 	value = sinfo->default_lcdcon2;
@@ -311,9 +343,14 @@ static int atmel_lcdfb_set_par(struct fb
 	dev_dbg(info->device, "  * LCDTIM2 = %08lx\n", value);
 	lcdc_writel(sinfo, ATMEL_LCDC_TIM2, value);
 
+	/* Horizontal value (aka line size) */
+	hozval_linesz = compute_hozval(info->var.xres,
+					lcdc_readl(sinfo, ATMEL_LCDC_LCDCON2));
+
 	/* Display size */
-	value = (info->var.xres - 1) << ATMEL_LCDC_HOZVAL_OFFSET;
+	value = (hozval_linesz - 1) << ATMEL_LCDC_HOZVAL_OFFSET;
 	value |= info->var.yres - 1;
+	dev_dbg(info->device, "  * LCDFRMCFG = %08lx\n", value);
 	lcdc_writel(sinfo, ATMEL_LCDC_LCDFRMCFG, value);
 
 	/* FIFO Threshold: Use formula from data sheet */
@@ -421,6 +458,15 @@ static int atmel_lcdfb_setcolreg(unsigne
 			ret = 0;
 		}
 		break;
+
+	case FB_VISUAL_MONO01:
+		if (regno < 2) {
+			val = (regno == 0) ? 0x00 : 0x1F;
+			lcdc_writel(sinfo, ATMEL_LCDC_LUT(regno), val);
+			ret = 0;
+		}
+		break;
+
 	}
 
 	return ret;
_

Patches currently in -mm which might be from nicolas.ferre@rfo.atmel.com are

driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
