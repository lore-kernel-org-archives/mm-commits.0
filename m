From: akpm@linux-foundation.org
Subject: + vmscan-improve-reclaim-throughput-to-bail-out-patch.patch added to -mm tree
Date: Sat, 06 Dec 2008 19:28:20 -0800
Message-ID: <200812070328.mB73SK2N012754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046AbYLGD2m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 22:28:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     vmscan: improve reclaim throughput to bail out patch
has been added to the -mm tree.  Its filename is
     vmscan-improve-reclaim-throughput-to-bail-out-patch.patch

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
Subject: vmscan: improve reclaim throughput to bail out patch
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The vmscan bail out patch move nr_reclaimed variable to struct
scan_control.  Unfortunately, indirect access can easily happen cache
miss.

if heavy memory pressure happend, that's ok.
cache miss already plenty. it is not observable.

but, if memory pressure is lite, performance degression is obserbable.

I compared following three pattern (it was mesured 10 times each)

hackbench 125 process 3000
hackbench 130 process 3000
hackbench 135 process 3000

            2.6.28-rc6                       bail-out

	125	130	135		125	130	135
      ==============================================================
	71.866	75.86	81.274		93.414	73.254	193.382
	74.145	78.295	77.27		74.897	75.021	80.17
	70.305	77.643	75.855		70.134	77.571	79.896
	74.288	73.986	75.955		77.222	78.48	80.619
	72.029	79.947	78.312		75.128	82.172	79.708
	71.499	77.615	77.042		74.177	76.532	77.306
	76.188	74.471	83.562		73.839	72.43	79.833
	73.236	75.606	78.743		76.001	76.557	82.726
	69.427	77.271	76.691		76.236	79.371	103.189
	72.473	76.978	80.643		69.128	78.932	75.736

avg	72.545	76.767	78.534		76.017	77.03	93.256
std	1.89	1.71	2.41		6.29	2.79	34.16
min	69.427	73.986	75.855		69.128	72.43	75.736
max	76.188	79.947	83.562		93.414	82.172	193.382

about 4-5% degression.

Then, this patch introduces a temporary local variable.

result:

            2.6.28-rc6                       this patch

num	125	130	135		125	130	135
      ==============================================================
	71.866	75.86	81.274		67.302	68.269	77.161
	74.145	78.295	77.27   	72.616	72.712	79.06
	70.305	77.643	75.855  	72.475	75.712	77.735
	74.288	73.986	75.955  	69.229	73.062	78.814
	72.029	79.947	78.312  	71.551	74.392	78.564
	71.499	77.615	77.042  	69.227	74.31	78.837
	76.188	74.471	83.562  	70.759	75.256	76.6
	73.236	75.606	78.743  	69.966	76.001	78.464
	69.427	77.271	76.691  	69.068	75.218	80.321
	72.473	76.978	80.643  	72.057	77.151	79.068

avg	72.545	76.767	78.534 		70.425	74.2083	78.462
std 	1.89	1.71	2.41    	1.66	2.34	1.00
min 	69.427	73.986	75.855  	67.302	68.269	76.6
max 	76.188	79.947	83.562  	72.616	77.151	80.321

OK. the degression is disappeared.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~vmscan-improve-reclaim-throughput-to-bail-out-patch mm/vmscan.c
--- a/mm/vmscan.c~vmscan-improve-reclaim-throughput-to-bail-out-patch
+++ a/mm/vmscan.c
@@ -1457,6 +1457,8 @@ static void shrink_zone(int priority, st
 	unsigned long nr_to_scan;
 	unsigned long percent[2];	/* anon @ 0; file @ 1 */
 	enum lru_list l;
+	unsigned long nr_reclaimed = sc->nr_reclaimed;
+	unsigned long swap_cluster_max = sc->swap_cluster_max;
 
 	get_scan_ratio(zone, sc, percent);
 
@@ -1472,7 +1474,7 @@ static void shrink_zone(int priority, st
 			}
 			zone->lru[l].nr_scan += scan;
 			nr[l] = zone->lru[l].nr_scan;
-			if (nr[l] >= sc->swap_cluster_max)
+			if (nr[l] >= swap_cluster_max)
 				zone->lru[l].nr_scan = 0;
 			else
 				nr[l] = 0;
@@ -1491,12 +1493,11 @@ static void shrink_zone(int priority, st
 					nr[LRU_INACTIVE_FILE]) {
 		for_each_evictable_lru(l) {
 			if (nr[l]) {
-				nr_to_scan = min(nr[l],
-					(unsigned long)sc->swap_cluster_max);
+				nr_to_scan = min(nr[l], swap_cluster_max);
 				nr[l] -= nr_to_scan;
 
-				sc->nr_reclaimed += shrink_list(l, nr_to_scan,
-							zone, sc, priority);
+				nr_reclaimed += shrink_list(l, nr_to_scan,
+							    zone, sc, priority);
 			}
 		}
 		/*
@@ -1507,11 +1508,13 @@ static void shrink_zone(int priority, st
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (sc->nr_reclaimed > sc->swap_cluster_max &&
+		if (nr_reclaimed > swap_cluster_max &&
 			priority < DEF_PRIORITY && !current_is_kswapd())
 			break;
 	}
 
+	sc->nr_reclaimed = nr_reclaimed;
+
 	/*
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
arch-ia64-kernel-iosapicc-fix-warnings.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
vmscan-improve-reclaim-throughput-to-bail-out-patch.patch
mm-kill-zone_is_near_oom.patch
mm-make-get_user_pages-interruptible.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch

