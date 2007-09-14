From: akpm@linux-foundation.org
Subject: + convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch added to -mm tree
Date: Fri, 14 Sep 2007 16:28:05 -0700
Message-ID: <200709142328.l8ENS5aL029499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181AbXINX2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 19:28:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Convert cpu_sibling_map to a per_cpu data array: ppc64
has been added to the -mm tree.  Its filename is
     convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Convert cpu_sibling_map to a per_cpu data array: ppc64
From: Mike Travis <travis@sgi.com>

Convert cpu_sibling_map to a per_cpu cpumask_t array for the ppc64
architecture.  This fixes build errors in block/blktrace.c and
kernel/sched.c when CONFIG_SCHED_SMT is defined.

Note: these changes have not been built nor tested.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup-common.c        |    4 ++--
 arch/powerpc/kernel/smp.c                 |    4 ++--
 arch/powerpc/platforms/cell/cbe_cpufreq.c |    2 +-
 include/asm-powerpc/smp.h                 |    4 +++-
 include/asm-powerpc/topology.h            |    2 +-
 5 files changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/kernel/setup-common.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64 arch/powerpc/kernel/setup-common.c
--- a/arch/powerpc/kernel/setup-common.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64
+++ a/arch/powerpc/kernel/setup-common.c
@@ -415,9 +415,9 @@ void __init smp_setup_cpu_maps(void)
 	 * Do the sibling map; assume only two threads per processor.
 	 */
 	for_each_possible_cpu(cpu) {
-		cpu_set(cpu, cpu_sibling_map[cpu]);
+		cpu_set(cpu, cpu_sibling_map(cpu));
 		if (cpu_has_feature(CPU_FTR_SMT))
-			cpu_set(cpu ^ 0x1, cpu_sibling_map[cpu]);
+			cpu_set(cpu ^ 0x1, cpu_sibling_map(cpu));
 	}
 
 	vdso_data->processorCount = num_present_cpus();
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
+	policy->cpus = cpu_sibling_map(policy->cpu);
 #endif
 
 	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
diff -puN include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64 include/asm-powerpc/smp.h
--- a/include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64
+++ a/include/asm-powerpc/smp.h
@@ -25,6 +25,7 @@
 
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
+#include <asm/percpu.h>
 #endif
 
 extern int boot_cpuid;
@@ -58,7 +59,8 @@ extern int smp_hw_index[];
 					(smp_hw_index[(cpu)] = (phys))
 #endif
 
-extern cpumask_t cpu_sibling_map[NR_CPUS];
+DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
+#define cpu_sibling_map(cpu) per_cpu(cpu_sibling_map, cpu)
 
 /* Since OpenPIC has only 4 IPIs, we use slightly different message numbers.
  *
diff -puN include/asm-powerpc/topology.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64 include/asm-powerpc/topology.h
--- a/include/asm-powerpc/topology.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64
+++ a/include/asm-powerpc/topology.h
@@ -108,7 +108,7 @@ static inline void sysfs_remove_device_f
 #ifdef CONFIG_PPC64
 #include <asm/smp.h>
 
-#define topology_thread_siblings(cpu)	(cpu_sibling_map[cpu])
+#define topology_thread_siblings(cpu)	(cpu_sibling_map(cpu))
 #endif
 #endif
 
_

Patches currently in -mm which might be from travis@sgi.com are

x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
