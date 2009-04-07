From: akpm@linux-foundation.org
Subject: [merged] replace-all-dma_31bit_mask-macro-with-dma_bit_mask31.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:08:00 -0700
Message-ID: <200904071908.n37J80q6011595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753049AbZDGTJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanghy@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: replace all DMA_31BIT_MASK macro with DMA_BIT_MASK(31)
has been removed from the -mm tree.  Its filename was
     replace-all-dma_31bit_mask-macro-with-dma_bit_mask31.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: replace all DMA_31BIT_MASK macro with DMA_BIT_MASK(31)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_31BIT_MASK macro with DMA_BIT_MASK(31)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/commsup.c |    4 ++--
 drivers/scsi/aacraid/linit.c   |    4 ++--
 drivers/usb/host/ehci-pci.c    |    2 +-
 sound/pci/ali5451/ali5451.c    |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/aacraid/commsup.c~replace-all-dma_31bit_mask-macro-with-dma_bit_mask31 drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c~replace-all-dma_31bit_mask-macro-with-dma_bit_mask31
+++ a/drivers/scsi/aacraid/commsup.c
@@ -1206,8 +1206,8 @@ static int _aac_reset_adapter(struct aac
 	aac->fsa_dev = NULL;
 	quirks = aac_get_driver_ident(index)->quirks;
 	if (quirks & AAC_QUIRK_31BIT) {
-		if (((retval = pci_set_dma_mask(aac->pdev, DMA_31BIT_MASK))) ||
-		  ((retval = pci_set_consistent_dma_mask(aac->pdev, DMA_31BIT_MASK))))
+		if (((retval = pci_set_dma_mask(aac->pdev, DMA_BIT_MASK(31)))) ||
+		  ((retval = pci_set_consistent_dma_mask(aac->pdev, DMA_BIT_MASK(31)))))
 			goto out;
 	} else {
 		if (((retval = pci_set_dma_mask(aac->pdev, DMA_BIT_MASK(32)))) ||
diff -puN drivers/scsi/aacraid/linit.c~replace-all-dma_31bit_mask-macro-with-dma_bit_mask31 drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~replace-all-dma_31bit_mask-macro-with-dma_bit_mask31
+++ a/drivers/scsi/aacraid/linit.c
@@ -1103,8 +1103,8 @@ static int __devinit aac_probe_one(struc
 	 * to driver communication memory to be allocated below 2gig
 	 */
 	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
-		if (pci_set_dma_mask(pdev, DMA_31BIT_MASK) ||
-				pci_set_consistent_dma_mask(pdev, DMA_31BIT_MASK))
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(31)) ||
+				pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(31)))
 			goto out_disable_pdev;
 
 	pci_set_master(pdev);
diff -puN drivers/usb/host/ehci-pci.c~replace-all-dma_31bit_mask-macro-with-dma_bit_mask31 drivers/usb/host/ehci-pci.c
--- a/drivers/usb/host/ehci-pci.c~replace-all-dma_31bit_mask-macro-with-dma_bit_mask31
+++ a/drivers/usb/host/ehci-pci.c
@@ -108,7 +108,7 @@ static int ehci_pci_setup(struct usb_hcd
 		case 0x00d8:	/* CK8 */
 		case 0x00e8:	/* CK8S */
 			if (pci_set_consistent_dma_mask(pdev,
-						DMA_31BIT_MASK) < 0)
+						DMA_BIT_MASK(31)) < 0)
 				ehci_warn(ehci, "can't enable NVidia "
 					"workaround for >2GB RAM\n");
 			break;
diff -puN sound/pci/ali5451/ali5451.c~replace-all-dma_31bit_mask-macro-with-dma_bit_mask31 sound/pci/ali5451/ali5451.c
--- a/sound/pci/ali5451/ali5451.c~replace-all-dma_31bit_mask-macro-with-dma_bit_mask31
+++ a/sound/pci/ali5451/ali5451.c
@@ -2186,8 +2186,8 @@ static int __devinit snd_ali_create(stru
 	if (err < 0)
 		return err;
 	/* check, if we can restrict PCI DMA transfers to 31 bits */
-	if (pci_set_dma_mask(pci, DMA_31BIT_MASK) < 0 ||
-	    pci_set_consistent_dma_mask(pci, DMA_31BIT_MASK) < 0) {
+	if (pci_set_dma_mask(pci, DMA_BIT_MASK(31)) < 0 ||
+	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(31)) < 0) {
 		snd_printk(KERN_ERR "architecture does not support "
 			   "31bit PCI busmaster DMA\n");
 		pci_disable_device(pci);
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

origin.patch

