From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-laguna-chipset-8bpp-fix.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:39 -0700
Message-ID: <200904011842.n31Igd3g009770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490AbZDATHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: Laguna chipset 8bpp fix
has been removed from the -mm tree.  Its filename was
     cirrusfb-laguna-chipset-8bpp-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: Laguna chipset 8bpp fix
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix 8bpp mode by adding handling of the Laguna chipsets to various places
and stop trashing a HDR register which probably does not exist on the
Laguna.

Fix compilation warnings about uninitialized variables also.

Finally, all 8bpp, 16bpp and 32bpp modes work on the Laguna chipset.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   34 +++++++++++++++++++++-------------
 include/video/cirrus.h   |    1 -
 2 files changed, 21 insertions(+), 14 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-laguna-chipset-8bpp-fix drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-laguna-chipset-8bpp-fix
+++ a/drivers/video/cirrusfb.c
@@ -660,7 +660,7 @@ static int cirrusfb_set_par_foo(struct f
 	int yres, vdispend, vsyncstart, vsyncend, vtotal;
 	long freq;
 	int nom, den, div;
-	unsigned int control, format, threshold;
+	unsigned int control = 0, format = 0, threshold = 0;
 
 	dev_dbg(info->device, "Requested mode: %dx%dx%d\n",
 	       var->xres, var->yres, var->bits_per_pixel);
@@ -842,8 +842,7 @@ static int cirrusfb_set_par_foo(struct f
 		threshold = fb_readw(cinfo->laguna_mmio + 0xea);
 		control &= ~0x6800;
 		format = 0;
-		threshold &= 0xffe0;
-		threshold &= 0x3fbf;
+		threshold &= 0xffe0 & 0x3fbf;
 	}
 	if (nom) {
 		tmp = den << 1;
@@ -893,6 +892,8 @@ static int cirrusfb_set_par_foo(struct f
 		tmp |= 0x40;
 	if (var->sync & FB_SYNC_VERT_HIGH_ACT)
 		tmp |= 0x80;
+	if (cinfo->btype == BT_LAGUNA)
+		tmp |= 0xc;
 	WGen(cinfo, VGA_MIS_W, tmp);
 
 	/* Screen A Preset Row-Scan register */
@@ -1228,9 +1229,7 @@ static int cirrusfb_set_par_foo(struct f
 	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19)
 		vga_wcrt(regbase, CL_CRT1D, (pitch >> 9) & 1);
 
-	if (cinfo->btype == BT_LAGUNA ||
-	    cinfo->btype == BT_GD5480) {
-
+	if (cinfo->btype == BT_LAGUNA) {
 		tmp = 0;
 		if ((htotal + 5) & 256)
 			tmp |= 128;
@@ -1360,7 +1359,8 @@ static int cirrusfb_pan_display(struct f
 		xpix = (unsigned char) ((xoffset % 4) * 2);
 	}
 
-	cirrusfb_WaitBLT(cinfo->regbase); /* make sure all the BLT's are done */
+	if (cinfo->btype != BT_LAGUNA)
+		cirrusfb_WaitBLT(cinfo->regbase);
 
 	/* lower 8 + 8 bits of screen start address */
 	vga_wcrt(cinfo->regbase, VGA_CRTC_START_LO,
@@ -1394,7 +1394,8 @@ static int cirrusfb_pan_display(struct f
 	if (info->var.bits_per_pixel == 1)
 		vga_wattr(cinfo->regbase, CL_AR33, xpix);
 
-	cirrusfb_WaitBLT(cinfo->regbase);
+	if (cinfo->btype != BT_LAGUNA)
+		cirrusfb_WaitBLT(cinfo->regbase);
 
 	return 0;
 }
@@ -1513,6 +1514,7 @@ static void init_vgachip(struct fb_info 
 		vga_wgfx(cinfo->regbase, CL_GR2F, 0x00);
 		break;
 
+	case BT_LAGUNA:
 	case BT_ALPINE:
 		/* Nothing to do to reset the board. */
 		break;
@@ -1538,7 +1540,7 @@ static void init_vgachip(struct fb_info 
 			WGen(cinfo, CL_VSSM2, 0x01);
 
 		/* reset sequencer logic */
-		vga_wseq(cinfo->regbase, CL_SEQR0, 0x03);
+		vga_wseq(cinfo->regbase, VGA_SEQ_RESET, 0x03);
 
 		/* FullBandwidth (video off) and 8/9 dot clock */
 		vga_wseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE, 0x21);
@@ -1560,6 +1562,7 @@ static void init_vgachip(struct fb_info 
 			vga_wseq(cinfo->regbase, CL_SEQRF, 0x98);
 			break;
 		case BT_ALPINE:
+		case BT_LAGUNA:
 			break;
 		case BT_SD64:
 			vga_wseq(cinfo->regbase, CL_SEQRF, 0xb8);
@@ -1648,7 +1651,8 @@ static void init_vgachip(struct fb_info 
 	vga_wgfx(cinfo->regbase, VGA_GFX_COMPARE_MASK, 0x0f);
 	/* Bit Mask: no mask at all */
 	vga_wgfx(cinfo->regbase, VGA_GFX_BIT_MASK, 0xff);
-	if (cinfo->btype == BT_ALPINE)
+
+	if (cinfo->btype == BT_ALPINE || cinfo->btype == BT_LAGUNA)
 		/* (5434 can't have bit 3 set for bitblt) */
 		vga_wgfx(cinfo->regbase, CL_GRB, 0x20);
 	else
@@ -1845,7 +1849,8 @@ static void cirrusfb_imageblit(struct fb
 {
 	struct cirrusfb_info *cinfo = info->par;
 
-	cirrusfb_WaitBLT(cinfo->regbase);
+	if (cinfo->btype != BT_LAGUNA)
+		cirrusfb_WaitBLT(cinfo->regbase);
 	cfb_imageblit(info, image);
 }
 
@@ -1992,7 +1997,7 @@ static int __devinit cirrusfb_set_fbinfo
 		    | FBINFO_HWACCEL_YPAN
 		    | FBINFO_HWACCEL_FILLRECT
 		    | FBINFO_HWACCEL_COPYAREA;
-	if (noaccel)
+	if (noaccel || cinfo->btype == BT_LAGUNA)
 		info->flags |= FBINFO_HWACCEL_DISABLED;
 	info->fbops = &cirrusfb_ops;
 	if (cinfo->btype == BT_GD5480) {
@@ -2481,6 +2486,8 @@ static void WHDR(const struct cirrusfb_i
 {
 	unsigned char dummy;
 
+	if (cinfo->btype == BT_LAGUNA)
+		return;
 	if (cinfo->btype == BT_PICASSO) {
 		/* Klaus' hint for correct access to HDR on some boards */
 		/* first write 0 to pixel mask (3c6) */
@@ -2548,7 +2555,8 @@ static void WClut(struct cirrusfb_info *
 	vga_w(cinfo->regbase, VGA_PEL_IW, regnum);
 
 	if (cinfo->btype == BT_PICASSO || cinfo->btype == BT_PICASSO4 ||
-	    cinfo->btype == BT_ALPINE || cinfo->btype == BT_GD5480) {
+	    cinfo->btype == BT_ALPINE || cinfo->btype == BT_GD5480 ||
+	    cinfo->btype == BT_LAGUNA) {
 		/* but DAC data register IS, at least for Picasso II */
 		if (cinfo->btype == BT_PICASSO)
 			data += 0xfff;
diff -puN include/video/cirrus.h~cirrusfb-laguna-chipset-8bpp-fix include/video/cirrus.h
--- a/include/video/cirrus.h~cirrusfb-laguna-chipset-8bpp-fix
+++ a/include/video/cirrus.h
@@ -32,7 +32,6 @@
 #define CL_VSSM2	0x3c3	/* Motherboard Sleep */
 
 /*** VGA Sequencer Registers ***/
-#define CL_SEQR0	0x0	/* Reset */
 /* the following are from the "extension registers" group */
 #define CL_SEQR6	0x6	/* Unlock ALL Extensions */
 #define CL_SEQR7	0x7	/* Extended Sequencer Mode */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

