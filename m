From: akpm@linux-foundation.org
Subject: + replace-all-dma_31bit_mask-macro-with-dma_bit_mask31.patch added to -mm tree
Date: Thu, 19 Feb 2009 15:14:38 -0800
Message-ID: <200902192314.n1JNEcZK029809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258AbZBSXPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 18:15:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanghy@cn.fujitsu.com


The patch titled
     dma-mapping: replace all DMA_31BIT_MASK macro with DMA_BIT_MASK(31)
has been added to the -mm tree.  Its filename is
     replace-all-dma_31bit_mask-macro-with-dma_bit_mask31.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1097,8 +1097,8 @@ static int __devinit aac_probe_one(struc
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

replace-all-dma_64bit_mask-macro-with-dma_bit_mask64.patch
replace-all-dma_48bit_mask-macro-with-dma_bit_mask48.patch
replace-all-dma_40bit_mask-macro-with-dma_bit_mask40.patch
replace-all-dma_39bit_mask-macro-with-dma_bit_mask39.patch
replace-all-dma_35bit_mask-macro-with-dma_bit_mask35.patch
replace-all-dma_32bit_mask-macro-with-dma_bit_mask32.patch
replace-all-dma_31bit_mask-macro-with-dma_bit_mask31.patch
replace-all-dma_30bit_mask-macro-with-dma_bit_mask30.patch
replace-all-dma_28bit_mask-macro-with-dma_bit_mask28.patch
replace-all-dma_24bit_mask-macro-with-dma_bit_mask24.patch
update-the-old-macro-dma_nbit_mask-related-documentations.patch
update-related-documentations.patch

