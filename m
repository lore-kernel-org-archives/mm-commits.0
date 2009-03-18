From: akpm@linux-foundation.org
Subject: + cirrusfb-set-mclk-in-one-place.patch added to -mm tree
Date: Wed, 18 Mar 2009 16:49:21 -0700
Message-ID: <200903182352.n2INqhaJ031635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432AbZCRXx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 19:53:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: set MCLK in one place
has been added to the -mm tree.  Its filename is
     cirrusfb-set-mclk-in-one-place.patch

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
Subject: cirrusfb: set MCLK in one place
From: Krzysztof Helt <krzysztof.h1@wp.pl>

A memory clock (MCLK) is set at various places.  Move the setting into one
place.

Set the MCLK only for Zorro cards as the x86 cards should be initialized by
BIOS.

Improve handling of the GD5434 (SD64).

Kill one annoying debug output "virtual offset: ...".

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   69 ++++++++-----------------------------
 1 file changed, 15 insertions(+), 54 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-set-mclk-in-one-place drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-set-mclk-in-one-place
+++ a/drivers/video/cirrusfb.c
@@ -146,7 +146,7 @@ static const struct cirrusfb_board_info_
 		.sr07			= 0xF0,
 		.sr07_1bpp		= 0xF0,
 		.sr07_8bpp		= 0xF1,
-		.sr1f			= 0x20
+		.sr1f			= 0x1E
 	},
 	[BT_PICCOLO] = {
 		.name			= "CL Piccolo",
@@ -482,6 +482,7 @@ static int cirrusfb_check_pixclock(const
 	if (var->bits_per_pixel == 8) {
 		switch (cinfo->btype) {
 		case BT_ALPINE:
+		case BT_SD64:
 		case BT_PICASSO4:
 			if (freq > 85500)
 				cinfo->multiplexing = 1;
@@ -492,10 +493,7 @@ static int cirrusfb_check_pixclock(const
 			break;
 
 		default:
-			dev_err(info->device,
-				"Frequency greater than maxclock (%ld kHz)\n",
-				maxclock);
-			return -EINVAL;
+			break;
 		}
 	}
 #if 0
@@ -847,7 +845,8 @@ static int cirrusfb_set_par_foo(struct f
 	/* formula: VClk = (OSC * N) / (D * (1+P)) */
 	/* Example: VClk = (14.31818 * 91) / (23 * (1+1)) = 28.325 MHz */
 
-	if (cinfo->btype == BT_ALPINE || cinfo->btype == BT_PICASSO4) {
+	if (cinfo->btype == BT_ALPINE || cinfo->btype == BT_PICASSO4 ||
+	    cinfo->btype == BT_SD64) {
 		/* if freq is close to mclk or mclk/2 select mclk
 		 * as clock source
 		 */
@@ -966,30 +965,19 @@ static int cirrusfb_set_par_foo(struct f
 
 		/* Extended Sequencer Mode */
 		switch (cinfo->btype) {
-		case BT_SD64:
-			/* setting the SEQRF on SD64 is not necessary
-			 * (only during init)
-			 */
-			/*  MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x1a);
-			break;
 
 		case BT_PICCOLO:
 		case BT_SPECTRUM:
-			/* ### ueberall 0x22? */
-			/* ##vorher 1c MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			/* evtl d0 bei 1 bit? avoid FIFO underruns..? */
 			vga_wseq(regbase, CL_SEQRF, 0xb0);
 			break;
 
 		case BT_PICASSO:
-			/* ##vorher 22 MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			/* ## vorher d0 avoid FIFO underruns..? */
 			vga_wseq(regbase, CL_SEQRF, 0xd0);
 			break;
 
+		case BT_SD64:
 		case BT_PICASSO4:
 		case BT_ALPINE:
 		case BT_GD5480:
@@ -1051,16 +1039,9 @@ static int cirrusfb_set_par_foo(struct f
 		}
 
 		switch (cinfo->btype) {
-		case BT_SD64:
-			/* MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x1d);
-			break;
-
 		case BT_PICCOLO:
 		case BT_PICASSO:
 		case BT_SPECTRUM:
-			/* ### vorher 1c MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			/* Fast Page-Mode writes */
 			vga_wseq(regbase, CL_SEQRF, 0xb0);
 			break;
@@ -1074,6 +1055,7 @@ static int cirrusfb_set_par_foo(struct f
 			/* We already set SRF and SR1F */
 			break;
 
+		case BT_SD64:
 		case BT_GD5480:
 		case BT_LAGUNA:
 		case BT_LAGUNAB:
@@ -1104,32 +1086,23 @@ static int cirrusfb_set_par_foo(struct f
 	else if (var->bits_per_pixel == 16) {
 		dev_dbg(info->device, "preparing for 16 bit deep display\n");
 		switch (cinfo->btype) {
-		case BT_SD64:
-			/* Extended Sequencer Mode: 256c col. mode */
-			vga_wseq(regbase, CL_SEQR7, 0xf7);
-			/* MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x1e);
-			break;
-
 		case BT_PICCOLO:
 		case BT_SPECTRUM:
 			vga_wseq(regbase, CL_SEQR7, 0x87);
 			/* Fast Page-Mode writes */
 			vga_wseq(regbase, CL_SEQRF, 0xb0);
-			/* MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
 		case BT_PICASSO:
 			vga_wseq(regbase, CL_SEQR7, 0x27);
 			/* Fast Page-Mode writes */
 			vga_wseq(regbase, CL_SEQRF, 0xb0);
-			/* MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
+		case BT_SD64:
 		case BT_PICASSO4:
 		case BT_ALPINE:
+			/* Extended Sequencer Mode: 256c col. mode */
 			vga_wseq(regbase, CL_SEQR7, 0xa7);
 			break;
 
@@ -1171,32 +1144,23 @@ static int cirrusfb_set_par_foo(struct f
 	else if (var->bits_per_pixel == 24) {
 		dev_dbg(info->device, "preparing for 24 bit deep display\n");
 		switch (cinfo->btype) {
-		case BT_SD64:
-			/* Extended Sequencer Mode: 256c col. mode */
-			vga_wseq(regbase, CL_SEQR7, 0xf5);
-			/* MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x1e);
-			break;
-
 		case BT_PICCOLO:
 		case BT_SPECTRUM:
 			vga_wseq(regbase, CL_SEQR7, 0x85);
 			/* Fast Page-Mode writes */
 			vga_wseq(regbase, CL_SEQRF, 0xb0);
-			/* MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
 		case BT_PICASSO:
 			vga_wseq(regbase, CL_SEQR7, 0x25);
 			/* Fast Page-Mode writes */
 			vga_wseq(regbase, CL_SEQRF, 0xb0);
-			/* MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
+		case BT_SD64:
 		case BT_PICASSO4:
 		case BT_ALPINE:
+			/* Extended Sequencer Mode: 256c col. mode */
 			vga_wseq(regbase, CL_SEQR7, 0xa5);
 			break;
 
@@ -1353,9 +1317,6 @@ static int cirrusfb_pan_display(struct f
 	unsigned char tmp, xpix;
 	struct cirrusfb_info *cinfo = info->par;
 
-	dev_dbg(info->device,
-		"virtual offset: (%d,%d)\n", var->xoffset, var->yoffset);
-
 	/* no range checks for xoffset and yoffset,   */
 	/* as fb_pan_display has already done this */
 	if (var->vmode & FB_VMODE_YWRAP)
@@ -1607,10 +1568,6 @@ static void init_vgachip(struct fb_info 
 		vga_wseq(cinfo->regbase, CL_SEQR18, 0x02);
 	}
 
-	/* MCLK select etc. */
-	if (bi->init_sr1f)
-		vga_wseq(cinfo->regbase, CL_SEQR1F, bi->sr1f);
-
 	/* Screen A preset row scan: none */
 	vga_wcrt(cinfo->regbase, VGA_CRTC_PRESET_ROW, 0x00);
 	/* Text cursor start: disable text cursor */
@@ -2346,6 +2303,10 @@ static int __devinit cirrusfb_zorro_regi
 
 	zorro_set_drvdata(z, info);
 
+	/* MCLK select etc. */
+	if (bi->init_sr1f)
+		vga_wseq(cinfo->regbase, CL_SEQR1F, bi->sr1f);
+
 	ret = cirrusfb_register(info);
 	if (!ret)
 		return 0;
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
cirrusfb-add-accelerator-constant.patch
cirrusfb-set-mclk-in-one-place.patch
nvidiafb-remove-open_lock-mutex.patch
fb-hide-hardware-cursor-in-graphics-mode-mach64.patch
atyfb-speed-up-mach64-cursor.patch

