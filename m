From: akpm@linux-foundation.org
Subject: + qla1280-use-dma_64bit_mask-instead-of-0ull.patch added to -mm tree
Date: Fri, 20 Apr 2007 13:35:22 -0700
Message-ID: <200704202035.l3KKZMTp023288@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767249AbXDTUfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 16:35:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     qla1280: use DMA_64BIT_MASK instead of ~0ULL
has been added to the -mm tree.  Its filename is
     qla1280-use-dma_64bit_mask-instead-of-0ull.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: qla1280: use DMA_64BIT_MASK instead of ~0ULL
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

QLA1280: call pci_set_dma_mask with DMA_64BIT_MASK instead of  ~0ULL

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla1280.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/qla1280.c~qla1280-use-dma_64bit_mask-instead-of-0ull drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c~qla1280-use-dma_64bit_mask-instead-of-0ull
+++ a/drivers/scsi/qla1280.c
@@ -4293,7 +4293,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
 		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
