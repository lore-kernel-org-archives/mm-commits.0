From: akpm@linux-foundation.org
Subject: [merged] dma-cma-support-alignment-constraint-on-cma-region.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:59 -0700
Message-ID: <53e3dbaf.yB98ca9sqBCOmCFU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:59506 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaHGUEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:00 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so609488yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, agraf@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, gleb@kernel.org, m.szyprowski@samsung.com, mina86@mina86.com, minchan@kernel.org, paulus@samba.org, pbonzini@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: DMA, CMA: support alignment constraint on CMA region
has been removed from the -mm tree.  Its filename was
     dma-cma-support-alignment-constraint-on-cma-region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: DMA, CMA: support alignment constraint on CMA region

PPC KVM's CMA area management needs alignment constraint on CMA region. 
So support it to prepare generalization of CMA area management
functionality.

Additionally, add some comments which tell us why alignment
constraint is needed on CMA region.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff -puN drivers/base/dma-contiguous.c~dma-cma-support-alignment-constraint-on-cma-region drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~dma-cma-support-alignment-constraint-on-cma-region
+++ a/drivers/base/dma-contiguous.c
@@ -32,6 +32,7 @@
 #include <linux/swap.h>
 #include <linux/mm_types.h>
 #include <linux/dma-contiguous.h>
+#include <linux/log2.h>
 
 struct cma {
 	unsigned long	base_pfn;
@@ -215,17 +216,16 @@ core_initcall(cma_init_reserved_areas);
 
 static int __init __dma_contiguous_reserve_area(phys_addr_t size,
 				phys_addr_t base, phys_addr_t limit,
+				phys_addr_t alignment,
 				struct cma **res_cma, bool fixed)
 {
 	struct cma *cma = &cma_areas[cma_area_count];
-	phys_addr_t alignment;
 	int ret = 0;
 
-	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
-		 (unsigned long)size, (unsigned long)base,
-		 (unsigned long)limit);
+	pr_debug("%s(size %lx, base %08lx, limit %08lx alignment %08lx)\n",
+		__func__, (unsigned long)size, (unsigned long)base,
+		(unsigned long)limit, (unsigned long)alignment);
 
-	/* Sanity checks */
 	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
 		pr_err("Not enough slots for CMA reserved regions!\n");
 		return -ENOSPC;
@@ -234,8 +234,17 @@ static int __init __dma_contiguous_reser
 	if (!size)
 		return -EINVAL;
 
-	/* Sanitise input arguments */
-	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
+	if (alignment && !is_power_of_2(alignment))
+		return -EINVAL;
+
+	/*
+	 * Sanitise input arguments.
+	 * Pages both ends in CMA area could be merged into adjacent unmovable
+	 * migratetype page by page allocator's buddy algorithm. In the case,
+	 * you couldn't get a contiguous memory, which is not what we want.
+	 */
+	alignment = max(alignment,
+		(phys_addr_t)PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order));
 	base = ALIGN(base, alignment);
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
@@ -299,7 +308,8 @@ int __init dma_contiguous_reserve_area(p
 {
 	int ret;
 
-	ret = __dma_contiguous_reserve_area(size, base, limit, res_cma, fixed);
+	ret = __dma_contiguous_reserve_area(size, base, limit, 0,
+						res_cma, fixed);
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

