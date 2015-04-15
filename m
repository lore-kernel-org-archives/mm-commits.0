From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mempool-poison-elements-backed-by-page-allocator.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 15:37:35 -0700
Message-ID: <552ee82f.3MQAvht53KxBnHZr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbbDOWhg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:37:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, catalin.marinas@arm.com, hch@lst.de, mpatocka@redhat.com, sebott@linux.vnet.ibm.com, shaggy@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempool: poison elements backed by page allocator
has been removed from the -mm tree.  Its filename was
     mm-mempool-poison-elements-backed-by-page-allocator.patch

This patch was dropped because it was folded into mm-mempool-poison-elements-backed-by-slab-allocator.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempool: poison elements backed by page allocator

Elements backed by the slab allocator are poisoned when added to a
mempool's reserved pool.

It is also possible to poison elements backed by the page allocator
because the mempool layer knows the allocation order.

This patch extends mempool element poisoning to include memory backed by
the page allocator.

This is only effective for configs with CONFIG_DEBUG_SLAB or
CONFIG_SLUB_DEBUG_ON.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   74 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 25 deletions(-)

diff -puN mm/mempool.c~mm-mempool-poison-elements-backed-by-page-allocator mm/mempool.c
--- a/mm/mempool.c~mm-mempool-poison-elements-backed-by-page-allocator
+++ a/mm/mempool.c
@@ -6,6 +6,7 @@
  *  extreme VM load.
  *
  *  started by Ingo Molnar, Copyright (C) 2001
+ *  debugging by David Rientjes, Copyright (C) 2015
  */
 
 #include <linux/mm.h>
@@ -35,41 +36,64 @@ static void poison_error(mempool_t *pool
 	dump_stack();
 }
 
-static void check_slab_element(mempool_t *pool, void *element)
+static void __check_element(mempool_t *pool, void *element, size_t size)
 {
-	if (pool->free == mempool_free_slab || pool->free == mempool_kfree) {
-		size_t size = ksize(element);
-		u8 *obj = element;
-		size_t i;
-
-		for (i = 0; i < size; i++) {
-			u8 exp = (i < size - 1) ? POISON_FREE : POISON_END;
-
-			if (obj[i] != exp) {
-				poison_error(pool, element, size, i);
-				return;
-			}
+	u8 *obj = element;
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		u8 exp = (i < size - 1) ? POISON_FREE : POISON_END;
+
+		if (obj[i] != exp) {
+			poison_error(pool, element, size, i);
+			return;
 		}
-		memset(obj, POISON_INUSE, size);
 	}
+	memset(obj, POISON_INUSE, size);
 }
 
-static void poison_slab_element(mempool_t *pool, void *element)
+static void check_element(mempool_t *pool, void *element)
 {
-	if (pool->alloc == mempool_alloc_slab ||
-	    pool->alloc == mempool_kmalloc) {
-		size_t size = ksize(element);
-		u8 *obj = element;
+	/* Mempools backed by slab allocator */
+	if (pool->free == mempool_free_slab || pool->free == mempool_kfree)
+		__check_element(pool, element, ksize(element));
+
+	/* Mempools backed by page allocator */
+	if (pool->free == mempool_free_pages) {
+		int order = (int)(long)pool->pool_data;
+		void *addr = page_address(element);
+
+		__check_element(pool, addr, 1UL << (PAGE_SHIFT + order));
+	}
+}
+
+static void __poison_element(void *element, size_t size)
+{
+	u8 *obj = element;
+
+	memset(obj, POISON_FREE, size - 1);
+	obj[size - 1] = POISON_END;
+}
+
+static void poison_element(mempool_t *pool, void *element)
+{
+	/* Mempools backed by slab allocator */
+	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
+		__poison_element(element, ksize(element));
+
+	/* Mempools backed by page allocator */
+	if (pool->alloc == mempool_alloc_pages) {
+		int order = (int)(long)pool->pool_data;
+		void *addr = page_address(element);
 
-		memset(obj, POISON_FREE, size - 1);
-		obj[size - 1] = POISON_END;
+		__poison_element(addr, 1UL << (PAGE_SHIFT + order));
 	}
 }
 #else /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
-static inline void check_slab_element(mempool_t *pool, void *element)
+static inline void check_element(mempool_t *pool, void *element)
 {
 }
-static inline void poison_slab_element(mempool_t *pool, void *element)
+static inline void poison_element(mempool_t *pool, void *element)
 {
 }
 #endif /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
@@ -77,7 +101,7 @@ static inline void poison_slab_element(m
 static void add_element(mempool_t *pool, void *element)
 {
 	BUG_ON(pool->curr_nr >= pool->min_nr);
-	poison_slab_element(pool, element);
+	poison_element(pool, element);
 	pool->elements[pool->curr_nr++] = element;
 }
 
@@ -86,7 +110,7 @@ static void *remove_element(mempool_t *p
 	void *element = pool->elements[--pool->curr_nr];
 
 	BUG_ON(pool->curr_nr < 0);
-	check_slab_element(pool, element);
+	check_element(pool, element);
 	return element;
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-refactor-zone_movable_is_highmem.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-compaction-reset-compaction-scanner-positions.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
hugetlbfs-document-min_size-mount-option-and-cleanup.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mremap-should-return-enomem-when-__vm_enough_memory-fail.patch
clean-up-goto-just-return-err_ptr.patch
fs-jfs-remove-slab-object-constructor.patch
mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch
mm-mempool-poison-elements-backed-by-slab-allocator.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix-fix.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix-fix-fix.patch
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix.patch
mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory.patch
mm-dont-call-__page_cache_release-for-hugetlb.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
thp-cleanup-khugepaged-startup.patch
mm-mempool-kasan-poison-mempool-elements.patch
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch

