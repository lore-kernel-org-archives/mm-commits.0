From: akpm@linux-foundation.org
Subject: - x86_64-rename-and-export-bad_srat-to-kernel-code.patch removed from -mm tree
Date: Thu, 10 May 2007 17:07:46 -0700
Message-ID: <200705110007.l4B07kVX001956@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755657AbXEKAH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 20:07:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: rename and export bad_srat to kernel code
has been removed from the -mm tree.  Its filename was
     x86_64-rename-and-export-bad_srat-to-kernel-code.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: x86_64: rename and export bad_srat to kernel code
From: David Rientjes <rientjes@google.com>

Rename bad_srat() to disable_srat() and include it in asm-x86_64/numa.h so
that it can be referenced from generic x86-64 boot code.  It's needed for NUMA
emulation disabling of active SRAT regions and apicid_to_node[] population.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/srat.c     |   16 ++++++++--------
 include/asm-x86_64/numa.h |    6 ++++++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/mm/srat.c~x86_64-rename-and-export-bad_srat-to-kernel-code arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86_64-rename-and-export-bad_srat-to-kernel-code
+++ a/arch/x86_64/mm/srat.c
@@ -74,7 +74,7 @@ static __init void cutoff_node(int i, un
 	}
 }
 
-static __init void bad_srat(void)
+void __init disable_srat(void)
 {
 	int i;
 	printk(KERN_ERR "SRAT: SRAT not used.\n");
@@ -133,7 +133,7 @@ acpi_numa_processor_affinity_init(struct
 	if (srat_disabled())
 		return;
 	if (pa->header.length != sizeof(struct acpi_srat_cpu_affinity)) {
-		bad_srat();
+		disable_srat();
 		return;
 	}
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
@@ -142,7 +142,7 @@ acpi_numa_processor_affinity_init(struct
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
-		bad_srat();
+		disable_srat();
 		return;
 	}
 	apicid_to_node[pa->apic_id] = node;
@@ -289,7 +289,7 @@ acpi_numa_memory_affinity_init(struct ac
 	if (srat_disabled())
 		return;
 	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
-		bad_srat();
+		disable_srat();
 		return;
 	}
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
@@ -303,7 +303,7 @@ acpi_numa_memory_affinity_init(struct ac
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
-		bad_srat();
+		disable_srat();
 		return;
 	}
 	i = conflicting_nodes(start, end);
@@ -316,7 +316,7 @@ acpi_numa_memory_affinity_init(struct ac
 		       "SRAT: PXM %d (%lx-%lx) overlaps with PXM %d (%Lx-%Lx)\n",
 		       pxm, start, end, node_to_pxm(i),
 			nodes[i].start, nodes[i].end);
-		bad_srat();
+		disable_srat();
 		return;
 	}
 	nd = &nodes[node];
@@ -407,7 +407,7 @@ int __init acpi_scan_nodes(unsigned long
 		return -1;
 
 	if (!nodes_cover_memory()) {
-		bad_srat();
+		disable_srat();
 		return -1;
 	}
 
@@ -415,7 +415,7 @@ int __init acpi_scan_nodes(unsigned long
 	if (memnode_shift < 0) {
 		printk(KERN_ERR
 		     "SRAT: No NUMA node hash function found. Contact maintainer\n");
-		bad_srat();
+		disable_srat();
 		return -1;
 	}
 
diff -puN include/asm-x86_64/numa.h~x86_64-rename-and-export-bad_srat-to-kernel-code include/asm-x86_64/numa.h
--- a/include/asm-x86_64/numa.h~x86_64-rename-and-export-bad_srat-to-kernel-code
+++ a/include/asm-x86_64/numa.h
@@ -33,6 +33,12 @@ static inline void clear_node_cpumask(in
 #define clear_node_cpumask(cpu) do {} while (0)
 #endif
 
+#ifdef CONFIG_ACPI_NUMA
+extern void __init disable_srat(void);
+#else
+#define disable_srat()	do {} while (0)
+#endif
+
 #define NUMA_NO_NODE 0xff
 
 #endif
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
x86_64-rename-and-export-bad_srat-to-kernel-code.patch
x86_64-rename-and-export-bad_srat-to-kernel-code-fix.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-fix-fake-numa-for-machines-with-true-srat.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
frv-gdb-use-__maybe_unused.patch
