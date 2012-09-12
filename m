From: akpm@linux-foundation.org
Subject: + mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch added to -mm tree
Date: Wed, 12 Sep 2012 13:07:41 -0700
Message-ID: <20120912200742.3D17A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35892 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2ILUHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 16:07:45 -0400
Received: by eekd4 with SMTP id d4so143786eek.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 13:07:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, riel@redhat.com


The patch titled
     Subject: mm: cma: discard clean pages during contiguous allocation instead of migration
has been added to the -mm tree.  Its filename is
     mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: cma: discard clean pages during contiguous allocation instead of migration

Drop clean cache pages instead of migration during alloc_contig_range() to
minimise allocation latency by reducing the amount of migration that is
necessary.  It's useful for CMA because latency of migration is more
important than evicting the background process's working set.  In
addition, as pages are reclaimed then fewer free pages for migration
targets are required so it avoids memory reclaiming to get free pages,
which is a contributory factor to increased latency.

I measured elapsed time of __alloc_contig_migrate_range() which migrates
10M in 40M movable zone in QEMU machine.

Before - 146ms, After - 7ms

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Mel Gorman <mgorman@suse.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Rik van Riel <riel@redhat.com>
Tested-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    3 ++-
 mm/page_alloc.c |    2 ++
 mm/vmscan.c     |   43 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 41 insertions(+), 7 deletions(-)

diff -puN mm/internal.h~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration mm/internal.h
--- a/mm/internal.h~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration
+++ a/mm/internal.h
@@ -356,5 +356,6 @@ extern unsigned long vm_mmap_pgoff(struc
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-
+unsigned long reclaim_clean_pages_from_list(struct zone *zone,
+					    struct list_head *page_list);
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/page_alloc.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration
+++ a/mm/page_alloc.c
@@ -5699,6 +5699,8 @@ static int __alloc_contig_migrate_range(
 			break;
 		}
 
+		reclaim_clean_pages_from_list(cc.zone, &cc.migratepages);
+
 		ret = migrate_pages(&cc.migratepages,
 				    __alloc_contig_migrate_alloc,
 				    0, false, MIGRATE_SYNC);
diff -puN mm/vmscan.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration mm/vmscan.c
--- a/mm/vmscan.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration
+++ a/mm/vmscan.c
@@ -674,8 +674,10 @@ static enum page_references page_check_r
 static unsigned long shrink_page_list(struct list_head *page_list,
 				      struct zone *zone,
 				      struct scan_control *sc,
+				      enum ttu_flags ttu_flags,
 				      unsigned long *ret_nr_dirty,
-				      unsigned long *ret_nr_writeback)
+				      unsigned long *ret_nr_writeback,
+				      bool force_reclaim)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
@@ -689,10 +691,10 @@ static unsigned long shrink_page_list(st
 
 	mem_cgroup_uncharge_start();
 	while (!list_empty(page_list)) {
-		enum page_references references;
 		struct address_space *mapping;
 		struct page *page;
 		int may_enter_fs;
+		enum page_references references = PAGEREF_RECLAIM;
 
 		cond_resched();
 
@@ -758,7 +760,9 @@ static unsigned long shrink_page_list(st
 			wait_on_page_writeback(page);
 		}
 
-		references = page_check_references(page, sc);
+		if (!force_reclaim)
+			references = page_check_references(page, sc);
+
 		switch (references) {
 		case PAGEREF_ACTIVATE:
 			goto activate_locked;
@@ -788,7 +792,7 @@ static unsigned long shrink_page_list(st
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page) && mapping) {
-			switch (try_to_unmap(page, TTU_UNMAP)) {
+			switch (try_to_unmap(page, ttu_flags)) {
 			case SWAP_FAIL:
 				goto activate_locked;
 			case SWAP_AGAIN:
@@ -960,6 +964,33 @@ keep:
 	return nr_reclaimed;
 }
 
+unsigned long reclaim_clean_pages_from_list(struct zone *zone,
+					    struct list_head *page_list)
+{
+	struct scan_control sc = {
+		.gfp_mask = GFP_KERNEL,
+		.priority = DEF_PRIORITY,
+		.may_unmap = 1,
+	};
+	unsigned long ret, dummy1, dummy2;
+	struct page *page, *next;
+	LIST_HEAD(clean_pages);
+
+	list_for_each_entry_safe(page, next, page_list, lru) {
+		if (page_is_file_cache(page) && !PageDirty(page)) {
+			ClearPageActive(page);
+			list_move(&page->lru, &clean_pages);
+		}
+	}
+
+	ret = shrink_page_list(&clean_pages, zone, &sc,
+				TTU_UNMAP|TTU_IGNORE_ACCESS,
+				&dummy1, &dummy2, true);
+	list_splice(&clean_pages, page_list);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
+	return ret;
+}
+
 /*
  * Attempt to remove the specified page from its LRU.  Only take this page
  * if it is of the appropriate PageActive status.  Pages which are being
@@ -1278,8 +1309,8 @@ shrink_inactive_list(unsigned long nr_to
 	if (nr_taken == 0)
 		return 0;
 
-	nr_reclaimed = shrink_page_list(&page_list, zone, sc,
-						&nr_dirty, &nr_writeback);
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc, TTU_UNMAP,
+					&nr_dirty, &nr_writeback, false);
 
 	spin_lock_irq(&zone->lru_lock);
 
_

Patches currently in -mm which might be from minchan@kernel.org are

memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix-fix.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-check-lock-contention-first-before-taking-lock.patch

