From: akpm@linux-foundation.org
Subject: +
 mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
 added to -mm tree
Date: Fri, 21 Feb 2014 14:52:53 -0800
Message-ID: <5307d8c5.3GKdn/80Y5Jze14P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbaBUWwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 17:52:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com

Subject: + mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 14:52:53 -0800


The patch titled
     Subject: mm/compaction: do not call suitable_migration_target() on every page
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch

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
Subject: mm/compaction: do not call suitable_migration_target() on every page

suitable_migration_target() checks that pageblock is suitable for
migration target.  In isolate_freepages_block(), it is called on every
page and this is inefficient.  So make it called once per pageblock.

suitable_migration_target() also checks if page is highorder or not, but
it's criteria for highorder is pageblock order.  So calling it once within
pageblock range has no problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-do-not-call-suitable_migration_target-on-every-page mm/compaction.c
--- a/mm/compaction.c~mm-compaction-do-not-call-suitable_migration_target-on-every-page
+++ a/mm/compaction.c
@@ -245,6 +245,7 @@ static unsigned long isolate_freepages_b
 	unsigned long nr_strict_required = end_pfn - blockpfn;
 	unsigned long flags;
 	bool locked = false;
+	bool checked_pageblock = false;
 
 	cursor = pfn_to_page(blockpfn);
 
@@ -275,8 +276,16 @@ static unsigned long isolate_freepages_b
 			break;
 
 		/* Recheck this is a suitable migration target under lock */
-		if (!strict && !suitable_migration_target(page))
-			break;
+		if (!strict && !checked_pageblock) {
+			/*
+			 * We need to check suitability of pageblock only once
+			 * and this isolate_freepages_block() is called with
+			 * pageblock range, so just check once is sufficient.
+			 */
+			checked_pageblock = true;
+			if (!suitable_migration_target(page))
+				break;
+		}
 
 		/* Recheck this is a buddy page under lock */
 		if (!PageBuddy(page))
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

