From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-add-laguna-additional-overflow-register.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:28 -0700
Message-ID: <200904011842.n31IgSqX009694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765380AbZDATQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:16:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: add Laguna additional overflow register
has been removed from the -mm tree.  Its filename was
     cirrusfb-add-laguna-additional-overflow-register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: add Laguna additional overflow register
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add additional overflow register setting for Laguna chips.

Also, simplify some code in the cirrusfb_pan_display() and
cirrusfb_blank().

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   68 ++++++++++++++++++++++---------------
 include/video/cirrus.h   |    1 
 2 files changed, 43 insertions(+), 26 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-add-laguna-additional-overflow-register drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-add-laguna-additional-overflow-register
+++ a/drivers/video/cirrusfb.c
@@ -1259,13 +1259,32 @@ static int cirrusfb_set_par_foo(struct f
 	/* screen start addr #16-18, fastpagemode cycles */
 	vga_wcrt(regbase, CL_CRT1B, tmp);
 
-	if (cinfo->btype == BT_SD64 ||
-	    cinfo->btype == BT_PICASSO4 ||
-	    cinfo->btype == BT_ALPINE ||
-	    cinfo->btype == BT_GD5480)
-		/* screen start address bit 19 */
+	/* screen start address bit 19 */
+	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19)
 		vga_wcrt(regbase, CL_CRT1D, 0x00);
 
+	if (cinfo->btype == BT_LAGUNA ||
+	    cinfo->btype == BT_GD5480) {
+
+		tmp = 0;
+		if ((htotal + 5) & 256)
+			tmp |= 128;
+		if (hdispend & 256)
+			tmp |= 64;
+		if (hsyncstart & 256)
+			tmp |= 48;
+		if (vtotal & 1024)
+			tmp |= 8;
+		if (vdispend & 1024)
+			tmp |= 4;
+		if (vsyncstart & 1024)
+			tmp |= 3;
+
+		vga_wcrt(regbase, CL_CRT1E, tmp);
+		dev_dbg(info->device, "CRT1e: %d\n", tmp);
+	}
+
+
 	/* text cursor location high */
 	vga_wcrt(regbase, VGA_CRTC_CURSOR_HI, 0);
 	/* text cursor location low */
@@ -1383,7 +1402,7 @@ static int cirrusfb_pan_display(struct f
 	int xoffset = 0;
 	int yoffset = 0;
 	unsigned long base;
-	unsigned char tmp = 0, tmp2 = 0, xpix;
+	unsigned char tmp, xpix;
 	struct cirrusfb_info *cinfo = info->par;
 
 	dev_dbg(info->device,
@@ -1418,6 +1437,8 @@ static int cirrusfb_pan_display(struct f
 	vga_wcrt(cinfo->regbase, VGA_CRTC_START_HI,
 		 (unsigned char) (base >> 8));
 
+	/* 0xf2 is %11110010, exclude tmp bits */
+	tmp = vga_rcrt(cinfo->regbase, CL_CRT1B) & 0xf2;
 	/* construct bits 16, 17 and 18 of screen start address */
 	if (base & 0x10000)
 		tmp |= 0x01;
@@ -1426,9 +1447,7 @@ static int cirrusfb_pan_display(struct f
 	if (base & 0x40000)
 		tmp |= 0x08;
 
-	/* 0xf2 is %11110010, exclude tmp bits */
-	tmp2 = (vga_rcrt(cinfo->regbase, CL_CRT1B) & 0xf2) | tmp;
-	vga_wcrt(cinfo->regbase, CL_CRT1B, tmp2);
+	vga_wcrt(cinfo->regbase, CL_CRT1B, tmp);
 
 	/* construct bit 19 of screen start address */
 	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19)
@@ -1473,47 +1492,44 @@ static int cirrusfb_blank(int blank_mode
 
 	/* Undo current */
 	if (current_mode == FB_BLANK_NORMAL ||
-	    current_mode == FB_BLANK_UNBLANK) {
-		/* unblank the screen */
-		val = vga_rseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE);
+	    current_mode == FB_BLANK_UNBLANK)
 		/* clear "FullBandwidth" bit */
-		vga_wseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE, val & 0xdf);
-		/* and undo VESA suspend trickery */
-		vga_wgfx(cinfo->regbase, CL_GRE, 0x00);
-	}
-
-	/* set new */
-	if (blank_mode > FB_BLANK_NORMAL) {
-		/* blank the screen */
-		val = vga_rseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE);
+		val = 0;
+	else
 		/* set "FullBandwidth" bit */
-		vga_wseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE, val | 0x20);
-	}
+		val = 0x20;
+
+	val |= vga_rseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE) & 0xdf;
+	vga_wseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE, val);
 
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
 	case FB_BLANK_NORMAL:
+		val = 0x00;
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
-		vga_wgfx(cinfo->regbase, CL_GRE, 0x04);
+		val = 0x04;
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
-		vga_wgfx(cinfo->regbase, CL_GRE, 0x02);
+		val = 0x02;
 		break;
 	case FB_BLANK_POWERDOWN:
-		vga_wgfx(cinfo->regbase, CL_GRE, 0x06);
+		val = 0x06;
 		break;
 	default:
 		dev_dbg(info->device, "EXIT, returning 1\n");
 		return 1;
 	}
 
+	vga_wgfx(cinfo->regbase, CL_GRE, val);
+
 	cinfo->blank_mode = blank_mode;
 	dev_dbg(info->device, "EXIT, returning 0\n");
 
 	/* Let fbcon do a soft blank for us */
 	return (blank_mode == FB_BLANK_NORMAL) ? 1 : 0;
 }
+
 /**** END   Hardware specific Routines **************************************/
 /****************************************************************************/
 /**** BEGIN Internal Routines ***********************************************/
diff -puN include/video/cirrus.h~cirrusfb-add-laguna-additional-overflow-register include/video/cirrus.h
--- a/include/video/cirrus.h~cirrusfb-add-laguna-additional-overflow-register
+++ a/include/video/cirrus.h
@@ -71,6 +71,7 @@
 #define CL_CRT1B	0x1b	/* Extended Display Controls */
 #define CL_CRT1C	0x1c	/* Sync adjust and genlock register */
 #define CL_CRT1D	0x1d	/* Overlay Extended Control register */
+#define CL_CRT1E	0x1e	/* Another overflow register */
 #define CL_CRT25	0x25	/* Part Status Register */
 #define CL_CRT27	0x27	/* ID Register */
 #define CL_CRT51	0x51	/* P4 disable "flicker fixer" */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

