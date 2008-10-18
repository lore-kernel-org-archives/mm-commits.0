From: akpm@linux-foundation.org
Subject: - tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:03 -0700
Message-ID: <200810182317.m9INH3eC029004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800AbYJRXRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: do not make changes to default tdfx_fix
has been removed from the -mm tree.  Its filename was
     tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tdfxfb: do not make changes to default tdfx_fix
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This was suggested by Geert Uytterhoeven to avoid overwriting of default
values from the tdfx_fix.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |   48 +++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-do-not-make-changes-to-default-tdfx_fix drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-do-not-make-changes-to-default-tdfx_fix
+++ a/drivers/video/tdfxfb.c
@@ -1195,57 +1195,58 @@ static int __devinit tdfxfb_probe(struct
 		return -ENOMEM;
 
 	default_par = info->par;
+	info->fix = tdfx_fix;
 
 	/* Configure the default fb_fix_screeninfo first */
 	switch (pdev->device) {
 	case PCI_DEVICE_ID_3DFX_BANSHEE:
-		strcpy(tdfx_fix.id, "3Dfx Banshee");
+		strcpy(info->fix.id, "3Dfx Banshee");
 		default_par->max_pixclock = BANSHEE_MAX_PIXCLOCK;
 		break;
 	case PCI_DEVICE_ID_3DFX_VOODOO3:
-		strcpy(tdfx_fix.id, "3Dfx Voodoo3");
+		strcpy(info->fix.id, "3Dfx Voodoo3");
 		default_par->max_pixclock = VOODOO3_MAX_PIXCLOCK;
 		break;
 	case PCI_DEVICE_ID_3DFX_VOODOO5:
-		strcpy(tdfx_fix.id, "3Dfx Voodoo5");
+		strcpy(info->fix.id, "3Dfx Voodoo5");
 		default_par->max_pixclock = VOODOO5_MAX_PIXCLOCK;
 		break;
 	}
 
-	tdfx_fix.mmio_start = pci_resource_start(pdev, 0);
-	tdfx_fix.mmio_len = pci_resource_len(pdev, 0);
-	if (!request_mem_region(tdfx_fix.mmio_start, tdfx_fix.mmio_len,
+	info->fix.mmio_start = pci_resource_start(pdev, 0);
+	info->fix.mmio_len = pci_resource_len(pdev, 0);
+	if (!request_mem_region(info->fix.mmio_start, info->fix.mmio_len,
 				"tdfx regbase")) {
 		printk(KERN_ERR "tdfxfb: Can't reserve regbase\n");
 		goto out_err;
 	}
 
 	default_par->regbase_virt =
-		ioremap_nocache(tdfx_fix.mmio_start, tdfx_fix.mmio_len);
+		ioremap_nocache(info->fix.mmio_start, info->fix.mmio_len);
 	if (!default_par->regbase_virt) {
 		printk(KERN_ERR "fb: Can't remap %s register area.\n",
-				tdfx_fix.id);
+				info->fix.id);
 		goto out_err_regbase;
 	}
 
-	tdfx_fix.smem_start = pci_resource_start(pdev, 1);
-	tdfx_fix.smem_len = do_lfb_size(default_par, pdev->device);
-	if (!tdfx_fix.smem_len) {
-		printk(KERN_ERR "fb: Can't count %s memory.\n", tdfx_fix.id);
+	info->fix.smem_start = pci_resource_start(pdev, 1);
+	info->fix.smem_len = do_lfb_size(default_par, pdev->device);
+	if (!info->fix.smem_len) {
+		printk(KERN_ERR "fb: Can't count %s memory.\n", info->fix.id);
 		goto out_err_regbase;
 	}
 
-	if (!request_mem_region(tdfx_fix.smem_start,
+	if (!request_mem_region(info->fix.smem_start,
 				pci_resource_len(pdev, 1), "tdfx smem")) {
 		printk(KERN_ERR "tdfxfb: Can't reserve smem\n");
 		goto out_err_regbase;
 	}
 
-	info->screen_base = ioremap_nocache(tdfx_fix.smem_start,
-					    tdfx_fix.smem_len);
+	info->screen_base = ioremap_nocache(info->fix.smem_start,
+					    info->fix.smem_len);
 	if (!info->screen_base) {
 		printk(KERN_ERR "fb: Can't remap %s framebuffer.\n",
-				tdfx_fix.id);
+				info->fix.id);
 		goto out_err_screenbase;
 	}
 
@@ -1257,20 +1258,19 @@ static int __devinit tdfxfb_probe(struct
 		goto out_err_screenbase;
 	}
 
-	printk(KERN_INFO "fb: %s memory = %dK\n", tdfx_fix.id,
-			tdfx_fix.smem_len >> 10);
+	printk(KERN_INFO "fb: %s memory = %dK\n", info->fix.id,
+			info->fix.smem_len >> 10);
 
 	default_par->mtrr_handle = -1;
 	if (!nomtrr)
 		default_par->mtrr_handle =
-			mtrr_add(tdfx_fix.smem_start, tdfx_fix.smem_len,
+			mtrr_add(info->fix.smem_start, info->fix.smem_len,
 				 MTRR_TYPE_WRCOMB, 1);
 
-	tdfx_fix.ypanstep	= nopan ? 0 : 1;
-	tdfx_fix.ywrapstep	= nowrap ? 0 : 1;
+	info->fix.ypanstep	= nopan ? 0 : 1;
+	info->fix.ywrapstep	= nowrap ? 0 : 1;
 
 	info->fbops		= &tdfxfb_ops;
-	info->fix		= tdfx_fix;
 	info->pseudo_palette	= default_par->palette;
 	info->flags		= FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
 #ifdef CONFIG_FB_3DFX_ACCEL
@@ -1323,14 +1323,14 @@ out_err_iobase:
 out_err_screenbase:
 	if (info->screen_base)
 		iounmap(info->screen_base);
-	release_mem_region(tdfx_fix.smem_start, pci_resource_len(pdev, 1));
+	release_mem_region(info->fix.smem_start, pci_resource_len(pdev, 1));
 out_err_regbase:
 	/*
 	 * Cleanup after anything that was remapped/allocated.
 	 */
 	if (default_par->regbase_virt)
 		iounmap(default_par->regbase_virt);
-	release_mem_region(tdfx_fix.mmio_start, tdfx_fix.mmio_len);
+	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
 out_err:
 	framebuffer_release(info);
 	return -ENXIO;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

