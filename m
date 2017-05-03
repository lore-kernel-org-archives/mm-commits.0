From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch removed
 from -mm tree
Date: Wed, 03 May 2017 14:32:51 -0700
Message-ID: <590a4c83.YVgqBNLfBoY7E49g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdECVcw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:32:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, hillf.zj@alibaba-inc.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix 100% CPU kswapd busyloop on unreclaimable nodes fix
has been removed from the -mm tree.  Its filename was
     mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch

This patch was dropped because it was folded into mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: fix 100% CPU kswapd busyloop on unreclaimable nodes fix

Check kswapd failure against the cumulative nr_reclaimed count, not
against the count from the lowest priority iteration.

Link: http://lkml.kernel.org/r/20170306162410.GB2090@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jia He <hejianet@gmail.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix
+++ a/mm/vmscan.c
@@ -3223,9 +3223,9 @@ static int balance_pgdat(pg_data_t *pgda
 	count_vm_event(PAGEOUTRUN);
 
 	do {
+		unsigned long nr_reclaimed = sc.nr_reclaimed;
 		bool raise_priority = true;
 
-		sc.nr_reclaimed = 0;
 		sc.reclaim_idx = classzone_idx;
 
 		/*
@@ -3315,7 +3315,8 @@ static int balance_pgdat(pg_data_t *pgda
 		 * Raise priority if scanning rate is too low or there was no
 		 * progress in reclaiming pages
 		 */
-		if (raise_priority || !sc.nr_reclaimed)
+		nr_reclaimed = sc.nr_reclaimed - nr_reclaimed;
+		if (raise_priority || !nr_reclaimed)
 			sc.priority--;
 	} while (sc.priority >= 1);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch
mm-memcontrol-provide-shmem-statistics.patch
mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings.patch
mm-vmscan-fix-io-refault-regression-in-cache-workingset-transition.patch
mm-memcontrol-clean-up-memoryevents-counting-function.patch
mm-memcontrol-re-use-global-vm-event-enum.patch
mm-memcontrol-re-use-node-vm-page-state-enum.patch
mm-memcontrol-use-node-page-state-naming-scheme-for-memcg.patch

