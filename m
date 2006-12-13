From: akpm@osdl.org
Subject: - sched-domain-move-sched-group-allocations-to-percpu-area.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:53:16 -0800
Message-ID: <200612130653.kBD6rGh3030514@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57499 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964996AbWLMGxX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:53:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, clameter@sgi.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     ched domain: move sched group allocations to percpu area
has been removed from the -mm tree.  Its filename was
     sched-domain-move-sched-group-allocations-to-percpu-area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ched domain: move sched group allocations to percpu area
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Move the sched group allocations to percpu area.  This will minimize cross
node memory references and also cleans up the sched groups allocation for
allnodes sched domain.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |  132 ++++++++++++++++++++++-------------------------
 1 file changed, 64 insertions(+), 68 deletions(-)

diff -puN kernel/sched.c~sched-domain-move-sched-group-allocations-to-percpu-area kernel/sched.c
--- a/kernel/sched.c~sched-domain-move-sched-group-allocations-to-percpu-area
+++ a/kernel/sched.c
@@ -5528,28 +5528,27 @@ static int __init isolated_cpu_setup(cha
 __setup ("isolcpus=", isolated_cpu_setup);
 
 /*
- * init_sched_build_groups takes an array of groups, the cpumask we wish
- * to span, and a pointer to a function which identifies what group a CPU
- * belongs to. The return value of group_fn must be a valid index into the
- * groups[] array, and must be >= 0 and < NR_CPUS (due to the fact that we
- * keep track of groups covered with a cpumask_t).
+ * init_sched_build_groups takes the cpumask we wish to span, and a pointer
+ * to a function which identifies what group(along with sched group) a CPU
+ * belongs to. The return value of group_fn must be a >= 0 and < NR_CPUS
+ * (due to the fact that we keep track of groups covered with a cpumask_t).
  *
  * init_sched_build_groups will build a circular linked list of the groups
  * covered by the given span, and will set each group's ->cpumask correctly,
  * and ->cpu_power to 0.
  */
 static void
-init_sched_build_groups(struct sched_group groups[], cpumask_t span,
-			const cpumask_t *cpu_map,
-			int (*group_fn)(int cpu, const cpumask_t *cpu_map))
+init_sched_build_groups(cpumask_t span, const cpumask_t *cpu_map,
+			int (*group_fn)(int cpu, const cpumask_t *cpu_map,
+					struct sched_group **sg))
 {
 	struct sched_group *first = NULL, *last = NULL;
 	cpumask_t covered = CPU_MASK_NONE;
 	int i;
 
 	for_each_cpu_mask(i, span) {
-		int group = group_fn(i, cpu_map);
-		struct sched_group *sg = &groups[group];
+		struct sched_group *sg;
+		int group = group_fn(i, cpu_map, &sg);
 		int j;
 
 		if (cpu_isset(i, covered))
@@ -5559,7 +5558,7 @@ init_sched_build_groups(struct sched_gro
 		sg->cpu_power = 0;
 
 		for_each_cpu_mask(j, span) {
-			if (group_fn(j, cpu_map) != group)
+			if (group_fn(j, cpu_map, NULL) != group)
 				continue;
 
 			cpu_set(j, covered);
@@ -6145,10 +6144,13 @@ int sched_smt_power_savings = 0, sched_m
  */
 #ifdef CONFIG_SCHED_SMT
 static DEFINE_PER_CPU(struct sched_domain, cpu_domains);
-static struct sched_group sched_group_cpus[NR_CPUS];
+static DEFINE_PER_CPU(struct sched_group, sched_group_cpus);
 
-static int cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map)
+static int cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map,
+			    struct sched_group **sg)
 {
+	if (sg)
+		*sg = &per_cpu(sched_group_cpus, cpu);
 	return cpu;
 }
 #endif
@@ -6158,39 +6160,52 @@ static int cpu_to_cpu_group(int cpu, con
  */
 #ifdef CONFIG_SCHED_MC
 static DEFINE_PER_CPU(struct sched_domain, core_domains);
-static struct sched_group sched_group_core[NR_CPUS];
+static DEFINE_PER_CPU(struct sched_group, sched_group_core);
 #endif
 
 #if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
-static int cpu_to_core_group(int cpu, const cpumask_t *cpu_map)
+static int cpu_to_core_group(int cpu, const cpumask_t *cpu_map,
+			     struct sched_group **sg)
 {
+	int group;
 	cpumask_t mask = cpu_sibling_map[cpu];
 	cpus_and(mask, mask, *cpu_map);
-	return first_cpu(mask);
+	group = first_cpu(mask);
+	if (sg)
+		*sg = &per_cpu(sched_group_core, group);
+	return group;
 }
 #elif defined(CONFIG_SCHED_MC)
-static int cpu_to_core_group(int cpu, const cpumask_t *cpu_map)
+static int cpu_to_core_group(int cpu, const cpumask_t *cpu_map,
+			     struct sched_group **sg)
 {
+	if (sg)
+		*sg = &per_cpu(sched_group_core, cpu);
 	return cpu;
 }
 #endif
 
 static DEFINE_PER_CPU(struct sched_domain, phys_domains);
-static struct sched_group sched_group_phys[NR_CPUS];
+static DEFINE_PER_CPU(struct sched_group, sched_group_phys);
 
-static int cpu_to_phys_group(int cpu, const cpumask_t *cpu_map)
+static int cpu_to_phys_group(int cpu, const cpumask_t *cpu_map,
+			     struct sched_group **sg)
 {
+	int group;
 #ifdef CONFIG_SCHED_MC
 	cpumask_t mask = cpu_coregroup_map(cpu);
 	cpus_and(mask, mask, *cpu_map);
-	return first_cpu(mask);
+	group = first_cpu(mask);
 #elif defined(CONFIG_SCHED_SMT)
 	cpumask_t mask = cpu_sibling_map[cpu];
 	cpus_and(mask, mask, *cpu_map);
-	return first_cpu(mask);
+	group = first_cpu(mask);
 #else
-	return cpu;
+	group = cpu;
 #endif
+	if (sg)
+		*sg = &per_cpu(sched_group_phys, group);
+	return group;
 }
 
 #ifdef CONFIG_NUMA
@@ -6203,12 +6218,22 @@ static DEFINE_PER_CPU(struct sched_domai
 static struct sched_group **sched_group_nodes_bycpu[NR_CPUS];
 
 static DEFINE_PER_CPU(struct sched_domain, allnodes_domains);
-static struct sched_group *sched_group_allnodes_bycpu[NR_CPUS];
+static DEFINE_PER_CPU(struct sched_group, sched_group_allnodes);
 
-static int cpu_to_allnodes_group(int cpu, const cpumask_t *cpu_map)
+static int cpu_to_allnodes_group(int cpu, const cpumask_t *cpu_map,
+				 struct sched_group **sg)
 {
-	return cpu_to_node(cpu);
+	cpumask_t nodemask = node_to_cpumask(cpu_to_node(cpu));
+	int group;
+
+	cpus_and(nodemask, nodemask, *cpu_map);
+	group = first_cpu(nodemask);
+
+	if (sg)
+		*sg = &per_cpu(sched_group_allnodes, group);
+	return group;
 }
+
 static void init_numa_sched_groups_power(struct sched_group *group_head)
 {
 	struct sched_group *sg = group_head;
@@ -6244,16 +6269,9 @@ static void free_sched_groups(const cpum
 	int cpu, i;
 
 	for_each_cpu_mask(cpu, *cpu_map) {
-		struct sched_group *sched_group_allnodes
-			= sched_group_allnodes_bycpu[cpu];
 		struct sched_group **sched_group_nodes
 			= sched_group_nodes_bycpu[cpu];
 
-		if (sched_group_allnodes) {
-			kfree(sched_group_allnodes);
-			sched_group_allnodes_bycpu[cpu] = NULL;
-		}
-
 		if (!sched_group_nodes)
 			continue;
 
@@ -6347,7 +6365,7 @@ static int build_sched_domains(const cpu
 	struct sched_domain *sd;
 #ifdef CONFIG_NUMA
 	struct sched_group **sched_group_nodes = NULL;
-	struct sched_group *sched_group_allnodes = NULL;
+	int sd_allnodes = 0;
 
 	/*
 	 * Allocate the per-node list of sched groups
@@ -6365,7 +6383,6 @@ static int build_sched_domains(const cpu
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
 	for_each_cpu_mask(i, *cpu_map) {
-		int group;
 		struct sched_domain *sd = NULL, *p;
 		cpumask_t nodemask = node_to_cpumask(cpu_to_node(i));
 
@@ -6374,26 +6391,12 @@ static int build_sched_domains(const cpu
 #ifdef CONFIG_NUMA
 		if (cpus_weight(*cpu_map)
 				> SD_NODES_PER_DOMAIN*cpus_weight(nodemask)) {
-			if (!sched_group_allnodes) {
-				sched_group_allnodes
-					= kmalloc_node(sizeof(struct sched_group)
-						  	* MAX_NUMNODES,
-						  GFP_KERNEL,
-						  cpu_to_node(i));
-				if (!sched_group_allnodes) {
-					printk(KERN_WARNING
-					"Can not alloc allnodes sched group\n");
-					goto error;
-				}
-				sched_group_allnodes_bycpu[i]
-						= sched_group_allnodes;
-			}
 			sd = &per_cpu(allnodes_domains, i);
 			*sd = SD_ALLNODES_INIT;
 			sd->span = *cpu_map;
-			group = cpu_to_allnodes_group(i, cpu_map);
-			sd->groups = &sched_group_allnodes[group];
+			cpu_to_allnodes_group(i, cpu_map, &sd->groups);
 			p = sd;
+			sd_allnodes = 1;
 		} else
 			p = NULL;
 
@@ -6408,36 +6411,33 @@ static int build_sched_domains(const cpu
 
 		p = sd;
 		sd = &per_cpu(phys_domains, i);
-		group = cpu_to_phys_group(i, cpu_map);
 		*sd = SD_CPU_INIT;
 		sd->span = nodemask;
 		sd->parent = p;
 		if (p)
 			p->child = sd;
-		sd->groups = &sched_group_phys[group];
+		cpu_to_phys_group(i, cpu_map, &sd->groups);
 
 #ifdef CONFIG_SCHED_MC
 		p = sd;
 		sd = &per_cpu(core_domains, i);
-		group = cpu_to_core_group(i, cpu_map);
 		*sd = SD_MC_INIT;
 		sd->span = cpu_coregroup_map(i);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
-		sd->groups = &sched_group_core[group];
+		cpu_to_core_group(i, cpu_map, &sd->groups);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
 		p = sd;
 		sd = &per_cpu(cpu_domains, i);
-		group = cpu_to_cpu_group(i, cpu_map);
 		*sd = SD_SIBLING_INIT;
 		sd->span = cpu_sibling_map[i];
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
-		sd->groups = &sched_group_cpus[group];
+		cpu_to_cpu_group(i, cpu_map, &sd->groups);
 #endif
 	}
 
@@ -6449,8 +6449,7 @@ static int build_sched_domains(const cpu
 		if (i != first_cpu(this_sibling_map))
 			continue;
 
-		init_sched_build_groups(sched_group_cpus, this_sibling_map,
-					cpu_map, &cpu_to_cpu_group);
+		init_sched_build_groups(this_sibling_map, cpu_map, &cpu_to_cpu_group);
 	}
 #endif
 
@@ -6461,8 +6460,7 @@ static int build_sched_domains(const cpu
 		cpus_and(this_core_map, this_core_map, *cpu_map);
 		if (i != first_cpu(this_core_map))
 			continue;
-		init_sched_build_groups(sched_group_core, this_core_map,
-					cpu_map, &cpu_to_core_group);
+		init_sched_build_groups(this_core_map, cpu_map, &cpu_to_core_group);
 	}
 #endif
 
@@ -6475,15 +6473,13 @@ static int build_sched_domains(const cpu
 		if (cpus_empty(nodemask))
 			continue;
 
-		init_sched_build_groups(sched_group_phys, nodemask,
-					cpu_map, &cpu_to_phys_group);
+		init_sched_build_groups(nodemask, cpu_map, &cpu_to_phys_group);
 	}
 
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
-	if (sched_group_allnodes)
-		init_sched_build_groups(sched_group_allnodes, *cpu_map,
-					cpu_map, &cpu_to_allnodes_group);
+	if (sd_allnodes)
+		init_sched_build_groups(*cpu_map, cpu_map, &cpu_to_allnodes_group);
 
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		/* Set up node groups */
@@ -6575,10 +6571,10 @@ static int build_sched_domains(const cpu
 	for (i = 0; i < MAX_NUMNODES; i++)
 		init_numa_sched_groups_power(sched_group_nodes[i]);
 
-	if (sched_group_allnodes) {
-		int group = cpu_to_allnodes_group(first_cpu(*cpu_map), cpu_map);
-		struct sched_group *sg = &sched_group_allnodes[group];
+	if (sd_allnodes) {
+		struct sched_group *sg;
 
+		cpu_to_allnodes_group(first_cpu(*cpu_map), cpu_map, &sg);
 		init_numa_sched_groups_power(sg);
 	}
 #endif
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
optimize-calc_load.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

