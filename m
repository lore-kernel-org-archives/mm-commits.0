From: akpm@osdl.org
Subject: - sched-use-softirq-for-load-balancing.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:17 -0800
Message-ID: <200612130654.kBD6sHrP030545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57603 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965002AbWLMGyd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, kenneth.w.chen@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pwil3058@bigpond.net.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: use softirq for load balancing
has been removed from the -mm tree.  Its filename was
     sched-use-softirq-for-load-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: use softirq for load balancing
From: Christoph Lameter <clameter@sgi.com>

Call rebalance_tick (renamed to run_rebalance_domains) from a newly introduced
softirq.

We calculate the earliest time for each layer of sched domains to be rescanned
(this is the rescan time for idle) and use the earliest of those to schedule
the softirq via a new field "next_balance" added to struct rq.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/interrupt.h |    3 ++-
 kernel/sched.c            |   22 +++++++++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff -puN include/linux/interrupt.h~sched-use-softirq-for-load-balancing include/linux/interrupt.h
--- a/include/linux/interrupt.h~sched-use-softirq-for-load-balancing
+++ a/include/linux/interrupt.h
@@ -231,7 +231,8 @@ enum
 	NET_TX_SOFTIRQ,
 	NET_RX_SOFTIRQ,
 	BLOCK_SOFTIRQ,
-	TASKLET_SOFTIRQ
+	TASKLET_SOFTIRQ,
+	SCHED_SOFTIRQ,
 };
 
 /* softirq mask and active fields moved to irq_cpustat_t in
diff -puN kernel/sched.c~sched-use-softirq-for-load-balancing kernel/sched.c
--- a/kernel/sched.c~sched-use-softirq-for-load-balancing
+++ a/kernel/sched.c
@@ -227,6 +227,7 @@ struct rq {
 	unsigned long expired_timestamp;
 	unsigned long long timestamp_last_tick;
 	struct task_struct *curr, *idle;
+	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 	struct prio_array *active, *expired, arrays[2];
 	int best_expired_prio;
@@ -2858,7 +2859,7 @@ static void update_load(struct rq *this_
 }
 
 /*
- * rebalance_tick will get called every timer tick, on every CPU.
+ * run_rebalance_domains is triggered when needed from the scheduler tick.
  *
  * It checks each scheduling domain to see if it is due to be balanced,
  * and initiates a balancing operation if so.
@@ -2866,9 +2867,10 @@ static void update_load(struct rq *this_
  * Balancing parameters are set up in arch_init_sched_domains.
  */
 
-static void
-rebalance_tick(int this_cpu, struct rq *this_rq)
+static void run_rebalance_domains(struct softirq_action *h)
 {
+	int this_cpu = smp_processor_id();
+	struct rq *this_rq = cpu_rq(this_cpu);
 	unsigned long interval;
 	struct sched_domain *sd;
 	/*
@@ -2877,6 +2879,8 @@ rebalance_tick(int this_cpu, struct rq *
 	 */
 	enum idle_type idle = !this_rq->nr_running ?
 				SCHED_IDLE : NOT_IDLE;
+	/* Earliest time when we have to call run_rebalance_domains again */
+	unsigned long next_balance = jiffies + 60*HZ;
 
 	for_each_domain(this_cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -2891,7 +2895,7 @@ rebalance_tick(int this_cpu, struct rq *
 		if (unlikely(!interval))
 			interval = 1;
 
-		if (jiffies - sd->last_balance >= interval) {
+		if (time_after_eq(jiffies, sd->last_balance + interval)) {
 			if (load_balance(this_cpu, this_rq, sd, idle)) {
 				/*
 				 * We've pulled tasks over so either we're no
@@ -2902,7 +2906,10 @@ rebalance_tick(int this_cpu, struct rq *
 			}
 			sd->last_balance += interval;
 		}
+		if (time_after(next_balance, sd->last_balance + interval))
+			next_balance = sd->last_balance + interval;
 	}
+	this_rq->next_balance = next_balance;
 }
 #else
 /*
@@ -3155,7 +3162,8 @@ void scheduler_tick(void)
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);
-	rebalance_tick(cpu, rq);
+	if (time_after_eq(jiffies, rq->next_balance))
+		raise_softirq(SCHED_SOFTIRQ);
 #endif
 }
 
@@ -6869,6 +6877,10 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
+#ifdef CONFIG_SMP
+	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
+#endif
+
 #ifdef CONFIG_RT_MUTEXES
 	plist_head_init(&init_task.pi_waiters, &init_task.pi_lock);
 #endif
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-fix-sleeping-in-atomic-bug.patch
cleanup-slab-headers--api-to-allow-easy-addition-of-new-slab.patch
more-slabh-cleanups.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

