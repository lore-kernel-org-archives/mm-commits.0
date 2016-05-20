From: akpm@linux-foundation.org
Subject: [patch 060/117] mm, compaction: skip blocks where isolation fails in async direct compaction
Date: Thu, 19 May 2016 17:11:55 -0700
Message-ID: <573e564b.nAcaFnQvg0mX+J8n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbcETAMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:12:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: skip blocks where isolation fails in async direct compaction

The goal of direct compaction is to quickly make a high-order page
available for the pending allocation.  Within an aligned block of pages of
desired order, a single allocated page that cannot be isolated for
migration means that the block cannot fully merge to a buddy page that
would satisfy the allocation request.  Therefore we can reduce the
allocation stall by skipping the rest of the block immediately on
isolation failure.  For async compaction, this also means a higher chance
of succeeding until it detects contention.

We however shouldn't completely sacrifice the second objective of
compaction, which is to reduce overal long-term memory fragmentation.  As
a compromise, perform the eager skipping only in direct async compaction,
while sync compaction (including kcompactd) remains thorough.

Testing was done using stress-highalloc from mmtests, configured for
order-4 GFP_KERNEL allocations:

                               4.6-rc1               4.6-rc1
                                before                 after
Success 1 Min         24.00 (  0.00%)       27.00 (-12.50%)
Success 1 Mean        30.20 (  0.00%)       31.60 ( -4.64%)
Success 1 Max         37.00 (  0.00%)       35.00 (  5.41%)
Success 2 Min         42.00 (  0.00%)       32.00 ( 23.81%)
Success 2 Mean        44.00 (  0.00%)       44.80 ( -1.82%)
Success 2 Max         48.00 (  0.00%)       52.00 ( -8.33%)
Success 3 Min         91.00 (  0.00%)       92.00 ( -1.10%)
Success 3 Mean        92.20 (  0.00%)       92.80 ( -0.65%)
Success 3 Max         94.00 (  0.00%)       93.00 (  1.06%)

We can see that success rates are unaffected by the skipping.

              4.6-rc1     4.6-rc1
               before       after
User         2587.42     2566.53
System        482.89      471.20
Elapsed      1395.68     1382.00

Times are not so useful metric for this benchmark as main portion is the
interfering kernel builds, but results do hint at reduced system times.

                                    4.6-rc1     4.6-rc1
                                     before       after
Direct pages scanned                163614      159608
Kswapd pages scanned               2070139     2078790
Kswapd pages reclaimed             2061707     2069757
Direct pages reclaimed              163354      159505

Reduced direct reclaim was unintended, but could be explained by more
successful first attempt at (async) direct compaction, which is 
attempted before the first reclaim attempt in __alloc_pages_slowpath().

Compaction stalls                    33052       39853
Compaction success                   12121       19773
Compaction failures                  20931       20079

Compaction is indeed more successful, and thus less likely to get
deferred, so there are also more direct compaction stalls.

Page migrate success               3781876     3326819
Page migrate failure                 45817       41774
Compaction pages isolated          7868232     6941457
Compaction migrate scanned       168160492   127269354
Compaction migrate prescanned            0           0
Compaction free scanned         2522142582  2326342620
Compaction free direct alloc             0           0
Compaction free dir. all. miss           0           0
Compaction cost                       5252        4476

The patch reduces migration scanned pages by 25% thanks to the eager
skipping.

[hughd@google.com: prevent nr_isolated_* from going negative]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   89 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 9 deletions(-)

diff -puN mm/compaction.c~mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction
+++ a/mm/compaction.c
@@ -638,12 +638,13 @@ isolate_migratepages_block(struct compac
 {
 	struct zone *zone = cc->zone;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
-	struct list_head *migratelist = &cc->migratepages;
 	struct lruvec *lruvec;
 	unsigned long flags = 0;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
 	unsigned long start_pfn = low_pfn;
+	bool skip_on_failure = false;
+	unsigned long next_skip_pfn = 0;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -664,10 +665,37 @@ isolate_migratepages_block(struct compac
 	if (compact_should_abort(cc))
 		return 0;
 
+	if (cc->direct_compaction && (cc->mode == MIGRATE_ASYNC)) {
+		skip_on_failure = true;
+		next_skip_pfn = block_end_pfn(low_pfn, cc->order);
+	}
+
 	/* Time to isolate some pages for migration */
 	for (; low_pfn < end_pfn; low_pfn++) {
 		bool is_lru;
 
+		if (skip_on_failure && low_pfn >= next_skip_pfn) {
+			/*
+			 * We have isolated all migration candidates in the
+			 * previous order-aligned block, and did not skip it due
+			 * to failure. We should migrate the pages now and
+			 * hopefully succeed compaction.
+			 */
+			if (nr_isolated)
+				break;
+
+			/*
+			 * We failed to isolate in the previous order-aligned
+			 * block. Set the new boundary to the end of the
+			 * current block. Note we can't simply increase
+			 * next_skip_pfn by 1 << order, as low_pfn might have
+			 * been incremented by a higher number due to skipping
+			 * a compound or a high-order buddy page in the
+			 * previous loop iteration.
+			 */
+			next_skip_pfn = block_end_pfn(low_pfn, cc->order);
+		}
+
 		/*
 		 * Periodically drop the lock (if held) regardless of its
 		 * contention, to give chance to IRQs. Abort async compaction
@@ -679,7 +707,7 @@ isolate_migratepages_block(struct compac
 			break;
 
 		if (!pfn_valid_within(low_pfn))
-			continue;
+			goto isolate_fail;
 		nr_scanned++;
 
 		page = pfn_to_page(low_pfn);
@@ -734,11 +762,11 @@ isolate_migratepages_block(struct compac
 			if (likely(comp_order < MAX_ORDER))
 				low_pfn += (1UL << comp_order) - 1;
 
-			continue;
+			goto isolate_fail;
 		}
 
 		if (!is_lru)
-			continue;
+			goto isolate_fail;
 
 		/*
 		 * Migration will fail if an anonymous page is pinned in memory,
@@ -747,7 +775,7 @@ isolate_migratepages_block(struct compac
 		 */
 		if (!page_mapping(page) &&
 		    page_count(page) > page_mapcount(page))
-			continue;
+			goto isolate_fail;
 
 		/* If we already hold the lock, we can skip some rechecking */
 		if (!locked) {
@@ -758,7 +786,7 @@ isolate_migratepages_block(struct compac
 
 			/* Recheck PageLRU and PageCompound under lock */
 			if (!PageLRU(page))
-				continue;
+				goto isolate_fail;
 
 			/*
 			 * Page become compound since the non-locked check,
@@ -767,7 +795,7 @@ isolate_migratepages_block(struct compac
 			 */
 			if (unlikely(PageCompound(page))) {
 				low_pfn += (1UL << compound_order(page)) - 1;
-				continue;
+				goto isolate_fail;
 			}
 		}
 
@@ -775,7 +803,7 @@ isolate_migratepages_block(struct compac
 
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, isolate_mode) != 0)
-			continue;
+			goto isolate_fail;
 
 		VM_BUG_ON_PAGE(PageCompound(page), page);
 
@@ -783,7 +811,7 @@ isolate_migratepages_block(struct compac
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 
 isolate_success:
-		list_add(&page->lru, migratelist);
+		list_add(&page->lru, &cc->migratepages);
 		cc->nr_migratepages++;
 		nr_isolated++;
 
@@ -801,6 +829,37 @@ isolate_success:
 			++low_pfn;
 			break;
 		}
+
+		continue;
+isolate_fail:
+		if (!skip_on_failure)
+			continue;
+
+		/*
+		 * We have isolated some pages, but then failed. Release them
+		 * instead of migrating, as we cannot form the cc->order buddy
+		 * page anyway.
+		 */
+		if (nr_isolated) {
+			if (locked) {
+				spin_unlock_irqrestore(&zone->lru_lock,	flags);
+				locked = false;
+			}
+			acct_isolated(zone, cc);
+			putback_movable_pages(&cc->migratepages);
+			cc->nr_migratepages = 0;
+			cc->last_migrated_pfn = 0;
+			nr_isolated = 0;
+		}
+
+		if (low_pfn < next_skip_pfn) {
+			low_pfn = next_skip_pfn - 1;
+			/*
+			 * The check near the loop beginning would have updated
+			 * next_skip_pfn too, but this is a bit simpler.
+			 */
+			next_skip_pfn += 1UL << cc->order;
+		}
 	}
 
 	/*
@@ -1401,6 +1460,18 @@ static int compact_zone(struct zone *zon
 				ret = COMPACT_CONTENDED;
 				goto out;
 			}
+			/*
+			 * We failed to migrate at least one page in the current
+			 * order-aligned block, so skip the rest of it.
+			 */
+			if (cc->direct_compaction &&
+						(cc->mode == MIGRATE_ASYNC)) {
+				cc->migrate_pfn = block_end_pfn(
+						cc->migrate_pfn - 1, cc->order);
+				/* Draining pcplists is useless in this case */
+				cc->last_migrated_pfn = 0;
+
+			}
 		}
 
 check_drain:
_
