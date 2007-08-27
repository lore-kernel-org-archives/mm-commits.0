From: akpm@linux-foundation.org
Subject: + x86-fix-cpu_to_node-references.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:43:55 -0700
Message-ID: <200708272143.l7RLhuVC029934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933639AbXH0VoB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:44:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, ak@suse.de, clameter@sgi.com, suresh.b.siddha@intel.com


The patch titled
     x86: fix cpu_to_node references 
has been added to the -mm tree.  Its filename is
     x86-fix-cpu_to_node-references.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: fix cpu_to_node references 
From: Mike Travis <travis@sgi.com>

In x86_64 and i386 architectures most arrays that are sized using NR_CPUS lay
in local memory on node 0.  Not only will most (99%?) of the systems not use
all the slots in these arrays, particularly when NR_CPUS is increased to
accommodate future very high cpu count systems, but a number of cache lines
are passed unnecessarily on the system bus when these arrays are referenced by
cpus on other nodes.

Typically, the values in these arrays are referenced by the cpu accessing it's
own values, though when passing IPI interrupts, the cpu does access the data
relevant to the targeted cpu/node.  Of course, if the referencing cpu is not
on node 0, then the reference will still require cross node exchanges of cache
lines.  A common use of this is for an interrupt service routine to pass the
interrupt to other cpus local to that node.

Ideally, all the elements in these arrays should be moved to the per_cpu data
area.  In some cases (such as x86_cpu_to_apicid) the array is referenced
before the per_cpu data areas are setup.  In this case, a static array is
declared in the __initdata area and initialized by the booting cpu (BSP).  The
values are then moved to the per_cpu area after it is initialized and the
original static array is freed with the rest of the __initdata.


This patch:

Fix four instances where cpu_to_node is referenced by array instead of via the
cpu_to_node macro.  This is preparation to moving it to the per_cpu data area.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vsyscall.c |    2 +-
 arch/x86_64/mm/numa.c         |    4 ++--
 arch/x86_64/mm/srat.c         |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86_64/kernel/vsyscall.c~x86-fix-cpu_to_node-references arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~x86-fix-cpu_to_node-references
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -291,7 +291,7 @@ static void __cpuinit vsyscall_set_cpu(i
 	unsigned long *d;
 	unsigned long node = 0;
 #ifdef CONFIG_NUMA
-	node = cpu_to_node[cpu];
+	node = cpu_to_node(cpu);
 #endif
 	if (cpu_has(&cpu_data[cpu], X86_FEATURE_RDTSCP))
 		write_rdtscp_aux((node << 12) | cpu);
diff -puN arch/x86_64/mm/numa.c~x86-fix-cpu_to_node-references arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86-fix-cpu_to_node-references
+++ a/arch/x86_64/mm/numa.c
@@ -261,7 +261,7 @@ void __init numa_init_array(void)
 	   We round robin the existing nodes. */
 	rr = first_node(node_online_map);
 	for (i = 0; i < NR_CPUS; i++) {
-		if (cpu_to_node[i] != NUMA_NO_NODE)
+		if (cpu_to_node(i) != NUMA_NO_NODE)
 			continue;
  		numa_set_node(i, rr);
 		rr = next_node(rr, node_online_map);
@@ -543,7 +543,7 @@ __cpuinit void numa_add_cpu(int cpu)
 void __cpuinit numa_set_node(int cpu, int node)
 {
 	cpu_pda(cpu)->nodenumber = node;
-	cpu_to_node[cpu] = node;
+	cpu_to_node(cpu) = node;
 }
 
 unsigned long __init numa_free_all_bootmem(void) 
diff -puN arch/x86_64/mm/srat.c~x86-fix-cpu_to_node-references arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86-fix-cpu_to_node-references
+++ a/arch/x86_64/mm/srat.c
@@ -431,9 +431,9 @@ int __init acpi_scan_nodes(unsigned long
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 
 	for (i = 0; i < NR_CPUS; i++) {
-		if (cpu_to_node[i] == NUMA_NO_NODE)
+		if (cpu_to_node(i) == NUMA_NO_NODE)
 			continue;
-		if (!node_isset(cpu_to_node[i], node_possible_map))
+		if (!node_isset(cpu_to_node(i), node_possible_map))
 			numa_set_node(i, NUMA_NO_NODE);
 	}
 	numa_init_array();
_

Patches currently in -mm which might be from travis@sgi.com are

x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
