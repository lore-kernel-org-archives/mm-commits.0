From: akpm@linux-foundation.org
Subject: + pm2fb-checkpatch-fixes.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:42:20 -0700
Message-ID: <200708012242.l71MgKuv021180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312AbXHAWnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: checkpatch fixes
has been added to the -mm tree.  Its filename is
     pm2fb-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: checkpatch fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes all errors detected by checkpatch.pl script in the pm2fb.c
file.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |  162 +++++++++++++++++++++-------------------
 1 files changed, 88 insertions(+), 74 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-checkpatch-fixes drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-checkpatch-fixes
+++ a/drivers/video/pm2fb.c
@@ -55,9 +55,10 @@
 
 #undef PM2FB_MASTER_DEBUG
 #ifdef PM2FB_MASTER_DEBUG
-#define DPRINTK(a,b...)	printk(KERN_DEBUG "pm2fb: %s: " a, __FUNCTION__ , ## b)
+#define DPRINTK(a, b...)	\
+	printk(KERN_DEBUG "pm2fb: %s: " a, __FUNCTION__ , ## b)
 #else
-#define DPRINTK(a,b...)
+#define DPRINTK(a, b...)
 #endif
 
 #define PM2_PIXMAP_SIZE	(1600 * 4)
@@ -65,7 +66,7 @@
 /*
  * Driver data
  */
-static char *mode __devinitdata = NULL;
+static char *mode __devinitdata;
 
 /*
  * The XFree GLINT driver will (I think to implement hardware cursor
@@ -146,31 +147,31 @@ static struct fb_var_screeninfo pm2fb_va
  * Utility functions
  */
 
-static inline u32 pm2_RD(struct pm2fb_par* p, s32 off)
+static inline u32 pm2_RD(struct pm2fb_par *p, s32 off)
 {
 	return fb_readl(p->v_regs + off);
 }
 
-static inline void pm2_WR(struct pm2fb_par* p, s32 off, u32 v)
+static inline void pm2_WR(struct pm2fb_par *p, s32 off, u32 v)
 {
 	fb_writel(v, p->v_regs + off);
 }
 
-static inline u32 pm2_RDAC_RD(struct pm2fb_par* p, s32 idx)
+static inline u32 pm2_RDAC_RD(struct pm2fb_par *p, s32 idx)
 {
 	pm2_WR(p, PM2R_RD_PALETTE_WRITE_ADDRESS, idx);
 	mb();
 	return pm2_RD(p, PM2R_RD_INDEXED_DATA);
 }
 
-static inline u32 pm2v_RDAC_RD(struct pm2fb_par* p, s32 idx)
+static inline u32 pm2v_RDAC_RD(struct pm2fb_par *p, s32 idx)
 {
 	pm2_WR(p, PM2VR_RD_INDEX_LOW, idx & 0xff);
 	mb();
 	return pm2_RD(p,  PM2VR_RD_INDEXED_DATA);
 }
 
-static inline void pm2_RDAC_WR(struct pm2fb_par* p, s32 idx, u32 v)
+static inline void pm2_RDAC_WR(struct pm2fb_par *p, s32 idx, u32 v)
 {
 	pm2_WR(p, PM2R_RD_PALETTE_WRITE_ADDRESS, idx);
 	wmb();
@@ -178,7 +179,7 @@ static inline void pm2_RDAC_WR(struct pm
 	wmb();
 }
 
-static inline void pm2v_RDAC_WR(struct pm2fb_par* p, s32 idx, u32 v)
+static inline void pm2v_RDAC_WR(struct pm2fb_par *p, s32 idx, u32 v)
 {
 	pm2_WR(p, PM2VR_RD_INDEX_LOW, idx & 0xff);
 	wmb();
@@ -189,9 +190,9 @@ static inline void pm2v_RDAC_WR(struct p
 #ifdef CONFIG_FB_PM2_FIFO_DISCONNECT
 #define WAIT_FIFO(p, a)
 #else
-static inline void WAIT_FIFO(struct pm2fb_par* p, u32 a)
+static inline void WAIT_FIFO(struct pm2fb_par *p, u32 a)
 {
-	while(pm2_RD(p, PM2R_IN_FIFO_SPACE) < a);
+	while (pm2_RD(p, PM2R_IN_FIFO_SPACE) < a);
 	mb();
 }
 #endif
@@ -250,8 +251,8 @@ static u32 to3264(u32 timing, int bpp, i
 	return timing;
 }
 
-static void pm2_mnp(u32 clk, unsigned char* mm, unsigned char* nn,
-		    unsigned char* pp)
+static void pm2_mnp(u32 clk, unsigned char *mm, unsigned char *nn,
+		    unsigned char *pp)
 {
 	unsigned char m;
 	unsigned char n;
@@ -279,8 +280,8 @@ static void pm2_mnp(u32 clk, unsigned ch
 	}
 }
 
-static void pm2v_mnp(u32 clk, unsigned char* mm, unsigned char* nn,
-		     unsigned char* pp)
+static void pm2v_mnp(u32 clk, unsigned char *mm, unsigned char *nn,
+		     unsigned char *pp)
 {
 	unsigned char m;
 	unsigned char n;
@@ -304,7 +305,8 @@ static void pm2v_mnp(u32 clk, unsigned c
 	}
 }
 
-static void clear_palette(struct pm2fb_par* p) {
+static void clear_palette(struct pm2fb_par *p)
+{
 	int i = 256;
 
 	WAIT_FIFO(p, 1);
@@ -318,7 +320,7 @@ static void clear_palette(struct pm2fb_p
 	}
 }
 
-static void reset_card(struct pm2fb_par* p)
+static void reset_card(struct pm2fb_par *p)
 {
 	if (p->type == PM2_TYPE_PERMEDIA2V)
 		pm2_WR(p, PM2VR_RD_INDEX_HIGH, 0);
@@ -341,7 +343,7 @@ static void reset_card(struct pm2fb_par*
 	pm2_WR(p, PM2R_MEM_CONFIG, p->mem_config);
 }
 
-static void reset_config(struct pm2fb_par* p)
+static void reset_config(struct pm2fb_par *p)
 {
 	WAIT_FIFO(p, 53);
 	pm2_WR(p, PM2R_CHIP_CONFIG, pm2_RD(p, PM2R_CHIP_CONFIG) &
@@ -398,7 +400,7 @@ static void reset_config(struct pm2fb_pa
 	}
 }
 
-static void set_aperture(struct pm2fb_par* p, u32 depth)
+static void set_aperture(struct pm2fb_par *p, u32 depth)
 {
 	/*
 	 * The hardware is little-endian. When used in big-endian
@@ -428,11 +430,11 @@ static void set_aperture(struct pm2fb_pa
 	}
 #endif
 
-	// We don't use aperture two, so this may be superflous
+	/* We don't use aperture two, so this may be superflous */
 	pm2_WR(p, PM2R_APERTURE_TWO, PM2F_APERTURE_STANDARD);
 }
 
-static void set_color(struct pm2fb_par* p, unsigned char regno,
+static void set_color(struct pm2fb_par *p, unsigned char regno,
 		      unsigned char r, unsigned char g, unsigned char b)
 {
 	WAIT_FIFO(p, 4);
@@ -445,7 +447,7 @@ static void set_color(struct pm2fb_par* 
 	pm2_WR(p, PM2R_RD_PALETTE_DATA, b);
 }
 
-static void set_memclock(struct pm2fb_par* par, u32 clk)
+static void set_memclock(struct pm2fb_par *par, u32 clk)
 {
 	int i;
 	unsigned char m, n, p;
@@ -482,7 +484,7 @@ static void set_memclock(struct pm2fb_pa
 	}
 }
 
-static void set_pixclock(struct pm2fb_par* par, u32 clk)
+static void set_pixclock(struct pm2fb_par *par, u32 clk)
 {
 	int i;
 	unsigned char m, n, p;
@@ -513,7 +515,8 @@ static void set_pixclock(struct pm2fb_pa
 	}
 }
 
-static void set_video(struct pm2fb_par* p, u32 video) {
+static void set_video(struct pm2fb_par *p, u32 video)
+{
 	u32 tmp;
 	u32 vsync = video;
 
@@ -572,12 +575,14 @@ static int pm2fb_check_var(struct fb_var
 	}
 
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
 
@@ -611,15 +616,18 @@ static int pm2fb_check_var(struct fb_var
 	}
 
 	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
-		DPRINTK("pixclock too high (%ldKHz)\n", PICOS2KHZ(var->pixclock));
+		DPRINTK("pixclock too high (%ldKHz)\n",
+			PICOS2KHZ(var->pixclock));
 		return -EINVAL;
 	}
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
-	switch(var->bits_per_pixel) {
+	switch (var->bits_per_pixel) {
 	case 8:
-		var->red.length = var->green.length = var->blue.length = 8;
+		var->red.length = 8;
+		var->green.length = 8;
+		var->blue.length = 8;
 		break;
 	case 16:
 		var->red.offset   = 11;
@@ -635,7 +643,9 @@ static int pm2fb_check_var(struct fb_var
 		var->red.offset	  = 16;
 		var->green.offset = 8;
 		var->blue.offset  = 0;
-		var->red.length = var->green.length = var->blue.length = 8;
+		var->red.length = 8;
+		var->green.length = 8;
+		var->blue.length = 8;
 		break;
 	case 24:
 #ifdef __BIG_ENDIAN
@@ -646,10 +656,13 @@ static int pm2fb_check_var(struct fb_var
 		var->blue.offset  = 0;
 #endif
 		var->green.offset = 8;
-		var->red.length = var->green.length = var->blue.length = 8;
+		var->red.length = 8;
+		var->green.length = 8;
+		var->blue.length = 8;
 		break;
 	}
-	var->height = var->width = -1;
+	var->height = -1;
+	var->width = -1;
 
 	var->accel_flags = 0;	/* Can't mmap if this is on */
 
@@ -708,7 +721,8 @@ static int pm2fb_set_par(struct fb_info 
 		? info->var.lower_margin - 1
 		: 0;	/* FIXME! */
 	vsend = info->var.lower_margin + info->var.vsync_len - 1;
-	vbend = info->var.lower_margin + info->var.vsync_len + info->var.upper_margin;
+	vbend = info->var.lower_margin + info->var.vsync_len +
+		info->var.upper_margin;
 	vtotal = info->var.yres + vbend - 1;
 	stride = to3264(width, depth, 1);
 	base = to3264(info->var.yoffset * xres + info->var.xoffset, depth, 1);
@@ -721,18 +735,18 @@ static int pm2fb_set_par(struct fb_info 
 			video |= PM2F_HSYNC_ACT_LOW;
 		} else
 			video |= PM2F_HSYNC_ACT_HIGH;
-	}
-	else
+	} else
 		video |= PM2F_HSYNC_ACT_LOW;
+
 	if (info->var.sync & FB_SYNC_VERT_HIGH_ACT) {
 		if (lowvsync) {
 			DPRINTK("ignoring +vsync, using -vsync.\n");
 			video |= PM2F_VSYNC_ACT_LOW;
 		} else
 			video |= PM2F_VSYNC_ACT_HIGH;
-	}
-	else
+	} else
 		video |= PM2F_VSYNC_ACT_LOW;
+
 	if ((info->var.vmode & FB_VMODE_MASK) == FB_VMODE_INTERLACED) {
 		DPRINTK("interlaced not supported\n");
 		return -EINVAL;
@@ -817,7 +831,7 @@ static int pm2fb_set_par(struct fb_info 
 	case PM2_TYPE_PERMEDIA2:
 		pm2_RDAC_WR(par, PM2I_RD_COLOR_MODE, clrmode);
 		pm2_RDAC_WR(par, PM2I_RD_COLOR_KEY_CONTROL,
-			        (depth == 8) ? 0 : PM2F_COLOR_KEY_TEST_OFF);
+				(depth == 8) ? 0 : PM2F_COLOR_KEY_TEST_OFF);
 		break;
 	case PM2_TYPE_PERMEDIA2V:
 		pm2v_RDAC_WR(par, PM2VI_RD_DAC_CONTROL, 0);
@@ -861,10 +875,9 @@ static int pm2fb_setcolreg(unsigned regn
 	 */
 
 	/* grayscale works only partially under directcolor */
-	if (info->var.grayscale) {
-		/* grayscale = 0.30*R + 0.59*G + 0.11*B */
+	/* grayscale = 0.30*R + 0.59*G + 0.11*B */
+	if (info->var.grayscale)
 		red = green = blue = (red * 77 + green * 151 + blue * 28) >> 8;
-	}
 
 	/* Directcolor:
 	 *   var->{color}.offset contains start of bitfield
@@ -931,8 +944,7 @@ static int pm2fb_setcolreg(unsigned regn
 			break;
 		}
 		return 0;
-	}
-	else if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR)
+	} else if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR)
 		set_color(par, regno, red, green, blue);
 
 	return 0;
@@ -1007,7 +1019,7 @@ static int pm2fb_blank(int blank_mode, s
 		break;
 	case FB_BLANK_POWERDOWN:
 		/* HSync: Off, VSync: Off */
-		video &= ~(PM2F_VSYNC_MASK | PM2F_HSYNC_MASK| PM2F_BLANK_LOW);
+		video &= ~(PM2F_VSYNC_MASK | PM2F_HSYNC_MASK | PM2F_BLANK_LOW);
 		break;
 	}
 	set_video(par, video);
@@ -1030,14 +1042,14 @@ static int pm2fb_sync(struct fb_info *in
 	return 0;
 }
 
-static void pm2fb_fillrect (struct fb_info *info,
+static void pm2fb_fillrect(struct fb_info *info,
 				const struct fb_fillrect *region)
 {
-  	struct pm2fb_par *par = info->par;
+	struct pm2fb_par *par = info->par;
 	struct fb_fillrect modded;
 	int vxres, vyres;
 	u32 color = (info->fix.visual == FB_VISUAL_TRUECOLOR) ?
-		((u32*)info->pseudo_palette)[region->color] : region->color;
+		((u32 *)info->pseudo_palette)[region->color] : region->color;
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
@@ -1082,7 +1094,8 @@ static void pm2fb_fillrect (struct fb_in
 		pm2_WR(par, PM2R_CONSTANT_COLOR, color);
 		wmb();
 		pm2_WR(par, PM2R_RENDER,
-				PM2F_RENDER_RECTANGLE | PM2F_INCREASE_X | PM2F_INCREASE_Y );
+				PM2F_RENDER_RECTANGLE |
+				PM2F_INCREASE_X | PM2F_INCREASE_Y );
 		pm2_WR(par, PM2R_COLOR_DDA_MODE, 0);
 	}
 }
@@ -1124,14 +1137,14 @@ static void pm2fb_copyarea(struct fb_inf
 	pm2_WR(par, PM2R_CONFIG, PM2F_CONFIG_FB_WRITE_ENABLE |
 		PM2F_CONFIG_FB_READ_SOURCE_ENABLE);
 	pm2_WR(par, PM2R_FB_SOURCE_DELTA,
-			((modded.sy-modded.dy) & 0xfff) << 16 |
-			((modded.sx-modded.dx) & 0xfff));
+			((modded.sy - modded.dy) & 0xfff) << 16 |
+			((modded.sx - modded.dx) & 0xfff));
 	pm2_WR(par, PM2R_RECTANGLE_ORIGIN, (modded.dy << 16) | modded.dx);
 	pm2_WR(par, PM2R_RECTANGLE_SIZE, (modded.height << 16) | modded.width);
 	wmb();
 	pm2_WR(par, PM2R_RENDER, PM2F_RENDER_RECTANGLE |
-				(modded.dx<modded.sx ? PM2F_INCREASE_X : 0) |
-				(modded.dy<modded.sy ? PM2F_INCREASE_Y : 0));
+				(modded.dx < modded.sx ? PM2F_INCREASE_X : 0) |
+				(modded.dy < modded.sy ? PM2F_INCREASE_Y : 0));
 }
 
 static void pm2fb_imageblit(struct fb_info *info, const struct fb_image *image)
@@ -1139,7 +1152,7 @@ static void pm2fb_imageblit(struct fb_in
 	struct pm2fb_par *par = info->par;
 	u32 height = image->height;
 	u32 fgx, bgx;
-	const u32 *src = (const u32*)image->data;
+	const u32 *src = (const u32 *)image->data;
 	u32 xres = (info->var.xres + 31) & ~31;
 
 	if (info->state != FBINFO_STATE_RUNNING)
@@ -1269,7 +1282,8 @@ static int __devinit pm2fb_probe(struct 
 {
 	struct pm2fb_par *default_par;
 	struct fb_info *info;
-	int err, err_retval = -ENXIO;
+	int err;
+	int retval = -ENXIO;
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -1342,26 +1356,28 @@ static int __devinit pm2fb_probe(struct 
 		default_par->mem_config = 0xe6002021;
 		if (pdev->subsystem_vendor == 0x1048 &&
 			pdev->subsystem_device == 0x0a31) {
-			DPRINTK("subsystem_vendor: %04x, subsystem_device: %04x\n",
+			DPRINTK("subsystem_vendor: %04x, "
+				"subsystem_device: %04x\n",
 				pdev->subsystem_vendor, pdev->subsystem_device);
-			DPRINTK("We have not been initialized by VGA BIOS "
-				"and are running on an Elsa Winner 2000 Office\n");
+			DPRINTK("We have not been initialized by VGA BIOS and "
+				"are running on an Elsa Winner 2000 Office\n");
 			DPRINTK("Initializing card timings manually...\n");
 			default_par->memclock = 100000;
 		}
 		if (pdev->subsystem_vendor == 0x3d3d &&
 			pdev->subsystem_device == 0x0100) {
-			DPRINTK("subsystem_vendor: %04x, subsystem_device: %04x\n",
+			DPRINTK("subsystem_vendor: %04x, "
+				"subsystem_device: %04x\n",
 				pdev->subsystem_vendor, pdev->subsystem_device);
-			DPRINTK("We have not been initialized by VGA BIOS "
-				"and are running on an 3dlabs reference board\n");
+			DPRINTK("We have not been initialized by VGA BIOS and "
+				"are running on an 3dlabs reference board\n");
 			DPRINTK("Initializing card timings manually...\n");
 			default_par->memclock = 74894;
 		}
 	}
 
 	/* Now work out how big lfb is going to be. */
-	switch(default_par->mem_config & PM2F_MEM_CONFIG_RAM_MASK) {
+	switch (default_par->mem_config & PM2F_MEM_CONFIG_RAM_MASK) {
 	case PM2F_MEM_BANKS_1:
 		pm2fb_fix.smem_len = 0x200000;
 		break;
@@ -1411,7 +1427,7 @@ static int __devinit pm2fb_probe(struct 
 
 	info->pixmap.addr = kmalloc(PM2_PIXMAP_SIZE, GFP_KERNEL);
 	if (!info->pixmap.addr) {
-		err_retval = -ENOMEM;
+		retval = -ENOMEM;
 		goto err_exit_pixmap;
 	}
 	info->pixmap.size = PM2_PIXMAP_SIZE;
@@ -1461,7 +1477,7 @@ static int __devinit pm2fb_probe(struct 
 	release_mem_region(pm2fb_fix.mmio_start, pm2fb_fix.mmio_len);
  err_exit_neither:
 	framebuffer_release(info);
-	return err_retval;
+	return retval;
 }
 
 /**
@@ -1473,8 +1489,8 @@ static int __devinit pm2fb_probe(struct 
  */
 static void __devexit pm2fb_remove(struct pci_dev *pdev)
 {
-	struct fb_info* info = pci_get_drvdata(pdev);
-	struct fb_fix_screeninfo* fix = &info->fix;
+	struct fb_info *info = pci_get_drvdata(pdev);
+	struct fb_fix_screeninfo *fix = &info->fix;
 	struct pm2fb_par *par = info->par;
 
 	unregister_framebuffer(info);
@@ -1490,8 +1506,7 @@ static void __devexit pm2fb_remove(struc
 	release_mem_region(fix->mmio_start, fix->mmio_len);
 
 	pci_set_drvdata(pdev, NULL);
-	if (info->pixmap.addr)
-		kfree(info->pixmap.addr);
+	kfree(info->pixmap.addr);
 	kfree(info);
 }
 
@@ -1523,7 +1538,7 @@ MODULE_DEVICE_TABLE(pci, pm2fb_id_table)
  */
 static int __init pm2fb_setup(char *options)
 {
-	char* this_opt;
+	char *this_opt;
 
 	if (!options || !*options)
 		return 0;
@@ -1531,19 +1546,18 @@ static int __init pm2fb_setup(char *opti
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 		if (!*this_opt)
 			continue;
-		if (!strcmp(this_opt, "lowhsync")) {
+		if (!strcmp(this_opt, "lowhsync"))
 			lowhsync = 1;
-		} else if (!strcmp(this_opt, "lowvsync")) {
+		else if (!strcmp(this_opt, "lowvsync"))
 			lowvsync = 1;
 #ifdef CONFIG_MTRR
-		} else if (!strncmp(this_opt, "nomtrr", 6)) {
+		else if (!strncmp(this_opt, "nomtrr", 6))
 			nomtrr = 1;
 #endif
-		} else if (!strncmp(this_opt, "noaccel", 7)) {
+		else if (!strncmp(this_opt, "noaccel", 7))
 			noaccel = 1;
-		} else {
+		else
 			mode = this_opt;
-		}
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
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
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
