From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-check_var-improvements.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:41 -0700
Message-ID: <200904011842.n31Igfgb009795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933876AbZDATK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: check_var improvements
has been removed from the -mm tree.  Its filename was
     cirrusfb-check_var-improvements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: check_var improvements
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Break cirrusfb_decode_var() function into two parts:
cirrusfb_check_pixclock() which can be called from the
cirrusfb_check_var() aand merge rest into the cirrusfb_set_par_foo(). 
This allows rejecting modes with too high pixclock before before any
change to hardware state (and a console is messed up).

Also, fix RGB field's lengths for 8bpp modes to correct ones so X11 works
with fbdev driver with cirrusfb.

Kill some redundant function calls or register loads.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |  195 ++++++++++++++-----------------------
 1 file changed, 74 insertions(+), 121 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-check_var-improvements drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-check_var-improvements
+++ a/drivers/video/cirrusfb.c
@@ -432,6 +432,53 @@ static int cirrusfb_check_mclk(struct fb
 	return 0;
 }
 
+static int cirrusfb_check_pixclock(const struct fb_var_screeninfo *var,
+				   struct fb_info *info)
+{
+	long freq;
+	long maxclock;
+	struct cirrusfb_info *cinfo = info->par;
+	unsigned maxclockidx = var->bits_per_pixel >> 3;
+
+	/* convert from ps to kHz */
+	freq = PICOS2KHZ(var->pixclock);
+
+	dev_dbg(info->device, "desired pixclock: %ld kHz\n", freq);
+
+	maxclock = cirrusfb_board_info[cinfo->btype].maxclock[maxclockidx];
+	cinfo->multiplexing = 0;
+
+	/* If the frequency is greater than we can support, we might be able
+	 * to use multiplexing for the video mode */
+	if (freq > maxclock) {
+		switch (cinfo->btype) {
+		case BT_ALPINE:
+		case BT_GD5480:
+			cinfo->multiplexing = 1;
+			break;
+
+		default:
+			dev_err(info->device,
+				"Frequency greater than maxclock (%ld kHz)\n",
+				maxclock);
+			return -EINVAL;
+		}
+	}
+#if 0
+	/* TODO: If we have a 1MB 5434, we need to put ourselves in a mode where
+	 * the VCLK is double the pixel clock. */
+	switch (var->bits_per_pixel) {
+	case 16:
+	case 32:
+		if (var->xres <= 800)
+			/* Xbh has this type of clock for 32-bit */
+			freq /= 2;
+		break;
+	}
+#endif
+	return 0;
+}
+
 static int cirrusfb_check_var(struct fb_var_screeninfo *var,
 			      struct fb_info *info)
 {
@@ -449,7 +496,7 @@ static int cirrusfb_check_var(struct fb_
 
 	case 8:
 		var->red.offset = 0;
-		var->red.length = 6;
+		var->red.length = 8;
 		var->green = var->red;
 		var->blue = var->red;
 		break;
@@ -513,7 +560,6 @@ static int cirrusfb_check_var(struct fb_
 		return -EINVAL;
 	}
 
-
 	if (var->xoffset < 0)
 		var->xoffset = 0;
 	if (var->yoffset < 0)
@@ -544,80 +590,9 @@ static int cirrusfb_check_var(struct fb_
 		return -EINVAL;
 	}
 
-	return 0;
-}
-
-static int cirrusfb_decode_var(const struct fb_var_screeninfo *var,
-				struct fb_info *info)
-{
-	long freq;
-	long maxclock;
-	int maxclockidx = var->bits_per_pixel >> 3;
-	struct cirrusfb_info *cinfo = info->par;
-
-	switch (var->bits_per_pixel) {
-	case 1:
-		info->fix.line_length = var->xres_virtual / 8;
-		info->fix.visual = FB_VISUAL_MONO10;
-		break;
-
-	case 8:
-		info->fix.line_length = var->xres_virtual;
-		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
-		break;
-
-	case 16:
-	case 32:
-		info->fix.line_length = var->xres_virtual * maxclockidx;
-		info->fix.visual = FB_VISUAL_TRUECOLOR;
-		break;
-
-	default:
-		dev_dbg(info->device,
-			"Unsupported bpp size: %d\n", var->bits_per_pixel);
-		assert(false);
-		/* should never occur */
-		break;
-	}
-
-	info->fix.type = FB_TYPE_PACKED_PIXELS;
-
-	/* convert from ps to kHz */
-	freq = PICOS2KHZ(var->pixclock);
-
-	dev_dbg(info->device, "desired pixclock: %ld kHz\n", freq);
-
-	maxclock = cirrusfb_board_info[cinfo->btype].maxclock[maxclockidx];
-	cinfo->multiplexing = 0;
-
-	/* If the frequency is greater than we can support, we might be able
-	 * to use multiplexing for the video mode */
-	if (freq > maxclock) {
-		switch (cinfo->btype) {
-		case BT_ALPINE:
-		case BT_GD5480:
-			cinfo->multiplexing = 1;
-			break;
+	if (cirrusfb_check_pixclock(var, info))
+		return -EINVAL;
 
-		default:
-			dev_err(info->device,
-				"Frequency greater than maxclock (%ld kHz)\n",
-				maxclock);
-			return -EINVAL;
-		}
-	}
-#if 0
-	/* TODO: If we have a 1MB 5434, we need to put ourselves in a mode where
-	 * the VCLK is double the pixel clock. */
-	switch (var->bits_per_pixel) {
-	case 16:
-	case 32:
-		if (var->xres <= 800)
-			/* Xbh has this type of clock for 32-bit */
-			freq /= 2;
-		break;
-	}
-#endif
 	return 0;
 }
 
@@ -653,7 +628,6 @@ static int cirrusfb_set_par_foo(struct f
 	struct fb_var_screeninfo *var = &info->var;
 	u8 __iomem *regbase = cinfo->regbase;
 	unsigned char tmp;
-	int err;
 	int pitch;
 	const struct cirrusfb_board_info_rec *bi;
 	int hdispend, hsyncstart, hsyncend, htotal;
@@ -664,16 +638,28 @@ static int cirrusfb_set_par_foo(struct f
 
 	dev_dbg(info->device, "Requested mode: %dx%dx%d\n",
 	       var->xres, var->yres, var->bits_per_pixel);
-	dev_dbg(info->device, "pixclock: %d\n", var->pixclock);
 
-	init_vgachip(info);
+	switch (var->bits_per_pixel) {
+	case 1:
+		info->fix.line_length = var->xres_virtual / 8;
+		info->fix.visual = FB_VISUAL_MONO10;
+		break;
 
-	err = cirrusfb_decode_var(var, info);
-	if (err) {
-		/* should never happen */
-		dev_dbg(info->device, "mode change aborted.  invalid var.\n");
-		return -EINVAL;
+	case 8:
+		info->fix.line_length = var->xres_virtual;
+		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
+		break;
+
+	case 16:
+	case 32:
+		info->fix.line_length = var->xres_virtual *
+					var->bits_per_pixel >> 3;
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
+		break;
 	}
+	info->fix.type = FB_TYPE_PACKED_PIXELS;
+
+	init_vgachip(info);
 
 	bi = &cirrusfb_board_info[cinfo->btype];
 
@@ -873,9 +859,6 @@ static int cirrusfb_set_par_foo(struct f
 		 * address wrap, no compat. */
 		vga_wcrt(regbase, VGA_CRTC_MODE, 0xc3);
 
-/* HAEH?	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, 0x20);
- * previously: 0x00  unlock VGA_CRTC_H_TOTAL..CRT7 */
-
 	/* don't know if it would hurt to also program this if no interlaced */
 	/* mode is used, but I feel better this way.. :-) */
 	if (var->vmode & FB_VMODE_INTERLACED)
@@ -883,8 +866,6 @@ static int cirrusfb_set_par_foo(struct f
 	else
 		vga_wcrt(regbase, VGA_CRTC_REGS, 0x00);	/* interlace control */
 
-	vga_wseq(regbase, VGA_SEQ_CHARACTER_MAP, 0);
-
 	/* adjust horizontal/vertical sync type (low/high) */
 	/* enable display memory & CRTC I/O address for color mode */
 	tmp = 0x03;
@@ -896,8 +877,6 @@ static int cirrusfb_set_par_foo(struct f
 		tmp |= 0xc;
 	WGen(cinfo, VGA_MIS_W, tmp);
 
-	/* Screen A Preset Row-Scan register */
-	vga_wcrt(regbase, VGA_CRTC_PRESET_ROW, 0);
 	/* text cursor on and start line */
 	vga_wcrt(regbase, VGA_CRTC_CURSOR_START, 0);
 	/* text cursor end line */
@@ -1248,7 +1227,6 @@ static int cirrusfb_set_par_foo(struct f
 		dev_dbg(info->device, "CRT1e: %d\n", tmp);
 	}
 
-
 	/* pixel panning */
 	vga_wattr(regbase, CL_AR33, 0);
 
@@ -1274,9 +1252,6 @@ static int cirrusfb_set_par_foo(struct f
 	vga_wseq(regbase, VGA_SEQ_CLOCK_MODE, tmp);
 	dev_dbg(info->device, "CL_SEQR1: %d\n", tmp);
 
-	/* pan to requested offset */
-	cirrusfb_pan_display(var, info);
-
 #ifdef CIRRUSFB_DEBUG
 	cirrusfb_dbg_reg_dump(info, NULL);
 #endif
@@ -1332,8 +1307,7 @@ static int cirrusfb_setcolreg(unsigned r
 static int cirrusfb_pan_display(struct fb_var_screeninfo *var,
 				struct fb_info *info)
 {
-	int xoffset = 0;
-	int yoffset = 0;
+	int xoffset;
 	unsigned long base;
 	unsigned char tmp, xpix;
 	struct cirrusfb_info *cinfo = info->par;
@@ -1347,9 +1321,8 @@ static int cirrusfb_pan_display(struct f
 		return -EINVAL;
 
 	xoffset = var->xoffset * info->var.bits_per_pixel / 8;
-	yoffset = var->yoffset;
 
-	base = yoffset * info->fix.line_length + xoffset;
+	base = var->yoffset * info->fix.line_length + xoffset;
 
 	if (info->var.bits_per_pixel == 1) {
 		/* base is already correct */
@@ -1363,10 +1336,8 @@ static int cirrusfb_pan_display(struct f
 		cirrusfb_WaitBLT(cinfo->regbase);
 
 	/* lower 8 + 8 bits of screen start address */
-	vga_wcrt(cinfo->regbase, VGA_CRTC_START_LO,
-		 (unsigned char) (base & 0xff));
-	vga_wcrt(cinfo->regbase, VGA_CRTC_START_HI,
-		 (unsigned char) (base >> 8));
+	vga_wcrt(cinfo->regbase, VGA_CRTC_START_LO, base & 0xff);
+	vga_wcrt(cinfo->regbase, VGA_CRTC_START_HI, (base >> 8) & 0xff);
 
 	/* 0xf2 is %11110010, exclude tmp bits */
 	tmp = vga_rcrt(cinfo->regbase, CL_CRT1B) & 0xf2;
@@ -1544,10 +1515,6 @@ static void init_vgachip(struct fb_info 
 
 		/* FullBandwidth (video off) and 8/9 dot clock */
 		vga_wseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE, 0x21);
-		/* polarity (-/-), disable access to display memory,
-		 * VGA_CRTC_START_HI base address: color
-		 */
-		WGen(cinfo, VGA_MIS_W, 0xc1);
 
 		/* "magic cookie" - doesn't make any sense to me.. */
 /*      vga_wgfx(cinfo->regbase, CL_GRA, 0xce);   */
@@ -1614,10 +1581,6 @@ static void init_vgachip(struct fb_info 
 	vga_wcrt(cinfo->regbase, VGA_CRTC_CURSOR_START, 0x20);
 	/* Text cursor end: - */
 	vga_wcrt(cinfo->regbase, VGA_CRTC_CURSOR_END, 0x00);
-	/* Screen start address high: 0 */
-	vga_wcrt(cinfo->regbase, VGA_CRTC_START_HI, 0x00);
-	/* Screen start address low: 0 */
-	vga_wcrt(cinfo->regbase, VGA_CRTC_START_LO, 0x00);
 	/* text cursor location high: 0 */
 	vga_wcrt(cinfo->regbase, VGA_CRTC_CURSOR_HI, 0x00);
 	/* text cursor location low: 0 */
@@ -1625,10 +1588,6 @@ static void init_vgachip(struct fb_info 
 
 	/* Underline Row scanline: - */
 	vga_wcrt(cinfo->regbase, VGA_CRTC_UNDERLINE, 0x00);
-	/* mode control: timing enable, byte mode, no compat modes */
-	vga_wcrt(cinfo->regbase, VGA_CRTC_MODE, 0xc3);
-	/* Line Compare: not needed */
-	vga_wcrt(cinfo->regbase, VGA_CRTC_LINE_COMPARE, 0x00);
 	/* ### add 0x40 for text modes with > 30 MHz pixclock */
 	/* ext. display controls: ext.adr. wrap */
 	vga_wcrt(cinfo->regbase, CL_CRT1B, 0x02);
@@ -1697,12 +1656,6 @@ static void init_vgachip(struct fb_info 
 
 	WGen(cinfo, VGA_PEL_MSK, 0xff);	/* Pixel mask: no mask */
 
-	if (cinfo->btype != BT_ALPINE && cinfo->btype != BT_GD5480)
-	/* polarity (-/-), enable display mem,
-	 * VGA_CRTC_START_HI i/o base = color
-	 */
-		WGen(cinfo, VGA_MIS_W, 0xc3);
