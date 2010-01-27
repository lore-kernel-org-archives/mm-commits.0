From: akpm@linux-foundation.org
Subject: + documentation-dma-apitxt-remove-deprecated-function-descriptions.patch added to -mm tree
Date: Wed, 27 Jan 2010 15:32:09 -0800
Message-ID: <201001272332.o0RNW9cA006832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756531Ab0A0XcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:32:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, davem@davemloft.net, joro@8bytes.org


The patch titled
     Documentation/DMA-API.txt: remove deprecated function descriptions
has been added to the -mm tree.  Its filename is
     documentation-dma-apitxt-remove-deprecated-function-descriptions.patch

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
Subject: Documentation/DMA-API.txt: remove deprecated function descriptions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_sync_single(), pci_dma_sync_single(), dma_sync_sg(), and
pci_dma_sync_sg() are deprecated.  We should not advertise them.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Joerg Roedel <joro@8bytes.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff -puN Documentation/DMA-API.txt~documentation-dma-apitxt-remove-deprecated-function-descriptions Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~documentation-dma-apitxt-remove-deprecated-function-descriptions
+++ a/Documentation/DMA-API.txt
@@ -364,34 +364,6 @@ API.
 Note: <nents> must be the number you passed in, *not* the number of
 physical entries returned.
 
-void
-dma_sync_single(struct device *dev, dma_addr_t dma_handle, size_t size,
-		enum dma_data_direction direction)
-void
-pci_dma_sync_single(struct pci_dev *hwdev, dma_addr_t dma_handle,
-			   size_t size, int direction)
-void
-dma_sync_sg(struct device *dev, struct scatterlist *sg, int nelems,
-			  enum dma_data_direction direction)
-void
-pci_dma_sync_sg(struct pci_dev *hwdev, struct scatterlist *sg,
-		       int nelems, int direction)
-
-Synchronise a single contiguous or scatter/gather mapping.  All the
-parameters must be the same as those passed into the single mapping
-API.
-
-Notes:  You must do this:
-
-- Before reading values that have been written by DMA from the device
-  (use the DMA_FROM_DEVICE direction)
-- After writing values that will be written to the device using DMA
-  (use the DMA_TO_DEVICE) direction
-- before *and* after handing memory to the device if the memory is
-  DMA_BIDIRECTIONAL
-
-See also dma_map_single().
