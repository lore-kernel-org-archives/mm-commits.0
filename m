From: akpm@linux-foundation.org
Subject: - mm-only-sched-add-a-few-scheduler-event-counters.patch removed from -mm tree
Date: Wed, 21 Feb 2007 12:26:44 -0800
Message-ID: <200702212026.l1LKQi10024874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42576 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423086AbXBUU1E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:27:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, kenneth.w.chen@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pwil3058@bigpond.net.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: few scheduler event counters
has been removed from the -mm tree.  Its filename was
     mm-only-sched-add-a-few-scheduler-event-counters.patch

This patch was dropped because Suresh's patches trashed it, and I'm not sure anyone is using it much

------------------------------------------------------
Subject: sched: few scheduler event counters
From: Christoph Lameter <clameter@sgi.com>

Add a few counters to be able to see how the softirq affects the scheduler. 
This patch should not go into mainline and maybe also not into mm.

(akpm: heh.  Bad boy)

New counters in /proc/vmstat

sched_tick_balance	Ticks that required invokation of the softirq
sched_tick_no_balance	Ticks that did not require the softirq
sched_load_balance	# invocations of load_balance().
sched_balance_softirq	# of softirq executions
sched_balance_running	# of times that serialization prevented
			load balancing of a sched_domain.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 ++
 kernel/sched.c         |   12 ++++++++++--
 mm/vmstat.c            |    5 +++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff -puN include/linux/vmstat.h~mm-only-sched-add-a-few-scheduler-event-counters include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-only-sched-add-a-few-scheduler-event-counters
+++ a/include/linux/vmstat.h
@@ -37,6 +37,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		SCHED_TICK_NO_BALANCE, SCHED_TICK_BALANCE, SCHED_BALANCE_SOFTIRQ,
+		SCHED_LOAD_BALANCE, SCHED_BALANCE_RUNNING,
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN kernel/sched.c~mm-only-sched-add-a-few-scheduler-event-counters kernel/sched.c
--- a/kernel/sched.c~mm-only-sched-add-a-few-scheduler-event-counters
+++ a/kernel/sched.c
@@ -2953,6 +2953,8 @@ static void run_rebalance_domains(struct
 	/* Earliest time when we have to call run_rebalance_domains again */
 	unsigned long next_balance = jiffies + 60*HZ;
 
+	__count_vm_event(SCHED_BALANCE_SOFTIRQ);
+
 	for_each_domain(this_cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
@@ -2967,11 +2969,14 @@ static void run_rebalance_domains(struct
 			interval = 1;
 
 		if (sd->flags & SD_SERIALIZE) {
-			if (!spin_trylock(&balancing))
+			if (!spin_trylock(&balancing)) {
+				__count_vm_event(SCHED_BALANCE_RUNNING);
 				goto out;
+			}
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
+			__count_vm_event(SCHED_LOAD_BALANCE);
 			if (load_balance(this_cpu, this_rq, sd, idle, &balance)) {
 				/*
 				 * We've pulled tasks over so either we're no
@@ -3247,8 +3252,11 @@ void scheduler_tick(void)
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
-	if (time_after_eq(jiffies, rq->next_balance))
+	if (time_after_eq(jiffies, rq->next_balance)) {
+		__count_vm_event(SCHED_TICK_BALANCE);
 		raise_softirq(SCHED_SOFTIRQ);
+	}
+		__count_vm_event(SCHED_TICK_NO_BALANCE);
 #endif
 }
 
diff -puN mm/vmstat.c~mm-only-sched-add-a-few-scheduler-event-counters mm/vmstat.c
--- a/mm/vmstat.c~mm-only-sched-add-a-few-scheduler-event-counters
+++ a/mm/vmstat.c
@@ -484,6 +484,11 @@ static const char * const vmstat_text[] 
 	"allocstall",
 
 	"pgrotated",
+	"sched_tick_no_balance",
+	"sched_tick_balance",
+	"sched_balance_softirq",
+	"sched_load_balance",
+	"sched_balance_running",
 #endif
 };
 
_

Patches currently in -mm which might be from clameter@sgi.com are

use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
make-try_to_unmap-return-a-special-exit-code.patch
add-nr_mlock-zvc.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure-fix.patch
logic-to-move-mlocked-pages.patch
consolidate-new-anonymous-page-code-paths.patch
avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
opportunistically-move-mlocked-pages-off-the-lru.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
