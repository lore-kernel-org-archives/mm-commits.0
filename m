From: akpm@linux-foundation.org
Subject: + memory-hotplug-unify-is_removable-and-offline-detection-code.patch added to -mm tree
Date: Tue, 07 Sep 2010 14:04:48 -0700
Message-ID: <201009072104.o87L4mpr006045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab0IGVGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 17:06:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com, mel@csn.ul.ie, mhocko@suse.cz


The patch titled
     memory hotplug: unify is_removable and offline detection code
has been added to the -mm tree.  Its filename is
     memory-hotplug-unify-is_removable-and-offline-detection-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: unify is_removable and offline detection code
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, sysfs interface of memory hotplug shows whether the section is
removable or not.  But it checks only migrateype of pages and doesn't
check details of cluster of pages.

Next, memory hotplug's set_migratetype_isolate() has the same kind of
check, too.

This patch adds the function __count_unmovable_pages() and makes above 2
checks to use the same logic.  Then, is_removable and hotremove code uses
the same logic.  No changes in the hotremove logic itself.

TODO: need to find a way to check RECLAMABLE. But, considering bit,
      calling shrink_slab() against a range before starting memory hotremove
      sounds better. If so, this patch's logic doesn't need to be changed.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reported-by: Michal Hocko <mhocko@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    4 +
 mm/memory_hotplug.c            |   17 ------
 mm/page_alloc.c                |   87 +++++++++++++++++++++++--------
 3 files changed, 72 insertions(+), 36 deletions(-)

diff -puN include/linux/memory_hotplug.h~memory-hotplug-unify-is_removable-and-offline-detection-code include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-unify-is_removable-and-offline-detection-code
+++ a/include/linux/memory_hotplug.h
@@ -70,6 +70,10 @@ extern void online_page(struct page *pag
 extern int online_pages(unsigned long, unsigned long);
 extern void __offline_isolated_pages(unsigned long, unsigned long);
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+extern bool is_pageblock_removable_nolock(struct page *page);
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(int nid, struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
diff -puN mm/memory_hotplug.c~memory-hotplug-unify-is_removable-and-offline-detection-code mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-unify-is_removable-and-offline-detection-code
+++ a/mm/memory_hotplug.c
@@ -602,27 +602,14 @@ static struct page *next_active_pagebloc
 /* Checks if this range of memory is likely to be hot-removable. */
 int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
 {
-	int type;
 	struct page *page = pfn_to_page(start_pfn);
 	struct page *end_page = page + nr_pages;
 
 	/* Check the starting page of each pageblock within the range */
 	for (; page < end_page; page = next_active_pageblock(page)) {
-		type = get_pageblock_migratetype(page);
-
-		/*
-		 * A pageblock containing MOVABLE or free pages is considered
-		 * removable
-		 */
-		if (type != MIGRATE_MOVABLE && !pageblock_free(page))
-			return 0;
-
-		/*
-		 * A pageblock starting with a PageReserved page is not
-		 * considered removable.
-		 */
-		if (PageReserved(page))
+		if (!is_pageblock_removable_nolock(page))
 			return 0;
+		cond_resched();
 	}
 
 	/* All pageblocks in the memory block are likely to be hot-removable */
diff -puN mm/page_alloc.c~memory-hotplug-unify-is_removable-and-offline-detection-code mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-unify-is_removable-and-offline-detection-code
+++ a/mm/page_alloc.c
@@ -5281,12 +5281,65 @@ void set_pageblock_flags_group(struct pa
  * page allocater never alloc memory from ISOLATE block.
  */
 
+static int
+__count_immobile_pages(struct zone *zone, struct page *page, int count)
+{
+	unsigned long pfn, iter, found;
+	/*
+	 * For avoiding noise data, lru_add_drain_all() should be called
+ 	 * If ZONE_MOVABLE, the zone never contains immobile pages
+ 	 */
+	if (zone_idx(zone) == ZONE_MOVABLE)
+		return true;
+
+	if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE)
+		return true;
+
+	pfn = page_to_pfn(page);
+	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
+		unsigned long check = pfn + iter;
+
+		if (!pfn_valid_within(check)) {
+			iter++;
+			continue;
+		}
+		page = pfn_to_page(check);
+		if (!page_count(page)) {
+			if (PageBuddy(page))
+				iter += (1 << page_order(page)) - 1;
+			continue;
+		}
+		if (!PageLRU(page))
+			found++;
+		/*
+		 * If there are RECLAIMABLE pages, we need to check it.
+		 * But now, memory offline itself doesn't call shrink_slab()
+		 * and it still to be fixed.
+		 */
+		/*
+		 * If the page is not RAM, page_count()should be 0.
+		 * we don't need more check. This is an _used_ not-movable page.
+		 *
+		 * The problematic thing here is PG_reserved pages. PG_reserved
+		 * is set to both of a memory hole page and a _used_ kernel
+		 * page at boot.
+		 */
+		if (found > count)
+			return false;
+	}
+	return true;
+}
+
+bool is_pageblock_removable_nolock(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+	return __count_immobile_pages(zone, page, 0);
+}
+
 int set_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
-	struct page *curr_page;
-	unsigned long flags, pfn, iter;
-	unsigned long immobile = 0;
+	unsigned long flags, pfn;
 	struct memory_isolate_notify arg;
 	int notifier_ret;
 	int ret = -EBUSY;
@@ -5296,11 +5349,6 @@ int set_migratetype_isolate(struct page 
 	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
-	if (get_pageblock_migratetype(page) == MIGRATE_MOVABLE ||
-	    zone_idx == ZONE_MOVABLE) {
-		ret = 0;
-		goto out;
-	}
 
 	pfn = page_to_pfn(page);
 	arg.start_pfn = pfn;
@@ -5322,21 +5370,18 @@ int set_migratetype_isolate(struct page 
 	notifier_ret = notifier_to_errno(notifier_ret);
 	if (notifier_ret)
 		goto out;
-
-	for (iter = pfn; iter < (pfn + pageblock_nr_pages); iter++) {
-		if (!pfn_valid_within(pfn))
-			continue;
-
-		curr_page = pfn_to_page(iter);
-		if (!page_count(curr_page) || PageLRU(curr_page))
-			continue;
-
-		immobile++;
-	}
-
-	if (arg.pages_found == immobile)
+	/*
+	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
+	 * We just check MOVABLE pages.
+	 */
+	if(__count_immobile_pages(zone ,page, arg.pages_found))
 		ret = 0;
 
+	/*
+	 * immobile means "not-on-lru" paes. If immobile is larger than
+	 * removable-by-driver pages reported by notifier, we'll fail.
+	 */
+
 out:
 	if (!ret) {
 		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memory-hotplug-fix-next-block-calculation-in-is_removable.patch
swap-revert-special-hibernation-allocation.patch
swap-prevent-reuse-during-hibernation.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch

