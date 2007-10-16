From: akpm@linux-foundation.org
Subject: - s3c2410fb-use-new-margin-fields.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:13 -0700
Message-ID: <200710162043.l9GKhDSN016024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964910AbXJPVPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:15:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: use new margin fields
has been removed from the -mm tree.  Its filename was
     s3c2410fb-use-new-margin-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3c2410fb: use new margin fields
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch makes use of margins fields in the s3c2410fb_display
structure.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |  234 ++++++++++++++++++++----------------
 1 file changed, 136 insertions(+), 98 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-use-new-margin-fields drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-use-new-margin-fields
+++ a/drivers/video/s3c2410fb.c
@@ -197,6 +197,14 @@ static int s3c2410fb_check_var(struct fb
 		return -EINVAL;
 	}
 
+	/* it is always the size as the display */
+	var->xres_virtual = display->xres;
+	var->yres_virtual = display->yres;
+
+	/* copy lcd settings */
+	var->left_margin = display->left_margin;
+	var->right_margin = display->right_margin;
+
 	var->transp.offset = 0;
 	var->transp.length = 0;
 	/* set r/g/b positions */
@@ -270,125 +278,152 @@ static int s3c2410fb_check_var(struct fb
 	return 0;
 }
 
+/* s3c2410fb_calculate_stn_lcd_regs
+ *
+ * calculate register values from var settings
+ */
+static void s3c2410fb_calculate_stn_lcd_regs(const struct fb_info *info,
+					     struct s3c2410fb_hw *regs)
+{
+	const struct s3c2410fb_info *fbi = info->par;
+	const struct fb_var_screeninfo *var = &info->var;
+	int type = regs->lcdcon1 & ~S3C2410_LCDCON1_TFT;
+	int hs = var->xres >> 2;
+	unsigned wdly = (var->left_margin >> 4) - 1;
+
+	dprintk("%s: var->xres  = %d\n", __FUNCTION__, var->xres);
+	dprintk("%s: var->yres  = %d\n", __FUNCTION__, var->yres);
+	dprintk("%s: var->bpp   = %d\n", __FUNCTION__, var->bits_per_pixel);
+
+	if (type != S3C2410_LCDCON1_STN4)
+		hs >>= 1;
+
+	regs->lcdcon1 &= ~S3C2410_LCDCON1_MODEMASK;
+
+	switch (var->bits_per_pixel) {
+	case 1:
+		regs->lcdcon1 |= S3C2410_LCDCON1_STN1BPP;
+		break;
+	case 2:
+		regs->lcdcon1 |= S3C2410_LCDCON1_STN2GREY;
+		break;
+	case 4:
+		regs->lcdcon1 |= S3C2410_LCDCON1_STN4GREY;
+		break;
+	case 8:
+		regs->lcdcon1 |= S3C2410_LCDCON1_STN8BPP;
+		hs *= 3;
+		break;
+	case 12:
+		regs->lcdcon1 |= S3C2410_LCDCON1_STN12BPP;
+		hs *= 3;
+		break;
+
+	default:
+		/* invalid pixel depth */
+		dev_err(fbi->dev, "invalid bpp %d\n",
+			var->bits_per_pixel);
+	}
+	/* update X/Y info */
+	dprintk("setting vert: up=%d, low=%d, sync=%d\n",
+		var->upper_margin, var->lower_margin, var->vsync_len);
+
+	dprintk("setting horz: lft=%d, rt=%d, sync=%d\n",
+		var->left_margin, var->right_margin, var->hsync_len);
+
+	regs->lcdcon2 &= ~S3C2410_LCDCON2_LINEVAL(0x3ff);
+	regs->lcdcon2 |=  S3C2410_LCDCON2_LINEVAL(var->yres - 1);
+
+	if (wdly > 3)
+		wdly = 3;
+
+	regs->lcdcon3 =	S3C2410_LCDCON3_WDLY(wdly) |
+			S3C2410_LCDCON3_LINEBLANK(var->right_margin / 8) |
+			S3C2410_LCDCON3_HOZVAL(hs - 1);
+}
+
+/* s3c2410fb_calculate_tft_lcd_regs
+ *
+ * calculate register values from var settings
+ */
+static void s3c2410fb_calculate_tft_lcd_regs(const struct fb_info *info,
+					     struct s3c2410fb_hw *regs)
+{
+	const struct s3c2410fb_info *fbi = info->par;
+	const struct fb_var_screeninfo *var = &info->var;
+
+	dprintk("%s: var->xres  = %d\n", __FUNCTION__, var->xres);
+	dprintk("%s: var->yres  = %d\n", __FUNCTION__, var->yres);
+	dprintk("%s: var->bpp   = %d\n", __FUNCTION__, var->bits_per_pixel);
+
+	regs->lcdcon1 &= ~S3C2410_LCDCON1_MODEMASK;
+
+	switch (var->bits_per_pixel) {
+	case 1:
+		regs->lcdcon1 |= S3C2410_LCDCON1_TFT1BPP;
+		break;
+	case 2:
+		regs->lcdcon1 |= S3C2410_LCDCON1_TFT2BPP;
+		break;
+	case 4:
+		regs->lcdcon1 |= S3C2410_LCDCON1_TFT4BPP;
+		break;
+	case 8:
+		regs->lcdcon1 |= S3C2410_LCDCON1_TFT8BPP;
+		break;
+	case 16:
+		regs->lcdcon1 |= S3C2410_LCDCON1_TFT16BPP;
+		break;
+
+	default:
+		/* invalid pixel depth */
+		dev_err(fbi->dev, "invalid bpp %d\n",
+			var->bits_per_pixel);
+	}
+	/* update X/Y info */
+	dprintk("setting vert: up=%d, low=%d, sync=%d\n",
+		var->upper_margin, var->lower_margin, var->vsync_len);
+
+	dprintk("setting horz: lft=%d, rt=%d, sync=%d\n",
+		var->left_margin, var->right_margin, var->hsync_len);
+
+	regs->lcdcon2 &= ~S3C2410_LCDCON2_LINEVAL(0x3ff);
+	regs->lcdcon2 |=  S3C2410_LCDCON2_LINEVAL(var->yres - 1);
+
+	regs->lcdcon3 = S3C2410_LCDCON3_HBPD(var->right_margin - 1) |
+			S3C2410_LCDCON3_HFPD(var->left_margin - 1) |
+			S3C2410_LCDCON3_HOZVAL(var->xres - 1);
+}
+
 /* s3c2410fb_activate_var
  *
  * activate (set) the controller from the given framebuffer
  * information
  */
-static void s3c2410fb_activate_var(struct fb_info *info,
-				   struct fb_var_screeninfo *var)
+static void s3c2410fb_activate_var(struct fb_info *info)
 {
 	struct s3c2410fb_info *fbi = info->par;
+	struct fb_var_screeninfo *var = &info->var;
 	struct s3c2410fb_mach_info *mach_info = fbi->mach_info;
 	struct s3c2410fb_display *display = mach_info->displays +
 					    fbi->current_display;
-	int hs;
 
-	fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_MODEMASK;
+	/* set display type */
 	fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_TFT;
-
-	dprintk("%s: var->xres  = %d\n", __FUNCTION__, var->xres);
-	dprintk("%s: var->yres  = %d\n", __FUNCTION__, var->yres);
-	dprintk("%s: var->bpp   = %d\n", __FUNCTION__, var->bits_per_pixel);
-
 	fbi->regs.lcdcon1 |= display->type;
 
-	if (display->type == S3C2410_LCDCON1_TFT)
-		switch (var->bits_per_pixel) {
-		case 1:
-			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_TFT1BPP;
-			break;
-		case 2:
-			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_TFT2BPP;
-			break;
-		case 4:
-			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_TFT4BPP;
-			break;
-		case 8:
-			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_TFT8BPP;
-			break;
-		case 16:
-			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_TFT16BPP;
-			break;
-
-		default:
-			/* invalid pixel depth */
-			dev_err(fbi->dev, "invalid bpp %d\n",
-				var->bits_per_pixel);
-		}
-	else
-		switch (var->bits_per_pixel) {
-		case 1:
-			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_STN1BPP;
-			break;
-		case 2:
-			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_STN2GREY;
-			break;
-		case 4:
-			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_STN4GREY;
-			break;
-		case 8:
-			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_STN8BPP;
-			break;
-		case 12:
-			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_STN12BPP;
-			break;
-
-		default:
-			/* invalid pixel depth */
-			dev_err(fbi->dev, "invalid bpp %d\n",
-				var->bits_per_pixel);
-		}
-
 	/* check to see if we need to update sync/borders */
 
 	if (!mach_info->fixed_syncs) {
-		dprintk("setting vert: up=%d, low=%d, sync=%d\n",
-			var->upper_margin, var->lower_margin, var->vsync_len);
-
-		dprintk("setting horz: lft=%d, rt=%d, sync=%d\n",
-			var->left_margin, var->right_margin, var->hsync_len);
-
 		fbi->regs.lcdcon2 =
 			S3C2410_LCDCON2_VBPD(var->upper_margin - 1) |
 			S3C2410_LCDCON2_VFPD(var->lower_margin - 1) |
 			S3C2410_LCDCON2_VSPW(var->vsync_len - 1);
 
-		fbi->regs.lcdcon3 =
-			S3C2410_LCDCON3_HBPD(var->right_margin - 1) |
-			S3C2410_LCDCON3_HFPD(var->left_margin - 1);
-
 		fbi->regs.lcdcon4 &= ~S3C2410_LCDCON4_HSPW(0xff);
 		fbi->regs.lcdcon4 |=  S3C2410_LCDCON4_HSPW(var->hsync_len - 1);
 	}
 
-	/* update X/Y info */
-
-	fbi->regs.lcdcon2 &= ~S3C2410_LCDCON2_LINEVAL(0x3ff);
-	fbi->regs.lcdcon2 |=  S3C2410_LCDCON2_LINEVAL(var->yres - 1);
-
-	switch (display->type) {
-	case S3C2410_LCDCON1_DSCAN4:
-	case S3C2410_LCDCON1_STN8:
-		hs = var->xres / 8;
-		break;
-	case S3C2410_LCDCON1_STN4:
-		hs = var->xres / 4;
-		break;
-	default:
-	case S3C2410_LCDCON1_TFT:
-		hs = var->xres;
-		break;
-	}
-
-	/* Special cases : STN color displays */
-	if (((fbi->regs.lcdcon1 & S3C2410_LCDCON1_MODEMASK) == S3C2410_LCDCON1_STN8BPP) ||
-	    ((fbi->regs.lcdcon1 & S3C2410_LCDCON1_MODEMASK) == S3C2410_LCDCON1_STN12BPP))
-		hs = hs * 3;
-
-	fbi->regs.lcdcon3 &= ~S3C2410_LCDCON3_HOZVAL(0x7ff);
-	fbi->regs.lcdcon3 |=  S3C2410_LCDCON3_HOZVAL(hs - 1);
-
 	if (var->pixclock > 0) {
 		int clkdiv = s3c2410fb_calc_pixclk(fbi, var->pixclock);
 
@@ -406,6 +441,11 @@ static void s3c2410fb_activate_var(struc
 		fbi->regs.lcdcon1 |=  S3C2410_LCDCON1_CLKVAL(clkdiv);
 	}
 
+	if (display->type == S3C2410_LCDCON1_TFT)
+		s3c2410fb_calculate_tft_lcd_regs(info, &fbi->regs);
+	else
+		s3c2410fb_calculate_stn_lcd_regs(info, &fbi->regs);
+
 	/* write new registers */
 
 	dprintk("new register set:\n");
@@ -452,7 +492,7 @@ static int s3c2410fb_set_par(struct fb_i
 
 	/* activate this new configuration */
 
-	s3c2410fb_activate_var(info, var);
+	s3c2410fb_activate_var(info);
 	return 0;
 }
 
@@ -848,6 +888,8 @@ static int __init s3c2410fb_probe(struct
 	fbinfo->var.yres	    = display->yres;
 	fbinfo->var.yres_virtual    = display->yres;
 	fbinfo->var.bits_per_pixel  = display->bpp;
+	fbinfo->var.left_margin	    = display->left_margin;
+	fbinfo->var.right_margin    = display->right_margin;
 
 	fbinfo->var.upper_margin    =
 				S3C2410_LCDCON2_GET_VBPD(mregs->lcdcon2) + 1;
@@ -856,10 +898,6 @@ static int __init s3c2410fb_probe(struct
 	fbinfo->var.vsync_len	    =
 				S3C2410_LCDCON2_GET_VSPW(mregs->lcdcon2) + 1;
 
-	fbinfo->var.left_margin	    =
-				S3C2410_LCDCON3_GET_HFPD(mregs->lcdcon3) + 1;
-	fbinfo->var.right_margin    =
-				S3C2410_LCDCON3_GET_HBPD(mregs->lcdcon3) + 1;
 	fbinfo->var.hsync_len	    =
 				S3C2410_LCDCON4_GET_HSPW(mregs->lcdcon4) + 1;
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
