From: akpm@linux-foundation.org
Subject: + dma-cma-support-alignment-constraint-on-cma-region.patch added
 to -mm tree
Date: Wed, 18 Jun 2014 13:53:11 -0700
Message-ID: <53a1fc37.LQJfyTOjV2PVq+QW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaFRUxM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 16:53:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, pbonzini@redhat.com, paulus@samba.org, minchan@kernel.org, mina86@mina86.com, m.szyprowski@samsung.com, gleb@kernel.org, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, agraf@suse.de, iamjoonsoo.kim@lge.com


The patch titled
     Subject: DMA, CMA: support alignment constraint on CMA region
has been added to the -mm tree.  Its filename is
     dma-cma-support-alignment-constraint-on-cma-region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-cma-support-alignment-constraint-on-cma-region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-cma-support-alignment-constraint-on-cma-region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
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

slab-maintainer-update.patch
slab-fix-oops-when-reading-proc-slab_allocators.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
dma-cma-fix-possible-memory-leak.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

