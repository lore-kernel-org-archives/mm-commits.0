From: akpm@linux-foundation.org
Subject: + convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch added to -mm tree
Date: Fri, 14 Sep 2007 16:27:48 -0700
Message-ID: <200709142327.l8ENRmIr029489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071AbXINX1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 19:27:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, tony.luck@intel.com


The patch titled
     Convert cpu_sibling_map to a per_cpu data array: ia64
has been added to the -mm tree.  Its filename is
     convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Convert cpu_sibling_map to a per_cpu data array: ia64
From: Mike Travis <travis@sgi.com>

Convert cpu_sibling_map to a per_cpu cpumask_t array for the ia64
architecture.  This fixes build errors in block/blktrace.c and
kernel/sched.c when CONFIG_SCHED_SMT is defined.

There was one access to cpu_sibling_map before the per_cpu data
area was created, so that step was moved to after the per_cpu
area is setup.

Tested and verified on an A4700.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/setup.c    |    4 ----
 arch/ia64/kernel/smpboot.c  |   18 ++++++++++--------
 arch/ia64/mm/contig.c       |    6 ++++++
 include/asm-ia64/smp.h      |    2 +-
 include/asm-ia64/topology.h |    2 +-
 5 files changed, 18 insertions(+), 14 deletions(-)

diff -puN arch/ia64/kernel/setup.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64 arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64
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
diff -puN arch/ia64/kernel/smpboot.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64 arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64
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
diff -puN arch/ia64/mm/contig.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64 arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64
+++ a/arch/ia64/mm/contig.c
@@ -212,6 +212,12 @@ per_cpu_init (void)
 			cpu_data += PERCPU_PAGE_SIZE;
 			per_cpu(local_per_cpu_offset, cpu) = __per_cpu_offset[cpu];
 		}
+		/*
+		 * cpu_sibling_map is now a per_cpu variable - it needs to
+		 * be accessed after per_cpu_init() sets up the per_cpu area.
+		 */
+		cpu_set(0, per_cpu(cpu_sibling_map, 0));
+		cpu_set(0, cpu_core_map[0]);
 	}
 	return __per_cpu_start + __per_cpu_offset[smp_processor_id()];
 }
diff -puN include/asm-ia64/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64 include/asm-ia64/smp.h
--- a/include/asm-ia64/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64
+++ a/include/asm-ia64/smp.h
@@ -58,7 +58,7 @@ extern char no_int_routing __devinitdata
 
 extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_core_map[NR_CPUS];
-extern cpumask_t cpu_sibling_map[NR_CPUS];
+DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 extern int smp_num_siblings;
 extern int smp_num_cpucores;
 extern void __iomem *ipi_base_addr;
diff -puN include/asm-ia64/topology.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64 include/asm-ia64/topology.h
--- a/include/asm-ia64/topology.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64
+++ a/include/asm-ia64/topology.h
@@ -112,7 +112,7 @@ void build_cpu_to_node_map(void);
 #define topology_physical_package_id(cpu)	(cpu_data(cpu)->socket_id)
 #define topology_core_id(cpu)			(cpu_data(cpu)->core_id)
 #define topology_core_siblings(cpu)		(cpu_core_map[cpu])
-#define topology_thread_siblings(cpu)		(cpu_sibling_map[cpu])
+#define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #define smt_capable() 				(smp_num_siblings > 1)
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
