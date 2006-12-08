From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:49 -0800
Message-ID: <200612082012.kB8KCnfS003033@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59384 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946724AbWLHUMz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/cirrusfb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/cirrusfb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/cirrusfb.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/video/cirrusfb.c~ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb
+++ a/drivers/video/cirrusfb.c
@@ -2442,7 +2442,10 @@ static int cirrusfb_pci_register (struct
 	printk ("Cirrus Logic chipset on PCI bus\n");
 	pci_set_drvdata(pdev, info);
 
-	return cirrusfb_register(cinfo);
+	ret = cirrusfb_register(cinfo);
+	if (ret)
+		iounmap(cinfo->fbmem);
+	return ret;
 
 err_release_legacy:
 	if (release_io_ports)
@@ -2574,7 +2577,15 @@ static int cirrusfb_zorro_register(struc
 	printk (KERN_INFO "Cirrus Logic chipset on Zorro bus\n");
 	zorro_set_drvdata(z, info);
 
-	return cirrusfb_register(cinfo);
+	ret = cirrusfb_register(cinfo);
+	if (ret) {
+		if (btype == BT_PICASSO4) {
+			iounmap(cinfo->fbmem);
+			iounmap(cinfo->regbase - 0x600000);
+		} else if (board_addr > 0x01000000)
+			iounmap(cinfo->fbmem);
+	}
+	return ret;
 
 err_unmap_regbase:
 	/* Parental advisory: explicit hack */
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch
ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch

