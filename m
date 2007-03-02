From: akpm@linux-foundation.org
Subject: + safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:25:54 -0800
Message-ID: <200703020125.l221PsSv028680@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34071 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422681AbXCBBZ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:25:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@engr.sgi.com, clameter@sgi.coim


The patch titled
     Safer nr_node_ids and nr_node_ids determination and initial values
has been added to the -mm tree.  Its filename is
     safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Christoph Lameter <clameter@sgi.coim>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c     |    5 -----
 kernel/sched.c  |    7 +++++++
 lib/cpumask.c   |    3 ---
 mm/page_alloc.c |    2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

diff -puN init/main.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial init/main.c
--- a/init/main.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial
+++ a/init/main.c
@@ -388,11 +388,6 @@ static void __init setup_per_cpu_areas(v
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
@@ -6911,9 +6911,14 @@ int in_sched_functions(unsigned long add
 		&& addr < (unsigned long)__sched_text_end);
 }
 
+/* Number of possible processor ids */
+int nr_cpu_ids = NR_CPUS;
+EXPORT_SYMBOL(nr_cpu_ids);
+
 void __init sched_init(void)
 {
 	int i, j, k;
+	int highest_cpu = 0;
 
 	for_each_possible_cpu(i) {
 		struct prio_array *array;
@@ -6948,7 +6953,9 @@ void __init sched_init(void)
 			// delimiter for bitsearch
 			__set_bit(MAX_PRIO, array->bitmap);
 		}
+		highest_cpu = i;
 	}
+	nr_cpu_ids = highest_cpu + 1;
 
 	set_load_weight(&init_task);
 
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

adapt-page_lock_anon_vma-to-preempt_rcu.patch
nfs-fix-congestion-control-v4.patch
git-block-xfs-barriers-broke.patch
mm-set-hashdist_default-to-1-for-x86_64-numa.patch
x86_64-configurable-fake-numa-node-sizes.patch
x86_64-split-remaining-fake-nodes-equally.patch
x86_64-fixed-size-remaining-fake-nodes.patch
x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
x86_64-fake-numa-for-cpusets-document.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
swap_prefetch-vs-zoned-counters.patch
reiser4-vs-zoned-allocator.patch
slab-leaks3-default-y.patch
