From: akpm@osdl.org
Subject: - sched-disable-interrupts-for-locking-in-load_balance.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:53:55 -0800
Message-ID: <200612130653.kBD6rtT8030534@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965004AbWLMGye (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, kenneth.w.chen@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pwil3058@bigpond.net.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: disable interrupts for locking in load_balance()
has been removed from the -mm tree.  Its filename was
     sched-disable-interrupts-for-locking-in-load_balance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: disable interrupts for locking in load_balance()
From: Christoph Lameter <clameter@sgi.com>

Interrupts must be disabled for request queue locks if we want to run
load_balance() with interrupts enabled.

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

 kernel/sched.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/sched.c~sched-disable-interrupts-for-locking-in-load_balance kernel/sched.c
--- a/kernel/sched.c~sched-disable-interrupts-for-locking-in-load_balance
+++ a/kernel/sched.c
@@ -2546,8 +2546,6 @@ static inline unsigned long minus_1_or_z
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
- *
- * Called with this_rq unlocked.
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum idle_type idle)
@@ -2557,6 +2555,7 @@ static int load_balance(int this_cpu, st
 	unsigned long imbalance;
 	struct rq *busiest;
 	cpumask_t cpus = CPU_MASK_ALL;
+	unsigned long flags;
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -2596,11 +2595,13 @@ redo:
 		 * still unbalanced. nr_moved simply stays zero, so it is
 		 * correctly treated as an imbalance.
 		 */
+		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
 		nr_moved = move_tasks(this_rq, this_cpu, busiest,
 				      minus_1_or_zero(busiest->nr_running),
 				      imbalance, sd, idle, &all_pinned);
 		double_rq_unlock(this_rq, busiest);
+		local_irq_restore(flags);
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(all_pinned)) {
@@ -2617,13 +2618,13 @@ redo:
 
 		if (unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2)) {
 
-			spin_lock(&busiest->lock);
+			spin_lock_irqsave(&busiest->lock, flags);
 
 			/* don't kick the migration_thread, if the curr
 			 * task on busiest cpu can't be moved to this_cpu
 			 */
 			if (!cpu_isset(this_cpu, busiest->curr->cpus_allowed)) {
-				spin_unlock(&busiest->lock);
+				spin_unlock_irqrestore(&busiest->lock, flags);
 				all_pinned = 1;
 				goto out_one_pinned;
 			}
@@ -2633,7 +2634,7 @@ redo:
 				busiest->push_cpu = this_cpu;
 				active_balance = 1;
 			}
-			spin_unlock(&busiest->lock);
+			spin_unlock_irqrestore(&busiest->lock, flags);
 			if (active_balance)
 				wake_up_process(busiest->migration_thread);
 
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

