From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:28 -0800
Message-ID: <200612082012.kB8KCSK3003006@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59307 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946710AbWLHUMi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/pvr2fb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/pvr2fb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/pvr2fb.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN drivers/video/pvr2fb.c~ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb drivers/video/pvr2fb.c
--- a/drivers/video/pvr2fb.c~ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb
+++ a/drivers/video/pvr2fb.c
@@ -905,6 +905,15 @@ static int __init pvr2fb_dc_init(void)
 
 static void pvr2fb_dc_exit(void)
 {
+	if (fb_info->screen_base) {
+		iounmap(fb_info->screen_base);
+		fb_info->screen_base = NULL;
+	}
+	if (currentpar->mmio_base) {
+		iounmap((void *)currentpar->mmio_base);
+		currentpar->mmio_base = 0;
+	}
+
 	free_irq(HW_EVENT_VSYNC, 0);
 #ifdef CONFIG_SH_DMA
 	free_dma(pvr2dma);
@@ -946,6 +955,15 @@ static int __devinit pvr2fb_pci_probe(st
 
 static void __devexit pvr2fb_pci_remove(struct pci_dev *pdev)
 {
+	if (fb_info->screen_base) {
+		iounmap(fb_info->screen_base);
+		fb_info->screen_base = NULL;
+	}
+	if (currentpar->mmio_base) {
+		iounmap((void *)currentpar->mmio_base);
+		currentpar->mmio_base = 0;
+	}
+
 	pci_release_regions(pdev);
 }
 
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
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

