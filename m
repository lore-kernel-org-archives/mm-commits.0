From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-fix-dma_sync_single_range_.patch removed from -mm tree
Date: Wed, 12 May 2010 10:57:57 -0400
Message-ID: <201005121759.o4CHxQDD011509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048Ab0ELSAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, konrad.wilk@oracle.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: fix dma_sync_single_range_*
has been removed from the -mm tree.  Its filename was
     dma-mapping-fix-dma_sync_single_range_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: fix dma_sync_single_range_*
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_sync_single_range_for_cpu() and dma_sync_single_range_for_device() use
a wrong address with a partial synchronization.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/dma-mapping-common.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/dma-mapping-common.h~dma-mapping-fix-dma_sync_single_range_ include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~dma-mapping-fix-dma_sync_single_range_
+++ a/include/asm-generic/dma-mapping-common.h
@@ -131,7 +131,7 @@ static inline void dma_sync_single_range
 		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 
 	} else
-		dma_sync_single_for_cpu(dev, addr, size, dir);
+		dma_sync_single_for_cpu(dev, addr + offset, size, dir);
 }
 
 static inline void dma_sync_single_range_for_device(struct device *dev,
@@ -148,7 +148,7 @@ static inline void dma_sync_single_range
 		debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
 
 	} else
-		dma_sync_single_for_device(dev, addr, size, dir);
+		dma_sync_single_for_device(dev, addr + offset, size, dir);
 }
 
 static inline void
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

