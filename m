From: akpm@linux-foundation.org
Subject: [merged] memcg-pin-execution-to-current-cpu-while-draining-stock.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:24 -0700
Message-ID: <201108261903.p7QJ38SA005657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab1HZTDv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     memcg: pin execution to current cpu while draining stock
has been removed from the -mm tree.  Its filename was
     memcg-pin-execution-to-current-cpu-while-draining-stock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: pin execution to current cpu while draining stock
From: Johannes Weiner <jweiner@redhat.com>

Commit d1a05b6 ("memcg do not try to drain per-cpu caches without pages")
added a drain_local_stock() call to a preemptible section.

The draining task looks up the cpu-local stock twice to set the
draining-flag, then to drain the stock and clear the flag again.  If the
task is migrated to a different CPU in between, noone will clear the flag
on the first stock and it will be forever undrainable.  Its charge can not
be recovered and the cgroup can not be deleted anymore.

Properly pin the task to the executing CPU while draining stocks.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-pin-execution-to-current-cpu-while-draining-stock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-pin-execution-to-current-cpu-while-draining-stock
+++ a/mm/memcontrol.c
@@ -2169,13 +2169,7 @@ static void drain_all_stock(struct mem_c
 
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
-	/*
-	 * Get a hint for avoiding draining charges on the current cpu,
-	 * which must be exhausted by our charging.  It is not required that
-	 * this be a precise check, so we use raw_smp_processor_id() instead of
-	 * getcpu()/putcpu().
-	 */
-	curcpu = raw_smp_processor_id();
+	curcpu = get_cpu();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *mem;
@@ -2192,6 +2186,7 @@ static void drain_all_stock(struct mem_c
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
+	put_cpu();
 
 	if (!sync)
 		goto out;
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
memcg-remove-unneeded-preempt_disable.patch

