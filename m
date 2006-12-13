From: akpm@osdl.org
Subject: - sched-remove-staggering-of-load-balancing.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:53:49 -0800
Message-ID: <200612130653.kBD6rnge030526@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57616 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965007AbWLMGyg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, kenneth.w.chen@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pwil3058@bigpond.net.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: remove staggering of load balancing
has been removed from the -mm tree.  Its filename was
     sched-remove-staggering-of-load-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: remove staggering of load balancing
From: Christoph Lameter <clameter@sgi.com>

Timer interrupts already are staggered.  We do not need an additional layer of
time staggering for short load balancing actions that take a reasonably small
portion of the time slice.

For load balancing on large sched_domains we will add a serialization later
that avoids concurrent load balance operations and thus has the same effect as
load staggering.

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

 kernel/sched.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN kernel/sched.c~sched-remove-staggering-of-load-balancing kernel/sched.c
--- a/kernel/sched.c~sched-remove-staggering-of-load-balancing
+++ a/kernel/sched.c
@@ -2841,16 +2841,10 @@ static void active_load_balance(struct r
  * Balancing parameters are set up in arch_init_sched_domains.
  */
 
-/* Don't have all balancing operations going off at once: */
-static inline unsigned long cpu_offset(int cpu)
-{
-	return jiffies + cpu * HZ / NR_CPUS;
-}
-
 static void
 rebalance_tick(int this_cpu, struct rq *this_rq, enum idle_type idle)
 {
-	unsigned long this_load, interval, j = cpu_offset(this_cpu);
+	unsigned long this_load, interval;
 	struct sched_domain *sd;
 	int i, scale;
 
@@ -2885,7 +2879,7 @@ rebalance_tick(int this_cpu, struct rq *
 		if (unlikely(!interval))
 			interval = 1;
 
-		if (j - sd->last_balance >= interval) {
+		if (jiffies - sd->last_balance >= interval) {
 			if (load_balance(this_cpu, this_rq, sd, idle)) {
 				/*
 				 * We've pulled tasks over so either we're no
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

