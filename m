From: akpm@linux-foundation.org
Subject: - x86_64-acpi-various-cleanups.patch removed from -mm tree
Date: Fri, 11 May 2007 22:16:23 -0700
Message-ID: <200705120516.l4C5GN4b001819@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756645AbXELFRo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:17:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64 acpi: various cleanups
has been removed from the -mm tree.  Its filename was
     x86_64-acpi-various-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 acpi: various cleanups
From: David Rientjes <rientjes@google.com>

In acpi_scan_nodes(), we immediately return -1 if acpi_numa <= 0, meaning we
haven't detected any underlying ACPI topology or we have explicitly disabled
its use from the command-line with numa=noacpi.

acpi_table_print_srat_entry() and acpi_table_parse_srat() are only referenced
within drivers/acpi/numa.c, so we can mark them as static and remove their
prototypes from the header file.

Likewise, pxm_to_node_map[] and node_to_pxm_map[] are only used within
drivers/acpi/numa.c, so we mark them as static and remove their externs from
the header file.

The automatic 'result' variable is unused in acpi_numa_init(), so it's
removed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/srat.c    |    6 +++---
 drivers/acpi/numa.c      |   20 ++++++++++----------
 include/acpi/acpi_numa.h |    3 ---
 include/linux/acpi.h     |    2 --
 4 files changed, 13 insertions(+), 18 deletions(-)

diff -puN arch/x86_64/mm/srat.c~x86_64-acpi-various-cleanups arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86_64-acpi-various-cleanups
+++ a/arch/x86_64/mm/srat.c
@@ -394,6 +394,9 @@ int __init acpi_scan_nodes(unsigned long
 {
 	int i;
 
+	if (acpi_numa <= 0)
+		return -1;
+
 	/* First clean up the node list */
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		cutoff_node(i, start, end);
@@ -403,9 +406,6 @@ int __init acpi_scan_nodes(unsigned long
 		}
 	}
 
-	if (acpi_numa <= 0)
-		return -1;
-
 	if (!nodes_cover_memory()) {
 		disable_srat();
 		return -1;
diff -puN drivers/acpi/numa.c~x86_64-acpi-various-cleanups drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~x86_64-acpi-various-cleanups
+++ a/drivers/acpi/numa.c
@@ -40,9 +40,9 @@ static nodemask_t nodes_found_map = NODE
 #define NID_INVAL	-1
 
 /* maps to convert between proximity domain and logical node ID */
-int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
+static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
 				= { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
-int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
+static int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
 				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
 int __cpuinit pxm_to_node(int pxm)
@@ -83,7 +83,8 @@ void __cpuinit acpi_unmap_pxm_to_node(in
 	node_clear(node, nodes_found_map);
 }
 
-void __init acpi_table_print_srat_entry(struct acpi_subtable_header * header)
+static void __init
+acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 {
 
 	ACPI_FUNCTION_NAME("acpi_table_print_srat_entry");
@@ -200,7 +201,7 @@ static int __init acpi_parse_srat(struct
 	return 0;
 }
 
-int __init
+static int __init
 acpi_table_parse_srat(enum acpi_srat_type id,
 		      acpi_table_entry_handler handler, unsigned int max_entries)
 {
@@ -211,14 +212,13 @@ acpi_table_parse_srat(enum acpi_srat_typ
 
 int __init acpi_numa_init(void)
 {
-	int result;
-
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
-		result = acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-					       acpi_parse_processor_affinity,
-					       NR_CPUS);
-		result = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY, acpi_parse_memory_affinity, NR_NODE_MEMBLKS);	// IA64 specific
+		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
+				      acpi_parse_processor_affinity, NR_CPUS);
+		acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
+				      acpi_parse_memory_affinity,
+				      NR_NODE_MEMBLKS);
 	}
 
 	/* SLIT: System Locality Information Table */
diff -puN include/acpi/acpi_numa.h~x86_64-acpi-various-cleanups include/acpi/acpi_numa.h
--- a/include/acpi/acpi_numa.h~x86_64-acpi-various-cleanups
+++ a/include/acpi/acpi_numa.h
@@ -11,9 +11,6 @@
 #define MAX_PXM_DOMAINS (256)	/* Old pxm spec is defined 8 bit */
 #endif
 
-extern int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS];
-extern int __cpuinitdata node_to_pxm_map[MAX_NUMNODES];
-
 extern int __cpuinit pxm_to_node(int);
 extern int __cpuinit node_to_pxm(int);
 extern int __cpuinit acpi_map_pxm_to_node(int);
diff -puN include/linux/acpi.h~x86_64-acpi-various-cleanups include/linux/acpi.h
--- a/include/linux/acpi.h~x86_64-acpi-various-cleanups
+++ a/include/linux/acpi.h
@@ -88,10 +88,8 @@ int acpi_table_parse (char *id, acpi_tab
 int __init acpi_table_parse_entries(char *id, unsigned long table_size,
 	int entry_id, acpi_table_entry_handler handler, unsigned int max_entries);
 int acpi_table_parse_madt (enum acpi_madt_type id, acpi_table_entry_handler handler, unsigned int max_entries);
-int acpi_table_parse_srat (enum acpi_srat_type id, acpi_table_entry_handler handler, unsigned int max_entries);
 int acpi_parse_mcfg (struct acpi_table_header *header);
 void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
-void acpi_table_print_srat_entry (struct acpi_subtable_header *srat);
 
 /* the following four functions are architecture-dependent */
 #ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
frv-gdb-use-__maybe_unused.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch
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
