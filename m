From: akpm@linux-foundation.org
Subject: + drivers-video-pmag-ba-fbc-improve-diagnostics.patch added to -mm tree
Date: Wed, 19 Sep 2007 17:24:43 -0700
Message-ID: <200709200024.l8K0OhOD020230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756610AbXITAY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 20:24:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, adaplas@pol.net, m.kozlowski@tuxland.pl, ralf@linux-mips.org


The patch titled
     drivers/video/pmag-ba-fb.c: improve diagnostics
has been added to the -mm tree.  Its filename is
     drivers-video-pmag-ba-fbc-improve-diagnostics.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/video/pmag-ba-fb.c: improve diagnostics
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Add error messages to the probe call.

While they may rarely trigger, they may be useful when something weird is
going on.  Also this is good style.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pmag-ba-fb.c |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff -puN drivers/video/pmag-ba-fb.c~drivers-video-pmag-ba-fbc-improve-diagnostics drivers/video/pmag-ba-fb.c
--- a/drivers/video/pmag-ba-fb.c~drivers-video-pmag-ba-fbc-improve-diagnostics
+++ a/drivers/video/pmag-ba-fb.c
@@ -147,16 +147,23 @@ static int __init pmagbafb_probe(struct 
 	resource_size_t start, len;
 	struct fb_info *info;
 	struct pmagbafb_par *par;
+	int err = 0;
 
 	info = framebuffer_alloc(sizeof(struct pmagbafb_par), dev);
-	if (!info)
+	if (!info) {
+		printk(KERN_ERR "%s: Cannot allocate memory\n", dev->bus_id);
 		return -ENOMEM;
+	}
 
 	par = info->par;
 	dev_set_drvdata(dev, info);
 
-	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0)
+	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
+		printk(KERN_ERR "%s: Cannot allocate color map\n",
+		       dev->bus_id);
+		err = -ENOMEM;
 		goto err_alloc;
+	}
 
 	info->fbops = &pmagbafb_ops;
 	info->fix = pmagbafb_fix;
@@ -166,28 +173,41 @@ static int __init pmagbafb_probe(struct 
 	/* Request the I/O MEM resource.  */
 	start = tdev->resource.start;
 	len = tdev->resource.end - start + 1;
-	if (!request_mem_region(start, len, dev->bus_id))
+	if (!request_mem_region(start, len, dev->bus_id)) {
+		printk(KERN_ERR "%s: Cannot reserve FB region\n", dev->bus_id);
+		err = -EBUSY;
 		goto err_cmap;
+	}
 
 	/* MMIO mapping setup.  */
 	info->fix.mmio_start = start;
 	par->mmio = ioremap_nocache(info->fix.mmio_start, info->fix.mmio_len);
-	if (!par->mmio)
+	if (!par->mmio) {
+		printk(KERN_ERR "%s: Cannot map MMIO\n", dev->bus_id);
+		err = -ENOMEM;
 		goto err_resource;
+	}
 	par->dac = par->mmio + PMAG_BA_BT459;
 
 	/* Frame buffer mapping setup.  */
 	info->fix.smem_start = start + PMAG_BA_FBMEM;
 	info->screen_base = ioremap_nocache(info->fix.smem_start,
 					    info->fix.smem_len);
-	if (!info->screen_base)
+	if (!info->screen_base) {
+		printk(KERN_ERR "%s: Cannot map FB\n", dev->bus_id);
+		err = -ENOMEM;
 		goto err_mmio_map;
+	}
 	info->screen_size = info->fix.smem_len;
 
 	pmagbafb_erase_cursor(info);
 
-	if (register_framebuffer(info) < 0)
+	err = register_framebuffer(info);
+	if (err < 0) {
+		printk(KERN_ERR "%s: Cannot register framebuffer\n",
+		       dev->bus_id);
 		goto err_smem_map;
+	}
 
 	get_device(dev);
 
@@ -211,7 +231,7 @@ err_cmap:
 
 err_alloc:
 	framebuffer_release(info);
-	return -ENXIO;
+	return err;
 }
 
 static int __exit pmagbafb_remove(struct device *dev)
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
git-mips.patch
sb1250-macc-de-typedef-de-volatile-de-etc.patch
net_sb1250_mac-update-kconfig-entry.patch
net_sb1250_mac-rename-to-sb1250_mac.patch
phylib-spinlock-fixes-for-softirqs.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
lk201-remove-obsolete-driver.patch
drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
