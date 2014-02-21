From: akpm@linux-foundation.org
Subject: +
 mm-compaction-check-pageblock-suitability-once-per-pageblock.patch added to -mm tree
Date: Fri, 21 Feb 2014 14:52:55 -0800
Message-ID: <5307d8c7.6mq8osT5pl85j179%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbaBUWw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 17:52:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com

Subject: + mm-compaction-check-pageblock-suitability-once-per-pageblock.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 14:52:55 -0800


The patch titled
     Subject: mm/compaction: check pageblock suitability once per pageblock
has been added to the -mm tree.  Its filename is
     mm-compaction-check-pageblock-suitability-once-per-pageblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-check-pageblock-suitability-once-per-pageblock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: check pageblock suitability once per pageblock

isolation_suitable() and migrate_async_suitable() is used to be sure that
this pageblock range is fine to be migragted.  It isn't needed to call it
on every page.  Current code do well if not suitable, but, don't do well
when suitable.

1) It re-checks isolation_suitable() on each page of a pageblock that was
   already estabilished as suitable.
2) It re-checks migrate_async_suitable() on each page of a pageblock that
   was not entered through the next_pageblock: label, because
   last_pageblock_nr is not otherwise updated.

This patch fixes situation by 1) calling isolation_suitable() only once
per pageblock and 2) always updating last_pageblock_nr to the pageblock
that was just checked.

Additionally, move PageBuddy() check after pageblock unit check, since
pageblock check is the first thing we should do and makes things more
simple.

[vbabka@suse.cz: rephrase commit description]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff -puN mm/compaction.c~mm-compaction-check-pageblock-suitability-once-per-pageblock mm/compaction.c
--- a/mm/compaction.c~mm-compaction-check-pageblock-suitability-once-per-pageblock
+++ a/mm/compaction.c
@@ -520,8 +520,25 @@ isolate_migratepages_range(struct zone *
 
 		/* If isolation recently failed, do not retry */
 		pageblock_nr = low_pfn >> pageblock_order;
-		if (!isolation_suitable(cc, page))
-			goto next_pageblock;
+		if (last_pageblock_nr != pageblock_nr) {
+			int mt;
+
+			last_pageblock_nr = pageblock_nr;
+			if (!isolation_suitable(cc, page))
+				goto next_pageblock;
+
+			/*
+			 * For async migration, also only scan in MOVABLE
+			 * blocks. Async migration is optimistic to see if
+			 * the minimum amount of work satisfies the allocation
+			 */
+			mt = get_pageblock_migratetype(page);
+			if (!cc->sync && !migrate_async_suitable(mt)) {
+				cc->finished_update_migrate = true;
+				skipped_async_unsuitable = true;
+				goto next_pageblock;
+			}
+		}
 
 		/*
 		 * Skip if free. page_order cannot be used without zone->lock
@@ -531,18 +548,6 @@ isolate_migratepages_range(struct zone *
 			continue;
 
 		/*
-		 * For async migration, also only scan in MOVABLE blocks. Async
-		 * migration is optimistic to see if the minimum amount of work
-		 * satisfies the allocation
-		 */
-		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
-		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
-			cc->finished_update_migrate = true;
-			skipped_async_unsuitable = true;
-			goto next_pageblock;
-		}
-
-		/*
 		 * Check may be lockless but that's ok as we recheck later.
 		 * It's possible to migrate LRU pages and balloon pages
 		 * Skip any other type of page
@@ -633,7 +638,6 @@ check_compact_cluster:
 
 next_pageblock:
 		low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
-		last_pageblock_nr = pageblock_nr;
 	}
 
 	acct_isolated(zone, locked, cc);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

kthread-ensure-locality-of-task_struct-allocations.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch

