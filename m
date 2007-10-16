From: akpm@linux-foundation.org
Subject: - convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:11 -0700
Message-ID: <200710162030.l9GKUBUj014384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935199AbXJPUa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:30:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, ak@suse.de, benh@kernel.crashing.org, clameter@sgi.com, davem@davemloft.net, paulus@samba.org, suresh.b.siddha@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Convert cpu_sibling_map to be a per cpu variable 
has been removed from the -mm tree.  Its filename was
     convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Convert cpu_sibling_map to be a per cpu variable 
From: Mike Travis <travis@sgi.com>

Convert cpu_sibling_map from a static array sized by NR_CPUS to a per_cpu
variable.  This saves sizeof(cpumask_t) * NR unused cpus.  Access is mostly
from startup and CPU HOTPLUG functions.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/setup.c                    |   12 ++++--
 arch/ia64/kernel/smpboot.c                  |   18 +++++----
 arch/powerpc/kernel/setup-common.c          |   20 ++++++++--
 arch/powerpc/kernel/setup_64.c              |    3 +
 arch/powerpc/kernel/smp.c                   |    4 +-
 arch/powerpc/platforms/cell/cbe_cpufreq.c   |    2 -
 arch/sparc64/kernel/smp.c                   |   17 ++++----
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c   |    2 -
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c |    2 -
 arch/x86/kernel/io_apic_32.c                |    4 +-
 arch/x86/kernel/smpboot_32.c                |   36 +++++++++---------
 arch/x86/kernel/smpboot_64.c                |   26 ++++++-------
 arch/x86/oprofile/op_model_p4.c             |    2 -
 arch/x86/xen/smp.c                          |    4 +-
 block/blktrace.c                            |    2 -
 include/asm-ia64/smp.h                      |    2 -
 include/asm-ia64/topology.h                 |    2 -
 include/asm-powerpc/smp.h                   |    4 +-
 include/asm-powerpc/topology.h              |    2 -
 include/asm-sparc64/smp.h                   |    3 +
 include/asm-sparc64/topology.h              |    2 -
 include/asm-x86/smp_32.h                    |    2 -
 include/asm-x86/smp_64.h                    |    6 ++-
 include/asm-x86/topology_32.h               |    2 -
 include/asm-x86/topology_64.h               |    2 -
 kernel/sched.c                              |    8 ++--
 26 files changed, 107 insertions(+), 82 deletions(-)

diff -puN arch/ia64/kernel/setup.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/ia64/kernel/setup.c
@@ -528,10 +528,6 @@ setup_arch (char **cmdline_p)
 
 #ifdef CONFIG_SMP
 	cpu_physical_id(0) = hard_smp_processor_id();
-
-	cpu_set(0, cpu_sibling_map[0]);
-	cpu_set(0, cpu_core_map[0]);
-
 	check_for_logical_procs();
 	if (smp_num_cpucores > 1)
 		printk(KERN_INFO
@@ -873,6 +869,14 @@ cpu_init (void)
 	void *cpu_data;
 
 	cpu_data = per_cpu_init();
+	/*
+	 * insert boot cpu into sibling and core mapes
+	 * (must be done after per_cpu area is setup)
+	 */
+	if (smp_processor_id() == 0) {
+		cpu_set(0, per_cpu(cpu_sibling_map, 0));
+		cpu_set(0, cpu_core_map[0]);
+	}
 
 	/*
 	 * We set ar.k3 so that assembly code in MCA handler can compute
diff -puN arch/ia64/kernel/smpboot.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/ia64/kernel/smpboot.c
@@ -138,7 +138,9 @@ cpumask_t cpu_possible_map = CPU_MASK_NO
 EXPORT_SYMBOL(cpu_possible_map);
 
 cpumask_t cpu_core_map[NR_CPUS] __cacheline_aligned;
-cpumask_t cpu_sibling_map[NR_CPUS] __cacheline_aligned;
+DEFINE_PER_CPU_SHARED_ALIGNED(cpumask_t, cpu_sibling_map);
+EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
+
 int smp_num_siblings = 1;
 int smp_num_cpucores = 1;
 
@@ -650,12 +652,12 @@ clear_cpu_sibling_map(int cpu)
 {
 	int i;
 
-	for_each_cpu_mask(i, cpu_sibling_map[cpu])
-		cpu_clear(cpu, cpu_sibling_map[i]);
+	for_each_cpu_mask(i, per_cpu(cpu_sibling_map, cpu))
+		cpu_clear(cpu, per_cpu(cpu_sibling_map, i));
 	for_each_cpu_mask(i, cpu_core_map[cpu])
 		cpu_clear(cpu, cpu_core_map[i]);
 
-	cpu_sibling_map[cpu] = cpu_core_map[cpu] = CPU_MASK_NONE;
+	per_cpu(cpu_sibling_map, cpu) = cpu_core_map[cpu] = CPU_MASK_NONE;
 }
 
 static void
@@ -666,7 +668,7 @@ remove_siblinginfo(int cpu)
 	if (cpu_data(cpu)->threads_per_core == 1 &&
 	    cpu_data(cpu)->cores_per_socket == 1) {
 		cpu_clear(cpu, cpu_core_map[cpu]);
-		cpu_clear(cpu, cpu_sibling_map[cpu]);
+		cpu_clear(cpu, per_cpu(cpu_sibling_map, cpu));
 		return;
 	}
 
@@ -807,8 +809,8 @@ set_cpu_sibling_map(int cpu)
 			cpu_set(i, cpu_core_map[cpu]);
 			cpu_set(cpu, cpu_core_map[i]);
 			if (cpu_data(cpu)->core_id == cpu_data(i)->core_id) {
-				cpu_set(i, cpu_sibling_map[cpu]);
-				cpu_set(cpu, cpu_sibling_map[i]);
+				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
+				cpu_set(cpu, per_cpu(cpu_sibling_map, i));
 			}
 		}
 	}
@@ -839,7 +841,7 @@ __cpu_up (unsigned int cpu)
 
 	if (cpu_data(cpu)->threads_per_core == 1 &&
 	    cpu_data(cpu)->cores_per_socket == 1) {
-		cpu_set(cpu, cpu_sibling_map[cpu]);
+		cpu_set(cpu, per_cpu(cpu_sibling_map, cpu));
 		cpu_set(cpu, cpu_core_map[cpu]);
 		return 0;
 	}
diff -puN arch/powerpc/kernel/setup-common.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/powerpc/kernel/setup-common.c
@@ -413,16 +413,28 @@ void __init smp_setup_cpu_maps(void)
 		of_node_put(dn);
 	}
 
+	vdso_data->processorCount = num_present_cpus();
+#endif /* CONFIG_PPC64 */
+}
+
+/*
+ * Being that cpu_sibling_map is now a per_cpu array, then it cannot
+ * be initialized until the per_cpu areas have been created.  This
+ * function is now called from setup_per_cpu_areas().
+ */
+void __init smp_setup_cpu_sibling_map(void)
+{
+#if defined(CONFIG_PPC64)
+	int cpu;
+
 	/*
 	 * Do the sibling map; assume only two threads per processor.
 	 */
 	for_each_possible_cpu(cpu) {
-		cpu_set(cpu, cpu_sibling_map[cpu]);
+		cpu_set(cpu, per_cpu(cpu_sibling_map, cpu));
 		if (cpu_has_feature(CPU_FTR_SMT))
-			cpu_set(cpu ^ 0x1, cpu_sibling_map[cpu]);
+			cpu_set(cpu ^ 0x1, per_cpu(cpu_sibling_map, cpu));
 	}
-
-	vdso_data->processorCount = num_present_cpus();
 #endif /* CONFIG_PPC64 */
 }
 #endif /* CONFIG_SMP */
diff -puN arch/powerpc/kernel/setup_64.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/powerpc/kernel/setup_64.c
@@ -597,6 +597,9 @@ void __init setup_per_cpu_areas(void)
 		paca[i].data_offset = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 	}
+
+	/* Now that per_cpu is setup, initialize cpu_sibling_map */
+	smp_setup_cpu_sibling_map();
 }
 #endif
 
diff -puN arch/powerpc/kernel/smp.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/powerpc/kernel/smp.c
@@ -61,11 +61,11 @@ struct thread_info *secondary_ti;
 
 cpumask_t cpu_possible_map = CPU_MASK_NONE;
 cpumask_t cpu_online_map = CPU_MASK_NONE;
-cpumask_t cpu_sibling_map[NR_CPUS] = { [0 ... NR_CPUS-1] = CPU_MASK_NONE };
+DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
 
 EXPORT_SYMBOL(cpu_online_map);
 EXPORT_SYMBOL(cpu_possible_map);
-EXPORT_SYMBOL(cpu_sibling_map);
+EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 
 /* SMP operations for this machine */
 struct smp_ops_t *smp_ops;
diff -puN arch/powerpc/platforms/cell/cbe_cpufreq.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/powerpc/platforms/cell/cbe_cpufreq.c
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -117,7 +117,7 @@ static int cbe_cpufreq_cpu_init(struct c
 	policy->cur = cbe_freqs[cur_pmode].frequency;
 
 #ifdef CONFIG_SMP
-	policy->cpus = cpu_sibling_map[policy->cpu];
+	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
 #endif
 
 	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
diff -puN arch/sparc64/kernel/smp.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/sparc64/kernel/smp.c
--- a/arch/sparc64/kernel/smp.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/sparc64/kernel/smp.c
@@ -52,14 +52,13 @@ int sparc64_multi_core __read_mostly;
 
 cpumask_t cpu_possible_map __read_mostly = CPU_MASK_NONE;
 cpumask_t cpu_online_map __read_mostly = CPU_MASK_NONE;
-cpumask_t cpu_sibling_map[NR_CPUS] __read_mostly =
-	{ [0 ... NR_CPUS-1] = CPU_MASK_NONE };
+DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
 cpumask_t cpu_core_map[NR_CPUS] __read_mostly =
 	{ [0 ... NR_CPUS-1] = CPU_MASK_NONE };
 
 EXPORT_SYMBOL(cpu_possible_map);
 EXPORT_SYMBOL(cpu_online_map);
-EXPORT_SYMBOL(cpu_sibling_map);
+EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 EXPORT_SYMBOL(cpu_core_map);
 
 static cpumask_t smp_commenced_mask;
@@ -1261,16 +1260,16 @@ void __devinit smp_fill_in_sib_core_maps
 	for_each_present_cpu(i) {
 		unsigned int j;
 
-		cpus_clear(cpu_sibling_map[i]);
+		cpus_clear(per_cpu(cpu_sibling_map, i));
 		if (cpu_data(i).proc_id == -1) {
-			cpu_set(i, cpu_sibling_map[i]);
+			cpu_set(i, per_cpu(cpu_sibling_map, i));
 			continue;
 		}
 
 		for_each_present_cpu(j) {
 			if (cpu_data(i).proc_id ==
 			    cpu_data(j).proc_id)
-				cpu_set(j, cpu_sibling_map[i]);
+				cpu_set(j, per_cpu(cpu_sibling_map, i));
 		}
 	}
 }
@@ -1342,9 +1341,9 @@ int __cpu_disable(void)
 		cpu_clear(cpu, cpu_core_map[i]);
 	cpus_clear(cpu_core_map[cpu]);
 
-	for_each_cpu_mask(i, cpu_sibling_map[cpu])
-		cpu_clear(cpu, cpu_sibling_map[i]);
-	cpus_clear(cpu_sibling_map[cpu]);
+	for_each_cpu_mask(i, per_cpu(cpu_sibling_map, cpu))
+		cpu_clear(cpu, per_cpu(cpu_sibling_map, i));
+	cpus_clear(per_cpu(cpu_sibling_map, cpu));
 
 	c = &cpu_data(cpu);
 
diff -puN arch/x86/kernel/cpu/cpufreq/p4-clockmod.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -200,7 +200,7 @@ static int cpufreq_p4_cpu_init(struct cp
 	unsigned int i;
 
 #ifdef CONFIG_SMP
-	policy->cpus = cpu_sibling_map[policy->cpu];
+	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
 #endif
 
 	/* Errata workaround */
diff -puN arch/x86/kernel/cpu/cpufreq/speedstep-ich.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -322,7 +322,7 @@ static int speedstep_cpu_init(struct cpu
 
 	/* only run on CPU to be set, or on its sibling */
 #ifdef CONFIG_SMP
-	policy->cpus = cpu_sibling_map[policy->cpu];
+	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
 #endif
 
 	cpus_allowed = current->cpus_allowed;
diff -puN arch/x86/kernel/io_apic_32.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/x86/kernel/io_apic_32.c
--- a/arch/x86/kernel/io_apic_32.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/x86/kernel/io_apic_32.c
@@ -378,7 +378,7 @@ static struct irq_cpu_info {
 
 #define IRQ_ALLOWED(cpu, allowed_mask)	cpu_isset(cpu, allowed_mask)
 
-#define CPU_TO_PACKAGEINDEX(i) (first_cpu(cpu_sibling_map[i]))
+#define CPU_TO_PACKAGEINDEX(i) (first_cpu(per_cpu(cpu_sibling_map, i)))
 
 static cpumask_t balance_irq_affinity[NR_IRQS] = {
 	[0 ... NR_IRQS-1] = CPU_MASK_ALL
@@ -598,7 +598,7 @@ tryanotherirq:
 	 * (A+B)/2 vs B
 	 */
 	load = CPU_IRQ(min_loaded) >> 1;
-	for_each_cpu_mask(j, cpu_sibling_map[min_loaded]) {
+	for_each_cpu_mask(j, per_cpu(cpu_sibling_map, min_loaded)) {
 		if (load > CPU_IRQ(j)) {
 			/* This won't change cpu_sibling_map[min_loaded] */
 			load = CPU_IRQ(j);
diff -puN arch/x86/kernel/smpboot_32.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/x86/kernel/smpboot_32.c
--- a/arch/x86/kernel/smpboot_32.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/x86/kernel/smpboot_32.c
@@ -70,8 +70,8 @@ EXPORT_SYMBOL(smp_num_siblings);
 int cpu_llc_id[NR_CPUS] __cpuinitdata = {[0 ... NR_CPUS-1] = BAD_APICID};
 
 /* representing HT siblings of each logical CPU */
-cpumask_t cpu_sibling_map[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(cpu_sibling_map);
+DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
+EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 
 /* representing HT and core siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_t, cpu_core_map);
@@ -319,8 +319,8 @@ void __cpuinit set_cpu_sibling_map(int c
 		for_each_cpu_mask(i, cpu_sibling_setup_map) {
 			if (c[cpu].phys_proc_id == c[i].phys_proc_id &&
 			    c[cpu].cpu_core_id == c[i].cpu_core_id) {
-				cpu_set(i, cpu_sibling_map[cpu]);
-				cpu_set(cpu, cpu_sibling_map[i]);
+				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
+				cpu_set(cpu, per_cpu(cpu_sibling_map, i));
 				cpu_set(i, per_cpu(cpu_core_map, cpu));
 				cpu_set(cpu, per_cpu(cpu_core_map, i));
 				cpu_set(i, c[cpu].llc_shared_map);
@@ -328,13 +328,13 @@ void __cpuinit set_cpu_sibling_map(int c
 			}
 		}
 	} else {
-		cpu_set(cpu, cpu_sibling_map[cpu]);
+		cpu_set(cpu, per_cpu(cpu_sibling_map, cpu));
 	}
 
 	cpu_set(cpu, c[cpu].llc_shared_map);
 
 	if (current_cpu_data.x86_max_cores == 1) {
-		per_cpu(cpu_core_map, cpu) = cpu_sibling_map[cpu];
+		per_cpu(cpu_core_map, cpu) = per_cpu(cpu_sibling_map, cpu);
 		c[cpu].booted_cores = 1;
 		return;
 	}
@@ -351,12 +351,12 @@ void __cpuinit set_cpu_sibling_map(int c
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
-			if (cpus_weight(cpu_sibling_map[cpu]) == 1) {
+			if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1) {
 				/*
 				 * for each core in package, increment
 				 * the booted_cores for this new cpu
 				 */
-				if (first_cpu(cpu_sibling_map[i]) == i)
+				if (first_cpu(per_cpu(cpu_sibling_map, i)) == i)
 					c[cpu].booted_cores++;
 				/*
 				 * increment the core count for all
@@ -983,7 +983,7 @@ static void __init smp_boot_cpus(unsigne
 			printk(KERN_NOTICE "Local APIC not detected."
 					   " Using dummy APIC emulation.\n");
 		map_cpu_to_logical_apicid();
-		cpu_set(0, cpu_sibling_map[0]);
+		cpu_set(0, per_cpu(cpu_sibling_map, 0));
 		cpu_set(0, per_cpu(cpu_core_map, 0));
 		return;
 	}
@@ -1008,7 +1008,7 @@ static void __init smp_boot_cpus(unsigne
 		printk(KERN_ERR "... forcing use of dummy APIC emulation. (tell your hw vendor)\n");
 		smpboot_clear_io_apic_irqs();
 		phys_cpu_present_map = physid_mask_of_physid(0);
-		cpu_set(0, cpu_sibling_map[0]);
+		cpu_set(0, per_cpu(cpu_sibling_map, 0));
 		cpu_set(0, per_cpu(cpu_core_map, 0));
 		return;
 	}
@@ -1023,7 +1023,7 @@ static void __init smp_boot_cpus(unsigne
 		printk(KERN_INFO "SMP mode deactivated, forcing use of dummy APIC emulation.\n");
 		smpboot_clear_io_apic_irqs();
 		phys_cpu_present_map = physid_mask_of_physid(0);
-		cpu_set(0, cpu_sibling_map[0]);
+		cpu_set(0, per_cpu(cpu_sibling_map, 0));
 		cpu_set(0, per_cpu(cpu_core_map, 0));
 		return;
 	}
@@ -1102,15 +1102,15 @@ static void __init smp_boot_cpus(unsigne
 	Dprintk("Boot done.\n");
 
 	/*
-	 * construct cpu_sibling_map[], so that we can tell sibling CPUs
+	 * construct cpu_sibling_map, so that we can tell sibling CPUs
 	 * efficiently.
 	 */
 	for (cpu = 0; cpu < NR_CPUS; cpu++) {
-		cpus_clear(cpu_sibling_map[cpu]);
+		cpus_clear(per_cpu(cpu_sibling_map, cpu));
 		cpus_clear(per_cpu(cpu_core_map, cpu));
 	}
 
-	cpu_set(0, cpu_sibling_map[0]);
+	cpu_set(0, per_cpu(cpu_sibling_map, 0));
 	cpu_set(0, per_cpu(cpu_core_map, 0));
 
 	smpboot_setup_io_apic();
@@ -1153,13 +1153,13 @@ void remove_siblinginfo(int cpu)
 		/*/
 		 * last thread sibling in this cpu core going down
 		 */
-		if (cpus_weight(cpu_sibling_map[cpu]) == 1)
+		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
 			c[sibling].booted_cores--;
 	}
 			
-	for_each_cpu_mask(sibling, cpu_sibling_map[cpu])
-		cpu_clear(cpu, cpu_sibling_map[sibling]);
-	cpus_clear(cpu_sibling_map[cpu]);
+	for_each_cpu_mask(sibling, per_cpu(cpu_sibling_map, cpu))
+		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
+	cpus_clear(per_cpu(cpu_sibling_map, cpu));
 	cpus_clear(per_cpu(cpu_core_map, cpu));
 	c[cpu].phys_proc_id = 0;
 	c[cpu].cpu_core_id = 0;
diff -puN arch/x86/kernel/smpboot_64.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/x86/kernel/smpboot_64.c
--- a/arch/x86/kernel/smpboot_64.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/x86/kernel/smpboot_64.c
@@ -91,8 +91,8 @@ EXPORT_SYMBOL(cpu_data);
 int smp_threads_ready;
 
 /* representing HT siblings of each logical CPU */
-cpumask_t cpu_sibling_map[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(cpu_sibling_map);
+DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
+EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 
 /* representing HT and core siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_t, cpu_core_map);
@@ -262,8 +262,8 @@ static inline void set_cpu_sibling_map(i
 		for_each_cpu_mask(i, cpu_sibling_setup_map) {
 			if (c[cpu].phys_proc_id == c[i].phys_proc_id &&
 			    c[cpu].cpu_core_id == c[i].cpu_core_id) {
-				cpu_set(i, cpu_sibling_map[cpu]);
-				cpu_set(cpu, cpu_sibling_map[i]);
+				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
+				cpu_set(cpu, per_cpu(cpu_sibling_map, i));
 				cpu_set(i, per_cpu(cpu_core_map, cpu));
 				cpu_set(cpu, per_cpu(cpu_core_map, i));
 				cpu_set(i, c[cpu].llc_shared_map);
@@ -271,13 +271,13 @@ static inline void set_cpu_sibling_map(i
 			}
 		}
 	} else {
-		cpu_set(cpu, cpu_sibling_map[cpu]);
+		cpu_set(cpu, per_cpu(cpu_sibling_map, cpu));
 	}
 
 	cpu_set(cpu, c[cpu].llc_shared_map);
 
 	if (current_cpu_data.x86_max_cores == 1) {
-		per_cpu(cpu_core_map, cpu) = cpu_sibling_map[cpu];
+		per_cpu(cpu_core_map, cpu) = per_cpu(cpu_sibling_map, cpu);
 		c[cpu].booted_cores = 1;
 		return;
 	}
@@ -294,12 +294,12 @@ static inline void set_cpu_sibling_map(i
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
-			if (cpus_weight(cpu_sibling_map[cpu]) == 1) {
+			if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1) {
 				/*
 				 * for each core in package, increment
 				 * the booted_cores for this new cpu
 				 */
-				if (first_cpu(cpu_sibling_map[i]) == i)
+				if (first_cpu(per_cpu(cpu_sibling_map, i)) == i)
 					c[cpu].booted_cores++;
 				/*
 				 * increment the core count for all
@@ -735,7 +735,7 @@ static __init void disable_smp(void)
 		phys_cpu_present_map = physid_mask_of_physid(boot_cpu_id);
 	else
 		phys_cpu_present_map = physid_mask_of_physid(0);
-	cpu_set(0, cpu_sibling_map[0]);
+	cpu_set(0, per_cpu(cpu_sibling_map, 0));
 	cpu_set(0, per_cpu(cpu_core_map, 0));
 }
 
@@ -976,13 +976,13 @@ static void remove_siblinginfo(int cpu)
 		/*
 		 * last thread sibling in this cpu core going down
 		 */
-		if (cpus_weight(cpu_sibling_map[cpu]) == 1)
+		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
 			c[sibling].booted_cores--;
 	}
 			
-	for_each_cpu_mask(sibling, cpu_sibling_map[cpu])
-		cpu_clear(cpu, cpu_sibling_map[sibling]);
-	cpus_clear(cpu_sibling_map[cpu]);
+	for_each_cpu_mask(sibling, per_cpu(cpu_sibling_map, cpu))
+		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
+	cpus_clear(per_cpu(cpu_sibling_map, cpu));
 	cpus_clear(per_cpu(cpu_core_map, cpu));
 	c[cpu].phys_proc_id = 0;
 	c[cpu].cpu_core_id = 0;
diff -puN arch/x86/oprofile/op_model_p4.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/x86/oprofile/op_model_p4.c
--- a/arch/x86/oprofile/op_model_p4.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/x86/oprofile/op_model_p4.c
@@ -379,7 +379,7 @@ static unsigned int get_stagger(void)
 {
 #ifdef CONFIG_SMP
 	int cpu = smp_processor_id();
-	return (cpu != first_cpu(cpu_sibling_map[cpu]));
+	return (cpu != first_cpu(per_cpu(cpu_sibling_map, cpu)));
 #endif	
 	return 0;
 }
diff -puN arch/x86/xen/smp.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/arch/x86/xen/smp.c
@@ -147,7 +147,7 @@ void __init xen_smp_prepare_boot_cpu(voi
 	make_lowmem_page_readwrite(&per_cpu__gdt_page);
 
 	for (cpu = 0; cpu < NR_CPUS; cpu++) {
-		cpus_clear(cpu_sibling_map[cpu]);
+		cpus_clear(per_cpu(cpu_sibling_map, cpu));
 		/*
 		 * cpu_core_map lives in a per cpu area that is cleared
 		 * when the per cpu array is allocated.
@@ -164,7 +164,7 @@ void __init xen_smp_prepare_cpus(unsigne
 	unsigned cpu;
 
 	for (cpu = 0; cpu < NR_CPUS; cpu++) {
-		cpus_clear(cpu_sibling_map[cpu]);
+		cpus_clear(per_cpu(cpu_sibling_map, cpu));
 		/*
 		 * cpu_core_ map will be zeroed when the per
 		 * cpu area is allocated.
diff -puN block/blktrace.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable block/blktrace.c
--- a/block/blktrace.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/block/blktrace.c
@@ -550,7 +550,7 @@ static void blk_trace_set_ht_offsets(voi
 	for_each_online_cpu(cpu) {
 		unsigned long long *cpu_off, *sibling_off;
 
-		for_each_cpu_mask(i, cpu_sibling_map[cpu]) {
+		for_each_cpu_mask(i, per_cpu(cpu_sibling_map, cpu)) {
 			if (i == cpu)
 				continue;
 
diff -puN include/asm-ia64/smp.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable include/asm-ia64/smp.h
--- a/include/asm-ia64/smp.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/include/asm-ia64/smp.h
@@ -58,7 +58,7 @@ extern char no_int_routing __devinitdata
 
 extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_core_map[NR_CPUS];
-extern cpumask_t cpu_sibling_map[NR_CPUS];
+DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 extern int smp_num_siblings;
 extern int smp_num_cpucores;
 extern void __iomem *ipi_base_addr;
diff -puN include/asm-ia64/topology.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable include/asm-ia64/topology.h
--- a/include/asm-ia64/topology.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/include/asm-ia64/topology.h
@@ -112,7 +112,7 @@ void build_cpu_to_node_map(void);
 #define topology_physical_package_id(cpu)	(cpu_data(cpu)->socket_id)
 #define topology_core_id(cpu)			(cpu_data(cpu)->core_id)
 #define topology_core_siblings(cpu)		(cpu_core_map[cpu])
-#define topology_thread_siblings(cpu)		(cpu_sibling_map[cpu])
+#define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #define smt_capable() 				(smp_num_siblings > 1)
 #endif
 
diff -puN include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable include/asm-powerpc/smp.h
--- a/include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/include/asm-powerpc/smp.h
@@ -26,6 +26,7 @@
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
 #endif
+#include <asm/percpu.h>
 
 extern int boot_cpuid;
 
@@ -58,7 +59,7 @@ extern int smp_hw_index[];
 					(smp_hw_index[(cpu)] = (phys))
 #endif
 
-extern cpumask_t cpu_sibling_map[NR_CPUS];
+DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 
 /* Since OpenPIC has only 4 IPIs, we use slightly different message numbers.
  *
@@ -77,6 +78,7 @@ void smp_init_pSeries(void);
 void smp_init_cell(void);
 void smp_init_celleb(void);
 void smp_setup_cpu_maps(void);
+void smp_setup_cpu_sibling_map(void);
 
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
diff -puN include/asm-powerpc/topology.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable include/asm-powerpc/topology.h
--- a/include/asm-powerpc/topology.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/include/asm-powerpc/topology.h
@@ -108,7 +108,7 @@ static inline void sysfs_remove_device_f
 #ifdef CONFIG_PPC64
 #include <asm/smp.h>
 
-#define topology_thread_siblings(cpu)	(cpu_sibling_map[cpu])
+#define topology_thread_siblings(cpu)	(per_cpu(cpu_sibling_map, cpu))
 #endif
 #endif
 
diff -puN include/asm-sparc64/smp.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable include/asm-sparc64/smp.h
--- a/include/asm-sparc64/smp.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/include/asm-sparc64/smp.h
@@ -28,8 +28,9 @@
  
 #include <asm/bitops.h>
 #include <asm/atomic.h>
+#include <asm/percpu.h>
 
-extern cpumask_t cpu_sibling_map[NR_CPUS];
+DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 extern cpumask_t cpu_core_map[NR_CPUS];
 extern int sparc64_multi_core;
 
diff -puN include/asm-sparc64/topology.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable include/asm-sparc64/topology.h
--- a/include/asm-sparc64/topology.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/include/asm-sparc64/topology.h
@@ -5,7 +5,7 @@
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).core_id)
 #define topology_core_siblings(cpu)		(cpu_core_map[cpu])
-#define topology_thread_siblings(cpu)		(cpu_sibling_map[cpu])
+#define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #define mc_capable()				(sparc64_multi_core)
 #define smt_capable()				(sparc64_multi_core)
 #endif /* CONFIG_SMP */
diff -puN include/asm-x86/smp_32.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable include/asm-x86/smp_32.h
--- a/include/asm-x86/smp_32.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/include/asm-x86/smp_32.h
@@ -30,7 +30,7 @@
 extern void smp_alloc_memory(void);
 extern int pic_mode;
 extern int smp_num_siblings;
-extern cpumask_t cpu_sibling_map[];
+DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 
 extern void (*mtrr_hook) (void);
diff -puN include/asm-x86/smp_64.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable include/asm-x86/smp_64.h
--- a/include/asm-x86/smp_64.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/include/asm-x86/smp_64.h
@@ -38,12 +38,14 @@ extern void unlock_ipi_call_lock(void);
 extern int smp_num_siblings;
 extern void smp_send_reschedule(int cpu);
 
-extern cpumask_t cpu_sibling_map[NR_CPUS];
 /*
- * cpu_core_map lives in a per cpu area
+ * cpu_sibling_map and cpu_core_map now live
+ * in the per cpu area
  *
+ * extern cpumask_t cpu_sibling_map[NR_CPUS];
  * extern cpumask_t cpu_core_map[NR_CPUS];
  */
+DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 extern u8 cpu_llc_id[NR_CPUS];
 
diff -puN include/asm-x86/topology_32.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable include/asm-x86/topology_32.h
--- a/include/asm-x86/topology_32.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/include/asm-x86/topology_32.h
@@ -31,7 +31,7 @@
 #define topology_physical_package_id(cpu)	(cpu_data[cpu].phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data[cpu].cpu_core_id)
 #define topology_core_siblings(cpu)		(per_cpu(cpu_core_map, cpu))
-#define topology_thread_siblings(cpu)		(cpu_sibling_map[cpu])
+#define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #endif
 
 #ifdef CONFIG_NUMA
diff -puN include/asm-x86/topology_64.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable include/asm-x86/topology_64.h
--- a/include/asm-x86/topology_64.h~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/include/asm-x86/topology_64.h
@@ -59,7 +59,7 @@ extern int __node_distance(int, int);
 #define topology_physical_package_id(cpu)	(cpu_data[cpu].phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data[cpu].cpu_core_id)
 #define topology_core_siblings(cpu)		(per_cpu(cpu_core_map, cpu))
-#define topology_thread_siblings(cpu)		(cpu_sibling_map[cpu])
+#define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #define mc_capable()			(boot_cpu_data.x86_max_cores > 1)
 #define smt_capable() 			(smp_num_siblings > 1)
 #endif
diff -puN kernel/sched.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable kernel/sched.c
--- a/kernel/sched.c~convert-cpu_sibling_map-to-be-a-per-cpu-variable
+++ a/kernel/sched.c
@@ -5869,7 +5869,7 @@ static int cpu_to_core_group(int cpu, co
 			     struct sched_group **sg)
 {
 	int group;
-	cpumask_t mask = cpu_sibling_map[cpu];
+	cpumask_t mask = per_cpu(cpu_sibling_map, cpu);
 	cpus_and(mask, mask, *cpu_map);
 	group = first_cpu(mask);
 	if (sg)
@@ -5898,7 +5898,7 @@ static int cpu_to_phys_group(int cpu, co
 	cpus_and(mask, mask, *cpu_map);
 	group = first_cpu(mask);
 #elif defined(CONFIG_SCHED_SMT)
-	cpumask_t mask = cpu_sibling_map[cpu];
+	cpumask_t mask = per_cpu(cpu_sibling_map, cpu);
 	cpus_and(mask, mask, *cpu_map);
 	group = first_cpu(mask);
 #else
@@ -6132,7 +6132,7 @@ static int build_sched_domains(const cpu
 		p = sd;
 		sd = &per_cpu(cpu_domains, i);
 		*sd = SD_SIBLING_INIT;
-		sd->span = cpu_sibling_map[i];
+		sd->span = per_cpu(cpu_sibling_map, i);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -6143,7 +6143,7 @@ static int build_sched_domains(const cpu
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
 	for_each_cpu_mask(i, *cpu_map) {
-		cpumask_t this_sibling_map = cpu_sibling_map[i];
+		cpumask_t this_sibling_map = per_cpu(cpu_sibling_map, i);
 		cpus_and(this_sibling_map, this_sibling_map, *cpu_map);
 		if (i != first_cpu(this_sibling_map))
 			continue;
_

Patches currently in -mm which might be from travis@sgi.com are

origin.patch
x86-fix-cpu_to_node-references.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
