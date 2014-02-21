From: akpm@linux-foundation.org
Subject: +
 mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch added to
 -mm tree
Date: Fri, 21 Feb 2014 14:52:56 -0800
Message-ID: <5307d8c8.6cxRRgjxG6Y8cNME%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbaBUWw5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 17:52:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com

Subject: + mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 14:52:56 -0800


The patch titled
     Subject: mm/compaction: clean-up code on success of ballon isolation
has been added to the -mm tree.  Its filename is
     mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch

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
Subject: mm/compaction: clean-up code on success of ballon isolation

It is just for clean-up to reduce code size and improve readability. 
There is no functional change.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN mm/compaction.c~mm-compaction-clean-up-code-on-success-of-ballon-isolation mm/compaction.c
--- a/mm/compaction.c~mm-compaction-clean-up-code-on-success-of-ballon-isolation
+++ a/mm/compaction.c
@@ -556,11 +556,7 @@ isolate_migratepages_range(struct zone *
 			if (unlikely(balloon_page_movable(page))) {
 				if (locked && balloon_page_isolate(page)) {
 					/* Successfully isolated */
-					cc->finished_update_migrate = true;
-					list_add(&page->lru, migratelist);
-					cc->nr_migratepages++;
-					nr_isolated++;
-					goto check_compact_cluster;
+					goto isolate_success;
 				}
 			}
 			continue;
@@ -621,13 +617,14 @@ isolate_migratepages_range(struct zone *
 		VM_BUG_ON_PAGE(PageTransCompound(page), page);
 
 		/* Successfully isolated */
-		cc->finished_update_migrate = true;
 		del_page_from_lru_list(page, lruvec, page_lru(page));
+
+isolate_success:
+		cc->finished_update_migrate = true;
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
 		nr_isolated++;
 
-check_compact_cluster:
 		/* Avoid isolating too much */
 		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX) {
 			++low_pfn;
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

