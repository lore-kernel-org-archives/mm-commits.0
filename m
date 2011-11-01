From: akpm@linux-foundation.org
Subject: [merged] mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:07:53 -0700
Message-ID: <201111012107.pA1L7rwF016393@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15340 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1KAVIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-co


The patch titled
     Subject: mm: zone_reclaim: make isolate_lru_page() filter-aware
has been removed from the -mm tree.  Its filename was
     mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Minchan Kim <minchan.kim@gmail.com>
Subject: mm: zone_reclaim: make isolate_lru_page() filter-aware

In __zone_reclaim case, we don't want to shrink mapped page.  Nonetheless,
we have isolated mapped page and re-add it into LRU's head.  It's
unnecessary CPU overhead and makes LRU churning.

Of course, when we isolate the page, the page might be mapped but when we
try to migrate the page, the page would be not mapped.  So it could be
migrated.  But race is rare and although it happens, it's no big deal.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/vmscan.c            |   20 ++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-zone_reclaim-make-isolate_lru_page-filter-aware include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-zone_reclaim-make-isolate_lru_page-filter-aware
+++ a/include/linux/mmzone.h
@@ -170,6 +170,8 @@ static inline int is_unevictable_lru(enu
 #define ISOLATE_ACTIVE		((__force isolate_mode_t)0x2)
 /* Isolate clean file */
 #define ISOLATE_CLEAN		((__force isolate_mode_t)0x4)
+/* Isolate unmapped file */
+#define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x8)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
diff -puN mm/vmscan.c~mm-zone_reclaim-make-isolate_lru_page-filter-aware mm/vmscan.c
--- a/mm/vmscan.c~mm-zone_reclaim-make-isolate_lru_page-filter-aware
+++ a/mm/vmscan.c
@@ -1048,6 +1048,9 @@ int __isolate_lru_page(struct page *page
 	if ((mode & ISOLATE_CLEAN) && (PageDirty(page) || PageWriteback(page)))
 		return ret;
 
+	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
+		return ret;
+
 	if (likely(get_page_unless_zero(page))) {
 		/*
 		 * Be careful not to clear PageLRU until after we're
@@ -1471,6 +1474,12 @@ shrink_inactive_list(unsigned long nr_to
 		reclaim_mode |= ISOLATE_ACTIVE;
 
 	lru_add_drain();
+
+	if (!sc->may_unmap)
+		reclaim_mode |= ISOLATE_UNMAPPED;
+	if (!sc->may_writepage)
+		reclaim_mode |= ISOLATE_CLEAN;
+
 	spin_lock_irq(&zone->lru_lock);
 
 	if (scanning_global_lru(sc)) {
@@ -1588,19 +1597,26 @@ static void shrink_active_list(unsigned 
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	unsigned long nr_rotated = 0;
+	isolate_mode_t reclaim_mode = ISOLATE_ACTIVE;
 
 	lru_add_drain();
+
+	if (!sc->may_unmap)
+		reclaim_mode |= ISOLATE_UNMAPPED;
+	if (!sc->may_writepage)
+		reclaim_mode |= ISOLATE_CLEAN;
+
 	spin_lock_irq(&zone->lru_lock);
 	if (scanning_global_lru(sc)) {
 		nr_taken = isolate_pages_global(nr_pages, &l_hold,
 						&pgscanned, sc->order,
-						ISOLATE_ACTIVE, zone,
+						reclaim_mode, zone,
 						1, file);
 		zone->pages_scanned += pgscanned;
 	} else {
 		nr_taken = mem_cgroup_isolate_pages(nr_pages, &l_hold,
 						&pgscanned, sc->order,
-						ISOLATE_ACTIVE, zone,
+						reclaim_mode, zone,
 						sc->mem_cgroup, 1, file);
 		/*
 		 * mem_cgroup_isolate_pages() keeps track of
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
thp-tail-page-refcounting-fix-5.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

