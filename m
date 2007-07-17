From: akpm@linux-foundation.org
Subject: - pm3fb-fillrect-acceleration.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:53 -0700
Message-ID: <200707172307.l6HN7roI012228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48723 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936121AbXGQXP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm3fb: fillrect acceleration
has been removed from the -mm tree.  Its filename was
     pm3fb-fillrect-acceleration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm3fb: fillrect acceleration
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This is a port of accelerated fillrect function from the 2.4 kernel driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |  241 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 238 insertions(+), 3 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-fillrect-acceleration drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-fillrect-acceleration
+++ a/drivers/video/pm3fb.c
@@ -77,7 +77,7 @@ static struct fb_fix_screeninfo pm3fb_fi
 	.xpanstep =	1,
 	.ypanstep =	1,
 	.ywrapstep =	0,
-	.accel =	FB_ACCEL_NONE,
+	.accel =	FB_ACCEL_3DLABS_PERMEDIA3,
 };
 
 /*
@@ -185,6 +185,238 @@ static inline int pm3fb_shift_bpp(unsign
 	return 0;
 }
 
+/* acceleration */
+static int pm3fb_sync(struct fb_info *info)
+{
+	struct pm3_par *par = info->par;
+
+	PM3_WAIT(par, 2);
+	PM3_WRITE_REG(par, PM3FilterMode, PM3FilterModeSync);
+	PM3_WRITE_REG(par, PM3Sync, 0);
+	mb();
+	do {
+		while ((PM3_READ_REG(par, PM3OutFIFOWords)) == 0);
+		rmb();
+	} while ((PM3_READ_REG(par, PM3OutputFifo)) != PM3Sync_Tag);
+
+	return 0;
+}
+
+static void pm3fb_init_engine(struct fb_info *info)
+{
+	struct pm3_par *par = info->par;
+	const u32 width = (info->var.xres_virtual + 7) & ~7;
+
+	PM3_WAIT(par, 50);
+	PM3_WRITE_REG(par, PM3FilterMode, PM3FilterModeSync);
+	PM3_WRITE_REG(par, PM3StatisticMode, 0x0);
+	PM3_WRITE_REG(par, PM3DeltaMode, 0x0);
+	PM3_WRITE_REG(par, PM3RasterizerMode, 0x0);
+	PM3_WRITE_REG(par, PM3ScissorMode, 0x0);
+	PM3_WRITE_REG(par, PM3LineStippleMode, 0x0);
+	PM3_WRITE_REG(par, PM3AreaStippleMode, 0x0);
+	PM3_WRITE_REG(par, PM3GIDMode, 0x0);
+	PM3_WRITE_REG(par, PM3DepthMode, 0x0);
+	PM3_WRITE_REG(par, PM3StencilMode, 0x0);
+	PM3_WRITE_REG(par, PM3StencilData, 0x0);
+	PM3_WRITE_REG(par, PM3ColorDDAMode, 0x0);
+	PM3_WRITE_REG(par, PM3TextureCoordMode, 0x0);
+	PM3_WRITE_REG(par, PM3TextureIndexMode0, 0x0);
+	PM3_WRITE_REG(par, PM3TextureIndexMode1, 0x0);
+	PM3_WRITE_REG(par, PM3TextureReadMode, 0x0);
+	PM3_WRITE_REG(par, PM3LUTMode, 0x0);
+	PM3_WRITE_REG(par, PM3TextureFilterMode, 0x0);
+	PM3_WRITE_REG(par, PM3TextureCompositeMode, 0x0);
+	PM3_WRITE_REG(par, PM3TextureApplicationMode, 0x0);
+	PM3_WRITE_REG(par, PM3TextureCompositeColorMode1, 0x0);
+	PM3_WRITE_REG(par, PM3TextureCompositeAlphaMode1, 0x0);
+	PM3_WRITE_REG(par, PM3TextureCompositeColorMode0, 0x0);
+	PM3_WRITE_REG(par, PM3TextureCompositeAlphaMode0, 0x0);
+	PM3_WRITE_REG(par, PM3FogMode, 0x0);
+	PM3_WRITE_REG(par, PM3ChromaTestMode, 0x0);
+	PM3_WRITE_REG(par, PM3AlphaTestMode, 0x0);
+	PM3_WRITE_REG(par, PM3AntialiasMode, 0x0);
+	PM3_WRITE_REG(par, PM3YUVMode, 0x0);
+	PM3_WRITE_REG(par, PM3AlphaBlendColorMode, 0x0);
+	PM3_WRITE_REG(par, PM3AlphaBlendAlphaMode, 0x0);
+	PM3_WRITE_REG(par, PM3DitherMode, 0x0);
+	PM3_WRITE_REG(par, PM3LogicalOpMode, 0x0);
+	PM3_WRITE_REG(par, PM3RouterMode, 0x0);
+	PM3_WRITE_REG(par, PM3Window, 0x0);
+
+	PM3_WRITE_REG(par, PM3Config2D, 0x0);
+
+	PM3_WRITE_REG(par, PM3SpanColorMask, 0xffffffff);
+
+	PM3_WRITE_REG(par, PM3XBias, 0x0);
+	PM3_WRITE_REG(par, PM3YBias, 0x0);
+	PM3_WRITE_REG(par, PM3DeltaControl, 0x0);
+
+	PM3_WRITE_REG(par, PM3BitMaskPattern, 0xffffffff);
+
+	PM3_WRITE_REG(par, PM3FBDestReadEnables,
+			   PM3FBDestReadEnables_E(0xff) |
+			   PM3FBDestReadEnables_R(0xff) |
+			   PM3FBDestReadEnables_ReferenceAlpha(0xff));
+	PM3_WRITE_REG(par, PM3FBDestReadBufferAddr0, 0x0);
+	PM3_WRITE_REG(par, PM3FBDestReadBufferOffset0, 0x0);
+	PM3_WRITE_REG(par, PM3FBDestReadBufferWidth0,
+			   PM3FBDestReadBufferWidth_Width(width));
+
+	PM3_WRITE_REG(par, PM3FBDestReadMode,
+			   PM3FBDestReadMode_ReadEnable |
+			   PM3FBDestReadMode_Enable0);
+	PM3_WRITE_REG(par, PM3FBSourceReadBufferAddr, 0x0);
+	PM3_WRITE_REG(par, PM3FBSourceReadBufferOffset, 0x0);
+	PM3_WRITE_REG(par, PM3FBSourceReadBufferWidth,
+			   PM3FBSourceReadBufferWidth_Width(width));
+	PM3_WRITE_REG(par, PM3FBSourceReadMode,
+			   PM3FBSourceReadMode_Blocking |
+			   PM3FBSourceReadMode_ReadEnable);
+
+	PM3_WAIT(par, 2);
+	{
+		unsigned long rm = 1;
+		switch (info->var.bits_per_pixel) {
+		case 8:
+			PM3_WRITE_REG(par, PM3PixelSize,
+					   PM3PixelSize_GLOBAL_8BIT);
+			break;
+		case 16:
+			PM3_WRITE_REG(par, PM3PixelSize,
+					   PM3PixelSize_GLOBAL_16BIT);
+			break;
+		case 32:
+			PM3_WRITE_REG(par, PM3PixelSize,
+					   PM3PixelSize_GLOBAL_32BIT);
+			break;
+		default:
+			DPRINTK(1, "Unsupported depth %d\n",
+				info->var.bits_per_pixel);
+			break;
+		}
+		PM3_WRITE_REG(par, PM3RasterizerMode, rm);
+	}
+
+	PM3_WAIT(par, 20);
+	PM3_WRITE_REG(par, PM3FBSoftwareWriteMask, 0xffffffff);
+	PM3_WRITE_REG(par, PM3FBHardwareWriteMask, 0xffffffff);
+	PM3_WRITE_REG(par, PM3FBWriteMode,
+			   PM3FBWriteMode_WriteEnable |
+			   PM3FBWriteMode_OpaqueSpan |
+			   PM3FBWriteMode_Enable0);
+	PM3_WRITE_REG(par, PM3FBWriteBufferAddr0, 0x0);
+	PM3_WRITE_REG(par, PM3FBWriteBufferOffset0, 0x0);
+	PM3_WRITE_REG(par, PM3FBWriteBufferWidth0,
+			   PM3FBWriteBufferWidth_Width(width));
+
+	PM3_WRITE_REG(par, PM3SizeOfFramebuffer, 0x0);
+	{
+		/* size in lines of FB */
+		unsigned long sofb = info->screen_size /
+			info->fix.line_length;
+		if (sofb > 4095)
+			PM3_WRITE_REG(par, PM3SizeOfFramebuffer, 4095);
+		else
+			PM3_WRITE_REG(par, PM3SizeOfFramebuffer, sofb);
+
+		switch (info->var.bits_per_pixel) {
+		case 8:
+			PM3_WRITE_REG(par, PM3DitherMode,
+					   (1 << 10) | (2 << 3));
+			break;
+		case 16:
+			PM3_WRITE_REG(par, PM3DitherMode,
+					   (1 << 10) | (1 << 3));
+			break;
+		case 32:
+			PM3_WRITE_REG(par, PM3DitherMode,
+					   (1 << 10) | (0 << 3));
+			break;
+		default:
+			DPRINTK(1, "Unsupported depth %d\n",
+				info->current_par->depth);
+			break;
+		}
+	}
+
+	PM3_WRITE_REG(par, PM3dXDom, 0x0);
+	PM3_WRITE_REG(par, PM3dXSub, 0x0);
+	PM3_WRITE_REG(par, PM3dY, (1 << 16));
+	PM3_WRITE_REG(par, PM3StartXDom, 0x0);
+	PM3_WRITE_REG(par, PM3StartXSub, 0x0);
+	PM3_WRITE_REG(par, PM3StartY, 0x0);
+	PM3_WRITE_REG(par, PM3Count, 0x0);
+
+/* Disable LocalBuffer. better safe than sorry */
+	PM3_WRITE_REG(par, PM3LBDestReadMode, 0x0);
+	PM3_WRITE_REG(par, PM3LBDestReadEnables, 0x0);
+	PM3_WRITE_REG(par, PM3LBSourceReadMode, 0x0);
+	PM3_WRITE_REG(par, PM3LBWriteMode, 0x0);
+
+	pm3fb_sync(info);
+}
+
+static void pm3fb_fillrect (struct fb_info *info,
+				const struct fb_fillrect *region)
+{
+	struct pm3_par *par = info->par;
+	struct fb_fillrect modded;
+	int vxres, vyres;
+	u32 color = (info->fix.visual == FB_VISUAL_TRUECOLOR) ?
+		((u32*)info->pseudo_palette)[region->color] : region->color;
+
+	if (info->state != FBINFO_STATE_RUNNING)
+		return;
+	if ((info->flags & FBINFO_HWACCEL_DISABLED) ||
+		region->rop != ROP_COPY ) {
+		cfb_fillrect(info, region);
+		return;
+	}
+
+	vxres = info->var.xres_virtual;
+	vyres = info->var.yres_virtual;
+
+	memcpy(&modded, region, sizeof(struct fb_fillrect));
+
+	if(!modded.width || !modded.height ||
+	   modded.dx >= vxres || modded.dy >= vyres)
+		return;
+
+	if(modded.dx + modded.width  > vxres)
+		modded.width  = vxres - modded.dx;
+	if(modded.dy + modded.height > vyres)
+		modded.height = vyres - modded.dy;
+
+	if(info->var.bits_per_pixel == 8)
+		color |= color << 8;
+	if(info->var.bits_per_pixel <= 16)
+		color |= color << 16;
+
+	PM3_WAIT(par, 4);
+
+	PM3_WRITE_REG(par, PM3Config2D,
+				  PM3Config2D_UseConstantSource |
+				  PM3Config2D_ForegroundROPEnable |
+				  (PM3Config2D_ForegroundROP(0x3)) |	/* Ox3 is GXcopy */
+				  PM3Config2D_FBWriteEnable);
+
+	PM3_WRITE_REG(par, PM3ForegroundColor, color);
+
+	PM3_WRITE_REG(par, PM3RectanglePosition,
+		      (PM3RectanglePosition_XOffset(modded.dx)) |
+		      (PM3RectanglePosition_YOffset(modded.dy)));
+
+	PM3_WRITE_REG(par, PM3Render2D,
+		      PM3Render2D_XPositive |
+		      PM3Render2D_YPositive |
+		      PM3Render2D_Operation_Normal |
+		      PM3Render2D_SpanOperation |
+		      (PM3Render2D_Width(modded.width)) |
+		      (PM3Render2D_Height(modded.height)));
+}
+/* end of acceleration functions */
+
 /* write the mode to registers */
 static void pm3fb_write_mode(struct fb_info *info)
 {
@@ -528,6 +760,7 @@ static int pm3fb_set_par(struct fb_info 
 	pm3fb_clear_colormap(par, 0, 0, 0);
 	PM3_WRITE_DAC_REG(par, PM3RD_CursorMode,
 			  PM3RD_CursorMode_CURSOR_DISABLE);
+	pm3fb_init_engine(info);
 	pm3fb_write_mode(info);
 	return 0;
 }
@@ -675,10 +908,11 @@ static struct fb_ops pm3fb_ops = {
 	.fb_set_par	= pm3fb_set_par,
 	.fb_setcolreg	= pm3fb_setcolreg,
 	.fb_pan_display	= pm3fb_pan_display,
-	.fb_fillrect	= cfb_fillrect,
+	.fb_fillrect	= pm3fb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
 	.fb_blank	= pm3fb_blank,
+	.fb_sync	= pm3fb_sync,
 };
 
 /* ------------------------------------------------------------------------- */
@@ -847,7 +1081,8 @@ static int __devinit pm3fb_probe(struct 
 
 	info->fix = pm3fb_fix;
 	info->pseudo_palette = par->palette;
-	info->flags = FBINFO_DEFAULT;/* | FBINFO_HWACCEL_YPAN;*/
+	info->flags = FBINFO_DEFAULT |
+			FBINFO_HWACCEL_FILLRECT;/* | FBINFO_HWACCEL_YPAN;*/
 
 	/*
 	 * This should give a reasonable default video mode. The following is
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
