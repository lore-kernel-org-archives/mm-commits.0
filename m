From: akpm@linux-foundation.org
Subject: - mm-remove-gfp_highuser_pagecache.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:13 -0800
Message-ID: <200901072212.n07MCDEX012475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505AbZAGWMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: remove GFP_HIGHUSER_PAGECACHE
has been removed from the -mm tree.  Its filename was
     mm-remove-gfp_highuser_pagecache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove GFP_HIGHUSER_PAGECACHE
From: Hugh Dickins <hugh@veritas.com>

GFP_HIGHUSER_PAGECACHE is just an alias for GFP_HIGHUSER_MOVABLE, making
that harder to track down: remove it, and its out-of-work brothers
GFP_NOFS_PAGECACHE and GFP_USER_PAGECACHE.

Since we're making that improvement to hotremove_migrate_alloc(), I think
we can now also remove one of the "o"s from its comment.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c          |    4 ++--
 include/linux/gfp.h |    6 ------
 mm/memory_hotplug.c |    9 +++------
 3 files changed, 5 insertions(+), 14 deletions(-)

diff -puN fs/inode.c~mm-remove-gfp_highuser_pagecache fs/inode.c
--- a/fs/inode.c~mm-remove-gfp_highuser_pagecache
+++ a/fs/inode.c
@@ -166,7 +166,7 @@ struct inode *inode_init_always(struct s
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
 	mapping->flags = 0;
-	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_PAGECACHE);
+	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->assoc_mapping = NULL;
 	mapping->backing_dev_info = &default_backing_dev_info;
 	mapping->writeback_index = 0;
@@ -601,7 +601,7 @@ EXPORT_SYMBOL_GPL(inode_add_to_lists);
  *	@sb: superblock
  *
  *	Allocates a new inode for given superblock. The default gfp_mask
- *	for allocations related to inode->i_mapping is GFP_HIGHUSER_PAGECACHE.
+ *	for allocations related to inode->i_mapping is GFP_HIGHUSER_MOVABLE.
  *	If HIGHMEM pages are unsuitable or it is known that pages allocated
  *	for the page cache are not reclaimable or migratable,
  *	mapping_set_gfp_mask() must be called with suitable flags on the
diff -puN include/linux/gfp.h~mm-remove-gfp_highuser_pagecache include/linux/gfp.h
--- a/include/linux/gfp.h~mm-remove-gfp_highuser_pagecache
+++ a/include/linux/gfp.h
@@ -69,12 +69,6 @@ struct vm_area_struct;
 #define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
 				 __GFP_HARDWALL | __GFP_HIGHMEM | \
 				 __GFP_MOVABLE)
-#define GFP_NOFS_PAGECACHE	(__GFP_WAIT | __GFP_IO | __GFP_MOVABLE)
-#define GFP_USER_PAGECACHE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
-				 __GFP_HARDWALL | __GFP_MOVABLE)
-#define GFP_HIGHUSER_PAGECACHE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
-				 __GFP_HARDWALL | __GFP_HIGHMEM | \
-				 __GFP_MOVABLE)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
diff -puN mm/memory_hotplug.c~mm-remove-gfp_highuser_pagecache mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-remove-gfp_highuser_pagecache
+++ a/mm/memory_hotplug.c
@@ -627,15 +627,12 @@ int scan_lru_pages(unsigned long start, 
 }
 
 static struct page *
-hotremove_migrate_alloc(struct page *page,
-			unsigned long private,
-			int **x)
+hotremove_migrate_alloc(struct page *page, unsigned long private, int **x)
 {
-	/* This should be improoooooved!! */
-	return alloc_page(GFP_HIGHUSER_PAGECACHE);
+	/* This should be improooooved!! */
+	return alloc_page(GFP_HIGHUSER_MOVABLE);
 }
 
-
 #define NR_OFFLINE_AT_ONCE_PAGES	(256)
 static int
 do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

