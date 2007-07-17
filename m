From: akpm@linux-foundation.org
Subject: - pm2fb-white-spaces-clean-up.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:59 -0700
Message-ID: <200707172306.l6HN6xZG012068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40339 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936494AbXGQXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     pm2fb: white spaces clean up
has been removed from the -mm tree.  Its filename was
     pm2fb-white-spaces-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm2fb: white spaces clean up
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch removes trailing spaces and tabs and spaces before tabs.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |  202 ++++++++++++++++++++--------------------
 1 file changed, 101 insertions(+), 101 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-white-spaces-clean-up drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-white-spaces-clean-up
+++ a/drivers/video/pm2fb.c
@@ -24,7 +24,7 @@
  * License. See the file COPYING in the main directory of this archive for
  * more details.
  *
- * 
+ *
  */
 
 #include <linux/module.h>
@@ -58,7 +58,7 @@
 #endif
 
 /*
- * Driver data 
+ * Driver data
  */
 static char *mode __devinitdata = NULL;
 
@@ -82,12 +82,12 @@ struct pm2fb_par
 {
 	pm2type_t	type;		/* Board type */
 	unsigned char	__iomem *v_regs;/* virtual address of p_regs */
-	u32 	   	memclock;	/* memclock */
+	u32		memclock;	/* memclock */
 	u32		video;		/* video flags before blanking */
 	u32		mem_config;	/* MemConfig reg at probe */
 	u32		mem_control;	/* MemControl reg at probe */
 	u32		boot_address;	/* BootAddress reg at probe */
-	u32             palette[16];
+	u32		palette[16];
 };
 
 /*
@@ -95,12 +95,12 @@ struct pm2fb_par
  * if we don't use modedb.
  */
 static struct fb_fix_screeninfo pm2fb_fix __devinitdata = {
-	.id =		"", 
+	.id =		"",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_PSEUDOCOLOR,
 	.xpanstep =	1,
 	.ypanstep =	1,
-	.ywrapstep =	0, 
+	.ywrapstep =	0,
 	.accel =	FB_ACCEL_3DLABS_PERMEDIA2,
 };
 
@@ -109,26 +109,26 @@ static struct fb_fix_screeninfo pm2fb_fi
  */
 static struct fb_var_screeninfo pm2fb_var __devinitdata = {
 	/* "640x480, 8 bpp @ 60 Hz */
-	.xres =		640,
-	.yres =		480,
-	.xres_virtual =	640,
-	.yres_virtual =	480,
-	.bits_per_pixel =8,
-	.red =		{0, 8, 0},
-	.blue =		{0, 8, 0},
-	.green =	{0, 8, 0},
-	.activate =	FB_ACTIVATE_NOW,
-	.height =	-1,
-	.width =	-1,
-	.accel_flags =	0,
-	.pixclock =	39721,
-	.left_margin =	40,
-	.right_margin =	24,
-	.upper_margin =	32,
-	.lower_margin =	11,
-	.hsync_len =	96,
-	.vsync_len =	2,
-	.vmode =	FB_VMODE_NONINTERLACED
+	.xres =			640,
+	.yres =			480,
+	.xres_virtual =		640,
+	.yres_virtual =		480,
+	.bits_per_pixel =	8,
+	.red =			{0, 8, 0},
+	.blue =			{0, 8, 0},
+	.green =		{0, 8, 0},
+	.activate =		FB_ACTIVATE_NOW,
+	.height =		-1,
+	.width =		-1,
+	.accel_flags =		0,
+	.pixclock =		39721,
+	.left_margin =		40,
+	.right_margin =		24,
+	.upper_margin =		32,
+	.lower_margin =		11,
+	.hsync_len =		96,
+	.vsync_len =		2,
+	.vmode =		FB_VMODE_NONINTERLACED
 };
 
 /*
@@ -166,7 +166,7 @@ static inline u32 pm2_RDAC_RD(struct pm2
 		pm2_WR(p, PM2VR_RD_INDEX_LOW, idx & 0xff);
 		index = PM2VR_RD_INDEXED_DATA;
 		break;
-	}	
+	}
 	mb();
 	return pm2_RD(p, index);
 }
@@ -182,7 +182,7 @@ static inline void pm2_RDAC_WR(struct pm
 		pm2_WR(p, PM2VR_RD_INDEX_LOW, idx & 0xff);
 		index = PM2VR_RD_INDEXED_DATA;
 		break;
-	}	
+	}
 	wmb();
 	pm2_WR(p, index, v);
 	wmb();
@@ -197,7 +197,7 @@ static inline void pm2v_RDAC_WR(struct p
 }
 
 #ifdef CONFIG_FB_PM2_FIFO_DISCONNECT
-#define WAIT_FIFO(p,a)
+#define WAIT_FIFO(p, a)
 #else
 static inline void WAIT_FIFO(struct pm2fb_par* p, u32 a)
 {
@@ -209,7 +209,7 @@ static inline void WAIT_FIFO(struct pm2f
 /*
  * partial products for the supported horizontal resolutions.
  */
-#define PACKPP(p0,p1,p2)	(((p2) << 6) | ((p1) << 3) | (p0))
+#define PACKPP(p0, p1, p2)	(((p2) << 6) | ((p1) << 3) | (p0))
 static const struct {
 	u16 width;
 	u16 pp;
@@ -357,7 +357,7 @@ static void reset_card(struct pm2fb_par*
 static void reset_config(struct pm2fb_par* p)
 {
 	WAIT_FIFO(p, 52);
-	pm2_WR(p, PM2R_CHIP_CONFIG, pm2_RD(p, PM2R_CHIP_CONFIG)&
+	pm2_WR(p, PM2R_CHIP_CONFIG, pm2_RD(p, PM2R_CHIP_CONFIG) &
 	       ~(PM2F_VGA_ENABLE|PM2F_VGA_FIXED));
 	pm2_WR(p, PM2R_BYPASS_WRITE_MASK, ~(0L));
 	pm2_WR(p, PM2R_FRAMEBUFFER_WRITE_MASK, ~(0L));
@@ -367,7 +367,7 @@ static void reset_config(struct pm2fb_pa
 	pm2_WR(p, PM2R_RASTERIZER_MODE, 0);
 	pm2_WR(p, PM2R_DELTA_MODE, PM2F_DELTA_ORDER_RGB);
 	pm2_WR(p, PM2R_LB_READ_FORMAT, 0);
-	pm2_WR(p, PM2R_LB_WRITE_FORMAT, 0); 
+	pm2_WR(p, PM2R_LB_WRITE_FORMAT, 0);
 	pm2_WR(p, PM2R_LB_READ_MODE, 0);
 	pm2_WR(p, PM2R_LB_SOURCE_OFFSET, 0);
 	pm2_WR(p, PM2R_FB_SOURCE_OFFSET, 0);
@@ -535,7 +535,7 @@ static void set_video(struct pm2fb_par* 
 	vsync = video;
 
 	DPRINTK("video = 0x%x\n", video);
-	
+
 	/*
 	 * The hardware cursor needs +vsync to recognise vert retrace.
 	 * We may not be using the hardware cursor, but the X Glint
@@ -574,9 +574,9 @@ static void set_video(struct pm2fb_par* 
  */
 
 /**
- *      pm2fb_check_var - Optional function. Validates a var passed in. 
- *      @var: frame buffer variable screen structure
- *      @info: frame buffer structure that represents a single frame buffer 
+ *	pm2fb_check_var - Optional function. Validates a var passed in.
+ *	@var: frame buffer variable screen structure
+ *	@info: frame buffer structure that represents a single frame buffer
  *
  *	Checks to see if the hardware supports the state requested by
  *	var passed in.
@@ -615,23 +615,23 @@ static int pm2fb_check_var(struct fb_var
 
 	var->xres = (var->xres + 15) & ~15; /* could sometimes be 8 */
 	lpitch = var->xres * ((var->bits_per_pixel + 7)>>3);
-  
+
 	if (var->xres < 320 || var->xres > 1600) {
 		DPRINTK("width not supported: %u\n", var->xres);
 		return -EINVAL;
 	}
-  
+
 	if (var->yres < 200 || var->yres > 1200) {
 		DPRINTK("height not supported: %u\n", var->yres);
 		return -EINVAL;
 	}
-  
+
 	if (lpitch * var->yres_virtual > info->fix.smem_len) {
 		DPRINTK("no memory for screen (%ux%ux%u)\n",
 			var->xres, var->yres_virtual, var->bits_per_pixel);
 		return -EINVAL;
 	}
-  
+
 	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
 		DPRINTK("pixclock too high (%ldKHz)\n", PICOS2KHZ(var->pixclock));
 		return -EINVAL;
@@ -672,17 +672,17 @@ static int pm2fb_check_var(struct fb_var
 		break;
 	}
 	var->height = var->width = -1;
-  
+
 	var->accel_flags = 0;	/* Can't mmap if this is on */
-	
+
 	DPRINTK("Checking graphics mode at %dx%d depth %d\n",
 		var->xres, var->yres, var->bits_per_pixel);
 	return 0;
 }
 
 /**
- *      pm2fb_set_par - Alters the hardware state.
- *      @info: frame buffer structure that represents a single frame buffer
+ *	pm2fb_set_par - Alters the hardware state.
+ *	@info: frame buffer structure that represents a single frame buffer
  *
  *	Using the fb_var_screeninfo in fb_info we set the resolution of the
  *	this particular framebuffer.
@@ -709,7 +709,7 @@ static int pm2fb_set_par(struct fb_info 
 	clear_palette(par);
 	if ( par->memclock )
 		set_memclock(par, par->memclock);
-    
+
 	width = (info->var.xres_virtual + 7) & ~7;
 	height = info->var.yres_virtual;
 	depth = (info->var.bits_per_pixel + 7) & ~7;
@@ -722,7 +722,7 @@ static int pm2fb_set_par(struct fb_info 
 		DPRINTK("pixclock too high (%uKHz)\n", pixclock);
 		return -EINVAL;
 	}
-    
+
 	hsstart = to3264(info->var.right_margin, depth, data64);
 	hsend = hsstart + to3264(info->var.hsync_len, depth, data64);
 	hbend = hsend + to3264(info->var.left_margin, depth, data64);
@@ -737,7 +737,7 @@ static int pm2fb_set_par(struct fb_info 
 	base = to3264(info->var.yoffset * xres + info->var.xoffset, depth, 1);
 	if (data64)
 		video |= PM2F_DATA_64_ENABLE;
-    
+
 	if (info->var.sync & FB_SYNC_HOR_HIGH_ACT) {
 		if (lowhsync) {
 			DPRINTK("ignoring +hsync, using -hsync.\n");
@@ -778,9 +778,9 @@ static int pm2fb_set_par(struct fb_info 
 		WAIT_FIFO(par, 1);
 		pm2_WR(par, PM2VR_RD_INDEX_HIGH, 0);
 	}
-    
+
 	set_aperture(par, depth);
-    
+
 	mb();
 	WAIT_FIFO(par, 19);
 	pm2_RDAC_WR(par, PM2I_RD_COLOR_KEY_CONTROL,
@@ -847,22 +847,22 @@ static int pm2fb_set_par(struct fb_info 
 	set_pixclock(par, pixclock);
 	DPRINTK("Setting graphics mode at %dx%d depth %d\n",
 		info->var.xres, info->var.yres, info->var.bits_per_pixel);
-	return 0;	
+	return 0;
 }
 
 /**
- *  	pm2fb_setcolreg - Sets a color register.
- *      @regno: boolean, 0 copy local, 1 get_user() function
- *      @red: frame buffer colormap structure
- *	@green: The green value which can be up to 16 bits wide 
+ *	pm2fb_setcolreg - Sets a color register.
+ *	@regno: boolean, 0 copy local, 1 get_user() function
+ *	@red: frame buffer colormap structure
+ *	@green: The green value which can be up to 16 bits wide
  *	@blue:  The blue value which can be up to 16 bits wide.
- *	@transp: If supported the alpha value which can be up to 16 bits wide.	
- *      @info: frame buffer info structure
- * 
- *  	Set a single color register. The values supplied have a 16 bit
- *  	magnitude which needs to be scaled in this function for the hardware.
+ *	@transp: If supported the alpha value which can be up to 16 bits wide.
+ *	@info: frame buffer info structure
+ *
+ *	Set a single color register. The values supplied have a 16 bit
+ *	magnitude which needs to be scaled in this function for the hardware.
  *	Pretty much a direct lift from tdfxfb.c.
- * 
+ *
  *	Returns negative errno on error, or zero on success.
  */
 static int pm2fb_setcolreg(unsigned regno, unsigned red, unsigned green,
@@ -906,7 +906,7 @@ static int pm2fb_setcolreg(unsigned regn
 	 *    (blue << blue.offset) | (transp << transp.offset)
 	 *    RAMDAC does not exist
 	 */
-#define CNVT_TOHW(val,width) ((((val)<<(width))+0x7FFF-(val))>>16)
+#define CNVT_TOHW(val, width) ((((val) << (width)) + 0x7FFF -(val)) >> 16)
 	switch (info->fix.visual) {
 	case FB_VISUAL_TRUECOLOR:
 	case FB_VISUAL_PSEUDOCOLOR:
@@ -916,9 +916,9 @@ static int pm2fb_setcolreg(unsigned regn
 		transp = CNVT_TOHW(transp, info->var.transp.length);
 		break;
 	case FB_VISUAL_DIRECTCOLOR:
-		/* example here assumes 8 bit DAC. Might be different 
-		 * for your hardware */	
-		red = CNVT_TOHW(red, 8);       
+		/* example here assumes 8 bit DAC. Might be different
+		 * for your hardware */
+		red = CNVT_TOHW(red, 8);
 		green = CNVT_TOHW(green, 8);
 		blue = CNVT_TOHW(blue, 8);
 		/* hey, there is bug in transp handling... */
@@ -940,11 +940,11 @@ static int pm2fb_setcolreg(unsigned regn
 
 		switch (info->var.bits_per_pixel) {
 		case 8:
-			break;	
-   		case 16:
+			break;
+		case 16:
 		case 24:
-		case 32:	
-           		par->palette[regno] = v;
+		case 32:
+			par->palette[regno] = v;
 			break;
 		}
 		return 0;
@@ -956,15 +956,15 @@ static int pm2fb_setcolreg(unsigned regn
 }
 
 /**
- *      pm2fb_pan_display - Pans the display.
- *      @var: frame buffer variable screen structure
- *      @info: frame buffer structure that represents a single frame buffer
+ *	pm2fb_pan_display - Pans the display.
+ *	@var: frame buffer variable screen structure
+ *	@info: frame buffer structure that represents a single frame buffer
  *
  *	Pan (or wrap, depending on the `vmode' field) the display using the
- *  	`xoffset' and `yoffset' fields of the `var' structure.
- *  	If the values don't fit, return -EINVAL.
+ *	`xoffset' and `yoffset' fields of the `var' structure.
+ *	If the values don't fit, return -EINVAL.
  *
- *      Returns negative errno on error, or zero on success.
+ *	Returns negative errno on error, or zero on success.
  *
  */
 static int pm2fb_pan_display(struct fb_var_screeninfo *var,
@@ -980,24 +980,24 @@ static int pm2fb_pan_display(struct fb_v
 	depth = (depth > 32) ? 32 : depth;
 	base = to3264(var->yoffset * xres + var->xoffset, depth, 1);
 	WAIT_FIFO(p, 1);
-	pm2_WR(p, PM2R_SCREEN_BASE, base);    
+	pm2_WR(p, PM2R_SCREEN_BASE, base);
 	return 0;
 }
 
 /**
- *      pm2fb_blank - Blanks the display.
- *      @blank_mode: the blank mode we want. 
- *      @info: frame buffer structure that represents a single frame buffer
+ *	pm2fb_blank - Blanks the display.
+ *	@blank_mode: the blank mode we want.
+ *	@info: frame buffer structure that represents a single frame buffer
  *
- *      Blank the screen if blank_mode != 0, else unblank. Return 0 if
- *      blanking succeeded, != 0 if un-/blanking failed due to e.g. a 
- *      video mode which doesn't support it. Implements VESA suspend
- *      and powerdown modes on hardware that supports disabling hsync/vsync:
- *      blank_mode == 2: suspend vsync
- *      blank_mode == 3: suspend hsync
- *      blank_mode == 4: powerdown
+ *	Blank the screen if blank_mode != 0, else unblank. Return 0 if
+ *	blanking succeeded, != 0 if un-/blanking failed due to e.g. a
+ *	video mode which doesn't support it. Implements VESA suspend
+ *	and powerdown modes on hardware that supports disabling hsync/vsync:
+ *	blank_mode == 2: suspend vsync
+ *	blank_mode == 3: suspend hsync
+ *	blank_mode == 4: powerdown
  *
- *      Returns negative errno on error, or zero on success.
+ *	Returns negative errno on error, or zero on success.
  *
  */
 static int pm2fb_blank(int blank_mode, struct fb_info *info)
@@ -1071,7 +1071,7 @@ static void pm2fb_block_op(struct fb_inf
 	pm2_WR(par, PM2R_RECTANGLE_ORIGIN, (y << 16) | x);
 	pm2_WR(par, PM2R_RECTANGLE_SIZE, (h << 16) | w);
 	wmb();
-	pm2_WR(par, PM2R_RENDER,PM2F_RENDER_RECTANGLE |
+	pm2_WR(par, PM2R_RENDER, PM2F_RENDER_RECTANGLE |
 				(x<xsrc ? PM2F_INCREASE_X : 0) |
 				(y<ysrc ? PM2F_INCREASE_Y : 0) |
 				(copy ? 0 : PM2F_RENDER_FASTFILL));
@@ -1234,7 +1234,7 @@ static int __devinit pm2fb_probe(struct 
 	DPRINTK("Adjusting register base for big-endian.\n");
 #endif
 	DPRINTK("Register base at 0x%lx\n", pm2fb_fix.mmio_start);
-    
+
 	/* Registers - request region and map it. */
 	if ( !request_mem_region(pm2fb_fix.mmio_start, pm2fb_fix.mmio_len,
 				 "pm2fb regbase") ) {
@@ -1317,17 +1317,17 @@ static int __devinit pm2fb_probe(struct 
 	}
 
 	info->fbops		= &pm2fb_ops;
-	info->fix		= pm2fb_fix; 	
+	info->fix		= pm2fb_fix;
 	info->pseudo_palette	= default_par->palette;
 	info->flags		= FBINFO_DEFAULT |
-                                  FBINFO_HWACCEL_YPAN |
-	                          FBINFO_HWACCEL_COPYAREA |
-	                          FBINFO_HWACCEL_FILLRECT;
+				  FBINFO_HWACCEL_YPAN |
+				  FBINFO_HWACCEL_COPYAREA |
+				  FBINFO_HWACCEL_FILLRECT;
 
 	if (!mode)
 		mode = "640x480@60";
-	 
-	err = fb_find_mode(&info->var, info, mode, NULL, 0, NULL, 8); 
+
+	err = fb_find_mode(&info->var, info, mode, NULL, 0, NULL, 8);
 	if (!err || err == 4)
 		info->var = pm2fb_var;
 
@@ -1348,8 +1348,8 @@ static int __devinit pm2fb_probe(struct 
 	return 0;
 
  err_exit_all:
-	fb_dealloc_cmap(&info->cmap);	
- err_exit_both:    
+	fb_dealloc_cmap(&info->cmap);
+ err_exit_both:
 	iounmap(info->screen_base);
 	release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
  err_exit_mmio:
@@ -1374,7 +1374,7 @@ static void __devexit pm2fb_remove(struc
 	struct pm2fb_par *par = info->par;
 
 	unregister_framebuffer(info);
-    
+
 	iounmap(info->screen_base);
 	release_mem_region(fix->smem_start, fix->smem_len);
 	iounmap(par->v_regs);
@@ -1402,9 +1402,9 @@ static struct pci_device_id pm2fb_id_tab
 
 static struct pci_driver pm2fb_driver = {
 	.name		= "pm2fb",
-	.id_table 	= pm2fb_id_table,
-	.probe 		= pm2fb_probe,
-	.remove 	= __devexit_p(pm2fb_remove),
+	.id_table	= pm2fb_id_table,
+	.probe		= pm2fb_probe,
+	.remove		= __devexit_p(pm2fb_remove),
 };
 
 MODULE_DEVICE_TABLE(pci, pm2fb_id_table);
@@ -1423,7 +1423,7 @@ static int __init pm2fb_setup(char *opti
 	if (!options || !*options)
 		return 0;
 
-	while ((this_opt = strsep(&options, ",")) != NULL) {	
+	while ((this_opt = strsep(&options, ",")) != NULL) {
 		if (!*this_opt)
 			continue;
 		if(!strcmp(this_opt, "lowhsync")) {
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
