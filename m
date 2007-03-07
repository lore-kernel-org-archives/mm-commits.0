From: akpm@linux-foundation.org
Subject: - libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:33 -0800
Message-ID: <200703070422.l274MX2j019000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47196 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbXCGEXL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:23:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@sw.ru, dmonakhov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     libata: handle ata_pci_device_do_resume() failure while resuming
has been removed from the -mm tree.  Its filename was
     libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: handle ata_pci_device_do_resume() failure while resuming
From: Dmitriy Monakhov <dmonakhov@sw.ru>

Since commit:553c4aa630af7bc885e056d0436e4eb7f238579b
ata_pci_device_do_resume() can return error code, all callers was updated
except this one.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_inic162x.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/ata/sata_inic162x.c~libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2 drivers/ata/sata_inic162x.c
--- a/drivers/ata/sata_inic162x.c~libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2
+++ a/drivers/ata/sata_inic162x.c
@@ -642,7 +642,9 @@ static int inic_pci_device_resume(struct
 	void __iomem *mmio_base = host->iomap[MMIO_BAR];
 	int rc;
 
-	ata_pci_device_do_resume(pdev);
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
 		rc = init_controller(mmio_base, hpriv->cached_hctl);
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

origin.patch
git-libata-all.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
ext3-dirindex-error-pointer-issues.patch
