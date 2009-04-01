From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-set-mclk-in-one-place.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:59 -0700
Message-ID: <200904011842.n31IgxBh009884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932297AbZDATIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: set MCLK in one place
has been removed from the -mm tree.  Its filename was
     cirrusfb-set-mclk-in-one-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/video/cirrusfb.c |   70 ++++++++-----------------------------
 1 file changed, 16 insertions(+), 54 deletions(-)

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
