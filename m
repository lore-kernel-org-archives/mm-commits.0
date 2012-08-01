From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-fix-kswapd-looping-forever-problem.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:29 -0700
Message-ID: <20120801201529.DEB14100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:31 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aaditya.kumar.30@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: fix kswapd looping forever problem
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-kswapd-looping-forever-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: memory-hotplug: fix kswapd looping forever problem

When hotplug offlining happens on zone A, it starts to mark freed page as
MIGRATE_ISOLATE type in buddy for preventing further allocation. 
(MIGRATE_ISOLATE is very irony type because it's apparently on buddy but
we can't allocate them).

When the memory shortage happens during hotplug offlining, current task
starts to reclaim, then wake up kswapd.  Kswapd checks watermark, then go
sleep because current zone_watermark_ok_safe doesn't consider
MIGRATE_ISOLATE freed page count.  Current task continue to reclaim in
direct reclaim path without kswapd's helping.  The problem is that
zone->all_unreclaimable is set by only kswapd so that current task would
be looping forever like below.

__alloc_pages_slowpath
restart:
	wake_all_kswapd
rebalance:
	__alloc_pages_direct_reclaim
		do_try_to_free_pages
			if global_reclaim && !all_unreclaimable
				return 1; /* It means we did did_some_progress */
	skip __alloc_pages_may_oom
	should_alloc_retry
		goto rebalance;

If we apply KOSAKI's patch[1] which doesn't depends on kswapd about
setting zone->all_unreclaimable, we can solve this problem by killing some
task in direct reclaim path.  But it doesn't wake up kswapd, still.  It
could be a problem still if other subsystem needs GFP_ATOMIC request.  So
kswapd should consider MIGRATE_ISOLATE when it calculate free pages BEFORE
going sleep.

This patch counts the number of MIGRATE_ISOLATE page block and
zone_watermark_ok_safe will consider it if the system has such blocks
(fortunately, it's very rare so no problem in POV overhead and kswapd is
never hotpath).

Copy/modify from Mel's quote
"
Ideal solution would be "allocating" the pageblock.
It would keep the free space accounting as it is but historically,
memory hotplug didn't allocate pages because it would be difficult to
detect if a pageblock was isolated or if part of some balloon.
Allocating just full pageblocks would work around this, However,
it would play very badly with CMA.
"

[1] http://lkml.org/lkml/2012/6/14/74

[akpm@linux-foundation.org: simplify nr_zone_isolate_freepages(), rework zone_watermark_ok_safe() comment, simplify set_pageblock_isolate() and restore_pageblock_isolate()]
[akpm@linux-foundation.org: fix CONFIG_MEMORY_ISOLATION=n build]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Suggested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Tested-by: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 ++++++++
 mm/page_alloc.c        |   30 ++++++++++++++++++++++++++++++
 mm/page_isolation.c    |   26 ++++++++++++++++++++++++--
 3 files changed, 62 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~memory-hotplug-fix-kswapd-looping-forever-problem include/linux/mmzone.h
--- a/include/linux/mmzone.h~memory-hotplug-fix-kswapd-looping-forever-problem
+++ a/include/linux/mmzone.h
@@ -478,6 +478,14 @@ struct zone {
 	 * rarely used fields:
 	 */
 	const char		*name;
+#ifdef CONFIG_MEMORY_ISOLATION
+	/*
+	 * the number of MIGRATE_ISOLATE *pageblock*.
+	 * We need this for free page counting. Look at zone_watermark_ok_safe.
+	 * It's protected by zone->lock
+	 */
+	int		nr_pageblock_isolate;
+#endif
 } ____cacheline_internodealigned_in_smp;
 
 typedef enum {
diff -puN mm/page_alloc.c~memory-hotplug-fix-kswapd-looping-forever-problem mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-kswapd-looping-forever-problem
+++ a/mm/page_alloc.c
@@ -218,6 +218,11 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 int page_group_by_mobility_disabled __read_mostly;
 
+/*
+ * NOTE:
+ * Don't use set_pageblock_migratetype(page, MIGRATE_ISOLATE) directly.
+ * Instead, use {un}set_pageblock_isolate.
+ */
 void set_pageblock_migratetype(struct page *page, int migratetype)
 {
 
@@ -1619,6 +1624,20 @@ static bool __zone_watermark_ok(struct z
 	return true;
 }
 
+#ifdef CONFIG_MEMORY_ISOLATION
+static inline unsigned long nr_zone_isolate_freepages(struct zone *zone)
+{
+	if (unlikely(zone->nr_pageblock_isolate))
+		return zone->nr_pageblock_isolate * pageblock_nr_pages;
+	return 0;
+}
+#else
+static inline unsigned long nr_zone_isolate_freepages(struct zone *zone)
+{
+	return 0;
+}
+#endif
+
 bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 		      int classzone_idx, int alloc_flags)
 {
@@ -1634,6 +1653,14 @@ bool zone_watermark_ok_safe(struct zone 
 	if (z->percpu_drift_mark && free_pages < z->percpu_drift_mark)
 		free_pages = zone_page_state_snapshot(z, NR_FREE_PAGES);
 
+	/*
+	 * If the zone has MIGRATE_ISOLATE type free pages, we should consider
+	 * it.  nr_zone_isolate_freepages is never accurate so kswapd might not
+	 * sleep although it could do so.  But this is more desirable for memory
+	 * hotplug than sleeping which can cause a livelock in the direct
+	 * reclaim path.
+	 */
+	free_pages -= nr_zone_isolate_freepages(z);
 	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
 								free_pages);
 }
@@ -4398,6 +4425,9 @@ static void __paginginit free_area_init_
 		lruvec_init(&zone->lruvec, zone);
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
+#ifdef CONFIG_MEMORY_ISOLATION
+		zone->nr_pageblock_isolate = 0;
+#endif
 		if (!size)
 			continue;
 
diff -puN mm/page_isolation.c~memory-hotplug-fix-kswapd-looping-forever-problem mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotplug-fix-kswapd-looping-forever-problem
+++ a/mm/page_isolation.c
@@ -8,6 +8,28 @@
 #include <linux/memory.h>
 #include "internal.h"
 
+/* called while holding zone->lock */
+static void set_pageblock_isolate(struct page *page)
+{
+	if (get_pageblock_migratetype(page) == MIGRATE_ISOLATE)
+		return;
+
+	set_pageblock_migratetype(page, MIGRATE_ISOLATE);
+	page_zone(page)->nr_pageblock_isolate++;
+}
+
+/* called while holding zone->lock */
+static void restore_pageblock_isolate(struct page *page, int migratetype)
+{
+	struct zone *zone = page_zone(page);
+	if (WARN_ON(get_pageblock_migratetype(page) != MIGRATE_ISOLATE))
+		return;
+
+	BUG_ON(zone->nr_pageblock_isolate <= 0);
+	set_pageblock_migratetype(page, migratetype);
+	zone->nr_pageblock_isolate--;
+}
+
 int set_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
@@ -54,7 +76,7 @@ int set_migratetype_isolate(struct page 
 
 out:
 	if (!ret) {
-		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
+		set_pageblock_isolate(page);
 		move_freepages_block(zone, page, MIGRATE_ISOLATE);
 	}
 
@@ -72,8 +94,8 @@ void unset_migratetype_isolate(struct pa
 	spin_lock_irqsave(&zone->lock, flags);
 	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 		goto out;
-	set_pageblock_migratetype(page, migratetype);
 	move_freepages_block(zone, page, migratetype);
+	restore_pageblock_isolate(page, migratetype);
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-__gfp_no_kswapd.patch
remove-__gfp_no_kswapd-fixes-fix.patch

