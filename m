From: akpm@linux-foundation.org
Subject: - convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch removed from -mm tree
Date: Mon, 15 Oct 2007 23:29:59 -0700
Message-ID: <200710160629.l9G6TxIV013045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47338 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762129AbXJPGaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 02:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Convert cpu_sibling_map to a per_cpu data array: ppc64
has been removed from the -mm tree.  Its filename was
     convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch

This patch was dropped because it was folded into convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch

------------------------------------------------------
Subject: Convert cpu_sibling_map to a per_cpu data array: ppc64
From: Mike Travis <travis@sgi.com>

Convert cpu_sibling_map to a per_cpu cpumask_t array for the ppc64
architecture.  This fixes build errors in block/blktrace.c and
kernel/sched.c when CONFIG_SCHED_SMT is defined.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup-common.c        |   20 ++++++++++++++++----
 arch/powerpc/kernel/setup_64.c            |    3 +++
 arch/powerpc/kernel/smp.c                 |    4 ++--
 arch/powerpc/platforms/cell/cbe_cpufreq.c |    2 +-
 include/asm-powerpc/smp.h                 |    4 +++-
 include/asm-powerpc/topology.h            |    2 +-
 6 files changed, 26 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/kernel/setup-common.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64 arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64
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
diff -puN arch/powerpc/kernel/smp.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64 arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64
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
diff -puN arch/powerpc/platforms/cell/cbe_cpufreq.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64 arch/powerpc/platforms/cell/cbe_cpufreq.c
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64
+++ a/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -117,7 +117,7 @@ static int cbe_cpufreq_cpu_init(struct c
 	policy->cur = cbe_freqs[cur_pmode].frequency;
 
 #ifdef CONFIG_SMP
-	policy->cpus = cpu_sibling_map[policy->cpu];
+	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
 #endif
 
 	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
diff -puN include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64 include/asm-powerpc/smp.h
--- a/include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64
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
diff -puN include/asm-powerpc/topology.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64 include/asm-powerpc/topology.h
--- a/include/asm-powerpc/topology.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64
+++ a/include/asm-powerpc/topology.h
@@ -108,7 +108,7 @@ static inline void sysfs_remove_device_f
 #ifdef CONFIG_PPC64
 #include <asm/smp.h>
 
-#define topology_thread_siblings(cpu)	(cpu_sibling_map[cpu])
+#define topology_thread_siblings(cpu)	(per_cpu(cpu_sibling_map, cpu))
 #endif
 #endif
 
diff -puN arch/powerpc/kernel/setup_64.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64 arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64
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
 
_

Patches currently in -mm which might be from travis@sgi.com are

x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
