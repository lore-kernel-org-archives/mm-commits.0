From: akpm@osdl.org
Subject: - sched-add-option-to-serialize-load-balancing.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:32 -0800
Message-ID: <200612130654.kBD6sWs1030555@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57640 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965004AbWLMGym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, kenneth.w.chen@intel.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pwil3058@bigpond.net.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: add option to serialize load balancing
has been removed from the -mm tree.  Its filename was
     sched-add-option-to-serialize-load-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: add option to serialize load balancing
From: Christoph Lameter <clameter@sgi.com>

Large sched domains can be very expensive to scan.  Add an option SD_SERIALIZE
to the sched domain flags.  If that flag is set then we make sure that no
other such domain is being balanced.

[akpm@osdl.org: build fix]
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

 include/asm-i386/topology.h    |    1 +
 include/asm-ia64/topology.h    |    1 +
 include/asm-powerpc/topology.h |    1 +
 include/asm-x86_64/topology.h  |    1 +
 include/linux/sched.h          |    1 +
 include/linux/topology.h       |    3 ++-
 kernel/sched.c                 |    9 +++++++++
 7 files changed, 16 insertions(+), 1 deletion(-)

diff -puN include/asm-i386/topology.h~sched-add-option-to-serialize-load-balancing include/asm-i386/topology.h
--- a/include/asm-i386/topology.h~sched-add-option-to-serialize-load-balancing
+++ a/include/asm-i386/topology.h
@@ -89,6 +89,7 @@ static inline int node_to_first_cpu(int 
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
+				| SD_SERIALIZE		\
 				| SD_WAKE_BALANCE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
diff -puN include/asm-ia64/topology.h~sched-add-option-to-serialize-load-balancing include/asm-ia64/topology.h
--- a/include/asm-ia64/topology.h~sched-add-option-to-serialize-load-balancing
+++ a/include/asm-ia64/topology.h
@@ -101,6 +101,7 @@ void build_cpu_to_node_map(void);
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
+				| SD_SERIALIZE		\
 				| SD_WAKE_BALANCE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 64,			\
diff -puN include/asm-powerpc/topology.h~sched-add-option-to-serialize-load-balancing include/asm-powerpc/topology.h
--- a/include/asm-powerpc/topology.h~sched-add-option-to-serialize-load-balancing
+++ a/include/asm-powerpc/topology.h
@@ -66,6 +66,7 @@ static inline int pcibus_to_node(struct 
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_WAKE_IDLE		\
+				| SD_SERIALIZE		\
 				| SD_WAKE_BALANCE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
diff -puN include/asm-x86_64/topology.h~sched-add-option-to-serialize-load-balancing include/asm-x86_64/topology.h
--- a/include/asm-x86_64/topology.h~sched-add-option-to-serialize-load-balancing
+++ a/include/asm-x86_64/topology.h
@@ -47,6 +47,7 @@ extern int __node_distance(int, int);
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
+				| SD_SERIALIZE		\
 				| SD_WAKE_BALANCE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
diff -puN include/linux/sched.h~sched-add-option-to-serialize-load-balancing include/linux/sched.h
--- a/include/linux/sched.h~sched-add-option-to-serialize-load-balancing
+++ a/include/linux/sched.h
@@ -648,6 +648,7 @@ enum idle_type
 #define SD_SHARE_CPUPOWER	128	/* Domain members share cpu power */
 #define SD_POWERSAVINGS_BALANCE	256	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	512	/* Domain members share cpu pkg resources */
+#define SD_SERIALIZE		1024	/* Only a single load balancing instance */
 
 #define BALANCE_FOR_MC_POWER	\
 	(sched_smt_power_savings ? SD_POWERSAVINGS_BALANCE : 0)
diff -puN include/linux/topology.h~sched-add-option-to-serialize-load-balancing include/linux/topology.h
--- a/include/linux/topology.h~sched-add-option-to-serialize-load-balancing
+++ a/include/linux/topology.h
@@ -194,7 +194,8 @@
 	.wake_idx		= 0, /* unused */	\
 	.forkexec_idx		= 0, /* unused */	\
 	.per_cpu_gain		= 100,			\
-	.flags			= SD_LOAD_BALANCE,	\
+	.flags			= SD_LOAD_BALANCE	\
+				| SD_SERIALIZE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 64,			\
 	.nr_balance_failed	= 0,			\
diff -puN kernel/sched.c~sched-add-option-to-serialize-load-balancing kernel/sched.c
--- a/kernel/sched.c~sched-add-option-to-serialize-load-balancing
+++ a/kernel/sched.c
@@ -2880,6 +2880,7 @@ static void update_load(struct rq *this_
  *
  * Balancing parameters are set up in arch_init_sched_domains.
  */
+static DEFINE_SPINLOCK(balancing);
 
 static void run_rebalance_domains(struct softirq_action *h)
 {
@@ -2909,6 +2910,11 @@ static void run_rebalance_domains(struct
 		if (unlikely(!interval))
 			interval = 1;
 
+		if (sd->flags & SD_SERIALIZE) {
+			if (!spin_trylock(&balancing))
+				goto out;
+		}
+
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
 			if (load_balance(this_cpu, this_rq, sd, idle)) {
 				/*
@@ -2920,6 +2926,9 @@ static void run_rebalance_domains(struct
 			}
 			sd->last_balance = jiffies;
 		}
+		if (sd->flags & SD_SERIALIZE)
+			spin_unlock(&balancing);
+out:
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
 	}
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

