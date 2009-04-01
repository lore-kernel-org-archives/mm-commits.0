From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-various-laguna-fixes.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:43 -0700
Message-ID: <200904011842.n31IghUd009798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153AbZDATJ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: various Laguna fixes
has been removed from the -mm tree.  Its filename was
     cirrusfb-various-laguna-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: various Laguna fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

- The Laguna GD5465 (AGP) has one register more than non-AGP chips. 
  Recognize the AGP version and write a tile control register only on the
  AGP version.  Tested only on an AGP card.

- Bump up RAMDAC frequencies after X11 code.  This allow to drive a flat
  panel resolution 1680x1050 at 16bpp from the 4MB card.

- Fix screen start address overflow bits on Laguna cards (CRT1D
  register).

- Fix exit path in the cirrusfb_pci_register() in case of error.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   84 +++++++++++++++++++++++++------------
 1 file changed, 57 insertions(+), 27 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-various-laguna-fixes drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-various-laguna-fixes
+++ a/drivers/video/cirrusfb.c
@@ -102,7 +102,8 @@ enum cirrus_board {
 	BT_PICASSO4,	/* GD5446 */
 	BT_ALPINE,	/* GD543x/4x */
 	BT_GD5480,
-	BT_LAGUNA,	/* GD546x */
+	BT_LAGUNA,	/* GD5462/64 */
+	BT_LAGUNAB,	/* GD5465 */
 };
 
 /*
@@ -234,8 +235,18 @@ static const struct cirrusfb_board_info_
 	[BT_LAGUNA] = {
 		.name			= "CL Laguna",
 		.maxclock		= {
-			/* guess */
-			135100, 135100, 135100, 135100, 135100,
+			/* taken from X11 code */
+			170000, 170000, 170000, 170000, 135100,
+		},
+		.init_sr07		= false,
+		.init_sr1f		= false,
+		.scrn_start_bit19	= true,
+	},
+	[BT_LAGUNAB] = {
+		.name			= "CL Laguna AGP",
+		.maxclock		= {
+			/* taken from X11 code */
+			170000, 250000, 170000, 170000, 135100,
 		},
 		.init_sr07		= false,
 		.init_sr1f		= false,
@@ -258,7 +269,7 @@ static struct pci_device_id cirrusfb_pci
 	CHIP(PCI_DEVICE_ID_CIRRUS_5446, BT_PICASSO4), /* Picasso 4 is 5446 */
 	CHIP(PCI_DEVICE_ID_CIRRUS_5462, BT_LAGUNA), /* CL Laguna */
 	CHIP(PCI_DEVICE_ID_CIRRUS_5464, BT_LAGUNA), /* CL Laguna 3D */
-	CHIP(PCI_DEVICE_ID_CIRRUS_5465, BT_LAGUNA), /* CL Laguna 3DA*/
+	CHIP(PCI_DEVICE_ID_CIRRUS_5465, BT_LAGUNAB), /* CL Laguna 3DA*/
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, cirrusfb_pci_table);
@@ -385,6 +396,11 @@ static void cirrusfb_dbg_print_regs(stru
 /*****************************************************************************/
 /*** BEGIN Interface Used by the World ***************************************/
 
+static inline int is_laguna(const struct cirrusfb_info *cinfo)
+{
+	return cinfo->btype == BT_LAGUNA || cinfo->btype == BT_LAGUNAB;
+}
+
 static int opencount;
 
 /*--- Open /dev/fbx ---------------------------------------------------------*/
@@ -814,13 +830,16 @@ static int cirrusfb_set_par_foo(struct f
 			cirrusfb_set_mclk_as_source(info, divMCLK);
 		}
 	}
-	if (cinfo->btype == BT_LAGUNA) {
+	if (is_laguna(cinfo)) {
 		long pcifc = fb_readl(cinfo->laguna_mmio + 0x3fc);
 		unsigned char tile = fb_readb(cinfo->laguna_mmio + 0x407);
 		unsigned short tile_control;
 
-		tile_control = fb_readw(cinfo->laguna_mmio + 0x2c4);
-		fb_writew(tile_control & ~0x80, cinfo->laguna_mmio + 0x2c4);
+		if (cinfo->btype == BT_LAGUNAB) {
+			tile_control = fb_readw(cinfo->laguna_mmio + 0x2c4);
+			tile_control &= ~0x80;
+			fb_writew(tile_control, cinfo->laguna_mmio + 0x2c4);
+		}
 
 		fb_writel(pcifc | 0x10000000l, cinfo->laguna_mmio + 0x3fc);
 		fb_writeb(tile & 0x3f, cinfo->laguna_mmio + 0x407);
@@ -842,7 +861,7 @@ static int cirrusfb_set_par_foo(struct f
 
 		dev_dbg(info->device, "CL_SEQR1B: %d\n", (int) tmp);
 		/* Laguna chipset has reversed clock registers */
-		if (cinfo->btype == BT_LAGUNA) {
+		if (is_laguna(cinfo)) {
 			vga_wseq(regbase, CL_SEQRE, tmp);
 			vga_wseq(regbase, CL_SEQR1E, nom);
 		} else {
@@ -873,7 +892,7 @@ static int cirrusfb_set_par_foo(struct f
 		tmp |= 0x40;
 	if (var->sync & FB_SYNC_VERT_HIGH_ACT)
 		tmp |= 0x80;
-	if (cinfo->btype == BT_LAGUNA)
+	if (is_laguna(cinfo))
 		tmp |= 0xc;
 	WGen(cinfo, VGA_MIS_W, tmp);
 
@@ -908,6 +927,7 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_LAGUNA:
+		case BT_LAGUNAB:
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) & ~0x01);
 			break;
@@ -947,6 +967,7 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_ALPINE:
 		case BT_GD5480:
 		case BT_LAGUNA:
+		case BT_LAGUNAB:
 			/* do nothing */
 			break;
 
@@ -991,6 +1012,7 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_LAGUNA:
+		case BT_LAGUNAB:
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) | 0x01);
 			threshold |= 0x10;
@@ -1030,6 +1052,7 @@ static int cirrusfb_set_par_foo(struct f
 
 		case BT_GD5480:
 		case BT_LAGUNA:
+		case BT_LAGUNAB:
 			/* do nothing */
 			break;
 
@@ -1096,6 +1119,7 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_LAGUNA:
+		case BT_LAGUNAB:
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) & ~0x01);
 			control |= 0x2000;
@@ -1166,6 +1190,7 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_LAGUNA:
+		case BT_LAGUNAB:
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) & ~0x01);
 			control |= 0x6000;
@@ -1208,7 +1233,7 @@ static int cirrusfb_set_par_foo(struct f
 	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19)
 		vga_wcrt(regbase, CL_CRT1D, (pitch >> 9) & 1);
 
-	if (cinfo->btype == BT_LAGUNA) {
+	if (is_laguna(cinfo)) {
 		tmp = 0;
 		if ((htotal + 5) & 256)
 			tmp |= 128;
@@ -1234,7 +1259,7 @@ static int cirrusfb_set_par_foo(struct f
 	/* From SetOffset(): Turn on VideoEnable bit in Attribute controller */
 	AttrOn(cinfo);
 
-	if (cinfo->btype == BT_LAGUNA) {
+	if (is_laguna(cinfo)) {
 		/* no tiles */
 		fb_writew(control | 0x1000, cinfo->laguna_mmio + 0x402);
 		fb_writew(format, cinfo->laguna_mmio + 0xc0);
@@ -1332,7 +1357,7 @@ static int cirrusfb_pan_display(struct f
 		xpix = (unsigned char) ((xoffset % 4) * 2);
 	}
 
-	if (cinfo->btype != BT_LAGUNA)
+	if (!is_laguna(cinfo))
 		cirrusfb_WaitBLT(cinfo->regbase);
 
 	/* lower 8 + 8 bits of screen start address */
@@ -1353,8 +1378,11 @@ static int cirrusfb_pan_display(struct f
 
 	/* construct bit 19 of screen start address */
 	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19) {
-		tmp = vga_rcrt(cinfo->regbase, CL_CRT1D) & ~0x80;
-		tmp |= (base >> 12) & 0x80;
+		tmp = vga_rcrt(cinfo->regbase, CL_CRT1D);
+		if (is_laguna(cinfo))
+			tmp = (tmp & ~0x18) | ((base >> 16) & 0x18);
+		else
+			tmp = (tmp & ~0x80) | ((base >> 12) & 0x80);
 		vga_wcrt(cinfo->regbase, CL_CRT1D, tmp);
 	}
 
@@ -1365,7 +1393,7 @@ static int cirrusfb_pan_display(struct f
 	if (info->var.bits_per_pixel == 1)
 		vga_wattr(cinfo->regbase, CL_AR33, xpix);
 
-	if (cinfo->btype != BT_LAGUNA)
+	if (!is_laguna(cinfo))
 		cirrusfb_WaitBLT(cinfo->regbase);
 
 	return 0;
@@ -1486,6 +1514,7 @@ static void init_vgachip(struct fb_info 
 		break;
 
 	case BT_LAGUNA:
+	case BT_LAGUNAB:
 	case BT_ALPINE:
 		/* Nothing to do to reset the board. */
 		break;
@@ -1530,6 +1559,7 @@ static void init_vgachip(struct fb_info 
 			break;
 		case BT_ALPINE:
 		case BT_LAGUNA:
+		case BT_LAGUNAB:
 			break;
 		case BT_SD64:
 			vga_wseq(cinfo->regbase, CL_SEQRF, 0xb8);
@@ -1611,7 +1641,7 @@ static void init_vgachip(struct fb_info 
 	/* Bit Mask: no mask at all */
 	vga_wgfx(cinfo->regbase, VGA_GFX_BIT_MASK, 0xff);
 
-	if (cinfo->btype == BT_ALPINE || cinfo->btype == BT_LAGUNA)
+	if (cinfo->btype == BT_ALPINE || is_laguna(cinfo))
 		/* (5434 can't have bit 3 set for bitblt) */
 		vga_wgfx(cinfo->regbase, CL_GRB, 0x20);
 	else
@@ -1802,7 +1832,7 @@ static void cirrusfb_imageblit(struct fb
 {
 	struct cirrusfb_info *cinfo = info->par;
 
-	if (cinfo->btype != BT_LAGUNA)
+	if (!is_laguna(cinfo))
 		cirrusfb_WaitBLT(cinfo->regbase);
 	cfb_imageblit(info, image);
 }
@@ -1831,7 +1861,7 @@ static unsigned int __devinit cirrusfb_g
 	unsigned long mem;
 	struct cirrusfb_info *cinfo = info->par;
 
-	if (cinfo->btype == BT_LAGUNA) {
+	if (is_laguna(cinfo)) {
 		unsigned char SR14 = vga_rseq(regbase, CL_SEQR14);
 
 		mem = ((SR14 & 7) + 1) << 20;
@@ -1950,7 +1980,7 @@ static int __devinit cirrusfb_set_fbinfo
 		    | FBINFO_HWACCEL_YPAN
 		    | FBINFO_HWACCEL_FILLRECT
 		    | FBINFO_HWACCEL_COPYAREA;
-	if (noaccel || cinfo->btype == BT_LAGUNA)
+	if (noaccel || is_laguna(cinfo))
 		info->flags |= FBINFO_HWACCEL_DISABLED;
 	info->fbops = &cirrusfb_ops;
 	if (cinfo->btype == BT_GD5480) {
@@ -2060,7 +2090,7 @@ static int __devinit cirrusfb_pci_regist
 	if (!info) {
 		printk(KERN_ERR "cirrusfb: could not allocate memory\n");
 		ret = -ENOMEM;
-		goto err_disable;
+		goto err_out;
 	}
 
 	cinfo = info->par;
@@ -2127,10 +2157,11 @@ static int __devinit cirrusfb_pci_regist
 	pci_set_drvdata(pdev, info);
 
 	ret = cirrusfb_register(info);
-	if (ret)
-		iounmap(info->screen_base);
-	return ret;
+	if (!ret)
+		return 0;
 
+	pci_set_drvdata(pdev, NULL);
+	iounmap(info->screen_base);
 err_release_legacy:
 	if (release_io_ports)
 		release_region(0x3C0, 32);
@@ -2140,10 +2171,9 @@ err_release_regions:
 #endif
 	pci_release_regions(pdev);
 err_release_fb:
-	if (cinfo->laguna_mmio == NULL)
+	if (cinfo->laguna_mmio != NULL)
 		iounmap(cinfo->laguna_mmio);
 	framebuffer_release(info);
-err_disable:
 err_out:
 	return ret;
 }
@@ -2439,7 +2469,7 @@ static void WHDR(const struct cirrusfb_i
 {
 	unsigned char dummy;
 
-	if (cinfo->btype == BT_LAGUNA)
+	if (is_laguna(cinfo))
 		return;
 	if (cinfo->btype == BT_PICASSO) {
 		/* Klaus' hint for correct access to HDR on some boards */
@@ -2509,7 +2539,7 @@ static void WClut(struct cirrusfb_info *
 
 	if (cinfo->btype == BT_PICASSO || cinfo->btype == BT_PICASSO4 ||
 	    cinfo->btype == BT_ALPINE || cinfo->btype == BT_GD5480 ||
-	    cinfo->btype == BT_LAGUNA) {
+	    is_laguna(cinfo)) {
 		/* but DAC data register IS, at least for Picasso II */
 		if (cinfo->btype == BT_PICASSO)
 			data += 0xfff;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

