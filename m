From: akpm@linux-foundation.org
Subject: + libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:39:12 -0800
Message-ID: <200702272039.l1RKdGKK027686@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50887 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbXB0Uj5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:39:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org


The patch titled
     libata: handle ata_pci_device_do_resume() failure while resuming
has been added to the -mm tree.  Its filename is
     libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -639,7 +639,9 @@ static int inic_pci_device_resume(struct
 	void __iomem *mmio_base = host->iomap[MMIO_BAR];
 	int rc;
 
-	ata_pci_device_do_resume(pdev);
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
 		printk("XXX\n");
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

libata-handle-ata_pci_device_do_resume-failure-while-resuming-v2.patch
3c59x-handle-pci_enable_device-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
