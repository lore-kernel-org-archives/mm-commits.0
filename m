From: akpm@linux-foundation.org
Subject: + cirrusfb-gd5434-aka-sd64-support-fixed.patch added to -mm tree
Date: Thu, 19 Mar 2009 15:43:22 -0700
Message-ID: <200903192246.n2JMkveg014051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755940AbZCSWsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Mar 2009 18:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: GD5434 (aka SD64) support fixed
has been added to the -mm tree.  Its filename is
     cirrusfb-gd5434-aka-sd64-support-fixed.patch

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
Subject: cirrusfb: GD5434 (aka SD64) support fixed
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix handling of the Cirrus Logic GD5434 chip.  Distinguish this chip from the
GD5430.  It allows detecting memory size for both models correctly.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   72 +++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 35 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-gd5434-aka-sd64-support-fixed drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-gd5434-aka-sd64-support-fixed
+++ a/drivers/video/cirrusfb.c
@@ -145,7 +145,9 @@ static const struct cirrusfb_board_info_
 		.scrn_start_bit19	= true,
 		.sr07			= 0xF0,
 		.sr07_1bpp		= 0xF0,
+		.sr07_1bpp_mux		= 0xF6,
 		.sr07_8bpp		= 0xF1,
+		.sr07_8bpp_mux		= 0xF7,
 		.sr1f			= 0x1E
 	},
 	[BT_PICCOLO] = {
@@ -262,8 +264,8 @@ static const struct cirrusfb_board_info_
 
 static struct pci_device_id cirrusfb_pci_table[] = {
 	CHIP(PCI_DEVICE_ID_CIRRUS_5436, BT_ALPINE),
-	CHIP(PCI_DEVICE_ID_CIRRUS_5434_8, BT_ALPINE),
-	CHIP(PCI_DEVICE_ID_CIRRUS_5434_4, BT_ALPINE),
+	CHIP(PCI_DEVICE_ID_CIRRUS_5434_8, BT_SD64),
+	CHIP(PCI_DEVICE_ID_CIRRUS_5434_4, BT_SD64),
 	CHIP(PCI_DEVICE_ID_CIRRUS_5430, BT_ALPINE), /* GD-5440 is same id */
 	CHIP(PCI_DEVICE_ID_CIRRUS_7543, BT_ALPINE),
 	CHIP(PCI_DEVICE_ID_CIRRUS_7548, BT_ALPINE),
@@ -341,6 +343,7 @@ struct cirrusfb_info {
 	unsigned char SFR;	/* Shadow of special function register */
 
 	int multiplexing;
+	int doubleVCLK;
 	int blank_mode;
 	u32 pseudo_palette[16];
 
@@ -496,18 +499,15 @@ static int cirrusfb_check_pixclock(const
 			break;
 		}
 	}
-#if 0
-	/* TODO: If we have a 1MB 5434, we need to put ourselves in a mode where
+
+	/* If we have a 1MB 5434, we need to put ourselves in a mode where
 	 * the VCLK is double the pixel clock. */
-	switch (var->bits_per_pixel) {
-	case 16:
-	case 24:
-		if (var->xres <= 800)
-			/* Xbh has this type of clock for 32-bit */
-			freq /= 2;
-		break;
+	cinfo->doubleVCLK = 0;
+	if (cinfo->btype == BT_SD64 && info->fix.smem_len <= MB_ &&
+	    var->bits_per_pixel == 16) {
+		cinfo->doubleVCLK = 1;
 	}
-#endif
+
 	return 0;
 }
 
@@ -830,10 +830,13 @@ static int cirrusfb_set_par_foo(struct f
 	vga_wcrt(regbase, CL_CRT1A, tmp);
 
 	freq = PICOS2KHZ(var->pixclock);
-	if (cinfo->btype == BT_ALPINE && var->bits_per_pixel == 24)
-		freq *= 3;
+	if (var->bits_per_pixel == 24)
+		if (cinfo->btype == BT_ALPINE || cinfo->btype == BT_SD64)
+			freq *= 3;
 	if (cinfo->multiplexing)
 		freq /= 2;
+	if (cinfo->doubleVCLK)
+		freq *= 2;
 
 	bestclock(freq, &nom, &den, &div);
 
@@ -851,10 +854,9 @@ static int cirrusfb_set_par_foo(struct f
 		 * as clock source
 		 */
 		int divMCLK = cirrusfb_check_mclk(info, freq);
-		if (divMCLK)  {
+		if (divMCLK)
 			nom = 0;
-			cirrusfb_set_mclk_as_source(info, divMCLK);
-		}
+		cirrusfb_set_mclk_as_source(info, divMCLK);
 	}
 	if (is_laguna(cinfo)) {
 		long pcifc = fb_readl(cinfo->laguna_mmio + 0x3fc);
@@ -885,14 +887,13 @@ static int cirrusfb_set_par_foo(struct f
 		    (cinfo->btype == BT_GD5480))
 			tmp |= 0x80;
 
-		dev_dbg(info->device, "CL_SEQR1B: %d\n", (int) tmp);
 		/* Laguna chipset has reversed clock registers */
 		if (is_laguna(cinfo)) {
 			vga_wseq(regbase, CL_SEQRE, tmp);
 			vga_wseq(regbase, CL_SEQR1E, nom);
 		} else {
-			vga_wseq(regbase, CL_SEQRB, nom);
-			vga_wseq(regbase, CL_SEQR1B, tmp);
+			vga_wseq(regbase, CL_SEQRE, nom);
+			vga_wseq(regbase, CL_SEQR1E, tmp);
 		}
 	}
 
@@ -911,15 +912,13 @@ static int cirrusfb_set_par_foo(struct f
 	else
 		vga_wcrt(regbase, VGA_CRTC_REGS, 0x00);	/* interlace control */
 
-	/* adjust horizontal/vertical sync type (low/high) */
+	/* adjust horizontal/vertical sync type (low/high), use VCLK3 */
 	/* enable display memory & CRTC I/O address for color mode */
-	tmp = 0x03;
+	tmp = 0x03 | 0xc;
 	if (var->sync & FB_SYNC_HOR_HIGH_ACT)
 		tmp |= 0x40;
 	if (var->sync & FB_SYNC_VERT_HIGH_ACT)
 		tmp |= 0x80;
-	if (is_laguna(cinfo))
-		tmp |= 0xc;
 	WGen(cinfo, VGA_MIS_W, tmp);
 
 	/* text cursor on and start line */
@@ -1052,9 +1051,6 @@ static int cirrusfb_set_par_foo(struct f
 			vga_wseq(regbase, CL_SEQRF, 0xb8);
 #endif
 		case BT_ALPINE:
-			/* We already set SRF and SR1F */
-			break;
-
 		case BT_SD64:
 		case BT_GD5480:
 		case BT_LAGUNA:
@@ -1103,7 +1099,8 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_PICASSO4:
 		case BT_ALPINE:
 			/* Extended Sequencer Mode: 256c col. mode */
-			vga_wseq(regbase, CL_SEQR7, 0xa7);
+			vga_wseq(regbase, CL_SEQR7,
+					cinfo->doubleVCLK ? 0xa3 : 0xa7);
 			break;
 
 		case BT_GD5480:
@@ -1128,7 +1125,7 @@ static int cirrusfb_set_par_foo(struct f
 		/* mode register: 256 color mode */
 		vga_wgfx(regbase, VGA_GFX_MODE, 64);
 #ifdef CONFIG_PCI
-		WHDR(cinfo, 0xc1);	/* Copy Xbh */
+		WHDR(cinfo, cinfo->doubleVCLK ? 0xe1 : 0xc1);
 #elif defined(CONFIG_ZORRO)
 		/* FIXME: CONFIG_PCI and CONFIG_ZORRO may be defined both */
 		WHDR(cinfo, 0xa0);	/* hidden dac reg: nothing special */
@@ -1529,7 +1526,9 @@ static void init_vgachip(struct fb_info 
 		case BT_LAGUNAB:
 			break;
 		case BT_SD64:
+#ifdef CONFIG_ZORRO
 			vga_wseq(cinfo->regbase, CL_SEQRF, 0xb8);
+#endif
 			break;
 		default:
 			vga_wseq(cinfo->regbase, CL_SEQR16, 0x0f);
@@ -1604,7 +1603,8 @@ static void init_vgachip(struct fb_info 
 	/* Bit Mask: no mask at all */
 	vga_wgfx(cinfo->regbase, VGA_GFX_BIT_MASK, 0xff);
 
-	if (cinfo->btype == BT_ALPINE || is_laguna(cinfo))
+	if (cinfo->btype == BT_ALPINE || cinfo->btype == BT_SD64 ||
+	    is_laguna(cinfo))
 		/* (5434 can't have bit 3 set for bitblt) */
 		vga_wgfx(cinfo->regbase, CL_GRB, 0x20);
 	else
@@ -1809,9 +1809,11 @@ static void cirrusfb_imageblit(struct fb
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
-	/* Alpine acceleration does not work at 24bpp ?!? */
-	if (info->flags & FBINFO_HWACCEL_DISABLED || image->depth != 1 ||
-	    (cinfo->btype == BT_ALPINE && op == 0xc))
+	/* Alpine/SD64 does not work at 24bpp ??? */
+	if (info->flags & FBINFO_HWACCEL_DISABLED || image->depth != 1)
+		cfb_imageblit(info, image);
+	else if ((cinfo->btype == BT_ALPINE || cinfo->btype == BT_SD64) &&
+		  op == 0xc)
 		cfb_imageblit(info, image);
 	else {
 		unsigned size = ((image->width + 7) >> 3) * image->height;
@@ -1895,7 +1897,7 @@ static unsigned int __devinit cirrusfb_g
 		/* If DRAM bank switching is enabled, there must be
 		 * twice as much memory installed. (4MB on the 5434)
 		 */
-		if (SRF & 0x80)
+		if (cinfo->btype != BT_ALPINE && (SRF & 0x80) != 0)
 			mem *= 2;
 	}
 
@@ -2552,7 +2554,7 @@ static void WClut(struct cirrusfb_info *
 
 	if (cinfo->btype == BT_PICASSO || cinfo->btype == BT_PICASSO4 ||
 	    cinfo->btype == BT_ALPINE || cinfo->btype == BT_GD5480 ||
-	    is_laguna(cinfo)) {
+	    cinfo->btype == BT_SD64 || is_laguna(cinfo)) {
 		/* but DAC data register IS, at least for Picasso II */
 		if (cinfo->btype == BT_PICASSO)
 			data += 0xfff;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix3.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
cirrusfb-add-mmio-registers-for-laguna-chipsets.patch
cirrusfb-do-not-calculate-line-length-twice.patch
cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch
cirrusfb-various-improvements.patch
cirrusfb-laguna-chipset-8bpp-fix.patch
cirrusfb-check_var-improvements.patch
cirrusfb-various-laguna-fixes.patch
cirrusfb-acceleration-improvements.patch
cirrusfb-add-imageblit-function.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch
cirrusfb-gd5446-fixes.patch
cirrusfb-use-24bpp-instead-of-32bpp.patch
cirrusfb-fix-clock-doubling.patch
cirrusfb-fix-clock-doubling-fix.patch
cirrusfb-add-accelerator-constant.patch
cirrusfb-add-accelerator-constantpatch-compilation-fix.patch
cirrusfb-set-mclk-in-one-place.patch
cirrusfb-gd5434-aka-sd64-support-fixed.patch
cirrusfb-fix-threshold-register-mask-for-laguna-chips.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
asiliantfb-fix-cmap-memory-leaks.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
remove-cyblafb-driver.patch
nvidiafb-remove-open_lock-mutex.patch
fb-hide-hardware-cursor-in-graphics-mode-mach64.patch
atyfb-speed-up-mach64-cursor.patch

