From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-compaction-memory-compaction-core-map-free-pages-in-the-address-space-after-they-get-split-for-compaction.patch removed from -mm tree
Date: Thu, 22 Apr 2010 12:06:40 -0700
Message-ID: <201004221906.o3MJ6eJs002138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755352Ab0DVTH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 15:07:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm,compaction: map free pages in the address space after they get split for compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-memory-compaction-core-map-free-pages-in-the-address-space-after-they-get-split-for-compaction.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm,compaction: map free pages in the address space after they get split for compaction
From: Mel Gorman <mel@csn.ul.ie>

split_free_page() is a helper function which takes a free page from the
buddy lists and splits it into order-0 pages.  It is used by memory
compaction to build a list of destination pages.  If
CONFIG_DEBUG_PAGEALLOC is set, a kernel paging request bug is triggered
because split_free_page() did not call the arch-allocation hooks or map
the page into the kernel address space.

This patch does not update split_free_page() as it is called with
interrupts held.  Instead it documents that callers of split_free_page()
are responsible for calling the arch hooks and to map the page and fixes
compaction.

This is a fix to the patch mm-compaction-memory-compaction-core.patch.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++++++
 mm/page_alloc.c |    3 +++
 2 files changed, 9 insertions(+)

diff -puN mm/compaction.c~mm-compaction-memory-compaction-core-map-free-pages-in-the-address-space-after-they-get-split-for-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-memory-compaction-core-map-free-pages-in-the-address-space-after-they-get-split-for-compaction
+++ a/mm/compaction.c
@@ -180,6 +180,12 @@ static void isolate_freepages(struct zon
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
 
+	/* split_free_page does not map the pages */
+	list_for_each_entry(page, freelist, lru) {
+		arch_alloc_page(page, 0);
+		kernel_map_pages(page, 1, 1);
+	}
+
 	cc->free_pfn = high_pfn;
 	cc->nr_freepages = nr_freepages;
 }
diff -puN mm/page_alloc.c~mm-compaction-memory-compaction-core-map-free-pages-in-the-address-space-after-they-get-split-for-compaction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-memory-compaction-core-map-free-pages-in-the-address-space-after-they-get-split-for-compaction
+++ a/mm/page_alloc.c
@@ -1210,6 +1210,9 @@ void split_page(struct page *page, unsig
 /*
  * Similar to split_page except the page is already free. As this is only
  * being used for migration, the migratetype of the block also changes.
+ * As this is called with interrupts disabled, the caller is responsible
+ * for calling arch_alloc_page() and kernel_map_page() after interrupts
+ * are enabled.
  */
 int split_free_page(struct page *page)
 {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
hugetlbfs-kill-applications-that-use-map_noreserve-with-sigbus-instead-of-oom-killer.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mempolicy-remove-redundant-code.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-compaction-memory-compaction-core-map-free-pages-in-the-address-space-after-they-get-split-for-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled.patch
vmstat-fix-build-errors-when-proc_fs-is-disabled-checkpatch-fixes.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2-do-not-compact-twice.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree.patch
mm-introduce-free_pages_prepare.patch
mm-introduce-free_pages_prepare-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
add-debugging-aid-for-memory-initialisation-problems.patch

