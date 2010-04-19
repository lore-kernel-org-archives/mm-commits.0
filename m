From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-alloc-function-in-pcpu_alloc_pages.patch removed from -mm tree
Date: Mon, 19 Apr 2010 15:26:15 -0700
Message-ID: <201004192226.o3JMQFQE013203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716Ab0DSW0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:26:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, cl@linux-foundation.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: alloc function in pcpu_alloc_pages
has been removed from the -mm tree.  Its filename was
     mm-alloc-function-in-pcpu_alloc_pages.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: alloc function in pcpu_alloc_pages
From: Minchan Kim <minchan.kim@gmail.com>

alloc_pages_node() is called with cpu_to_node(cpu).  I think
cpu_to_node(cpu) never returns -1.

So we can use alloc_pages_exact_node() instead of alloc_pages_node().  It
could avoid comparison and branch as 6484eb3e2a81807722 ("page allocator:
do not check NUMA node ID when the caller knows the node is") tried.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/percpu.c~mm-alloc-function-in-pcpu_alloc_pages mm/percpu.c
--- a/mm/percpu.c~mm-alloc-function-in-pcpu_alloc_pages
+++ a/mm/percpu.c
@@ -720,7 +720,7 @@ static int pcpu_alloc_pages(struct pcpu_
 		for (i = page_start; i < page_end; i++) {
 			struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
 
-			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
+			*pagep = alloc_pages_exact_node(cpu_to_node(cpu), gfp, 0);
 			if (!*pagep) {
 				pcpu_free_pages(chunk, pages, populated,
 						page_start, page_end);
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

linux-next.patch
rmap-add-exclusively-owned-pages-to-the-newest-anon_vma.patch
ntfs-clean-up-ntfs_attr_extend_initialized.patch
ntfs-use-add_to_page_cache_lru.patch
shmem-remove-redundant-code.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix-fix-2.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index-fix.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree.patch
mm-alloc-function-in-pcpu_alloc_pages.patch
mm-change-alloc-function-in-vmemmap_alloc_block.patch
mm-change-alloc-function-in-__vmalloc_area_node.patch
mm-add-comment-in-alloc_pages_exact_node.patch
vmscan-page_check_references-check-low-order-lumpy-reclaim-properly.patch

