From: akpm@linux-foundation.org
Subject: - tridentfb-acceleration-code-improvements.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:17 -0700
Message-ID: <200807242331.m6ONVHng011614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756735AbYGXXbT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: acceleration code improvements
has been removed from the -mm tree.  Its filename was
     tridentfb-acceleration-code-improvements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: acceleration code improvements
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch brings various acceleration improvements:
- set  copyarea/fillrect for non-accelerated framebuffer (fix)
- remove 15 bpp depth handling to simplify code as it hardly
  works (15 bpp handling was obviously missing in some switches)
- add fb_sync call and move waiting before accelerated function
  to make acceleration more asynchronous to cpu (few % of speed
  improvement)
- add cpu_relax() call in waiting loops
- make longer register names and name more registers
- move registers' definition to header
- general code improvements (shortening, simplifying)

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |  261 ++++++++++++------------------------
 include/video/trident.h   |   21 ++
 2 files changed, 109 insertions(+), 173 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-acceleration-code-improvements drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-acceleration-code-improvements
+++ a/drivers/video/tridentfb.c
@@ -1,5 +1,5 @@
 /*
- * Frame buffer driver for Trident Blade and Image series
+ * Frame buffer driver for Trident TGUI, Blade and Image series
  *
  * Copyright 2001, 2002 - Jani Monoses   <jani@iv.ro>
  *
@@ -13,7 +13,6 @@
  *	code, suggestions
  * TODO:
  *	timing value tweaking so it looks good on every monitor in every mode
- *	TGUI acceleration
  */
 
 #include <linux/module.h>
@@ -193,37 +192,13 @@ static inline u32 readmmr(struct trident
  */
 
 #define point(x, y) ((y) << 16 | (x))
-#define STA	0x2120
-#define CMD	0x2144
-#define ROP	0x2148
-#define CLR	0x2160
-#define SR1	0x2100
-#define SR2	0x2104
-#define DR1	0x2108
-#define DR2	0x210C
-
-#define ROP_S	0xCC
 
 static void blade_init_accel(struct tridentfb_par *par, int pitch, int bpp)
 {
 	int v1 = (pitch >> 3) << 20;
-	int tmp = 0, v2;
-	switch (bpp) {
-	case 8:
-		tmp = 0;
-		break;
-	case 15:
-		tmp = 5;
-		break;
-	case 16:
-		tmp = 1;
-		break;
-	case 24:
-	case 32:
-		tmp = 2;
-		break;
-	}
-	v2 = v1 | (tmp << 29);
+	int tmp = bpp == 24 ? 2 : (bpp >> 4);
+	int v2 = v1 | (tmp << 29);
+
 	writemmr(par, 0x21C0, v2);
 	writemmr(par, 0x21C4, v2);
 	writemmr(par, 0x21B8, v2);
@@ -237,29 +212,29 @@ static void blade_init_accel(struct trid
 
 static void blade_wait_engine(struct tridentfb_par *par)
 {
-	while (readmmr(par, STA) & 0xFA800000) ;
+	while (readmmr(par, STATUS) & 0xFA800000)
+		cpu_relax();
 }
 
 static void blade_fill_rect(struct tridentfb_par *par,
 			    u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
 {
-	writemmr(par, CLR, c);
-	writemmr(par, ROP, rop ? 0x66 : ROP_S);
+	writemmr(par, COLOR, c);
+	writemmr(par, ROP, rop ? ROP_X : ROP_S);
 	writemmr(par, CMD, 0x20000000 | 1 << 19 | 1 << 4 | 2 << 2);
 
-	writemmr(par, DR1, point(x, y));
-	writemmr(par, DR2, point(x + w - 1, y + h - 1));
+	writemmr(par, DST1, point(x, y));
+	writemmr(par, DST2, point(x + w - 1, y + h - 1));
 }
 
 static void blade_copy_rect(struct tridentfb_par *par,
 			    u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
-	u32 s1, s2, d1, d2;
 	int direction = 2;
-	s1 = point(x1, y1);
-	s2 = point(x1 + w - 1, y1 + h - 1);
-	d1 = point(x2, y2);
-	d2 = point(x2 + w - 1, y2 + h - 1);
+	u32 s1 = point(x1, y1);
+	u32 s2 = point(x1 + w - 1, y1 + h - 1);
+	u32 d1 = point(x2, y2);
+	u32 d2 = point(x2 + w - 1, y2 + h - 1);
 
 	if ((y1 > y2) || ((y1 == y2) && (x1 > x2)))
 		direction = 0;
@@ -267,38 +242,20 @@ static void blade_copy_rect(struct tride
 	writemmr(par, ROP, ROP_S);
 	writemmr(par, CMD, 0xE0000000 | 1 << 19 | 1 << 4 | 1 << 2 | direction);
 
-	writemmr(par, SR1, direction ? s2 : s1);
-	writemmr(par, SR2, direction ? s1 : s2);
-	writemmr(par, DR1, direction ? d2 : d1);
-	writemmr(par, DR2, direction ? d1 : d2);
+	writemmr(par, SRC1, direction ? s2 : s1);
+	writemmr(par, SRC2, direction ? s1 : s2);
+	writemmr(par, DST1, direction ? d2 : d1);
+	writemmr(par, DST2, direction ? d1 : d2);
 }
 
 /*
  * BladeXP specific acceleration functions
  */
 
-#define ROP_P 0xF0
-#define masked_point(x, y) ((y & 0xffff)<<16|(x & 0xffff))
-
 static void xp_init_accel(struct tridentfb_par *par, int pitch, int bpp)
 {
-	int tmp = 0, v1;
-	unsigned char x = 0;
-
-	switch (bpp) {
-	case 8:
-		x = 0;
-		break;
-	case 16:
-		x = 1;
-		break;
-	case 24:
-		x = 3;
-		break;
-	case 32:
-		x = 2;
-		break;
-	}
+	unsigned char x = bpp == 24 ? 3 : (bpp >> 4);
+	int v1 = pitch << (bpp == 24 ? 20 : (18 + x));
 
 	switch (pitch << (bpp >> 3)) {
 	case 8192:
@@ -320,22 +277,6 @@ static void xp_init_accel(struct trident
 
 	eng_oper = x | 0x40;
 
-	switch (bpp) {
-	case 8:
-		tmp = 18;
-		break;
-	case 15:
-	case 16:
-		tmp = 19;
-		break;
-	case 24:
-	case 32:
-		tmp = 20;
-		break;
-	}
-
-	v1 = pitch << tmp;
-
 	writemmr(par, 0x2154, v1);
 	writemmr(par, 0x2150, v1);
 	t_outb(par, 3, 0x2126);
@@ -343,15 +284,11 @@ static void xp_init_accel(struct trident
 
 static void xp_wait_engine(struct tridentfb_par *par)
 {
-	int busy;
 	int count, timeout;
 
 	count = 0;
 	timeout = 0;
-	for (;;) {
-		busy = t_inb(par, STA) & 0x80;
-		if (busy != 0x80)
-			return;
+	while (t_inb(par, STATUS) & 0x80) {
 		count++;
 		if (count == 10000000) {
 			/* Timeout */
@@ -359,10 +296,11 @@ static void xp_wait_engine(struct triden
 			timeout++;
 			if (timeout == 8) {
 				/* Reset engine */
-				t_outb(par, 0x00, 0x2120);
+				t_outb(par, 0x00, STATUS);
 				return;
 			}
 		}
+		cpu_relax();
 	}
 }
 
@@ -371,10 +309,10 @@ static void xp_fill_rect(struct tridentf
 {
 	writemmr(par, 0x2127, ROP_P);
 	writemmr(par, 0x2158, c);
-	writemmr(par, 0x2128, 0x4000);
-	writemmr(par, 0x2140, masked_point(h, w));
-	writemmr(par, 0x2138, masked_point(y, x));
-	t_outb(par, 0x01, 0x2124);
+	writemmr(par, DRAWFL, 0x4000);
+	writemmr(par, OLDDIM, point(h, w));
+	writemmr(par, OLDDST, point(y, x));
+	t_outb(par, 0x01, OLDCMD);
 	t_outb(par, eng_oper, 0x2125);
 }
 
@@ -404,12 +342,12 @@ static void xp_copy_rect(struct tridentf
 		y2_tmp = y2;
 	}
 
-	writemmr(par, 0x2128, direction);
+	writemmr(par, DRAWFL, direction);
 	t_outb(par, ROP_S, 0x2127);
-	writemmr(par, 0x213C, masked_point(y1_tmp, x1_tmp));
-	writemmr(par, 0x2138, masked_point(y2_tmp, x2_tmp));
-	writemmr(par, 0x2140, masked_point(h, w));
-	t_outb(par, 0x01, 0x2124);
+	writemmr(par, OLDSRC, point(y1_tmp, x1_tmp));
+	writemmr(par, OLDDST, point(y2_tmp, x2_tmp));
+	writemmr(par, OLDDIM, point(h, w));
+	t_outb(par, 0x01, OLDCMD);
 }
 
 /*
@@ -417,22 +355,8 @@ static void xp_copy_rect(struct tridentf
  */
 static void image_init_accel(struct tridentfb_par *par, int pitch, int bpp)
 {
-	int tmp = 0;
-	switch (bpp) {
-	case 8:
-		tmp = 0;
-		break;
-	case 15:
-		tmp = 5;
-		break;
-	case 16:
-		tmp = 1;
-		break;
-	case 24:
-	case 32:
-		tmp = 2;
-		break;
-	}
+	int tmp = bpp == 24 ? 2: (bpp >> 4);
+
 	writemmr(par, 0x2120, 0xF0000000);
 	writemmr(par, 0x2120, 0x40000000 | tmp);
 	writemmr(par, 0x2120, 0x80000000);
@@ -450,7 +374,8 @@ static void image_init_accel(struct trid
 
 static void image_wait_engine(struct tridentfb_par *par)
 {
-	while (readmmr(par, 0x2164) & 0xF0000000) ;
+	while (readmmr(par, 0x2164) & 0xF0000000)
+		cpu_relax();
 }
 
 static void image_fill_rect(struct tridentfb_par *par,
@@ -461,8 +386,8 @@ static void image_fill_rect(struct tride
 
 	writemmr(par, 0x2144, c);
 
-	writemmr(par, DR1, point(x, y));
-	writemmr(par, DR2, point(x + w - 1, y + h - 1));
+	writemmr(par, DST1, point(x, y));
+	writemmr(par, DST2, point(x + w - 1, y + h - 1));
 
 	writemmr(par, 0x2124, 0x80000000 | 3 << 22 | 1 << 10 | 1 << 9);
 }
@@ -470,12 +395,11 @@ static void image_fill_rect(struct tride
 static void image_copy_rect(struct tridentfb_par *par,
 			    u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
-	u32 s1, s2, d1, d2;
 	int direction = 2;
-	s1 = point(x1, y1);
-	s2 = point(x1 + w - 1, y1 + h - 1);
-	d1 = point(x2, y2);
-	d2 = point(x2 + w - 1, y2 + h - 1);
+	u32 s1 = point(x1, y1);
+	u32 s2 = point(x1 + w - 1, y1 + h - 1);
+	u32 d1 = point(x2, y2);
+	u32 d2 = point(x2 + w - 1, y2 + h - 1);
 
 	if ((y1 > y2) || ((y1 == y2) && (x1 > x2)))
 		direction = 0;
@@ -483,10 +407,10 @@ static void image_copy_rect(struct tride
 	writemmr(par, 0x2120, 0x80000000);
 	writemmr(par, 0x2120, 0x90000000 | ROP_S);
 
-	writemmr(par, SR1, direction ? s2 : s1);
-	writemmr(par, SR2, direction ? s1 : s2);
-	writemmr(par, DR1, direction ? d2 : d1);
-	writemmr(par, DR2, direction ? d1 : d2);
+	writemmr(par, SRC1, direction ? s2 : s1);
+	writemmr(par, SRC2, direction ? s1 : s2);
+	writemmr(par, DST1, direction ? d2 : d1);
+	writemmr(par, DST2, direction ? d1 : d2);
 	writemmr(par, 0x2124,
 		 0x80000000 | 1 << 22 | 1 << 10 | 1 << 7 | direction);
 }
@@ -497,27 +421,12 @@ static void image_copy_rect(struct tride
 
 static void tgui_init_accel(struct tridentfb_par *par, int pitch, int bpp)
 {
-	unsigned char x = 0;
+	unsigned char x = bpp == 24 ? 3 : (bpp >> 4);
 
 	/* disable clipping */
 	writemmr(par, 0x2148, 0);
 	writemmr(par, 0x214C, point(4095, 2047));
 
-	switch (bpp) {
-	case 8:
-		x = 0;
-		break;
-	case 16:
-		x = 1;
-		break;
-	case 24:
-		x = 3;
-		break;
-	case 32:
-		x = 2;
-		break;
-	}
-
 	switch ((pitch * bpp) / 8) {
 	case 8192:
 	case 512:
@@ -541,11 +450,11 @@ static void tgui_fill_rect(struct triden
 			   u32 x, u32 y, u32 w, u32 h, u32 c, u32 rop)
 {
 	t_outb(par, ROP_P, 0x2127);
-	writemmr(par, 0x212c, c);
-	writemmr(par, 0x2128, 0x4020);
-	writemmr(par, 0x2140, point(w - 1, h - 1));
-	writemmr(par, 0x2138, point(x, y));
-	t_outb(par, 1, 0x2124);
+	writemmr(par, OLDCLR, c);
+	writemmr(par, DRAWFL, 0x4020);
+	writemmr(par, OLDDIM, point(w - 1, h - 1));
+	writemmr(par, OLDDST, point(x, y));
+	t_outb(par, 1, OLDCMD);
 }
 
 static void tgui_copy_rect(struct tridentfb_par *par,
@@ -572,12 +481,12 @@ static void tgui_copy_rect(struct triden
 		y2_tmp = y2;
 	}
 
-	writemmr(par, 0x2128, 0x4 | flags);
+	writemmr(par, DRAWFL, 0x4 | flags);
 	t_outb(par, ROP_S, 0x2127);
-	writemmr(par, 0x213C, point(x1_tmp, y1_tmp));
-	writemmr(par, 0x2138, point(x2_tmp, y2_tmp));
-	writemmr(par, 0x2140, point(w - 1, h - 1));
-	t_outb(par, 1, 0x2124);
+	writemmr(par, OLDSRC, point(x1_tmp, y1_tmp));
+	writemmr(par, OLDDST, point(x2_tmp, y2_tmp));
+	writemmr(par, OLDDIM, point(w - 1, h - 1));
+	t_outb(par, 1, OLDCMD);
 }
 
 /*
@@ -588,37 +497,40 @@ static void tridentfb_fillrect(struct fb
 			       const struct fb_fillrect *fr)
 {
 	struct tridentfb_par *par = info->par;
-	int bpp = info->var.bits_per_pixel;
-	int col = 0;
+	int col;
 
-	switch (bpp) {
-	default:
-	case 8:
-		col |= fr->color;
+	if (info->var.bits_per_pixel == 8) {
+		col = fr->color;
 		col |= col << 8;
 		col |= col << 16;
-		break;
-	case 16:
-		col = ((u32 *)(info->pseudo_palette))[fr->color];
-		break;
-	case 32:
+	} else
 		col = ((u32 *)(info->pseudo_palette))[fr->color];
-		break;
-	}
 
+	par->wait_engine(par);
 	par->fill_rect(par, fr->dx, fr->dy, fr->width,
 		       fr->height, col, fr->rop);
-	par->wait_engine(par);
 }
+
 static void tridentfb_copyarea(struct fb_info *info,
 			       const struct fb_copyarea *ca)
 {
 	struct tridentfb_par *par = info->par;
 
+	par->wait_engine(par);
 	par->copy_rect(par, ca->sx, ca->sy, ca->dx, ca->dy,
 		       ca->width, ca->height);
+}
+
+static int tridentfb_sync(struct fb_info *info)
+{
+	struct tridentfb_par *par = info->par;
+
 	par->wait_engine(par);
+	return 0;
 }
+#else
+#define tridentfb_fillrect cfb_fillrect
+#define tridentfb_copyarea cfb_copyarea
 #endif /* CONFIG_FB_TRIDENT_ACCEL */
 
 /*
@@ -921,6 +833,8 @@ static int tridentfb_check_var(struct fb
 	/* check color depth */
 	if (bpp == 24)
 		bpp = var->bits_per_pixel = 32;
+	if (bpp != 8 && bpp != 16 && bpp != 32)
+		return -EINVAL;
 	if (par->chip_id == TGUI9440 && bpp == 32)
 		return -EINVAL;
 	/* check whether resolution fits on panel and in memory */
@@ -928,8 +842,15 @@ static int tridentfb_check_var(struct fb
 		return -EINVAL;
 	/* various resolution checks */
 	var->xres = (var->xres + 7) & ~0x7;
-	if (var->xres != var->xres_virtual)
+	if (var->xres > var->xres_virtual)
 		var->xres_virtual = var->xres;
+	if (var->yres > var->yres_virtual)
+		var->yres_virtual = var->yres;
+	if (var->xres_virtual > 4095 || var->yres > 2048)
+		return -EINVAL;
+	/* prevent from position overflow for acceleration */
+	if (var->yres_virtual > 0xffff)
+		return -EINVAL;
 	line_length = var->xres_virtual * bpp / 8;
 #ifdef CONFIG_FB_TRIDENT_ACCEL
 	if (!is3Dchip(par->chip_id)) {
@@ -944,6 +865,8 @@ static int tridentfb_check_var(struct fb
 			var->xres_virtual = 4096 * 8 / bpp;
 		else if (line_length <= 8192)
 			var->xres_virtual = 8192 * 8 / bpp;
+		else
+			return -EINVAL;
 
 		line_length = var->xres_virtual * bpp / 8;
 	}
@@ -1229,9 +1152,6 @@ static int tridentfb_set_par(struct fb_i
 	case 8:
 		tmp = 0;
 		break;
-	case 15:
-		tmp = 0x10;
-		break;
 	case 16:
 		tmp = 0x30;
 		break;
@@ -1352,10 +1272,11 @@ static struct fb_ops tridentfb_ops = {
 	.fb_blank = tridentfb_blank,
 	.fb_check_var = tridentfb_check_var,
 	.fb_set_par = tridentfb_set_par,
-#ifdef CONFIG_FB_TRIDENT_ACCEL
 	.fb_fillrect = tridentfb_fillrect,
 	.fb_copyarea = tridentfb_copyarea,
 	.fb_imageblit = cfb_imageblit,
+#ifdef CONFIG_FB_TRIDENT_ACCEL
+	.fb_sync = tridentfb_sync,
 #endif
 };
 
@@ -1366,7 +1287,6 @@ static int __devinit trident_pci_probe(s
 	unsigned char revision;
 	struct fb_info *info;
 	struct tridentfb_par *default_par;
-	int defaultaccel;
 	int chip3D;
 	int chip_id;
 
@@ -1448,9 +1368,6 @@ static int __devinit trident_pci_probe(s
 
 	default_par->chip_id = chip_id;
 
-	/* acceleration is on by default for 3D chips */
-	defaultaccel = chip3D && !noaccel;
-
 	/* setup MMIO region */
 	tridentfb_fix.mmio_start = pci_resource_start(dev, 1);
 	tridentfb_fix.mmio_len = chip3D ? 0x20000 : 0x10000;
@@ -1515,7 +1432,7 @@ static int __devinit trident_pci_probe(s
 	if (err < 0)
 		goto out_unmap2;
 
-	if (defaultaccel && default_par->init_accel)
+	if (!noaccel && default_par->init_accel)
 		info->var.accel_flags |= FB_ACCELF_TEXT;
 	else
 		info->var.accel_flags &= ~FB_ACCELF_TEXT;
diff -puN include/video/trident.h~tridentfb-acceleration-code-improvements include/video/trident.h
--- a/include/video/trident.h~tridentfb-acceleration-code-improvements
+++ a/include/video/trident.h
@@ -4,7 +4,7 @@
 #endif
 
 #if TRIDENTFB_DEBUG
-#define debug(f,a...)	printk("%s:" f,  __FUNCTION__ , ## a);mdelay(1000);
+#define debug(f,a...)	printk("%s:" f,  __FUNCTION__ , ## a);mdelay(100);
 #else
 #define debug(f,a...)
 #endif
@@ -124,3 +124,22 @@
 #define BiosMode     0x5c
 #define BiosReg      0x5d
 
+/* Graphics Engine */
+#define STATUS	0x2120
+#define OLDCMD	0x2124
+#define DRAWFL	0x2128
+#define OLDCLR	0x212C
+#define OLDDST	0x2138
+#define OLDSRC	0x213C
+#define OLDDIM	0x2140
+#define CMD	0x2144
+#define ROP	0x2148
+#define COLOR	0x2160
+#define SRC1	0x2100
+#define SRC2	0x2104
+#define DST1	0x2108
+#define DST2	0x210C
+
+#define ROP_S	0xCC
+#define ROP_P	0xF0
+#define ROP_X	0x66
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

