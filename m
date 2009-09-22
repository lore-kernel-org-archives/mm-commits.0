From: akpm@linux-foundation.org
Subject: [merged] mm-count-only-reclaimable-lru-pages-v2.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:39 -0700
Message-ID: <200909222038.n8MKcdUg001831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099AbZIVUnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dhowells@redhat.com, hannes@cmpxchg.org, jbarnes@virtuousgeek.org, kosaki.motohiro@jp.fujitsu.com, macli@brc.u


The patch titled
     mm: count only reclaimable lru pages
has been removed from the -mm tree.  Its filename was
     mm-count-only-reclaimable-lru-pages-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: count only reclaimable lru pages
From: Wu Fengguang <fengguang.wu@intel.com>

global_lru_pages() / zone_lru_pages() can be used in two ways:
- to estimate max reclaimable pages in determine_dirtyable_memory()
- to calculate the slab scan ratio

When swap is full or not present, the anon lru lists are not reclaimable
and also won't be scanned.  So the anon pages shall not be counted in both
usage scenarios.  Also rename to _reclaimable_pages: now they are counting
the possibly reclaimable lru pages.

It can greatly (and correctly) increase the slab scan rate under high
memory pressure (when most file pages have been reclaimed and swap is
full/absent), thus reduce false OOM kills.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "Li, Ming Chun" <macli@brc.ubc.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   11 +-------
 mm/page-writeback.c    |    5 ++-
 mm/vmscan.c            |   50 ++++++++++++++++++++++++++++++---------
 3 files changed, 44 insertions(+), 22 deletions(-)

diff -puN include/linux/vmstat.h~mm-count-only-reclaimable-lru-pages-v2 include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-count-only-reclaimable-lru-pages-v2
+++ a/include/linux/vmstat.h
@@ -166,15 +166,8 @@ static inline unsigned long zone_page_st
 	return x;
 }
 
-extern unsigned long global_lru_pages(void);
-
-static inline unsigned long zone_lru_pages(struct zone *zone)
-{
-	return (zone_page_state(zone, NR_ACTIVE_ANON)
-		+ zone_page_state(zone, NR_ACTIVE_FILE)
-		+ zone_page_state(zone, NR_INACTIVE_ANON)
-		+ zone_page_state(zone, NR_INACTIVE_FILE));
-}
+extern unsigned long global_reclaimable_pages(void);
+extern unsigned long zone_reclaimable_pages(struct zone *zone);
 
 #ifdef CONFIG_NUMA
 /*
diff -puN mm/page-writeback.c~mm-count-only-reclaimable-lru-pages-v2 mm/page-writeback.c
--- a/mm/page-writeback.c~mm-count-only-reclaimable-lru-pages-v2
+++ a/mm/page-writeback.c
@@ -380,7 +380,8 @@ static unsigned long highmem_dirtyable_m
 		struct zone *z =
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
-		x += zone_page_state(z, NR_FREE_PAGES) + zone_lru_pages(z);
+		x += zone_page_state(z, NR_FREE_PAGES) +
+		     zone_reclaimable_pages(z);
 	}
 	/*
 	 * Make sure that the number of highmem pages is never larger
@@ -404,7 +405,7 @@ unsigned long determine_dirtyable_memory
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_lru_pages();
+	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
diff -puN mm/vmscan.c~mm-count-only-reclaimable-lru-pages-v2 mm/vmscan.c
--- a/mm/vmscan.c~mm-count-only-reclaimable-lru-pages-v2
+++ a/mm/vmscan.c
@@ -1734,7 +1734,7 @@ static unsigned long do_try_to_free_page
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
 
-			lru_pages += zone_lru_pages(zone);
+			lru_pages += zone_reclaimable_pages(zone);
 		}
 	}
 
@@ -1951,7 +1951,7 @@ loop_again:
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 
-			lru_pages += zone_lru_pages(zone);
+			lru_pages += zone_reclaimable_pages(zone);
 		}
 
 		/*
@@ -1995,7 +1995,7 @@ loop_again:
 			if (zone_is_all_unreclaimable(zone))
 				continue;
 			if (nr_slab == 0 && zone->pages_scanned >=
-						(zone_lru_pages(zone) * 6))
+					(zone_reclaimable_pages(zone) * 6))
 					zone_set_flag(zone,
 						      ZONE_ALL_UNRECLAIMABLE);
 			/*
@@ -2162,12 +2162,39 @@ void wakeup_kswapd(struct zone *zone, in
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
-unsigned long global_lru_pages(void)
+/*
+ * The reclaimable count would be mostly accurate.
+ * The less reclaimable pages may be
+ * - mlocked pages, which will be moved to unevictable list when encountered
+ * - mapped pages, which may require several travels to be reclaimed
+ * - dirty pages, which is not "instantly" reclaimable
+ */
+unsigned long global_reclaimable_pages(void)
 {
-	return global_page_state(NR_ACTIVE_ANON)
-		+ global_page_state(NR_ACTIVE_FILE)
-		+ global_page_state(NR_INACTIVE_ANON)
-		+ global_page_state(NR_INACTIVE_FILE);
+	int nr;
+
+	nr = global_page_state(NR_ACTIVE_FILE) +
+	     global_page_state(NR_INACTIVE_FILE);
+
+	if (nr_swap_pages > 0)
+		nr += global_page_state(NR_ACTIVE_ANON) +
+		      global_page_state(NR_INACTIVE_ANON);
+
+	return nr;
+}
+
+unsigned long zone_reclaimable_pages(struct zone *zone)
+{
+	int nr;
+
+	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
+	     zone_page_state(zone, NR_INACTIVE_FILE);
+
+	if (nr_swap_pages > 0)
+		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
+		      zone_page_state(zone, NR_INACTIVE_ANON);
+
+	return nr;
 }
 
 #ifdef CONFIG_HIBERNATION
@@ -2239,7 +2266,7 @@ unsigned long shrink_all_memory(unsigned
 
 	current->reclaim_state = &reclaim_state;
 
-	lru_pages = global_lru_pages();
+	lru_pages = global_reclaimable_pages();
 	nr_slab = global_page_state(NR_SLAB_RECLAIMABLE);
 	/* If slab caches are huge, it's better to hit them first */
 	while (nr_slab >= lru_pages) {
@@ -2281,7 +2308,7 @@ unsigned long shrink_all_memory(unsigned
 
 			reclaim_state.reclaimed_slab = 0;
 			shrink_slab(sc.nr_scanned, sc.gfp_mask,
-					global_lru_pages());
+				    global_reclaimable_pages());
 			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
 			if (sc.nr_reclaimed >= nr_pages)
 				goto out;
@@ -2298,7 +2325,8 @@ unsigned long shrink_all_memory(unsigned
 	if (!sc.nr_reclaimed) {
 		do {
 			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask, global_lru_pages());
+			shrink_slab(nr_pages, sc.gfp_mask,
+				    global_reclaimable_pages());
 			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
 		} while (sc.nr_reclaimed < nr_pages &&
 				reclaim_state.reclaimed_slab > 0);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
libfs-return-error-code-on-failed-attr-set.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch
documentation-vm-gitignore-add-page-types.patch
page-types-add-feature-for-walking-process-address-space.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch

