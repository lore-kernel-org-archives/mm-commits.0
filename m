From: akpm@linux-foundation.org
Subject: [folded] memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:32:43 -0700
Message-ID: <20120731233243.D2040A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34356 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2GaXcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:32:45 -0400
Received: by obbwc20 with SMTP id wc20so4819432obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:32:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aaditya.kumar.30@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-fix-kswapd-looping-forever-problem-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch

This patch was dropped because it was folded into memory-hotplug-fix-kswapd-looping-forever-problem.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hotplug-fix-kswapd-looping-forever-problem-fix

simplify nr_zone_isolate_freepages(), rework zone_watermark_ok_safe() comment, simplify set_pageblock_isolate() and restore_pageblock_isolate().

Cc: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |   19 ++++++++-----------
 mm/page_isolation.c |   19 ++++++++-----------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff -puN mm/page_alloc.c~memory-hotplug-fix-kswapd-looping-forever-problem-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-kswapd-looping-forever-problem-fix
+++ a/mm/page_alloc.c
@@ -1626,12 +1626,9 @@ static bool __zone_watermark_ok(struct z
 #ifdef CONFIG_MEMORY_ISOLATION
 static inline unsigned long nr_zone_isolate_freepages(struct zone *zone)
 {
-	unsigned long nr_pages = 0;
-
-	if (unlikely(zone->nr_pageblock_isolate)) {
-		nr_pages = zone->nr_pageblock_isolate * pageblock_nr_pages;
-	}
-	return nr_pages;
+	if (unlikely(zone->nr_pageblock_isolate))
+		return zone->nr_pageblock_isolate * pageblock_nr_pages;
+	return 0;
 }
 #else
 static inline unsigned long nr_zone_isolate_freepages(struct zone *zone)
@@ -1656,11 +1653,11 @@ bool zone_watermark_ok_safe(struct zone 
 		free_pages = zone_page_state_snapshot(z, NR_FREE_PAGES);
 
 	/*
-	 * If the zone has MIGRATE_ISOLATE type free page,
-	 * we should consider it. nr_zone_isolate_freepages is never
-	 * accurate so kswapd might not sleep although she can.
-	 * But it's more desirable for memory hotplug rather than
-	 * forever sleep which cause livelock in direct reclaim path.
+	 * If the zone has MIGRATE_ISOLATE type free pages, we should consider
+	 * it.  nr_zone_isolate_freepages is never accurate so kswapd might not
+	 * sleep although it could do so.  But this is more desirable for memory
+	 * hotplug than sleeping which can cause a livelock in the direct
+	 * reclaim path.
 	 */
 	free_pages -= nr_zone_isolate_freepages(z);
 	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
diff -puN mm/page_isolation.c~memory-hotplug-fix-kswapd-looping-forever-problem-fix mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotplug-fix-kswapd-looping-forever-problem-fix
+++ a/mm/page_isolation.c
@@ -8,23 +8,20 @@
 #include <linux/memory.h>
 #include "internal.h"
 
-/* called by holding zone->lock */
-static void set_pageblock_isolate(struct zone *zone, struct page *page)
+/* called while holding zone->lock */
+static void set_pageblock_isolate(struct page *page)
 {
-	BUG_ON(page_zone(page) != zone);
-
 	if (get_pageblock_migratetype(page) == MIGRATE_ISOLATE)
 		return;
 
 	set_pageblock_migratetype(page, MIGRATE_ISOLATE);
-	zone->nr_pageblock_isolate++;
+	page_zone(page)->nr_pageblock_isolate++;
 }
 
-/* called by holding zone->lock */
-static void restore_pageblock_isolate(struct zone *zone, struct page *page,
-		int migratetype)
+/* called while holding zone->lock */
+static void restore_pageblock_isolate(struct page *page, int migratetype)
 {
-	BUG_ON(page_zone(page) != zone);
+	struct zone *zone = page_zone(page);
 	if (WARN_ON(get_pageblock_migratetype(page) != MIGRATE_ISOLATE))
 		return;
 
@@ -79,7 +76,7 @@ int set_migratetype_isolate(struct page 
 
 out:
 	if (!ret) {
-		set_pageblock_isolate(zone, page);
+		set_pageblock_isolate(page);
 		move_freepages_block(zone, page, MIGRATE_ISOLATE);
 	}
 
@@ -98,7 +95,7 @@ void unset_migratetype_isolate(struct pa
 	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 		goto out;
 	move_freepages_block(zone, page, migratetype);
-	restore_pageblock_isolate(zone, page, migratetype);
+	restore_pageblock_isolate(page, migratetype);
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-media-video-v4l2-ioctlc-fix-build.patch
mm-make-vb_alloc-more-foolproof.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
mm-have-order-0-compaction-start-off-where-it-left.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix-fix.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

