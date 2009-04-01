From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-gd5446-fixes.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:51 -0700
Message-ID: <200904011842.n31IgprO009853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919AbZDATDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: GD5446 fixes
has been removed from the -mm tree.  Its filename was
     cirrusfb-gd5446-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
