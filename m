From: akpm@linux-foundation.org
Subject: - x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 12:15:36 -0700
Message-ID: <200707091915.l69JFaWK003457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbXGITQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 15:16:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64 slit: fake pxm-to-node mapping for fake numa
has been removed from the -mm tree.  Its filename was
     x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch

This patch was dropped because it was folded into x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch

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
which is newly exported to this code, as our measurement if the emulated nodes
appear in the same PXM.  Otherwise, we use REMOTE_DISTANCE.

PXM_INVAL and NID_INVAL are also exported to the ACPI header file so that we
can compare node_to_pxm() results in generic code (in this case, the SRAT
code).

Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c     |    1 
 arch/x86_64/mm/srat.c     |   76 ++++++++++++++++++++++++++++++++++--
 drivers/acpi/numa.c       |   11 +++--
 include/acpi/acpi_numa.h  |    1 
 include/asm-x86_64/acpi.h |   11 +++++
 include/linux/acpi.h      |    3 +
 6 files changed, 96 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/mm/numa.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2 arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2
+++ a/arch/x86_64/mm/numa.c
@@ -485,6 +485,7 @@ out:
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
+	acpi_fake_nodes(nodes, num_nodes);
  	numa_init_array();
  	return 0;
 }
diff -puN arch/x86_64/mm/srat.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2 arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2
+++ a/arch/x86_64/mm/srat.c
@@ -350,7 +350,7 @@ acpi_numa_memory_affinity_init(struct ac
 
 /* Sanity check to catch more bad SRATs (they are amazingly common).
    Make sure the PXMs cover all memory. */
-static int nodes_cover_memory(void)
+static int __init nodes_cover_memory(const struct bootnode *nodes)
 {
 	int i;
 	unsigned long pxmram, e820ram;
@@ -406,7 +406,7 @@ int __init acpi_scan_nodes(unsigned long
 		}
 	}
 
-	if (!nodes_cover_memory()) {
+	if (!nodes_cover_memory(nodes)) {
 		bad_srat();
 		return -1;
 	}
@@ -440,6 +440,75 @@ int __init acpi_scan_nodes(unsigned long
 	return 0;
 }
 
+#ifdef CONFIG_NUMA_EMU
+static int __init find_node_by_addr(unsigned long addr)
+{
+	int ret = NUMA_NO_NODE;
+	int i;
+
+	for_each_node_mask(i, nodes_parsed) {
+		/*
+		 * Find the real node that this emulated node appears on.  For
+		 * the sake of simplicity, we only use a real node's starting
+		 * address to determine which emulated node it appears on.
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
+ * environment.  For each emulated node, we find which real node it appears on
+ * and create PXM to NID mappings for those fake nodes which mirror that
+ * locality.  SLIT will now represent the correct distances between emulated
+ * nodes as a result of the real topology.
+ */
+void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
+{
+	int i;
+	int fake_node_to_pxm_map[MAX_NUMNODES] = {
+		[0 ... MAX_NUMNODES-1] = PXM_INVAL
+	};
+
+	printk(KERN_INFO "Faking PXM affinity for fake nodes on real "
+			 "topology.\n");
+	for (i = 0; i < num_nodes; i++) {
+		int nid, pxm;
+
+		nid = find_node_by_addr(fake_nodes[i].start);
+		if (nid == NUMA_NO_NODE)
+			continue;
+		pxm = node_to_pxm(nid);
+		if (pxm == PXM_INVAL)
+			continue;
+		fake_node_to_pxm_map[i] = pxm;
+	}
+	for (i = 0; i < num_nodes; i++)
+		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
+
+	nodes_clear(nodes_parsed);
+	for (i = 0; i < num_nodes; i++)
+		if (fake_nodes[i].start != fake_nodes[i].end)
+			node_set(i, nodes_parsed);
+	WARN_ON(!nodes_cover_memory(fake_nodes));
+}
+
+static int null_slit_node_compare(int a, int b)
+{
+	return node_to_pxm(a) == node_to_pxm(b);
+}
+#else
+static int null_slit_node_compare(int a, int b)
+{
+	return a == b;
+}
+#endif /* CONFIG_NUMA_EMU */
+
 void __init srat_reserve_add_area(int nodeid)
 {
 	if (found_add_area && nodes_add[nodeid].end) {
@@ -464,7 +533,8 @@ int __node_distance(int a, int b)
 	int index;
 
 	if (!acpi_slit)
-		return a == b ? LOCAL_DISTANCE : REMOTE_DISTANCE;
+		return null_slit_node_compare(a, b) ? LOCAL_DISTANCE :
+						      REMOTE_DISTANCE;
 	index = acpi_slit->locality_count * node_to_pxm(a);
 	return acpi_slit->entry[index + node_to_pxm(b)];
 }
diff -puN drivers/acpi/numa.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2 drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2
+++ a/drivers/acpi/numa.c
@@ -36,8 +36,6 @@
 ACPI_MODULE_NAME("numa");
 
 static nodemask_t nodes_found_map = NODE_MASK_NONE;
-#define PXM_INVAL	-1
-#define NID_INVAL	-1
 
 /* maps to convert between proximity domain and logical node ID */
 static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
@@ -59,6 +57,12 @@ int node_to_pxm(int node)
 	return node_to_pxm_map[node];
 }
 
+void __acpi_map_pxm_to_node(int pxm, int node)
+{
+	pxm_to_node_map[pxm] = node;
+	node_to_pxm_map[node] = pxm;
+}
+
 int acpi_map_pxm_to_node(int pxm)
 {
 	int node = pxm_to_node_map[pxm];
@@ -67,8 +71,7 @@ int acpi_map_pxm_to_node(int pxm)
 		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
 			return NID_INVAL;
 		node = first_unset_node(nodes_found_map);
-		pxm_to_node_map[pxm] = node;
-		node_to_pxm_map[node] = pxm;
+		__acpi_map_pxm_to_node(pxm, node);
 		node_set(node, nodes_found_map);
 	}
 
diff -puN include/acpi/acpi_numa.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2 include/acpi/acpi_numa.h
--- a/include/acpi/acpi_numa.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2
+++ a/include/acpi/acpi_numa.h
@@ -13,6 +13,7 @@
 
 extern int pxm_to_node(int);
 extern int node_to_pxm(int);
+extern void __acpi_map_pxm_to_node(int, int);
 extern int acpi_map_pxm_to_node(int);
 extern void __cpuinit acpi_unmap_pxm_to_node(int);
 
diff -puN include/asm-x86_64/acpi.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2 include/asm-x86_64/acpi.h
--- a/include/asm-x86_64/acpi.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2
+++ a/include/asm-x86_64/acpi.h
@@ -29,6 +29,7 @@
 #ifdef __KERNEL__
 
 #include <acpi/pdc_intel.h>
+#include <asm/numa.h>
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -141,6 +142,16 @@ extern int acpi_pci_disabled;
 extern int acpi_skip_timer_override;
 extern int acpi_use_timer_override;
 
+#ifdef CONFIG_ACPI_NUMA
+extern void __init acpi_fake_nodes(const struct bootnode *fake_nodes,
+				   int num_nodes);
+#else
+static inline void acpi_fake_nodes(const struct bootnode *fake_nodes,
+				   int num_nodes)
+{
+}
+#endif
+
 #endif /*__KERNEL__*/
 
 #endif /*_ASM_ACPI_H*/
diff -puN include/linux/acpi.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2 include/linux/acpi.h
--- a/include/linux/acpi.h~x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2
+++ a/include/linux/acpi.h
@@ -228,6 +228,9 @@ extern int acpi_paddr_to_node(u64 start_
 
 extern int pnpacpi_disabled;
 
+#define PXM_INVAL	(-1)
+#define NID_INVAL	(-1)
+
 #else	/* CONFIG_ACPI */
 
 static inline int acpi_boot_init(void)
_

Patches currently in -mm which might be from rientjes@google.com are

git-scsi-misc.patch
usb-make-the-usb_device-numa_node-to-get-assigned-from.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
x86_64-fix-e820_hole_size-based-on-address-ranges.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds.patch
x86_64-acpi-disable-srat-when-numa-emulation-succeeds-fix.patch
x86_64-slit-fake-pxm-to-node-mapping-for-fake-numa-2.patch
x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
x86_64-get-mp_bus_to_node-as-early.patch
x86_64-get-mp_bus_to_node-as-early-fix.patch
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
dma-make-dma-pool-to-use-kmalloc_node.patch
