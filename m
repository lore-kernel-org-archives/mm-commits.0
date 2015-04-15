From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mempool-poison-elements-backed-by-page-allocator-fix-fix.patch removed
 from -mm tree
Date: Wed, 15 Apr 2015 15:37:40 -0700
Message-ID: <552ee834.IIo04E6cm0L3pxhc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbbDOWhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:37:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, a.ryabinin@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempool: poison elements backed by page allocator fix fix
has been removed from the -mm tree.  Its filename was
     mm-mempool-poison-elements-backed-by-page-allocator-fix-fix.patch

This patch was dropped because it was folded into mm-mempool-poison-elements-backed-by-slab-allocator.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempool: poison elements backed by page allocator fix fix

Elements backed by the page allocator might not be directly mapped into
lowmem, so do k{,un}map_atomic() before poisoning and verifying contents
to map into lowmem and return the virtual adddress.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/mempool.c~mm-mempool-poison-elements-backed-by-page-allocator-fix-fix mm/mempool.c
--- a/mm/mempool.c~mm-mempool-poison-elements-backed-by-page-allocator-fix-fix
+++ a/mm/mempool.c
@@ -61,9 +61,10 @@ static void check_element(mempool_t *poo
 	/* Mempools backed by page allocator */
 	if (pool->free == mempool_free_pages) {
 		int order = (int)(long)pool->pool_data;
-		void *addr = page_address(element);
+		void *addr = kmap_atomic((struct page *)element);
 
 		__check_element(pool, addr, 1UL << (PAGE_SHIFT + order));
+		kunmap_atomic(addr);
 	}
 }
 
@@ -84,9 +85,10 @@ static void poison_element(mempool_t *po
 	/* Mempools backed by page allocator */
 	if (pool->alloc == mempool_alloc_pages) {
 		int order = (int)(long)pool->pool_data;
-		void *addr = page_address(element);
+		void *addr = kmap_atomic((struct page *)element);
 
 		__poison_element(addr, 1UL << (PAGE_SHIFT + order));
+		kunmap_atomic(addr);
 	}
 }
 #else /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
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

