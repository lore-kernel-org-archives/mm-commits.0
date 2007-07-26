From: akpm@linux-foundation.org
Subject: + mbxfb-improvements-and-new-features.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:44 -0700
Message-ID: <200707261900.l6QJ0i2c015667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764308AbXGZTNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:13:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raph@8d.com, adaplas@gmail.com


The patch titled
     mbxfb: Improvements and new features
has been added to the -mm tree.  Its filename is
     mbxfb-improvements-and-new-features.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mbxfb: Improvements and new features
From: Raphael Assenat <raph@8d.com>

This contains the following changes:

* Overlay surface alpha is configured separately from the overlay. This
prevents display glitches (configure and fill the overlay first, set
alpha to a visible value next)

* Added an ioctl for configuring transparency of the Overlay and graphics
planes. Blend mode, colorkey mode and global alpha mode are supported.

* Added an ioctl for setting the plane order. The overlay plance can be placed
over or
under the graphics plane.

* Added an ioctl for setting and reading chip registers, with mask.

* Updated copyright for 2007

[adaplas]
* Coding style changes

Signed-off-by: Raphael Assenat <raph@8d.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mbx/mbxfb.c    |  344 +++++++++++++++++++++++++--------
 drivers/video/mbx/reg_bits.h |   87 ++++++++
 drivers/video/mbx/regs.h     |    2 
 include/video/mbxfb.h        |   53 ++++-
 4 files changed, 402 insertions(+), 84 deletions(-)

diff -puN drivers/video/mbx/mbxfb.c~mbxfb-improvements-and-new-features drivers/video/mbx/mbxfb.c
--- a/drivers/video/mbx/mbxfb.c~mbxfb-improvements-and-new-features
+++ a/drivers/video/mbx/mbxfb.c
@@ -1,7 +1,7 @@
 /*
  *  linux/drivers/video/mbx/mbxfb.c
  *
- *  Copyright (C) 2006 8D Technologies inc
+ *  Copyright (C) 2006-2007 8D Technologies inc
  *  Raphael Assenat <raph@8d.com>
  *  	- Added video overlay support
  *  	- Various improvements
@@ -334,8 +334,8 @@ static int mbxfb_blank(int blank, struct
 
 static int mbxfb_setupOverlay(struct mbxfb_overlaySetup *set)
 {
-	u32 vsctrl, vbbase, vscadr, vsadr;
-	u32 sssize, spoctrl, svctrl, shctrl;
+	u32 vsctrl, vscadr, vsadr;
+	u32 sssize, spoctrl, shctrl;
 	u32 vubase, vvbase;
 	u32 vovrclk;
 
@@ -349,13 +349,11 @@ static int mbxfb_setupOverlay(struct mbx
 	vscadr = readl(VSCADR);
 	vubase = readl(VUBASE);
 	vvbase = readl(VVBASE);
+	shctrl = readl(SHCTRL);
 
 	spoctrl = readl(SPOCTRL);
 	sssize = readl(SSSIZE);
 
-
-	vbbase = Vbbase_Glalpha(set->alpha);
-
 	vsctrl &= ~(	FMsk(VSCTRL_VSWIDTH) |
 					FMsk(VSCTRL_VSHEIGHT) |
 					FMsk(VSCTRL_VPIXFMT) |
@@ -364,38 +362,41 @@ static int mbxfb_setupOverlay(struct mbx
 	vsctrl |= Vsctrl_Width(set->width) | Vsctrl_Height(set->height) |
 				VSCTRL_CSC_EN;
 
-	vscadr &= ~(VSCADR_STR_EN | VSCADR_COLKEY_EN | VSCADR_COLKEYSRC |
-				FMsk(VSCADR_BLEND_M) | FMsk(VSCADR_BLEND_POS) |
-				FMsk(VSCADR_VBASE_ADR) );
+	vscadr &= ~(VSCADR_STR_EN | FMsk(VSCADR_VBASE_ADR) );
 	vubase &= ~(VUBASE_UVHALFSTR | FMsk(VUBASE_UBASE_ADR));
 	vvbase &= ~(FMsk(VVBASE_VBASE_ADR));
 
-	switch (set->fmt)
-	{
-		case MBXFB_FMT_YUV12:
-			vsctrl |= VSCTRL_VPIXFMT_YUV12;
+	switch (set->fmt) {
+	case MBXFB_FMT_YUV16:
+		vsctrl |= VSCTRL_VPIXFMT_YUV12;
 
-			set->Y_stride = ((set->width) + 0xf ) & ~0xf;
+		set->Y_stride = ((set->width) + 0xf ) & ~0xf;
+		break;
+	case MBXFB_FMT_YUV12:
+		vsctrl |= VSCTRL_VPIXFMT_YUV12;
 
+		set->Y_stride = ((set->width) + 0xf ) & ~0xf;
+		vubase |= VUBASE_UVHALFSTR;
+
+		break;
+	case MBXFB_FMT_UY0VY1:
+		vsctrl |= VSCTRL_VPIXFMT_UY0VY1;
+		set->Y_stride = (set->width*2 + 0xf ) & ~0xf;
+		break;
+	case MBXFB_FMT_VY0UY1:
+		vsctrl |= VSCTRL_VPIXFMT_VY0UY1;
+		set->Y_stride = (set->width*2 + 0xf ) & ~0xf;
+		break;
+	case MBXFB_FMT_Y0UY1V:
+		vsctrl |= VSCTRL_VPIXFMT_Y0UY1V;
+		set->Y_stride = (set->width*2 + 0xf ) & ~0xf;
+		break;
+	case MBXFB_FMT_Y0VY1U:
+		vsctrl |= VSCTRL_VPIXFMT_Y0VY1U;
+		set->Y_stride = (set->width*2 + 0xf ) & ~0xf;
 			break;
-		case MBXFB_FMT_UY0VY1:
-			vsctrl |= VSCTRL_VPIXFMT_UY0VY1;
-			set->Y_stride = (set->width*2 + 0xf ) & ~0xf;
-			break;
-		case MBXFB_FMT_VY0UY1:
-			vsctrl |= VSCTRL_VPIXFMT_VY0UY1;
-			set->Y_stride = (set->width*2 + 0xf ) & ~0xf;
-			break;
-		case MBXFB_FMT_Y0UY1V:
-			vsctrl |= VSCTRL_VPIXFMT_Y0UY1V;
-			set->Y_stride = (set->width*2 + 0xf ) & ~0xf;
-			break;
-		case MBXFB_FMT_Y0VY1U:
-			vsctrl |= VSCTRL_VPIXFMT_Y0VY1U;
-			set->Y_stride = (set->width*2 + 0xf ) & ~0xf;
-			break;
-		default:
-			return -EINVAL;
+	default:
+		return -EINVAL;
 	}
 
 	/* VSCTRL has the bits which sets the Video Pixel Format.
@@ -417,8 +418,7 @@ static int mbxfb_setupOverlay(struct mbx
 			(0x60000 + set->mem_offset + set->V_offset)>>3);
 
 
-	vscadr |= VSCADR_BLEND_VID | VSCADR_BLEND_GLOB |
-		Vscadr_Vbase_Adr((0x60000 + set->mem_offset)>>4);
+	vscadr |= Vscadr_Vbase_Adr((0x60000 + set->mem_offset)>>4);
 
 	if (set->enable)
 		vscadr |= VSCADR_STR_EN;
@@ -433,9 +433,8 @@ static int mbxfb_setupOverlay(struct mbx
 
 	spoctrl &= ~(SPOCTRL_H_SC_BP | SPOCTRL_V_SC_BP |
 			SPOCTRL_HV_SC_OR | SPOCTRL_VS_UR_C |
-			FMsk(SPOCTRL_VORDER) | FMsk(SPOCTRL_VPITCH));
-	spoctrl = Spoctrl_Vpitch((set->height<<11)/set->scaled_height)
-							| SPOCTRL_VORDER_2TAP;
+			FMsk(SPOCTRL_VPITCH));
+	spoctrl |= Spoctrl_Vpitch((set->height<<11)/set->scaled_height);
 
 	/* Bypass horiz/vert scaler when same size */
 	if (set->scaled_width == set->width)
@@ -443,14 +442,11 @@ static int mbxfb_setupOverlay(struct mbx
 	if (set->scaled_height == set->height)
 		spoctrl |= SPOCTRL_V_SC_BP;
 
-	svctrl = Svctrl_Initial1(1<<10) | Svctrl_Initial2(1<<10);
-
-	shctrl = Shctrl_Hinitial(4<<11)
-			| Shctrl_Hpitch((set->width<<11)/set->scaled_width);
+	shctrl &= ~(FMsk(SHCTRL_HPITCH) | SHCTRL_HDECIM);
+	shctrl |= Shctrl_Hpitch((set->width<<11)/set->scaled_width);
 
 	/* Video plane registers */
 	write_reg(vsctrl, VSCTRL);
-	write_reg(vbbase, VBBASE);
 	write_reg(vscadr, VSCADR);
 	write_reg(vubase, VUBASE);
 	write_reg(vvbase, VVBASE);
@@ -459,28 +455,8 @@ static int mbxfb_setupOverlay(struct mbx
 	/* Video scaler registers */
 	write_reg(sssize, SSSIZE);
 	write_reg(spoctrl, SPOCTRL);
-	write_reg(svctrl, SVCTRL);
 	write_reg(shctrl, SHCTRL);
 
-	/* RAPH: Using those coefficients, the scaled
-	 * image is quite blurry. I dont know how
-	 * to improve them ; The chip documentation
-	 * was not helpful.. */
-	write_reg(0x21212121, VSCOEFF0);
-	write_reg(0x21212121, VSCOEFF1);
-	write_reg(0x21212121, VSCOEFF2);
-	write_reg(0x21212121, VSCOEFF3);
-	write_reg(0x21212121, VSCOEFF4);
-	write_reg(0x00000000, HSCOEFF0);
-	write_reg(0x00000000, HSCOEFF1);
-	write_reg(0x00000000, HSCOEFF2);
-	write_reg(0x03020201, HSCOEFF3);
-	write_reg(0x09070604, HSCOEFF4);
-	write_reg(0x0f0e0c0a, HSCOEFF5);
-	write_reg(0x15141211, HSCOEFF6);
-	write_reg(0x19181716, HSCOEFF7);
-	write_reg(0x00000019, HSCOEFF8);
-
 	/* Clock */
 	if (set->enable)
 		vovrclk |= 1;
@@ -492,27 +468,206 @@ static int mbxfb_setupOverlay(struct mbx
 	return 0;
 }
 
+static int mbxfb_ioctl_planeorder(struct mbxfb_planeorder *porder)
+{
+	unsigned long gscadr, vscadr;
+
+	if (porder->bottom == porder->top)
+		return -EINVAL;
+
+	gscadr = readl(GSCADR);
+	vscadr = readl(VSCADR);
+
+	gscadr &= ~(FMsk(GSCADR_BLEND_POS));
+	vscadr &= ~(FMsk(VSCADR_BLEND_POS));
+
+	switch (porder->bottom) {
+	case MBXFB_PLANE_GRAPHICS:
+		gscadr |= GSCADR_BLEND_GFX;
+		break;
+	case MBXFB_PLANE_VIDEO:
+		vscadr |= VSCADR_BLEND_GFX;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (porder->top) {
+	case MBXFB_PLANE_GRAPHICS:
+		gscadr |= GSCADR_BLEND_VID;
+		break;
+	case MBXFB_PLANE_VIDEO:
+		vscadr |= GSCADR_BLEND_VID;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	write_reg_dly(vscadr, VSCADR);
+	write_reg_dly(gscadr, GSCADR);
+
+	return 0;
+
+}
+
+static int mbxfb_ioctl_alphactl(struct mbxfb_alphaCtl *alpha)
+{
+	unsigned long vscadr, vbbase, vcmsk;
+	unsigned long gscadr, gbbase, gdrctrl;
+
+	vbbase = Vbbase_Glalpha(alpha->overlay_global_alpha) |
+				Vbbase_Colkey(alpha->overlay_colorkey);
+
+	gbbase = Gbbase_Glalpha(alpha->graphics_global_alpha) |
+				Gbbase_Colkey(alpha->graphics_colorkey);
+
+	vcmsk = readl(VCMSK);
+	vcmsk &= ~(FMsk(VCMSK_COLKEY_M));
+	vcmsk |= Vcmsk_colkey_m(alpha->overlay_colorkey_mask);
+
+	gdrctrl = readl(GDRCTRL);
+	gdrctrl &= ~(FMsk(GDRCTRL_COLKEYM));
+	gdrctrl |= Gdrctrl_Colkeym(alpha->graphics_colorkey_mask);
+
+	vscadr = readl(VSCADR);
+	vscadr &= ~(FMsk(VSCADR_BLEND_M) | VSCADR_COLKEYSRC | VSCADR_COLKEY_EN);
+
+	gscadr = readl(GSCADR);
+	gscadr &= ~(FMsk(GSCADR_BLEND_M) | GSCADR_COLKEY_EN | GSCADR_COLKEYSRC);
+
+	switch (alpha->overlay_colorkey_mode) {
+	case MBXFB_COLORKEY_DISABLED:
+		break;
+	case MBXFB_COLORKEY_PREVIOUS:
+		vscadr |= VSCADR_COLKEY_EN;
+		break;
+	case MBXFB_COLORKEY_CURRENT:
+		vscadr |= VSCADR_COLKEY_EN | VSCADR_COLKEYSRC;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (alpha->overlay_blend_mode) {
+	case MBXFB_ALPHABLEND_NONE:
+		vscadr |= VSCADR_BLEND_NONE;
+		break;
+	case MBXFB_ALPHABLEND_GLOBAL:
+		vscadr |= VSCADR_BLEND_GLOB;
+		break;
+	case MBXFB_ALPHABLEND_PIXEL:
+		vscadr |= VSCADR_BLEND_PIX;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (alpha->graphics_colorkey_mode) {
+	case MBXFB_COLORKEY_DISABLED:
+		break;
+	case MBXFB_COLORKEY_PREVIOUS:
+		gscadr |= GSCADR_COLKEY_EN;
+		break;
+	case MBXFB_COLORKEY_CURRENT:
+		gscadr |= GSCADR_COLKEY_EN | GSCADR_COLKEYSRC;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (alpha->graphics_blend_mode) {
+	case MBXFB_ALPHABLEND_NONE:
+		gscadr |= GSCADR_BLEND_NONE;
+		break;
+	case MBXFB_ALPHABLEND_GLOBAL:
+		gscadr |= GSCADR_BLEND_GLOB;
+		break;
+	case MBXFB_ALPHABLEND_PIXEL:
+		gscadr |= GSCADR_BLEND_PIX;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	write_reg_dly(vbbase, VBBASE);
+	write_reg_dly(gbbase, GBBASE);
+	write_reg_dly(vcmsk, VCMSK);
+	write_reg_dly(gdrctrl, GDRCTRL);
+	write_reg_dly(gscadr, GSCADR);
+	write_reg_dly(vscadr, VSCADR);
+
+	return 0;
+}
+
 static int mbxfb_ioctl(struct fb_info *info, unsigned int cmd,
 				unsigned long arg)
 {
-	struct mbxfb_overlaySetup setup;
+	struct mbxfb_overlaySetup	setup;
+	struct mbxfb_planeorder 	porder;
+	struct mbxfb_alphaCtl 		alpha;
+	struct mbxfb_reg			reg;
 	int res;
+	__u32 tmp;
 
-	if (cmd == MBXFB_IOCX_OVERLAY)
+	switch (cmd)
 	{
-		if (copy_from_user(&setup, (void __user*)arg,
-					sizeof(struct mbxfb_overlaySetup)))
+		case MBXFB_IOCX_OVERLAY:
+			if (copy_from_user(&setup, (void __user*)arg,
+						sizeof(struct mbxfb_overlaySetup)))
+				return -EFAULT;
+
+			res = mbxfb_setupOverlay(&setup);
+			if (res)
+				return res;
+
+			if (copy_to_user((void __user*)arg, &setup,
+						sizeof(struct mbxfb_overlaySetup)))
+				return -EFAULT;
+
+			return 0;
+
+		case MBXFB_IOCS_PLANEORDER:
+			if (copy_from_user(&porder, (void __user*)arg,
+					sizeof(struct mbxfb_planeorder)))
 			return -EFAULT;
 
-		res = mbxfb_setupOverlay(&setup);
-		if (res)
-			return res;
+			return mbxfb_ioctl_planeorder(&porder);
 
-		if (copy_to_user((void __user*)arg, &setup,
-					sizeof(struct mbxfb_overlaySetup)))
+		case MBXFB_IOCS_ALPHA:
+			if (copy_from_user(&alpha, (void __user*)arg,
+					sizeof(struct mbxfb_alphaCtl)))
 			return -EFAULT;
 
-		return 0;
+			return mbxfb_ioctl_alphactl(&alpha);
+
+		case MBXFB_IOCS_REG:
+			if (copy_from_user(&reg, (void __user*)arg,
+						sizeof(struct mbxfb_reg)))
+				return -EFAULT;
+
+			if (reg.addr >= 0x10000) /* regs are from 0x3fe0000 to 0x3feffff */
+				return -EINVAL;
+
+			tmp = readl(virt_base_2700 + reg.addr);
+			tmp &= ~reg.mask;
+			tmp |= reg.val & reg.mask;
+			writel(tmp, virt_base_2700 + reg.addr);
+
+			return 0;
+		case MBXFB_IOCX_REG:
+			if (copy_from_user(&reg, (void __user*)arg,
+						sizeof(struct mbxfb_reg)))
+				return -EFAULT;
+
+			if (reg.addr >= 0x10000)	/* regs are from 0x3fe0000 to 0x3feffff */
+				return -EINVAL;
+			reg.val = readl(virt_base_2700 + reg.addr);
+
+			if (copy_to_user((void __user*)arg, &reg,
+						sizeof(struct mbxfb_reg)))
+				return -EFAULT;
+
+			return 0;
 	}
 	return -EINVAL;
 }
@@ -558,7 +713,6 @@ static void __devinit setup_memc(struct 
 	       LMTYPE);
 	/* enable memory controller */
 	write_reg_dly(LMPWR_MC_PWR_ACT, LMPWR);
-
 	/* perform dummy reads */
 	for ( i = 0; i < 16; i++ ) {
 		tmp = readl(fbi->screen_base);
@@ -588,8 +742,8 @@ static void enable_clocks(struct fb_info
 	write_reg_dly(0x00000000, VOVRCLK);
 	write_reg_dly(PIXCLK_EN, PIXCLK);
 	write_reg_dly(MEMCLK_EN, MEMCLK);
-	write_reg_dly(0x00000006, M24CLK);
-	write_reg_dly(0x00000006, MBXCLK);
+	write_reg_dly(0x00000001, M24CLK);
+	write_reg_dly(0x00000001, MBXCLK);
 	write_reg_dly(SDCLK_EN, SDCLK);
 	write_reg_dly(0x00000001, PIXCLKDIV);
 }
@@ -597,6 +751,7 @@ static void enable_clocks(struct fb_info
 static void __devinit setup_graphics(struct fb_info *fbi)
 {
 	unsigned long gsctrl;
+	unsigned long vscadr;
 
 	gsctrl = GSCTRL_GAMMA_EN | Gsctrl_Width(fbi->var.xres) |
 		Gsctrl_Height(fbi->var.yres);
@@ -620,6 +775,11 @@ static void __devinit setup_graphics(str
 	write_reg_dly(0x00ffffff, GDRCTRL);
 	write_reg_dly((GSCADR_STR_EN | Gscadr_Gbase_Adr(0x6000)), GSCADR);
 	write_reg_dly(0x00000000, GPLUT);
+
+	vscadr = readl(VSCADR);
+	vscadr &= ~(FMsk(VSCADR_BLEND_POS) | FMsk(VSCADR_BLEND_M));
+	vscadr |= VSCADR_BLEND_VID | VSCADR_BLEND_NONE;
+	write_reg_dly(vscadr, VSCADR);
 }
 
 static void __devinit setup_display(struct fb_info *fbi)
@@ -638,13 +798,47 @@ static void __devinit setup_display(stru
 
 static void __devinit enable_controller(struct fb_info *fbi)
 {
+	u32 svctrl, shctrl;
+
 	write_reg_dly(SYSRST_RST, SYSRST);
 
+	/* setup a timeout, raise drive strength */
+	write_reg_dly(0xffffff0c, SYSCFG);
 
 	enable_clocks(fbi);
 	setup_memc(fbi);
 	setup_graphics(fbi);
 	setup_display(fbi);
+
+	shctrl = readl(SHCTRL);
+	shctrl &= ~(FMsk(SHCTRL_HINITIAL));
+	shctrl |= Shctrl_Hinitial(4<<11);
+	writel(shctrl, SHCTRL);
+
+	svctrl = Svctrl_Initial1(1<<10) | Svctrl_Initial2(1<<10);
+	writel(svctrl, SVCTRL);
+
+	writel(SPOCTRL_H_SC_BP | SPOCTRL_V_SC_BP | SPOCTRL_VORDER_4TAP
+			, SPOCTRL);
+
+	/* Those coefficients are good for scaling up. For scaling
+	 * down, the application has to calculate them. */
+	write_reg(0xff000100, VSCOEFF0);
+	write_reg(0xfdfcfdfe, VSCOEFF1);
+	write_reg(0x170d0500, VSCOEFF2);
+	write_reg(0x3d372d22, VSCOEFF3);
+	write_reg(0x00000040, VSCOEFF4);
+
+	write_reg(0xff010100, HSCOEFF0);
+	write_reg(0x00000000, HSCOEFF1);
+	write_reg(0x02010000, HSCOEFF2);
+	write_reg(0x01020302, HSCOEFF3);
+	write_reg(0xf9fbfe00, HSCOEFF4);
+	write_reg(0xfbf7f6f7, HSCOEFF5);
+	write_reg(0x1c110700, HSCOEFF6);
+	write_reg(0x3e393127, HSCOEFF7);
+	write_reg(0x00000040, HSCOEFF8);
+
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/video/mbx/reg_bits.h~mbxfb-improvements-and-new-features drivers/video/mbx/reg_bits.h
--- a/drivers/video/mbx/reg_bits.h~mbxfb-improvements-and-new-features
+++ a/drivers/video/mbx/reg_bits.h
@@ -215,7 +215,7 @@
 /* GSCADR graphics stream control address register fields */
 #define GSCADR_STR_EN	(1 << 31)
 #define GSCADR_COLKEY_EN	(1 << 30)
-#define GSCADR_COLKEYSCR	(1 << 29)
+#define GSCADR_COLKEYSRC	(1 << 29)
 #define GSCADR_BLEND_M	Fld(2,27)
 #define GSCADR_BLEND_NONE	((0x0) << FShft(GSCADR_BLEND_M))
 #define GSCADR_BLEND_INV	((0x1) << FShft(GSCADR_BLEND_M))
@@ -303,6 +303,67 @@
 #define VSADR_YSTART		Fld(11,0)
 #define Vsadr_Ystart(x)		((x) << FShft(VSADR_YSTART))
 
+/* VSCTRL - Video Surface Control Register */
+#define VSCTRL_VPIXFMT		Fld(4,27)
+#define VSCTRL_VPIXFMT_YUV12	((0x9) << FShft(VSCTRL_VPIXFMT))
+#define VSCTRL_VPIXFMT_UY0VY1	((0xc) << FShft(VSCTRL_VPIXFMT))
+#define VSCTRL_VPIXFMT_VY0UY1	((0xd) << FShft(VSCTRL_VPIXFMT))
+#define VSCTRL_VPIXFMT_Y0UY1V	((0xe) << FShft(VSCTRL_VPIXFMT))
+#define VSCTRL_VPIXFMT_Y0VY1U	((0xf) << FShft(VSCTRL_VPIXFMT))
+#define VSCTRL_GAMMA_EN		(1 << 26)
+#define VSCTRL_CSC_EN		(1 << 25)
+#define VSCTRL_COSITED		(1 << 22)
+#define VSCTRL_VSWIDTH		Fld(11,11)
+#define Vsctrl_Width(Pixels) /* Video Width [1-2048] */ \
+			(((Pixels) - 1) << FShft(VSCTRL_VSWIDTH))
+#define VSCTRL_VSHEIGHT		Fld(11,0)
+#define Vsctrl_Height(Pixels) /* Video Height [1-2048] */ \
+			(((Pixels) - 1) << FShft(VSCTRL_VSHEIGHT))
+
+/* VBBASE - Video Blending Base Register */
+#define VBBASE_GLALPHA		Fld(8,24)
+#define Vbbase_Glalpha(x)	((x) << FShft(VBBASE_GLALPHA))
+
+#define VBBASE_COLKEY		Fld(24,0)
+#define Vbbase_Colkey(x)	((x) << FShft(VBBASE_COLKEY))
+
+/* VCMSK - Video Color Key Mask Register */
+#define VCMSK_COLKEY_M		Fld(24,0)
+#define Vcmsk_colkey_m(x)	((x) << FShft(VCMSK_COLKEY_M))
+
+/* VSCADR - Video Stream Control Rddress Register */
+#define VSCADR_STR_EN		(1 << 31)
+#define VSCADR_COLKEY_EN	(1 << 30)
+#define VSCADR_COLKEYSRC	(1 << 29)
+#define VSCADR_BLEND_M		Fld(2,27)
+#define VSCADR_BLEND_NONE	((0x0) << FShft(VSCADR_BLEND_M))
+#define VSCADR_BLEND_INV	((0x1) << FShft(VSCADR_BLEND_M))
+#define VSCADR_BLEND_GLOB	((0x2) << FShft(VSCADR_BLEND_M))
+#define VSCADR_BLEND_PIX	((0x3) << FShft(VSCADR_BLEND_M))
+#define VSCADR_BLEND_POS	Fld(2,24)
+#define VSCADR_BLEND_GFX	((0x0) << FShft(VSCADR_BLEND_POS))
+#define VSCADR_BLEND_VID	((0x1) << FShft(VSCADR_BLEND_POS))
+#define VSCADR_BLEND_CUR	((0x2) << FShft(VSCADR_BLEND_POS))
+#define VSCADR_VBASE_ADR	Fld(23,0)
+#define Vscadr_Vbase_Adr(x)	((x) << FShft(VSCADR_VBASE_ADR))
+
+/* VUBASE - Video U Base Register */
+#define VUBASE_UVHALFSTR	(1 << 31)
+#define VUBASE_UBASE_ADR	Fld(24,0)
+#define Vubase_Ubase_Adr(x)	((x) << FShft(VUBASE_UBASE_ADR))
+
+/* VVBASE - Video V Base Register */
+#define VVBASE_VBASE_ADR	Fld(24,0)
+#define Vvbase_Vbase_Adr(x)	((x) << FShft(VVBASE_VBASE_ADR))
+
+/* VSADR - Video Stride Address Register */
+#define VSADR_SRCSTRIDE		Fld(10,22)
+#define Vsadr_Srcstride(x)	((x) << FShft(VSADR_SRCSTRIDE))
+#define VSADR_XSTART		Fld(11,11)
+#define Vsadr_Xstart(x)		((x) << FShft(VSADR_XSTART))
+#define VSADR_YSTART		Fld(11,0)
+#define Vsadr_Ystart(x)		((x) << FShft(VSADR_YSTART))
+
 /* HCCTRL - Hardware Cursor Register fields */
 #define HCCTRL_CUR_EN	(1 << 31)
 #define HCCTRL_COLKEY_EN	(1 << 29)
@@ -479,6 +540,30 @@
 #define DINTRE_HBLNK1_EN	(1 << 1)
 #define DINTRE_HBLNK0_EN	(1 << 0)
 
+/* DINTRS - Display Interrupt Status Register */
+#define DINTRS_CUR_OR_S		(1 << 18)
+#define DINTRS_STR2_OR_S	(1 << 17)
+#define DINTRS_STR1_OR_S	(1 << 16)
+#define DINTRS_CUR_UR_S		(1 << 6)
+#define DINTRS_STR2_UR_S	(1 << 5)
+#define DINTRS_STR1_UR_S	(1 << 4)
+#define DINTRS_VEVENT1_S	(1 << 3)
+#define DINTRS_VEVENT0_S	(1 << 2)
+#define DINTRS_HBLNK1_S		(1 << 1)
+#define DINTRS_HBLNK0_S		(1 << 0)
+
+/* DINTRE - Display Interrupt Enable Register */
+#define DINTRE_CUR_OR_EN	(1 << 18)
+#define DINTRE_STR2_OR_EN	(1 << 17)
+#define DINTRE_STR1_OR_EN	(1 << 16)
+#define DINTRE_CUR_UR_EN	(1 << 6)
+#define DINTRE_STR2_UR_EN	(1 << 5)
+#define DINTRE_STR1_UR_EN	(1 << 4)
+#define DINTRE_VEVENT1_EN	(1 << 3)
+#define DINTRE_VEVENT0_EN	(1 << 2)
+#define DINTRE_HBLNK1_EN	(1 << 1)
+#define DINTRE_HBLNK0_EN	(1 << 0)
+
 
 /* DLSTS - display load status register */
 #define DLSTS_RLD_ADONE	(1 << 23)
diff -puN drivers/video/mbx/regs.h~mbxfb-improvements-and-new-features drivers/video/mbx/regs.h
--- a/drivers/video/mbx/regs.h~mbxfb-improvements-and-new-features
+++ a/drivers/video/mbx/regs.h
@@ -30,7 +30,7 @@
 #define VOVRCLK		__REG_2700G(0x00000044)
 #define PIXCLK		__REG_2700G(0x00000048)
 #define MEMCLK		__REG_2700G(0x0000004c)
-#define M24CLK		__REG_2700G(0x00000054)
+#define M24CLK		__REG_2700G(0x00000050)
 #define MBXCLK		__REG_2700G(0x00000054)
 #define SDCLK		__REG_2700G(0x00000058)
 #define PIXCLKDIV	__REG_2700G(0x0000005c)
diff -puN include/video/mbxfb.h~mbxfb-improvements-and-new-features include/video/mbxfb.h
--- a/include/video/mbxfb.h~mbxfb-improvements-and-new-features
+++ a/include/video/mbxfb.h
@@ -29,18 +29,18 @@ struct mbxfb_platform_data {
 };
 
 /* planar */
-#define MBXFB_FMT_YUV12		0
+#define MBXFB_FMT_YUV16		0
+#define MBXFB_FMT_YUV12		1
 
 /* packed */
-#define MBXFB_FMT_UY0VY1	1
-#define MBXFB_FMT_VY0UY1	2
-#define MBXFB_FMT_Y0UY1V	3
-#define MBXFB_FMT_Y0VY1U	4
+#define MBXFB_FMT_UY0VY1	2
+#define MBXFB_FMT_VY0UY1	3
+#define MBXFB_FMT_Y0UY1V	4
+#define MBXFB_FMT_Y0VY1U	5
 struct mbxfb_overlaySetup {
 	__u32 enable;
 	__u32 x, y;
 	__u32 width, height;
-	__u32 alpha;
 	__u32 fmt;
 	__u32 mem_offset;
 	__u32 scaled_width;
@@ -54,6 +54,45 @@ struct mbxfb_overlaySetup {
 	__u16 UV_stride;
 };
 
-#define MBXFB_IOCX_OVERLAY	_IOWR(0xF4, 0x00,struct mbxfb_overlaySetup)
+#define MBXFB_ALPHABLEND_NONE		0
+#define MBXFB_ALPHABLEND_GLOBAL		1
+#define MBXFB_ALPHABLEND_PIXEL		2
+
+#define MBXFB_COLORKEY_DISABLED		0
+#define MBXFB_COLORKEY_PREVIOUS		1
+#define MBXFB_COLORKEY_CURRENT		2
+struct mbxfb_alphaCtl {
+	__u8 overlay_blend_mode;
+	__u8 overlay_colorkey_mode;
+	__u8 overlay_global_alpha;
+	__u32 overlay_colorkey;
+	__u32 overlay_colorkey_mask;
+
+	__u8 graphics_blend_mode;
+	__u8 graphics_colorkey_mode;
+	__u8 graphics_global_alpha;
+	__u32 graphics_colorkey;
+	__u32 graphics_colorkey_mask;
+};
+
+#define MBXFB_PLANE_GRAPHICS	0
+#define MBXFB_PLANE_VIDEO	1
+struct mbxfb_planeorder {
+	__u8 bottom;
+	__u8 top;
+};
+
+struct mbxfb_reg {
+	__u32 addr; 	/* offset from 0x03fe 0000 */
+	__u32 val;		/* value */
+	__u32 mask;		/* which bits to touch (for write) */
+};
+
+#define MBXFB_IOCX_OVERLAY		_IOWR(0xF4, 0x00,struct mbxfb_overlaySetup)
+#define MBXFB_IOCG_ALPHA		_IOR(0xF4, 0x01,struct mbxfb_alphaCtl)
+#define MBXFB_IOCS_ALPHA		_IOW(0xF4, 0x02,struct mbxfb_alphaCtl)
+#define MBXFB_IOCS_PLANEORDER	_IOR(0xF4, 0x03,struct mbxfb_planeorder)
+#define MBXFB_IOCS_REG			_IOW(0xF4, 0x04,struct mbxfb_reg)
+#define MBXFB_IOCX_REG			_IOWR(0xF4, 0x05,struct mbxfb_reg)
 
 #endif /* __MBX_FB_H */
_

Patches currently in -mm which might be from raph@8d.com are

mbxfb-improvements-and-new-features.patch
