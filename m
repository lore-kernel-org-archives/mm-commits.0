From: akpm@linux-foundation.org
Subject: + cirrusfb-remove-fields-from-cirrusfb_info.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:44 -0700
Message-ID: <200708272223.l7RMNiY4031674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757787AbXH0WXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     cirrusfb: remove fields from cirrusfb_info
has been added to the -mm tree.  Its filename is
     cirrusfb-remove-fields-from-cirrusfb_info.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cirrusfb: remove fields from cirrusfb_info
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch removes unused or redundant fields from cirrusfb_info structure.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |  149 ++++++++++++++++---------------------
 1 files changed, 68 insertions(+), 81 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-remove-fields-from-cirrusfb_info drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-remove-fields-from-cirrusfb_info
+++ a/drivers/video/cirrusfb.c
@@ -369,23 +369,14 @@ enum cirrusfb_dbg_reg_class {
 
 /* info about board */
 struct cirrusfb_info {
-	struct fb_info *info;
-
-	u8 __iomem *fbmem;
 	u8 __iomem *regbase;
-	u8 __iomem *mem;
-	unsigned long size;
 	enum cirrus_board btype;
 	unsigned char SFR;	/* Shadow of special function register */
 
-	unsigned long fbmem_phys;
-	unsigned long fbregs_phys;
-
 	struct cirrusfb_regs currentmode;
 	int blank_mode;
 
 	u32	pseudo_palette[16];
-	struct { u8 red, green, blue, pad; } palette[256];
 
 #ifdef CONFIG_ZORRO
 	struct zorro_dev *zdev;
@@ -393,7 +384,7 @@ struct cirrusfb_info {
 #ifdef CONFIG_PCI
 	struct pci_dev *pdev;
 #endif
-	void (*unmap)(struct cirrusfb_info *cinfo);
+	void (*unmap)(struct fb_info *info);
 };
 
 static unsigned cirrusfb_def_mode = 1;
@@ -536,7 +527,7 @@ static int cirrusfb_decode_var(const str
 				struct cirrusfb_regs *regs,
 				const struct fb_info *info);
 /*--- Internal routines ----------------------------------------------------*/
-static void init_vgachip(struct cirrusfb_info *cinfo);
+static void init_vgachip(struct fb_info *info);
 static void switch_monitor(struct cirrusfb_info *cinfo, int on);
 static void WGen(const struct cirrusfb_info *cinfo,
 		 int regnum, unsigned char val);
@@ -645,7 +636,6 @@ static long cirrusfb_get_mclk(long freq,
 static int cirrusfb_check_var(struct fb_var_screeninfo *var,
 			      struct fb_info *info)
 {
-	struct cirrusfb_info *cinfo = info->par;
 	int nom, den;		/* translyting from pixels->bytes */
 	int yres, i;
 	static struct { int xres, yres; } modes[] =
@@ -690,7 +680,7 @@ static int cirrusfb_check_var(struct fb_
 		return -EINVAL;
 	}
 
-	if (var->xres * nom / den * var->yres > cinfo->size) {
+	if (var->xres * nom / den * var->yres > info->screen_size) {
 		printk(KERN_ERR "cirrusfb: mode %dx%dx%d rejected..."
 			"resolution too high to fit into video memory!\n",
 			var->xres, var->yres, var->bits_per_pixel);
@@ -704,7 +694,8 @@ static int cirrusfb_check_var(struct fb_
 		printk(KERN_INFO
 		     "cirrusfb: using maximum available virtual resolution\n");
 		for (i = 0; modes[i].xres != -1; i++) {
-			if (modes[i].xres * nom / den * modes[i].yres < cinfo->size / 2)
+			int size = modes[i].xres * nom / den * modes[i].yres;
+			if (size < info->screen_size / 2)
 				break;
 		}
 		if (modes[i].xres == -1) {
@@ -1018,7 +1009,7 @@ static int cirrusfb_set_par_foo(struct f
 	       var->xres, var->yres, var->bits_per_pixel);
 	DPRINTK("pixclock: %d\n", var->pixclock);
 
-	init_vgachip(cinfo);
+	init_vgachip(info);
 
 	err = cirrusfb_decode_var(var, &regs, info);
 	if (err) {
@@ -1686,10 +1677,6 @@ static int cirrusfb_setcolreg(unsigned r
 		return 0;
 	}
 
-	cinfo->palette[regno].red = red;
-	cinfo->palette[regno].green = green;
-	cinfo->palette[regno].blue = blue;
-
 	if (info->var.bits_per_pixel == 8)
 		WClut(cinfo, regno, red >> 10, green >> 10, blue >> 10);
 
@@ -1848,8 +1835,9 @@ static int cirrusfb_blank(int blank_mode
 /****************************************************************************/
 /**** BEGIN Internal Routines ***********************************************/
 
-static void init_vgachip(struct cirrusfb_info *cinfo)
+static void init_vgachip(struct fb_info *info)
 {
+	struct cirrusfb_info *cinfo = info->par;
 	const struct cirrusfb_board_info_rec *bi;
 
 	DPRINTK("ENTER\n");
@@ -1903,7 +1891,8 @@ static void init_vgachip(struct cirrusfb
 		break;
 	}
 
-	assert(cinfo->size > 0); /* make sure RAM size set by this point */
+	/* make sure RAM size set by this point */
+	assert(info->screen_size > 0);
 
 	/* the P4 is not fully initialized here; I rely on it having been */
 	/* inited under AmigaOS already, which seems to work just fine    */
@@ -2089,7 +2078,7 @@ static void init_vgachip(struct cirrusfb
 	WHDR(cinfo, 0);	/* Hidden DAC register: - */
 
 	printk(KERN_DEBUG "cirrusfb: This board has %ld bytes of DRAM memory\n",
-		cinfo->size);
+		info->screen_size);
 	DPRINTK("EXIT\n");
 	return;
 }
@@ -2150,24 +2139,25 @@ static void switch_monitor(struct cirrus
 /* Linux 2.6-style  accelerated functions */
 /******************************************/
 
-static void cirrusfb_prim_fillrect(struct cirrusfb_info *cinfo,
+static void cirrusfb_prim_fillrect(struct fb_info *info,
 				   const struct fb_fillrect *region)
 {
+	struct cirrusfb_info *cinfo = info->par;
 	int m; /* bytes per pixel */
-	u32 color = (cinfo->info->fix.visual == FB_VISUAL_TRUECOLOR) ?
+	u32 color = (info->fix.visual == FB_VISUAL_TRUECOLOR) ?
 		cinfo->pseudo_palette[region->color] : region->color;
 
-	if (cinfo->info->var.bits_per_pixel == 1) {
+	if (info->var.bits_per_pixel == 1) {
 		cirrusfb_RectFill(cinfo->regbase,
-				  cinfo->info->var.bits_per_pixel,
+				  info->var.bits_per_pixel,
 				  region->dx / 8, region->dy,
 				  region->width / 8, region->height,
 				  color,
 				  cinfo->currentmode.line_length);
 	} else {
-		m = (cinfo->info->var.bits_per_pixel + 7) / 8;
+		m = (info->var.bits_per_pixel + 7) / 8;
 		cirrusfb_RectFill(cinfo->regbase,
-				  cinfo->info->var.bits_per_pixel,
+				  info->var.bits_per_pixel,
 				  region->dx * m, region->dy,
 				  region->width * m, region->height,
 				  color,
@@ -2179,7 +2169,6 @@ static void cirrusfb_prim_fillrect(struc
 static void cirrusfb_fillrect(struct fb_info *info,
 			      const struct fb_fillrect *region)
 {
-	struct cirrusfb_info *cinfo = info->par;
 	struct fb_fillrect modded;
 	int vxres, vyres;
 
@@ -2204,22 +2193,24 @@ static void cirrusfb_fillrect(struct fb_
 	if (modded.dy + modded.height > vyres)
 		modded.height = vyres - modded.dy;
 
-	cirrusfb_prim_fillrect(cinfo, &modded);
+	cirrusfb_prim_fillrect(info, &modded);
 }
 
-static void cirrusfb_prim_copyarea(struct cirrusfb_info *cinfo,
+static void cirrusfb_prim_copyarea(struct fb_info *info,
 				   const struct fb_copyarea *area)
 {
+	struct cirrusfb_info *cinfo = info->par;
 	int m; /* bytes per pixel */
-	if (cinfo->info->var.bits_per_pixel == 1) {
-		cirrusfb_BitBLT(cinfo->regbase, cinfo->info->var.bits_per_pixel,
+
+	if (info->var.bits_per_pixel == 1) {
+		cirrusfb_BitBLT(cinfo->regbase, info->var.bits_per_pixel,
 				area->sx / 8, area->sy,
 				area->dx / 8, area->dy,
 				area->width / 8, area->height,
 				cinfo->currentmode.line_length);
 	} else {
-		m = (cinfo->info->var.bits_per_pixel + 7) / 8;
-		cirrusfb_BitBLT(cinfo->regbase, cinfo->info->var.bits_per_pixel,
+		m = (info->var.bits_per_pixel + 7) / 8;
+		cirrusfb_BitBLT(cinfo->regbase, info->var.bits_per_pixel,
 				area->sx * m, area->sy,
 				area->dx * m, area->dy,
 				area->width * m, area->height,
@@ -2231,9 +2222,9 @@ static void cirrusfb_prim_copyarea(struc
 static void cirrusfb_copyarea(struct fb_info *info,
 			      const struct fb_copyarea *area)
 {
-	struct cirrusfb_info *cinfo = info->par;
 	struct fb_copyarea modded;
 	u32 vxres, vyres;
+
 	modded.sx = area->sx;
 	modded.sy = area->sy;
 	modded.dx = area->dx;
@@ -2265,7 +2256,7 @@ static void cirrusfb_copyarea(struct fb_
 	if (modded.dy + modded.height > vyres)
 		modded.height = vyres - modded.dy;
 
-	cirrusfb_prim_copyarea(cinfo, &modded);
+	cirrusfb_prim_copyarea(info, &modded);
 }
 
 static void cirrusfb_imageblit(struct fb_info *info,
@@ -2363,18 +2354,19 @@ static void get_pci_addrs(const struct p
 	DPRINTK("EXIT\n");
 }
 
-static void cirrusfb_pci_unmap(struct cirrusfb_info *cinfo)
+static void cirrusfb_pci_unmap(struct fb_info *info)
 {
+	struct cirrusfb_info *cinfo = info->par;
 	struct pci_dev *pdev = cinfo->pdev;
 
-	iounmap(cinfo->fbmem);
+	iounmap(info->screen_base);
 #if 0 /* if system didn't claim this region, we would... */
 	release_mem_region(0xA0000, 65535);
 #endif
 	if (release_io_ports)
 		release_region(0x3C0, 32);
 	pci_release_regions(pdev);
-	framebuffer_release(cinfo->info);
+	framebuffer_release(info);
 }
 #endif /* CONFIG_PCI */
 
@@ -2386,21 +2378,20 @@ static void __devexit cirrusfb_zorro_unm
 	if (cinfo->btype == BT_PICASSO4) {
 		cinfo->regbase -= 0x600000;
 		iounmap((void *)cinfo->regbase);
-		iounmap((void *)cinfo->fbmem);
+		iounmap(info->screen_base);
 	} else {
 		if (zorro_resource_start(cinfo->zdev) > 0x01000000)
-			iounmap((void *)cinfo->fbmem);
+			iounmap(info->screen_base);
 	}
 	framebuffer_release(cinfo->info);
 }
 #endif /* CONFIG_ZORRO */
 
-static int cirrusfb_set_fbinfo(struct cirrusfb_info *cinfo)
+static int cirrusfb_set_fbinfo(struct fb_info *info)
 {
-	struct fb_info *info = cinfo->info;
+	struct cirrusfb_info *cinfo = info->par;
 	struct fb_var_screeninfo *var = &info->var;
 
-	info->par = cinfo;
 	info->pseudo_palette = cinfo->pseudo_palette;
 	info->flags = FBINFO_DEFAULT
 		    | FBINFO_HWACCEL_XPAN
@@ -2410,7 +2401,6 @@ static int cirrusfb_set_fbinfo(struct ci
 	if (noaccel)
 		info->flags |= FBINFO_HWACCEL_DISABLED;
 	info->fbops = &cirrusfb_ops;
-	info->screen_base = cinfo->fbmem;
 	if (cinfo->btype == BT_GD5480) {
 		if (var->bits_per_pixel == 16)
 			info->screen_base += 1 * MB_;
@@ -2424,9 +2414,9 @@ static int cirrusfb_set_fbinfo(struct ci
 
 	/* monochrome: only 1 memory plane */
 	/* 8 bit and above: Use whole memory area */
-	info->fix.smem_start = cinfo->fbmem_phys;
-	info->fix.smem_len   =
-		(var->bits_per_pixel == 1) ? cinfo->size / 4 : cinfo->size;
+	info->fix.smem_len   = info->screen_size;
+	if (var->bits_per_pixel == 1)
+		info->fix.smem_len /= 4;
 	info->fix.type       = cinfo->currentmode.type;
 	info->fix.type_aux   = 0;
 	info->fix.visual     = cinfo->currentmode.visual;
@@ -2436,7 +2426,6 @@ static int cirrusfb_set_fbinfo(struct ci
 	info->fix.line_length = cinfo->currentmode.line_length;
 
 	/* FIXME: map region at 0xB8000 if available, fill in here */
-	info->fix.mmio_start = cinfo->fbregs_phys;
 	info->fix.mmio_len   = 0;
 	info->fix.accel = FB_ACCEL_NONE;
 
@@ -2445,9 +2434,9 @@ static int cirrusfb_set_fbinfo(struct ci
 	return 0;
 }
 
-static int cirrusfb_register(struct cirrusfb_info *cinfo)
+static int cirrusfb_register(struct fb_info *info)
 {
-	struct fb_info *info;
+	struct cirrusfb_info *cinfo = info->par;
 	int err;
 	enum cirrus_board btype;
 
@@ -2456,13 +2445,12 @@ static int cirrusfb_register(struct cirr
 	printk(KERN_INFO "cirrusfb: Driver for Cirrus Logic based "
 		"graphic boards, v" CIRRUSFB_VERSION "\n");
 
-	info = cinfo->info;
 	btype = cinfo->btype;
 
 	/* sanity checks */
 	assert(btype != BT_NONE);
 
-	DPRINTK("cirrusfb: (RAM start set to: 0x%p)\n", cinfo->fbmem);
+	DPRINTK("cirrusfb: (RAM start set to: 0x%p)\n", info->screen_base);
 
 	/* Make pretend we've set the var so our structures are in a "good" */
 	/* state, even though we haven't written the mode to the hw yet...  */
@@ -2477,7 +2465,7 @@ static int cirrusfb_register(struct cirr
 	}
 
 	/* set all the vital stuff */
-	cirrusfb_set_fbinfo(cinfo);
+	cirrusfb_set_fbinfo(info);
 
 	err = register_framebuffer(info);
 	if (err < 0) {
@@ -2492,7 +2480,7 @@ static int cirrusfb_register(struct cirr
 err_dealloc_cmap:
 	fb_dealloc_cmap(&info->cmap);
 err_unmap_cirrusfb:
-	cinfo->unmap(cinfo);
+	cinfo->unmap(info);
 	return err;
 }
 
@@ -2506,7 +2494,7 @@ static void __devexit cirrusfb_cleanup(s
 	unregister_framebuffer(info);
 	fb_dealloc_cmap(&info->cmap);
 	printk("Framebuffer unregistered\n");
-	cinfo->unmap(cinfo);
+	cinfo->unmap(info);
 
 	DPRINTK("EXIT\n");
 }
@@ -2535,7 +2523,6 @@ static int cirrusfb_pci_register(struct 
 	}
 
 	cinfo = info->par;
-	cinfo->info = info;
 	cinfo->pdev = pdev;
 	cinfo->btype = btype = (enum cirrus_board) ent->driver_data;
 
@@ -2546,19 +2533,19 @@ static int cirrusfb_pci_register(struct 
 	if (isPReP) {
 		pci_write_config_dword(pdev, PCI_BASE_ADDRESS_0, 0x00000000);
 #ifdef CONFIG_PPC_PREP
-		get_prep_addrs(&board_addr, &cinfo->fbregs_phys);
+		get_prep_addrs(&board_addr, &info->fix.mmio_start);
 #endif
 	/* PReP dies if we ioremap the IO registers, but it works w/out... */
-		cinfo->regbase = (char __iomem *) cinfo->fbregs_phys;
+		cinfo->regbase = (char __iomem *) info->fix.mmio_start;
 	} else {
 		DPRINTK("Attempt to get PCI info for Cirrus Graphics Card\n");
-		get_pci_addrs(pdev, &board_addr, &cinfo->fbregs_phys);
+		get_pci_addrs(pdev, &board_addr, &info->fix.mmio_start);
 		/* FIXME: this forces VGA.  alternatives? */
 		cinfo->regbase = NULL;
 	}
 
 	DPRINTK("Board address: 0x%lx, register address: 0x%lx\n",
-		board_addr, cinfo->fbregs_phys);
+		board_addr, info->fix.mmio_start);
 
 	board_size = (btype == BT_GD5480) ?
 		32 * MB_ : cirrusfb_get_memsize(cinfo->regbase);
@@ -2582,24 +2569,24 @@ static int cirrusfb_pci_register(struct 
 	if (request_region(0x3C0, 32, "cirrusfb"))
 		release_io_ports = 1;
 
-	cinfo->fbmem = ioremap(board_addr, board_size);
-	if (!cinfo->fbmem) {
+	info->screen_base = ioremap(board_addr, board_size);
+	if (!info->screen_base) {
 		ret = -EIO;
 		goto err_release_legacy;
 	}
 
-	cinfo->fbmem_phys = board_addr;
-	cinfo->size = board_size;
+	info->fix.smem_start = board_addr;
+	info->screen_size = board_size;
 	cinfo->unmap = cirrusfb_pci_unmap;
 
 	printk(KERN_INFO " RAM (%lu kB) at 0xx%lx, ",
-		cinfo->size / KB_, board_addr);
+		info->screen_size / KB_, board_addr);
 	printk(KERN_INFO "Cirrus Logic chipset on PCI bus\n");
 	pci_set_drvdata(pdev, info);
 
-	ret = cirrusfb_register(cinfo);
+	ret = cirrusfb_register(info);
 	if (ret)
-		iounmap(cinfo->fbmem);
+		iounmap(info->screen_base);
 	return ret;
 
 err_release_legacy:
@@ -2677,7 +2664,7 @@ static int cirrusfb_zorro_register(struc
 	cinfo->zdev = z;
 	board_addr = zorro_resource_start(z);
 	board_size = zorro_resource_len(z);
-	cinfo->size = size;
+	info->screen_size = size;
 
 	if (!zorro_request_device(z, "cirrusfb")) {
 		printk(KERN_ERR "cirrusfb: cannot reserve region 0x%lx, "
@@ -2705,27 +2692,27 @@ static int cirrusfb_zorro_register(struc
 		DPRINTK("cirrusfb: Virtual address for board set to: $%p\n",
 			cinfo->regbase);
 		cinfo->regbase += 0x600000;
-		cinfo->fbregs_phys = board_addr + 0x600000;
+		info->fix.mmio_start = board_addr + 0x600000;
 
-		cinfo->fbmem_phys = board_addr + 16777216;
-		cinfo->fbmem = ioremap(cinfo->fbmem_phys, 16777216);
-		if (!cinfo->fbmem)
+		info->fix.smem_start = board_addr + 16777216;
+		info->screen_base = ioremap(info->fix.smem_start, 16777216);
+		if (!info->screen_base)
 			goto err_unmap_regbase;
 	} else {
 		printk(KERN_INFO " REG at $%lx\n",
 			(unsigned long) z2->resource.start);
 
-		cinfo->fbmem_phys = board_addr;
+		info->fix.smem_start = board_addr;
 		if (board_addr > 0x01000000)
-			cinfo->fbmem = ioremap(board_addr, board_size);
+			info->screen_base = ioremap(board_addr, board_size);
 		else
-			cinfo->fbmem = (caddr_t) ZTWO_VADDR(board_addr);
-		if (!cinfo->fbmem)
+			info->screen_base = (caddr_t) ZTWO_VADDR(board_addr);
+		if (!info->screen_base)
 			goto err_release_region;
 
 		/* set address for REG area of board */
 		cinfo->regbase = (caddr_t) ZTWO_VADDR(z2->resource.start);
-		cinfo->fbregs_phys = z2->resource.start;
+		info->fix.mmio_start = z2->resource.start;
 
 		DPRINTK("cirrusfb: Virtual address for board set to: $%p\n",
 			cinfo->regbase);
@@ -2738,10 +2725,10 @@ static int cirrusfb_zorro_register(struc
 	ret = cirrusfb_register(cinfo);
 	if (ret) {
 		if (btype == BT_PICASSO4) {
-			iounmap(cinfo->fbmem);
+			iounmap(info->screen_base);
 			iounmap(cinfo->regbase - 0x600000);
 		} else if (board_addr > 0x01000000)
-			iounmap(cinfo->fbmem);
+			iounmap(info->screen_base);
 	}
 	return ret;
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
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
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
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
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
