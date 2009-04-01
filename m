From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-convert-printks-to-dev_foo.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:22 -0700
Message-ID: <200904011842.n31IgM9q009686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758977AbZDATfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:35:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@poczta.fm, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: convert printks to dev_foo
has been removed from the -mm tree.  Its filename was
     cirrusfb-convert-printks-to-dev_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: convert printks to dev_foo
From: Krzysztof Helt <krzysztof.h1@poczta.fm>

Convert all printks to dev_dbg, dev_info or dev_err.  Kill some excessive
debug information and code in the process.

[akpm@linux-foundation.org: printk fixes]
[akpm@linux-foundation.org: cleanups]
Signed-off-by: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |  455 ++++++++++++-------------------------
 1 file changed, 158 insertions(+), 297 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-convert-printks-to-dev_foo drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-convert-printks-to-dev_foo
+++ a/drivers/video/cirrusfb.c
@@ -34,8 +34,6 @@
  *
  */
 
-#define CIRRUSFB_VERSION "2.0-pre2"
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -72,20 +70,9 @@
  *
  */
 
-/* enable debug output? */
-/* #define CIRRUSFB_DEBUG 1 */
-
 /* disable runtime assertions? */
 /* #define CIRRUSFB_NDEBUG */
 
-/* debug output */
-#ifdef CIRRUSFB_DEBUG
-#define DPRINTK(fmt, args...) \
-	printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
-#else
-#define DPRINTK(fmt, args...)
-#endif
-
 /* debugging assertions */
 #ifndef CIRRUSFB_NDEBUG
 #define assert(expr) \
@@ -150,7 +137,7 @@ static const struct cirrusfb_board_info_
 		.maxclock		= {
 			/* guess */
 			/* the SD64/P4 have a higher max. videoclock */
-			140000, 140000, 140000, 140000, 140000,
+			135100, 135100, 85500, 85500, 0
 		},
 		.init_sr07		= true,
 		.init_sr1f		= true,
@@ -426,11 +413,10 @@ static void cirrusfb_RectFill(u8 __iomem
 static void bestclock(long freq, int *nom, int *den, int *div);
 
 #ifdef CIRRUSFB_DEBUG
-static void cirrusfb_dump(void);
-static void cirrusfb_dbg_reg_dump(caddr_t regbase);
-static void cirrusfb_dbg_print_regs(caddr_t regbase,
+static void cirrusfb_dbg_reg_dump(struct fb_info *info, caddr_t regbase);
+static void cirrusfb_dbg_print_regs(struct fb_info *info,
+				    caddr_t regbase,
 				    enum cirrusfb_dbg_reg_class reg_class, ...);
-static void cirrusfb_dbg_print_byte(const char *name, unsigned char val);
 #endif /* CIRRUSFB_DEBUG */
 
 /*** END   PROTOTYPES ********************************************************/
@@ -460,23 +446,24 @@ static int cirrusfb_release(struct fb_in
 /**** BEGIN Hardware specific Routines **************************************/
 
 /* Check if the MCLK is not a better clock source */
-static int cirrusfb_check_mclk(struct cirrusfb_info *cinfo, long freq)
+static int cirrusfb_check_mclk(struct fb_info *info, long freq)
 {
+	struct cirrusfb_info *cinfo = info->par;
 	long mclk = vga_rseq(cinfo->regbase, CL_SEQR1F) & 0x3f;
 
 	/* Read MCLK value */
 	mclk = (14318 * mclk) >> 3;
-	DPRINTK("Read MCLK of %ld kHz\n", mclk);
+	dev_dbg(info->device, "Read MCLK of %ld kHz\n", mclk);
 
 	/* Determine if we should use MCLK instead of VCLK, and if so, what we
 	 * should divide it by to get VCLK
 	 */
 
 	if (abs(freq - mclk) < 250) {
-		DPRINTK("Using VCLK = MCLK\n");
+		dev_dbg(info->device, "Using VCLK = MCLK\n");
 		return 1;
 	} else if (abs(freq - (mclk / 2)) < 250) {
-		DPRINTK("Using VCLK = MCLK/2\n");
+		dev_dbg(info->device, "Using VCLK = MCLK/2\n");
 		return 2;
 	}
 
@@ -492,56 +479,6 @@ static int cirrusfb_check_var(struct fb_
 
 	switch (var->bits_per_pixel) {
 	case 1:
-		pixels /= 4;
-		break;		/* 8 pixel per byte, only 1/4th of mem usable */
-	case 8:
-	case 16:
-	case 32:
-		break;		/* 1 pixel == 1 byte */
-	default:
-		printk(KERN_ERR "cirrusfb: mode %dx%dx%d rejected..."
-			"color depth not supported.\n",
-			var->xres, var->yres, var->bits_per_pixel);
-		DPRINTK("EXIT - EINVAL error\n");
-		return -EINVAL;
-	}
-
-	if (var->xres_virtual < var->xres)
-		var->xres_virtual = var->xres;
-	/* use highest possible virtual resolution */
-	if (var->yres_virtual == -1) {
-		var->yres_virtual = pixels / var->xres_virtual;
-
-		printk(KERN_INFO "cirrusfb: virtual resolution set to "
-			"maximum of %dx%d\n", var->xres_virtual,
-			var->yres_virtual);
-	}
-	if (var->yres_virtual < var->yres)
-		var->yres_virtual = var->yres;
-
-	if (var->xres_virtual * var->yres_virtual > pixels) {
-		printk(KERN_ERR "cirrusfb: mode %dx%dx%d rejected... "
-		      "virtual resolution too high to fit into video memory!\n",
-			var->xres_virtual, var->yres_virtual,
-			var->bits_per_pixel);
-		DPRINTK("EXIT - EINVAL error\n");
-		return -EINVAL;
-	}
-
-
-	if (var->xoffset < 0)
-		var->xoffset = 0;
-	if (var->yoffset < 0)
-		var->yoffset = 0;
-
-	/* truncate xoffset and yoffset to maximum if too high */
-	if (var->xoffset > var->xres_virtual - var->xres)
-		var->xoffset = var->xres_virtual - var->xres - 1;
-	if (var->yoffset > var->yres_virtual - var->yres)
-		var->yoffset = var->yres_virtual - var->yres - 1;
-
-	switch (var->bits_per_pixel) {
-	case 1:
 		var->red.offset = 0;
 		var->red.length = 1;
 		var->green = var->red;
@@ -586,12 +523,46 @@ static int cirrusfb_check_var(struct fb_
 		break;
 
 	default:
-		DPRINTK("Unsupported bpp size: %d\n", var->bits_per_pixel);
+		dev_dbg(info->device,
+			"Unsupported bpp size: %d\n", var->bits_per_pixel);
 		assert(false);
 		/* should never occur */
 		break;
 	}
 
+	if (var->xres_virtual < var->xres)
+		var->xres_virtual = var->xres;
+	/* use highest possible virtual resolution */
+	if (var->yres_virtual == -1) {
+		var->yres_virtual = pixels / var->xres_virtual;
+
+		dev_info(info->device,
+			 "virtual resolution set to maximum of %dx%d\n",
+			 var->xres_virtual, var->yres_virtual);
+	}
+	if (var->yres_virtual < var->yres)
+		var->yres_virtual = var->yres;
+
+	if (var->xres_virtual * var->yres_virtual > pixels) {
+		dev_err(info->device, "mode %dx%dx%d rejected... "
+		      "virtual resolution too high to fit into video memory!\n",
+			var->xres_virtual, var->yres_virtual,
+			var->bits_per_pixel);
+		return -EINVAL;
+	}
+
+
+	if (var->xoffset < 0)
+		var->xoffset = 0;
+	if (var->yoffset < 0)
+		var->yoffset = 0;
+
+	/* truncate xoffset and yoffset to maximum if too high */
+	if (var->xoffset > var->xres_virtual - var->xres)
+		var->xoffset = var->xres_virtual - var->xres - 1;
+	if (var->yoffset > var->yres_virtual - var->yres)
+		var->yoffset = var->yres_virtual - var->yres - 1;
+
 	var->red.msb_right =
 	    var->green.msb_right =
 	    var->blue.msb_right =
@@ -606,9 +577,8 @@ static int cirrusfb_check_var(struct fb_
 		yres = (yres + 1) / 2;
 
 	if (yres >= 1280) {
-		printk(KERN_ERR "cirrusfb: ERROR: VerticalTotal >= 1280; "
+		dev_err(info->device, "ERROR: VerticalTotal >= 1280; "
 			"special treatment required! (TODO)\n");
-		DPRINTK("EXIT - EINVAL error\n");
 		return -EINVAL;
 	}
 
@@ -642,7 +612,8 @@ static int cirrusfb_decode_var(const str
 		break;
 
 	default:
-		DPRINTK("Unsupported bpp size: %d\n", var->bits_per_pixel);
+		dev_dbg(info->device,
+			"Unsupported bpp size: %d\n", var->bits_per_pixel);
 		assert(false);
 		/* should never occur */
 		break;
@@ -653,7 +624,7 @@ static int cirrusfb_decode_var(const str
 	/* convert from ps to kHz */
 	freq = PICOS2KHZ(var->pixclock);
 
-	DPRINTK("desired pixclock: %ld kHz\n", freq);
+	dev_dbg(info->device, "desired pixclock: %ld kHz\n", freq);
 
 	maxclock = cirrusfb_board_info[cinfo->btype].maxclock[maxclockidx];
 	regs->multiplexing = 0;
@@ -668,9 +639,9 @@ static int cirrusfb_decode_var(const str
 			break;
 
 		default:
-			printk(KERN_ERR "cirrusfb: Frequency greater "
-				"than maxclock (%ld kHz)\n", maxclock);
-			DPRINTK("EXIT - return -EINVAL\n");
+			dev_err(info->device,
+				"Frequency greater than maxclock (%ld kHz)\n",
+				maxclock);
 			return -EINVAL;
 		}
 	}
@@ -689,16 +660,17 @@ static int cirrusfb_decode_var(const str
 	return 0;
 }
 
-static void cirrusfb_set_mclk_as_source(const struct cirrusfb_info *cinfo,
-					int div)
+static void cirrusfb_set_mclk_as_source(const struct fb_info *info, int div)
 {
+	struct cirrusfb_info *cinfo = info->par;
 	unsigned char old1f, old1e;
+
 	assert(cinfo != NULL);
 	old1f = vga_rseq(cinfo->regbase, CL_SEQR1F) & ~0x40;
 
 	if (div) {
-		DPRINTK("Set %s as pixclock source.\n",
-					(div == 2) ? "MCLK/2" : "MCLK");
+		dev_dbg(info->device, "Set %s as pixclock source.\n",
+			(div == 2) ? "MCLK/2" : "MCLK");
 		old1f |= 0x40;
 		old1e = vga_rseq(cinfo->regbase, CL_SEQR1E) & ~0x1;
 		if (div == 2)
@@ -728,17 +700,16 @@ static int cirrusfb_set_par_foo(struct f
 	long freq;
 	int nom, den, div;
 
-	DPRINTK("ENTER\n");
-	DPRINTK("Requested mode: %dx%dx%d\n",
+	dev_dbg(info->device, "Requested mode: %dx%dx%d\n",
 	       var->xres, var->yres, var->bits_per_pixel);
-	DPRINTK("pixclock: %d\n", var->pixclock);
+	dev_dbg(info->device, "pixclock: %d\n", var->pixclock);
 
 	init_vgachip(info);
 
 	err = cirrusfb_decode_var(var, &regs, info);
 	if (err) {
 		/* should never happen */
-		DPRINTK("mode change aborted.  invalid var.\n");
+		dev_dbg(info->device, "mode change aborted.  invalid var.\n");
 		return -EINVAL;
 	}
 
@@ -789,30 +760,30 @@ static int cirrusfb_set_par_foo(struct f
 	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, 0x20);	/* previously: 0x00) */
 
 	/* if debugging is enabled, all parameters get output before writing */
-	DPRINTK("CRT0: %d\n", htotal);
+	dev_dbg(info->device, "CRT0: %d\n", htotal);
 	vga_wcrt(regbase, VGA_CRTC_H_TOTAL, htotal);
 
-	DPRINTK("CRT1: %d\n", hdispend);
+	dev_dbg(info->device, "CRT1: %d\n", hdispend);
 	vga_wcrt(regbase, VGA_CRTC_H_DISP, hdispend);
 
-	DPRINTK("CRT2: %d\n", var->xres / 8);
+	dev_dbg(info->device, "CRT2: %d\n", var->xres / 8);
 	vga_wcrt(regbase, VGA_CRTC_H_BLANK_START, var->xres / 8);
 
 	/*  + 128: Compatible read */
-	DPRINTK("CRT3: 128+%d\n", (htotal + 5) % 32);
+	dev_dbg(info->device, "CRT3: 128+%d\n", (htotal + 5) % 32);
 	vga_wcrt(regbase, VGA_CRTC_H_BLANK_END,
 		 128 + ((htotal + 5) % 32));
 
-	DPRINTK("CRT4: %d\n", hsyncstart);
+	dev_dbg(info->device, "CRT4: %d\n", hsyncstart);
 	vga_wcrt(regbase, VGA_CRTC_H_SYNC_START, hsyncstart);
 
 	tmp = hsyncend % 32;
 	if ((htotal + 5) & 32)
 		tmp += 128;
-	DPRINTK("CRT5: %d\n", tmp);
+	dev_dbg(info->device, "CRT5: %d\n", tmp);
 	vga_wcrt(regbase, VGA_CRTC_H_SYNC_END, tmp);
 
-	DPRINTK("CRT6: %d\n", vtotal & 0xff);
+	dev_dbg(info->device, "CRT6: %d\n", vtotal & 0xff);
 	vga_wcrt(regbase, VGA_CRTC_V_TOTAL, vtotal & 0xff);
 
 	tmp = 16;		/* LineCompare bit #9 */
@@ -830,7 +801,7 @@ static int cirrusfb_set_par_foo(struct f
 		tmp |= 64;
 	if (vsyncstart & 512)
 		tmp |= 128;
-	DPRINTK("CRT7: %d\n", tmp);
+	dev_dbg(info->device, "CRT7: %d\n", tmp);
 	vga_wcrt(regbase, VGA_CRTC_OVERFLOW, tmp);
 
 	tmp = 0x40;		/* LineCompare bit #8 */
@@ -838,25 +809,25 @@ static int cirrusfb_set_par_foo(struct f
 		tmp |= 0x20;
 	if (var->vmode & FB_VMODE_DOUBLE)
 		tmp |= 0x80;
-	DPRINTK("CRT9: %d\n", tmp);
+	dev_dbg(info->device, "CRT9: %d\n", tmp);
 	vga_wcrt(regbase, VGA_CRTC_MAX_SCAN, tmp);
 
-	DPRINTK("CRT10: %d\n", vsyncstart & 0xff);
+	dev_dbg(info->device, "CRT10: %d\n", vsyncstart & 0xff);
 	vga_wcrt(regbase, VGA_CRTC_V_SYNC_START, vsyncstart & 0xff);
 
-	DPRINTK("CRT11: 64+32+%d\n", vsyncend % 16);
+	dev_dbg(info->device, "CRT11: 64+32+%d\n", vsyncend % 16);
 	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, vsyncend % 16 + 64 + 32);
 
-	DPRINTK("CRT12: %d\n", vdispend & 0xff);
+	dev_dbg(info->device, "CRT12: %d\n", vdispend & 0xff);
 	vga_wcrt(regbase, VGA_CRTC_V_DISP_END, vdispend & 0xff);
 
-	DPRINTK("CRT15: %d\n", (vdispend + 1) & 0xff);
+	dev_dbg(info->device, "CRT15: %d\n", (vdispend + 1) & 0xff);
 	vga_wcrt(regbase, VGA_CRTC_V_BLANK_START, (vdispend + 1) & 0xff);
 
-	DPRINTK("CRT16: %d\n", vtotal & 0xff);
+	dev_dbg(info->device, "CRT16: %d\n", vtotal & 0xff);
 	vga_wcrt(regbase, VGA_CRTC_V_BLANK_END, vtotal & 0xff);
 
-	DPRINTK("CRT18: 0xff\n");
+	dev_dbg(info->device, "CRT18: 0xff\n");
 	vga_wcrt(regbase, VGA_CRTC_LINE_COMPARE, 0xff);
 
 	tmp = 0;
@@ -871,12 +842,15 @@ static int cirrusfb_set_par_foo(struct f
 	if (vtotal & 512)
 		tmp |= 128;
 
-	DPRINTK("CRT1a: %d\n", tmp);
+	dev_dbg(info->device, "CRT1a: %d\n", tmp);
 	vga_wcrt(regbase, CL_CRT1A, tmp);
 
 	freq = PICOS2KHZ(var->pixclock);
 	bestclock(freq, &nom, &den, &div);
 
+	dev_dbg(info->device, "VCLK freq: %ld kHz  nom: %d  den: %d  div: %d\n",
+		freq, nom, den, div);
+
 	/* set VCLK0 */
 	/* hardware RefClock: 14.31818 MHz */
 	/* formula: VClk = (OSC * N) / (D * (1+P)) */
@@ -886,10 +860,10 @@ static int cirrusfb_set_par_foo(struct f
 		/* if freq is close to mclk or mclk/2 select mclk
 		 * as clock source
 		 */
-		int divMCLK = cirrusfb_check_mclk(cinfo, freq);
+		int divMCLK = cirrusfb_check_mclk(info, freq);
 		if (divMCLK)  {
 			nom = 0;
-			cirrusfb_set_mclk_as_source(cinfo, divMCLK);
+			cirrusfb_set_mclk_as_source(info, divMCLK);
 		}
 	}
 	if (nom) {
@@ -904,7 +878,7 @@ static int cirrusfb_set_par_foo(struct f
 		    (cinfo->btype == BT_GD5480))
 			tmp |= 0x80;
 
-		DPRINTK("CL_SEQR1B: %ld\n", (long) tmp);
+		dev_dbg(info->device, "CL_SEQR1B: %ld\n", (long) tmp);
 		vga_wseq(regbase, CL_SEQR1B, tmp);
 	}
 
@@ -952,7 +926,7 @@ static int cirrusfb_set_par_foo(struct f
 
 	/* programming for different color depths */
 	if (var->bits_per_pixel == 1) {
-		DPRINTK("cirrusfb: preparing for 1 bit deep display\n");
+		dev_dbg(info->device, "preparing for 1 bit deep display\n");
 		vga_wgfx(regbase, VGA_GFX_MODE, 0);	/* mode register */
 
 		/* SR07 */
@@ -964,20 +938,18 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_PICASSO4:
 		case BT_ALPINE:
 		case BT_GD5480:
-			DPRINTK(" (for GD54xx)\n");
 			vga_wseq(regbase, CL_SEQR7,
-				  regs.multiplexing ?
+				 regs.multiplexing ?
 					bi->sr07_1bpp_mux : bi->sr07_1bpp);
 			break;
 
 		case BT_LAGUNA:
-			DPRINTK(" (for GD546x)\n");
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) & ~0x01);
 			break;
 
 		default:
-			printk(KERN_WARNING "cirrusfb: unknown Board\n");
+			dev_warn(info->device, "unknown Board\n");
 			break;
 		}
 
@@ -987,14 +959,12 @@ static int cirrusfb_set_par_foo(struct f
 			/* setting the SEQRF on SD64 is not necessary
 			 * (only during init)
 			 */
-			DPRINTK("(for SD64)\n");
 			/*  MCLK select */
 			vga_wseq(regbase, CL_SEQR1F, 0x1a);
 			break;
 
 		case BT_PICCOLO:
 		case BT_SPECTRUM:
-			DPRINTK("(for Piccolo/Spectrum)\n");
 			/* ### ueberall 0x22? */
 			/* ##vorher 1c MCLK select */
 			vga_wseq(regbase, CL_SEQR1F, 0x22);
@@ -1003,7 +973,6 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_PICASSO:
-			DPRINTK("(for Picasso)\n");
 			/* ##vorher 22 MCLK select */
 			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			/* ## vorher d0 avoid FIFO underruns..? */
@@ -1014,12 +983,11 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_ALPINE:
 		case BT_GD5480:
 		case BT_LAGUNA:
-			DPRINTK(" (for GD54xx)\n");
 			/* do nothing */
 			break;
 
 		default:
-			printk(KERN_WARNING "cirrusfb: unknown Board\n");
+			dev_warn(info->device, "unknown Board\n");
 			break;
 		}
 
@@ -1045,7 +1013,7 @@ static int cirrusfb_set_par_foo(struct f
 	 */
 
 	else if (var->bits_per_pixel == 8) {
-		DPRINTK("cirrusfb: preparing for 8 bit deep display\n");
+		dev_dbg(info->device, "preparing for 8 bit deep display\n");
 		switch (cinfo->btype) {
 		case BT_SD64:
 		case BT_PICCOLO:
@@ -1054,20 +1022,18 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_PICASSO4:
 		case BT_ALPINE:
 		case BT_GD5480:
-			DPRINTK(" (for GD54xx)\n");
 			vga_wseq(regbase, CL_SEQR7,
 				  regs.multiplexing ?
 					bi->sr07_8bpp_mux : bi->sr07_8bpp);
 			break;
 
 		case BT_LAGUNA:
-			DPRINTK(" (for GD546x)\n");
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) | 0x01);
 			break;
 
 		default:
-			printk(KERN_WARNING "cirrusfb: unknown Board\n");
+			dev_warn(info->device, "unknown Board\n");
 			break;
 		}
 
@@ -1095,18 +1061,16 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_ALPINE:
-			DPRINTK(" (for GD543x)\n");
 			/* We already set SRF and SR1F */
 			break;
 
 		case BT_GD5480:
 		case BT_LAGUNA:
-			DPRINTK(" (for GD54xx)\n");
 			/* do nothing */
 			break;
 
 		default:
-			printk(KERN_WARNING "cirrusfb: unknown Board\n");
+			dev_warn(info->device, "unknown board\n");
 			break;
 		}
 
@@ -1134,7 +1098,7 @@ static int cirrusfb_set_par_foo(struct f
 	 */
 
 	else if (var->bits_per_pixel == 16) {
-		DPRINTK("cirrusfb: preparing for 16 bit deep display\n");
+		dev_dbg(info->device, "preparing for 16 bit deep display\n");
 		switch (cinfo->btype) {
 		case BT_SD64:
 			/* Extended Sequencer Mode: 256c col. mode */
@@ -1166,24 +1130,21 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_ALPINE:
-			DPRINTK(" (for GD543x)\n");
 			vga_wseq(regbase, CL_SEQR7, 0xa7);
 			break;
 
 		case BT_GD5480:
-			DPRINTK(" (for GD5480)\n");
 			vga_wseq(regbase, CL_SEQR7, 0x17);
 			/* We already set SRF and SR1F */
 			break;
 
 		case BT_LAGUNA:
-			DPRINTK(" (for GD546x)\n");
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) & ~0x01);
 			break;
 
 		default:
-			printk(KERN_WARNING "CIRRUSFB: unknown Board\n");
+			dev_warn(info->device, "unknown Board\n");
 			break;
 		}
 
@@ -1211,7 +1172,7 @@ static int cirrusfb_set_par_foo(struct f
 	 */
 
 	else if (var->bits_per_pixel == 32) {
-		DPRINTK("cirrusfb: preparing for 32 bit deep display\n");
+		dev_dbg(info->device, "preparing for 32 bit deep display\n");
 		switch (cinfo->btype) {
 		case BT_SD64:
 			/* Extended Sequencer Mode: 256c col. mode */
@@ -1243,24 +1204,21 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_ALPINE:
-			DPRINTK(" (for GD543x)\n");
 			vga_wseq(regbase, CL_SEQR7, 0xa9);
 			break;
 
 		case BT_GD5480:
-			DPRINTK(" (for GD5480)\n");
 			vga_wseq(regbase, CL_SEQR7, 0x19);
 			/* We already set SRF and SR1F */
 			break;
 
 		case BT_LAGUNA:
-			DPRINTK(" (for GD546x)\n");
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) & ~0x01);
 			break;
 
 		default:
-			printk(KERN_WARNING "cirrusfb: unknown Board\n");
+			dev_warn(info->device, "unknown Board\n");
 			break;
 		}
 
@@ -1284,8 +1242,8 @@ static int cirrusfb_set_par_foo(struct f
 	 */
 
 	else
-		printk(KERN_ERR "cirrusfb: What's this?? "
-			" requested color depth == %d.\n",
+		dev_err(info->device,
+			"What's this? requested color depth == %d.\n",
 			var->bits_per_pixel);
 
 	vga_wcrt(regbase, VGA_CRTC_OFFSET, offset & 0xff);
@@ -1355,7 +1313,7 @@ static int cirrusfb_set_par_foo(struct f
 */
 
 	vga_wseq(regbase, VGA_SEQ_CLOCK_MODE, tmp);
-	DPRINTK("CL_SEQR1: %d\n", tmp);
+	dev_dbg(info->device, "CL_SEQR1: %d\n", tmp);
 
 	cinfo->currentmode = regs;
 
@@ -1363,10 +1321,9 @@ static int cirrusfb_set_par_foo(struct f
 	cirrusfb_pan_display(var, info);
 
 #ifdef CIRRUSFB_DEBUG
-	cirrusfb_dump();
+	cirrusfb_dbg_reg_dump(info, NULL);
 #endif
 
-	DPRINTK("EXIT\n");
 	return 0;
 }
 
@@ -1424,8 +1381,8 @@ static int cirrusfb_pan_display(struct f
 	unsigned char tmp = 0, tmp2 = 0, xpix;
 	struct cirrusfb_info *cinfo = info->par;
 
-	DPRINTK("ENTER\n");
-	DPRINTK("virtual offset: (%d,%d)\n", var->xoffset, var->yoffset);
+	dev_dbg(info->device,
+		"virtual offset: (%d,%d)\n", var->xoffset, var->yoffset);
 
 	/* no range checks for xoffset and yoffset,   */
 	/* as fb_pan_display has already done this */
@@ -1481,7 +1438,6 @@ static int cirrusfb_pan_display(struct f
 
 	cirrusfb_WaitBLT(cinfo->regbase);
 
-	DPRINTK("EXIT\n");
 	return 0;
 }
 
@@ -1502,11 +1458,11 @@ static int cirrusfb_blank(int blank_mode
 	struct cirrusfb_info *cinfo = info->par;
 	int current_mode = cinfo->blank_mode;
 
-	DPRINTK("ENTER, blank mode = %d\n", blank_mode);
+	dev_dbg(info->device, "ENTER, blank mode = %d\n", blank_mode);
 
 	if (info->state != FBINFO_STATE_RUNNING ||
 	    current_mode == blank_mode) {
-		DPRINTK("EXIT, returning 0\n");
+		dev_dbg(info->device, "EXIT, returning 0\n");
 		return 0;
 	}
 
@@ -1543,12 +1499,12 @@ static int cirrusfb_blank(int blank_mode
 		vga_wgfx(cinfo->regbase, CL_GRE, 0x06);
 		break;
 	default:
-		DPRINTK("EXIT, returning 1\n");
+		dev_dbg(info->device, "EXIT, returning 1\n");
 		return 1;
 	}
 
 	cinfo->blank_mode = blank_mode;
-	DPRINTK("EXIT, returning 0\n");
+	dev_dbg(info->device, "EXIT, returning 0\n");
 
 	/* Let fbcon do a soft blank for us */
 	return (blank_mode == FB_BLANK_NORMAL) ? 1 : 0;
@@ -1562,8 +1518,6 @@ static void init_vgachip(struct fb_info 
 	struct cirrusfb_info *cinfo = info->par;
 	const struct cirrusfb_board_info_rec *bi;
 
-	DPRINTK("ENTER\n");
-
 	assert(cinfo != NULL);
 
 	bi = &cirrusfb_board_info[cinfo->btype];
@@ -1609,7 +1563,7 @@ static void init_vgachip(struct fb_info 
 		break;
 
 	default:
-		printk(KERN_ERR "cirrusfb: Warning: Unknown board type\n");
+		dev_err(info->device, "Warning: Unknown board type\n");
 		break;
 	}
 
@@ -1798,8 +1752,6 @@ static void init_vgachip(struct fb_info 
 
 	/* misc... */
 	WHDR(cinfo, 0);	/* Hidden DAC register: - */
-
-	DPRINTK("EXIT\n");
 	return;
 }
 
@@ -1808,8 +1760,6 @@ static void switch_monitor(struct cirrus
 #ifdef CONFIG_ZORRO /* only works on Zorro boards */
 	static int IsOn = 0;	/* XXX not ok for multiple boards */
 
-	DPRINTK("ENTER\n");
-
 	if (cinfo->btype == BT_PICASSO4)
 		return;		/* nothing to switch */
 	if (cinfo->btype == BT_ALPINE)
@@ -1819,8 +1769,6 @@ static void switch_monitor(struct cirrus
 	if (cinfo->btype == BT_PICASSO) {
 		if ((on && !IsOn) || (!on && IsOn))
 			WSFR(cinfo, 0xff);
-
-		DPRINTK("EXIT\n");
 		return;
 	}
 	if (on) {
@@ -1847,11 +1795,10 @@ static void switch_monitor(struct cirrus
 		case BT_SPECTRUM:
 			WSFR(cinfo, 0x4f);
 			break;
-		default: /* do nothing */ break;
+		default: /* do nothing */
+			break;
 		}
 	}
-
-	DPRINTK("EXIT\n");
 #endif /* CONFIG_ZORRO */
 }
 
@@ -1953,12 +1900,8 @@ static void cirrusfb_imageblit(struct fb
 #define PREP_IO_BASE    ((volatile unsigned char *) 0x80000000)
 static void get_prep_addrs(unsigned long *display, unsigned long *registers)
 {
-	DPRINTK("ENTER\n");
-
 	*display = PREP_VIDEO_BASE;
 	*registers = (unsigned long) PREP_IO_BASE;
-
-	DPRINTK("EXIT\n");
 }
 
 #endif				/* CONFIG_PPC_PREP */
@@ -1970,13 +1913,12 @@ static int release_io_ports;
  * based on the DRAM bandwidth bit and DRAM bank switching bit.  This
  * works with 1MB, 2MB and 4MB configurations (which the Motorola boards
  * seem to have. */
-static unsigned int __devinit cirrusfb_get_memsize(u8 __iomem *regbase)
+static unsigned int __devinit cirrusfb_get_memsize(struct fb_info *info,
+						   u8 __iomem *regbase)
 {
 	unsigned long mem;
 	unsigned char SRF;
 
-	DPRINTK("ENTER\n");
-
 	SRF = vga_rseq(regbase, CL_SEQRF);
 	switch ((SRF & 0x18)) {
 	case 0x08:
@@ -1992,7 +1934,7 @@ static unsigned int __devinit cirrusfb_g
 		mem = 2048 * 1024;
 		break;
 	default:
-		printk(KERN_WARNING "CLgenfb: Unknown memory size!\n");
+		dev_warn(info->device, "CLgenfb: Unknown memory size!\n");
 		mem = 1024 * 1024;
 	}
 	if (SRF & 0x80)
@@ -2002,8 +1944,6 @@ static unsigned int __devinit cirrusfb_g
 		mem *= 2;
 
 	/* TODO: Handling of GD5446/5480 (see XF86 sources ...) */
-
-	DPRINTK("EXIT\n");
 	return mem;
 }
 
@@ -2014,8 +1954,6 @@ static void get_pci_addrs(const struct p
 	assert(display != NULL);
 	assert(registers != NULL);
 
-	DPRINTK("ENTER\n");
-
 	*display = 0;
 	*registers = 0;
 
@@ -2030,8 +1968,6 @@ static void get_pci_addrs(const struct p
 	}
 
 	assert(*display != 0);
-
-	DPRINTK("EXIT\n");
 }
 
 static void cirrusfb_pci_unmap(struct fb_info *info)
@@ -2117,11 +2053,6 @@ static int __devinit cirrusfb_register(s
 	int err;
 	enum cirrus_board btype;
 
-	DPRINTK("ENTER\n");
-
-	printk(KERN_INFO "cirrusfb: Driver for Cirrus Logic based "
-		"graphic boards, v" CIRRUSFB_VERSION "\n");
-
 	btype = cinfo->btype;
 
 	/* sanity checks */
@@ -2130,11 +2061,11 @@ static int __devinit cirrusfb_register(s
 	/* set all the vital stuff */
 	cirrusfb_set_fbinfo(info);
 
-	DPRINTK("cirrusfb: (RAM start set to: 0x%p)\n", info->screen_base);
+	dev_dbg(info->device, "(RAM start set to: 0x%p)\n", info->screen_base);
 
 	err = fb_find_mode(&info->var, info, mode_option, NULL, 0, NULL, 8);
 	if (!err) {
-		DPRINTK("wrong initial video mode\n");
+		dev_dbg(info->device, "wrong initial video mode\n");
 		err = -EINVAL;
 		goto err_dealloc_cmap;
 	}
@@ -2144,18 +2075,18 @@ static int __devinit cirrusfb_register(s
 	err = cirrusfb_decode_var(&info->var, &cinfo->currentmode, info);
 	if (err < 0) {
 		/* should never happen */
-		DPRINTK("choking on default var... umm, no good.\n");
+		dev_dbg(info->device,
+			"choking on default var... umm, no good.\n");
 		goto err_dealloc_cmap;
 	}
 
 	err = register_framebuffer(info);
 	if (err < 0) {
-		printk(KERN_ERR "cirrusfb: could not register "
-			"fb device; err = %d!\n", err);
+		dev_err(info->device,
+			"could not register fb device; err = %d!\n", err);
 		goto err_dealloc_cmap;
 	}
 
-	DPRINTK("EXIT, returning 0\n");
 	return 0;
 
 err_dealloc_cmap:
@@ -2168,17 +2099,13 @@ err_dealloc_cmap:
 static void __devexit cirrusfb_cleanup(struct fb_info *info)
 {
 	struct cirrusfb_info *cinfo = info->par;
-	DPRINTK("ENTER\n");
 
 	switch_monitor(cinfo, 0);
-
 	unregister_framebuffer(info);
 	fb_dealloc_cmap(&info->cmap);
-	printk("Framebuffer unregistered\n");
+	dev_dbg(info->device, "Framebuffer unregistered\n");
 	cinfo->unmap(info);
 	framebuffer_release(info);
-
-	DPRINTK("EXIT\n");
 }
 
 #ifdef CONFIG_PCI
@@ -2207,9 +2134,11 @@ static int __devinit cirrusfb_pci_regist
 	cinfo = info->par;
 	cinfo->btype = btype = (enum cirrus_board) ent->driver_data;
 
-	DPRINTK(" Found PCI device, base address 0 is 0x%x, btype set to %d\n",
-		pdev->resource[0].start, btype);
-	DPRINTK(" base address 1 is 0x%x\n", pdev->resource[1].start);
+	dev_dbg(info->device,
+		" Found PCI device, base address 0 is 0x%Lx, btype set to %d\n",
+		(unsigned long long)pdev->resource[0].start, btype);
+	dev_dbg(info->device, " base address 1 is 0x%Lx\n",
+		(unsigned long long)pdev->resource[1].start);
 
 	if (isPReP) {
 		pci_write_config_dword(pdev, PCI_BASE_ADDRESS_0, 0x00000000);
@@ -2219,30 +2148,29 @@ static int __devinit cirrusfb_pci_regist
 	/* PReP dies if we ioremap the IO registers, but it works w/out... */
 		cinfo->regbase = (char __iomem *) info->fix.mmio_start;
 	} else {
-		DPRINTK("Attempt to get PCI info for Cirrus Graphics Card\n");
+		dev_dbg(info->device,
+			"Attempt to get PCI info for Cirrus Graphics Card\n");
 		get_pci_addrs(pdev, &board_addr, &info->fix.mmio_start);
 		/* FIXME: this forces VGA.  alternatives? */
 		cinfo->regbase = NULL;
 	}
 
-	DPRINTK("Board address: 0x%lx, register address: 0x%lx\n",
+	dev_dbg(info->device, "Board address: 0x%lx, register address: 0x%lx\n",
 		board_addr, info->fix.mmio_start);
 
 	board_size = (btype == BT_GD5480) ?
-		32 * MB_ : cirrusfb_get_memsize(cinfo->regbase);
+		32 * MB_ : cirrusfb_get_memsize(info, cinfo->regbase);
 
 	ret = pci_request_regions(pdev, "cirrusfb");
 	if (ret < 0) {
-		printk(KERN_ERR "cirrusfb: cannot reserve region 0x%lx, "
-		       "abort\n",
-		       board_addr);
+		dev_err(info->device, "cannot reserve region 0x%lx, abort\n",
+			board_addr);
 		goto err_release_fb;
 	}
 #if 0 /* if the system didn't claim this region, we would... */
 	if (!request_mem_region(0xA0000, 65535, "cirrusfb")) {
-		printk(KERN_ERR "cirrusfb: cannot reserve region 0x%lx, abort\n"
-,
-		       0xA0000L);
+		dev_err(info->device, "cannot reserve region 0x%lx, abort\n",
+			0xA0000L);
 		ret = -EBUSY;
 		goto err_release_regions;
 	}
@@ -2260,9 +2188,9 @@ static int __devinit cirrusfb_pci_regist
 	info->screen_size = board_size;
 	cinfo->unmap = cirrusfb_pci_unmap;
 
-	printk(KERN_INFO "RAM (%lu kB) at 0x%lx, Cirrus "
-			"Logic chipset on PCI bus\n",
-			info->screen_size >> 10, board_addr);
+	dev_info(info->device,
+		 "Cirrus Logic chipset on PCI bus, RAM (%lu kB) at 0x%lx\n",
+		 info->screen_size >> 10, board_addr);
 	pci_set_drvdata(pdev, info);
 
 	ret = cirrusfb_register(info);
@@ -2288,11 +2216,8 @@ err_out:
 static void __devexit cirrusfb_pci_unregister(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
-	DPRINTK("ENTER\n");
 
 	cirrusfb_cleanup(info);
-
-	DPRINTK("EXIT\n");
 }
 
 static struct pci_driver cirrusfb_pci_driver = {
@@ -2324,8 +2249,6 @@ static int __devinit cirrusfb_zorro_regi
 	if (cirrusfb_zorro_table2[btype].id2)
 		z2 = zorro_find_device(cirrusfb_zorro_table2[btype].id2, NULL);
 	size = cirrusfb_zorro_table2[btype].size;
-	printk(KERN_INFO "cirrusfb: %s board detected; ",
-	       cirrusfb_board_info[btype].name);
 
 	info = framebuffer_alloc(sizeof(struct cirrusfb_info), &z->dev);
 	if (!info) {
@@ -2334,6 +2257,9 @@ static int __devinit cirrusfb_zorro_regi
 		goto err_out;
 	}
 
+	dev_info(info->device, "%s board detected\n",
+		 cirrusfb_board_info[btype].name);
+
 	cinfo = info->par;
 	cinfo->btype = btype;
 
@@ -2345,19 +2271,16 @@ static int __devinit cirrusfb_zorro_regi
 	info->screen_size = size;
 
 	if (!zorro_request_device(z, "cirrusfb")) {
-		printk(KERN_ERR "cirrusfb: cannot reserve region 0x%lx, "
-		       "abort\n",
-		       board_addr);
+		dev_err(info->device, "cannot reserve region 0x%lx, abort\n",
+			board_addr);
 		ret = -EBUSY;
 		goto err_release_fb;
 	}
 
-	printk(" RAM (%lu MB) at $%lx, ", board_size / MB_, board_addr);
-
 	ret = -EIO;
 
 	if (btype == BT_PICASSO4) {
-		printk(KERN_INFO " REG at $%lx\n", board_addr + 0x600000);
+		dev_info(info->device, " REG at $%lx\n", board_addr + 0x600000);
 
 		/* To be precise, for the P4 this is not the */
 		/* begin of the board, but the begin of RAM. */
@@ -2367,7 +2290,7 @@ static int __devinit cirrusfb_zorro_regi
 		if (!cinfo->regbase)
 			goto err_release_region;
 
-		DPRINTK("cirrusfb: Virtual address for board set to: $%p\n",
+		dev_dbg(info->device, "Virtual address for board set to: $%p\n",
 			cinfo->regbase);
 		cinfo->regbase += 0x600000;
 		info->fix.mmio_start = board_addr + 0x600000;
@@ -2377,8 +2300,8 @@ static int __devinit cirrusfb_zorro_regi
 		if (!info->screen_base)
 			goto err_unmap_regbase;
 	} else {
-		printk(KERN_INFO " REG at $%lx\n",
-			(unsigned long) z2->resource.start);
+		dev_info(info->device, " REG at $%lx\n",
+			 (unsigned long) z2->resource.start);
 
 		info->fix.smem_start = board_addr;
 		if (board_addr > 0x01000000)
@@ -2392,12 +2315,15 @@ static int __devinit cirrusfb_zorro_regi
 		cinfo->regbase = (caddr_t) ZTWO_VADDR(z2->resource.start);
 		info->fix.mmio_start = z2->resource.start;
 
-		DPRINTK("cirrusfb: Virtual address for board set to: $%p\n",
+		dev_dbg(info->device, "Virtual address for board set to: $%p\n",
 			cinfo->regbase);
 	}
 	cinfo->unmap = cirrusfb_zorro_unmap;
 
-	printk(KERN_INFO "Cirrus Logic chipset on Zorro bus\n");
+	dev_info(info->device,
+		 "Cirrus Logic chipset on Zorro bus, RAM (%lu MB) at $%lx\n",
+		 board_size / MB_, board_addr);
+
 	zorro_set_drvdata(z, info);
 
 	ret = cirrusfb_register(info);
@@ -2424,11 +2350,8 @@ err_out:
 void __devexit cirrusfb_zorro_unregister(struct zorro_dev *z)
 {
 	struct fb_info *info = zorro_get_drvdata(z);
-	DPRINTK("ENTER\n");
 
 	cirrusfb_cleanup(info);
-
-	DPRINTK("EXIT\n");
 }
 
 static struct zorro_driver cirrusfb_zorro_driver = {
@@ -2461,11 +2384,10 @@ static int __init cirrusfb_init(void)
 }
 
 #ifndef MODULE
-static int __init cirrusfb_setup(char *options) {
+static int __init cirrusfb_setup(char *options)
+{
 	char *this_opt;
 
-	DPRINTK("ENTER\n");
-
 	if (!options || !*options)
 		return 0;
 
@@ -2473,8 +2395,6 @@ static int __init cirrusfb_setup(char *o
 		if (!*this_opt)
 			continue;
 
-		DPRINTK("cirrusfb_setup: option '%s'\n", this_opt);
-
 		if (!strcmp(this_opt, "noaccel"))
 			noaccel = 1;
 		else if (!strncmp(this_opt, "mode:", 5))
@@ -2560,8 +2480,6 @@ static void AttrOn(const struct cirrusfb
 {
 	assert(cinfo != NULL);
 
-	DPRINTK("ENTER\n");
-
 	if (vga_rcrt(cinfo->regbase, CL_CRT24) & 0x80) {
 		/* if we're just in "write value" mode, write back the */
 		/* same value as before to not modify anything */
@@ -2574,8 +2492,6 @@ static void AttrOn(const struct cirrusfb
 
 	/* dummy write on Reg0 to be on "write index" mode next time */
 	vga_w(cinfo->regbase, VGA_ATT_IW, 0x00);
-
-	DPRINTK("EXIT\n");
 }
 
 /*** WHDR() - write into the Hidden DAC register ***/
@@ -2723,8 +2639,6 @@ static void cirrusfb_BitBLT(u8 __iomem *
 	u_long nsrc, ndest;
 	u_char bltmode;
 
-	DPRINTK("ENTER\n");
-
 	nwidth = width - 1;
 	nheight = height - 1;
 
@@ -2813,8 +2727,6 @@ static void cirrusfb_BitBLT(u8 __iomem *
 
 	/* and finally: GO! */
 	vga_wgfx(regbase, CL_GR31, 0x02);	/* BLT Start/status */
-
-	DPRINTK("EXIT\n");
 }
 
 /*******************************************************************
@@ -2831,8 +2743,6 @@ static void cirrusfb_RectFill(u8 __iomem
 	u_long ndest;
 	u_char op;
 
-	DPRINTK("ENTER\n");
-
 	nwidth = width - 1;
 	nheight = height - 1;
 
@@ -2896,8 +2806,6 @@ static void cirrusfb_RectFill(u8 __iomem
 
 	/* and finally: GO! */
 	vga_wgfx(regbase, CL_GR31, 0x02);	/* BLT Start/status */
-
-	DPRINTK("EXIT\n");
 }
 
 /**************************************************************************
@@ -2917,8 +2825,6 @@ static void bestclock(long freq, int *no
 	*den = 0;
 	*div = 0;
 
-	DPRINTK("ENTER\n");
-
 	if (freq < 8000)
 		freq = 8000;
 
@@ -2960,12 +2866,6 @@ static void bestclock(long freq, int *no
 			}
 		}
 	}
-
-	DPRINTK("Best possible values for given frequency:\n");
-	DPRINTK("	freq: %ld kHz  nom: %d  den: %d  div: %d\n",
-		freq, *nom, *den, *div);
-
-	DPRINTK("EXIT\n");
 }
 
 /* -------------------------------------------------------------------------
@@ -2978,32 +2878,6 @@ static void bestclock(long freq, int *no
 #ifdef CIRRUSFB_DEBUG
 
 /**
- * cirrusfb_dbg_print_byte
- * @name: name associated with byte value to be displayed
- * @val: byte value to be displayed
- *
- * DESCRIPTION:
- * Display an indented string, along with a hexidecimal byte value, and
- * its decoded bits.  Bits 7 through 0 are listed in left-to-right
- * order.
- */
-
-static
-void cirrusfb_dbg_print_byte(const char *name, unsigned char val)
-{
-	DPRINTK("%8s = 0x%02X (bits 7-0: %c%c%c%c%c%c%c%c)\n",
-		name, val,
-		val & 0x80 ? '1' : '0',
-		val & 0x40 ? '1' : '0',
-		val & 0x20 ? '1' : '0',
-		val & 0x10 ? '1' : '0',
-		val & 0x08 ? '1' : '0',
-		val & 0x04 ? '1' : '0',
-		val & 0x02 ? '1' : '0',
-		val & 0x01 ? '1' : '0');
-}
-
-/**
  * cirrusfb_dbg_print_regs
  * @base: If using newmmio, the newmmio base address, otherwise %NULL
  * @reg_class: type of registers to read: %CRT, or %SEQ
@@ -3014,9 +2888,9 @@ void cirrusfb_dbg_print_byte(const char 
  * used at the given @base address to query the information.
  */
 
-static
-void cirrusfb_dbg_print_regs(caddr_t regbase,
-			     enum cirrusfb_dbg_reg_class reg_class, ...)
+static void cirrusfb_dbg_print_regs(struct fb_info *info,
+				    caddr_t regbase,
+				    enum cirrusfb_dbg_reg_class reg_class, ...)
 {
 	va_list list;
 	unsigned char val = 0;
@@ -3042,7 +2916,7 @@ void cirrusfb_dbg_print_regs(caddr_t reg
 			break;
 		}
 
-		cirrusfb_dbg_print_byte(name, val);
+		dev_dbg(info->device, "%8s = 0x%02X\n", name, val);
 
 		name = va_arg(list, char *);
 	}
@@ -3051,18 +2925,6 @@ void cirrusfb_dbg_print_regs(caddr_t reg
 }
 
 /**
- * cirrusfb_dump
- * @cirrusfbinfo:
- *
- * DESCRIPTION:
- */
-
-static void cirrusfb_dump(void)
-{
-	cirrusfb_dbg_reg_dump(NULL);
-}
-
-/**
  * cirrusfb_dbg_reg_dump
  * @base: If using newmmio, the newmmio base address, otherwise %NULL
  *
@@ -3072,12 +2934,11 @@ static void cirrusfb_dump(void)
  * used at the given @base address to query the information.
  */
 
-static
-void cirrusfb_dbg_reg_dump(caddr_t regbase)
+static void cirrusfb_dbg_reg_dump(struct fb_info *info, caddr_t regbase)
 {
-	DPRINTK("CIRRUSFB VGA CRTC register dump:\n");
+	dev_dbg(info->device, "VGA CRTC register dump:\n");
 
-	cirrusfb_dbg_print_regs(regbase, CRT,
+	cirrusfb_dbg_print_regs(info, regbase, CRT,
 			   "CR00", 0x00,
 			   "CR01", 0x01,
 			   "CR02", 0x02,
@@ -3127,11 +2988,11 @@ void cirrusfb_dbg_reg_dump(caddr_t regba
 			   "CR3F", 0x3F,
 			   NULL);
 
-	DPRINTK("\n");
+	dev_dbg(info->device, "\n");
 
-	DPRINTK("CIRRUSFB VGA SEQ register dump:\n");
+	dev_dbg(info->device, "VGA SEQ register dump:\n");
 
-	cirrusfb_dbg_print_regs(regbase, SEQ,
+	cirrusfb_dbg_print_regs(info, regbase, SEQ,
 			   "SR00", 0x00,
 			   "SR01", 0x01,
 			   "SR02", 0x02,
@@ -3160,7 +3021,7 @@ void cirrusfb_dbg_reg_dump(caddr_t regba
 			   "SR1F", 0x1F,
 			   NULL);
 
-	DPRINTK("\n");
+	dev_dbg(info->device, "\n");
 }
 
 #endif				/* CIRRUSFB_DEBUG */
_

Patches currently in -mm which might be from krzysztof.h1@poczta.fm are

origin.patch
intelfb-support-i854.patch

