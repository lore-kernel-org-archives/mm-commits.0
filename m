From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-trivial-clean-up-in-acct_isolated.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:07:36 -0700
Message-ID: <201111012107.pA1L7a62002940@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15308 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1KAVId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-co


The patch titled
     Subject: mm: compaction: trivial clean up in acct_isolated()
has been removed from the -mm tree.  Its filename was
     mm-compaction-trivial-clean-up-in-acct_isolated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Minchan Kim <minchan.kim@gmail.com>
Subject: mm: compaction: trivial clean up in acct_isolated()

acct_isolated of compaction uses page_lru_base_type which returns only
base type of LRU list so it never returns LRU_ACTIVE_ANON or
LRU_ACTIVE_FILE.  In addtion, cc->nr_[anon|file] is used in only
acct_isolated so it doesn't have fields in conpact_control.

This patch removes fields from compact_control and makes clear function of
acct_issolated which counts the number of anon|file pages isolated.

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

 mm/compaction.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN mm/compaction.c~mm-compaction-trivial-clean-up-in-acct_isolated mm/compaction.c
--- a/mm/compaction.c~mm-compaction-trivial-clean-up-in-acct_isolated
+++ a/mm/compaction.c
@@ -35,10 +35,6 @@ struct compact_control {
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
 
-	/* Account for isolated anon and file pages */
-	unsigned long nr_anon;
-	unsigned long nr_file;
-
 	unsigned int order;		/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
@@ -223,17 +219,13 @@ static void isolate_freepages(struct zon
 static void acct_isolated(struct zone *zone, struct compact_control *cc)
 {
 	struct page *page;
-	unsigned int count[NR_LRU_LISTS] = { 0, };
+	unsigned int count[2] = { 0, };
 
-	list_for_each_entry(page, &cc->migratepages, lru) {
-		int lru = page_lru_base_type(page);
-		count[lru]++;
-	}
+	list_for_each_entry(page, &cc->migratepages, lru)
+		count[!!page_is_file_cache(page)]++;
 
-	cc->nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
-	cc->nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, cc->nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, cc->nr_file);
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, count[0]);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);
 }
 
 /* Similar to reclaim, but different enough that they don't share logic */
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
thp-tail-page-refcounting-fix-5.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch

