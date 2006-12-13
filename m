From: akpm@osdl.org
Subject: - sched-extract-load-calculation-from-rebalance_tick.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:02 -0800
Message-ID: <200612130654.kBD6s2rb030537@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57585 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964998AbWLMGy3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, kenneth.w.chen@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pwil3058@bigpond.net.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: extract load calculation from rebalance_tick
has been removed from the -mm tree.  Its filename was
     sched-extract-load-calculation-from-rebalance_tick.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: extract load calculation from rebalance_tick
From: Christoph Lameter <clameter@sgi.com>

A load calculation is always done in rebalance_tick() in addition to the real
load balancing activities that only take place when certain jiffie counts have
been reached.  Move that processing into a separate function and call it
directly from scheduler_tick().

Also extract the time slice handling from scheduler_tick and put it into a
separate function.  Then we can clean up scheduler_tick significantly.  It
will no longer have any gotos.

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

 kernel/sched.c |   96 ++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 42 deletions(-)

diff -puN kernel/sched.c~sched-extract-load-calculation-from-rebalance_tick kernel/sched.c
--- a/kernel/sched.c~sched-extract-load-calculation-from-rebalance_tick
+++ a/kernel/sched.c
@@ -2833,20 +2833,9 @@ static void active_load_balance(struct r
 	spin_unlock(&target_rq->lock);
 }
 
-/*
- * rebalance_tick will get called every timer tick, on every CPU.
- *
- * It checks each scheduling domain to see if it is due to be balanced,
- * and initiates a balancing operation if so.
- *
- * Balancing parameters are set up in arch_init_sched_domains.
- */
-
-static void
-rebalance_tick(int this_cpu, struct rq *this_rq, enum idle_type idle)
+static void update_load(struct rq *this_rq)
 {
-	unsigned long this_load, interval;
-	struct sched_domain *sd;
+	unsigned long this_load;
 	int i, scale;
 
 	this_load = this_rq->raw_weighted_load;
@@ -2866,6 +2855,22 @@ rebalance_tick(int this_cpu, struct rq *
 			new_load += scale-1;
 		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) / scale;
 	}
+}
+
+/*
+ * rebalance_tick will get called every timer tick, on every CPU.
+ *
+ * It checks each scheduling domain to see if it is due to be balanced,
+ * and initiates a balancing operation if so.
+ *
+ * Balancing parameters are set up in arch_init_sched_domains.
+ */
+
+static void
+rebalance_tick(int this_cpu, struct rq *this_rq, enum idle_type idle)
+{
+	unsigned long interval;
+	struct sched_domain *sd;
 
 	for_each_domain(this_cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -2897,12 +2902,15 @@ rebalance_tick(int this_cpu, struct rq *
 /*
  * on UP we do not need to balance between CPUs:
  */
-static inline void rebalance_tick(int cpu, struct rq *rq, enum idle_type idle)
+static inline void rebalance_tick(int cpu, struct rq *rq)
 {
 }
 static inline void idle_balance(int cpu, struct rq *rq)
 {
 }
+static inline void update_load(struct rq *this_rq)
+{
+}
 #endif
 
 static inline int wake_priority_sleeper(struct rq *rq)
@@ -3052,35 +3060,12 @@ void account_steal_time(struct task_stru
 		cpustat->steal = cputime64_add(cpustat->steal, tmp);
 }
 
-/*
- * This function gets called by the timer code, with HZ frequency.
- * We call it with interrupts disabled.
- *
- * It also gets called by the fork code, when changing the parent's
- * timeslices.
- */
-void scheduler_tick(void)
+static void task_running_tick(struct rq *rq, struct task_struct *p)
 {
-	unsigned long long now = sched_clock();
-	struct task_struct *p = current;
-	int cpu = smp_processor_id();
-	struct rq *rq = cpu_rq(cpu);
-
-	update_cpu_clock(p, rq, now);
-
-	rq->timestamp_last_tick = now;
-
-	if (p == rq->idle) {
-		if (wake_priority_sleeper(rq))
-			goto out;
-		rebalance_tick(cpu, rq, SCHED_IDLE);
-		return;
-	}
-
-	/* Task might have expired already, but not scheduled off yet */
 	if (p->array != rq->active) {
+		/* Task has expired but was not scheduled yet */
 		set_tsk_need_resched(p);
-		goto out;
+		return;
 	}
 	spin_lock(&rq->lock);
 	/*
@@ -3148,8 +3133,35 @@ void scheduler_tick(void)
 	}
 out_unlock:
 	spin_unlock(&rq->lock);
-out:
-	rebalance_tick(cpu, rq, NOT_IDLE);
+}
+
+/*
+ * This function gets called by the timer code, with HZ frequency.
+ * We call it with interrupts disabled.
+ *
+ * It also gets called by the fork code, when changing the parent's
+ * timeslices.
+ */
+void scheduler_tick(void)
+{
+	unsigned long long now = sched_clock();
+	struct task_struct *p = current;
+	int cpu = smp_processor_id();
+	struct rq *rq = cpu_rq(cpu);
+	enum idle_type idle = NOT_IDLE;
+
+	update_cpu_clock(p, rq, now);
+
+	rq->timestamp_last_tick = now;
+
+	if (p == rq->idle) {
+		/* Task on the idle queue */
+		if (!wake_priority_sleeper(rq))
+			idle = SCHED_IDLE;
+	} else
+		task_running_tick(rq, p);
+	update_load(rq);
+	rebalance_tick(cpu, rq, idle);
 }
 
 #ifdef CONFIG_SCHED_SMT
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

