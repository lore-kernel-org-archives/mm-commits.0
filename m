From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-add-imageblit-function.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:47 -0700
Message-ID: <200904011842.n31Igli1009805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764810AbZDATE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:04:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: add imageblit function
has been removed from the -mm tree.  Its filename was
     cirrusfb-add-imageblit-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: add imageblit function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add hardware color expansion (imageblit) function.  It roughly doubles
scrolling speed of my Alpine card (GD5430).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   64 ++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-add-imageblit-function drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-add-imageblit-function
+++ a/drivers/video/cirrusfb.c
@@ -381,7 +381,8 @@ static void cirrusfb_BitBLT(u8 __iomem *
 static void cirrusfb_RectFill(u8 __iomem *regbase, int bits_per_pixel,
 			      u_short x, u_short y,
 			      u_short width, u_short height,
-			      u32 color, u_short line_length);
+			      u32 fg_color, u32 bg_color,
+			      u_short line_length, u_char blitmode);
 
 static void bestclock(long freq, int *nom, int *den, int *div);
 
@@ -1790,8 +1791,8 @@ static void cirrusfb_fillrect(struct fb_
 			  info->var.bits_per_pixel,
 			  (region->dx * m) / 8, region->dy,
 			  (region->width * m) / 8, region->height,
-			  color,
-			  info->fix.line_length);
+			  color, color,
+			  info->fix.line_length, 0x40);
 }
 
 static void cirrusfb_copyarea(struct fb_info *info,
@@ -1840,9 +1841,33 @@ static void cirrusfb_imageblit(struct fb
 {
 	struct cirrusfb_info *cinfo = info->par;
 
-	if (!is_laguna(cinfo))
+	if (info->state != FBINFO_STATE_RUNNING)
+		return;
+	if (info->flags & FBINFO_HWACCEL_DISABLED)
+		cfb_imageblit(info, image);
+	else {
+		unsigned size = ((image->width + 7) >> 3) * image->height;
+		int m = info->var.bits_per_pixel;
+		u32 fg, bg;
+
+		if (info->var.bits_per_pixel == 8) {
+			fg = image->fg_color;
+			bg = image->bg_color;
+		} else {
+			fg = ((u32 *)(info->pseudo_palette))[image->fg_color];
+			bg = ((u32 *)(info->pseudo_palette))[image->bg_color];
+		}
 		cirrusfb_WaitBLT(cinfo->regbase);
-	cfb_imageblit(info, image);
+		/* byte rounded scanlines */
+		vga_wgfx(cinfo->regbase, CL_GR33, 0x00);
+		cirrusfb_RectFill(cinfo->regbase,
+				  info->var.bits_per_pixel,
+				  (image->dx * m) / 8, image->dy,
+				  (image->width * m) / 8, image->height,
+				  fg, bg,
+				  info->fix.line_length, 0x04);
+		memcpy(info->screen_base, image->data, size);
+	}
 }
 
 #ifdef CONFIG_PPC_PREP
@@ -1988,10 +2013,12 @@ static int __devinit cirrusfb_set_fbinfo
 		    | FBINFO_HWACCEL_XPAN
 		    | FBINFO_HWACCEL_YPAN
 		    | FBINFO_HWACCEL_FILLRECT
+		    | FBINFO_HWACCEL_IMAGEBLIT
 		    | FBINFO_HWACCEL_COPYAREA;
 	if (noaccel || is_laguna(cinfo))
 		info->flags |= FBINFO_HWACCEL_DISABLED;
 	info->fbops = &cirrusfb_ops;
+
 	if (cinfo->btype == BT_GD5480) {
 		if (var->bits_per_pixel == 16)
 			info->screen_base += 1 * MB_;
@@ -2711,7 +2738,8 @@ static void cirrusfb_BitBLT(u8 __iomem *
 
 static void cirrusfb_RectFill(u8 __iomem *regbase, int bits_per_pixel,
 		     u_short x, u_short y, u_short width, u_short height,
-		     u32 color, u_short line_length)
+		     u32 fg_color, u32 bg_color, u_short line_length,
+		     u_char blitmode)
 {
 	u_long ndest = (y * line_length) + x;
 	u_char op;
@@ -2720,24 +2748,24 @@ static void cirrusfb_RectFill(u8 __iomem
 
 	/* This is a ColorExpand Blt, using the */
 	/* same color for foreground and background */
-	vga_wgfx(regbase, VGA_GFX_SR_VALUE, color);	/* foreground color */
-	vga_wgfx(regbase, VGA_GFX_SR_ENABLE, color);	/* background color */
+	vga_wgfx(regbase, VGA_GFX_SR_VALUE, bg_color);
+	vga_wgfx(regbase, VGA_GFX_SR_ENABLE, fg_color);
 
-	op = 0xc0;
+	op = 0x80;
 	if (bits_per_pixel >= 16) {
-		vga_wgfx(regbase, CL_GR10, color >> 8);	/* foreground color */
-		vga_wgfx(regbase, CL_GR11, color >> 8);	/* background color */
-		op = 0xd0;
+		vga_wgfx(regbase, CL_GR10, bg_color >> 8);
+		vga_wgfx(regbase, CL_GR11, fg_color >> 8);
+		op = 0x90;
 	}
 	if (bits_per_pixel == 32) {
-		vga_wgfx(regbase, CL_GR12, color >> 16);/* foreground color */
-		vga_wgfx(regbase, CL_GR13, color >> 16);/* background color */
-		vga_wgfx(regbase, CL_GR14, color >> 24);/* foreground color */
-		vga_wgfx(regbase, CL_GR15, color >> 24);/* background color */
-		op = 0xf0;
+		vga_wgfx(regbase, CL_GR12, bg_color >> 16);
+		vga_wgfx(regbase, CL_GR13, fg_color >> 16);
+		vga_wgfx(regbase, CL_GR14, bg_color >> 24);
+		vga_wgfx(regbase, CL_GR15, fg_color >> 24);
+		op = 0xb0;
 	}
 	cirrusfb_set_blitter(regbase, width - 1, height - 1,
-			    0, ndest, op, line_length);
+			    0, ndest, op | blitmode, line_length);
 }
 
 /**************************************************************************
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

