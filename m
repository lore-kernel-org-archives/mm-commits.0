From: akpm@linux-foundation.org
Subject: + x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:43:33 -0700
Message-ID: <200708272143.l7RLhXqj029922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47436 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760580AbXH0Vnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, ak@suse.de, clameter@sgi.com, suresh.b.siddha@intel.com


The patch titled
     x86: Convert cpu_llc_id to be a per cpu variable 
has been added to the -mm tree.  Its filename is
     x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/i386/kernel/cpu/intel_cacheinfo.c |    4 ++--
 arch/i386/kernel/smpboot.c             |    6 +++---
 arch/x86_64/kernel/smpboot.c           |    6 +++---
 include/asm-i386/processor.h           |    6 +++++-
 include/asm-x86_64/smp.h               |    9 ++++-----
 5 files changed, 17 insertions(+), 14 deletions(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
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
 
diff -puN arch/i386/kernel/smpboot.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable
+++ a/arch/i386/kernel/smpboot.c
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
diff -puN arch/x86_64/kernel/smpboot.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable
+++ a/arch/x86_64/kernel/smpboot.c
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
diff -puN include/asm-i386/processor.h~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable
+++ a/include/asm-i386/processor.h
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
diff -puN include/asm-x86_64/smp.h~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable include/asm-x86_64/smp.h
--- a/include/asm-x86_64/smp.h~x86-convert-cpu_llc_id-to-be-a-per-cpu-variable
+++ a/include/asm-x86_64/smp.h
@@ -39,16 +39,14 @@ extern int smp_num_siblings;
 extern void smp_send_reschedule(int cpu);
 
 /*
- * cpu_sibling_map and cpu_core_map now live
- * in the per cpu area
- *
+ * the following now live in the per cpu area:
  * extern cpumask_t cpu_sibling_map[NR_CPUS];
  * extern cpumask_t cpu_core_map[NR_CPUS];
+ * extern u8 cpu_llc_id[NR_CPUS];
  */
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
-
-extern u8 cpu_llc_id[NR_CPUS];
+DECLARE_PER_CPU(u8, cpu_llc_id);
 
 #define SMP_TRAMPOLINE_BASE 0x6000
 
@@ -120,6 +118,7 @@ static __inline int logical_smp_processo
 #ifdef CONFIG_SMP
 #define cpu_physical_id(cpu)		per_cpu(x86_cpu_to_apicid, cpu)
 #else
+extern unsigned int boot_cpu_id;
 #define cpu_physical_id(cpu)		boot_cpu_id
 #endif /* !CONFIG_SMP */
 #endif
_

Patches currently in -mm which might be from travis@sgi.com are

x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
