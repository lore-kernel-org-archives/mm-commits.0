From: akpm@linux-foundation.org
Subject: [folded] mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:23:20 -0800
Message-ID: <201101132323.p0DNNKFl006848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab1AMXXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:23:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     set_pgdat_percpu_threshold() don't use for_each_online_cpu
has been removed from the -mm tree.  Its filename was
     mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch

This patch was dropped because it was folded into mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: set_pgdat_percpu_threshold() don't use for_each_online_cpu
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This patch fixes following lockdep warning.

=================================
[ INFO: inconsistent lock state ]
2.6.37-rc1-mm1+ #150
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/419 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (cpu_hotplug.lock){+.+.?.}, at: [<ffffffff810520d1>]
get_online_cpus+0x41/0x60
{RECLAIM_FS-ON-W} state was registered at:
  [<ffffffff8108a1a3>] mark_held_locks+0x73/0xa0
  [<ffffffff8108a296>] lockdep_trace_alloc+0xc6/0x100
  [<ffffffff8113fba9>] kmem_cache_alloc+0x39/0x2b0
  [<ffffffff812eea10>] idr_pre_get+0x60/0x90
  [<ffffffff812ef5b7>] ida_pre_get+0x27/0xf0
  [<ffffffff8106ebf5>] create_worker+0x55/0x190
  [<ffffffff814fb4f4>] workqueue_cpu_callback+0xbc/0x235
  [<ffffffff8151934c>] notifier_call_chain+0x8c/0xe0
  [<ffffffff8107a34e>] __raw_notifier_call_chain+0xe/0x10
  [<ffffffff81051f30>] __cpu_notify+0x20/0x40
  [<ffffffff8150bff7>] _cpu_up+0x73/0x113
  [<ffffffff8150c175>] cpu_up+0xde/0xf1
  [<ffffffff81dcc81d>] kernel_init+0x21b/0x342
  [<ffffffff81003724>] kernel_thread_helper+0x4/0x10
irq event stamp: 27
hardirqs last  enabled at (27): [<ffffffff815152c0>] _raw_spin_unlock_irqrestore+0x40/0x80
hardirqs last disabled at (26): [<ffffffff81514982>] _raw_spin_lock_irqsave+0x32/0xa0
softirqs last  enabled at (20): [<ffffffff810614c4>] del_timer_sync+0x54/0xa0
softirqs last disabled at (18): [<ffffffff8106148c>] del_timer_sync+0x1c/0xa0

other info that might help us debug this:
no locks held by kswapd0/419.

stack backtrace:
Pid: 419, comm: kswapd0 Not tainted 2.6.37-rc1-mm1+ #150
Call Trace:
 [<ffffffff810890b1>] print_usage_bug+0x171/0x180
 [<ffffffff8108a057>] mark_lock+0x377/0x450
 [<ffffffff8108ab67>] __lock_acquire+0x267/0x15e0
 [<ffffffff8107af0f>] ? local_clock+0x6f/0x80
 [<ffffffff81086789>] ? trace_hardirqs_off_caller+0x29/0x150
 [<ffffffff8108bf94>] lock_acquire+0xb4/0x150
 [<ffffffff810520d1>] ? get_online_cpus+0x41/0x60
 [<ffffffff81512cf4>] __mutex_lock_common+0x44/0x3f0
 [<ffffffff810520d1>] ? get_online_cpus+0x41/0x60
 [<ffffffff810744f0>] ? prepare_to_wait+0x60/0x90
 [<ffffffff81086789>] ? trace_hardirqs_off_caller+0x29/0x150
 [<ffffffff810520d1>] ? get_online_cpus+0x41/0x60
 [<ffffffff810868bd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8107af0f>] ? local_clock+0x6f/0x80
 [<ffffffff815131a8>] mutex_lock_nested+0x48/0x60
 [<ffffffff810520d1>] get_online_cpus+0x41/0x60
 [<ffffffff811138b2>] set_pgdat_percpu_threshold+0x22/0xe0
 [<ffffffff81113970>] ? calculate_normal_threshold+0x0/0x60
 [<ffffffff8110b552>] kswapd+0x1f2/0x360
 [<ffffffff81074180>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8110b360>] ? kswapd+0x0/0x360
 [<ffffffff81073ae6>] kthread+0xa6/0xb0
 [<ffffffff81003724>] kernel_thread_helper+0x4/0x10
 [<ffffffff81515710>] ? restore_args+0x0/0x30
 [<ffffffff81073a40>] ? kthread+0x0/0xb0
 [<ffffffff81003720>] ? kernel_thread_helper+0x0/0x10

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/vmstat.c~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu
+++ a/mm/vmstat.c
@@ -193,18 +193,16 @@ void set_pgdat_percpu_threshold(pg_data_
 	int threshold;
 	int i;
 
-	get_online_cpus();
 	for (i = 0; i < pgdat->nr_zones; i++) {
 		zone = &pgdat->node_zones[i];
 		if (!zone->percpu_drift_mark)
 			continue;
 
 		threshold = (*calculate_pressure)(zone);
-		for_each_online_cpu(cpu)
+		for_each_possible_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
 	}
-	put_online_cpus();
 }
 
 /*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch
do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mempolicy-remove-tasklist_lock-from-migrate_pages.patch
mm-remove-likely-from-mapping_unevictable.patch
mm-remove-unlikely-from-page_mapping.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
mm-simplify-code-of-swapc.patch
mm-batch-activate_page-to-reduce-lock-contention.patch

