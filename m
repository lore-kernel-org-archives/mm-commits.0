From: akpm@linux-foundation.org
Subject: +
 mm-compaction-fix-nr_isolated_-stats-for-pfn-based-migration.patch added to -mm tree
Date: Thu, 20 Oct 2016 20:16:52 -0700
Message-ID: <580988a4.pSHsC9b8M7lbjW/Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39641 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753047AbcJUDQx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2016 23:16:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ming.ling@spreadtrum.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: fix NR_ISOLATED_* stats for pfn based migration
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-nr_isolated_-stats-for-pfn-based-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-fix-nr_isolated_-stats-for-pfn-based-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-fix-nr_isolated_-stats-for-pfn-based-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Ling <ming.ling@spreadtrum.com>
Subject: mm, compaction: fix NR_ISOLATED_* stats for pfn based migration

Since bda807d44454 ("mm: migrate: support non-lru movable page migration")
isolate_migratepages_block) can isolate !PageLRU pages which would
acct_isolated account as NR_ISOLATED_*.  Accounting these non-lru pages
NR_ISOLATED_{ANON,FILE} doesn't make any sense and it can misguide
heuristics based on those counters such as pgdat_reclaimable_pages resp. 
too_many_isolated which would lead to unexpected stalls during the direct
reclaim without any good reason.  Note that __alloc_contig_migrate_range
can isolate a lot of pages at once.

On mobile devices such as 512M ram android Phone, it may use a big zram
swap.  In some cases zram(zsmalloc) uses too many non-lru but migratedable
pages, such as:

      MemTotal: 468148 kB
      Normal free:5620kB
      Free swap:4736kB
      Total swap:409596kB
      ZRAM: 164616kB(zsmalloc non-lru pages)
      active_anon:60700kB
      inactive_anon:60744kB
      active_file:34420kB
      inactive_file:37532kB

Fix this by only accounting lru pages to NR_ISOLATED_* in
isolate_migratepages_block right after they were isolated and we still
know they were on LRU.  Drop acct_isolated because it is called after the
fact and we've lost that information.  Batching per-cpu counter doesn't
make much improvement anyway.  Also make sure that we uncharge only LRU
pages when putting them back on the LRU in putback_movable_pages resp. 
when unmap_and_move migrates the page.

Fixes: bda807d44454 ("mm: migrate: support non-lru movable page migration")
Link: http://lkml.kernel.org/r/20161019080240.9682-1-mhocko@kernel.org
Signed-off-by: Ming Ling <ming.ling@spreadtrum.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   25 +++----------------------
 mm/migrate.c    |   15 +++++++++++----
 2 files changed, 14 insertions(+), 26 deletions(-)

diff -puN mm/compaction.c~mm-compaction-fix-nr_isolated_-stats-for-pfn-based-migration mm/compaction.c
--- a/mm/compaction.c~mm-compaction-fix-nr_isolated_-stats-for-pfn-based-migration
+++ a/mm/compaction.c
@@ -634,22 +634,6 @@ isolate_freepages_range(struct compact_c
 	return pfn;
 }
 
-/* Update the number of anon and file isolated pages in the zone */
-static void acct_isolated(struct zone *zone, struct compact_control *cc)
-{
-	struct page *page;
-	unsigned int count[2] = { 0, };
-
-	if (list_empty(&cc->migratepages))
-		return;
-
-	list_for_each_entry(page, &cc->migratepages, lru)
-		count[!!page_is_file_cache(page)]++;
-
-	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_ANON, count[0]);
-	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, count[1]);
-}
-
 /* Similar to reclaim, but different enough that they don't share logic */
 static bool too_many_isolated(struct zone *zone)
 {
@@ -866,6 +850,8 @@ isolate_migratepages_block(struct compac
 
 		/* Successfully isolated */
 		del_page_from_lru_list(page, lruvec, page_lru(page));
+		inc_node_page_state(page,
+				NR_ISOLATED_ANON + page_is_file_cache(page));
 
 isolate_success:
 		list_add(&page->lru, &cc->migratepages);
@@ -902,7 +888,6 @@ isolate_fail:
 				spin_unlock_irqrestore(zone_lru_lock(zone), flags);
 				locked = false;
 			}
-			acct_isolated(zone, cc);
 			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
 			cc->last_migrated_pfn = 0;
@@ -988,7 +973,6 @@ isolate_migratepages_range(struct compac
 		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
 			break;
 	}
-	acct_isolated(cc->zone, cc);
 
 	return pfn;
 }
@@ -1258,10 +1242,8 @@ static isolate_migrate_t isolate_migrate
 		low_pfn = isolate_migratepages_block(cc, low_pfn,
 						block_end_pfn, isolate_mode);
 
-		if (!low_pfn || cc->contended) {
-			acct_isolated(zone, cc);
+		if (!low_pfn || cc->contended)
 			return ISOLATE_ABORT;
-		}
 
 		/*
 		 * Either we isolated something and proceed with migration. Or
@@ -1271,7 +1253,6 @@ static isolate_migrate_t isolate_migrate
 		break;
 	}
 
-	acct_isolated(zone, cc);
 	/* Record where migration scanner will be restarted. */
 	cc->migrate_pfn = low_pfn;
 
diff -puN mm/migrate.c~mm-compaction-fix-nr_isolated_-stats-for-pfn-based-migration mm/migrate.c
--- a/mm/migrate.c~mm-compaction-fix-nr_isolated_-stats-for-pfn-based-migration
+++ a/mm/migrate.c
@@ -168,8 +168,6 @@ void putback_movable_pages(struct list_h
 			continue;
 		}
 		list_del(&page->lru);
-		dec_node_page_state(page, NR_ISOLATED_ANON +
-				page_is_file_cache(page));
 		/*
 		 * We isolated non-lru movable page so here we can use
 		 * __PageMovable because LRU page's mapping cannot have
@@ -186,6 +184,8 @@ void putback_movable_pages(struct list_h
 			put_page(page);
 		} else {
 			putback_lru_page(page);
+			dec_node_page_state(page, NR_ISOLATED_ANON +
+					page_is_file_cache(page));
 		}
 	}
 }
@@ -1121,8 +1121,15 @@ out:
 		 * restored.
 		 */
 		list_del(&page->lru);
-		dec_node_page_state(page, NR_ISOLATED_ANON +
-				page_is_file_cache(page));
+
+		/*
+		 * Compaction can migrate also non-LRU pages which are
+		 * not accounted to NR_ISOLATED_*. They can be recognized
+		 * as __PageMovable
+		 */
+		if (likely(!__PageMovable(page)))
+			dec_node_page_state(page, NR_ISOLATED_ANON +
+					page_is_file_cache(page));
 	}
 
 	/*
_

Patches currently in -mm which might be from ming.ling@spreadtrum.com are

mm-compaction-fix-nr_isolated_-stats-for-pfn-based-migration.patch

