From: akpm@linux-foundation.org
Subject: - qla2xxx-remove-duplicate-pci_disable_device-call.patch removed from -mm tree
Date: Sun, 01 Apr 2007 23:14:49 -0700
Message-ID: <200704020614.l326EnW9025952@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39793 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933844AbXDBGPB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 02:15:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, James.Bottomley@steeleye.com, andrew.vasquez@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     qla2xxx: remove duplicate pci_disable_device() call
has been removed from the -mm tree.  Its filename was
     qla2xxx-remove-duplicate-pci_disable_device-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qla2xxx: remove duplicate pci_disable_device() call
From: Bernhard Walle <bwalle@suse.de>

On the path qla2x00_probe_one() -> probe_failed -> qla2x00_free_device(),
pci_disable_device() is executed twice, once in qla2x00_free_device() and
once in qla2x00_probe_one().

This patch removes the unnecessary call.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_os.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~qla2xxx-remove-duplicate-pci_disable_device-call drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~qla2xxx-remove-duplicate-pci_disable_device-call
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -1707,6 +1707,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_host_put(ha->host);
 
+	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 }
 
@@ -1749,8 +1750,6 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	if (ha->iobase)
 		iounmap(ha->iobase);
 	pci_release_regions(ha->pdev);
-
-	pci_disable_device(ha->pdev);
 }
 
 static inline void
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
git-r8169.patch
git-scsi-misc.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-parisc.patch
add-irqf_irqpoll-flag-on-arm.patch
