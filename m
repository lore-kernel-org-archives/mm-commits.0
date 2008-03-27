From: akpm@linux-foundation.org
Subject: + sched-remove-fixed-nr_cpus-sized-arrays-in-kernel_schedc.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:00:42 -0700
Message-ID: <200803270800.m2R80gJX024719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589AbYC0IBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, mingo@elte.hu


The patch titled
     sched: remove fixed NR_CPUS sized arrays in kernel_sched.c
has been added to the -mm tree.  Its filename is
     sched-remove-fixed-nr_cpus-sized-arrays-in-kernel_schedc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: remove fixed NR_CPUS sized arrays in kernel_sched.c
From: Mike Travis <travis@sgi.com>

Change fixed size arrays to per_cpu variables or dynamically allocated
arrays in sched_init() and sched_init_smp().

 (1)	static struct sched_entity *init_sched_entity_p[NR_CPUS];
 (1)	static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
 (1)	static struct sched_rt_entity *init_sched_rt_entity_p[NR_CPUS];
 (1)	static struct rt_rq *init_rt_rq_p[NR_CPUS];
	static struct sched_group **sched_group_nodes_bycpu[NR_CPUS];
	char str[NR_CPUS];
	int ints[NR_CPUS], i;

(1 - these arrays are allocated via alloc_bootmem_low())

Also in sched_create_group() we allocate new arrays based on nr_cpu_ids.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   92 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 63 insertions(+), 29 deletions(-)

diff -puN kernel/sched.c~sched-remove-fixed-nr_cpus-sized-arrays-in-kernel_schedc kernel/sched.c
--- a/kernel/sched.c~sched-remove-fixed-nr_cpus-sized-arrays-in-kernel_schedc
+++ a/kernel/sched.c
@@ -62,6 +62,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/kprobes.h>
 #include <linux/delayacct.h>
+#include <linux/bootmem.h>
 #include <linux/reciprocal_div.h>
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
@@ -194,17 +195,11 @@ struct task_group {
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
 static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
-
-static struct sched_entity *init_sched_entity_p[NR_CPUS];
-static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
-
-static struct sched_rt_entity *init_sched_rt_entity_p[NR_CPUS];
-static struct rt_rq *init_rt_rq_p[NR_CPUS];
 #endif
 
 /* task_group_lock serializes add/remove of task groups and also changes to
@@ -228,17 +223,7 @@ static int init_task_group_load = INIT_T
 /* Default task group.
  *	Every task in system belong to this group at bootup.
  */
-struct task_group init_task_group = {
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	.se	= init_sched_entity_p,
-	.cfs_rq = init_cfs_rq_p,
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	.rt_se	= init_sched_rt_entity_p,
-	.rt_rq	= init_rt_rq_p,
-#endif
-};
+struct task_group init_task_group;
 
 /* return group to which a task belongs */
 static inline struct task_group *task_group(struct task_struct *p)
@@ -3650,7 +3635,7 @@ static inline void trigger_load_balance(
 			 */
 			int ilb = first_cpu(nohz.cpu_mask);
 
-			if (ilb != NR_CPUS)
+			if (ilb < nr_cpu_ids)
 				resched_cpu(ilb);
 		}
 	}
@@ -5602,11 +5587,11 @@ static void move_task_off_dead_cpu(int d
 		dest_cpu = any_online_cpu(mask);
 
 		/* On any allowed CPU? */
-		if (dest_cpu == NR_CPUS)
+		if (dest_cpu >= nr_cpu_ids)
 			dest_cpu = any_online_cpu(p->cpus_allowed);
 
 		/* No more Mr. Nice Guy. */
-		if (dest_cpu == NR_CPUS) {
+		if (dest_cpu >= nr_cpu_ids) {
 			cpumask_t cpus_allowed = cpuset_cpus_allowed_locked(p);
 			/*
 			 * Try to stay on the same cpuset, where the
@@ -6065,9 +6050,16 @@ static int sched_domain_debug_one(struct
 {
 	struct sched_group *group = sd->groups;
 	cpumask_t groupmask;
-	char str[NR_CPUS];
+	int len = cpumask_scnprintf_len(nr_cpu_ids);
+	char *str = kmalloc(len, GFP_KERNEL);
+	int ret = 0;
+
+	if (!str) {
+		printk(KERN_DEBUG "Cannot load-balance (no memory)\n");
+		return -1;
+	}
 
-	cpumask_scnprintf(str, NR_CPUS, sd->span);
+	cpumask_scnprintf(str, len, sd->span);
 	cpus_clear(groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
@@ -6077,6 +6069,7 @@ static int sched_domain_debug_one(struct
 		if (sd->parent)
 			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
 					" has parent");
+		kfree(str);
 		return -1;
 	}
 
@@ -6120,7 +6113,7 @@ static int sched_domain_debug_one(struct
 
 		cpus_or(groupmask, groupmask, group->cpumask);
 
-		cpumask_scnprintf(str, NR_CPUS, group->cpumask);
+		cpumask_scnprintf(str, len, group->cpumask);
 		printk(KERN_CONT " %s", str);
 
 		group = group->next;
@@ -6133,6 +6126,8 @@ static int sched_domain_debug_one(struct
 	if (sd->parent && !cpus_subset(groupmask, sd->parent->span))
 		printk(KERN_ERR "ERROR: parent span is not a superset "
 			"of domain->span\n");
+
+	kfree(str);
 	return 0;
 }
 
@@ -6316,7 +6311,7 @@ cpu_attach_domain(struct sched_domain *s
 /*
  * init_sched_build_groups takes the cpumask we wish to span, and a pointer
  * to a function which identifies what group(along with sched group) a CPU
- * belongs to. The return value of group_fn must be a >= 0 and < NR_CPUS
+ * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
  * (due to the fact that we keep track of groups covered with a cpumask_t).
  *
  * init_sched_build_groups will build a circular linked list of the groups
@@ -6514,7 +6509,7 @@ cpu_to_phys_group(int cpu, const cpumask
  * gets dynamically allocated.
  */
 static DEFINE_PER_CPU(struct sched_domain, node_domains);
-static struct sched_group **sched_group_nodes_bycpu[NR_CPUS];
+static struct sched_group ***sched_group_nodes_bycpu;
 
 static DEFINE_PER_CPU(struct sched_domain, allnodes_domains);
 static DEFINE_PER_CPU(struct sched_group, sched_group_allnodes);
@@ -7157,6 +7152,11 @@ void __init sched_init_smp(void)
 {
 	cpumask_t non_isolated_cpus;
 
+#if defined(CONFIG_NUMA)
+	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
+								GFP_KERNEL);
+	BUG_ON(sched_group_nodes_bycpu == NULL);
+#endif
 	get_online_cpus();
 	arch_init_sched_domains(&cpu_online_map);
 	non_isolated_cpus = cpu_possible_map;
@@ -7174,6 +7174,11 @@ void __init sched_init_smp(void)
 #else
 void __init sched_init_smp(void)
 {
+#if defined(CONFIG_NUMA)
+	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
+								GFP_KERNEL);
+	BUG_ON(sched_group_nodes_bycpu == NULL);
+#endif
 	sched_init_granularity();
 }
 #endif /* CONFIG_SMP */
@@ -7268,6 +7273,35 @@ void __init sched_init(void)
 {
 	int highest_cpu = 0;
 	int i, j;
+	unsigned long alloc_size = 0, ptr;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
+#endif
+	/*
+	 * As sched_init() is called before page_alloc is setup,
+	 * we use alloc_bootmem().
+	 */
+	if (alloc_size) {
+		ptr = (unsigned long)alloc_bootmem_low(alloc_size);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+		init_task_group.se = (struct sched_entity **)ptr;
+		ptr += nr_cpu_ids * sizeof(void **);
+
+		init_task_group.cfs_rq = (struct cfs_rq **)ptr;
+		ptr += nr_cpu_ids * sizeof(void **);
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+		init_task_group.rt_se = (struct sched_rt_entity **)ptr;
+		ptr += nr_cpu_ids * sizeof(void **);
+
+		init_task_group.rt_rq = (struct rt_rq **)ptr;
+#endif
+	}
 
 #ifdef CONFIG_SMP
 	init_defrootdomain();
@@ -7516,10 +7550,10 @@ static int alloc_fair_sched_group(struct
 	struct rq *rq;
 	int i;
 
-	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * NR_CPUS, GFP_KERNEL);
+	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->cfs_rq)
 		goto err;
-	tg->se = kzalloc(sizeof(se) * NR_CPUS, GFP_KERNEL);
+	tg->se = kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->se)
 		goto err;
 
@@ -7599,10 +7633,10 @@ static int alloc_rt_sched_group(struct t
 	struct rq *rq;
 	int i;
 
-	tg->rt_rq = kzalloc(sizeof(rt_rq) * NR_CPUS, GFP_KERNEL);
+	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->rt_rq)
 		goto err;
-	tg->rt_se = kzalloc(sizeof(rt_se) * NR_CPUS, GFP_KERNEL);
+	tg->rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->rt_se)
 		goto err;
 
_

Patches currently in -mm which might be from travis@sgi.com are

git-cpufreq.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch
acpi-change-processors-from-array-to-per_cpu-variable.patch
cpumask-add-cpumask_scnprintf_len-function.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch
net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch
sched-remove-fixed-nr_cpus-sized-arrays-in-kernel_schedc.patch

