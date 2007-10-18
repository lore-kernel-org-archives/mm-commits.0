From: akpm@linux-foundation.org
Subject: - x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:09:00 -0700
Message-ID: <200710180709.l9I790Nq031863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763100AbXJRHPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, ak@suse.de, clameter@sgi.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     x86: Convert cpu_llc_id to be a per cpu variable 
has been removed from the -mm tree.  Its filename was
     x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: Convert cpu_llc_id to be a per cpu variable 
From: Mike Travis <travis@sgi.com>

Convert cpu_llc_id from a static array sized by NR_CPUS to a per_cpu variable.
 This saves sizeof(cpu_llc_id) * NR unused cpus.  Access is mostly from
startup and CPU HOTPLUG functions.

Note there's an addtional change of the type of cpu_llc_id from int to u8 for
ARCH i386 to correspond with the same type in ARCH x86_64.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
 arch/x86/kernel/smpboot_32.c          |    6 +++---
 arch/x86/kernel/smpboot_64.c          |    6 +++---
 include/asm-x86/processor_32.h        |    6 +++++-
 include/asm-x86/smp_64.h              |    3 ++-
 5 files changed, 15 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/cpu/intel_cacheinfo.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -417,14 +417,14 @@ unsigned int __cpuinit init_intel_cachei
 	if (new_l2) {
 		l2 = new_l2;
 #ifdef CONFIG_X86_HT
-		cpu_llc_id[cpu] = l2_id;
+		per_cpu(cpu_llc_id, cpu) = l2_id;
 #endif
 	}
 
 	if (new_l3) {
 		l3 = new_l3;
 #ifdef CONFIG_X86_HT
-		cpu_llc_id[cpu] = l3_id;
+		per_cpu(cpu_llc_id, cpu) = l3_id;
 #endif
 	}
 
diff -puN arch/x86/kernel/smpboot_32.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable arch/x86/kernel/smpboot_32.c
--- a/arch/x86/kernel/smpboot_32.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable
+++ a/arch/x86/kernel/smpboot_32.c
@@ -67,7 +67,7 @@ int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
 
 /* Last level cache ID of each logical CPU */
-int cpu_llc_id[NR_CPUS] __cpuinitdata = {[0 ... NR_CPUS-1] = BAD_APICID};
+DEFINE_PER_CPU(u8, cpu_llc_id) = BAD_APICID;
 
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
@@ -348,8 +348,8 @@ void __cpuinit set_cpu_sibling_map(int c
 	}
 
 	for_each_cpu_mask(i, cpu_sibling_setup_map) {
-		if (cpu_llc_id[cpu] != BAD_APICID &&
-		    cpu_llc_id[cpu] == cpu_llc_id[i]) {
+		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
+		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpu_set(i, c[cpu].llc_shared_map);
 			cpu_set(cpu, c[i].llc_shared_map);
 		}
diff -puN arch/x86/kernel/smpboot_64.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable arch/x86/kernel/smpboot_64.c
--- a/arch/x86/kernel/smpboot_64.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable
+++ a/arch/x86/kernel/smpboot_64.c
@@ -65,7 +65,7 @@ int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
 
 /* Last level cache ID of each logical CPU */
-u8 cpu_llc_id[NR_CPUS] __cpuinitdata  = {[0 ... NR_CPUS-1] = BAD_APICID};
+DEFINE_PER_CPU(u8, cpu_llc_id) = BAD_APICID;
 
 /* Bitmask of currently online CPUs */
 cpumask_t cpu_online_map __read_mostly;
@@ -284,8 +284,8 @@ static inline void set_cpu_sibling_map(i
 	}
 
 	for_each_cpu_mask(i, cpu_sibling_setup_map) {
-		if (cpu_llc_id[cpu] != BAD_APICID &&
-		    cpu_llc_id[cpu] == cpu_llc_id[i]) {
+		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
+		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpu_set(i, c[cpu].llc_shared_map);
 			cpu_set(cpu, c[i].llc_shared_map);
 		}
diff -puN include/asm-x86/processor_32.h~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable include/asm-x86/processor_32.h
--- a/include/asm-x86/processor_32.h~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable
+++ a/include/asm-x86/processor_32.h
@@ -110,7 +110,11 @@ extern struct cpuinfo_x86 cpu_data[];
 #define current_cpu_data boot_cpu_data
 #endif
 
-extern	int cpu_llc_id[NR_CPUS];
+/*
+ * the following now lives in the per cpu area:
+ * extern	int cpu_llc_id[NR_CPUS];
+ */
+DECLARE_PER_CPU(u8, cpu_llc_id);
 extern char ignore_fpu_irq;
 
 void __init cpu_detect(struct cpuinfo_x86 *c);
diff -puN include/asm-x86/smp_64.h~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable include/asm-x86/smp_64.h
--- a/include/asm-x86/smp_64.h~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable
+++ a/include/asm-x86/smp_64.h
@@ -49,7 +49,7 @@ extern int smp_call_function_mask(cpumas
  */
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
-extern u8 cpu_llc_id[NR_CPUS];
+DECLARE_PER_CPU(u8, cpu_llc_id);
 
 #define SMP_TRAMPOLINE_BASE 0x6000
 
@@ -121,6 +121,7 @@ static __inline int logical_smp_processo
 #ifdef CONFIG_SMP
 #define cpu_physical_id(cpu)		per_cpu(x86_cpu_to_apicid, cpu)
 #else
+extern unsigned int boot_cpu_id;
 #define cpu_physical_id(cpu)		boot_cpu_id
 #endif /* !CONFIG_SMP */
 #endif
_

Patches currently in -mm which might be from travis@sgi.com are

origin.patch
git-x86.patch
