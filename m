From: akpm@osdl.org
Subject: - sched-call-tasklet-less-frequently.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:25 -0800
Message-ID: <200612130654.kBD6sPqG030548@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57632 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965008AbWLMGyk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, kenneth.w.chen@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pwil3058@bigpond.net.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: call tasklet less frequently
has been removed from the -mm tree.  Its filename was
     sched-call-tasklet-less-frequently.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: call tasklet less frequently
From: Christoph Lameter <clameter@sgi.com>

Trigger softirq less frequently

We trigger the softirq before this patch using offset of sd->interval. 
However, if the queue is busy then it is sufficient to schedule the softirq
with sd->interval * busy_factor.

So we modify the calculation of the next time to balance by taking
the interval added to last_balance again. This is only the
right value if the idle/busy situation continues as is.

There are two potential trouble spots:
- If the queue was idle and now gets busy then we call rebalance
  early. However, that is not a problem because we will then use
  the longer interval for the next period.

- If the queue was busy and becomes idle then we potentially
  wait too long before rebalancing. However, when the task
  goes idle then idle_balance is called. We add another calculation
  of the next balance time based on sd->interval in idle_balance
  so that we will rebalance soon.

V2->V3:
- Calculate rebalance time based on current jiffies and not
  based on the jiffies at the last time we load balanced.
  We no longer rely on staggering and therefore we can
  affort to do this now.

V3->V4:
- Use functions to do jiffy comparisons.

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

 kernel/sched.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~sched-call-tasklet-less-frequently kernel/sched.c
--- a/kernel/sched.c~sched-call-tasklet-less-frequently
+++ a/kernel/sched.c
@@ -2774,14 +2774,28 @@ out_balanced:
 static void idle_balance(int this_cpu, struct rq *this_rq)
 {
 	struct sched_domain *sd;
+	int pulled_task = 0;
+	unsigned long next_balance = jiffies + 60 *  HZ;
 
 	for_each_domain(this_cpu, sd) {
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
 			/* If we've pulled tasks over stop searching: */
-			if (load_balance_newidle(this_cpu, this_rq, sd))
+			pulled_task = load_balance_newidle(this_cpu,
+							this_rq, sd);
+			if (time_after(next_balance,
+				  sd->last_balance + sd->balance_interval))
+				next_balance = sd->last_balance
+						+ sd->balance_interval;
+			if (pulled_task)
 				break;
 		}
 	}
+	if (!pulled_task)
+		/*
+		 * We are going idle. next_balance may be set based on
+		 * a busy processor. So reset next_balance.
+		 */
+		this_rq->next_balance = next_balance;
 }
 
 /*
@@ -2904,7 +2918,7 @@ static void run_rebalance_domains(struct
 				 */
 				idle = NOT_IDLE;
 			}
-			sd->last_balance += interval;
+			sd->last_balance = jiffies;
 		}
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
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

