From: akpm@linux-foundation.org
Subject: - change-nvidiafb_remove-to-__devexit.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:50:03 -0800
Message-ID: <200702122250.l1CMo3aH014191@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030395AbXBLWuT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:50:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     change nvidiafb_remove to __devexit
has been removed from the -mm tree.  Its filename was
     change-nvidiafb_remove-to-__devexit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: change nvidiafb_remove to __devexit
From: Prarit Bhargava <prarit@redhat.com>

Change nvidiafb_remove to __devexit to fix MODPOST warnings:

WARNING: drivers/video/nvidia/nvidiafb.o - Section mismatch: reference to
.exit.text:nvidiafb_remove from .data.rel.local after 'nvidiafb_driver' (at
offset 0x28)

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-By: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nvidia.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/nvidia/nvidia.c~change-nvidiafb_remove-to-__devexit drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~change-nvidiafb_remove-to-__devexit
+++ a/drivers/video/nvidia/nvidia.c
@@ -1345,7 +1345,7 @@ err_out:
 	return -ENODEV;
 }
 
-static void __exit nvidiafb_remove(struct pci_dev *pd)
+static void __devexit nvidiafb_remove(struct pci_dev *pd)
 {
 	struct fb_info *info = pci_get_drvdata(pd);
 	struct nvidia_par *par = info->par;
@@ -1431,7 +1431,7 @@ static struct pci_driver nvidiafb_driver
 	.probe    = nvidiafb_probe,
 	.suspend  = nvidiafb_suspend,
 	.resume   = nvidiafb_resume,
-	.remove   = __exit_p(nvidiafb_remove),
+	.remove   = __devexit_p(nvidiafb_remove),
 };
 
 /* ------------------------------------------------------------------------- *
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
change-__init-to-__devinit-for-isp116x_probe.patch
