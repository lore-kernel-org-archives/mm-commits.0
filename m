From: akpm@linux-foundation.org
Subject: + mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch added to -mm tree
Date: Fri, 19 Nov 2010 11:50:36 -0800
Message-ID: <201011191950.oAJJoaaG031202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756504Ab0KSTwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Nov 2010 14:52:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     set_pgdat_percpu_threshold() don't use for_each_online_cpu
has been added to the -mm tree.  Its filename is
     mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch

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
Cc: Christoph Lameter <cl@linux.com>
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

linux-next.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch

