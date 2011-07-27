From: akpm@linux-foundation.org
Subject: + mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch added to -mm tree
Date: Wed, 27 Jul 2011 13:12:24 -0700
Message-ID: <201107272012.p6RKCPV4005393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499Ab1G0UMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 16:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com


The patch titled
     mm: zone_reclaim: make isolate_lru_page() filter-aware
has been added to the -mm tree.  Its filename is
     mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch

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
Subject: mm: zone_reclaim: make isolate_lru_page() filter-aware
From: Minchan Kim <minchan.kim@gmail.com>

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

 include/linux/mmzone.h |    3 +++
 mm/vmscan.c            |   20 ++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-zone_reclaim-make-isolate_lru_page-filter-aware include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-zone_reclaim-make-isolate_lru_page-filter-aware
+++ a/include/linux/mmzone.h
@@ -170,6 +170,9 @@ static inline int is_unevictable_lru(enu
 #define ISOLATE_ACTIVE		((__force fmode_t)0x2)
 /* Isolate clean file */
 #define ISOLATE_CLEAN		((__force fmode_t)0x4)
+/* Isolate unmapped file */
+#define ISOLATE_UNMAPPED	((__force fmode_t)0x8)
+
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
 
diff -puN mm/vmscan.c~mm-zone_reclaim-make-isolate_lru_page-filter-aware mm/vmscan.c
--- a/mm/vmscan.c~mm-zone_reclaim-make-isolate_lru_page-filter-aware
+++ a/mm/vmscan.c
@@ -1049,6 +1049,9 @@ int __isolate_lru_page(struct page *page
 	if ((mode & ISOLATE_CLEAN) && (PageDirty(page) || PageWriteback(page)))
 		return ret;
 
+	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
+		return ret;
+
 	if (likely(get_page_unless_zero(page))) {
 		/*
 		 * Be careful not to clear PageLRU until after we're
@@ -1478,6 +1481,12 @@ shrink_inactive_list(unsigned long nr_to
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
@@ -1598,19 +1607,26 @@ static void shrink_active_list(unsigned 
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
mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-migration-clean-up-unmap_and_move.patch

