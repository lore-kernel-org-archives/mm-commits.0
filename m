From: akpm@linux-foundation.org
Subject: [merged] frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:00 -0800
Message-ID: <201003091905.o29J50sn031086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755809Ab0CITFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: remove pci_dma_sync_single() and pci_dma_sync_sg()
has been removed from the -mm tree.  Its filename was
     frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: remove pci_dma_sync_single() and pci_dma_sync_sg()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

No architecture except for frv has pci_dma_sync_single() and
pci_dma_sync_sg().  The APIs are deprecated.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: David Howells <dhowells@redhat.com>
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
-
 #endif /* _ASM_FRV_PCI_H */
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
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
dma-mappingh-add-the-dma_unmap-state-api-fix.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath-fix.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

