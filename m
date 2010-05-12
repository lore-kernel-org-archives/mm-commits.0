From: akpm@linux-foundation.org
Subject: + dma-mapping-remove-deprecated-dma_sync_single-and-dma_sync_sg-api.patch added to -mm tree
Date: Wed, 12 May 2010 16:28:21 -0700
Message-ID: <201005122328.o4CNSLTP027376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758559Ab0ELX2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 19:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


The patch titled
     dma-mapping: remove deprecated dma_sync_single and dma_sync_sg API
has been added to the -mm tree.  Its filename is
     dma-mapping-remove-deprecated-dma_sync_single-and-dma_sync_sg-api.patch

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
Subject: dma-mapping: remove deprecated dma_sync_single and dma_sync_sg API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Since 2.6.5, it had been commented, 'for backwards compatibility,
removed in 2.7.x'. Since 2.6.31, it have been marked as __deprecated.

I think that we can remove the API safely now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN include/linux/dma-mapping.h~dma-mapping-remove-deprecated-dma_sync_single-and-dma_sync_sg-api include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-remove-deprecated-dma_sync_single-and-dma_sync_sg-api
+++ a/include/linux/dma-mapping.h
@@ -95,21 +95,6 @@ static inline int is_device_dma_capable(
 #include <asm-generic/dma-mapping-broken.h>
 #endif
 
-/* for backwards compatibility, removed soon */
-static inline void __deprecated dma_sync_single(struct device *dev,
-						dma_addr_t addr, size_t size,
-						enum dma_data_direction dir)
-{
-	dma_sync_single_for_cpu(dev, addr, size, dir);
-}
-
-static inline void __deprecated dma_sync_sg(struct device *dev,
-					    struct scatterlist *sg, int nelems,
-					    enum dma_data_direction dir)
-{
-	dma_sync_sg_for_cpu(dev, sg, nelems, dir);
-}
-
 static inline u64 dma_get_mask(struct device *dev)
 {
 	if (dev && dev->dma_mask && *dev->dma_mask)
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

