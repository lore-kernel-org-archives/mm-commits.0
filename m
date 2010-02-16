From: akpm@linux-foundation.org
Subject: + b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch added to -mm tree
Date: Tue, 16 Feb 2010 13:40:35 -0800
Message-ID: <201002162140.o1GLeZh3006607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933311Ab0BPVlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 16:41:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Larry.Finger@lwfinger.net, linville@tuxdriver.com, stefano.brivio@polimi.it


The patch titled
     b43legacy: replace the ssb_dma API with the generic DMA API
has been added to the -mm tree.  Its filename is
     b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch

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
Subject: b43legacy: replace the ssb_dma API with the generic DMA API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43legacy/dma.c |   49 +++++++++++++------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff -puN drivers/net/wireless/b43legacy/dma.c~b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api drivers/net/wireless/b43legacy/dma.c
--- a/drivers/net/wireless/b43legacy/dma.c~b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api
+++ a/drivers/net/wireless/b43legacy/dma.c
@@ -393,11 +393,11 @@ dma_addr_t map_descbuffer(struct b43lega
 	dma_addr_t dmaaddr;
 
 	if (tx)
-		dmaaddr = ssb_dma_map_single(ring->dev->dev,
+		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
 					     buf, len,
 					     DMA_TO_DEVICE);
 	else
-		dmaaddr = ssb_dma_map_single(ring->dev->dev,
+		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
 					     buf, len,
 					     DMA_FROM_DEVICE);
 
@@ -411,11 +411,11 @@ void unmap_descbuffer(struct b43legacy_d
 		      int tx)
 {
 	if (tx)
-		ssb_dma_unmap_single(ring->dev->dev,
+		dma_unmap_single(ring->dev->dev->dma_dev,
 				     addr, len,
 				     DMA_TO_DEVICE);
 	else
-		ssb_dma_unmap_single(ring->dev->dev,
+		dma_unmap_single(ring->dev->dev->dma_dev,
 				     addr, len,
 				     DMA_FROM_DEVICE);
 }
@@ -427,8 +427,8 @@ void sync_descbuffer_for_cpu(struct b43l
 {
 	B43legacy_WARN_ON(ring->tx);
 
-	ssb_dma_sync_single_for_cpu(ring->dev->dev,
-				    addr, len, DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(ring->dev->dev->dma_dev,
+				addr, len, DMA_FROM_DEVICE);
 }
 
 static inline
@@ -438,8 +438,8 @@ void sync_descbuffer_for_device(struct b
 {
 	B43legacy_WARN_ON(ring->tx);
 
-	ssb_dma_sync_single_for_device(ring->dev->dev,
-				       addr, len, DMA_FROM_DEVICE);
+	dma_sync_single_for_device(ring->dev->dev->dma_dev,
+				   addr, len, DMA_FROM_DEVICE);
 }
 
 static inline
@@ -459,10 +459,10 @@ void free_descriptor_buffer(struct b43le
 static int alloc_ringmemory(struct b43legacy_dmaring *ring)
 {
 	/* GFP flags must match the flags in free_ringmemory()! */
-	ring->descbase = ssb_dma_alloc_consistent(ring->dev->dev,
-						  B43legacy_DMA_RINGMEMSIZE,
-						  &(ring->dmabase),
-						  GFP_KERNEL);
+	ring->descbase = dma_alloc_coherent(ring->dev->dev->dma_dev,
+					    B43legacy_DMA_RINGMEMSIZE,
+					    &(ring->dmabase),
+					    GFP_KERNEL);
 	if (!ring->descbase) {
 		b43legacyerr(ring->dev->wl, "DMA ringmemory allocation"
 			     " failed\n");
@@ -475,8 +475,8 @@ static int alloc_ringmemory(struct b43le
 
 static void free_ringmemory(struct b43legacy_dmaring *ring)
 {
-	ssb_dma_free_consistent(ring->dev->dev, B43legacy_DMA_RINGMEMSIZE,
-				ring->descbase, ring->dmabase, GFP_KERNEL);
+	dma_free_coherent(ring->dev->dev->dma_dev, B43legacy_DMA_RINGMEMSIZE,
+			  ring->descbase, ring->dmabase);
 }
 
 /* Reset the RX DMA channel */
@@ -588,7 +588,7 @@ static bool b43legacy_dma_mapping_error(
 					 size_t buffersize,
 					 bool dma_to_device)
 {
-	if (unlikely(ssb_dma_mapping_error(ring->dev->dev, addr)))
+	if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
 		return 1;
 
 	switch (ring->type) {
@@ -905,7 +905,7 @@ struct b43legacy_dmaring *b43legacy_setu
 			goto err_kfree_meta;
 
 		/* test for ability to dma to txhdr_cache */
-		dma_test = ssb_dma_map_single(dev->dev, ring->txhdr_cache,
+		dma_test = dma_map_single(dev->dev->dma_dev, ring->txhdr_cache,
 					      sizeof(struct b43legacy_txhdr_fw3),
 					      DMA_TO_DEVICE);
 
@@ -919,7 +919,7 @@ struct b43legacy_dmaring *b43legacy_setu
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
-			dma_test = ssb_dma_map_single(dev->dev,
+			dma_test = dma_map_single(dev->dev->dma_dev,
 					ring->txhdr_cache,
 					sizeof(struct b43legacy_txhdr_fw3),
 					DMA_TO_DEVICE);
@@ -929,9 +929,9 @@ struct b43legacy_dmaring *b43legacy_setu
 				goto err_kfree_txhdr_cache;
 		}
 
-		ssb_dma_unmap_single(dev->dev, dma_test,
-				     sizeof(struct b43legacy_txhdr_fw3),
-				     DMA_TO_DEVICE);
+		dma_unmap_single(dev->dev->dma_dev, dma_test,
+				 sizeof(struct b43legacy_txhdr_fw3),
+				 DMA_TO_DEVICE);
 	}
 
 	ring->nr_slots = nr_slots;
@@ -1039,9 +1039,12 @@ static int b43legacy_dma_set_mask(struct
 	/* Try to set the DMA mask. If it fails, try falling back to a
 	 * lower mask, as we can always also support a lower one. */
 	while (1) {
-		err = ssb_dma_set_mask(dev->dev, mask);
-		if (!err)
-			break;
+		err = dma_set_mask(dev->dev->dma_dev, mask);
+		if (!err) {
+			err = dma_set_coherent_mask(dev->dev->dma_dev, mask);
+			if (!err)
+				break;
+		}
 		if (mask == DMA_BIT_MASK(64)) {
 			mask = DMA_BIT_MASK(32);
 			fallback = 1;
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch
documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
pci-dma-alpha-use-include-linux-pci-dmah.patch
pci-dma-arm-use-include-linux-pci-dmah.patch
pci-dma-frv-use-include-linux-pci-dmah.patch
pci-dma-ia64-use-include-linux-pci-dmah.patch
pci-dma-mips-use-include-linux-pci-dmah.patch
pci-dma-parisc-use-include-linux-pci-dmah.patch
pci-dma-powerpc-use-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
pci-dma-xtensa-use-include-linux-pci-dmah.patch
pci-dma-cris-use-include-linux-pci-dmah.patch
pci-dma-add-linux-pci-dmah-to-linux-pcih.patch
dma-mappingh-add-the-dma_unmap-state-api.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

