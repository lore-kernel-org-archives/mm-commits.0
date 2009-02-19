From: akpm@linux-foundation.org
Subject: + replace-all-dma_39bit_mask-macro-with-dma_bit_mask39.patch added to -mm tree
Date: Thu, 19 Feb 2009 15:14:27 -0800
Message-ID: <200902192314.n1JNERMx029794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbZBSXPC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 18:15:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanghy@cn.fujitsu.com


The patch titled
     dma-mapping: replace all DMA_39BIT_MASK macro with DMA_BIT_MASK(39)
has been added to the -mm tree.  Its filename is
     replace-all-dma_39bit_mask-macro-with-dma_bit_mask39.patch

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
Subject: dma-mapping: replace all DMA_39BIT_MASK macro with DMA_BIT_MASK(39)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_39BIT_MASK macro with DMA_BIT_MASK(39)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c                |    4 ++--
 drivers/net/netxen/netxen_nic_main.c   |    8 ++++----
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/net/forcedeth.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39 drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39
+++ a/drivers/net/forcedeth.c
@@ -5614,12 +5614,12 @@ static int __devinit nv_probe(struct pci
 		np->desc_ver = DESC_VER_3;
 		np->txrxctl_bits = NVREG_TXRXCTL_DESC_3;
 		if (dma_64bit) {
-			if (pci_set_dma_mask(pci_dev, DMA_39BIT_MASK))
+			if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(39)))
 				dev_printk(KERN_INFO, &pci_dev->dev,
 					"64-bit DMA failed, using 32-bit addressing\n");
 			else
 				dev->features |= NETIF_F_HIGHDMA;
-			if (pci_set_consistent_dma_mask(pci_dev, DMA_39BIT_MASK)) {
+			if (pci_set_consistent_dma_mask(pci_dev, DMA_BIT_MASK(39))) {
 				dev_printk(KERN_INFO, &pci_dev->dev,
 					"64-bit DMA (consistent) failed, using 32-bit ring buffers\n");
 			}
diff -puN drivers/net/netxen/netxen_nic_main.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39 drivers/net/netxen/netxen_nic_main.c
--- a/drivers/net/netxen/netxen_nic_main.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39
+++ a/drivers/net/netxen/netxen_nic_main.c
@@ -177,11 +177,11 @@ static int nx_set_dma_mask(struct netxen
 #else
 	if (revision_id >= NX_P3_B0) {
 		/* should go to DMA_BIT_MASK(64) */
-		adapter->dma_mask = DMA_39BIT_MASK;
-		mask = DMA_39BIT_MASK;
+		adapter->dma_mask = DMA_BIT_MASK(39);
+		mask = DMA_BIT_MASK(39);
 	} else if (revision_id == NX_P3_A2) {
-		adapter->dma_mask = DMA_39BIT_MASK;
-		mask = DMA_39BIT_MASK;
+		adapter->dma_mask = DMA_BIT_MASK(39);
+		mask = DMA_BIT_MASK(39);
 	} else if (revision_id == NX_P2_C1) {
 		adapter->dma_mask = DMA_35BIT_MASK;
 		mask = DMA_35BIT_MASK;
diff -puN drivers/scsi/aic7xxx/aic79xx_osm_pci.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39 drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c~replace-all-dma_39bit_mask-macro-with-dma_bit_mask39
+++ a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -194,11 +194,11 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 	if (sizeof(dma_addr_t) > 4) {
 		const u64 required_mask = dma_get_required_mask(dev);
 
-		if (required_mask > DMA_39BIT_MASK &&
+		if (required_mask > DMA_BIT_MASK(39) &&
 		    dma_set_mask(dev, DMA_BIT_MASK(64)) == 0)
 			ahd->flags |= AHD_64BIT_ADDRESSING;
 		else if (required_mask > DMA_32BIT_MASK &&
-			 dma_set_mask(dev, DMA_39BIT_MASK) == 0)
+			 dma_set_mask(dev, DMA_BIT_MASK(39)) == 0)
 			ahd->flags |= AHD_39BIT_ADDRESSING;
 		else
 			dma_set_mask(dev, DMA_32BIT_MASK);
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

