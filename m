From: akpm@linux-foundation.org
Subject: + documentation-move-the-error-handling-to-the-better-place-in-dma-api-howto.patch added to -mm tree
Date: Wed, 12 May 2010 16:23:36 -0700
Message-ID: <201005122323.o4CNNawW027164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756166Ab0ELXYK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 19:24:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


The patch titled
     Documentation: move the error handling to the better place in DMA-API-HOWTO
has been added to the -mm tree.  Its filename is
     documentation-move-the-error-handling-to-the-better-place-in-dma-api-howto.patch

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
Subject: Documentation: move the error handling to the better place in DMA-API-HOWTO
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Handing DMA mapping errors is essential.  Let's put it in the more
appropriate place rather than the end of the doc.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API-HOWTO.txt |   60 +++++++++++++++---------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff -puN Documentation/DMA-API-HOWTO.txt~documentation-move-the-error-handling-to-the-better-place-in-dma-api-howto Documentation/DMA-API-HOWTO.txt
--- a/Documentation/DMA-API-HOWTO.txt~documentation-move-the-error-handling-to-the-better-place-in-dma-api-howto
+++ a/Documentation/DMA-API-HOWTO.txt
@@ -639,6 +639,36 @@ is planned to completely remove virt_to_
 they are entirely deprecated.  Some ports already do not provide these
 as it is impossible to correctly support them.
 
+			Handling Errors
+
+DMA address space is limited on some architectures and an allocation
+failure can be determined by:
+
+- checking if dma_alloc_coherent returns NULL or dma_map_sg returns 0
+
+- checking the returned dma_addr_t of dma_map_single and dma_map_page
+  by using dma_mapping_error():
+
+	dma_addr_t dma_handle;
+
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dev, dma_handle)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+	}
+
+Networking drivers must call dev_kfree_skb to free the socket buffer
+and return NETDEV_TX_OK if the DMA mapping fails on the transmit hook
+(ndo_start_xmit). This means that the socket buffer is just dropped in
+the failure case.
+
+SCSI drivers must return SCSI_MLQUEUE_HOST_BUSY if the DMA mapping
+fails in the queuecommand hook. This means that the SCSI subsystem
+passes the command to the driver again later.
+
 		Optimizing Unmap State Space Consumption
 
 On many platforms, dma_unmap_{single,page}() is simply a nop.
@@ -710,36 +740,6 @@ to "Closing".
 
 2) More to come...
 
-			Handling Errors
-
-DMA address space is limited on some architectures and an allocation
-failure can be determined by:
-
-- checking if dma_alloc_coherent returns NULL or dma_map_sg returns 0
-
-- checking the returned dma_addr_t of dma_map_single and dma_map_page
-  by using dma_mapping_error():
-
-	dma_addr_t dma_handle;
-
-	dma_handle = dma_map_single(dev, addr, size, direction);
-	if (dma_mapping_error(dev, dma_handle)) {
-		/*
-		 * reduce current DMA mapping usage,
-		 * delay and try again later or
-		 * reset driver.
-		 */
-	}
-
-Networking drivers must call dev_kfree_skb to free the socket buffer
-and return NETDEV_TX_OK if the DMA mapping fails on the transmit hook
-(ndo_start_xmit). This means that the socket buffer is just dropped in
-the failure case.
-
-SCSI drivers must return SCSI_MLQUEUE_HOST_BUSY if the DMA mapping
-fails in the queuecommand hook. This means that the SCSI subsystem
-passes the command to the driver again later.
-
 			   Closing
 
 This document, and the API itself, would not be in its current
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ia64-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
x86-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
swiotlb-remove-unnecessary-swiotlb_sync_single_range_.patch
dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops.patch
documentation-add-networking-drivers-mapping-error-handling-to-dma-api-howto.patch
documentation-add-scsi-drivers-mapping-error-handling-to-dma-api-howto.patch
documentation-update-scatterlist-struct-description-in-dma-api-howto.patch
documentation-move-the-error-handling-to-the-better-place-in-dma-api-howto.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch
asm-generic-remove-isa_dma_threshold-in-scatterlisth.patch
asm-generic-add-need_sg_dma_length-to-define-sg_dma_len.patch
x86_32-use-asm-generic-scatterlisth.patch
powerpc-use-asm-generic-scatterlisth.patch
alpha-use-asm-generic-scatterlisth.patch
asm-generic-remove-arch_has_sg_chain-in-scatterlisth.patch
avr32-use-asm-generic-scatterlisth.patch
cris-use-asm-generic-scatterlisth.patch
h8300-use-asm-generic-scatterlisth.patch
m32r-use-use-asm-generic-scatterlisth.patch
m68k-use-asm-generic-scatterlisth.patch
mips-use-use-asm-generic-scatterlisth.patch
xtensa-use-use-asm-generic-scatterlisth.patch
blackfin-use-use-asm-generic-scatterlisth.patch
frv-use-asm-generic-scatterlisth.patch
mn10300-use-asm-generic-scatterlisth.patch
parisc-use-asm-generic-scatterlisth.patch

