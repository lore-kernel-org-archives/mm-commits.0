From: akpm@linux-foundation.org
Subject: + vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch added to -mm tree
Date: Wed, 22 Apr 2009 18:44:13 -0700
Message-ID: <200904230144.n3N1iDJI002043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbZDWBt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 21:49:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, Minchan.kim@gmail.com, a.p.zijlstra@chello.nl, apw@shadowen.org, mel@csn.ul.ie, riel@redhat.com


The patch titled
     vmscan: low order lumpy reclaim also should use PAGEOUT_IO_SYNC
has been added to the -mm tree.  Its filename is
     vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch

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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
@@ -1059,6 +1059,19 @@ static unsigned long shrink_inactive_lis
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
 
@@ -1071,19 +1084,7 @@ static unsigned long shrink_inactive_lis
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
@@ -1120,7 +1121,7 @@ static unsigned long shrink_inactive_lis
 		 * but that should be acceptable to the caller
 		 */
 		if (nr_freed < nr_taken && !current_is_kswapd() &&
-					sc->order > PAGE_ALLOC_COSTLY_ORDER) {
+		    lumpy_reclaim) {
 			congestion_wait(WRITE, HZ/10);
 
 			/*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_shrink_usage.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-add-file-based-rss-accounting.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

