From: akpm@linux-foundation.org
Subject: - safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch removed from -mm tree
Date: Mon, 07 May 2007 17:01:44 -0700
Message-ID: <200705080001.l4801iXh008790@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967306AbXEHABs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:01:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@engr.sgi.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Safer nr_node_ids and nr_node_ids determination and initial values
has been removed from the -mm tree.  Its filename was
     safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Safer nr_node_ids and nr_node_ids determination and initial values
From: Christoph Lameter <clameter@engr.sgi.com>

The nr_cpu_ids value is currently only calculated in smp_init.  However, it
may be needed before (SLUB needs it on kmem_cache_init!) and other kernel
components may also want to allocate dynamically sized per cpu array before
smp_init.  So move the determination of possible cpus into sched_init()
where we already loop over all possible cpus early in boot.

Also initialize both nr_node_ids and nr_cpu_ids with the highest value they
could take.  If we have accidental users before these values are determined
then the current valud of 0 may cause too small per cpu and per node arrays
to be allocated.  If it is set to the maximum possible then we only waste
some memory for early boot users.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c     |    5 -----
 kernel/sched.c  |    8 ++++++++
 lib/cpumask.c   |    3 ---
 mm/page_alloc.c |    2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff -puN init/main.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial init/main.c
--- a/init/main.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial
+++ a/init/main.c
@@ -384,11 +384,6 @@ static void __init setup_per_cpu_areas(v
 static void __init smp_init(void)
 {
 	unsigned int cpu;
-	unsigned highest = 0;
-
-	for_each_cpu_mask(cpu, cpu_possible_map)
-		highest = cpu;
-	nr_cpu_ids = highest + 1;
 
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
diff -puN kernel/sched.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial kernel/sched.c
--- a/kernel/sched.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial
+++ a/kernel/sched.c
@@ -5244,6 +5244,11 @@ int __init migration_init(void)
 #endif
 
 #ifdef CONFIG_SMP
+
+/* Number of possible processor ids */
+int nr_cpu_ids __read_mostly = NR_CPUS;
+EXPORT_SYMBOL(nr_cpu_ids);
+
 #undef SCHED_DOMAIN_DEBUG
 #ifdef SCHED_DOMAIN_DEBUG
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
@@ -6726,6 +6731,7 @@ int in_sched_functions(unsigned long add
 void __init sched_init(void)
 {
 	int i, j, k;
+	int highest_cpu = 0;
 
 	for_each_possible_cpu(i) {
 		struct prio_array *array;
@@ -6760,11 +6766,13 @@ void __init sched_init(void)
 			// delimiter for bitsearch
 			__set_bit(MAX_PRIO, array->bitmap);
 		}
+		highest_cpu = i;
 	}
 
 	set_load_weight(&init_task);
 
 #ifdef CONFIG_SMP
+	nr_cpu_ids = highest_cpu + 1;
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
 #endif
 
diff -puN lib/cpumask.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial lib/cpumask.c
--- a/lib/cpumask.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial
+++ a/lib/cpumask.c
@@ -15,9 +15,6 @@ int __next_cpu(int n, const cpumask_t *s
 }
 EXPORT_SYMBOL(__next_cpu);
 
-int nr_cpu_ids;
-EXPORT_SYMBOL(nr_cpu_ids);
-
 int __any_online_cpu(const cpumask_t *mask)
 {
 	int cpu;
diff -puN mm/page_alloc.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial mm/page_alloc.c
--- a/mm/page_alloc.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial
+++ a/mm/page_alloc.c
@@ -665,7 +665,7 @@ static int rmqueue_bulk(struct zone *zon
 }
 
 #if MAX_NUMNODES > 1
-int nr_node_ids __read_mostly;
+int nr_node_ids __read_mostly = MAX_NUMNODES;
 EXPORT_SYMBOL(nr_node_ids);
 
 /*
_

Patches currently in -mm which might be from clameter@engr.sgi.com are

origin.patch
increase-slab-redzone-to-64bits.patch
move-free-pages-between-lists-on-steal.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
pretend-cpuset-has-some-form-of-hugetlb-page-reservation.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
slab-leaks3-default-y.patch
