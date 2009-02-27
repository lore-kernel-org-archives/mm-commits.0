From: akpm@linux-foundation.org
Subject: + cirrusfb-gd5446-fixes.patch added to -mm tree
Date: Fri, 27 Feb 2009 12:53:18 -0800
Message-ID: <200902272053.n1RKrIjO001068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbZB0Uxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Feb 2009 15:53:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: GD5446 fixes
has been added to the -mm tree.  Its filename is
     cirrusfb-gd5446-fixes.patch

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
Subject: cirrusfb: GD5446 fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Various fixes to make Cirrus GD5446 chip work.

Another Cirrus chip works with the cirrusfb.  The gd5446 seems very
similar to Alpine chips.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-gd5446-fixes drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-gd5446-fixes
+++ a/drivers/video/cirrusfb.c
@@ -198,9 +198,11 @@ static const struct cirrusfb_board_info_
 		.init_sr07		= true,
 		.init_sr1f		= false,
 		.scrn_start_bit19	= true,
-		.sr07			= 0x20,
-		.sr07_1bpp		= 0x20,
-		.sr07_8bpp		= 0x21,
+		.sr07			= 0xA0,
+		.sr07_1bpp		= 0xA0,
+		.sr07_1bpp_mux		= 0xA6,
+		.sr07_8bpp		= 0xA1,
+		.sr07_8bpp_mux		= 0xA7,
 		.sr1f			= 0
 	},
 	[BT_ALPINE] = {
@@ -213,8 +215,8 @@ static const struct cirrusfb_board_info_
 		.init_sr1f		= true,
 		.scrn_start_bit19	= true,
 		.sr07			= 0xA0,
-		.sr07_1bpp		= 0xA1,
-		.sr07_1bpp_mux		= 0xA7,
+		.sr07_1bpp		= 0xA0,
+		.sr07_1bpp_mux		= 0xA6,
 		.sr07_8bpp		= 0xA1,
 		.sr07_8bpp_mux		= 0xA7,
 		.sr1f			= 0x1C
@@ -821,7 +823,7 @@ static int cirrusfb_set_par_foo(struct f
 	/* formula: VClk = (OSC * N) / (D * (1+P)) */
 	/* Example: VClk = (14.31818 * 91) / (23 * (1+1)) = 28.325 MHz */
 
-	if (cinfo->btype == BT_ALPINE) {
+	if (cinfo->btype == BT_ALPINE || cinfo->btype == BT_PICASSO4) {
 		/* if freq is close to mclk or mclk/2 select mclk
 		 * as clock source
 		 */
@@ -1044,9 +1046,6 @@ static int cirrusfb_set_par_foo(struct f
 			/* ### INCOMPLETE!! */
 			vga_wseq(regbase, CL_SEQRF, 0xb8);
 #endif
-/*	  		vga_wseq(regbase, CL_SEQR1F, 0x1c); */
-			break;
-
 		case BT_ALPINE:
 			/* We already set SRF and SR1F */
 			break;
@@ -1106,10 +1105,6 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_PICASSO4:
-			vga_wseq(regbase, CL_SEQR7, 0x27);
-/*			vga_wseq(regbase, CL_SEQR1F, 0x1c);  */
-			break;
-
 		case BT_ALPINE:
 			vga_wseq(regbase, CL_SEQR7, 0xa7);
 			break;
@@ -1177,10 +1172,6 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_PICASSO4:
-			vga_wseq(regbase, CL_SEQR7, 0x25);
-/*			vga_wseq(regbase, CL_SEQR1F, 0x1c);  */
-			break;
-
 		case BT_ALPINE:
 			vga_wseq(regbase, CL_SEQR7, 0xa9);
 			break;
@@ -2678,7 +2669,7 @@ static void cirrusfb_set_blitter(u8 __io
 	vga_wgfx(regbase, CL_GR32, 0x0d);	/* BLT ROP */
 
 	/* and finally: GO! */
-	vga_wgfx(regbase, CL_GR31, 0x82);	/* BLT Start/status */
+	vga_wgfx(regbase, CL_GR31, 0x02);	/* BLT Start/status */
 }
 
 /*******************************************************************
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
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

