From: akpm@linux-foundation.org
Subject: [patch 061/126] treewide: make "nr_cpu_ids" unsigned
Date: Fri, 08 Sep 2017 16:14:18 -0700
Message-ID: <20170908231418.plpN1ZiL0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52554 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757173AbdIHXOU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:14:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: treewide: make "nr_cpu_ids" unsigned

First, number of CPUs can't be negative number.

Second, different signnnedness leads to suboptimal code in the following
cases:

1)
	kmalloc(nr_cpu_ids * sizeof(X));

"int" has to be sign extended to size_t.

2)
	while (loff_t *pos < nr_cpu_ids)

MOVSXD is 1 byte longed than the same MOV.

Other cases exist as well. Basically compiler is told that nr_cpu_ids
can't be negative which can't be deduced if it is "int".

Code savings on allyesconfig kernel: -3KB

	add/remove: 0/0 grow/shrink: 25/264 up/down: 261/-3631 (-3370)
	function                                     old     new   delta
	coretemp_cpu_online                          450     512     +62
	rcu_init_one                                1234    1272     +38
	pci_device_probe                             374     399     +25

				...

	pgdat_reclaimable_pages                      628     556     -72
	select_fallback_rq                           446     369     -77
	task_numa_find_cpu                          1923    1807    -116

Link: http://lkml.kernel.org/r/20170819114959.GA30580@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/smp.c              |    2 +-
 arch/powerpc/kernel/paca.c           |    2 +-
 arch/powerpc/kernel/setup-common.c   |    2 +-
 arch/powerpc/sysdev/xive/native.c    |    4 ++--
 arch/tile/kernel/setup.c             |    2 +-
 arch/x86/kernel/apic/apic.c          |    2 +-
 arch/x86/kernel/setup_percpu.c       |    2 +-
 arch/x86/kernel/smpboot.c            |    2 +-
 drivers/base/cpu.c                   |    4 ++--
 drivers/scsi/scsi_debug.c            |    2 +-
 include/linux/cpumask.h              |    6 +++---
 kernel/rcu/tree.c                    |    2 +-
 kernel/rcu/tree_plugin.h             |    2 +-
 kernel/sched/topology.c              |    2 +-
 kernel/smp.c                         |    2 +-
 kernel/trace/trace_functions_graph.c |    2 +-
 mm/slub.c                            |    2 +-
 17 files changed, 21 insertions(+), 21 deletions(-)

diff -puN arch/arm64/kernel/smp.c~make-nr_cpu_ids-unsigned arch/arm64/kernel/smp.c
--- a/arch/arm64/kernel/smp.c~make-nr_cpu_ids-unsigned
+++ a/arch/arm64/kernel/smp.c
@@ -690,7 +690,7 @@ void __init smp_init_cpus(void)
 				      acpi_parse_gic_cpu_interface, 0);
 
 	if (cpu_count > nr_cpu_ids)
-		pr_warn("Number of cores (%d) exceeds configured maximum of %d - clipping\n",
+		pr_warn("Number of cores (%d) exceeds configured maximum of %u - clipping\n",
 			cpu_count, nr_cpu_ids);
 
 	if (!bootcpu_valid) {
diff -puN arch/powerpc/kernel/paca.c~make-nr_cpu_ids-unsigned arch/powerpc/kernel/paca.c
--- a/arch/powerpc/kernel/paca.c~make-nr_cpu_ids-unsigned
+++ a/arch/powerpc/kernel/paca.c
@@ -224,7 +224,7 @@ void __init allocate_pacas(void)
 	paca = __va(memblock_alloc_base(paca_size, PAGE_SIZE, limit));
 	memset(paca, 0, paca_size);
 
-	printk(KERN_DEBUG "Allocated %u bytes for %d pacas at %p\n",
+	printk(KERN_DEBUG "Allocated %u bytes for %u pacas at %p\n",
 		paca_size, nr_cpu_ids, paca);
 
 	allocate_lppacas(nr_cpu_ids, limit);
diff -puN arch/powerpc/kernel/setup-common.c~make-nr_cpu_ids-unsigned arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c~make-nr_cpu_ids-unsigned
+++ a/arch/powerpc/kernel/setup-common.c
@@ -551,7 +551,7 @@ void __init smp_setup_cpu_maps(void)
 		if (maxcpus > nr_cpu_ids) {
 			printk(KERN_WARNING
 			       "Partition configured for %d cpus, "
-			       "operating system maximum is %d.\n",
+			       "operating system maximum is %u.\n",
 			       maxcpus, nr_cpu_ids);
 			maxcpus = nr_cpu_ids;
 		} else
diff -puN arch/powerpc/sysdev/xive/native.c~make-nr_cpu_ids-unsigned arch/powerpc/sysdev/xive/native.c
--- a/arch/powerpc/sysdev/xive/native.c~make-nr_cpu_ids-unsigned
+++ a/arch/powerpc/sysdev/xive/native.c
@@ -511,13 +511,13 @@ static bool xive_parse_provisioning(stru
 static void xive_native_setup_pools(void)
 {
 	/* Allocate a pool big enough */
-	pr_debug("XIVE: Allocating VP block for pool size %d\n", nr_cpu_ids);
+	pr_debug("XIVE: Allocating VP block for pool size %u\n", nr_cpu_ids);
 
 	xive_pool_vps = xive_native_alloc_vp_block(nr_cpu_ids);
 	if (WARN_ON(xive_pool_vps == XIVE_INVALID_VP))
 		pr_err("XIVE: Failed to allocate pool VP, KVM might not function\n");
 
-	pr_debug("XIVE: Pool VPs allocated at 0x%x for %d max CPUs\n",
+	pr_debug("XIVE: Pool VPs allocated at 0x%x for %u max CPUs\n",
 		 xive_pool_vps, nr_cpu_ids);
 }
 
diff -puN arch/tile/kernel/setup.c~make-nr_cpu_ids-unsigned arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~make-nr_cpu_ids-unsigned
+++ a/arch/tile/kernel/setup.c
@@ -1200,7 +1200,7 @@ static void __init validate_hv(void)
 	 * We use a struct cpumask for this, so it must be big enough.
 	 */
 	if ((smp_height * smp_width) > nr_cpu_ids)
-		early_panic("Hypervisor %d x %d grid too big for Linux NR_CPUS %d\n",
+		early_panic("Hypervisor %d x %d grid too big for Linux NR_CPUS %u\n",
 			    smp_height, smp_width, nr_cpu_ids);
 #endif
 
diff -puN arch/x86/kernel/apic/apic.c~make-nr_cpu_ids-unsigned arch/x86/kernel/apic/apic.c
--- a/arch/x86/kernel/apic/apic.c~make-nr_cpu_ids-unsigned
+++ a/arch/x86/kernel/apic/apic.c
@@ -2097,7 +2097,7 @@ static int allocate_logical_cpuid(int ap
 
 	/* Allocate a new cpuid. */
 	if (nr_logical_cpuids >= nr_cpu_ids) {
-		WARN_ONCE(1, "APIC: NR_CPUS/possible_cpus limit of %i reached. "
+		WARN_ONCE(1, "APIC: NR_CPUS/possible_cpus limit of %u reached. "
 			     "Processor %d/0x%x and the rest are ignored.\n",
 			     nr_cpu_ids, nr_logical_cpuids, apicid);
 		return -EINVAL;
diff -puN arch/x86/kernel/setup_percpu.c~make-nr_cpu_ids-unsigned arch/x86/kernel/setup_percpu.c
--- a/arch/x86/kernel/setup_percpu.c~make-nr_cpu_ids-unsigned
+++ a/arch/x86/kernel/setup_percpu.c
@@ -168,7 +168,7 @@ void __init setup_per_cpu_areas(void)
 	unsigned long delta;
 	int rc;
 
-	pr_info("NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
+	pr_info("NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%u nr_node_ids:%d\n",
 		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
 
 	/*
diff -puN arch/x86/kernel/smpboot.c~make-nr_cpu_ids-unsigned arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~make-nr_cpu_ids-unsigned
+++ a/arch/x86/kernel/smpboot.c
@@ -1461,7 +1461,7 @@ __init void prefill_possible_map(void)
 
 	/* nr_cpu_ids could be reduced via nr_cpus= */
 	if (possible > nr_cpu_ids) {
-		pr_warn("%d Processors exceeds NR_CPUS limit of %d\n",
+		pr_warn("%d Processors exceeds NR_CPUS limit of %u\n",
 			possible, nr_cpu_ids);
 		possible = nr_cpu_ids;
 	}
diff -puN drivers/base/cpu.c~make-nr_cpu_ids-unsigned drivers/base/cpu.c
--- a/drivers/base/cpu.c~make-nr_cpu_ids-unsigned
+++ a/drivers/base/cpu.c
@@ -256,9 +256,9 @@ static ssize_t print_cpus_offline(struct
 			buf[n++] = ',';
 
 		if (nr_cpu_ids == total_cpus-1)
-			n += snprintf(&buf[n], len - n, "%d", nr_cpu_ids);
+			n += snprintf(&buf[n], len - n, "%u", nr_cpu_ids);
 		else
-			n += snprintf(&buf[n], len - n, "%d-%d",
+			n += snprintf(&buf[n], len - n, "%u-%d",
 						      nr_cpu_ids, total_cpus-1);
 	}
 
diff -puN drivers/scsi/scsi_debug.c~make-nr_cpu_ids-unsigned drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c~make-nr_cpu_ids-unsigned
+++ a/drivers/scsi/scsi_debug.c
@@ -5465,7 +5465,7 @@ static int sdebug_driver_probe(struct de
 		return error;
 	}
 	if (submit_queues > nr_cpu_ids) {
-		pr_warn("%s: trim submit_queues (was %d) to nr_cpu_ids=%d\n",
+		pr_warn("%s: trim submit_queues (was %d) to nr_cpu_ids=%u\n",
 			my_name, submit_queues, nr_cpu_ids);
 		submit_queues = nr_cpu_ids;
 	}
diff -puN include/linux/cpumask.h~make-nr_cpu_ids-unsigned include/linux/cpumask.h
--- a/include/linux/cpumask.h~make-nr_cpu_ids-unsigned
+++ a/include/linux/cpumask.h
@@ -32,15 +32,15 @@ typedef struct cpumask { DECLARE_BITMAP(
 #define cpumask_pr_args(maskp)		nr_cpu_ids, cpumask_bits(maskp)
 
 #if NR_CPUS == 1
-#define nr_cpu_ids		1
+#define nr_cpu_ids		1U
 #else
-extern int nr_cpu_ids;
+extern unsigned int nr_cpu_ids;
 #endif
 
 #ifdef CONFIG_CPUMASK_OFFSTACK
 /* Assuming NR_CPUS is huge, a runtime limit is more efficient.  Also,
  * not all bits may be allocated. */
-#define nr_cpumask_bits	((unsigned int)nr_cpu_ids)
+#define nr_cpumask_bits	nr_cpu_ids
 #else
 #define nr_cpumask_bits	((unsigned int)NR_CPUS)
 #endif
diff -puN kernel/rcu/tree.c~make-nr_cpu_ids-unsigned kernel/rcu/tree.c
--- a/kernel/rcu/tree.c~make-nr_cpu_ids-unsigned
+++ a/kernel/rcu/tree.c
@@ -4091,7 +4091,7 @@ static void __init rcu_init_geometry(voi
 	if (rcu_fanout_leaf == RCU_FANOUT_LEAF &&
 	    nr_cpu_ids == NR_CPUS)
 		return;
-	pr_info("RCU: Adjusting geometry for rcu_fanout_leaf=%d, nr_cpu_ids=%d\n",
+	pr_info("RCU: Adjusting geometry for rcu_fanout_leaf=%d, nr_cpu_ids=%u\n",
 		rcu_fanout_leaf, nr_cpu_ids);
 
 	/*
diff -puN kernel/rcu/tree_plugin.h~make-nr_cpu_ids-unsigned kernel/rcu/tree_plugin.h
--- a/kernel/rcu/tree_plugin.h~make-nr_cpu_ids-unsigned
+++ a/kernel/rcu/tree_plugin.h
@@ -89,7 +89,7 @@ static void __init rcu_bootup_announce_o
 	if (rcu_fanout_leaf != RCU_FANOUT_LEAF)
 		pr_info("\tBoot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
 	if (nr_cpu_ids != NR_CPUS)
-		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
+		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%u.\n", NR_CPUS, nr_cpu_ids);
 #ifdef CONFIG_RCU_BOOST
 	pr_info("\tRCU priority boosting: priority %d delay %d ms.\n", kthread_prio, CONFIG_RCU_BOOST_DELAY);
 #endif
diff -puN kernel/sched/topology.c~make-nr_cpu_ids-unsigned kernel/sched/topology.c
--- a/kernel/sched/topology.c~make-nr_cpu_ids-unsigned
+++ a/kernel/sched/topology.c
@@ -473,7 +473,7 @@ static int __init isolated_cpu_setup(cha
 	alloc_bootmem_cpumask_var(&cpu_isolated_map);
 	ret = cpulist_parse(str, cpu_isolated_map);
 	if (ret) {
-		pr_err("sched: Error, all isolcpus= values must be between 0 and %d\n", nr_cpu_ids);
+		pr_err("sched: Error, all isolcpus= values must be between 0 and %u\n", nr_cpu_ids);
 		return 0;
 	}
 	return 1;
diff -puN kernel/smp.c~make-nr_cpu_ids-unsigned kernel/smp.c
--- a/kernel/smp.c~make-nr_cpu_ids-unsigned
+++ a/kernel/smp.c
@@ -550,7 +550,7 @@ static int __init maxcpus(char *str)
 early_param("maxcpus", maxcpus);
 
 /* Setup number of possible processor ids */
-int nr_cpu_ids __read_mostly = NR_CPUS;
+unsigned int nr_cpu_ids __read_mostly = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
 
 /* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
diff -puN kernel/trace/trace_functions_graph.c~make-nr_cpu_ids-unsigned kernel/trace/trace_functions_graph.c
--- a/kernel/trace/trace_functions_graph.c~make-nr_cpu_ids-unsigned
+++ a/kernel/trace/trace_functions_graph.c
@@ -1543,7 +1543,7 @@ fs_initcall(init_graph_tracefs);
 
 static __init int init_graph_trace(void)
 {
-	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
+	max_bytes_for_cpu = snprintf(NULL, 0, "%u", nr_cpu_ids - 1);
 
 	if (!register_trace_event(&graph_trace_entry_event)) {
 		pr_warn("Warning: could not register graph trace events\n");
diff -puN mm/slub.c~make-nr_cpu_ids-unsigned mm/slub.c
--- a/mm/slub.c~make-nr_cpu_ids-unsigned
+++ a/mm/slub.c
@@ -4232,7 +4232,7 @@ void __init kmem_cache_init(void)
 	cpuhp_setup_state_nocalls(CPUHP_SLUB_DEAD, "slub:dead", NULL,
 				  slub_cpu_dead);
 
-	pr_info("SLUB: HWalign=%d, Order=%d-%d, MinObjects=%d, CPUs=%d, Nodes=%d\n",
+	pr_info("SLUB: HWalign=%d, Order=%d-%d, MinObjects=%d, CPUs=%u, Nodes=%d\n",
 		cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
 		nr_cpu_ids, nr_node_ids);
_
