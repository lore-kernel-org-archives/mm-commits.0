From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-tgafb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:20 -0800
Message-ID: <200612082012.kB8KCKrN002997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946690AbWLHUM2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/tgafb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-tgafb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/tgafb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/tgafb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/tgafb.c~ioremap-balanced-with-iounmap-for-drivers-video-tgafb drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~ioremap-balanced-with-iounmap-for-drivers-video-tgafb
+++ a/drivers/video/tgafb.c
@@ -1439,6 +1439,8 @@ tgafb_pci_register(struct pci_dev *pdev,
 	return 0;
 
  err1:
+	if (mem_base)
+		iounmap(mem_base);
 	release_mem_region(bar0_start, bar0_len);
  err0:
 	kfree(all);
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
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

