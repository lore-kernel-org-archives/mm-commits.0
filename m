From: akpm@linux-foundation.org
Subject: + frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch added to -mm tree
Date: Wed, 27 Jan 2010 15:30:22 -0800
Message-ID: <201001272330.o0RNUMuZ006675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756456Ab0A0Xar (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:30:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, dhowells@redhat.com


The patch titled
     frv: remove pci_dma_sync_single() and pci_dma_sync_sg()
has been added to the -mm tree.  Its filename is
     frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch

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
Subject: frv: remove pci_dma_sync_single() and pci_dma_sync_sg()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

No architecture except for frv has pci_dma_sync_single() and
pci_dma_sync_sg().  The APIs are deprecated.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/pci.h |   37 -----------------------------------
 1 file changed, 37 deletions(-)

diff -puN arch/frv/include/asm/pci.h~frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg arch/frv/include/asm/pci.h
--- a/arch/frv/include/asm/pci.h~frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg
+++ a/arch/frv/include/asm/pci.h
@@ -68,41 +68,4 @@ static inline void pci_dma_burst_advice(
 #define PCIBIOS_MIN_IO		0x100
 #define PCIBIOS_MIN_MEM		0x00010000
 
-/* Make physical memory consistent for a single
- * streaming mode DMA translation after a transfer.
- *
- * If you perform a pci_map_single() but wish to interrogate the
- * buffer using the cpu, yet do not wish to teardown the PCI dma
- * mapping, you must call this function before doing so.  At the
- * next point you give the PCI dma address back to the card, the
- * device again owns the buffer.
- */
-static inline void pci_dma_sync_single(struct pci_dev *hwdev,
-				       dma_addr_t dma_handle,
-				       size_t size, int direction)
-{
-	BUG_ON(direction == PCI_DMA_NONE);
-
-	frv_cache_wback_inv((unsigned long)bus_to_virt(dma_handle),
-			    (unsigned long)bus_to_virt(dma_handle) + size);
-}
-
-/* Make physical memory consistent for a set of streaming
- * mode DMA translations after a transfer.
- *
- * The same as pci_dma_sync_single but for a scatter-gather list,
- * same rules and usage.
- */
-static inline void pci_dma_sync_sg(struct pci_dev *hwdev,
-				   struct scatterlist *sg,
-				   int nelems, int direction)
-{
-	int i;
-	BUG_ON(direction == PCI_DMA_NONE);
-
-	for (i = 0; i < nelems; i++)
-		frv_cache_wback_inv(sg_dma_address(&sg[i]),
-				    sg_dma_address(&sg[i])+sg_dma_len(&sg[i]));
-}
