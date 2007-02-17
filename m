From: akpm@linux-foundation.org
Subject: - scsi-megaraid_sas-replace-pci_alloc_consitent-with-dma_alloc_coherent-in-ioctl-path.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:17:06 -0800
Message-ID: <200702170717.l1H7H68h021764@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51209 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946537AbXBQHRJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sumantp@lsil.com, sumant.patro@lsi.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid_sas - replace pci_alloc_consitent with dma_alloc_coherent in ioctl path
has been removed from the -mm tree.  Its filename was
     scsi-megaraid_sas-replace-pci_alloc_consitent-with-dma_alloc_coherent-in-ioctl-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: megaraid_sas - replace pci_alloc_consitent with dma_alloc_coherent in ioctl path
From: Sumant Patro <sumantp@lsil.com>

Replaced pci_alloc_consistent with dma_alloc_coherent from the ioctl path. 
This is to avoid situations where ioctl fails for lack of memory (when system
under heavy stress).

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-replace-pci_alloc_consitent-with-dma_alloc_coherent-in-ioctl-path drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~scsi-megaraid_sas-replace-pci_alloc_consitent-with-dma_alloc_coherent-in-ioctl-path
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -2738,9 +2738,9 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	 * For each user buffer, create a mirror buffer and copy in
 	 */
 	for (i = 0; i < ioc->sge_count; i++) {
-		kbuff_arr[i] = pci_alloc_consistent(instance->pdev,
+		kbuff_arr[i] = dma_alloc_coherent(&instance->pdev->dev,
 						    ioc->sgl[i].iov_len,
-						    &buf_handle);
+						    &buf_handle, GFP_KERNEL);
 		if (!kbuff_arr[i]) {
 			printk(KERN_DEBUG "megasas: Failed to alloc "
 			       "kernel SGL buffer for IOCTL \n");
@@ -2767,8 +2767,8 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	}
 
 	if (ioc->sense_len) {
-		sense = pci_alloc_consistent(instance->pdev, ioc->sense_len,
-					     &sense_handle);
+		sense = dma_alloc_coherent(&instance->pdev->dev, ioc->sense_len,
+					     &sense_handle, GFP_KERNEL);
 		if (!sense) {
 			error = -ENOMEM;
 			goto out;
@@ -2827,12 +2827,12 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 
       out:
 	if (sense) {
-		pci_free_consistent(instance->pdev, ioc->sense_len,
+		dma_free_coherent(&instance->pdev->dev, ioc->sense_len,
 				    sense, sense_handle);
 	}
 
 	for (i = 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
-		pci_free_consistent(instance->pdev,
+		dma_free_coherent(&instance->pdev->dev,
 				    kern_sge32[i].length,
 				    kbuff_arr[i], kern_sge32[i].phys_addr);
 	}
_

Patches currently in -mm which might be from sumantp@lsil.com are

origin.patch
git-scsi-misc.patch
scsi-megaraid_sas-throttle-io-if-fw-is-busy.patch
scsi-megaraid_sas-return-sync-cache-call-with-success.patch
