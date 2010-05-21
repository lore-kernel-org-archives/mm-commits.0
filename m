From: akpm@linux-foundation.org
Subject: + xtensa-set-arch_kmalloc_minalign.patch added to -mm tree
Date: Fri, 21 May 2010 12:57:55 -0700
Message-ID: <201005211957.o4LJvtYi031133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab0EUT6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 15:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, chris@zankel.net, penberg@cs.helsinki.fi, stable@kernel.org


The patch titled
     xtensa: set ARCH_KMALLOC_MINALIGN
has been added to the -mm tree.  Its filename is
     xtensa-set-arch_kmalloc_minalign.patch

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
Subject: xtensa: set ARCH_KMALLOC_MINALIGN
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Architectures that handle DMA-non-coherent memory need to set
ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe: the
buffer doesn't share a cache with the others.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Chris Zankel <chris@zankel.net>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/cache.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/xtensa/include/asm/cache.h~xtensa-set-arch_kmalloc_minalign arch/xtensa/include/asm/cache.h
--- a/arch/xtensa/include/asm/cache.h~xtensa-set-arch_kmalloc_minalign
+++ a/arch/xtensa/include/asm/cache.h
@@ -29,5 +29,6 @@
 # define CACHE_WAY_SIZE ICACHE_WAY_SIZE
 #endif
 
+#define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
 
 #endif	/* _XTENSA_CACHE_H */
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
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
frv-set-arch_kmalloc_minalign.patch
m68k-set-arch_kmalloc_minalign.patch
mn10300-set-arch_kmalloc_minalign.patch
xtensa-set-arch_kmalloc_minalign.patch

