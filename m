From: akpm@linux-foundation.org
Subject: [merged]
 mm-more-aggressive-page-stealing-for-unmovable-allocations.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:38:54 -0800
Message-ID: <54dd014e.YxWcBo+BYchM4wc4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbbBLTiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: more aggressive page stealing for UNMOVABLE allocations
has been removed from the -mm tree.  Its filename was
     mm-more-aggressive-page-stealing-for-unmovable-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
mm-fix-negative-nr_isolated-counts.patch
zram-fix-umount-reset_store-mount-race-condition.patch

