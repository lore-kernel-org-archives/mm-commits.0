From: akpm@osdl.org
Subject: + tgafb-switch-to-framebuffer_alloc.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:16:05 -0800
Message-ID: <200612140016.kBE0G5i5025763@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60816 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbWLNAQ0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:16:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org


The patch titled
     tgafb: switch to framebuffer_alloc()
has been added to the -mm tree.  Its filename is
     tgafb-switch-to-framebuffer_alloc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tgafb: switch to framebuffer_alloc()
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a set of changes to update the driver to the framebuffer_alloc() API. 
Included, there is also a fix to a memory leak due to the colour map
allocation not being freed upon driver's removal.  Aside from the fix there
are no functional changes.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/tgafb.c |   61 ++++++++++++++++++----------------------
 1 files changed, 28 insertions(+), 33 deletions(-)

diff -puN drivers/video/tgafb.c~tgafb-switch-to-framebuffer_alloc drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-switch-to-framebuffer_alloc
+++ a/drivers/video/tgafb.c
@@ -1342,14 +1342,10 @@ tgafb_pci_register(struct pci_dev *pdev,
 		TGA_24PLUSZ_FB_OFFSET
 	};
 
-	struct all_info {
-		struct fb_info info;
-		struct tga_par par;
-		u32 pseudo_palette[16];
-	} *all;
-
 	void __iomem *mem_base;
 	unsigned long bar0_start, bar0_len;
+	struct fb_info *info;
+	struct tga_par *par;
 	u8 tga_type;
 	int ret;
 
@@ -1360,13 +1356,14 @@ tgafb_pci_register(struct pci_dev *pdev,
 	}
 
 	/* Allocate the fb and par structures.  */
-	all = kmalloc(sizeof(*all), GFP_KERNEL);
-	if (!all) {
+	info = framebuffer_alloc(sizeof(struct tga_par), &pdev->dev);
+	if (!info) {
 		printk(KERN_ERR "tgafb: Cannot allocate memory\n");
 		return -ENOMEM;
 	}
-	memset(all, 0, sizeof(*all));
-	pci_set_drvdata(pdev, all);
+
+	par = info->par;
+	pci_set_drvdata(pdev, info);
 
 	/* Request the mem regions.  */
 	bar0_start = pci_resource_start(pdev, 0);
@@ -1386,25 +1383,23 @@ tgafb_pci_register(struct pci_dev *pdev,
 
 	/* Grab info about the card.  */
 	tga_type = (readl(mem_base) >> 12) & 0x0f;
-	all->par.pdev = pdev;
-	all->par.tga_mem_base = mem_base;
-	all->par.tga_fb_base = mem_base + fb_offset_presets[tga_type];
-	all->par.tga_regs_base = mem_base + TGA_REGS_OFFSET;
-	all->par.tga_type = tga_type;
-	pci_read_config_byte(pdev, PCI_REVISION_ID, &all->par.tga_chip_rev);
+	par->pdev = pdev;
+	par->tga_mem_base = mem_base;
+	par->tga_fb_base = mem_base + fb_offset_presets[tga_type];
+	par->tga_regs_base = mem_base + TGA_REGS_OFFSET;
+	par->tga_type = tga_type;
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &par->tga_chip_rev);
 
 	/* Setup framebuffer.  */
-	all->info.flags = FBINFO_DEFAULT | FBINFO_HWACCEL_COPYAREA |
-                          FBINFO_HWACCEL_IMAGEBLIT | FBINFO_HWACCEL_FILLRECT;
-	all->info.fbops = &tgafb_ops;
-	all->info.screen_base = all->par.tga_fb_base;
-	all->info.par = &all->par;
-	all->info.pseudo_palette = all->pseudo_palette;
+	info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_COPYAREA |
+		      FBINFO_HWACCEL_IMAGEBLIT | FBINFO_HWACCEL_FILLRECT;
+	info->fbops = &tgafb_ops;
+	info->screen_base = par->tga_fb_base;
+	info->pseudo_palette = (void *)(par + 1);
 
 	/* This should give a reasonable default video mode.  */
 
-	ret = fb_find_mode(&all->info.var, &all->info, mode_option,
-			   NULL, 0, NULL,
+	ret = fb_find_mode(&info->var, info, mode_option, NULL, 0, NULL,
 			   tga_type == TGA_TYPE_8PLANE ? 8 : 32);
 	if (ret == 0 || ret == 4) {
 		printk(KERN_ERR "tgafb: Could not find valid video mode\n");
@@ -1412,29 +1407,28 @@ tgafb_pci_register(struct pci_dev *pdev,
 		goto err1;
 	}
 
-	if (fb_alloc_cmap(&all->info.cmap, 256, 0)) {
+	if (fb_alloc_cmap(&info->cmap, 256, 0)) {
 		printk(KERN_ERR "tgafb: Could not allocate color map\n");
 		ret = -ENOMEM;
 		goto err1;
 	}
 
-	tgafb_set_par(&all->info);
-	tgafb_init_fix(&all->info);
+	tgafb_set_par(info);
+	tgafb_init_fix(info);
 
-	all->info.device = &pdev->dev;
-	if (register_framebuffer(&all->info) < 0) {
+	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "tgafb: Could not register framebuffer\n");
 		ret = -EINVAL;
 		goto err1;
 	}
 
 	printk(KERN_INFO "tgafb: DC21030 [TGA] detected, rev=0x%02x\n",
-	       all->par.tga_chip_rev);
+	       par->tga_chip_rev);
 	printk(KERN_INFO "tgafb: at PCI bus %d, device %d, function %d\n",
 	       pdev->bus->number, PCI_SLOT(pdev->devfn),
 	       PCI_FUNC(pdev->devfn));
 	printk(KERN_INFO "fb%d: %s frame buffer device at 0x%lx\n",
-	       all->info.node, all->info.fix.id, bar0_start);
+	       info->node, info->fix.id, bar0_start);
 
 	return 0;
 
@@ -1443,7 +1437,7 @@ tgafb_pci_register(struct pci_dev *pdev,
 		iounmap(mem_base);
 	release_mem_region(bar0_start, bar0_len);
  err0:
-	kfree(all);
+	framebuffer_release(info);
 	return ret;
 }
 
@@ -1456,10 +1450,11 @@ tgafb_pci_unregister(struct pci_dev *pde
 	if (!info)
 		return;
 	unregister_framebuffer(info);
+	fb_dealloc_cmap(&info->cmap);
 	iounmap(par->tga_mem_base);
 	release_mem_region(pci_resource_start(pdev, 0),
 			   pci_resource_len(pdev, 0));
-	kfree(info);
+	framebuffer_release(info);
 }
 
 #ifdef MODULE
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch

