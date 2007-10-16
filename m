From: akpm@linux-foundation.org
Subject: - convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch removed from -mm tree
Date: Mon, 15 Oct 2007 23:30:02 -0700
Message-ID: <200710160630.l9G6U2rq013120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763090AbXJPGaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 02:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Convert cpu_sibling_map to a per_cpu data array: sparc64
has been removed from the -mm tree.  Its filename was
     convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch

This patch was dropped because it was folded into convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch

------------------------------------------------------
Subject: Convert cpu_sibling_map to a per_cpu data array: sparc64
From: Mike Travis <travis@sgi.com>

Convert cpu_sibling_map to a per_cpu cpumask_t array for the sparc64
architecture.  This fixes build errors in block/blktrace.c and
kernel/sched.c when CONFIG_SCHED_SMT is defined.

Note: these changes have not been built nor tested.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/smp.c      |   17 ++++++++---------
 include/asm-sparc64/smp.h      |    3 ++-
 include/asm-sparc64/topology.h |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/sparc64/kernel/smp.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64 arch/sparc64/kernel/smp.c
--- a/arch/sparc64/kernel/smp.c~convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64
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
 
diff -puN include/asm-sparc64/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64 include/asm-sparc64/smp.h
--- a/include/asm-sparc64/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64
+++ a/include/asm-sparc64/smp.h
@@ -28,8 +28,9 @@
  
 #include <asm/bitops.h>
 #include <asm/atomic.h>
+#include <asm/percpu.h>
 
-extern cpumask_t cpu_sibling_map[NR_CPUS];
+DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 extern cpumask_t cpu_core_map[NR_CPUS];
 extern int sparc64_multi_core;
 
diff -puN include/asm-sparc64/topology.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64 include/asm-sparc64/topology.h
--- a/include/asm-sparc64/topology.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64
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
_

Patches currently in -mm which might be from travis@sgi.com are

x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
