From: akpm@linux-foundation.org
Subject: + qla2xxx-remove-duplicate-pci_disable_device-call.patch added to -mm tree
Date: Wed, 28 Mar 2007 16:03:34 -0700
Message-ID: <200703282303.l2SN3YLW022254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34850 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965801AbXC1XDv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 19:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, James.Bottomley@steeleye.com, andrew.vasquez@qlogic.com


The patch titled
     qla2xxx: remove duplicate pci_disable_device() call
has been added to the -mm tree.  Its filename is
     qla2xxx-remove-duplicate-pci_disable_device-call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
qla2xxx-remove-duplicate-pci_disable_device-call.patch
x86_64-i386-add-command-line-length-to-boot-protocol.patch
x86_64-fix-section-mismatch-compile-warning.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-parisc.patch
add-irqf_irqpoll-flag-on-arm.patch
