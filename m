From: akpm@linux-foundation.org
Subject: +
 mm-compaction-disallow-high-order-page-for-migration-target.patch added to
 -mm tree
Date: Fri, 21 Feb 2014 14:52:52 -0800
Message-ID: <5307d8c4.+OmNShW/1+K8/HLZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbaBUWwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 17:52:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com

Subject: + mm-compaction-disallow-high-order-page-for-migration-target.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 14:52:52 -0800


The patch titled
     Subject: mm/compaction: disallow high-order page for migration target
has been added to the -mm tree.  Its filename is
     mm-compaction-disallow-high-order-page-for-migration-target.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-disallow-high-order-page-for-migration-target.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-disallow-high-order-page-for-migration-target.patch

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
Subject: mm/compaction: disallow high-order page for migration target

Purpose of compaction is to get a high order page.  Currently, if we find
high-order page while searching migration target page, we break it to
order-0 pages and use them as migration target.  It is contrary to purpose
of compaction, so disallow high-order page to be used for migration
target.

Additionally, clean-up logic in suitable_migration_target() to simplify
the code.  There is no functional changes from this clean-up.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN mm/compaction.c~mm-compaction-disallow-high-order-page-for-migration-target mm/compaction.c
--- a/mm/compaction.c~mm-compaction-disallow-high-order-page-for-migration-target
+++ a/mm/compaction.c
@@ -217,21 +217,12 @@ static inline bool compact_trylock_irqsa
 /* Returns true if the page is within a block suitable for migration to */
 static bool suitable_migration_target(struct page *page)
 {
-	int migratetype = get_pageblock_migratetype(page);
-
-	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
-	if (migratetype == MIGRATE_RESERVE)
-		return false;
-
-	if (is_migrate_isolate(migratetype))
-		return false;
-
-	/* If the page is a large free page, then allow migration */
+	/* If the page is a large free page, then disallow migration */
 	if (PageBuddy(page) && page_order(page) >= pageblock_order)
-		return true;
+		return false;
 
 	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
-	if (migrate_async_suitable(migratetype))
+	if (migrate_async_suitable(get_pageblock_migratetype(page)))
 		return true;
 
 	/* Otherwise skip the block */
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

