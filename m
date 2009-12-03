From: akpm@linux-foundation.org
Subject: [merged] davinci-fb-fix-frame-buffer-driver-issues.patch removed from -mm tree
Date: Thu, 03 Dec 2009 12:35:50 -0800
Message-ID: <200912032035.nB3KZoSj010757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754737AbZLCUgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 15:36:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudhakar.raj@ti.com, krzysztof.h1@wp.pl, pkiryukhin@ru.mvista.com, schen@mvista.com, mm-commits@vger.kernel.org


The patch titled
     davinci: fb: fix frame buffer driver issues
has been removed from the -mm tree.  Its filename was
     davinci-fb-fix-frame-buffer-driver-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci: fb: fix frame buffer driver issues
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

Following issues have been addressed on DA8XX/OMAP-L1XX:

a. Screen misalignment during booting when frame buffer console is
   enabled.

b. Driver was configured always in PSEUDOCOLOR mode.  This patch
   dynamically configures the driver either in PSEUDOCOLOUR or TRUECOLOR
   mode depending on bpp.

c. The RED and BLUE offsets were interchanged resulting in wrong
   bootup logo colour.

This patch has been tested on DA830/OMAP-L137 and DA850/OMAP-L138 EVMs.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: Steve Chen <schen@mvista.com>
Cc: Pavel Kiryukhin <pkiryukhin@ru.mvista.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-fix-frame-buffer-driver-issues drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-fix-frame-buffer-driver-issues
+++ a/drivers/video/da8xx-fb.c
@@ -554,11 +554,11 @@ static int fb_check_var(struct fb_var_sc
 		var->transp.length = 0;
 		break;
 	case 16:		/* RGB 565 */
-		var->red.offset = 0;
+		var->red.offset = 11;
 		var->red.length = 5;
 		var->green.offset = 5;
 		var->green.length = 6;
-		var->blue.offset = 11;
+		var->blue.offset = 0;
 		var->blue.length = 5;
 		var->transp.offset = 0;
 		var->transp.length = 0;
@@ -591,7 +591,7 @@ static int __devexit fb_remove(struct pl
 		unregister_framebuffer(info);
 		fb_dealloc_cmap(&info->cmap);
 		dma_free_coherent(NULL, par->databuf_sz + PAGE_SIZE,
-					info->screen_base,
+					info->screen_base - PAGE_SIZE,
 					info->fix.smem_start);
 		free_irq(par->irq, par);
 		clk_disable(par->lcdc_clk);
@@ -749,6 +749,7 @@ static int __init fb_probe(struct platfo
 				(PAGE_SIZE - par->palette_sz);
 
 	/* the rest of the frame buffer is pixel data */
+	da8xx_fb_info->screen_base = par->v_palette_base + par->palette_sz;
 	da8xx_fb_fix.smem_start = par->p_palette_base + par->palette_sz;
 	da8xx_fb_fix.smem_len = par->databuf_sz - par->palette_sz;
 	da8xx_fb_fix.line_length = (lcdc_info->width * lcd_cfg->bpp) / 8;
@@ -787,6 +788,8 @@ static int __init fb_probe(struct platfo
 	da8xx_fb_info->var = da8xx_fb_var;
 	da8xx_fb_info->fbops = &da8xx_fb_ops;
 	da8xx_fb_info->pseudo_palette = par->pseudo_palette;
+	da8xx_fb_info->fix.visual = (da8xx_fb_info->var.bits_per_pixel <= 8) ?
+				FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
 
 	ret = fb_alloc_cmap(&da8xx_fb_info->cmap, PALETTE_SIZE, 0);
 	if (ret)
@@ -825,7 +828,7 @@ err_free_irq:
 
 err_release_fb_mem:
 	dma_free_coherent(NULL, par->databuf_sz + PAGE_SIZE,
-				da8xx_fb_info->screen_base,
+				da8xx_fb_info->screen_base - PAGE_SIZE,
 				da8xx_fb_info->fix.smem_start);
 
 err_release_fb:
_

Patches currently in -mm which might be from sudhakar.raj@ti.com are

linux-next.patch
mtd-nand-davinci-correct-4-bit-error-correction.patch
davinci-mmc-modify-data-types-of-edma-related-variables.patch
davinci-fb-calculate-the-clock-divider-from-pixel-clock-info.patch

