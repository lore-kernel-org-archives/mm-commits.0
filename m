From: akpm@linux-foundation.org
Subject: [merged]
 arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:19:17 -0700
Message-ID: <543c17a5.Q1FTrdHw8EKZ00C1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60263 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSTR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, drake@endlessm.com, iamjoonsoo.kim@lge.com, linux@arm.linux.org.uk, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mm: don't limit default CMA region only to low memory
has been removed from the -mm tree.  Its filename was
     arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: ARM: mm: don't limit default CMA region only to low memory

DMA-mapping supports CMA regions places either in low or high memory, so
there is no longer needed to limit default CMA regions only to low memory.
 The real limit is still defined by architecture specific DMA limit.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Daniel Drake <drake@endlessm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mm/init.c~arm-mm-dont-limit-default-cma-region-only-to-low-memory arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~arm-mm-dont-limit-default-cma-region-only-to-low-memory
+++ a/arch/arm/mm/init.c
@@ -322,7 +322,7 @@ void __init arm_memblock_init(const stru
 	 * reserve memory for DMA contigouos allocations,
 	 * must come from DMA area inside low memory
 	 */
-	dma_contiguous_reserve(min(arm_dma_limit, arm_lowmem_limit));
+	dma_contiguous_reserve(arm_dma_limit);
 
 	arm_memblock_steal_permitted = false;
 	memblock_dump_all();
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
linux-next.patch

