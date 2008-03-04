From: akpm@linux-foundation.org
Subject: - x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch removed from -mm tree
Date: Mon, 03 Mar 2008 16:53:57 -0800
Message-ID: <200803040103.m2413K5N016169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbYCDBIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 20:08:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, ak@suse.de, apw@shadowen.org, clameter@sgi.com, jschopp@austin.ibm.com, mingo@elte.hu, rdunlap@xenotime.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: Cleanup non-smp usage of cpu maps
has been removed from the -mm tree.  Its filename was
     x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: Cleanup non-smp usage of cpu maps
From: Mike Travis <travis@sgi.com>

Cleanup references to the early cpu maps for the non-SMP configuration
and remove some functions called for SMP configurations only.

Based on git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joel Schopp <jschopp@austin.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/genapic_64.c |    2 ++
 arch/x86/kernel/mpparse_64.c |    2 ++
 arch/x86/kernel/setup64.c    |    3 +++
 arch/x86/kernel/smpboot_32.c |    2 ++
 arch/x86/mm/numa_64.c        |    4 +++-
 include/asm-x86/smp_32.h     |    4 ++++
 include/asm-x86/smp_64.h     |    5 +++++
 include/asm-x86/topology.h   |   16 ++++++++++++----
 8 files changed, 33 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/genapic_64.c~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3 arch/x86/kernel/genapic_64.c
--- a/arch/x86/kernel/genapic_64.c~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3
+++ a/arch/x86/kernel/genapic_64.c
@@ -25,9 +25,11 @@
 #endif
 
 /* which logical CPU number maps to which CPU (physical APIC ID) */
+#ifdef CONFIG_SMP
 u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata
 					= { [0 ... NR_CPUS-1] = BAD_APICID };
 void *x86_cpu_to_apicid_early_ptr;
+#endif
 DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
diff -puN arch/x86/kernel/mpparse_64.c~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3 arch/x86/kernel/mpparse_64.c
--- a/arch/x86/kernel/mpparse_64.c~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3
+++ a/arch/x86/kernel/mpparse_64.c
@@ -67,9 +67,11 @@ unsigned disabled_cpus __cpuinitdata;
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map = PHYSID_MASK_NONE;
 
+#ifdef CONFIG_SMP
 u16 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
 				= { [0 ... NR_CPUS-1] = BAD_APICID };
 void *x86_bios_cpu_apicid_early_ptr;
+#endif
 DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
diff -puN arch/x86/kernel/setup64.c~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3 arch/x86/kernel/setup64.c
--- a/arch/x86/kernel/setup64.c~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3
+++ a/arch/x86/kernel/setup64.c
@@ -89,6 +89,8 @@ static int __init nonx32_setup(char *str
 }
 __setup("noexec32=", nonx32_setup);
 
+
+#ifdef CONFIG_SMP
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the
@@ -175,6 +177,7 @@ void __init setup_per_cpu_areas(void)
 	/* Fix up pda for this processor .... */
 	pda_init(0);
 } 
+#endif /* CONFIG_SMP */
 
 void pda_init(int cpu)
 { 
diff -puN arch/x86/kernel/smpboot_32.c~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3 arch/x86/kernel/smpboot_32.c
--- a/arch/x86/kernel/smpboot_32.c~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3
+++ a/arch/x86/kernel/smpboot_32.c
@@ -92,9 +92,11 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct cpu
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 /* which logical CPU number maps to which CPU (physical APIC ID) */
+#ifdef CONFIG_SMP
 u8 x86_cpu_to_apicid_init[NR_CPUS] __initdata =
 			{ [0 ... NR_CPUS-1] = BAD_APICID };
 void *x86_cpu_to_apicid_early_ptr;
+#endif
 DEFINE_PER_CPU(u8, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
diff -puN arch/x86/mm/numa_64.c~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3 arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3
+++ a/arch/x86/mm/numa_64.c
@@ -31,13 +31,15 @@ bootmem_data_t plat_node_bdata[MAX_NUMNO
 
 struct memnode memnode;
 
+#ifdef CONFIG_SMP
 int x86_cpu_to_node_map_init[NR_CPUS] = {
 	[0 ... NR_CPUS-1] = NUMA_NO_NODE
 };
 void *x86_cpu_to_node_map_early_ptr;
+EXPORT_SYMBOL(x86_cpu_to_node_map_early_ptr);
+#endif
 DEFINE_PER_CPU(int, x86_cpu_to_node_map) = NUMA_NO_NODE;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_node_map);
-EXPORT_SYMBOL(x86_cpu_to_node_map_early_ptr);
 
 s16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
diff -puN include/asm-x86/smp_32.h~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3 include/asm-x86/smp_32.h
--- a/include/asm-x86/smp_32.h~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3
+++ a/include/asm-x86/smp_32.h
@@ -29,8 +29,12 @@ extern void unlock_ipi_call_lock(void);
 extern void (*mtrr_hook) (void);
 extern void zap_low_mappings (void);
 
+#ifdef CONFIG_SMP
 extern u8 __initdata x86_cpu_to_apicid_init[];
 extern void *x86_cpu_to_apicid_early_ptr;
+#else
+#define x86_cpu_to_apicid_early_ptr NULL
+#endif
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
diff -puN include/asm-x86/smp_64.h~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3 include/asm-x86/smp_64.h
--- a/include/asm-x86/smp_64.h~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3
+++ a/include/asm-x86/smp_64.h
@@ -26,10 +26,15 @@ extern void unlock_ipi_call_lock(void);
 extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 				  void *info, int wait);
 
+#ifdef CONFIG_SMP
 extern u16 __initdata x86_cpu_to_apicid_init[];
 extern u16 __initdata x86_bios_cpu_apicid_init[];
 extern void *x86_cpu_to_apicid_early_ptr;
 extern void *x86_bios_cpu_apicid_early_ptr;
+#else
+#define x86_cpu_to_apicid_early_ptr NULL
+#define x86_bios_cpu_apicid_early_ptr NULL
+#endif
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
diff -puN include/asm-x86/topology.h~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3 include/asm-x86/topology.h
--- a/include/asm-x86/topology.h~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3
+++ a/include/asm-x86/topology.h
@@ -35,8 +35,14 @@ extern int cpu_to_node_map[];
 
 #else
 DECLARE_PER_CPU(int, x86_cpu_to_node_map);
+
+#ifdef CONFIG_SMP
 extern int x86_cpu_to_node_map_init[];
 extern void *x86_cpu_to_node_map_early_ptr;
+#else
+#define x86_cpu_to_node_map_early_ptr NULL
+#endif
+
 /* Returns the number of the current Node. */
 #define numa_node_id()		(early_cpu_to_node(raw_smp_processor_id()))
 #endif
@@ -54,6 +60,8 @@ static inline int cpu_to_node(int cpu)
 }
 
 #else /* CONFIG_X86_64 */
+
+#ifdef CONFIG_SMP
 static inline int early_cpu_to_node(int cpu)
 {
 	int *cpu_to_node_map = x86_cpu_to_node_map_early_ptr;
@@ -65,6 +73,9 @@ static inline int early_cpu_to_node(int 
 	else
 		return NUMA_NO_NODE;
 }
+#else
+#define	early_cpu_to_node(cpu)	cpu_to_node(cpu)
+#endif
 
 static inline int cpu_to_node(int cpu)
 {
@@ -76,10 +87,7 @@ static inline int cpu_to_node(int cpu)
 		return ((int *)x86_cpu_to_node_map_early_ptr)[cpu];
 	}
 #endif
-	if (per_cpu_offset(cpu))
-		return per_cpu(x86_cpu_to_node_map, cpu);
-	else
-		return NUMA_NO_NODE;
+	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 #endif /* CONFIG_X86_64 */
 
_

Patches currently in -mm which might be from travis@sgi.com are

cpufreq-change-cpu-freq-tables-to-per_cpu-variables.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch

