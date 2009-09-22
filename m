From: akpm@linux-foundation.org
Subject: [merged] mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:06 -0700
Message-ID: <200909222038.n8MKc6Hi000754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbZIVUit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, fengguang.wu@intel.com, minchan.kim@gmail.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: oom analysis: add per-zone statistics to show_free_areas()
has been removed from the -mm tree.  Its filename was
     mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: oom analysis: add per-zone statistics to show_free_areas()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

show_free_areas() displays only a limited amount of zone counters.  This
patch includes additional counters in the display to allow easier
debugging.  This may be especially useful if an OOM is due to running out
of DMA memory.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN mm/page_alloc.c~mm-oom-analysis-add-per-zone-statistics-to-show_free_areas mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-analysis-add-per-zone-statistics-to-show_free_areas
+++ a/mm/page_alloc.c
@@ -2170,6 +2170,16 @@ void show_free_areas(void)
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
 			" present:%lukB"
+			" mlocked:%lukB"
+			" dirty:%lukB"
+			" writeback:%lukB"
+			" mapped:%lukB"
+			" slab_reclaimable:%lukB"
+			" slab_unreclaimable:%lukB"
+			" pagetables:%lukB"
+			" unstable:%lukB"
+			" bounce:%lukB"
+			" writeback_tmp:%lukB"
 			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
 			"\n",
@@ -2184,6 +2194,16 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_UNEVICTABLE)),
 			K(zone->present_pages),
+			K(zone_page_state(zone, NR_MLOCK)),
+			K(zone_page_state(zone, NR_FILE_DIRTY)),
+			K(zone_page_state(zone, NR_WRITEBACK)),
+			K(zone_page_state(zone, NR_FILE_MAPPED)),
+			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
+			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
+			K(zone_page_state(zone, NR_PAGETABLE)),
+			K(zone_page_state(zone, NR_UNSTABLE_NFS)),
+			K(zone_page_state(zone, NR_BOUNCE)),
+			K(zone_page_state(zone, NR_WRITEBACK_TEMP)),
 			zone->pages_scanned,
 			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
 			);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
readahead-add-blk_run_backing_dev.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct-fix.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
getrusage-fill-ru_maxrss-value.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

