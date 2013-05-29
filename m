From: akpm@linux-foundation.org
Subject: + drivers-video-acornfbc-remove-dead-code.patch added to -mm tree
Date: Wed, 29 May 2013 15:48:38 -0700
Message-ID: <51a685c6.u/aHhYznrJSVGYwu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab3E2Wsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 18:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, laurent.pinchart@ideasonboard.com, FlorianSchandinat@gmx.de, pebolle@tiscali.nl

Subject: + drivers-video-acornfbc-remove-dead-code.patch added to -mm tree
To: pebolle@tiscali.nl,FlorianSchandinat@gmx.de,laurent.pinchart@ideasonboard.com
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 15:48:38 -0700


The patch titled
     Subject: drivers/video/acornfb.c: remove dead code
has been added to the -mm tree.  Its filename is
     drivers-video-acornfbc-remove-dead-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: drivers/video/acornfb.c: remove dead code

acornfb checks for HAS_VIDC while support for that macro was removed in
v2.6.23 (when the arm26 port was removed).  So we can remove a bit of dead
code.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/acornfb.c |  266 --------------------------------------
 drivers/video/acornfb.h |   29 ----
 2 files changed, 1 insertion(+), 294 deletions(-)

diff -puN drivers/video/acornfb.c~drivers-video-acornfbc-remove-dead-code drivers/video/acornfb.c
--- a/drivers/video/acornfb.c~drivers-video-acornfbc-remove-dead-code
+++ a/drivers/video/acornfb.c
@@ -38,14 +38,6 @@
 #include "acornfb.h"
 
 /*
- * VIDC machines can't do 16 or 32BPP modes.
- */
-#ifdef HAS_VIDC
-#undef FBCON_HAS_CFB16
-#undef FBCON_HAS_CFB32
-#endif
-
-/*
  * Default resolution.
  * NOTE that it has to be supported in the table towards
  * the end of this file.
@@ -106,238 +98,6 @@ static struct vidc_timing current_vidc;
 
 extern unsigned int vram_size;	/* set by setup.c */
 
-#ifdef HAS_VIDC
-
-#define MAX_SIZE	480*1024
-
-/* CTL     VIDC	Actual
- * 24.000  0	 8.000
- * 25.175  0	 8.392
- * 36.000  0	12.000
- * 24.000  1	12.000
- * 25.175  1	12.588
- * 24.000  2	16.000
- * 25.175  2	16.783
- * 36.000  1	18.000
- * 24.000  3	24.000
- * 36.000  2	24.000
- * 25.175  3	25.175
- * 36.000  3	36.000
- */
-struct pixclock {
-	u_long	min_clock;
-	u_long	max_clock;
-	u_int	vidc_ctl;
-	u_int	vid_ctl;
-};
-
-static struct pixclock arc_clocks[] = {
-	/* we allow +/-1% on these */
-	{ 123750, 126250, VIDC_CTRL_DIV3,   VID_CTL_24MHz },	/*  8.000MHz */
-	{  82500,  84167, VIDC_CTRL_DIV2,   VID_CTL_24MHz },	/* 12.000MHz */
-	{  61875,  63125, VIDC_CTRL_DIV1_5, VID_CTL_24MHz },	/* 16.000MHz */
-	{  41250,  42083, VIDC_CTRL_DIV1,   VID_CTL_24MHz },	/* 24.000MHz */
-};
-
-static struct pixclock *
-acornfb_valid_pixrate(struct fb_var_screeninfo *var)
-{
-	u_long pixclock = var->pixclock;
-	u_int i;
-
-	if (!var->pixclock)
-		return NULL;
-
-	for (i = 0; i < ARRAY_SIZE(arc_clocks); i++)
-		if (pixclock > arc_clocks[i].min_clock &&
-		    pixclock < arc_clocks[i].max_clock)
-			return arc_clocks + i;
-
-	return NULL;
-}
-
-/* VIDC Rules:
- * hcr  : must be even (interlace, hcr/2 must be even)
- * hswr : must be even
- * hdsr : must be odd
- * hder : must be odd
- *
- * vcr  : must be odd
- * vswr : >= 1
- * vdsr : >= 1
- * vder : >= vdsr
- * if interlaced, then hcr/2 must be even
- */
-static void
-acornfb_set_timing(struct fb_var_screeninfo *var)
-{
-	struct pixclock *pclk;
-	struct vidc_timing vidc;
-	u_int horiz_correction;
-	u_int sync_len, display_start, display_end, cycle;
-	u_int is_interlaced;
-	u_int vid_ctl, vidc_ctl;
-	u_int bandwidth;
-
-	memset(&vidc, 0, sizeof(vidc));
-
-	pclk = acornfb_valid_pixrate(var);
-	vidc_ctl = pclk->vidc_ctl;
-	vid_ctl  = pclk->vid_ctl;
-
-	bandwidth = var->pixclock * 8 / var->bits_per_pixel;
-	/* 25.175, 4bpp = 79.444ns per byte, 317.776ns per word: fifo = 2,6 */
-	if (bandwidth > 143500)
-		vidc_ctl |= VIDC_CTRL_FIFO_3_7;
-	else if (bandwidth > 71750)
-		vidc_ctl |= VIDC_CTRL_FIFO_2_6;
-	else if (bandwidth > 35875)
-		vidc_ctl |= VIDC_CTRL_FIFO_1_5;
-	else
-		vidc_ctl |= VIDC_CTRL_FIFO_0_4;
-
-	switch (var->bits_per_pixel) {
-	case 1:
-		horiz_correction = 19;
-		vidc_ctl |= VIDC_CTRL_1BPP;
-		break;
-
-	case 2:
-		horiz_correction = 11;
-		vidc_ctl |= VIDC_CTRL_2BPP;
-		break;
-
-	case 4:
-		horiz_correction = 7;
-		vidc_ctl |= VIDC_CTRL_4BPP;
-		break;
-
-	default:
-	case 8:
-		horiz_correction = 5;
-		vidc_ctl |= VIDC_CTRL_8BPP;
-		break;
-	}
-
-	if (var->sync & FB_SYNC_COMP_HIGH_ACT) /* should be FB_SYNC_COMP */
-		vidc_ctl |= VIDC_CTRL_CSYNC;
-	else {
-		if (!(var->sync & FB_SYNC_HOR_HIGH_ACT))
-			vid_ctl |= VID_CTL_HS_NHSYNC;
-
-		if (!(var->sync & FB_SYNC_VERT_HIGH_ACT))
-			vid_ctl |= VID_CTL_VS_NVSYNC;
-	}
-
-	sync_len	= var->hsync_len;
-	display_start	= sync_len + var->left_margin;
-	display_end	= display_start + var->xres;
-	cycle		= display_end + var->right_margin;
-
-	/* if interlaced, then hcr/2 must be even */
-	is_interlaced = (var->vmode & FB_VMODE_MASK) == FB_VMODE_INTERLACED;
-
-	if (is_interlaced) {
-		vidc_ctl |= VIDC_CTRL_INTERLACE;
-		if (cycle & 2) {
-			cycle += 2;
-			var->right_margin += 2;
-		}
-	}
-
-	vidc.h_cycle		= (cycle - 2) / 2;
-	vidc.h_sync_width	= (sync_len - 2) / 2;
-	vidc.h_border_start	= (display_start - 1) / 2;
-	vidc.h_display_start	= (display_start - horiz_correction) / 2;
-	vidc.h_display_end	= (display_end - horiz_correction) / 2;
-	vidc.h_border_end	= (display_end - 1) / 2;
-	vidc.h_interlace	= (vidc.h_cycle + 1) / 2;
-
-	sync_len	= var->vsync_len;
-	display_start	= sync_len + var->upper_margin;
-	display_end	= display_start + var->yres;
-	cycle		= display_end + var->lower_margin;
-
-	if (is_interlaced)
-		cycle = (cycle - 3) / 2;
-	else
-		cycle = cycle - 1;
-
-	vidc.v_cycle		= cycle;
-	vidc.v_sync_width	= sync_len - 1;
-	vidc.v_border_start	= display_start - 1;
-	vidc.v_display_start	= vidc.v_border_start;
-	vidc.v_display_end	= display_end - 1;
-	vidc.v_border_end	= vidc.v_display_end;
-
-	if (machine_is_a5k())
-		__raw_writeb(vid_ctl, IOEB_VID_CTL);
-
-	if (memcmp(&current_vidc, &vidc, sizeof(vidc))) {
-		current_vidc = vidc;
-
-		vidc_writel(0xe0000000 | vidc_ctl);
-		vidc_writel(0x80000000 | (vidc.h_cycle << 14));
-		vidc_writel(0x84000000 | (vidc.h_sync_width << 14));
-		vidc_writel(0x88000000 | (vidc.h_border_start << 14));
-		vidc_writel(0x8c000000 | (vidc.h_display_start << 14));
-		vidc_writel(0x90000000 | (vidc.h_display_end << 14));
-		vidc_writel(0x94000000 | (vidc.h_border_end << 14));
-		vidc_writel(0x98000000);
-		vidc_writel(0x9c000000 | (vidc.h_interlace << 14));
-		vidc_writel(0xa0000000 | (vidc.v_cycle << 14));
-		vidc_writel(0xa4000000 | (vidc.v_sync_width << 14));
-		vidc_writel(0xa8000000 | (vidc.v_border_start << 14));
-		vidc_writel(0xac000000 | (vidc.v_display_start << 14));
-		vidc_writel(0xb0000000 | (vidc.v_display_end << 14));
-		vidc_writel(0xb4000000 | (vidc.v_border_end << 14));
-		vidc_writel(0xb8000000);
-		vidc_writel(0xbc000000);
-	}
-#ifdef DEBUG_MODE_SELECTION
-	printk(KERN_DEBUG "VIDC registers for %dx%dx%d:\n", var->xres,
-	       var->yres, var->bits_per_pixel);
-	printk(KERN_DEBUG " H-cycle          : %d\n", vidc.h_cycle);
-	printk(KERN_DEBUG " H-sync-width     : %d\n", vidc.h_sync_width);
-	printk(KERN_DEBUG " H-border-start   : %d\n", vidc.h_border_start);
-	printk(KERN_DEBUG " H-display-start  : %d\n", vidc.h_display_start);
-	printk(KERN_DEBUG " H-display-end    : %d\n", vidc.h_display_end);
-	printk(KERN_DEBUG " H-border-end     : %d\n", vidc.h_border_end);
-	printk(KERN_DEBUG " H-interlace      : %d\n", vidc.h_interlace);
-	printk(KERN_DEBUG " V-cycle          : %d\n", vidc.v_cycle);
-	printk(KERN_DEBUG " V-sync-width     : %d\n", vidc.v_sync_width);
-	printk(KERN_DEBUG " V-border-start   : %d\n", vidc.v_border_start);
-	printk(KERN_DEBUG " V-display-start  : %d\n", vidc.v_display_start);
-	printk(KERN_DEBUG " V-display-end    : %d\n", vidc.v_display_end);
-	printk(KERN_DEBUG " V-border-end     : %d\n", vidc.v_border_end);
-	printk(KERN_DEBUG " VIDC Ctrl (E)    : 0x%08X\n", vidc_ctl);
-	printk(KERN_DEBUG " IOEB Ctrl        : 0x%08X\n", vid_ctl);
-#endif
-}
-
-static int
-acornfb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
-		  u_int trans, struct fb_info *info)
-{
-	union palette pal;
-
-	if (regno >= current_par.palette_size)
-		return 1;
-
-	pal.p = 0;
-	pal.vidc.reg   = regno;
-	pal.vidc.red   = red >> 12;
-	pal.vidc.green = green >> 12;
-	pal.vidc.blue  = blue >> 12;
-
-	current_par.palette[regno] = pal;
-
-	vidc_writel(pal.p);
-
-	return 0;
-}
-#endif
-
 #ifdef HAS_VIDC20
 #include <mach/acornfb.h>
 
@@ -634,16 +394,7 @@ acornfb_adjust_timing(struct fb_info *in
 	/* hsync_len must be even */
 	var->hsync_len = (var->hsync_len + 1) & ~1;
 
-#ifdef HAS_VIDC
-	/* left_margin must be odd */
-	if ((var->left_margin & 1) == 0) {
-		var->left_margin -= 1;
-		var->right_margin += 1;
-	}
-
-	/* right_margin must be odd */
-	var->right_margin |= 1;
-#elif defined(HAS_VIDC20)
+#if defined(HAS_VIDC20)
 	/* left_margin must be even */
 	if (var->left_margin & 1) {
 		var->left_margin += 1;
@@ -787,11 +538,7 @@ static int acornfb_set_par(struct fb_inf
 		break;
 	case 8:
 		current_par.palette_size = VIDC_PALETTE_SIZE;
-#ifdef HAS_VIDC
-		info->fix.visual = FB_VISUAL_STATIC_PSEUDOCOLOR;
-#else
 		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
-#endif
 		break;
 #ifdef HAS_VIDC20
 	case 16:
@@ -971,9 +718,6 @@ static void acornfb_init_fbinfo(void)
 #if defined(HAS_VIDC20)
 	fb_info.var.red.length	   = 8;
 	fb_info.var.transp.length  = 4;
-#elif defined(HAS_VIDC)
-	fb_info.var.red.length	   = 4;
-	fb_info.var.transp.length  = 1;
 #endif
 	fb_info.var.green	   = fb_info.var.red;
 	fb_info.var.blue	   = fb_info.var.red;
@@ -1310,14 +1054,6 @@ static int acornfb_probe(struct platform
 		fb_info.fix.smem_start = handle;
 	}
 #endif
-#if defined(HAS_VIDC)
-	/*
-	 * Archimedes/A5000 machines use a fixed address for their
-	 * framebuffers.  Free unused pages
-	 */
-	free_unused_pages(PAGE_OFFSET + size, PAGE_OFFSET + MAX_SIZE);
-#endif
-
 	fb_info.fix.smem_len = size;
 	current_par.palette_size   = VIDC_PALETTE_SIZE;
 
diff -puN drivers/video/acornfb.h~drivers-video-acornfbc-remove-dead-code drivers/video/acornfb.h
--- a/drivers/video/acornfb.h~drivers-video-acornfbc-remove-dead-code
+++ a/drivers/video/acornfb.h
@@ -13,10 +13,6 @@
 #include <asm/hardware/iomd.h>
 #define VIDC_PALETTE_SIZE	256
 #define VIDC_NAME		"VIDC20"
-#elif defined(HAS_VIDC)
-#include <asm/hardware/memc.h>
-#define VIDC_PALETTE_SIZE	16
-#define VIDC_NAME		"VIDC"
 #endif
 
 #define EXTEND8(x) ((x)|(x)<<8)
@@ -101,31 +97,6 @@ struct modex_params {
 	const struct modey_params *modey;
 };
 
-#ifdef HAS_VIDC
-
-#define VID_CTL_VS_NVSYNC	(1 << 3)
-#define VID_CTL_HS_NHSYNC	(1 << 2)
-#define VID_CTL_24MHz		(0)
-#define VID_CTL_25MHz		(1)
-#define VID_CTL_36MHz		(2)
-
-#define VIDC_CTRL_CSYNC		(1 << 7)
-#define VIDC_CTRL_INTERLACE	(1 << 6)
-#define VIDC_CTRL_FIFO_0_4	(0 << 4)
-#define VIDC_CTRL_FIFO_1_5	(1 << 4)
-#define VIDC_CTRL_FIFO_2_6	(2 << 4)
-#define VIDC_CTRL_FIFO_3_7	(3 << 4)
-#define VIDC_CTRL_1BPP		(0 << 2)
-#define VIDC_CTRL_2BPP		(1 << 2)
-#define VIDC_CTRL_4BPP		(2 << 2)
-#define VIDC_CTRL_8BPP		(3 << 2)
-#define VIDC_CTRL_DIV3		(0 << 0)
-#define VIDC_CTRL_DIV2		(1 << 0)
-#define VIDC_CTRL_DIV1_5	(2 << 0)
-#define VIDC_CTRL_DIV1		(3 << 0)
-
-#endif
