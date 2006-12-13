From: akpm@osdl.org
Subject: - sched-move-idle-status-calculation-into-rebalance_tick.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:09 -0800
Message-ID: <200612130654.kBD6s9xa030542@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57605 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003AbWLMGye (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, kenneth.w.chen@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pwil3058@bigpond.net.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: move idle status calculation into rebalance_tick()
has been removed from the -mm tree.  Its filename was
     sched-move-idle-status-calculation-into-rebalance_tick.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: move idle status calculation into rebalance_tick()
From: Christoph Lameter <clameter@sgi.com>

Perform the idle state determination in rebalance_tick.

If we separate balancing from sched_tick then we also need to determine the
idle state in rebalance_tick.

V2->V3
	Remove useless idlle != 0 check. Checking nr_running seems
	to be sufficient. Thanks Suresh.

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

 kernel/sched.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff -puN kernel/sched.c~sched-move-idle-status-calculation-into-rebalance_tick kernel/sched.c
--- a/kernel/sched.c~sched-move-idle-status-calculation-into-rebalance_tick
+++ a/kernel/sched.c
@@ -2867,10 +2867,16 @@ static void update_load(struct rq *this_
  */
 
 static void
-rebalance_tick(int this_cpu, struct rq *this_rq, enum idle_type idle)
+rebalance_tick(int this_cpu, struct rq *this_rq)
 {
 	unsigned long interval;
 	struct sched_domain *sd;
+	/*
+	 * We are idle if there are no processes running. This
+	 * is valid even if we are the idle process (SMT).
+	 */
+	enum idle_type idle = !this_rq->nr_running ?
+				SCHED_IDLE : NOT_IDLE;
 
 	for_each_domain(this_cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -2902,37 +2908,26 @@ rebalance_tick(int this_cpu, struct rq *
 /*
  * on UP we do not need to balance between CPUs:
  */
-static inline void rebalance_tick(int cpu, struct rq *rq)
-{
-}
 static inline void idle_balance(int cpu, struct rq *rq)
 {
 }
-static inline void update_load(struct rq *this_rq)
-{
-}
 #endif
 
-static inline int wake_priority_sleeper(struct rq *rq)
+static inline void wake_priority_sleeper(struct rq *rq)
 {
-	int ret = 0;
-
 #ifdef CONFIG_SCHED_SMT
 	if (!rq->nr_running)
-		return 0;
+		return;
 
 	spin_lock(&rq->lock);
 	/*
 	 * If an SMT sibling task has been put to sleep for priority
 	 * reasons reschedule the idle task to see if it can now run.
 	 */
-	if (rq->nr_running) {
+	if (rq->nr_running)
 		resched_task(rq->idle);
-		ret = 1;
-	}
 	spin_unlock(&rq->lock);
 #endif
-	return ret;
 }
 
 DEFINE_PER_CPU(struct kernel_stat, kstat);
@@ -3148,20 +3143,20 @@ void scheduler_tick(void)
 	struct task_struct *p = current;
 	int cpu = smp_processor_id();
 	struct rq *rq = cpu_rq(cpu);
-	enum idle_type idle = NOT_IDLE;
 
 	update_cpu_clock(p, rq, now);
 
 	rq->timestamp_last_tick = now;
 
-	if (p == rq->idle) {
+	if (p == rq->idle)
 		/* Task on the idle queue */
-		if (!wake_priority_sleeper(rq))
-			idle = SCHED_IDLE;
-	} else
+		wake_priority_sleeper(rq);
+	else
 		task_running_tick(rq, p);
+#ifdef CONFIG_SMP
 	update_load(rq);
-	rebalance_tick(cpu, rq, idle);
+	rebalance_tick(cpu, rq);
+#endif
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

