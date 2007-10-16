From: akpm@linux-foundation.org
Subject: - pm3fb-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:53 -0700
Message-ID: <200710162042.l9GKgrIV015925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759387AbXJPVRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm3fb: checkpatch fixes
has been removed from the -mm tree.  Its filename was
     pm3fb-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm3fb: checkpatch fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes all errors detected by checkpatch.pl script in the pm3fb.c
file.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |  152 +++++++++++++++++++++-------------------
 1 file changed, 82 insertions(+), 70 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-checkpatch-fixes drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-checkpatch-fixes
+++ a/drivers/video/pm3fb.c
@@ -44,9 +44,10 @@
 
 #undef PM3FB_MASTER_DEBUG
 #ifdef PM3FB_MASTER_DEBUG
-#define DPRINTK(a,b...)	printk(KERN_DEBUG "pm3fb: %s: " a, __FUNCTION__ , ## b)
+#define DPRINTK(a, b...)	\
+	printk(KERN_DEBUG "pm3fb: %s: " a, __FUNCTION__ , ## b)
 #else
-#define DPRINTK(a,b...)
+#define DPRINTK(a, b...)
 #endif
 
 #define PM3_PIXMAP_SIZE	(2048 * 4)
@@ -55,11 +56,11 @@
  * Driver data
  */
 static char *mode_option __devinitdata;
-static int noaccel   __devinitdata = 0;
+static int noaccel __devinitdata;
 
 /* mtrr option */
 #ifdef CONFIG_MTRR
-static int nomtrr __devinitdata = 0;
+static int nomtrr __devinitdata;
 #endif
 
 /*
@@ -72,7 +73,7 @@ static int nomtrr __devinitdata = 0;
 struct pm3_par {
 	unsigned char	__iomem *v_regs;/* virtual address of p_regs */
 	u32		video;		/* video flags before blanking */
-	u32		base;		/* screen base (xoffset+yoffset) in 128 bits unit */
+	u32		base;		/* screen base in 128 bits unit */
 	u32		palette[16];
 	int		mtrr_handle;
 };
@@ -376,7 +377,7 @@ static void pm3fb_init_engine(struct fb_
 	pm3fb_sync(info);
 }
 
-static void pm3fb_fillrect (struct fb_info *info,
+static void pm3fb_fillrect(struct fb_info *info,
 				const struct fb_fillrect *region)
 {
 	struct pm3_par *par = info->par;
@@ -384,7 +385,7 @@ static void pm3fb_fillrect (struct fb_in
 	int vxres, vyres;
 	int rop;
 	u32 color = (info->fix.visual == FB_VISUAL_TRUECOLOR) ?
-		((u32*)info->pseudo_palette)[region->color] : region->color;
+		((u32 *)info->pseudo_palette)[region->color] : region->color;
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
@@ -403,18 +404,18 @@ static void pm3fb_fillrect (struct fb_in
 
 	memcpy(&modded, region, sizeof(struct fb_fillrect));
 
-	if(!modded.width || !modded.height ||
-	   modded.dx >= vxres || modded.dy >= vyres)
+	if (!modded.width || !modded.height ||
+	    modded.dx >= vxres || modded.dy >= vyres)
 		return;
 
-	if(modded.dx + modded.width  > vxres)
+	if (modded.dx + modded.width  > vxres)
 		modded.width  = vxres - modded.dx;
-	if(modded.dy + modded.height > vyres)
+	if (modded.dy + modded.height > vyres)
 		modded.height = vyres - modded.dy;
 
-	if(info->var.bits_per_pixel == 8)
+	if (info->var.bits_per_pixel == 8)
 		color |= color << 8;
-	if(info->var.bits_per_pixel <= 16)
+	if (info->var.bits_per_pixel <= 16)
 		color |= color << 16;
 
 	PM3_WAIT(par, 4);
@@ -460,18 +461,18 @@ static void pm3fb_copyarea(struct fb_inf
 	vxres = info->var.xres_virtual;
 	vyres = info->var.yres_virtual;
 
-	if(!modded.width || !modded.height ||
-	   modded.sx >= vxres || modded.sy >= vyres ||
-	   modded.dx >= vxres || modded.dy >= vyres)
+	if (!modded.width || !modded.height ||
+	    modded.sx >= vxres || modded.sy >= vyres ||
+	    modded.dx >= vxres || modded.dy >= vyres)
 		return;
 
-	if(modded.sx + modded.width > vxres)
+	if (modded.sx + modded.width > vxres)
 		modded.width = vxres - modded.sx;
-	if(modded.dx + modded.width > vxres)
+	if (modded.dx + modded.width > vxres)
 		modded.width = vxres - modded.dx;
-	if(modded.sy + modded.height > vyres)
+	if (modded.sy + modded.height > vyres)
 		modded.height = vyres - modded.sy;
-	if(modded.dy + modded.height > vyres)
+	if (modded.dy + modded.height > vyres)
 		modded.height = vyres - modded.dy;
 
 	o_x = modded.sx - modded.dx;	/*(sx > dx ) ? (sx - dx) : (dx - sx); */
@@ -517,7 +518,7 @@ static void pm3fb_imageblit(struct fb_in
 	struct pm3_par *par = info->par;
 	u32 height = image->height;
 	u32 fgx, bgx;
-	const u32 *src = (const u32*)image->data;
+	const u32 *src = (const u32 *)image->data;
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
@@ -526,19 +527,19 @@ static void pm3fb_imageblit(struct fb_in
 		return;
 	}
 	switch (info->fix.visual) {
-		case FB_VISUAL_PSEUDOCOLOR:
-			fgx = image->fg_color;
-			bgx = image->bg_color;
-			break;
-		case FB_VISUAL_TRUECOLOR:
-		default:
-			fgx = par->palette[image->fg_color];
-			bgx = par->palette[image->bg_color];
-			break;
+	case FB_VISUAL_PSEUDOCOLOR:
+		fgx = image->fg_color;
+		bgx = image->bg_color;
+		break;
+	case FB_VISUAL_TRUECOLOR:
+	default:
+		fgx = par->palette[image->fg_color];
+		bgx = par->palette[image->bg_color];
+		break;
 	}
-	if (image->depth != 1) {
+	if (image->depth != 1)
 		return cfb_imageblit(info, image);
-	}
+
 	if (info->var.bits_per_pixel == 8) {
 		fgx |= fgx << 8;
 		bgx |= bgx << 8;
@@ -607,7 +608,8 @@ static void pm3fb_imageblit(struct fb_in
 static void pm3fb_write_mode(struct fb_info *info)
 {
 	struct pm3_par *par = info->par;
-	char tempsync = 0x00, tempmisc = 0x00;
+	char tempsync = 0x00;
+	char tempmisc = 0x00;
 	const u32 hsstart = info->var.right_margin;
 	const u32 hsend = hsstart + info->var.hsync_len;
 	const u32 hbend = hsend + info->var.left_margin;
@@ -807,44 +809,54 @@ static int pm3fb_check_var(struct fb_var
 	if (bpp != var->bits_per_pixel) {
 		/* set predefined mode for bits_per_pixel settings */
 
-		switch(var->bits_per_pixel) {
+		switch (var->bits_per_pixel) {
 		case 8:
-			var->red.length = var->green.length = var->blue.length = 8;
-			var->red.offset = var->green.offset = var->blue.offset = 0;
+			var->red.length = 8;
+			var->green.length = 8;
+			var->blue.length = 8;
+			var->red.offset = 0;
+			var->green.offset = 0;
+			var->blue.offset = 0;
 			var->transp.offset = 0;
 			var->transp.length = 0;
 			break;
 		case 16:
-			var->red.length = var->blue.length = 5;
+			var->red.length = 5;
+			var->blue.length = 5;
 			var->green.length = 6;
 			var->transp.length = 0;
 			break;
 		case 32:
-			var->red.length = var->green.length = var->blue.length = 8;
+			var->red.length = 8;
+			var->green.length = 8;
+			var->blue.length = 8;
 			var->transp.length = 8;
 			break;
 		default:
-			DPRINTK("depth not supported: %u\n", var->bits_per_pixel);
+			DPRINTK("depth not supported: %u\n",
+				var->bits_per_pixel);
 			return -EINVAL;
 		}
 	}
 	/* it is assumed BGRA order */
-	if (var->bits_per_pixel > 8 )
-	{
+	if (var->bits_per_pixel > 8 ) {
 		var->blue.offset = 0;
 		var->green.offset = var->blue.length;
 		var->red.offset = var->green.offset + var->green.length;
 		var->transp.offset = var->red.offset + var->red.length;
 	}
-	var->height = var->width = -1;
+	var->height = -1;
+	var->width = -1;
 
 	if (var->xres != var->xres_virtual) {
-		DPRINTK("virtual x resolution != physical x resolution not supported\n");
+		DPRINTK("virtual x resolution != "
+			"physical x resolution not supported\n");
 		return -EINVAL;
 	}
 
 	if (var->yres > var->yres_virtual) {
-		DPRINTK("virtual y resolution < physical y resolution not possible\n");
+		DPRINTK("virtual y resolution < "
+			"physical y resolution not possible\n");
 		return -EINVAL;
 	}
 
@@ -878,7 +890,8 @@ static int pm3fb_check_var(struct fb_var
 	}
 
 	if (PICOS2KHZ(var->pixclock) > PM3_MAX_PIXCLOCK) {
-		DPRINTK("pixclock too high (%ldKHz)\n", PICOS2KHZ(var->pixclock));
+		DPRINTK("pixclock too high (%ldKHz)\n",
+			PICOS2KHZ(var->pixclock));
 		return -EINVAL;
 	}
 
@@ -895,7 +908,7 @@ static int pm3fb_set_par(struct fb_info 
 	const u32 xres = (info->var.xres + 31) & ~31;
 	const unsigned bpp = info->var.bits_per_pixel;
 
-	par->base = pm3fb_shift_bpp(bpp,(info->var.yoffset * xres)
+	par->base = pm3fb_shift_bpp(bpp, (info->var.yoffset * xres)
 					+ info->var.xoffset);
 	par->video = 0;
 
@@ -954,10 +967,9 @@ static int pm3fb_setcolreg(unsigned regn
 	   return -EINVAL;
 
 	/* grayscale works only partially under directcolor */
-	if (info->var.grayscale) {
-	   /* grayscale = 0.30*R + 0.59*G + 0.11*B */
+	/* grayscale = 0.30*R + 0.59*G + 0.11*B */
+	if (info->var.grayscale)
 	   red = green = blue = (red * 77 + green * 151 + blue * 28) >> 8;
-	}
 
 	/* Directcolor:
 	 *   var->{color}.offset contains start of bitfield
@@ -971,8 +983,8 @@ static int pm3fb_setcolreg(unsigned regn
 	 *
 	 * Pseudocolor:
 	 *	var->{color}.offset is 0
-	 *	var->{color}.length contains width of DAC or the number of unique
-	 *			colors available (color depth)
+	 *	var->{color}.length contains width of DAC or the number
+	 *			of unique colors available (color depth)
 	 *	pseudo_palette is not used
 	 *	RAMDAC[X] is programmed to (red, green, blue)
 	 *	color depth = var->{color}.length
@@ -982,7 +994,7 @@ static int pm3fb_setcolreg(unsigned regn
 	 * This is the point where the color is converted to something that
 	 * is acceptable by the hardware.
 	 */
-#define CNVT_TOHW(val,width) ((((val)<<(width))+0x7FFF-(val))>>16)
+#define CNVT_TOHW(val, width) ((((val) << (width)) + 0x7FFF - (val)) >> 16)
 	red = CNVT_TOHW(red, info->var.red.length);
 	green = CNVT_TOHW(green, info->var.green.length);
 	blue = CNVT_TOHW(blue, info->var.blue.length);
@@ -1006,12 +1018,11 @@ static int pm3fb_setcolreg(unsigned regn
 			break;
 		case 16:
 		case 32:
-			((u32*)(info->pseudo_palette))[regno] = v;
+			((u32 *)(info->pseudo_palette))[regno] = v;
 			break;
 		}
 		return 0;
-	}
-	else if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR)
+	} else if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR)
 		pm3fb_set_color(par, regno, red, green, blue);
 
 	return 0;
@@ -1073,7 +1084,7 @@ static int pm3fb_blank(int blank_mode, s
 	}
 
 	PM3_WAIT(par, 1);
-	PM3_WRITE_REG(par,PM3VideoControl, video);
+	PM3_WRITE_REG(par, PM3VideoControl, video);
 	return 0;
 }
 
@@ -1104,7 +1115,8 @@ static struct fb_ops pm3fb_ops = {
 /* the pm3fb_fix.smem_start is also set */
 static unsigned long pm3fb_size_memory(struct pm3_par *par)
 {
-	unsigned long	memsize = 0, tempBypass, i, temp1, temp2;
+	unsigned long	memsize = 0;
+	unsigned long	tempBypass, i, temp1, temp2;
 	unsigned char	__iomem *screen_mem;
 
 	pm3fb_fix.smem_len = 64 * 1024l * 1024; /* request full aperture size */
@@ -1132,7 +1144,9 @@ static unsigned long pm3fb_size_memory(s
 	PM3_WAIT(par, 1);
 	PM3_WRITE_REG(par, PM3MemBypassWriteMask, 0xFFFFFFFF);
 
-	/* pm3 split up memory, replicates, and do a lot of nasty stuff IMHO ;-) */
+	/* pm3 split up memory, replicates, and do a lot of
+	 * nasty stuff IMHO ;-)
+	 */
 	for (i = 0; i < 32; i++) {
 		fb_writel(i * 0x00345678,
 			  (screen_mem + (i * 1048576)));
@@ -1189,8 +1203,9 @@ static int __devinit pm3fb_probe(struct 
 {
 	struct fb_info *info;
 	struct pm3_par *par;
-	struct device* device = &dev->dev; /* for pci drivers */
-	int err, retval = -ENXIO;
+	struct device *device = &dev->dev; /* for pci drivers */
+	int err;
+	int retval = -ENXIO;
 
 	err = pci_enable_device(dev);
 	if (err) {
@@ -1235,8 +1250,7 @@ static int __devinit pm3fb_probe(struct 
 	/* Linear frame buffer - request region and map it. */
 	pm3fb_fix.smem_start = pci_resource_start(dev, 1);
 	pm3fb_fix.smem_len = pm3fb_size_memory(par);
-	if (!pm3fb_fix.smem_len)
-	{
+	if (!pm3fb_fix.smem_len) {
 		printk(KERN_WARNING "pm3fb: Can't find memory on board.\n");
 		goto err_exit_mmio;
 	}
@@ -1255,11 +1269,10 @@ static int __devinit pm3fb_probe(struct 
 	info->screen_size = pm3fb_fix.smem_len;
 
 #ifdef CONFIG_MTRR
-	if (!nomtrr) {
+	if (!nomtrr)
 		par->mtrr_handle = mtrr_add(pm3fb_fix.smem_start,
 						pm3fb_fix.smem_len,
 						MTRR_TYPE_WRCOMB, 1);
-	}
 #endif
 	info->fbops = &pm3fb_ops;
 
@@ -1275,8 +1288,8 @@ static int __devinit pm3fb_probe(struct 
 			FBINFO_HWACCEL_FILLRECT;
 
 	if (noaccel) {
-	    	printk(KERN_DEBUG "disabling acceleration\n");
-  		info->flags |= FBINFO_HWACCEL_DISABLED;
+		printk(KERN_DEBUG "disabling acceleration\n");
+		info->flags |= FBINFO_HWACCEL_DISABLED;
 	}
 	info->pixmap.addr = kmalloc(PM3_PIXMAP_SIZE, GFP_KERNEL);
 	if (!info->pixmap.addr) {
@@ -1403,15 +1416,14 @@ static int __init pm3fb_setup(char *opti
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 		if (!*this_opt)
 			continue;
-		else if (!strncmp(this_opt, "noaccel", 7)) {
+		else if (!strncmp(this_opt, "noaccel", 7))
 			noaccel = 1;
 #ifdef CONFIG_MTRR
-		} else if (!strncmp(this_opt, "nomtrr", 6)) {
+		else if (!strncmp(this_opt, "nomtrr", 6))
 			nomtrr = 1;
 #endif
-		} else {
+		else
 			mode_option = this_opt;
-		}
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
