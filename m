From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-make-isolate_lru_page-filter-aware.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:07:48 -0700
Message-ID: <201111012107.pA1L7mxW013916@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15332 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1KAVIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-co


The patch titled
     Subject: mm: compaction: make isolate_lru_page() filter-aware
has been removed from the -mm tree.  Its filename was
     mm-compaction-make-isolate_lru_page-filter-aware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Minchan Kim <minchan.kim@gmail.com>
Subject: mm: compaction: make isolate_lru_page() filter-aware

In async mode, compaction doesn't migrate dirty or writeback pages.  So,
it's meaningless to pick the page and re-add it to lru list.

Of course, when we isolate the page in compaction, the page might be dirty
or writeback but when we try to migrate the page, the page would be not
dirty, writeback.  So it could be migrated.  But it's very unlikely as
isolate and migration cycle is much faster than writeout.

So, this patch helps cpu overhead and prevent unnecessary LRU churning.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/compaction.c        |    7 +++++--
 mm/vmscan.c            |    3 +++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-compaction-make-isolate_lru_page-filter-aware include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-compaction-make-isolate_lru_page-filter-aware
+++ a/include/linux/mmzone.h
@@ -168,6 +168,8 @@ static inline int is_unevictable_lru(enu
 #define ISOLATE_INACTIVE	((__force isolate_mode_t)0x1)
 /* Isolate active pages */
 #define ISOLATE_ACTIVE		((__force isolate_mode_t)0x2)
+/* Isolate clean file */
+#define ISOLATE_CLEAN		((__force isolate_mode_t)0x4)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
diff -puN mm/compaction.c~mm-compaction-make-isolate_lru_page-filter-aware mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-isolate_lru_page-filter-aware
+++ a/mm/compaction.c
@@ -261,6 +261,7 @@ static isolate_migrate_t isolate_migrate
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
+	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
 
 	/* Do not scan outside zone boundaries */
 	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
@@ -348,9 +349,11 @@ static isolate_migrate_t isolate_migrate
 			continue;
 		}
 
+		if (!cc->sync)
+			mode |= ISOLATE_CLEAN;
+
 		/* Try isolate the page */
-		if (__isolate_lru_page(page,
-				ISOLATE_ACTIVE|ISOLATE_INACTIVE, 0) != 0)
+		if (__isolate_lru_page(page, mode, 0) != 0)
 			continue;
 
 		VM_BUG_ON(PageTransCompound(page));
diff -puN mm/vmscan.c~mm-compaction-make-isolate_lru_page-filter-aware mm/vmscan.c
--- a/mm/vmscan.c~mm-compaction-make-isolate_lru_page-filter-aware
+++ a/mm/vmscan.c
@@ -1045,6 +1045,9 @@ int __isolate_lru_page(struct page *page
 
 	ret = -EBUSY;
 
+	if ((mode & ISOLATE_CLEAN) && (PageDirty(page) || PageWriteback(page)))
+		return ret;
+
 	if (likely(get_page_unless_zero(page))) {
 		/*
 		 * Be careful not to clear PageLRU until after we're
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
thp-tail-page-refcounting-fix-5.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

