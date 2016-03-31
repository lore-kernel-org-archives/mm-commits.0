From: akpm@linux-foundation.org
Subject: +
 mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction.patch added to -mm tree
Date: Thu, 31 Mar 2016 15:10:11 -0700
Message-ID: <56fda043.JZd+WkC6EDwZ8JYb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbcCaWKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 18:10:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: skip blocks where isolation fails in async direct compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   84 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 77 insertions(+), 7 deletions(-)

diff -puN mm/compaction.c~mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction mm/compaction.c
--- a/mm/compaction.c~mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction
+++ a/mm/compaction.c
@@ -644,6 +644,8 @@ isolate_migratepages_block(struct compac
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
 	unsigned long start_pfn = low_pfn;
+	bool skip_on_failure = false;
+	unsigned long next_skip_pfn = 0;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -664,10 +666,37 @@ isolate_migratepages_block(struct compac
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
@@ -679,7 +708,7 @@ isolate_migratepages_block(struct compac
 			break;
 
 		if (!pfn_valid_within(low_pfn))
-			continue;
+			goto isolate_fail;
 		nr_scanned++;
 
 		page = pfn_to_page(low_pfn);
@@ -739,11 +768,11 @@ isolate_migratepages_block(struct compac
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
@@ -752,7 +781,7 @@ isolate_migratepages_block(struct compac
 		 */
 		if (!page_mapping(page) &&
 		    page_count(page) > page_mapcount(page))
-			continue;
+			goto isolate_fail;
 
 		/* If we already hold the lock, we can skip some rechecking */
 		if (!locked) {
@@ -763,7 +792,7 @@ isolate_migratepages_block(struct compac
 
 			/* Recheck PageLRU and PageCompound under lock */
 			if (!PageLRU(page))
-				continue;
+				goto isolate_fail;
 
 			/*
 			 * Page become compound since the non-locked check,
@@ -772,7 +801,7 @@ isolate_migratepages_block(struct compac
 			 */
 			if (unlikely(PageCompound(page))) {
 				low_pfn += (1UL << compound_order(page)) - 1;
-				continue;
+				goto isolate_fail;
 			}
 		}
 
@@ -780,7 +809,7 @@ isolate_migratepages_block(struct compac
 
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, isolate_mode) != 0)
-			continue;
+			goto isolate_fail;
 
 		VM_BUG_ON_PAGE(PageCompound(page), page);
 
@@ -806,6 +835,35 @@ isolate_success:
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
+			putback_movable_pages(migratelist);
+			nr_isolated = 0;
+			cc->last_migrated_pfn = 0;
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
@@ -1414,6 +1472,18 @@ static int compact_zone(struct zone *zon
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch
mm-compaction-reduce-spurious-pcplist-drains.patch
mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction.patch

