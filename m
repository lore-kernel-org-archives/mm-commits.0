From: akpm@linux-foundation.org
Subject: - pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:05 -0700
Message-ID: <200805010925.m419P518030166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755304AbYEAJZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: purge unnecessary pr_debug and comments from pxafb
has been removed from the -mm tree.  Its filename was
     pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: purge unnecessary pr_debug and comments from pxafb
From: eric miao <eric.miao@marvell.com>

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |   71 ----------------------------------------
 1 file changed, 71 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb
+++ a/drivers/video/pxafb.c
@@ -355,7 +355,6 @@ static int pxafb_check_var(struct fb_var
 
 static inline void pxafb_set_truecolor(u_int is_true_color)
 {
-	pr_debug("pxafb: true_color = %d\n", is_true_color);
 	/* do your machine-specific setup if needed */
 }
 
@@ -369,8 +368,6 @@ static int pxafb_set_par(struct fb_info 
 	struct fb_var_screeninfo *var = &info->var;
 	unsigned long palette_mem_size;
 
-	pr_debug("pxafb: set_par\n");
-
 	if (var->bits_per_pixel == 16)
 		fbi->fb.fix.visual = FB_VISUAL_TRUECOLOR;
 	else if (!fbi->cmap_static)
@@ -397,8 +394,6 @@ static int pxafb_set_par(struct fb_info 
 	else
 		palette_mem_size = fbi->palette_size * sizeof(u32);
 
-	pr_debug("pxafb: palette_mem_size = 0x%08lx\n", palette_mem_size);
-
 	fbi->palette_cpu = (u16 *)(fbi->map_cpu + PAGE_SIZE - palette_mem_size);
 	fbi->palette_dma = fbi->map_dma + PAGE_SIZE - palette_mem_size;
 
@@ -418,36 +413,6 @@ static int pxafb_set_par(struct fb_info 
 }
 
 /*
- * Formal definition of the VESA spec:
- *  On
- *  	This refers to the state of the display when it is in full operation
- *  Stand-By
- *  	This defines an optional operating state of minimal power reduction with
- *  	the shortest recovery time
- *  Suspend
- *  	This refers to a level of power management in which substantial power
- *  	reduction is achieved by the display.  The display can have a longer
- *  	recovery time from this state than from the Stand-by state
- *  Off
- *  	This indicates that the display is consuming the lowest level of power
- *  	and is non-operational. Recovery from this state may optionally require
- *  	the user to manually power on the monitor
- *
- *  Now, the fbdev driver adds an additional state, (blank), where they
- *  turn off the video (maybe by colormap tricks), but don't mess with the
- *  video itself: think of it semantically between on and Stand-By.
- *
- *  So here's what we should do in our fbdev blank routine:
- *
- *  	VESA_NO_BLANKING (mode 0)	Video on,  front/back light on
- *  	VESA_VSYNC_SUSPEND (mode 1)  	Video on,  front/back light off
- *  	VESA_HSYNC_SUSPEND (mode 2)  	Video on,  front/back light off
- *  	VESA_POWERDOWN (mode 3)		Video off, front/back light off
- *
- *  This will match the matrox implementation.
- */
-
-/*
  * pxafb_blank():
  *	Blank the display by setting all palette values to zero.  Note, the
  * 	16 bpp mode does not really use the palette, so this will not
@@ -458,8 +423,6 @@ static int pxafb_blank(int blank, struct
 	struct pxafb_info *fbi = (struct pxafb_info *)info;
 	int i;
 
-	pr_debug("pxafb: blank=%d\n", blank);
-
 	switch (blank) {
 	case FB_BLANK_POWERDOWN:
 	case FB_BLANK_VSYNC_SUSPEND:
@@ -600,16 +563,6 @@ static int pxafb_activate_var(struct fb_
 	u_long flags;
 	u_int lines_per_panel, pcd = get_pcd(fbi, var->pixclock);
 
-	pr_debug("pxafb: Configuring PXA LCD\n");
-
-	pr_debug("var: xres=%d hslen=%d lm=%d rm=%d\n",
-		 var->xres, var->hsync_len,
-		 var->left_margin, var->right_margin);
-	pr_debug("var: yres=%d vslen=%d um=%d bm=%d\n",
-		 var->yres, var->vsync_len,
-		 var->upper_margin, var->lower_margin);
-	pr_debug("var: pixclock=%d pcd=%d\n", var->pixclock, pcd);
-
 #if DEBUG_VAR
 	if (var->xres < 16 || var->xres > 1024)
 		printk(KERN_ERR "%s: invalid xres %d\n",
@@ -683,11 +636,6 @@ static int pxafb_activate_var(struct fb_
 	if (pcd)
 		new_regs.lccr3 |= LCCR3_PixClkDiv(pcd);
 
-	pr_debug("nlccr0 = 0x%08x\n", new_regs.lccr0);
-	pr_debug("nlccr1 = 0x%08x\n", new_regs.lccr1);
-	pr_debug("nlccr2 = 0x%08x\n", new_regs.lccr2);
-	pr_debug("nlccr3 = 0x%08x\n", new_regs.lccr3);
-
 	/* Update shadow copy atomically */
 	local_irq_save(flags);
 
@@ -849,22 +797,12 @@ static void pxafb_enable_controller(stru
 	FDADR0 = fbi->fdadr0;
 	FDADR1 = fbi->fdadr1;
 	LCCR0 |= LCCR0_ENB;
-
-	pr_debug("FDADR0 0x%08x\n", (unsigned int) FDADR0);
-	pr_debug("FDADR1 0x%08x\n", (unsigned int) FDADR1);
-	pr_debug("LCCR0 0x%08x\n", (unsigned int) LCCR0);
-	pr_debug("LCCR1 0x%08x\n", (unsigned int) LCCR1);
-	pr_debug("LCCR2 0x%08x\n", (unsigned int) LCCR2);
-	pr_debug("LCCR3 0x%08x\n", (unsigned int) LCCR3);
-	pr_debug("LCCR4 0x%08x\n", (unsigned int) LCCR4);
 }
 
 static void pxafb_disable_controller(struct pxafb_info *fbi)
 {
 	DECLARE_WAITQUEUE(wait, current);
 
-	pr_debug("pxafb: disabling LCD controller\n");
-
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&fbi->ctrlr_wait, &wait);
 
@@ -1124,9 +1062,6 @@ static int __init pxafb_map_video_memory
 		else
 			palette_mem_size = fbi->palette_size * sizeof(u32);
 
-		pr_debug("pxafb: palette_mem_size = 0x%08lx\n",
-				palette_mem_size);
-
 		fbi->palette_cpu = (u16 *)(fbi->map_cpu + PAGE_SIZE
 						- palette_mem_size);
 		fbi->palette_dma = fbi->map_dma + PAGE_SIZE - palette_mem_size;
@@ -1483,10 +1418,6 @@ static int __init pxafb_probe(struct pla
 		goto failed;
 	}
 
-#ifdef CONFIG_PM
-	/* TODO */
-#endif
