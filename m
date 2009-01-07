From: akpm@linux-foundation.org
Subject: - pci-use-pci_ioremap_bar-in-drivers-video.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:35 -0800
Message-ID: <200901072219.n07MJZRs018903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762382AbZAGWh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     pci: use pci_ioremap_bar() in drivers/video
has been removed from the -mm tree.  Its filename was
     pci-use-pci_ioremap_bar-in-drivers-video.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: use pci_ioremap_bar() in drivers/video
From: Arjan van de Ven <arjan@linux.intel.com>

Use the newly introduced pci_ioremap_bar() function in drivers/video. 
pci_ioremap_bar() just takes a pci device and a bar number, with the goal
of making it really hard to get wrong, while also having a central place
to stick sanity checks.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c     |    2 +-
 drivers/video/cyber2000fb.c      |    3 +--
 drivers/video/geode/gx1fb_core.c |    3 +--
 drivers/video/geode/gxfb_core.c  |    8 +++-----
 drivers/video/geode/lxfb_core.c  |    9 +++------
 drivers/video/gxt4500.c          |    4 ++--
 6 files changed, 11 insertions(+), 18 deletions(-)

diff -puN drivers/video/aty/aty128fb.c~pci-use-pci_ioremap_bar-in-drivers-video drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~pci-use-pci_ioremap_bar-in-drivers-video
+++ a/drivers/video/aty/aty128fb.c
@@ -2051,7 +2051,7 @@ static int __devinit aty128_probe(struct
 
 	/* Virtualize mmio region */
 	info->fix.mmio_start = reg_addr;
-	par->regbase = ioremap(reg_addr, pci_resource_len(pdev, 2));
+	par->regbase = pci_ioremap_bar(pdev, 2);
 	if (!par->regbase)
 		goto err_free_info;
 
diff -puN drivers/video/cyber2000fb.c~pci-use-pci_ioremap_bar-in-drivers-video drivers/video/cyber2000fb.c
--- a/drivers/video/cyber2000fb.c~pci-use-pci_ioremap_bar-in-drivers-video
+++ a/drivers/video/cyber2000fb.c
@@ -1583,8 +1583,7 @@ cyberpro_pci_probe(struct pci_dev *dev, 
 		goto failed_release;
 
 	cfb->dev = dev;
-	cfb->region = ioremap(pci_resource_start(dev, 0),
-			      pci_resource_len(dev, 0));
+	cfb->region = pci_ioremap_bar(dev, 0);
 	if (!cfb->region)
 		goto failed_ioremap;
 
diff -puN drivers/video/geode/gx1fb_core.c~pci-use-pci_ioremap_bar-in-drivers-video drivers/video/geode/gx1fb_core.c
--- a/drivers/video/geode/gx1fb_core.c~pci-use-pci_ioremap_bar-in-drivers-video
+++ a/drivers/video/geode/gx1fb_core.c
@@ -217,8 +217,7 @@ static int __init gx1fb_map_video_memory
 	ret = pci_request_region(dev, 0, "gx1fb (video)");
 	if (ret < 0)
 		return ret;
-	par->vid_regs = ioremap(pci_resource_start(dev, 0),
-				pci_resource_len(dev, 0));
+	par->vid_regs = pci_ioremap_bar(dev, 0);
 	if (!par->vid_regs)
 		return -ENOMEM;
 
diff -puN drivers/video/geode/gxfb_core.c~pci-use-pci_ioremap_bar-in-drivers-video drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~pci-use-pci_ioremap_bar-in-drivers-video
+++ a/drivers/video/geode/gxfb_core.c
@@ -242,23 +242,21 @@ static int __init gxfb_map_video_memory(
 	ret = pci_request_region(dev, 3, "gxfb (video processor)");
 	if (ret < 0)
 		return ret;
-	par->vid_regs = ioremap(pci_resource_start(dev, 3),
-				pci_resource_len(dev, 3));
+	par->vid_regs = pci_ioremap_bar(dev, 3);
 	if (!par->vid_regs)
 		return -ENOMEM;
 
 	ret = pci_request_region(dev, 2, "gxfb (display controller)");
 	if (ret < 0)
 		return ret;
-	par->dc_regs = ioremap(pci_resource_start(dev, 2), pci_resource_len(dev, 2));
+	par->dc_regs = pci_ioremap_bar(dev, 2);
 	if (!par->dc_regs)
 		return -ENOMEM;
 
 	ret = pci_request_region(dev, 1, "gxfb (graphics processor)");
 	if (ret < 0)
 		return ret;
-	par->gp_regs = ioremap(pci_resource_start(dev, 1),
-	pci_resource_len(dev, 1));
+	par->gp_regs = pci_ioremap_bar(dev, 1);
 
 	if (!par->gp_regs)
 		return -ENOMEM;
diff -puN drivers/video/geode/lxfb_core.c~pci-use-pci_ioremap_bar-in-drivers-video drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~pci-use-pci_ioremap_bar-in-drivers-video
+++ a/drivers/video/geode/lxfb_core.c
@@ -379,20 +379,17 @@ static int __init lxfb_map_video_memory(
 	if (info->screen_base == NULL)
 		return ret;
 
-	par->gp_regs = ioremap(pci_resource_start(dev, 1),
-				pci_resource_len(dev, 1));
+	par->gp_regs = pci_ioremap_bar(dev, 1);
 
 	if (par->gp_regs == NULL)
 		return ret;
 
-	par->dc_regs = ioremap(pci_resource_start(dev, 2),
-			       pci_resource_len(dev, 2));
+	par->dc_regs = pci_ioremap_bar(dev, 2);
 
 	if (par->dc_regs == NULL)
 		return ret;
 
-	par->vp_regs = ioremap(pci_resource_start(dev, 3),
-			       pci_resource_len(dev, 3));
+	par->vp_regs = pci_ioremap_bar(dev, 3);
 
 	if (par->vp_regs == NULL)
 		return ret;
diff -puN drivers/video/gxt4500.c~pci-use-pci_ioremap_bar-in-drivers-video drivers/video/gxt4500.c
--- a/drivers/video/gxt4500.c~pci-use-pci_ioremap_bar-in-drivers-video
+++ a/drivers/video/gxt4500.c
@@ -648,7 +648,7 @@ static int __devinit gxt4500_probe(struc
 	info->pseudo_palette = par->pseudo_palette;
 
 	info->fix.mmio_start = reg_phys;
-	par->regs = ioremap(reg_phys, pci_resource_len(pdev, 0));
+	par->regs = pci_ioremap_bar(pdev, 0);
 	if (!par->regs) {
 		dev_err(&pdev->dev, "gxt4500: cannot map registers\n");
 		goto err_free_all;
@@ -656,7 +656,7 @@ static int __devinit gxt4500_probe(struc
 
 	info->fix.smem_start = fb_phys;
 	info->fix.smem_len = pci_resource_len(pdev, 1);
-	info->screen_base = ioremap(fb_phys, pci_resource_len(pdev, 1));
+	info->screen_base = pci_ioremap_bar(pdev, 1);
 	if (!info->screen_base) {
 		dev_err(&pdev->dev, "gxt4500: cannot map framebuffer\n");
 		goto err_unmap_regs;
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch

