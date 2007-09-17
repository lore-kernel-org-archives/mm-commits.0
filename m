From: akpm@linux-foundation.org
Subject: + convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix.patch added to -mm tree
Date: Mon, 17 Sep 2007 13:50:43 -0700
Message-ID: <200709172050.l8HKoh9V004050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45639 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbXIQUvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Sep 2007 16:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     ppc64: Convert cpu_sibling_map to a per_cpu data array ppc64 v2
has been added to the -mm tree.  Its filename is
     convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ppc64: Convert cpu_sibling_map to a per_cpu data array ppc64 v2
From: Mike Travis <travis@sgi.com>

This patch applies after:

	convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch

and should fix the "reference cpu_sibling_map before setup_per_cpu_areas()
has been called" problem.  In addtion, the cpu_sibiling_map macro has been
removed [this was missed in my original submission.]

Original Notes:

Convert cpu_sibling_map to a per_cpu cpumask_t array for the ppc64
architecture.  This fixes build errors in block/blktrace.c and
kernel/sched.c when CONFIG_SCHED_SMT is defined.

Note: these changes have not been built nor tested.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup-common.c        |   20 ++++++++++++++++----
 arch/powerpc/kernel/setup_64.c            |    3 +++
 arch/powerpc/platforms/cell/cbe_cpufreq.c |    2 +-
 include/asm-powerpc/smp.h                 |    2 +-
 include/asm-powerpc/topology.h            |    2 +-
 5 files changed, 22 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/kernel/setup-common.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix
+++ a/arch/powerpc/kernel/setup-common.c
@@ -411,16 +411,28 @@ void __init smp_setup_cpu_maps(void)
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
-		cpu_set(cpu, cpu_sibling_map(cpu));
+		cpu_set(cpu, per_cpu(cpu_sibling_map, cpu));
 		if (cpu_has_feature(CPU_FTR_SMT))
-			cpu_set(cpu ^ 0x1, cpu_sibling_map(cpu));
+			cpu_set(cpu ^ 0x1, per_cpu(cpu_sibling_map, cpu));
 	}
-
-	vdso_data->processorCount = num_present_cpus();
 #endif /* CONFIG_PPC64 */
 }
 #endif /* CONFIG_SMP */
diff -puN arch/powerpc/kernel/setup_64.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix
+++ a/arch/powerpc/kernel/setup_64.c
@@ -596,6 +596,9 @@ void __init setup_per_cpu_areas(void)
 		paca[i].data_offset = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 	}
+
+	/* Now that per_cpu is setup, initialize cpu_sibling_map */
+	smp_setup_cpu_sibling_map();
 }
 #endif
 
diff -puN arch/powerpc/platforms/cell/cbe_cpufreq.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix arch/powerpc/platforms/cell/cbe_cpufreq.c
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix
+++ a/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -117,7 +117,7 @@ static int cbe_cpufreq_cpu_init(struct c
 	policy->cur = cbe_freqs[cur_pmode].frequency;
 
 #ifdef CONFIG_SMP
-	policy->cpus = cpu_sibling_map(policy->cpu);
+	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
 #endif
 
 	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
diff -puN include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix include/asm-powerpc/smp.h
--- a/include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix
+++ a/include/asm-powerpc/smp.h
@@ -60,7 +60,6 @@ extern int smp_hw_index[];
 #endif
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
-#define cpu_sibling_map(cpu) per_cpu(cpu_sibling_map, cpu)
 
 /* Since OpenPIC has only 4 IPIs, we use slightly different message numbers.
  *
@@ -79,6 +78,7 @@ void smp_init_pSeries(void);
 void smp_init_cell(void);
 void smp_init_celleb(void);
 void smp_setup_cpu_maps(void);
+void smp_setup_cpu_sibling_map(void);
 
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
diff -puN include/asm-powerpc/topology.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix include/asm-powerpc/topology.h
--- a/include/asm-powerpc/topology.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix
+++ a/include/asm-powerpc/topology.h
@@ -108,7 +108,7 @@ static inline void sysfs_remove_device_f
 #ifdef CONFIG_PPC64
 #include <asm/smp.h>
 
-#define topology_thread_siblings(cpu)	(cpu_sibling_map(cpu))
+#define topology_thread_siblings(cpu)	(per_cpu(cpu_sibling_map, cpu))
 #endif
 #endif
 
_

Patches currently in -mm which might be from travis@sgi.com are

x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
