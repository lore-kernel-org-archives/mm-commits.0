From: akpm@linux-foundation.org
Subject: - x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa.patch removed from -mm tree
Date: Thu, 10 May 2007 17:10:12 -0700
Message-ID: <200705110010.l4B0ACpq001995@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755600AbXEKALh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 20:11:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64 slit: fake pxm-to-node mapping for fake numa
has been removed from the -mm tree.  Its filename was
     x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: x86_64 slit: fake pxm-to-node mapping for fake numa
From: David Rientjes <rientjes@google.com>

For NUMA emulation, our SLIT should represent the true NUMA topology of the
system but our proximity domain to node ID mapping needs to reflect the
emulated state.

When NUMA emulation has successfully setup fake nodes on the system, a new
function, acpi_fake_nodes() is called.  This function determines the proximity
domain (_PXM) for each true node found on the system.  It then finds which
emulated nodes have been allocated on this true node as determined by its
starting address.  The node ID to PXM mapping is changed so that each fake
node ID points to the PXM of the true node that it is located on.

If the machine failed to register a SLIT, then we assume there is no special
requirement for emulated node affinity so we use the default LOCAL_DISTANCE,
which is newly exported to this code, as our measurement.

PXM_INVAL and NID_INVAL are also exported to the ACPI header file so that we
can compare node_to_pxm() results in generic code (in this case, the SRAT
code).

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c     |    3 +
 arch/x86_64/mm/srat.c     |   67 ++++++++++++++++++++++++++++++++++--
 drivers/acpi/numa.c       |   11 +++--
 include/acpi/acpi_numa.h  |    1 
 include/asm-x86_64/acpi.h |    6 +++
 include/linux/acpi.h      |    3 +
 6 files changed, 84 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/mm/numa.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa
+++ a/arch/x86_64/mm/numa.c
@@ -476,6 +476,9 @@ out:
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
+#ifdef CONFIG_ACPI_NUMA
+	acpi_fake_nodes(nodes, num_nodes);
+#endif
  	numa_init_array();
  	return 0;
 }
diff -puN arch/x86_64/mm/srat.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa
+++ a/arch/x86_64/mm/srat.c
@@ -350,7 +350,7 @@ acpi_numa_memory_affinity_init(struct ac
 
 /* Sanity check to catch more bad SRATs (they are amazingly common).
    Make sure the PXMs cover all memory. */
-static int nodes_cover_memory(void)
+static __init int nodes_cover_memory(const struct bootnode *nodes)
 {
 	int i;
 	unsigned long pxmram, e820ram;
@@ -406,7 +406,7 @@ int __init acpi_scan_nodes(unsigned long
 		}
 	}
 
-	if (!nodes_cover_memory()) {
+	if (!nodes_cover_memory(nodes)) {
 		disable_srat();
 		return -1;
 	}
@@ -440,6 +440,62 @@ int __init acpi_scan_nodes(unsigned long
 	return 0;
 }
 
+#ifdef CONFIG_NUMA_EMU
+static int __init find_node_by_addr(const struct bootnode *nodes,
+				    unsigned char num_nodes, unsigned long addr)
+{
+	int ret = NUMA_NO_NODE;
+	int i;
+
+	for (i = 0; i < num_nodes; i++) {
+		/*
+		 * Find all the emulated nodes that appear on this real node.
+		 * For the sake of simplicity, we only use a fake node's
+		 * starting address to determine which real node it appears on.
+		 */
+		if (addr >= nodes[i].start && addr < nodes[i].end) {
+			ret = i;
+			break;
+		}
+	}
+	return i;
+}
+
+/*
+ * In NUMA emulation, we need to setup proximity domain (_PXM) to node ID
+ * mappings that respect the real ACPI topology but reflect our emulated
+ * environment.  For each real NUMA node, we find which emulated nodes are
+ * allocated on it and create PXM to NID mappings for those fake nodes which
+ * mirror the locality of the real node they appear on.  SLIT will now
+ * represent the correct distances between emulated nodes as a result of the
+ * real topology.
+ */
+void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
+{
+	int i;
+
+	printk(KERN_INFO "Faking PXM affinity for fake nodes on real "
+			 "topology.\n");
+	for_each_node_mask(i, nodes_parsed) {
+		int nid, pxm;
+
+		pxm = node_to_pxm(i);
+		if (pxm == PXM_INVAL)
+			continue;
+		nid = find_node_by_addr(fake_nodes, num_nodes, nodes[i].start);
+		if (nid == NUMA_NO_NODE)
+			continue;
+		__acpi_map_pxm_to_node(pxm, nid);
+	}
+
+	nodes_clear(nodes_parsed);
+	for (i = 0; i < MAX_NUMNODES; i++)
+		if (fake_nodes[i].start != fake_nodes[i].end)
+			node_set(i, nodes_parsed);
+	WARN_ON(!nodes_cover_memory(fake_nodes));
+}
+#endif /* CONFIG_NUMA_EMU */
+
 void __init srat_reserve_add_area(int nodeid)
 {
 	if (found_add_area && nodes_add[nodeid].end) {
@@ -463,8 +519,13 @@ int __node_distance(int a, int b)
 {
 	int index;
 
-	if (!acpi_slit)
+	if (!acpi_slit) {
+#ifdef CONFIG_NUMA_EMU
+		return LOCAL_DISTANCE;
+#else
 		return a == b ? LOCAL_DISTANCE : REMOTE_DISTANCE;
+#endif
+	}
 	index = acpi_slit->locality_count * node_to_pxm(a);
 	return acpi_slit->entry[index + node_to_pxm(b)];
 }
diff -puN drivers/acpi/numa.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa
+++ a/drivers/acpi/numa.c
@@ -36,8 +36,6 @@
 ACPI_MODULE_NAME("numa");
 
 static nodemask_t nodes_found_map = NODE_MASK_NONE;
-#define PXM_INVAL	-1
-#define NID_INVAL	-1
 
 /* maps to convert between proximity domain and logical node ID */
 static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
@@ -59,6 +57,12 @@ int __cpuinit node_to_pxm(int node)
 	return node_to_pxm_map[node];
 }
 
+void __cpuinit __acpi_map_pxm_to_node(int pxm, int node)
+{
+	pxm_to_node_map[pxm] = node;
+	node_to_pxm_map[node] = pxm;
+}
+
 int __cpuinit acpi_map_pxm_to_node(int pxm)
 {
 	int node = pxm_to_node_map[pxm];
@@ -67,8 +71,7 @@ int __cpuinit acpi_map_pxm_to_node(int p
 		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
 			return NID_INVAL;
 		node = first_unset_node(nodes_found_map);
-		pxm_to_node_map[pxm] = node;
-		node_to_pxm_map[node] = pxm;
+		__acpi_map_pxm_to_node(pxm, node);
 		node_set(node, nodes_found_map);
 	}
 
diff -puN include/acpi/acpi_numa.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa include/acpi/acpi_numa.h
--- a/include/acpi/acpi_numa.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa
+++ a/include/acpi/acpi_numa.h
@@ -13,6 +13,7 @@
 
 extern int __cpuinit pxm_to_node(int);
 extern int __cpuinit node_to_pxm(int);
+extern void __cpuinit __acpi_map_pxm_to_node(int, int);
 extern int __cpuinit acpi_map_pxm_to_node(int);
 extern void __cpuinit acpi_unmap_pxm_to_node(int);
 
diff -puN include/asm-x86_64/acpi.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa include/asm-x86_64/acpi.h
--- a/include/asm-x86_64/acpi.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa
+++ a/include/asm-x86_64/acpi.h
@@ -29,6 +29,9 @@
 #ifdef __KERNEL__
 
 #include <acpi/pdc_intel.h>
+#ifdef CONFIG_NUMA_EMU
+#include <asm/numa.h>
+#endif
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -118,6 +121,9 @@ static inline void acpi_disable_pci(void
 
 extern int acpi_numa;
 extern int acpi_scan_nodes(unsigned long start, unsigned long end);
+#ifdef CONFIG_NUMA_EMU
+extern void acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes);
+#endif
 #define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
 
 #ifdef CONFIG_ACPI_SLEEP
diff -puN include/linux/acpi.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa include/linux/acpi.h
--- a/include/linux/acpi.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa
+++ a/include/linux/acpi.h
@@ -226,6 +226,9 @@ extern int acpi_paddr_to_node(u64 start_
 
 extern int pnpacpi_disabled;
 
+#define PXM_INVAL	(-1)
+#define NID_INVAL	(-1)
+
 #else	/* CONFIG_ACPI */
 
 static inline int acpi_boot_init(void)
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-extract-helper-function-from-e820_register_active_regions-fix.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
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
