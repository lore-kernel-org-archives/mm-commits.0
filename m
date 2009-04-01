From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-acceleration-improvements.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:45 -0700
Message-ID: <200904011842.n31Igj1e009802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787AbZDATJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: acceleration improvements
has been removed from the -mm tree.  Its filename was
     cirrusfb-acceleration-improvements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: acceleration improvements
From: Krzysztof Helt <krzysztof.h1@wp.pl>

- Fix color expansion for 16bpp and 32bpp modes in the
  cirrusfb_RectFill().

- Make a function with a common blitter code (cirrusfb_set_blitter).

- Add fb_sync function to allow a higher layer synchronize with the
  blitter.

- Kill one redundant blitter reset.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |  186 ++++++++++++++-----------------------
 1 file changed, 75 insertions(+), 111 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-acceleration-improvements drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-acceleration-improvements
+++ a/drivers/video/cirrusfb.c
@@ -381,7 +381,7 @@ static void cirrusfb_BitBLT(u8 __iomem *
 static void cirrusfb_RectFill(u8 __iomem *regbase, int bits_per_pixel,
 			      u_short x, u_short y,
 			      u_short width, u_short height,
-			      u_char color, u_short line_length);
+			      u32 color, u_short line_length);
 
 static void bestclock(long freq, int *nom, int *den, int *div);
 
@@ -1550,9 +1550,6 @@ static void init_vgachip(struct fb_info 
 		/* unlock all extension registers */
 		vga_wseq(cinfo->regbase, CL_SEQR6, 0x12);
 
-		/* reset blitter */
-		vga_wgfx(cinfo->regbase, CL_GR31, 0x04);
-
 		switch (cinfo->btype) {
 		case BT_GD5480:
 			vga_wseq(cinfo->regbase, CL_SEQRF, 0x98);
@@ -1747,6 +1744,17 @@ static void switch_monitor(struct cirrus
 /* Linux 2.6-style  accelerated functions */
 /******************************************/
 
+static int cirrusfb_sync(struct fb_info *info)
+{
+	struct cirrusfb_info *cinfo = info->par;
+
+	if (!is_laguna(cinfo)) {
+		while (vga_rgfx(cinfo->regbase, CL_GR31) & 0x03)
+			cpu_relax();
+	}
+	return 0;
+}
+
 static void cirrusfb_fillrect(struct fb_info *info,
 			      const struct fb_fillrect *region)
 {
@@ -1966,6 +1974,7 @@ static struct fb_ops cirrusfb_ops = {
 	.fb_blank	= cirrusfb_blank,
 	.fb_fillrect	= cirrusfb_fillrect,
 	.fb_copyarea	= cirrusfb_copyarea,
+	.fb_sync	= cirrusfb_sync,
 	.fb_imageblit	= cirrusfb_imageblit,
 };
 
@@ -2586,7 +2595,6 @@ static void RClut(struct cirrusfb_info *
 /* FIXME: use interrupts instead */
 static void cirrusfb_WaitBLT(u8 __iomem *regbase)
 {
-	/* now busy-wait until we're done */
 	while (vga_rgfx(regbase, CL_GR31) & 0x08)
 		cpu_relax();
 }
@@ -2597,58 +2605,12 @@ static void cirrusfb_WaitBLT(u8 __iomem 
 	perform accelerated "scrolling"
 ********************************************************************/
 
-static void cirrusfb_BitBLT(u8 __iomem *regbase, int bits_per_pixel,
-			    u_short curx, u_short cury,
-			    u_short destx, u_short desty,
-			    u_short width, u_short height,
-			    u_short line_length)
-{
-	u_short nwidth, nheight;
-	u_long nsrc, ndest;
-	u_char bltmode;
-
-	nwidth = width - 1;
-	nheight = height - 1;
-
-	bltmode = 0x00;
-	/* if source adr < dest addr, do the Blt backwards */
-	if (cury <= desty) {
-		if (cury == desty) {
-			/* if src and dest are on the same line, check x */
-			if (curx < destx)
-				bltmode |= 0x01;
-		} else
-			bltmode |= 0x01;
-	}
-	if (!bltmode) {
-		/* standard case: forward blitting */
-		nsrc = (cury * line_length) + curx;
-		ndest = (desty * line_length) + destx;
-	} else {
-		/* this means start addresses are at the end,
-		 * counting backwards
-		 */
-		nsrc = cury * line_length + curx +
-			nheight * line_length + nwidth;
-		ndest = desty * line_length + destx +
-			nheight * line_length + nwidth;
-	}
-
-	/*
-	   run-down of registers to be programmed:
-	   destination pitch
-	   source pitch
-	   BLT width/height
-	   source start
-	   destination start
-	   BLT mode
-	   BLT ROP
-	   VGA_GFX_SR_VALUE / VGA_GFX_SR_ENABLE: "fill color"
-	   start/stop
-	 */
-
-	cirrusfb_WaitBLT(regbase);
+static void cirrusfb_set_blitter(u8 __iomem *regbase,
+			    u_short nwidth, u_short nheight,
+			    u_long nsrc, u_long ndest,
+			    u_short bltmode, u_short line_length)
 
+{
 	/* pitch: set to line_length */
 	/* dest pitch low */
 	vga_wgfx(regbase, CL_GR24, line_length & 0xff);
@@ -2694,56 +2656,67 @@ static void cirrusfb_BitBLT(u8 __iomem *
 	vga_wgfx(regbase, CL_GR32, 0x0d);	/* BLT ROP */
 
 	/* and finally: GO! */
-	vga_wgfx(regbase, CL_GR31, 0x02);	/* BLT Start/status */
+	vga_wgfx(regbase, CL_GR31, 0x82);	/* BLT Start/status */
 }
 
 /*******************************************************************
-	cirrusfb_RectFill()
+	cirrusfb_BitBLT()
 
-	perform accelerated rectangle fill
+	perform accelerated "scrolling"
 ********************************************************************/
 
-static void cirrusfb_RectFill(u8 __iomem *regbase, int bits_per_pixel,
-		     u_short x, u_short y, u_short width, u_short height,
-		     u_char color, u_short line_length)
+static void cirrusfb_BitBLT(u8 __iomem *regbase, int bits_per_pixel,
+			    u_short curx, u_short cury,
+			    u_short destx, u_short desty,
+			    u_short width, u_short height,
+			    u_short line_length)
 {
-	u_short nwidth, nheight;
-	u_long ndest;
-	u_char op;
-
-	nwidth = width - 1;
-	nheight = height - 1;
+	u_short nwidth = width - 1;
+	u_short nheight = height - 1;
+	u_long nsrc, ndest;
+	u_char bltmode;
 
-	ndest = (y * line_length) + x;
+	bltmode = 0x00;
+	/* if source adr < dest addr, do the Blt backwards */
+	if (cury <= desty) {
+		if (cury == desty) {
+			/* if src and dest are on the same line, check x */
+			if (curx < destx)
+				bltmode |= 0x01;
+		} else
+			bltmode |= 0x01;
+	}
+	/* standard case: forward blitting */
+	nsrc = (cury * line_length) + curx;
+	ndest = (desty * line_length) + destx;
+	if (bltmode) {
+		/* this means start addresses are at the end,
+		 * counting backwards
+		 */
+		nsrc += nheight * line_length + nwidth;
+		ndest += nheight * line_length + nwidth;
+	}
 
 	cirrusfb_WaitBLT(regbase);
 
-	/* pitch: set to line_length */
-	vga_wgfx(regbase, CL_GR24, line_length & 0xff);	/* dest pitch low */
-	vga_wgfx(regbase, CL_GR25, line_length >> 8);	/* dest pitch hi */
-	vga_wgfx(regbase, CL_GR26, line_length & 0xff);	/* source pitch low */
-	vga_wgfx(regbase, CL_GR27, line_length >> 8);	/* source pitch hi */
+	cirrusfb_set_blitter(regbase, nwidth, nheight,
+			    nsrc, ndest, bltmode, line_length);
+}
 
-	/* BLT width: actual number of pixels - 1 */
-	vga_wgfx(regbase, CL_GR20, nwidth & 0xff);	/* BLT width low */
-	vga_wgfx(regbase, CL_GR21, nwidth >> 8);	/* BLT width hi */
+/*******************************************************************
+	cirrusfb_RectFill()
 
-	/* BLT height: actual number of lines -1 */
-	vga_wgfx(regbase, CL_GR22, nheight & 0xff);	/* BLT height low */
-	vga_wgfx(regbase, CL_GR23, nheight >> 8);	/* BLT width hi */
+	perform accelerated rectangle fill
+********************************************************************/
 
-	/* BLT destination */
-	/* BLT dest low */
-	vga_wgfx(regbase, CL_GR28, (u_char) (ndest & 0xff));
-	/* BLT dest mid */
-	vga_wgfx(regbase, CL_GR29, (u_char) (ndest >> 8));
-	/* BLT dest hi */
-	vga_wgfx(regbase, CL_GR2A, (u_char) (ndest >> 16));
+static void cirrusfb_RectFill(u8 __iomem *regbase, int bits_per_pixel,
+		     u_short x, u_short y, u_short width, u_short height,
+		     u32 color, u_short line_length)
+{
+	u_long ndest = (y * line_length) + x;
+	u_char op;
 
-	/* BLT source: set to 0 (is a dummy here anyway) */
-	vga_wgfx(regbase, CL_GR2C, 0x00);	/* BLT src low */
-	vga_wgfx(regbase, CL_GR2D, 0x00);	/* BLT src mid */
-	vga_wgfx(regbase, CL_GR2E, 0x00);	/* BLT src hi */
+	cirrusfb_WaitBLT(regbase);
 
 	/* This is a ColorExpand Blt, using the */
 	/* same color for foreground and background */
@@ -2751,29 +2724,20 @@ static void cirrusfb_RectFill(u8 __iomem
 	vga_wgfx(regbase, VGA_GFX_SR_ENABLE, color);	/* background color */
 
 	op = 0xc0;
-	if (bits_per_pixel == 16) {
-		vga_wgfx(regbase, CL_GR10, color);	/* foreground color */
-		vga_wgfx(regbase, CL_GR11, color);	/* background color */
-		op = 0x50;
+	if (bits_per_pixel >= 16) {
+		vga_wgfx(regbase, CL_GR10, color >> 8);	/* foreground color */
+		vga_wgfx(regbase, CL_GR11, color >> 8);	/* background color */
 		op = 0xd0;
-	} else if (bits_per_pixel == 32) {
-		vga_wgfx(regbase, CL_GR10, color);	/* foreground color */
-		vga_wgfx(regbase, CL_GR11, color);	/* background color */
-		vga_wgfx(regbase, CL_GR12, color);	/* foreground color */
-		vga_wgfx(regbase, CL_GR13, color);	/* background color */
-		vga_wgfx(regbase, CL_GR14, 0);	/* foreground color */
-		vga_wgfx(regbase, CL_GR15, 0);	/* background color */
-		op = 0x50;
+	}
+	if (bits_per_pixel == 32) {
+		vga_wgfx(regbase, CL_GR12, color >> 16);/* foreground color */
+		vga_wgfx(regbase, CL_GR13, color >> 16);/* background color */
+		vga_wgfx(regbase, CL_GR14, color >> 24);/* foreground color */
+		vga_wgfx(regbase, CL_GR15, color >> 24);/* background color */
 		op = 0xf0;
 	}
-	/* BLT mode: color expand, Enable 8x8 copy (faster?) */
-	vga_wgfx(regbase, CL_GR30, op);	/* BLT mode */
-
-	/* BLT ROP: SrcCopy */
-	vga_wgfx(regbase, CL_GR32, 0x0d);	/* BLT ROP */
