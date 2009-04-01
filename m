From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-do-not-calculate-line-length-twice.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:32 -0700
Message-ID: <200904011842.n31IgWAh009743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756778AbZDATd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, arthur.marsh@internode.on.net, geert.uytterhoeven@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: do not calculate line length twice
has been removed from the -mm tree.  Its filename was
     cirrusfb-do-not-calculate-line-length-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: do not calculate line length twice
From: Krzysztof Helt <krzysztof.h1@wp.pl>

A line length is calculated twice: first in the cirrusfb_decode_var() then
in the cirrusfb_set_par_foo().

Use the first calculated value.  A nice side effect is that 32bpp mode
works now.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-do-not-calculate-line-length-twice drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-do-not-calculate-line-length-twice
+++ a/drivers/video/cirrusfb.c
@@ -694,7 +694,8 @@ static int cirrusfb_set_par_foo(struct f
 	struct cirrusfb_regs regs;
 	u8 __iomem *regbase = cinfo->regbase;
 	unsigned char tmp;
-	int offset = 0, err;
+	int err;
+	int pitch;
 	const struct cirrusfb_board_info_rec *bi;
 	int hdispend, hsyncstart, hsyncend, htotal;
 	int yres, vdispend, vsyncstart, vsyncend, vtotal;
@@ -1027,7 +1028,6 @@ static int cirrusfb_set_par_foo(struct f
 		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x06);
 		/* plane mask: only write to first plane */
 		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0x01);
-		offset = var->xres_virtual / 16;
 	}
 
 	/******************************************************
@@ -1113,7 +1113,6 @@ static int cirrusfb_set_par_foo(struct f
 		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x0a);
 		/* plane mask: enable writing to all 4 planes */
 		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0xff);
-		offset = var->xres_virtual / 8;
 	}
 
 	/******************************************************
@@ -1190,7 +1189,6 @@ static int cirrusfb_set_par_foo(struct f
 		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x0a);
 		/* plane mask: enable writing to all 4 planes */
 		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0xff);
-		offset = var->xres_virtual / 4;
 	}
 
 	/******************************************************
@@ -1263,7 +1261,6 @@ static int cirrusfb_set_par_foo(struct f
 		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x0a);
 		/* plane mask: enable writing to all 4 planes */
 		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0xff);
-		offset = var->xres_virtual / 4;
 	}
 
 	/******************************************************
@@ -1277,9 +1274,10 @@ static int cirrusfb_set_par_foo(struct f
 			"What's this? requested color depth == %d.\n",
 			var->bits_per_pixel);
 
-	vga_wcrt(regbase, VGA_CRTC_OFFSET, offset & 0xff);
+	pitch = info->fix.line_length >> 3;
+	vga_wcrt(regbase, VGA_CRTC_OFFSET, pitch & 0xff);
 	tmp = 0x22;
-	if (offset & 0x100)
+	if (pitch & 0x100)
 		tmp |= 0x10;	/* offset overflow bit */
 
 	/* screen start addr #16-18, fastpagemode cycles */
@@ -1287,7 +1285,7 @@ static int cirrusfb_set_par_foo(struct f
 
 	/* screen start address bit 19 */
 	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19)
-		vga_wcrt(regbase, CL_CRT1D, 0x00);
+		vga_wcrt(regbase, CL_CRT1D, (pitch >> 9) & 1);
 
 	if (cinfo->btype == BT_LAGUNA ||
 	    cinfo->btype == BT_GD5480) {
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

