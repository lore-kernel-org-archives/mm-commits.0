From: akpm@osdl.org
Subject: - sstfb-add-sysfs-interface.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:19:33 -0800
Message-ID: <200612140619.kBE6JWMX002372@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52844 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbWLNGUF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:20:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     sstfb: add sysfs interface
has been removed from the -mm tree.  Its filename was
     sstfb-add-sysfs-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sstfb: add sysfs interface
From: Helge Deller <deller@gmx.de>

Modify the sstfb (Voodoo1/2) driver:

- fix a memleak when removing the sstfb module

- fix sstfb to use the fbdev default videomode database

- add module option "mode_option" to set initial screen mode

- add sysfs-interface to turn VGA-passthrough on/off via
  /sys/class/graphics/fbX/vgapass

- remove old debug functions from ioctl interface

Signed-off-by: Helge Deller <deller@gmx.de>
Acked-By: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/sstfb.c |  335 ++++++++++++----------------------------
 include/video/sstfb.h |   13 +
 2 files changed, 114 insertions(+), 234 deletions(-)

diff -puN drivers/video/sstfb.c~sstfb-add-sysfs-interface drivers/video/sstfb.c
--- a/drivers/video/sstfb.c~sstfb-add-sysfs-interface
+++ a/drivers/video/sstfb.c
@@ -21,6 +21,11 @@
  *	Remove never finished and bogus 24/32bit support
  *	Clean up macro abuse
  *	Minor tidying for format.
+ * 12/2006 Helge Deller    <deller@gmx.de>
+ *	add /sys/class/graphics/fbX/vgapass sysfs-interface
+ *	add module option "mode_option" to set initial screen mode
+ *	use fbdev default videomode database
+ *	remove debug functions from ioctl
  */
 
 /*
@@ -65,19 +70,10 @@
  *
  * sstfb specific ioctls:
  *   		toggle vga (0x46db) : toggle vga_pass_through
- *   		fill fb    (0x46dc) : fills fb
- *   		test disp  (0x46de) : draws a test image
  */
 
 #undef SST_DEBUG
 
-/*
-  Default video mode .
-  0 800x600@60  took from glide
-  1 640x480@75  took from glide
-  2 1024x768@76 std fb.mode
-  3 640x480@60  glide default */
-#define DEFAULT_MODE 3 
 
 /*
  * Includes
@@ -92,20 +88,24 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <asm/io.h>
-#include <asm/ioctl.h>
 #include <asm/uaccess.h>
 #include <video/sstfb.h>
 
 
 /* initialized by setup */
 
-static int vgapass;		/* enable Vga passthrough cable */
+static int vgapass;		/* enable VGA passthrough cable */
 static int mem;			/* mem size in MB, 0 = autodetect */
 static int clipping = 1;	/* use clipping (slower, safer) */
 static int gfxclk;		/* force FBI freq in Mhz . Dangerous */
 static int slowpci;		/* slow PCI settings */
 
-static char *mode_option __devinitdata;
+/*
+  Possible default video modes: 800x600@60, 640x480@75, 1024x768@76, 640x480@60
+*/
+#define DEFAULT_VIDEO_MODE "640x480@60"
+
+static char *mode_option __devinitdata = DEFAULT_VIDEO_MODE;
 
 enum {
 	ID_VOODOO1 = 0,
@@ -119,48 +119,11 @@ static struct sst_spec voodoo_spec[] __d
  { .name = "Voodoo2",	      .default_gfx_clock = 75000, .max_gfxclk = 85 },
 };
 
-static struct fb_var_screeninfo	sstfb_default =
-#if ( DEFAULT_MODE == 0 )
-    { /* 800x600@60, 16 bpp .borowed from glide/sst1/include/sst1init.h */
-    800, 600, 800, 600, 0, 0, 16, 0,
-    {11, 5, 0}, {5, 6, 0}, {0, 5, 0}, {0, 0, 0},
-    0, 0, -1, -1, 0,
-    25000, 86, 41, 23, 1, 127, 4,
-    0, FB_VMODE_NONINTERLACED };
-#elif ( DEFAULT_MODE == 1 )
-    {/* 640x480@75, 16 bpp .borowed from glide/sst1/include/sst1init.h */
-    640, 480, 640, 480, 0, 0, 16, 0,
-    {11, 5, 0}, {5, 6, 0}, {0, 5, 0}, {0, 0, 0},
-    0, 0, -1, -1, 0,
-    31746, 118, 17, 16, 1, 63, 3,
-    0, FB_VMODE_NONINTERLACED };
-#elif ( DEFAULT_MODE == 2 )
-    { /* 1024x768@76 took from my /etc/fb.modes */
-    1024, 768, 1024, 768,0, 0, 16,0,
-    {11, 5, 0}, {5, 6, 0}, {0, 5, 0}, {0, 0, 0},
-    0, 0, -1, -1, 0,
-    11764, 208, 8, 36, 16, 120, 3 ,
-    0, FB_VMODE_NONINTERLACED };
-#elif ( DEFAULT_MODE == 3 )
-    { /* 640x480@60 , 16bpp glide default ?*/
-    640, 480, 640, 480, 0, 0, 16, 0,
-    {11, 5, 0}, {5, 6, 0}, {0, 5, 0}, {0, 0, 0},
-    0, 0, -1, -1, 0,
-    39721 ,  38, 26 ,  25 ,18  , 96 ,2,
-    0, FB_VMODE_NONINTERLACED };
-#elif
-    #error "Invalid DEFAULT_MODE value !"
-#endif
-
 
 /*
  * debug functions
  */
 
-static void sstfb_drawdebugimage(struct fb_info *info);
-static int sstfb_dump_regs(struct fb_info *info);
-
-
 #if (SST_DEBUG_REG > 0)
 static void sst_dbg_print_read_reg(u32 reg, u32 val) {
 	const char *regname;
@@ -726,51 +689,77 @@ static int sstfb_setcolreg(u_int regno, 
 	return 0;
 }
 
-static int sstfb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
+static void sstfb_setvgapass( struct fb_info *info, int enable )
 {
 	struct sstfb_par *par = info->par;
 	struct pci_dev *sst_dev = par->dev;
-	u32 fbiinit0, tmp, val;
-	u_long p;
+	u32 fbiinit0, tmp;
+
+	enable = enable ? 1:0;
+	if (par->vgapass == enable)
+		return;
+	par->vgapass = enable;
+
+	pci_read_config_dword(sst_dev, PCI_INIT_ENABLE, &tmp);
+	pci_write_config_dword(sst_dev, PCI_INIT_ENABLE,
+			       tmp | PCI_EN_INIT_WR );
+	fbiinit0 = sst_read (FBIINIT0);
+	if (par->vgapass) {
+		sst_write(FBIINIT0, fbiinit0 & ~DIS_VGA_PASSTHROUGH);
+		printk(KERN_INFO "fb%d: Enabling VGA pass-through\n", info->node );
+	} else {
+		sst_write(FBIINIT0, fbiinit0 | DIS_VGA_PASSTHROUGH);
+		printk(KERN_INFO "fb%d: Disabling VGA pass-through\n", info->node );
+	}
+	pci_write_config_dword(sst_dev, PCI_INIT_ENABLE, tmp);
+}
+
+static ssize_t store_vgapass(struct device *device, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct fb_info *info = dev_get_drvdata(device);
+	char ** last = NULL;
+	int val;
+
+	val = simple_strtoul(buf, last, 0);
+	sstfb_setvgapass(info, val);
+
+	return count;
+}
+
+static ssize_t show_vgapass(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	struct fb_info *info = dev_get_drvdata(device);
+	struct sstfb_par *par = info->par;
+	return snprintf(buf, PAGE_SIZE, "%d\n", par->vgapass);
+}
+
+static struct device_attribute device_attrs[] = {
+	__ATTR(vgapass, S_IRUGO|S_IWUSR, show_vgapass, store_vgapass)
+	};
+
+static int sstfb_ioctl(struct fb_info *info, unsigned int cmd,
+			unsigned long arg)
+{
+	struct sstfb_par *par;
+	u32 val;
 
 	switch (cmd) {
-		
-	/* dump current FBIINIT values to system log */
-	case _IO('F', 0xdb):            /* 0x46db */
-		return sstfb_dump_regs(info);
-		
-	/* fills lfb with #arg pixels */
-	case _IOW('F', 0xdc, u32):	/* 0x46dc */
+	/* set/get VGA pass_through mode */
+	case SSTFB_SET_VGAPASS:
 		if (copy_from_user(&val, (void __user *)arg, sizeof(val)))
 			return -EFAULT;
-		if (val > info->fix.smem_len)
-			val = info->fix.smem_len;
-		for (p = 0 ; p < val; p += 2)
-			writew(p >> 6, info->screen_base + p);
+		sstfb_setvgapass(info, val);
 		return 0;
-		
-	/* change VGA pass_through mode */
-	case _IOW('F', 0xdd, u32):	/* 0x46dd */
-		if (copy_from_user(&val, (void __user *)arg, sizeof(val)))
+	case SSTFB_GET_VGAPASS:
+		par = info->par;
+		val = par->vgapass;
+		if (copy_to_user((void __user *)arg, &val, sizeof(val)))
 			return -EFAULT;
-		pci_read_config_dword(sst_dev, PCI_INIT_ENABLE, &tmp);
-		pci_write_config_dword(sst_dev, PCI_INIT_ENABLE,
-				       tmp | PCI_EN_INIT_WR );
-		fbiinit0 = sst_read (FBIINIT0);
-		if (val)
-			sst_write(FBIINIT0, fbiinit0 & ~EN_VGA_PASSTHROUGH);
-		else
-			sst_write(FBIINIT0, fbiinit0 | EN_VGA_PASSTHROUGH);
-		pci_write_config_dword(sst_dev, PCI_INIT_ENABLE, tmp);
-		return 0;
-		
-	/* draw test image  */
-	case _IO('F', 0xde):		/* 0x46de */
-		f_dprintk("test color display at %d bpp\n",
-					info->var.bits_per_pixel);
-		sstfb_drawdebugimage(info);
 		return 0;
 	}
+
 	return -EINVAL;
 }
 
@@ -804,6 +793,7 @@ static void sstfb_copyarea(struct fb_inf
 /*
  * FillRect 2D command (solidfill or invert (via ROP_XOR)) - Voodoo2 only
  */
+#if 0
 static void sstfb_fillrect(struct fb_info *info, const struct fb_fillrect *rect) 
 {
 	struct sstfb_par *par = info->par;
@@ -825,6 +815,7 @@ static void sstfb_fillrect(struct fb_inf
 		 | (BLT_16BPP_FMT << 3) /* | BIT(14) */ | BIT(15) | BIT(16) );
 	sst_wait_idle();
 }
+#endif
 
 
 
@@ -1156,6 +1147,7 @@ static int __devinit sst_init(struct fb_
 	struct pll_timing gfx_timings;
 	struct sst_spec *spec;
 	int Fout;
+	int gfx_clock;
 
 	spec = &voodoo_spec[par->type];
 	f_ddprintk(" fbiinit0   fbiinit1   fbiinit2   fbiinit3   fbiinit4  "
@@ -1196,15 +1188,15 @@ static int __devinit sst_init(struct fb_
 	}
 
 	/* set graphic clock */
-	par->gfx_clock = spec->default_gfx_clock;
+	gfx_clock = spec->default_gfx_clock;
 	if ((gfxclk >10 ) && (gfxclk < spec->max_gfxclk)) {
 		printk(KERN_INFO "sstfb: Using supplied graphic freq : %dMHz\n", gfxclk);
-		 par->gfx_clock = gfxclk *1000;
+		 gfx_clock = gfxclk *1000;
 	} else if (gfxclk) {
 		printk(KERN_WARNING "sstfb: %dMhz is way out of spec! Using default\n", gfxclk);
 	}
 
-	sst_calc_pll(par->gfx_clock, &Fout, &gfx_timings);
+	sst_calc_pll(gfx_clock, &Fout, &gfx_timings);
 	par->dac_sw.set_pll(info, &gfx_timings, GFX_CLOCK);
 
 	/* disable fbiinit remap */
@@ -1215,10 +1207,11 @@ static int __devinit sst_init(struct fb_
 	fbiinit0 = FBIINIT0_DEFAULT;
 	fbiinit1 = FBIINIT1_DEFAULT;
 	fbiinit4 = FBIINIT4_DEFAULT;
-	if (vgapass)
-		fbiinit0 &= ~EN_VGA_PASSTHROUGH;
+	par->vgapass = vgapass;
+	if (par->vgapass)
+		fbiinit0 &= ~DIS_VGA_PASSTHROUGH;
 	else
-		fbiinit0 |= EN_VGA_PASSTHROUGH;
+		fbiinit0 |= DIS_VGA_PASSTHROUGH;
 	if (slowpci) {
 		fbiinit1 |= SLOW_PCI_WRITES;
 		fbiinit4 |= SLOW_PCI_READS;
@@ -1267,7 +1260,7 @@ static void  __devexit sst_shutdown(stru
 	/* TODO maybe shutdown the dac, vrefresh and so on... */
 	pci_write_config_dword(dev, PCI_INIT_ENABLE,
 	                       PCI_EN_INIT_WR);
-	sst_unset_bits(FBIINIT0, FBI_RESET | FIFO_RESET | EN_VGA_PASSTHROUGH);
+	sst_unset_bits(FBIINIT0, FBI_RESET | FIFO_RESET | DIS_VGA_PASSTHROUGH);
 	pci_write_config_dword(dev, PCI_VCLK_DISABLE,0);
 	/* maybe keep fbiinit* and PCI_INIT_enable in the fb_info struct
 	 * from start ? */
@@ -1278,8 +1271,7 @@ static void  __devexit sst_shutdown(stru
 /*
  * Interface to the world
  */
-#ifndef MODULE
-static int  __init sstfb_setup(char *options)
+static int  __devinit sstfb_setup(char *options)
 {
 	char *this_opt;
 
@@ -1312,7 +1304,7 @@ static int  __init sstfb_setup(char *opt
 	}
 	return 0;
 }
-#endif
+
 
 static struct fb_ops sstfb_ops = {
 	.owner		= THIS_MODULE,
@@ -1416,15 +1408,10 @@ static int __devinit sstfb_probe(struct 
 	 */
 	fix->line_length = 2048; /* default value, for 24 or 32bit: 4096 */
 	
-	if ( mode_option &&
-	     fb_find_mode(&info->var, info, mode_option, NULL, 0, NULL, 16)) {
-		printk(KERN_ERR "sstfb: can't set supplied video mode. Using default\n");
-		info->var = sstfb_default;
-	} else
-		info->var = sstfb_default;
+	fb_find_mode(&info->var, info, mode_option, NULL, 0, NULL, 16);
 
 	if (sstfb_check_var(&info->var, info)) {
-		printk(KERN_ERR "sstfb: invalid default video mode.\n");
+		printk(KERN_ERR "sstfb: invalid video mode.\n");
 		goto fail;
 	}
 
@@ -1442,10 +1429,11 @@ static int __devinit sstfb_probe(struct 
 		goto fail;
 	}
 
-	if (1) /* set to 0 to see an initial bitmap instead */
-		sstfb_clear_screen(info);
-	else
-		sstfb_drawdebugimage(info);
+	sstfb_clear_screen(info);
+
+	if (device_create_file(info->dev, &device_attrs[0]))
+		printk(KERN_WARNING "sstfb: can't create sysfs entry.\n");
+
 
 	printk(KERN_INFO "fb%d: %s frame buffer device at 0x%p\n",
 	       info->node, fix->id, info->screen_base);
@@ -1453,6 +1441,7 @@ static int __devinit sstfb_probe(struct 
 	return 0;
 
 fail:
+	fb_dealloc_cmap(&info->cmap);
 	iounmap(info->screen_base);
 fail_fb_remap:
 	iounmap(par->mmio_vbase);
@@ -1473,21 +1462,23 @@ static void __devexit sstfb_remove(struc
 	info = pci_get_drvdata(pdev);
 	par = info->par;
 	
+	device_remove_file(info->dev, &device_attrs[0]);
 	sst_shutdown(info);
-	unregister_framebuffer(info);
 	iounmap(info->screen_base);
 	iounmap(par->mmio_vbase);
 	release_mem_region(info->fix.smem_start, 0x400000);
 	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
+	fb_dealloc_cmap(&info->cmap);
+	unregister_framebuffer(info);
 	framebuffer_release(info);
 }
 
 
-static struct pci_device_id sstfb_id_tbl[] = {
-	{ PCI_VENDOR_ID_3DFX, PCI_DEVICE_ID_3DFX_VOODOO,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, ID_VOODOO1 },
-	{ PCI_VENDOR_ID_3DFX, PCI_DEVICE_ID_3DFX_VOODOO2,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, ID_VOODOO2 },
+static const struct pci_device_id sstfb_id_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_3DFX, PCI_DEVICE_ID_3DFX_VOODOO ),
+		.driver_data = ID_VOODOO1, },
+	{ PCI_DEVICE(PCI_VENDOR_ID_3DFX, PCI_DEVICE_ID_3DFX_VOODOO2),
+		.driver_data = ID_VOODOO2, },
 	{ 0 },
 };
 
@@ -1501,142 +1492,23 @@ static struct pci_driver sstfb_driver = 
 
 static int __devinit sstfb_init(void)
 {
-#ifndef MODULE
 	char *option = NULL;
 
 	if (fb_get_options("sstfb", &option))
 		return -ENODEV;
 	sstfb_setup(option);
-#endif
+
 	return pci_register_driver(&sstfb_driver);
 }
 
-#ifdef MODULE
 static void __devexit sstfb_exit(void)
 {
 	pci_unregister_driver(&sstfb_driver);
 }
-#endif
 
 
-/*
- * testing and debugging functions
- */
-
-static int sstfb_dump_regs(struct fb_info *info)
-{
-#ifdef SST_DEBUG
-	static struct { u32 reg ; const char *reg_name;}  pci_regs[] = {
-		{ PCI_INIT_ENABLE, "initenable"},
-		{ PCI_VCLK_ENABLE, "enable vclk"},
-		{ PCI_VCLK_DISABLE, "disable vclk"},
-	};
-
-	static struct { u32 reg ; const char *reg_name;}  sst_regs[] = {
-		{FBIINIT0,"fbiinit0"},
-		{FBIINIT1,"fbiinit1"},
-		{FBIINIT2,"fbiinit2"},
-		{FBIINIT3,"fbiinit3"},
-		{FBIINIT4,"fbiinit4"},
-		{FBIINIT5,"fbiinit5"},
-		{FBIINIT6,"fbiinit6"},
-		{FBIINIT7,"fbiinit7"},
-		{LFBMODE,"lfbmode"},
-		{FBZMODE,"fbzmode"},
-	};
-
-	const int pci_s = ARRAY_SIZE(pci_regs);
-	const int sst_s = ARRAY_SIZE(sst_regs);
-	struct sstfb_par *par = info->par;
-	struct pci_dev *dev = par->dev;
-	u32 pci_res[pci_s];
-	u32 sst_res[sst_s];
-	int i;
-
-	for (i=0; i<pci_s; i++) {
-		pci_read_config_dword(dev, pci_regs[i].reg, &pci_res[i]);
-	}
-	for (i=0; i<sst_s; i++) {
-		sst_res[i] = sst_read(sst_regs[i].reg);
-	}
-
-	dprintk("hardware register dump:\n");
-	for (i=0; i<pci_s; i++) {
-		dprintk("%s %0#10x\n", pci_regs[i].reg_name, pci_res[i]);
-	}
-	for (i=0; i<sst_s; i++) {
-		dprintk("%s %0#10x\n", sst_regs[i].reg_name, sst_res[i]);
-	}
-	return 0;
-#else
-	return -EINVAL;
-#endif
-}
-
-static void sstfb_fillrect_softw( struct fb_info *info, const struct fb_fillrect *rect)
-{
-	u8 __iomem *fbbase_virt = info->screen_base;
-	int x, y, w = info->var.bits_per_pixel == 16 ? 2 : 4;
-	u32 color = rect->color, height = rect->height;
-	u8 __iomem *p;
-	
-	if (w==2) color |= color<<16;
-	for (y=rect->dy; height; y++, height--) {
-		p = fbbase_virt + y*info->fix.line_length + rect->dx*w;
-		x = rect->width;
-		if (w==2) x>>=1;
-		while (x) {
-			writel(color, p);
-			p += 4;
-			x--;
-		}
-	}
-}
-
-static void sstfb_drawrect_XY( struct fb_info *info, int x, int y,
-		int w, int h, int color, int hwfunc)
-{
-	struct fb_fillrect rect;
-	rect.dx = x;
-	rect.dy = y;
-	rect.height = h;
-	rect.width = w;
-	rect.color = color;
-	rect.rop = ROP_COPY;
-	if (hwfunc)
-		sstfb_fillrect(info, &rect);
-	else
-		sstfb_fillrect_softw(info, &rect);
-}
-
-/* print some squares on the fb */
-static void sstfb_drawdebugimage(struct fb_info *info)
-{
-	static int idx;
-
-	/* clear screen */
-	sstfb_clear_screen(info);
-	
-   	idx = (idx+1) & 1;
-
-	/* white rect */
-	sstfb_drawrect_XY(info, 0, 0, 50, 50, 0xffff, idx);
-	
-	/* blue rect */
-	sstfb_drawrect_XY(info, 50, 50, 50, 50, 0x001f, idx);
-
-	/* green rect */
-	sstfb_drawrect_XY(info, 100, 100, 80, 80, 0x07e0, idx);
-	
-	/* red rect */
-	sstfb_drawrect_XY(info, 250, 250, 120, 100, 0xf800, idx);
-}
-
 module_init(sstfb_init);
-
-#ifdef MODULE
 module_exit(sstfb_exit);
-#endif
 
 MODULE_AUTHOR("(c) 2000,2002 Ghozlane Toumi <gtoumi@laposte.net>");
 MODULE_DESCRIPTION("FBDev driver for 3dfx Voodoo Graphics and Voodoo2 based video boards");
@@ -1652,3 +1524,6 @@ module_param(gfxclk, int, 0);
 MODULE_PARM_DESC(gfxclk, "Force graphic chip frequency in MHz. DANGEROUS. (default=auto)");
 module_param(slowpci, bool, 0);
 MODULE_PARM_DESC(slowpci, "Uses slow PCI settings (0 or 1) (default=0)");
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "Initial video mode (default=" DEFAULT_VIDEO_MODE ")");
+
diff -puN include/video/sstfb.h~sstfb-add-sysfs-interface include/video/sstfb.h
--- a/include/video/sstfb.h~sstfb-add-sysfs-interface
+++ a/include/video/sstfb.h
@@ -119,7 +119,7 @@
 #define BACKPORCH		0x0208
 #define VIDEODIMENSIONS		0x020c
 #define FBIINIT0		0x0210		/* misc+fifo  controls */
-#  define EN_VGA_PASSTHROUGH	  BIT(0)
+#  define DIS_VGA_PASSTHROUGH	  BIT(0)
 #  define FBI_RESET		  BIT(1)
 #  define FIFO_RESET		  BIT(2)
 #define FBIINIT1		0x0214		/* PCI + video controls */
@@ -251,7 +251,7 @@
 #  define DACREG_ICS_CLK1_A	  0	/* bit4 */
 
 /* sst default init registers */
-#define FBIINIT0_DEFAULT EN_VGA_PASSTHROUGH
+#define FBIINIT0_DEFAULT DIS_VGA_PASSTHROUGH
 
 #define FBIINIT1_DEFAULT 	\
 	(			\
@@ -296,6 +296,11 @@
  *
  */
 
+/* ioctl to enable/disable VGA passthrough */
+#define SSTFB_SET_VGAPASS	_IOW('F', 0xdd, __u32)
+#define SSTFB_GET_VGAPASS	_IOR('F', 0xdd, __u32)
+
+
 /* used to know witch clock to set */
 enum {
 	VID_CLOCK=0,
@@ -317,7 +322,7 @@ struct pll_timing {
 };
 
 struct dac_switch {
-	char * name;
+	const char *name;
 	int (*detect) (struct fb_info *info);
 	int (*set_pll) (struct fb_info *info, const struct pll_timing *t, const int clock);
 	void (*set_vidmod) (struct fb_info *info, const int bpp);
@@ -345,7 +350,7 @@ struct sstfb_par {
 	struct pci_dev		*dev;
 	int	type;
 	u8	revision;
-	int	gfx_clock;	/* status */
+	u8	vgapass;	/* VGA pass through: 1=enabled, 0=disabled */
 };
 
 #endif /* _SSTFB_H_ */
_

Patches currently in -mm which might be from deller@gmx.de are


