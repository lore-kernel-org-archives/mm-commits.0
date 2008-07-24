From: akpm@linux-foundation.org
Subject: - vga16fb-source-code-improvement.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:11 -0700
Message-ID: <200807242332.m6ONWBht011808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756471AbYGXXcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     vga16fb: source code improvement
has been removed from the -mm tree.  Its filename was
     vga16fb-source-code-improvement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vga16fb: source code improvement
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use constants and functions from the vga.h file.  Also add module
description.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vga16fb.c |  117 ++++++++++++--------------------------
 1 file changed, 39 insertions(+), 78 deletions(-)

diff -puN drivers/video/vga16fb.c~vga16fb-source-code-improvement drivers/video/vga16fb.c
--- a/drivers/video/vga16fb.c~vga16fb-source-code-improvement
+++ a/drivers/video/vga16fb.c
@@ -26,18 +26,6 @@
 #include <asm/io.h>
 #include <video/vga.h>
 
-#define GRAPHICS_ADDR_REG VGA_GFX_I	/* Graphics address register. */
-#define GRAPHICS_DATA_REG VGA_GFX_D	/* Graphics data register. */
-
-#define SET_RESET_INDEX 	VGA_GFX_SR_VALUE	/* Set/Reset Register index. */
-#define ENABLE_SET_RESET_INDEX	VGA_GFX_SR_ENABLE	/* Enable Set/Reset Register index. */
-#define DATA_ROTATE_INDEX	VGA_GFX_DATA_ROTATE	/* Data Rotate Register index. */
-#define GRAPHICS_MODE_INDEX	VGA_GFX_MODE		/* Graphics Mode Register index. */
-#define BIT_MASK_INDEX		VGA_GFX_BIT_MASK	/* Bit Mask Register index. */
-
-#define dac_reg	(VGA_PEL_IW)
-#define dac_val	(VGA_PEL_D)
-
 #define VGA_FB_PHYS 0xA0000
 #define VGA_FB_PHYS_LEN 65536
 
@@ -108,7 +96,7 @@ static struct fb_fix_screeninfo vga16fb_
 	.visual		= FB_VISUAL_PSEUDOCOLOR,
 	.xpanstep	= 8,
 	.ypanstep	= 1,
-	.line_length	= 640/8,
+	.line_length	= 640 / 8,
 	.accel		= FB_ACCEL_NONE
 };
 
@@ -135,23 +123,22 @@ static inline int setmode(int mode)
 {
 	int oldmode;
 	
-	vga_io_w(GRAPHICS_ADDR_REG, GRAPHICS_MODE_INDEX);
-	oldmode = vga_io_r(GRAPHICS_DATA_REG);
-	vga_io_w(GRAPHICS_DATA_REG, mode);
+	oldmode = vga_io_rgfx(VGA_GFX_MODE);
+	vga_io_w(VGA_GFX_D, mode);
 	return oldmode;
 }
 
 /* Select the Bit Mask Register and return its value. */
 static inline int selectmask(void)
 {
-	return vga_io_rgfx(BIT_MASK_INDEX);
+	return vga_io_rgfx(VGA_GFX_BIT_MASK);
 }
 
 /* Set the value of the Bit Mask Register.  It must already have been
    selected with selectmask(). */
 static inline void setmask(int mask)
 {
-	vga_io_w(GRAPHICS_DATA_REG, mask);
+	vga_io_w(VGA_GFX_D, mask);
 }
 
 /* Set the Data Rotate Register and return its old value. 
@@ -161,9 +148,8 @@ static inline int setop(int op)
 {
 	int oldop;
 	
-	vga_io_w(GRAPHICS_ADDR_REG, DATA_ROTATE_INDEX);
-	oldop = vga_io_r(GRAPHICS_DATA_REG);
-	vga_io_w(GRAPHICS_DATA_REG, op);
+	oldop = vga_io_rgfx(VGA_GFX_DATA_ROTATE);
+	vga_io_w(VGA_GFX_D, op);
 	return oldop;
 }
 
@@ -173,9 +159,8 @@ static inline int setsr(int sr)
 {
 	int oldsr;
 
-	vga_io_w(GRAPHICS_ADDR_REG, ENABLE_SET_RESET_INDEX);
-	oldsr = vga_io_r(GRAPHICS_DATA_REG);
-	vga_io_w(GRAPHICS_DATA_REG, sr);
+	oldsr = vga_io_rgfx(VGA_GFX_SR_ENABLE);
+	vga_io_w(VGA_GFX_D, sr);
 	return oldsr;
 }
 
@@ -184,22 +169,21 @@ static inline int setcolor(int color)
 {
 	int oldcolor;
 
-	vga_io_w(GRAPHICS_ADDR_REG, SET_RESET_INDEX);
-	oldcolor = vga_io_r(GRAPHICS_DATA_REG);
-	vga_io_w(GRAPHICS_DATA_REG, color);
+	oldcolor = vga_io_rgfx(VGA_GFX_SR_VALUE);
+	vga_io_w(VGA_GFX_D, color);
 	return oldcolor;
 }
 
 /* Return the value in the Graphics Address Register. */
 static inline int getindex(void)
 {
-	return vga_io_r(GRAPHICS_ADDR_REG);
+	return vga_io_r(VGA_GFX_I);
 }
 
 /* Set the value in the Graphics Address Register. */
 static inline void setindex(int index)
 {
-	vga_io_w(GRAPHICS_ADDR_REG, index);
+	vga_io_w(VGA_GFX_I, index);
 }
 
 static void vga16fb_pan_var(struct fb_info *info, 
@@ -672,10 +656,10 @@ static void ega16_setpalette(int regno, 
 
 static void vga16_setpalette(int regno, unsigned red, unsigned green, unsigned blue)
 {
-	outb(regno,       dac_reg);
-	outb(red   >> 10, dac_val);
-	outb(green >> 10, dac_val);
-	outb(blue  >> 10, dac_val);
+	outb(regno,       VGA_PEL_IW);
+	outb(red   >> 10, VGA_PEL_D);
+	outb(green >> 10, VGA_PEL_D);
+	outb(blue  >> 10, VGA_PEL_D);
 }
 
 static int vga16fb_setcolreg(unsigned regno, unsigned red, unsigned green,
@@ -719,28 +703,15 @@ static int vga16fb_pan_display(struct fb
    blanking code was originally by Huang shi chao, and modified by
    Christoph Rimek (chrimek@toppoint.de) and todd j. derr
    (tjd@barefoot.org) for Linux. */
-#define attrib_port		VGA_ATC_IW
-#define seq_port_reg		VGA_SEQ_I
-#define seq_port_val		VGA_SEQ_D
-#define gr_port_reg		VGA_GFX_I
-#define gr_port_val		VGA_GFX_D
-#define video_misc_rd		VGA_MIS_R
-#define video_misc_wr		VGA_MIS_W
-#define vga_video_port_reg	VGA_CRT_IC
-#define vga_video_port_val	VGA_CRT_DC
 
 static void vga_vesa_blank(struct vga16fb_par *par, int mode)
 {
-	unsigned char SeqCtrlIndex;
-	unsigned char CrtCtrlIndex;
+	unsigned char SeqCtrlIndex = vga_io_r(VGA_SEQ_I);
+	unsigned char CrtCtrlIndex = vga_io_r(VGA_CRT_IC);
 	
-	//cli();
-	SeqCtrlIndex = vga_io_r(seq_port_reg);
-	CrtCtrlIndex = vga_io_r(vga_video_port_reg);
-
 	/* save original values of VGA controller registers */
 	if(!par->vesa_blanked) {
-		par->vga_state.CrtMiscIO = vga_io_r(video_misc_rd);
+		par->vga_state.CrtMiscIO = vga_io_r(VGA_MIS_R);
 		//sti();
 
 		par->vga_state.HorizontalTotal = vga_io_rcrt(0x00);	/* HorizontalTotal */
@@ -756,12 +727,11 @@ static void vga_vesa_blank(struct vga16f
 
 	/* assure that video is enabled */
 	/* "0x20" is VIDEO_ENABLE_bit in register 01 of sequencer */
-	//cli();
 	vga_io_wseq(0x01, par->vga_state.ClockingMode | 0x20);
 
 	/* test for vertical retrace in process.... */
 	if ((par->vga_state.CrtMiscIO & 0x80) == 0x80)
-		vga_io_w(video_misc_wr, par->vga_state.CrtMiscIO & 0xef);
+		vga_io_w(VGA_MIS_W, par->vga_state.CrtMiscIO & 0xef);
 
 	/*
 	 * Set <End of vertical retrace> to minimum (0) and
@@ -769,12 +739,10 @@ static void vga_vesa_blank(struct vga16f
 	 * Result: turn off vertical sync (VSync) pulse.
 	 */
 	if (mode & FB_BLANK_VSYNC_SUSPEND) {
-		outb_p(0x10,vga_video_port_reg);	/* StartVertRetrace */
-		outb_p(0xff,vga_video_port_val); 	/* maximum value */
-		outb_p(0x11,vga_video_port_reg);	/* EndVertRetrace */
-		outb_p(0x40,vga_video_port_val);	/* minimum (bits 0..3)  */
-		outb_p(0x07,vga_video_port_reg);	/* Overflow */
-		outb_p(par->vga_state.Overflow | 0x84,vga_video_port_val); /* bits 9,10 of vert. retrace */
+		vga_io_wcrt(VGA_CRTC_V_SYNC_START, 0xff);
+		vga_io_wcrt(VGA_CRTC_V_SYNC_END, 0x40);
+		/* bits 9,10 of vert. retrace */
+		vga_io_wcrt(VGA_CRTC_OVERFLOW, par->vga_state.Overflow | 0x84);
 	}
 
 	if (mode & FB_BLANK_HSYNC_SUSPEND) {
@@ -783,29 +751,22 @@ static void vga_vesa_blank(struct vga16f
 		 *  <Start of horizontal Retrace> to maximum
 		 * Result: turn off horizontal sync (HSync) pulse.
 		 */
-		outb_p(0x04,vga_video_port_reg);	/* StartHorizRetrace */
-		outb_p(0xff,vga_video_port_val);	/* maximum */
-		outb_p(0x05,vga_video_port_reg);	/* EndHorizRetrace */
-		outb_p(0x00,vga_video_port_val);	/* minimum (0) */
+		vga_io_wcrt(VGA_CRTC_H_SYNC_START, 0xff);
+		vga_io_wcrt(VGA_CRTC_H_SYNC_END, 0x00);
 	}
 
 	/* restore both index registers */
-	outb_p(SeqCtrlIndex,seq_port_reg);
-	outb_p(CrtCtrlIndex,vga_video_port_reg);
-	//sti();
+	outb_p(SeqCtrlIndex, VGA_SEQ_I);
+	outb_p(CrtCtrlIndex, VGA_CRT_IC);
 }
 
 static void vga_vesa_unblank(struct vga16fb_par *par)
 {
-	unsigned char SeqCtrlIndex;
-	unsigned char CrtCtrlIndex;
+	unsigned char SeqCtrlIndex = vga_io_r(VGA_SEQ_I);
+	unsigned char CrtCtrlIndex = vga_io_r(VGA_CRT_IC);
 	
-	//cli();
-	SeqCtrlIndex = vga_io_r(seq_port_reg);
-	CrtCtrlIndex = vga_io_r(vga_video_port_reg);
-
 	/* restore original values of VGA controller registers */
-	vga_io_w(video_misc_wr, par->vga_state.CrtMiscIO);
+	vga_io_w(VGA_MIS_W, par->vga_state.CrtMiscIO);
 
 	/* HorizontalTotal */
 	vga_io_wcrt(0x00, par->vga_state.HorizontalTotal);
@@ -827,9 +788,8 @@ static void vga_vesa_unblank(struct vga1
 	vga_io_wseq(0x01, par->vga_state.ClockingMode);
 
 	/* restore index/control registers */
-	vga_io_w(seq_port_reg, SeqCtrlIndex);
-	vga_io_w(vga_video_port_reg, CrtCtrlIndex);
-	//sti();
+	vga_io_w(VGA_SEQ_I, SeqCtrlIndex);
+	vga_io_w(VGA_CRT_IC, CrtCtrlIndex);
 }
 
 static void vga_pal_blank(void)
@@ -837,10 +797,10 @@ static void vga_pal_blank(void)
 	int i;
 
 	for (i=0; i<16; i++) {
-		outb_p (i, dac_reg) ;
-		outb_p (0, dac_val) ;
-		outb_p (0, dac_val) ;
-		outb_p (0, dac_val) ;
+		outb_p(i, VGA_PEL_IW);
+		outb_p(0, VGA_PEL_D);
+		outb_p(0, VGA_PEL_D);
+		outb_p(0, VGA_PEL_D);
 	}
 }
 
@@ -1485,6 +1445,7 @@ static void __exit vga16fb_exit(void)
 	platform_driver_unregister(&vga16fb_driver);
 }
 
+MODULE_DESCRIPTION("Legacy VGA framebuffer device driver");
 MODULE_LICENSE("GPL");
 module_init(vga16fb_init);
 module_exit(vga16fb_exit);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

