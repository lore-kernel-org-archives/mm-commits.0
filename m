From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-always-update-cached-scanner-positions.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:56:43 -0800
Message-ID: <5489e8eb.4Gbk2BROXfvwCSNP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbaLKS4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: always update cached scanner positions
has been removed from the -mm tree.  Its filename was
     mm-compaction-always-update-cached-scanner-positions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: always update cached scanner positions

Compaction caches the migration and free scanner positions between
compaction invocations, so that the whole zone gets eventually scanned and
there is no bias towards the initial scanner positions at the
beginning/end of the zone.

The cached positions are continuously updated as scanners progress and the
updating stops as soon as a page is successfully isolated.  The reasoning
behind this is that a pageblock where isolation succeeded is likely to
succeed again in near future and it should be worth revisiting it.

However, the downside is that potentially many pages are rescanned without
successful isolation.  At worst, there might be a page where isolation
from LRU succeeds but migration fails (potentially always).  So upon
encountering this page, cached position would always stop being updated
for no good reason.  It might have been useful to let such page be
rescanned with sync compaction after async one failed, but this is now
handled by caching scanner position for async and sync mode separately
since commit 35979ef33931 ("mm, compaction: add per-zone migration pfn
cache for async compaction").

After this patch, cached positions are updated unconditionally.  In
stress-highalloc benchmark, this has decreased the numbers of scanned
pages by few percent, without affecting allocation success rates.

To prevent free scanner from leaving free pages behind after they are
returned due to page migration failure, the cached scanner pfn is changed
to point to the pageblock of the returned free page with the highest pfn,
before leaving compact_zone().

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   43 +++++++++++++++++++++++--------------------
 mm/internal.h   |    5 -----
 2 files changed, 23 insertions(+), 25 deletions(-)

diff -puN mm/compaction.c~mm-compaction-always-update-cached-scanner-positions mm/compaction.c
--- a/mm/compaction.c~mm-compaction-always-update-cached-scanner-positions
+++ a/mm/compaction.c
@@ -41,15 +41,17 @@ static inline void count_compact_events(
 static unsigned long release_freepages(struct list_head *freelist)
 {
 	struct page *page, *next;
-	unsigned long count = 0;
+	unsigned long high_pfn = 0;
 
 	list_for_each_entry_safe(page, next, freelist, lru) {
+		unsigned long pfn = page_to_pfn(page);
 		list_del(&page->lru);
 		__free_page(page);
-		count++;
+		if (pfn > high_pfn)
+			high_pfn = pfn;
 	}
 
-	return count;
+	return high_pfn;
 }
 
 static void map_pages(struct list_head *list)
@@ -195,16 +197,12 @@ static void update_pageblock_skip(struct
 
 	/* Update where async and sync compaction should restart */
 	if (migrate_scanner) {
-		if (cc->finished_update_migrate)
-			return;
 		if (pfn > zone->compact_cached_migrate_pfn[0])
 			zone->compact_cached_migrate_pfn[0] = pfn;
 		if (cc->mode != MIGRATE_ASYNC &&
 		    pfn > zone->compact_cached_migrate_pfn[1])
 			zone->compact_cached_migrate_pfn[1] = pfn;
 	} else {
-		if (cc->finished_update_free)
-			return;
 		if (pfn < zone->compact_cached_free_pfn)
 			zone->compact_cached_free_pfn = pfn;
 	}
@@ -715,7 +713,6 @@ isolate_migratepages_block(struct compac
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 
 isolate_success:
-		cc->finished_update_migrate = true;
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
 		nr_isolated++;
@@ -889,15 +886,6 @@ static void isolate_freepages(struct com
 				block_start_pfn - pageblock_nr_pages;
 
 		/*
-		 * Set a flag that we successfully isolated in this pageblock.
-		 * In the next loop iteration, zone->compact_cached_free_pfn
-		 * will not be updated and thus it will effectively contain the
-		 * highest pageblock we isolated pages from.
-		 */
-		if (isolated)
-			cc->finished_update_free = true;
-
-		/*
 		 * isolate_freepages_block() might have aborted due to async
 		 * compaction being contended
 		 */
@@ -1251,9 +1239,24 @@ static int compact_zone(struct zone *zon
 	}
 
 out:
-	/* Release free pages and check accounting */
-	cc->nr_freepages -= release_freepages(&cc->freepages);
-	VM_BUG_ON(cc->nr_freepages != 0);
+	/*
+	 * Release free pages and update where the free scanner should restart,
+	 * so we don't leave any returned pages behind in the next attempt.
+	 */
+	if (cc->nr_freepages > 0) {
+		unsigned long free_pfn = release_freepages(&cc->freepages);
+
+		cc->nr_freepages = 0;
+		VM_BUG_ON(free_pfn == 0);
+		/* The cached pfn is always the first in a pageblock */
+		free_pfn &= ~(pageblock_nr_pages-1);
+		/*
+		 * Only go back, not forward. The cached pfn might have been
+		 * already reset to zone end in compact_finished()
+		 */
+		if (free_pfn > zone->compact_cached_free_pfn)
+			zone->compact_cached_free_pfn = free_pfn;
+	}
 
 	trace_mm_compaction_end(ret);
 
diff -puN mm/internal.h~mm-compaction-always-update-cached-scanner-positions mm/internal.h
--- a/mm/internal.h~mm-compaction-always-update-cached-scanner-positions
+++ a/mm/internal.h
@@ -161,11 +161,6 @@ struct compact_control {
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
-	bool finished_update_free;	/* True when the zone cached pfns are
-					 * no longer being updated
-					 */
-	bool finished_update_migrate;
