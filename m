From: akpm@linux-foundation.org
Subject: + vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch added to -mm tree
Date: Thu, 11 Jun 2009 16:34:57 -0700
Message-ID: <200906112334.n5BNYwG4031481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759699AbZFKXfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 19:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     vmscan: count the number of times zone_reclaim() scans and fails
has been added to the -mm tree.  Its filename is
     vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch

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
Subject: vmscan: count the number of times zone_reclaim() scans and fails
From: Mel Gorman <mel@csn.ul.ie>

On NUMA machines, the administrator can configure zone_reclaim_mode that
is a more targetted form of direct reclaim.  On machines with large NUMA
distances for example, a zone_reclaim_mode defaults to 1 meaning that
clean unmapped pages will be reclaimed if the zone watermarks are not
being met.

There is a heuristic that determines if the scan is worthwhile but it is
possible that the heuristic will fail and the CPU gets tied up scanning
uselessly.  Detecting the situation requires some guesswork and
experimentation so this patch adds a counter "zreclaim_failed" to
/proc/vmstat.  If during high CPU utilisation this counter is increasing
rapidly, then the resolution to the problem may be to set
/proc/sys/vm/zone_reclaim_mode to 0.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    3 +++
 mm/vmscan.c            |    3 +++
 mm/vmstat.c            |    3 +++
 3 files changed, 9 insertions(+)

diff -puN include/linux/vmstat.h~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails
+++ a/include/linux/vmstat.h
@@ -36,6 +36,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSTEAL),
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
+#ifdef CONFIG_NUMA
+		PGSCAN_ZONERECLAIM_FAILED,
+#endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 #ifdef CONFIG_HUGETLB_PAGE
diff -puN mm/vmscan.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails mm/vmscan.c
--- a/mm/vmscan.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails
+++ a/mm/vmscan.c
@@ -2515,6 +2515,9 @@ int zone_reclaim(struct zone *zone, gfp_
 	ret = __zone_reclaim(zone, gfp_mask, order);
 	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
 
+	if (!ret)
+		count_vm_event(PGSCAN_ZONERECLAIM_FAILED);
+
 	return ret;
 }
 #endif
diff -puN mm/vmstat.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails mm/vmstat.c
--- a/mm/vmstat.c~vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails
+++ a/mm/vmstat.c
@@ -673,6 +673,9 @@ static const char * const vmstat_text[] 
 	TEXTS_FOR_ZONES("pgscan_kswapd")
 	TEXTS_FOR_ZONES("pgscan_direct")
 
+#ifdef CONFIG_NUMA
+	"zreclaim_failed",
+#endif
 	"pginodesteal",
 	"slabs_scanned",
 	"kswapd_steal",
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

