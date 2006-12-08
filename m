From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-tridentfb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:17 -0800
Message-ID: <200612082012.kB8KCH2v002994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59263 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946692AbWLHUM3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, Knut_Petersen@t-online.de, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/tridentfb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-tridentfb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/tridentfb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Knut Petersen <Knut_Petersen@t-online.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/tridentfb.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN drivers/video/tridentfb.c~ioremap-balanced-with-iounmap-for-drivers-video-tridentfb drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~ioremap-balanced-with-iounmap-for-drivers-video-tridentfb
+++ a/drivers/video/tridentfb.c
@@ -1130,7 +1130,8 @@ static int __devinit trident_pci_probe(s
 	
 	if (!request_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len, "tridentfb")) {
 		debug("request_mem_region failed!\n");
-		return -1;
+		err = -1;
+		goto out_unmap;
 	}
 
 	fb_info.screen_base = ioremap_nocache(tridentfb_fix.smem_start,
@@ -1139,7 +1140,8 @@ static int __devinit trident_pci_probe(s
 	if (!fb_info.screen_base) {
 		release_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len);
 		debug("ioremap failed\n");
-		return -1;
+		err = -1;
+		goto out_unmap;
 	}
 
 	output("%s board found\n", pci_name(dev));
@@ -1162,8 +1164,10 @@ static int __devinit trident_pci_probe(s
 #endif
 	fb_info.pseudo_palette = pseudo_pal;
 
-	if (!fb_find_mode(&default_var,&fb_info,mode,NULL,0,NULL,bpp))
-		return -EINVAL;
+	if (!fb_find_mode(&default_var,&fb_info,mode,NULL,0,NULL,bpp)) {
+		err = -EINVAL;
+		goto out_unmap;
+	}
 	fb_alloc_cmap(&fb_info.cmap,256,0);
 	if (defaultaccel && acc)
 		default_var.accel_flags |= FB_ACCELF_TEXT;
@@ -1174,12 +1178,20 @@ static int __devinit trident_pci_probe(s
 	fb_info.device = &dev->dev;
 	if (register_framebuffer(&fb_info) < 0) {
 		printk(KERN_ERR "tridentfb: could not register Trident framebuffer\n");
-		return -EINVAL;
+		err = -EINVAL;
+		goto out_unmap;
 	}
 	output("fb%d: %s frame buffer device %dx%d-%dbpp\n",
 	   fb_info.node, fb_info.fix.id,default_var.xres,
 	   default_var.yres,default_var.bits_per_pixel);
 	return 0;
+
+out_unmap:
+	if (default_par.io_virt)
+		iounmap(default_par.io_virt);
+	if (fb_info.screen_base)
+		iounmap(fb_info.screen_base);
+	return err;
 }
 
 static void __devexit trident_pci_remove(struct pci_dev * dev)
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
ioremap-balanced-with-iounmap-for-drivers-video-tridentfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tgafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-stifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-retz3fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-platinumfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-offb.patch
ioremap-balanced-with-iounmap-for-drivers-video-macfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-hpfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-fm2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-ffb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cyberfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch
ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch

