From: akpm@linux-foundation.org
Subject: + s3c2410fb-code-cleanup.patch added to -mm tree
Date: Wed, 15 Aug 2007 16:21:00 -0700
Message-ID: <200708152321.l7FNL01N020313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934624AbXHOXVr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:21:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     s3c2410fb: code cleanup
has been added to the -mm tree.  Its filename is
     s3c2410fb-code-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: s3c2410fb: code cleanup
=46rom: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch cleans up the driver a bit. It contains
coding style fixes (pointed by Lindent and checkpatch),
white space clean ups and few minor code improvements.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |  359 +++++++++++++++++-------------------
 1 files changed, 173 insertions(+), 186 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-code-cleanup drivers/vide=
o/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-code-cleanup
+++ a/drivers/video/s3c2410fb.c
@@ -31,8 +31,8 @@
  *	- add pixel clock divisor control
  *
  * 2004-11-11: Arnaud Patard <arnaud.patard@rtp-net.org>
- * 	- Removed the use of currcon as it no more exist
- * 	- Added LCD power sysfs interface
+ *	- Removed the use of currcon as it no more exist
+ *	- Added LCD power sysfs interface
  *
  * 2004-11-03: Ben Dooks <ben-linux@fluff.org>
  *	- minor cleanups
@@ -49,12 +49,12 @@
  *      - Suppress command line options
  *
  * 2004-09-15: Arnaud Patard <arnaud.patard@rtp-net.org>
- * 	- code cleanup
+ *	- code cleanup
  *
  * 2004-09-07: Arnaud Patard <arnaud.patard@rtp-net.org>
- * 	- Renamed from h1940fb.c to s3c2410fb.c
- * 	- Add support for different devices
- * 	- Backlight support
+ *	- Renamed from h1940fb.c to s3c2410fb.c
+ *	- Add support for different devices
+ *	- Backlight support
  *
  * 2004-09-05: Herbert P=F6tzl <herbert@13thfloor.at>
  *	- added clock (de-)allocation code
@@ -102,14 +102,13 @@
=20
 #include "s3c2410fb.h"
=20
-
 static struct s3c2410fb_mach_info *mach_info;
=20
 /* Debugging stuff */
 #ifdef CONFIG_FB_S3C2410_DEBUG
-static int debug	   =3D 1;
+static int debug	=3D 1;
 #else
-static int debug	   =3D 0;
+static int debug	=3D 0;
 #endif
=20
 #define dprintk(msg...)	if (debug) { printk(KERN_DEBUG "s3c2410fb: " m=
sg); }
@@ -119,19 +118,20 @@ static int debug	   =3D 0;
 /* s3c2410fb_set_lcdaddr
  *
  * initialise lcd controller address pointers
-*/
-
+ */
 static void s3c2410fb_set_lcdaddr(struct s3c2410fb_info *fbi)
 {
 	struct fb_var_screeninfo *var =3D &fbi->fb->var;
 	unsigned long saddr1, saddr2, saddr3;
+	int line_length =3D var->xres * var->bits_per_pixel;
=20
 	saddr1  =3D fbi->fb->fix.smem_start >> 1;
 	saddr2  =3D fbi->fb->fix.smem_start;
-	saddr2 +=3D (var->xres * var->yres * var->bits_per_pixel)/8;
-	saddr2>>=3D 1;
+	saddr2 +=3D (line_length * var->yres) / 8;
+	saddr2 >>=3D 1;
=20
-	saddr3 =3D  S3C2410_OFFSIZE(0) | S3C2410_PAGEWIDTH((var->xres * var->=
bits_per_pixel / 16) & 0x3ff);
+	saddr3 =3D S3C2410_OFFSIZE(0) |
+		 S3C2410_PAGEWIDTH((line_length / 16) & 0x3ff);
=20
 	dprintk("LCDSADDR1 =3D 0x%08lx\n", saddr1);
 	dprintk("LCDSADDR2 =3D 0x%08lx\n", saddr2);
@@ -145,8 +145,7 @@ static void s3c2410fb_set_lcdaddr(struct
 /* s3c2410fb_calc_pixclk()
  *
  * calculate divisor for clk->pixclk
-*/
-
+ */
 static unsigned int s3c2410fb_calc_pixclk(struct s3c2410fb_info *fbi,
 					  unsigned long pixclk)
 {
@@ -159,8 +158,8 @@ static unsigned int s3c2410fb_calc_pixcl
 	 */
=20
 	div =3D (unsigned long long)clk * pixclk;
-	do_div(div,1000000UL);
-	do_div(div,1000000UL);
+	do_div(div, 1000000UL);
+	do_div(div, 1000000UL);
=20
 	dprintk("pixclk %ld, divisor is %ld\n", pixclk, (long)div);
 	return div;
@@ -198,93 +197,84 @@ static int s3c2410fb_check_var(struct fb
 	else if (var->bits_per_pixel < fbi->mach_info->bpp.min)
 		var->bits_per_pixel =3D fbi->mach_info->bpp.min;
=20
+	var->transp.offset =3D 0;
+	var->transp.length =3D 0;
 	/* set r/g/b positions */
 	switch (var->bits_per_pixel) {
-		case 1:
-		case 2:
-		case 4:
-			var->red.offset    	=3D 0;
-			var->red.length    	=3D var->bits_per_pixel;
-			var->green         	=3D var->red;
-			var->blue          	=3D var->red;
-			var->transp.offset 	=3D 0;
-			var->transp.length 	=3D 0;
-			break;
-		case 8:
-			if ( fbi->mach_info->type !=3D S3C2410_LCDCON1_TFT ) {
-				/* 8 bpp 332 */
-				var->red.length		=3D 3;
-				var->red.offset		=3D 5;
-				var->green.length	=3D 3;
-				var->green.offset	=3D 2;
-				var->blue.length	=3D 2;
-				var->blue.offset	=3D 0;
-				var->transp.length	=3D 0;
-			} else {
-				var->red.offset    	=3D 0;
-				var->red.length    	=3D var->bits_per_pixel;
-				var->green         	=3D var->red;
-				var->blue          	=3D var->red;
-				var->transp.offset 	=3D 0;
-				var->transp.length 	=3D 0;
-			}
-			break;
-		case 12:
-			/* 12 bpp 444 */
-			var->red.length		=3D 4;
-			var->red.offset		=3D 8;
-			var->green.length	=3D 4;
-			var->green.offset	=3D 4;
-			var->blue.length	=3D 4;
+	case 1:
+	case 2:
+	case 4:
+		var->red.offset	=3D 0;
+		var->red.length	=3D var->bits_per_pixel;
+		var->green	=3D var->red;
+		var->blue	=3D var->red;
+		break;
+	case 8:
+		if (fbi->mach_info->type !=3D S3C2410_LCDCON1_TFT) {
+			/* 8 bpp 332 */
+			var->red.length		=3D 3;
+			var->red.offset		=3D 5;
+			var->green.length	=3D 3;
+			var->green.offset	=3D 2;
+			var->blue.length	=3D 2;
 			var->blue.offset	=3D 0;
-			var->transp.length	=3D 0;
-			break;
-
-		default:
-		case 16:
-			if (fbi->regs.lcdcon5 & S3C2410_LCDCON5_FRM565 ) {
-				/* 16 bpp, 565 format */
-				var->red.offset		=3D 11;
-				var->green.offset	=3D 5;
-				var->blue.offset	=3D 0;
-				var->red.length		=3D 5;
-				var->green.length	=3D 6;
-				var->blue.length	=3D 5;
-				var->transp.length	=3D 0;
-			} else {
-				/* 16 bpp, 5551 format */
-				var->red.offset		=3D 11;
-				var->green.offset	=3D 6;
-				var->blue.offset	=3D 1;
-				var->red.length		=3D 5;
-				var->green.length	=3D 5;
-				var->blue.length	=3D 5;
-				var->transp.length	=3D 0;
-			}
-			break;
-		case 24:
-			/* 24 bpp 888 */
+		} else {
+			var->red.offset		=3D 0;
 			var->red.length		=3D 8;
-			var->red.offset		=3D 16;
-			var->green.length	=3D 8;
-			var->green.offset	=3D 8;
-			var->blue.length	=3D 8;
+			var->green		=3D var->red;
+			var->blue		=3D var->red;
+		}
+		break;
+	case 12:
+		/* 12 bpp 444 */
+		var->red.length		=3D 4;
+		var->red.offset		=3D 8;
+		var->green.length	=3D 4;
+		var->green.offset	=3D 4;
+		var->blue.length	=3D 4;
+		var->blue.offset	=3D 0;
+		break;
+
+	default:
+	case 16:
+		if (fbi->regs.lcdcon5 & S3C2410_LCDCON5_FRM565) {
+			/* 16 bpp, 565 format */
+			var->red.offset		=3D 11;
+			var->green.offset	=3D 5;
 			var->blue.offset	=3D 0;
-			var->transp.length	=3D 0;
-			break;
+			var->red.length		=3D 5;
+			var->green.length	=3D 6;
+			var->blue.length	=3D 5;
+		} else {
+			/* 16 bpp, 5551 format */
+			var->red.offset		=3D 11;
+			var->green.offset	=3D 6;
+			var->blue.offset	=3D 1;
+			var->red.length		=3D 5;
+			var->green.length	=3D 5;
+			var->blue.length	=3D 5;
+		}
+		break;
+	case 24:
+		/* 24 bpp 888 */
+		var->red.length		=3D 8;
+		var->red.offset		=3D 16;
+		var->green.length	=3D 8;
+		var->green.offset	=3D 8;
+		var->blue.length	=3D 8;
+		var->blue.offset	=3D 0;
+		break;
=20
=20
 	}
 	return 0;
 }
=20
-
 /* s3c2410fb_activate_var
  *
  * activate (set) the controller from the given framebuffer
  * information
-*/
-
+ */
 static void s3c2410fb_activate_var(struct s3c2410fb_info *fbi,
 				   struct fb_var_screeninfo *var)
 {
@@ -319,7 +309,8 @@ static void s3c2410fb_activate_var(struc
=20
 		default:
 			/* invalid pixel depth */
-			dev_err(fbi->dev, "invalid bpp %d\n", var->bits_per_pixel);
+			dev_err(fbi->dev, "invalid bpp %d\n",
+				var->bits_per_pixel);
 		}
 	else
 		switch (var->bits_per_pixel) {
@@ -341,19 +332,18 @@ static void s3c2410fb_activate_var(struc
=20
 		default:
 			/* invalid pixel depth */
-			dev_err(fbi->dev, "invalid bpp %d\n", var->bits_per_pixel);
+			dev_err(fbi->dev, "invalid bpp %d\n",
+				var->bits_per_pixel);
 		}
=20
 	/* check to see if we need to update sync/borders */
=20
 	if (!fbi->mach_info->fixed_syncs) {
 		dprintk("setting vert: up=3D%d, low=3D%d, sync=3D%d\n",
-			var->upper_margin, var->lower_margin,
-			var->vsync_len);
+			var->upper_margin, var->lower_margin, var->vsync_len);
=20
 		dprintk("setting horz: lft=3D%d, rt=3D%d, sync=3D%d\n",
-			var->left_margin, var->right_margin,
-			var->hsync_len);
+			var->left_margin, var->right_margin, var->hsync_len);
=20
 		fbi->regs.lcdcon2 =3D
 			S3C2410_LCDCON2_VBPD(var->upper_margin - 1) |
@@ -373,27 +363,24 @@ static void s3c2410fb_activate_var(struc
 	fbi->regs.lcdcon2 &=3D ~S3C2410_LCDCON2_LINEVAL(0x3ff);
 	fbi->regs.lcdcon2 |=3D  S3C2410_LCDCON2_LINEVAL(var->yres - 1);
=20
-	switch(fbi->mach_info->type) {
-		case S3C2410_LCDCON1_DSCAN4:
-		case S3C2410_LCDCON1_STN8:
-			hs =3D var->xres / 8;
-			break;
-		case S3C2410_LCDCON1_STN4:
-			hs =3D var->xres / 4;
-			break;
-		default:
-		case S3C2410_LCDCON1_TFT:
-			hs =3D var->xres;
-			break;
-
+	switch (fbi->mach_info->type) {
+	case S3C2410_LCDCON1_DSCAN4:
+	case S3C2410_LCDCON1_STN8:
+		hs =3D var->xres / 8;
+		break;
+	case S3C2410_LCDCON1_STN4:
+		hs =3D var->xres / 4;
+		break;
+	default:
+	case S3C2410_LCDCON1_TFT:
+		hs =3D var->xres;
+		break;
 	}
=20
 	/* Special cases : STN color displays */
-	if ( ((fbi->regs.lcdcon1 & S3C2410_LCDCON1_MODEMASK) =3D=3D S3C2410_L=
CDCON1_STN8BPP) \
-	  || ((fbi->regs.lcdcon1 & S3C2410_LCDCON1_MODEMASK) =3D=3D S3C2410_L=
CDCON1_STN12BPP) ) {
+	if (((fbi->regs.lcdcon1 & S3C2410_LCDCON1_MODEMASK) =3D=3D S3C2410_LC=
DCON1_STN8BPP) ||
+	    ((fbi->regs.lcdcon1 & S3C2410_LCDCON1_MODEMASK) =3D=3D S3C2410_LC=
DCON1_STN12BPP))
 		hs =3D hs * 3;
-	}
-
=20
 	fbi->regs.lcdcon3 &=3D ~S3C2410_LCDCON3_HOZVAL(0x7ff);
 	fbi->regs.lcdcon3 |=3D  S3C2410_LCDCON3_HOZVAL(hs - 1);
@@ -402,11 +389,10 @@ static void s3c2410fb_activate_var(struc
 		int clkdiv =3D s3c2410fb_calc_pixclk(fbi, var->pixclock);
=20
 		if (fbi->mach_info->type =3D=3D S3C2410_LCDCON1_TFT) {
-			clkdiv =3D (clkdiv / 2) -1;
+			clkdiv =3D (clkdiv / 2) - 1;
 			if (clkdiv < 0)
 				clkdiv =3D 0;
-		}
-		else {
+		} else {
 			clkdiv =3D (clkdiv / 2);
 			if (clkdiv < 2)
 				clkdiv =3D 2;
@@ -437,9 +423,8 @@ static void s3c2410fb_activate_var(struc
 	writel(fbi->regs.lcdcon1, S3C2410_LCDCON1);
 }
=20
-
 /*
- *      s3c2410fb_set_par - Optional function. Alters the hardware sta=
te.
+ *      s3c2410fb_set_par - Alters the hardware state.
  *      @info: frame buffer structure that represents a single frame b=
uffer
  *
  */
@@ -448,20 +433,19 @@ static int s3c2410fb_set_par(struct fb_i
 	struct s3c2410fb_info *fbi =3D info->par;
 	struct fb_var_screeninfo *var =3D &info->var;
=20
-	switch (var->bits_per_pixel)
-	{
-		case 16:
-			fbi->fb->fix.visual =3D FB_VISUAL_TRUECOLOR;
-			break;
-		case 1:
-			 fbi->fb->fix.visual =3D FB_VISUAL_MONO01;
-			 break;
-		default:
-			 fbi->fb->fix.visual =3D FB_VISUAL_PSEUDOCOLOR;
-			 break;
+	switch (var->bits_per_pixel) {
+	case 16:
+		info->fix.visual =3D FB_VISUAL_TRUECOLOR;
+		break;
+	case 1:
+		info->fix.visual =3D FB_VISUAL_MONO01;
+		break;
+	default:
+		info->fix.visual =3D FB_VISUAL_PSEUDOCOLOR;
+		break;
 	}
=20
-	fbi->fb->fix.line_length     =3D (var->width*var->bits_per_pixel)/8;
+	info->fix.line_length =3D (var->width * var->bits_per_pixel) / 8;
=20
 	/* activate this new configuration */
=20
@@ -493,7 +477,8 @@ static void schedule_palette_update(stru
 }
=20
 /* from pxafb.c */
-static inline unsigned int chan_to_field(unsigned int chan, struct fb_=
bitfield *bf)
+static inline unsigned int chan_to_field(unsigned int chan,
+					 struct fb_bitfield *bf)
 {
 	chan &=3D 0xffff;
 	chan >>=3D 16 - bf->length;
@@ -507,18 +492,19 @@ static int s3c2410fb_setcolreg(unsigned=20
 	struct s3c2410fb_info *fbi =3D info->par;
 	unsigned int val;
=20
-	/* dprintk("setcol: regno=3D%d, rgb=3D%d,%d,%d\n", regno, red, green,=
 blue); */
+	/* dprintk("setcol: regno=3D%d, rgb=3D%d,%d,%d\n",
+		   regno, red, green, blue); */
=20
-	switch (fbi->fb->fix.visual) {
+	switch (info->fix.visual) {
 	case FB_VISUAL_TRUECOLOR:
-		/* true-colour, use pseuo-palette */
+		/* true-colour, use pseudo-palette */
=20
 		if (regno < 16) {
-			u32 *pal =3D fbi->fb->pseudo_palette;
+			u32 *pal =3D info->pseudo_palette;
=20
-			val  =3D chan_to_field(red,   &fbi->fb->var.red);
-			val |=3D chan_to_field(green, &fbi->fb->var.green);
-			val |=3D chan_to_field(blue,  &fbi->fb->var.blue);
+			val  =3D chan_to_field(red,   &info->var.red);
+			val |=3D chan_to_field(green, &info->var.green);
+			val |=3D chan_to_field(blue,  &info->var.blue);
=20
 			pal[regno] =3D val;
 		}
@@ -539,14 +525,13 @@ static int s3c2410fb_setcolreg(unsigned=20
 		break;
=20
 	default:
-		return 1;   /* unknown type */
+		return 1;	/* unknown type */
 	}
=20
 	return 0;
 }
=20
-
-/**
+/*
  *      s3c2410fb_blank
  *	@blank_mode: the blank mode we want.
  *	@info: frame buffer structure that represents a single frame buffer
@@ -579,12 +564,14 @@ static int s3c2410fb_blank(int blank_mod
 	return 0;
 }
=20
-static int s3c2410fb_debug_show(struct device *dev, struct device_attr=
ibute *attr, char *buf)
+static int s3c2410fb_debug_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", debug ? "on" : "off");
 }
-static int s3c2410fb_debug_store(struct device *dev, struct device_att=
ribute *attr,
-					   const char *buf, size_t len)
+static int s3c2410fb_debug_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t len)
 {
 	if (mach_info =3D=3D NULL)
 		return -EINVAL;
@@ -607,10 +594,7 @@ static int s3c2410fb_debug_store(struct=20
 	return len;
 }
=20
-
-static DEVICE_ATTR(debug, 0666,
-		   s3c2410fb_debug_show,
-		   s3c2410fb_debug_store);
+static DEVICE_ATTR(debug, 0666, s3c2410fb_debug_show, s3c2410fb_debug_=
store);
=20
 static struct fb_ops s3c2410fb_ops =3D {
 	.owner		=3D THIS_MODULE,
@@ -623,7 +607,6 @@ static struct fb_ops s3c2410fb_ops =3D {
 	.fb_imageblit	=3D cfb_imageblit,
 };
=20
-
 /*
  * s3c2410fb_map_video_memory():
  *	Allocates the DRAM memory for the frame buffer.  This buffer is
@@ -661,7 +644,8 @@ static int __init s3c2410fb_map_video_me
=20
 static inline void s3c2410fb_unmap_video_memory(struct s3c2410fb_info =
*fbi)
 {
-	dma_free_writecombine(fbi->dev,fbi->map_size,fbi->map_cpu, fbi->map_d=
ma);
+	dma_free_writecombine(fbi->dev, fbi->map_size, fbi->map_cpu,
+			      fbi->map_dma);
 }
=20
 static inline void modify_gpio(void __iomem *reg,
@@ -673,11 +657,9 @@ static inline void modify_gpio(void __io
 	writel(tmp | set, reg);
 }
=20
-
 /*
  * s3c2410fb_init_registers - Initialise all LCD-related registers
  */
-
 static int s3c2410fb_init_registers(struct s3c2410fb_info *fbi)
 {
 	unsigned long flags;
@@ -702,7 +684,7 @@ static int s3c2410fb_init_registers(stru
 	writel(fbi->regs.lcdcon4, regs + S3C2410_LCDCON4);
 	writel(fbi->regs.lcdcon5, regs + S3C2410_LCDCON5);
=20
- 	s3c2410fb_set_lcdaddr(fbi);
+	s3c2410fb_set_lcdaddr(fbi);
=20
 	dprintk("LPCSEL    =3D 0x%08lx\n", mach_info->lpcsel);
 	writel(mach_info->lpcsel, regs + S3C2410_LPCSEL);
@@ -721,13 +703,13 @@ static int s3c2410fb_init_registers(stru
 static void s3c2410fb_write_palette(struct s3c2410fb_info *fbi)
 {
 	unsigned int i;
-	unsigned long ent;
 	void __iomem *regs =3D fbi->io;
=20
 	fbi->palette_ready =3D 0;
=20
 	for (i =3D 0; i < 256; i++) {
-		if ((ent =3D fbi->palette_buffer[i]) =3D=3D PALETTE_BUFF_CLEAR)
+		unsigned long ent =3D fbi->palette_buffer[i];
+		if (ent =3D=3D PALETTE_BUFF_CLEAR)
 			continue;
=20
 		writel(ent, regs + S3C2410_TFTPAL(i));
@@ -761,12 +743,12 @@ static irqreturn_t s3c2410fb_irq(int irq
 	return IRQ_HANDLED;
 }
=20
-static char driver_name[]=3D"s3c2410fb";
+static char driver_name[] =3D "s3c2410fb";
=20
 static int __init s3c2410fb_probe(struct platform_device *pdev)
 {
 	struct s3c2410fb_info *info;
-	struct fb_info	   *fbinfo;
+	struct fb_info *fbinfo;
 	struct s3c2410fb_hw *mregs;
 	struct resource *res;
 	int ret;
@@ -777,7 +759,8 @@ static int __init s3c2410fb_probe(struct
=20
 	mach_info =3D pdev->dev.platform_data;
 	if (mach_info =3D=3D NULL) {
-		dev_err(&pdev->dev,"no platform data for lcd, cannot attach\n");
+		dev_err(&pdev->dev,
+			"no platform data for lcd, cannot attach\n");
 		return -EINVAL;
 	}
=20
@@ -790,9 +773,8 @@ static int __init s3c2410fb_probe(struct
 	}
=20
 	fbinfo =3D framebuffer_alloc(sizeof(struct s3c2410fb_info), &pdev->de=
v);
-	if (!fbinfo) {
+	if (!fbinfo)
 		return -ENOMEM;
-	}
=20
 	info =3D fbinfo->par;
 	info->fb =3D fbinfo;
@@ -800,12 +782,12 @@ static int __init s3c2410fb_probe(struct
=20
 	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res =3D=3D NULL) {
-		dev_err(&pdev->dev, "failed to get memory registersn");
+		dev_err(&pdev->dev, "failed to get memory registers\n");
 		ret =3D -ENXIO;
 		goto dealloc_fb;
 	}
=20
-	size =3D (res->end - res->start)+1;
+	size =3D (res->end - res->start) + 1;
 	info->mem =3D request_mem_region(res->start, size, pdev->name);
 	if (info->mem =3D=3D NULL) {
 		dev_err(&pdev->dev, "failed to get memory region\n");
@@ -859,13 +841,19 @@ static int __init s3c2410fb_probe(struct
 	fbinfo->var.yres_virtual    =3D mach_info->yres.defval;
 	fbinfo->var.bits_per_pixel  =3D mach_info->bpp.defval;
=20
-	fbinfo->var.upper_margin    =3D S3C2410_LCDCON2_GET_VBPD(mregs->lcdco=
n2) + 1;
-	fbinfo->var.lower_margin    =3D S3C2410_LCDCON2_GET_VFPD(mregs->lcdco=
n2) + 1;
-	fbinfo->var.vsync_len	    =3D S3C2410_LCDCON2_GET_VSPW(mregs->lcdcon2=
) + 1;
-
-	fbinfo->var.left_margin	    =3D S3C2410_LCDCON3_GET_HFPD(mregs->lcdco=
n3) + 1;
-	fbinfo->var.right_margin    =3D S3C2410_LCDCON3_GET_HBPD(mregs->lcdco=
n3) + 1;
-	fbinfo->var.hsync_len	    =3D S3C2410_LCDCON4_GET_HSPW(mregs->lcdcon4=
) + 1;
+	fbinfo->var.upper_margin    =3D
+				S3C2410_LCDCON2_GET_VBPD(mregs->lcdcon2) + 1;
+	fbinfo->var.lower_margin    =3D
+				S3C2410_LCDCON2_GET_VFPD(mregs->lcdcon2) + 1;
+	fbinfo->var.vsync_len	    =3D
+				S3C2410_LCDCON2_GET_VSPW(mregs->lcdcon2) + 1;
+
+	fbinfo->var.left_margin	    =3D
+				S3C2410_LCDCON3_GET_HFPD(mregs->lcdcon3) + 1;
+	fbinfo->var.right_margin    =3D
+				S3C2410_LCDCON3_GET_HBPD(mregs->lcdcon3) + 1;
+	fbinfo->var.hsync_len	    =3D
+				S3C2410_LCDCON4_GET_HSPW(mregs->lcdcon4) + 1;
=20
 	fbinfo->var.red.offset      =3D 11;
 	fbinfo->var.green.offset    =3D 5;
@@ -875,7 +863,7 @@ static int __init s3c2410fb_probe(struct
 	fbinfo->var.green.length    =3D 6;
 	fbinfo->var.blue.length     =3D 5;
 	fbinfo->var.transp.length   =3D 0;
-	fbinfo->fix.smem_len        =3D	mach_info->xres.max *
+	fbinfo->fix.smem_len	    =3D	mach_info->xres.max *
 					mach_info->yres.max *
 					mach_info->bpp.max / 8;
=20
@@ -904,20 +892,21 @@ static int __init s3c2410fb_probe(struct
 	/* Initialize video memory */
 	ret =3D s3c2410fb_map_video_memory(info);
 	if (ret) {
-		printk( KERN_ERR "Failed to allocate video RAM: %d\n", ret);
+		printk(KERN_ERR "Failed to allocate video RAM: %d\n", ret);
 		ret =3D -ENOMEM;
 		goto release_clock;
 	}
=20
 	dprintk("got video memory\n");
=20
-	ret =3D s3c2410fb_init_registers(info);
+	s3c2410fb_init_registers(info);
=20
-	ret =3D s3c2410fb_check_var(&fbinfo->var, fbinfo);
+	s3c2410fb_check_var(&fbinfo->var, fbinfo);
=20
 	ret =3D register_framebuffer(fbinfo);
 	if (ret < 0) {
-		printk(KERN_ERR "Failed to register framebuffer device: %d\n", ret);
+		printk(KERN_ERR "Failed to register framebuffer device: %d\n",
+			ret);
 		goto free_video_memory;
 	}
=20
@@ -935,7 +924,7 @@ release_clock:
 	clk_disable(info->clk);
 	clk_put(info->clk);
 release_irq:
-	free_irq(irq,info);
+	free_irq(irq, info);
 release_regs:
 	iounmap(info->io);
 release_mem:
@@ -949,8 +938,7 @@ dealloc_fb:
 /* s3c2410fb_stop_lcd
  *
  * shutdown the lcd controller
-*/
-
+ */
 static void s3c2410fb_stop_lcd(struct s3c2410fb_info *fbi)
 {
 	unsigned long flags;
@@ -968,7 +956,7 @@ static void s3c2410fb_stop_lcd(struct s3
  */
 static int s3c2410fb_remove(struct platform_device *pdev)
 {
-	struct fb_info	   *fbinfo =3D platform_get_drvdata(pdev);
+	struct fb_info *fbinfo =3D platform_get_drvdata(pdev);
 	struct s3c2410fb_info *info =3D fbinfo->par;
 	int irq;
=20
@@ -977,14 +965,14 @@ static int s3c2410fb_remove(struct platf
=20
 	s3c2410fb_unmap_video_memory(info);
=20
- 	if (info->clk) {
- 		clk_disable(info->clk);
- 		clk_put(info->clk);
- 		info->clk =3D NULL;
+	if (info->clk) {
+		clk_disable(info->clk);
+		clk_put(info->clk);
+		info->clk =3D NULL;
 	}
=20
 	irq =3D platform_get_irq(pdev, 0);
-	free_irq(irq,info);
+	free_irq(irq, info);
=20
 	release_resource(info->mem);
 	kfree(info->mem);
@@ -997,7 +985,6 @@ static int s3c2410fb_remove(struct platf
 #ifdef CONFIG_PM
=20
 /* suspend and resume support for the lcd controller */
-
 static int s3c2410fb_suspend(struct platform_device *dev, pm_message_t=
 state)
 {
 	struct fb_info	   *fbinfo =3D platform_get_drvdata(dev);
@@ -1054,10 +1041,10 @@ static void __exit s3c2410fb_cleanup(voi
 	platform_driver_unregister(&s3c2410fb_driver);
 }
=20
-
 module_init(s3c2410fb_init);
 module_exit(s3c2410fb_cleanup);
=20
-MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>, Ben Dooks <b=
en-linux@fluff.org>");
+MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>, "
+	      "Ben Dooks <ben-linux@fluff.org>");
 MODULE_DESCRIPTION("Framebuffer driver for the s3c2410");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-alsa.patch
git-arm-master.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-f=
ix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
