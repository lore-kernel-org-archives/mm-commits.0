From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:13 -0700
Message-ID: <20120531191713.6AA25A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:34813 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab2EaTRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:15 -0400
Received: by wibhn6 with SMTP id hn6so77010wib.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujtisu.com, mhocko@suse.cz, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: use vm_swappiness from target memory cgroup
has been removed from the -mm tree.  Its filename was
     mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/memcg: use vm_swappiness from target memory cgroup

Use vm_swappiness from memory cgroup which is triggered this memory
reclaim.  This is more reasonable and allows to kill one argument.

[akpm@linux-foundation.org: fix build (patch skew)]
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~mm-memcg-use-vm_swappiness-from-target-memory-cgroup mm/vmscan.c
--- a/mm/vmscan.c~mm-memcg-use-vm_swappiness-from-target-memory-cgroup
+++ a/mm/vmscan.c
@@ -1622,12 +1622,11 @@ static unsigned long shrink_list(enum lr
 	return shrink_inactive_list(nr_to_scan, mz, sc, priority, lru);
 }
 
-static int vmscan_swappiness(struct mem_cgroup_zone *mz,
-			     struct scan_control *sc)
+static int vmscan_swappiness(struct scan_control *sc)
 {
 	if (global_reclaim(sc))
 		return vm_swappiness;
-	return mem_cgroup_swappiness(mz->mem_cgroup);
+	return mem_cgroup_swappiness(sc->target_mem_cgroup);
 }
 
 /*
@@ -1695,8 +1694,8 @@ static void get_scan_count(struct mem_cg
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-	anon_prio = vmscan_swappiness(mz, sc);
-	file_prio = 200 - vmscan_swappiness(mz, sc);
+	anon_prio = vmscan_swappiness(sc);
+	file_prio = 200 - vmscan_swappiness(sc);
 
 	/*
 	 * OK, so we have swap space and a fair amount of page cache
@@ -1741,7 +1740,7 @@ out:
 		unsigned long scan;
 
 		scan = zone_nr_lru_pages(mz, lru);
-		if (priority || noswap || !vmscan_swappiness(mz, sc)) {
+		if (priority || noswap || !vmscan_swappiness(sc)) {
 			scan >>= priority;
 			if (!scan && force_scan)
 				scan = SWAP_CLUSTER_MAX;
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

