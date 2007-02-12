From: akpm@linux-foundation.org
Subject: - video-fb-kzalloc-changes.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:50:01 -0800
Message-ID: <200702122250.l1CMo1gf014182@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45726 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030382AbXBLWuN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:50:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Video: fb, kzalloc changes
has been removed from the -mm tree.  Its filename was
     video-fb-kzalloc-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Video: fb, kzalloc changes
From: Jiri Slaby <jirislaby@gmail.com>

Use kzalloc instead of kmalloc + memset(0).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/au1100fb.c           |    6 ++----
 drivers/video/controlfb.c          |    3 +--
 drivers/video/i810/i810_main.c     |    3 +--
 drivers/video/igafb.c              |    7 ++-----
 drivers/video/intelfb/intelfbdrv.c |    3 +--
 drivers/video/nvidia/nvidia.c      |    4 +---
 drivers/video/riva/fbdev.c         |    3 +--
 7 files changed, 9 insertions(+), 20 deletions(-)

diff -puN drivers/video/au1100fb.c~video-fb-kzalloc-changes drivers/video/au1100fb.c
--- a/drivers/video/au1100fb.c~video-fb-kzalloc-changes
+++ a/drivers/video/au1100fb.c
@@ -468,11 +468,10 @@ int au1100fb_drv_probe(struct device *de
 			return -EINVAL;
 
 	/* Allocate new device private */
-	if (!(fbdev = kmalloc(sizeof(struct au1100fb_device), GFP_KERNEL))) {
+	if (!(fbdev = kzalloc(sizeof(struct au1100fb_device), GFP_KERNEL))) {
 		print_err("fail to allocate device private record");
 		return -ENOMEM;
 	}
-	memset((void*)fbdev, 0, sizeof(struct au1100fb_device));
 
 	fbdev->panel = &known_lcd_panels[drv_info.panel_idx];
 
@@ -549,10 +548,9 @@ int au1100fb_drv_probe(struct device *de
 	fbdev->info.fbops = &au1100fb_ops;
 	fbdev->info.fix = au1100fb_fix;
 
-	if (!(fbdev->info.pseudo_palette = kmalloc(sizeof(u32) * 16, GFP_KERNEL))) {
+	if (!(fbdev->info.pseudo_palette = kzalloc(sizeof(u32) * 16, GFP_KERNEL))) {
 		return -ENOMEM;
 	}
-	memset(fbdev->info.pseudo_palette, 0, sizeof(u32) * 16);
 
 	if (fb_alloc_cmap(&fbdev->info.cmap, AU1100_LCD_NBR_PALETTE_ENTRIES, 0) < 0) {
 		print_err("Fail to allocate colormap (%d entries)",
diff -puN drivers/video/controlfb.c~video-fb-kzalloc-changes drivers/video/controlfb.c
--- a/drivers/video/controlfb.c~video-fb-kzalloc-changes
+++ a/drivers/video/controlfb.c
@@ -696,11 +696,10 @@ static int __init control_of_init(struct
 		printk(KERN_ERR "can't get 2 addresses for control\n");
 		return -ENXIO;
 	}
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (p == 0)
 		return -ENXIO;
 	control_fb = p;	/* save it for cleanups */
-	memset(p, 0, sizeof(*p));
 
 	/* Map in frame buffer and registers */
 	p->fb_orig_base = fb_res.start;
diff -puN drivers/video/i810/i810_main.c~video-fb-kzalloc-changes drivers/video/i810/i810_main.c
--- a/drivers/video/i810/i810_main.c~video-fb-kzalloc-changes
+++ a/drivers/video/i810/i810_main.c
@@ -2021,11 +2021,10 @@ static int __devinit i810fb_init_pci (st
 	par = info->par;
 	par->dev = dev;
 
-	if (!(info->pixmap.addr = kmalloc(8*1024, GFP_KERNEL))) {
+	if (!(info->pixmap.addr = kzalloc(8*1024, GFP_KERNEL))) {
 		i810fb_release_resource(info, par);
 		return -ENOMEM;
 	}
-	memset(info->pixmap.addr, 0, 8*1024);
 	info->pixmap.size = 8*1024;
 	info->pixmap.buf_align = 8;
 	info->pixmap.access_align = 32;
diff -puN drivers/video/igafb.c~video-fb-kzalloc-changes drivers/video/igafb.c
--- a/drivers/video/igafb.c~video-fb-kzalloc-changes
+++ a/drivers/video/igafb.c
@@ -401,12 +401,11 @@ int __init igafb_init(void)
 	
 	size = sizeof(struct fb_info) + sizeof(struct iga_par) + sizeof(u32)*16;
 
-        info = kmalloc(size, GFP_ATOMIC);
+        info = kzalloc(size, GFP_ATOMIC);
         if (!info) {
                 printk("igafb_init: can't alloc fb_info\n");
                 return -ENOMEM;
         }
-        memset(info, 0, size);
 
 	par = (struct iga_par *) (info + 1);
 	
@@ -465,7 +464,7 @@ int __init igafb_init(void)
 	 * one additional region with size == 0. 
 	 */
 
-	par->mmap_map = kmalloc(4 * sizeof(*par->mmap_map), GFP_ATOMIC);
+	par->mmap_map = kzalloc(4 * sizeof(*par->mmap_map), GFP_ATOMIC);
 	if (!par->mmap_map) {
 		printk("igafb_init: can't alloc mmap_map\n");
 		iounmap((void *)par->io_base);
@@ -474,8 +473,6 @@ int __init igafb_init(void)
 		return -ENOMEM;
 	}
 
-	memset(par->mmap_map, 0, 4 * sizeof(*par->mmap_map));
-
 	/*
 	 * Set default vmode and cmode from PROM properties.
 	 */
diff -puN drivers/video/intelfb/intelfbdrv.c~video-fb-kzalloc-changes drivers/video/intelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c~video-fb-kzalloc-changes
+++ a/drivers/video/intelfb/intelfbdrv.c
@@ -540,12 +540,11 @@ intelfb_pci_register(struct pci_dev *pde
 	dinfo->pdev  = pdev;
 
 	/* Reserve pixmap space. */
-	info->pixmap.addr = kmalloc(64 * 1024, GFP_KERNEL);
+	info->pixmap.addr = kzalloc(64 * 1024, GFP_KERNEL);
 	if (info->pixmap.addr == NULL) {
 		ERR_MSG("Cannot reserve pixmap memory.\n");
 		goto err_out_pixmap;
 	}
-	memset(info->pixmap.addr, 0, 64 * 1024);
 
 	/* set early this option because it could be changed by tv encoder
 	   driver */
diff -puN drivers/video/nvidia/nvidia.c~video-fb-kzalloc-changes drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~video-fb-kzalloc-changes
+++ a/drivers/video/nvidia/nvidia.c
@@ -1205,13 +1205,11 @@ static int __devinit nvidiafb_probe(stru
 	par = info->par;
 	par->pci_dev = pd;
 
-	info->pixmap.addr = kmalloc(8 * 1024, GFP_KERNEL);
+	info->pixmap.addr = kzalloc(8 * 1024, GFP_KERNEL);
 
 	if (info->pixmap.addr == NULL)
 		goto err_out_kfree;
 
-	memset(info->pixmap.addr, 0, 8 * 1024);
-
 	if (pci_enable_device(pd)) {
 		printk(KERN_ERR PFX "cannot enable PCI device\n");
 		goto err_out_enable;
diff -puN drivers/video/riva/fbdev.c~video-fb-kzalloc-changes drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~video-fb-kzalloc-changes
+++ a/drivers/video/riva/fbdev.c
@@ -1984,12 +1984,11 @@ static int __devinit rivafb_probe(struct
 	default_par = info->par;
 	default_par->pdev = pd;
 
-	info->pixmap.addr = kmalloc(8 * 1024, GFP_KERNEL);
+	info->pixmap.addr = kzalloc(8 * 1024, GFP_KERNEL);
 	if (info->pixmap.addr == NULL) {
 	    	ret = -ENOMEM;
 		goto err_framebuffer_release;
 	}
-	memset(info->pixmap.addr, 0, 8 * 1024);
 
 	ret = pci_enable_device(pd);
 	if (ret < 0) {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-watchdog.patch
shrink_slab-handle-bad-shrinkers.patch
