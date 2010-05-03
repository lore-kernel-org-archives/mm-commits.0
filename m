From: akpm@linux-foundation.org
Subject: [merged] arm-use-asm-generic-scatterlisth.patch removed from -mm tree
Date: Mon, 03 May 2010 13:09:57 -0400
Message-ID: <201005032011.o43KBSjK019212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756721Ab0ECULg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 May 2010 16:11:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: use asm-generic/scatterlist.h
has been removed from the -mm tree.  Its filename was
     arm-use-asm-generic-scatterlisth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/scatterlist.h |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff -puN arch/arm/include/asm/scatterlist.h~arm-use-asm-generic-scatterlisth arch/arm/include/asm/scatterlist.h
--- a/arch/arm/include/asm/scatterlist.h~arm-use-asm-generic-scatterlisth
+++ a/arch/arm/include/asm/scatterlist.h
@@ -4,24 +4,8 @@
 #include <asm/memory.h>
 #include <asm/types.h>
 
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;		/* buffer offset		 */
-	dma_addr_t	dma_address;	/* dma address			 */
-	unsigned int	length;		/* length			 */
-};
+#include <asm-generic/scatterlist.h>
 
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)      ((sg)->dma_address)
-#define sg_dma_len(sg)          ((sg)->length)
+#undef ARCH_HAS_SG_CHAIN
 
 #endif /* _ASMARM_SCATTERLIST_H */
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

dma-mapping-fix-dma_sync_single_range_.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ia64-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
x86-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
swiotlb-remove-unnecessary-swiotlb_sync_single_range_.patch
dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops.patch
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

