From: akpm@linux-foundation.org
Subject: +
 mm-more-aggressive-page-stealing-for-unmovable-allocations.patch added to
 -mm tree
Date: Fri, 23 Jan 2015 14:54:57 -0800
Message-ID: <54c2d141.+CLITojiGiEWUZvW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbAWWy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jan 2015 17:54:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: more aggressive page stealing for UNMOVABLE allocations
has been added to the -mm tree.  Its filename is
     mm-more-aggressive-page-stealing-for-unmovable-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-more-aggressive-page-stealing-for-unmovable-allocations.patch

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
Subject: mm: more aggressive page stealing for UNMOVABLE allocations

When allocation falls back to stealing free pages of another migratetype,
it can decide to steal extra pages, or even the whole pageblock in order
to reduce fragmentation, which could happen if further allocation
fallbacks pick a different pageblock.  In try_to_steal_freepages(), one of
the situations where extra pages are stolen happens when we are trying to
allocate a MIGRATE_RECLAIMABLE page.

However, MIGRATE_UNMOVABLE allocations are not treated the same way,
although spreading such allocation over multiple fallback pageblocks is
arguably even worse than it is for RECLAIMABLE allocations.  To minimize
fragmentation, we should minimize the number of such fallbacks, and thus
steal as much as is possible from each fallback pageblock.

Note that in theory this might put more pressure on movable pageblocks and
cause movable allocations to steal back from unmovable pageblocks. 
However, movable allocations are not as aggressive with stealing, and do
not cause permanent fragmentation, so the tradeoff is reasonable, and
evaluation seems to support the change.

This patch thus adds a check for MIGRATE_UNMOVABLE to the decision to
steal extra free pages.  When evaluating with stress-highalloc from
mmtests, this has reduced the number of MIGRATE_UNMOVABLE fallbacks to
roughly 1/6.  The number of these fallbacks stealing from MIGRATE_MOVABLE
block is reduced to 1/3.  There was no observation of growing number of
unmovable pageblocks over time, and also not of increased movable
allocation fallbacks.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-more-aggressive-page-stealing-for-unmovable-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-more-aggressive-page-stealing-for-unmovable-allocations
+++ a/mm/page_alloc.c
@@ -1123,10 +1123,19 @@ static void change_pageblock_range(struc
 }
 
 /*
- * If breaking a large block of pages, move all free pages to the preferred
- * allocation list. If falling back for a reclaimable kernel allocation, be
- * more aggressive about taking ownership of free pages. If we claim more than
- * half of the pageblock, change pageblock's migratetype as well.
+ * When we are falling back to another migratetype during allocation, try to
+ * steal extra free pages from the same pageblocks to satisfy further
+ * allocations, instead of polluting multiple pageblocks.
+ *
+ * If we are stealing a relatively large buddy page, it is likely there will
+ * be more free pages in the pageblock, so try to steal them all. For
+ * reclaimable and unmovable allocations, we steal regardless of page size,
+ * as fragmentation caused by those allocations polluting movable pageblocks
+ * is worse than movable allocations stealing from unmovable and reclaimable
+ * pageblocks.
+ *
+ * If we claim more than half of the pageblock, change pageblock's migratetype
+ * as well.
  */
 static void try_to_steal_freepages(struct zone *zone, struct page *page,
 				  int start_type, int fallback_type)
@@ -1141,6 +1150,7 @@ static void try_to_steal_freepages(struc
 
 	if (current_order >= pageblock_order / 2 ||
 	    start_type == MIGRATE_RECLAIMABLE ||
+	    start_type == MIGRATE_UNMOVABLE ||
 	    page_group_by_mobility_disabled) {
 		int pages;
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-vmscan-fix-highidx-argument-type.patch
mm-dont-offset-memmap-for-flatmem.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch

