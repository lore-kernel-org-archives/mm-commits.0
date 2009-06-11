From: akpm@linux-foundation.org
Subject: + vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch added to -mm tree
Date: Thu, 11 Jun 2009 16:34:55 -0700
Message-ID: <200906112334.n5BNYtwq031448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757304AbZFKXff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 19:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscan: do not unconditionally treat zones that fail zone_reclaim() as full
has been added to the -mm tree.  Its filename is
     vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: do not unconditionally treat zones that fail zone_reclaim() as full
From: Mel Gorman <mel@csn.ul.ie>

On NUMA machines, the administrator can configure zone_reclaim_mode that
is a more targetted form of direct reclaim.  On machines with large NUMA
distances for example, a zone_reclaim_mode defaults to 1 meaning that
clean unmapped pages will be reclaimed if the zone watermarks are not
being met.  The problem is that zone_reclaim() failing at all means the
zone gets marked full.

This can cause situations where a zone is usable, but is being skipped
because it has been considered full.  Take a situation where a large tmpfs
mount is occuping a large percentage of memory overall.  The pages do not
get cleaned or reclaimed by zone_reclaim(), but the zone gets marked full
and the zonelist cache considers them not worth trying in the future.

This patch makes zone_reclaim() return more fine-grained information about
what occured when zone_reclaim() failued.  The zone only gets marked full
if it really is unreclaimable.  If it's a case that the scan did not occur
or if enough pages were not reclaimed with the limited reclaim_mode, then
the zone is simply skipped.

There is a side-effect to this patch.  Currently, if zone_reclaim()
successfully reclaimed SWAP_CLUSTER_MAX, an allocation attempt would go
ahead.  With this patch applied, zone watermarks are rechecked after
zone_reclaim() does some work.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 ++++
 mm/page_alloc.c |   26 ++++++++++++++++++++++----
 mm/vmscan.c     |   11 ++++++-----
 3 files changed, 32 insertions(+), 9 deletions(-)

diff -puN mm/internal.h~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full mm/internal.h
--- a/mm/internal.h~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full
+++ a/mm/internal.h
@@ -259,4 +259,8 @@ int __get_user_pages(struct task_struct 
 		     unsigned long start, int len, int flags,
 		     struct page **pages, struct vm_area_struct **vmas);
 
+#define ZONE_RECLAIM_NOSCAN	-2
+#define ZONE_RECLAIM_FULL	-1
+#define ZONE_RECLAIM_SOME	0
+#define ZONE_RECLAIM_SUCCESS	1
 #endif
diff -puN mm/page_alloc.c~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full
+++ a/mm/page_alloc.c
@@ -1477,15 +1477,33 @@ zonelist_scan:
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
 			unsigned long mark;
+			int ret;
+
 			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
-			if (!zone_watermark_ok(zone, order, mark,
-				    classzone_idx, alloc_flags)) {
-				if (!zone_reclaim_mode ||
-				    !zone_reclaim(zone, gfp_mask, order))
+			if (zone_watermark_ok(zone, order, mark,
+				    classzone_idx, alloc_flags))
+				goto try_this_zone;
+
+			if (zone_reclaim_mode == 0)
+				goto this_zone_full;
+
+			ret = zone_reclaim(zone, gfp_mask, order);
+			switch (ret) {
+			case ZONE_RECLAIM_NOSCAN:
+				/* did not scan */
+				goto try_next_zone;
+			case ZONE_RECLAIM_FULL:
+				/* scanned but unreclaimable */
+				goto this_zone_full;
+			default:
+				/* did we reclaim enough */
+				if (!zone_watermark_ok(zone, order, mark,
+						classzone_idx, alloc_flags))
 					goto this_zone_full;
 			}
 		}
 
+try_this_zone:
 		page = buffered_rmqueue(preferred_zone, zone, order,
 						gfp_mask, migratetype);
 		if (page)
diff -puN mm/vmscan.c~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full mm/vmscan.c
--- a/mm/vmscan.c~vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full
+++ a/mm/vmscan.c
@@ -2488,16 +2488,16 @@ int zone_reclaim(struct zone *zone, gfp_
 	 */
 	if (zone_pagecache_reclaimable(zone) <= zone->min_unmapped_pages &&
 	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
-		return 0;
+		return ZONE_RECLAIM_FULL;
 
 	if (zone_is_all_unreclaimable(zone))
-		return 0;
+		return ZONE_RECLAIM_FULL;
 
 	/*
 	 * Do not scan if the allocation should not be delayed.
 	 */
 	if (!(gfp_mask & __GFP_WAIT) || (current->flags & PF_MEMALLOC))
-			return 0;
+		return ZONE_RECLAIM_NOSCAN;
 
 	/*
 	 * Only run zone reclaim on the local zone or on zones that do not
@@ -2507,10 +2507,11 @@ int zone_reclaim(struct zone *zone, gfp_
 	 */
 	node_id = zone_to_nid(zone);
 	if (node_state(node_id, N_CPU) && node_id != numa_node_id())
-		return 0;
+		return ZONE_RECLAIM_NOSCAN;
 
 	if (zone_test_and_set_flag(zone, ZONE_RECLAIM_LOCKED))
-		return 0;
+		return ZONE_RECLAIM_NOSCAN;
+
 	ret = __zone_reclaim(zone, gfp_mask, order);
 	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch
oom-invoke-oom-killer-for-__gfp_nofail.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
add-debugging-aid-for-memory-initialisation-problems.patch

