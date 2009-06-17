From: akpm@linux-foundation.org
Subject: [merged] vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:11 -0700
Message-ID: <200906171833.n5HIXBdS031772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758096AbZFQS4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:56:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, Minchan.kim@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: low order lumpy reclaim also should use PAGEOUT_IO_SYNC
has been removed from the -mm tree.  Its filename was
     vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: low order lumpy reclaim also should use PAGEOUT_IO_SYNC
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Commit 33c120ed2843090e2bd316de1588b8bf8b96cbde ("more aggressively use
lumpy reclaim") increased how aggressive lumpy reclaim was by isolating
both active and inactive pages for asynchronous lumpy reclaim on
costly-high-order pages and for cheap-high-order when memory pressure is
high.  However, if the system is under heavy pressure and there are dirty
pages, asynchronous IO may not be sufficient to reclaim a suitable page in
time.

This patch causes the caller to enter synchronous lumpy reclaim for
costly-high-order pages and for cheap-high-order pages when under memory
pressure.


Minchan.kim@gmail.com said:

Andy added synchronous lumpy reclaim with
c661b078fd62abe06fd11fab4ac5e4eeafe26b6d.  At that time, lumpy reclaim is
not agressive.  His intension is just for high-order users.(above
PAGE_ALLOC_COSTLY_ORDER).  

After some time, Rik added aggressive lumpy reclaim with
33c120ed2843090e2bd316de1588b8bf8b96cbde.  His intention was to do lumpy
reclaim when high-order users and trouble getting a small set of
contiguous pages.  

So we also have to add synchronous pageout for small set of contiguous
pages.

Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <Minchan.kim@gmail.com>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN mm/vmscan.c~vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync mm/vmscan.c
--- a/mm/vmscan.c~vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync
+++ a/mm/vmscan.c
@@ -1061,6 +1061,19 @@ static unsigned long shrink_inactive_lis
 	unsigned long nr_scanned = 0;
 	unsigned long nr_reclaimed = 0;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
+	int lumpy_reclaim = 0;
+
+	/*
+	 * If we need a large contiguous chunk of memory, or have
+	 * trouble getting a small set of contiguous pages, we
+	 * will reclaim both active and inactive pages.
+	 *
+	 * We use the same threshold as pageout congestion_wait below.
+	 */
+	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
+		lumpy_reclaim = 1;
+	else if (sc->order && priority < DEF_PRIORITY - 2)
+		lumpy_reclaim = 1;
 
 	pagevec_init(&pvec, 1);
 
@@ -1073,19 +1086,7 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_freed;
 		unsigned long nr_active;
 		unsigned int count[NR_LRU_LISTS] = { 0, };
-		int mode = ISOLATE_INACTIVE;
-
-		/*
-		 * If we need a large contiguous chunk of memory, or have
-		 * trouble getting a small set of contiguous pages, we
-		 * will reclaim both active and inactive pages.
-		 *
-		 * We use the same threshold as pageout congestion_wait below.
-		 */
-		if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
-			mode = ISOLATE_BOTH;
-		else if (sc->order && priority < DEF_PRIORITY - 2)
-			mode = ISOLATE_BOTH;
+		int mode = lumpy_reclaim ? ISOLATE_BOTH : ISOLATE_INACTIVE;
 
 		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
 			     &page_list, &nr_scan, sc->order, mode,
@@ -1122,7 +1123,7 @@ static unsigned long shrink_inactive_lis
 		 * but that should be acceptable to the caller
 		 */
 		if (nr_freed < nr_taken && !current_is_kswapd() &&
-					sc->order > PAGE_ALLOC_COSTLY_ORDER) {
+		    lumpy_reclaim) {
 			congestion_wait(WRITE, HZ/10);
 
 			/*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-update.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc-update-document-for-proc-softirqs-and-proc-stat-update.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
getrusage-fill-ru_maxrss-value.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

