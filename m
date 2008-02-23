From: akpm@linux-foundation.org
Subject: + x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:37:32 -0800
Message-ID: <200802230738.m1N7cLb9018651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765049AbYBWIPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:15:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, ak@suse.de, apw@shadowen.org, clameter@sgi.com, jschopp@austin.ibm.com, mingo@elte.hu, rdunlap@xenotime.net, tglx@linutronix.de


The patch titled
     x86_64: Cleanup non-smp usage of cpu maps
has been added to the -mm tree.  Its filename is
     x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch

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
 arch/x86/mm/numa_64.c        |   10 +++++-----
 include/asm-x86/pda.h        |    1 -
 include/asm-x86/smp_32.h     |    4 ++++
 include/asm-x86/smp_64.h     |    5 +++++
 include/asm-x86/topology.h   |   16 ++++++++++++----
 9 files changed, 35 insertions(+), 10 deletions(-)

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
@@ -546,11 +548,9 @@ void __cpuinit numa_set_node(int cpu, in
 {
 	int *cpu_to_node_map = x86_cpu_to_node_map_early_ptr;
 
-	cpu_pda(cpu)->nodenumber = node;
-
-	if(cpu_to_node_map)
+	if (cpu_to_node_map)
 		cpu_to_node_map[cpu] = node;
-	else if(per_cpu_offset(cpu))
+	else if (per_cpu_offset(cpu))
 		per_cpu(x86_cpu_to_node_map, cpu) = node;
 	else
 		Dprintk(KERN_INFO "Setting node for non-present cpu %d\n", cpu);
diff -puN include/asm-x86/pda.h~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3 include/asm-x86/pda.h
--- a/include/asm-x86/pda.h~x86_64-cleanup-non-smp-usage-of-cpu-maps-v3
+++ a/include/asm-x86/pda.h
@@ -22,7 +22,6 @@ struct x8664_pda {
 					   offset 40!!! */
 #endif
 	char *irqstackptr;
-	unsigned int nodenumber;	/* number of current node */
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* number of NMI on this CPUs */
 	short mmu_state;
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
x86-minor-cleanup-of-comments-in-processorh.patch
percpu-fix-debug_preempt-per_cpu-checking.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
