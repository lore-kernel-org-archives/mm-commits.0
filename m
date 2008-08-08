From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size.patch added to -mm tree
Date: Fri, 08 Aug 2008 13:36:36 -0700
Message-ID: <200808082036.m78KaakD027206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbYHHUhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 16:37:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stf_xl@wp.pl, haavard.skinnemoen@atmel.com, krzysztof.h1@wp.pl


The patch titled
     atmel_lcdfb: add board parameter specify framebuffer memory size
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: add board parameter specify framebuffer memory size
From: Stanislaw Gruszka <stf_xl@wp.pl>

Specify how much physically continuous, DMA capable memory will be
allocated at driver initialization time.  This allow to create framebuffer
device with larger virtual resolution.  Combine with y-panning this can be
used to implement double buffering acceleration method.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    7 +++++--
 include/video/atmel_lcdc.h  |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size
+++ a/drivers/video/atmel_lcdfb.c
@@ -242,9 +242,11 @@ static int atmel_lcdfb_alloc_video_memor
 {
 	struct fb_info *info = sinfo->info;
 	struct fb_var_screeninfo *var = &info->var;
+	unsigned int smem_len;
 
-	info->fix.smem_len = (var->xres_virtual * var->yres_virtual
-			    * ((var->bits_per_pixel + 7) / 8));
+	smem_len = (var->xres_virtual * var->yres_virtual
+		    * ((var->bits_per_pixel + 7) / 8));
+	info->fix.smem_len = max(smem_len, sinfo->smem_len);
 
 	info->screen_base = dma_alloc_writecombine(info->device, info->fix.smem_len,
 					(dma_addr_t *)&info->fix.smem_start, GFP_KERNEL);
@@ -796,6 +798,7 @@ static int __init atmel_lcdfb_probe(stru
 		sinfo->default_monspecs = pdata_sinfo->default_monspecs;
 		sinfo->atmel_lcdfb_power_control = pdata_sinfo->atmel_lcdfb_power_control;
 		sinfo->guard_time = pdata_sinfo->guard_time;
+		sinfo->smem_len = pdata_sinfo->smem_len;
 		sinfo->lcdcon_is_backlight = pdata_sinfo->lcdcon_is_backlight;
 		sinfo->lcd_wiring_mode = pdata_sinfo->lcd_wiring_mode;
 	} else {
diff -puN include/video/atmel_lcdc.h~atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size include/video/atmel_lcdc.h
--- a/include/video/atmel_lcdc.h~atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size
+++ a/include/video/atmel_lcdc.h
@@ -41,6 +41,7 @@ struct atmel_lcdfb_info {
 	struct work_struct	task;
 
 	unsigned int		guard_time;
+	unsigned int 		smem_len;
 	struct platform_device	*pdev;
 	struct clk		*bus_clk;
 	struct clk		*lcdc_clk;
_

Patches currently in -mm which might be from stf_xl@wp.pl are

atmel_lcdfb-set-ypanstep-to-1-and-enable-y-panning-on-at91.patch
atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size.patch

