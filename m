From: akpm@linux-foundation.org
Subject: + mm-mempool-poison-elements-backed-by-page-allocator.patch added to -mm tree
Date: Wed, 25 Mar 2015 14:55:41 -0700
Message-ID: <55132edd.ZoNxQ/T4YZrMJdBZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbbCYVzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 17:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, catalin.marinas@arm.com, hch@lst.de, mpatocka@redhat.com, sebott@linux.vnet.ibm.com, shaggy@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempool: poison elements backed by page allocator
has been added to the -mm tree.  Its filename is
     mm-mempool-poison-elements-backed-by-page-allocator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-poison-elements-backed-by-page-allocator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-poison-elements-backed-by-page-allocator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch
mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers.patch
mm-memory-hotplog-postpone-the-reset-of-obsolete-pgdat.patch
mm-slub-fix-lockups-on-preempt-smp-kernels.patch
cxgb4-drop-__gfp_nofail-allocation.patch
sh-dwarf-destroy-mempools-on-cleanup.patch
sh-dwarf-use-mempool_create_slab_pool.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-slab-correct-config-option-in-comment.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-mempool-do-not-allow-atomic-resizing.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-refactor-zone_movable_is_highmem.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
allow-compaction-of-unevictable-pages.patch
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
mm-mempool-poison-elements-backed-by-page-allocator.patch
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

