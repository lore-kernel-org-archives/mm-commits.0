From: akpm@linux-foundation.org
Subject: + documentation-dma-api-howto-add-arch_kmalloc_minalign-description.patch added to -mm tree
Date: Tue, 25 May 2010 14:34:40 -0700
Message-ID: <201005252134.o4PLYeN5016206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759093Ab0EYVeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 17:34:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, mpm@selenic.com


The patch titled
     Documentation/DMA-API-HOWTO: add ARCH_KMALLOC_MINALIGN description
has been added to the -mm tree.  Its filename is
     documentation-dma-api-howto-add-arch_kmalloc_minalign-description.patch

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
Subject: Documentation/DMA-API-HOWTO: add ARCH_KMALLOC_MINALIGN description
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Add ARCH_KMALLOC_MINALIGN description in "Platform Issues" section.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API-HOWTO.txt |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN Documentation/DMA-API-HOWTO.txt~documentation-dma-api-howto-add-arch_kmalloc_minalign-description Documentation/DMA-API-HOWTO.txt
--- a/Documentation/DMA-API-HOWTO.txt~documentation-dma-api-howto-add-arch_kmalloc_minalign-description
+++ a/Documentation/DMA-API-HOWTO.txt
@@ -738,7 +738,20 @@ to "Closing".
    CONFIG_NEED_SG_DMA_LENGTH if the architecture supports IOMMUs
    (including software IOMMU).
 
-2) More to come...
+2) ARCH_KMALLOC_MINALIGN
+
+   Architectures must ensure that kmalloc'ed buffer is
+   DMA-safe. Drivers and subsystems depend on it. If an architecture
+   isn't fully DMA-coherent (i.e. hardware doesn't ensure that data in
+   the CPU cache is identical to data in main memory),
+   ARCH_KMALLOC_MINALIGN must be set so that the memory allocator
+   makes sure that kmalloc'ed buffer doesn't share a cache line with
+   the others. See arch/arm/include/asm/cache.h as an example.
+
+   Note that ARCH_KMALLOC_MINALIGN is about DMA memory alignment
+   constraints. You don't need to worry about the architecture data
+   alignment constraints (e.g. the alignment constraints about 64-bit
+   objects).
 
 			   Closing
 
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
staging-saa7134-go7007-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
dma-mapping-remove-deprecated-dma_sync_single-and-dma_sync_sg-api.patch
documentation-add-scsi-drivers-mapping-error-handling-to-dma-api-howto.patch
documentation-update-scatterlist-struct-description-in-dma-api-howto.patch
documentation-move-the-error-handling-to-the-better-place-in-dma-api-howto.patch
documentation-dma-api-howto-add-arch_kmalloc_minalign-description.patch
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

