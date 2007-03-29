From: akpm@linux-foundation.org
Subject: - x86_64-map-fake-nodes-to-real-nodes.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:13:02 -0700
Message-ID: <200703292313.l2TND36t014646@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42292 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422682AbXC2XNR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, pj@sgi.com, rohitseth@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: map fake nodes to real nodes
has been removed from the -mm tree.  Its filename was
     x86_64-map-fake-nodes-to-real-nodes.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: x86_64: map fake nodes to real nodes
From: David Rientjes <rientjes@google.com>

Exports the struct bootnode array globally so that the physical mapping can be
saved when NUMA emulation is used.  This is then copied and stored for later
reference so that there exists a mapping between fake nodes and the real nodes
they reside on through the get_phys_node() function.

physical_node_map is a new struct bootnode array that is used to save the
physical mapping in the emulation case.  The is no effect when CONFIG_NUMA_EMU
is disabled or numa=fake=off.

The emulation case is handled after K8 and ACPI so that the physical mapping
can be saved later.

__node_distance() is modified to use the physical node that corresponds to the
fake node for measurement.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Rohit Seth <rohitseth@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/k8topology.c   |   23 +++---
 arch/x86_64/mm/numa.c         |  113 ++++++++++++++++++++++----------
 arch/x86_64/mm/srat.c         |    9 +-
 include/asm-x86_64/numa.h     |    4 -
 include/asm-x86_64/proto.h    |    2 
 include/asm-x86_64/topology.h |    1 
 6 files changed, 103 insertions(+), 49 deletions(-)

diff -puN arch/x86_64/mm/k8topology.c~x86_64-map-fake-nodes-to-real-nodes arch/x86_64/mm/k8topology.c
--- a/arch/x86_64/mm/k8topology.c~x86_64-map-fake-nodes-to-real-nodes
+++ a/arch/x86_64/mm/k8topology.c
@@ -40,10 +40,9 @@ static __init int find_northbridge(void)
 	return -1; 	
 }
 
-int __init k8_scan_nodes(unsigned long start, unsigned long end)
+int __init k8_scan_nodes(unsigned long start, unsigned long end, int fake)
 { 
 	unsigned long prevbase;
-	struct bootnode nodes[8];
 	int nodeid, i, nb; 
 	unsigned char nodeids[8];
 	int found = 0;
@@ -162,19 +161,25 @@ int __init k8_scan_nodes(unsigned long s
 	if (!found)
 		return -1; 
 
-	memnode_shift = compute_hash_shift(nodes, 8);
-	if (memnode_shift < 0) { 
-		printk(KERN_ERR "No NUMA node hash function found. Contact maintainer\n"); 
-		return -1; 
-	} 
-	printk(KERN_INFO "Using node hash shift of %d\n", memnode_shift); 
+	if (!fake) {
+		memnode_shift = compute_hash_shift(8);
+		if (memnode_shift < 0) {
+			printk(KERN_ERR "No NUMA node hash function found. "
+					"Contact maintainer\n");
+			return -1;
+		}
+		printk(KERN_INFO "Using node hash shift of %d\n",
+		       memnode_shift);
+	}
 
 	for (i = 0; i < 8; i++) {
 		if (nodes[i].start != nodes[i].end) { 
 			nodeid = nodeids[i];
 			apicid_to_node[nodeid << dualcore] = i;
 			apicid_to_node[(nodeid << dualcore) + dualcore] = i;
-			setup_node_bootmem(i, nodes[i].start, nodes[i].end); 
+			if (!fake)
+				setup_node_bootmem(i, nodes[i].start,
+						   nodes[i].end);
 		} 
 	}
 
diff -puN arch/x86_64/mm/numa.c~x86_64-map-fake-nodes-to-real-nodes arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-map-fake-nodes-to-real-nodes
+++ a/arch/x86_64/mm/numa.c
@@ -34,6 +34,7 @@ unsigned char apicid_to_node[MAX_LOCAL_A
  	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 cpumask_t node_to_cpumask[MAX_NUMNODES] __read_mostly;
+struct bootnode nodes[MAX_NUMNODES] __read_mostly;
 
 int numa_off __initdata;
 unsigned long __initdata nodemap_addr;
@@ -47,8 +48,7 @@ unsigned long __initdata nodemap_size;
  * 0 if memnodmap[] too small (of shift too small)
  * -1 if node overlap or lost ram (shift too big)
  */
-static int __init
-populate_memnodemap(const struct bootnode *nodes, int numnodes, int shift)
+static int __init populate_memnodemap(int numnodes, int shift)
 {
 	int i; 
 	int res = -1;
@@ -104,8 +104,7 @@ static int __init allocate_cachealigned_
  * The LSB of all start and end addresses in the node map is the value of the
  * maximum possible shift.
  */
-static int __init
-extract_lsb_from_nodes (const struct bootnode *nodes, int numnodes)
+static int __init extract_lsb_from_nodes(int numnodes)
 {
 	int i, nodes_used = 0;
 	unsigned long start, end;
@@ -129,17 +128,17 @@ extract_lsb_from_nodes (const struct boo
 	return i;
 }
 
-int __init compute_hash_shift(struct bootnode *nodes, int numnodes)
+int __init compute_hash_shift(int numnodes)
 {
 	int shift;
 
-	shift = extract_lsb_from_nodes(nodes, numnodes);
+	shift = extract_lsb_from_nodes(numnodes);
 	if (allocate_cachealigned_memnodemap())
 		return -1;
 	printk(KERN_DEBUG "NUMA: Using %d for the hash shift.\n",
 		shift);
 
-	if (populate_memnodemap(nodes, numnodes, shift) != 1) {
+	if (populate_memnodemap(numnodes, shift) != 1) {
 		printk(KERN_INFO
 	"Your memory is not aligned you need to rebuild your kernel "
 	"with a bigger NODEMAPSIZE shift=%d\n",
@@ -276,7 +275,37 @@ void __init numa_init_array(void)
 #define E820_ADDR_HOLE_SIZE(start, end)					\
 	(e820_hole_size((start) >> PAGE_SHIFT, (end) >> PAGE_SHIFT) <<	\
 	PAGE_SHIFT)
+
+static struct bootnode physical_node_map[MAX_NUMNODES];
 char *cmdline __initdata;
+int numa_emu;
+
+/*
+ * Returns the physical NUMA node that fake node nid resides on.  If NUMA
+ * emulation is disabled, then this is the same as nid.
+ */
+int get_phys_node(int nid)
+{
+	pg_data_t *pgdat;
+	u64 node_start_addr;
+	unsigned int i;
+	int ret = 0;
+
+	if (!numa_emu)
+		return nid;
+
+	pgdat = NODE_DATA(nid);
+	node_start_addr = pgdat->node_start_pfn << PAGE_SHIFT;
+
+	for (i = 0; i < MAX_NUMNODES; i++)
+		if (node_start_addr >= physical_node_map[i].start &&
+		    node_start_addr < physical_node_map[i].end) {
+			ret = i;
+			break;
+		}
+
+	return ret;
+}
 
 /*
  * Setups up nid to range from addr to addr + size.  If the end boundary is
@@ -284,8 +313,7 @@ char *cmdline __initdata;
  * if there is additional memory left for allocation past addr and -1 otherwise.
  * addr is adjusted to be at the end of the node.
  */
-static int __init setup_node_range(int nid, struct bootnode *nodes, u64 *addr,
-				   u64 size, u64 max_addr)
+static int __init setup_node_range(int nid, u64 *addr, u64 size, u64 max_addr)
 {
 	int ret = 0;
 	nodes[nid].start = *addr;
@@ -307,8 +335,7 @@ static int __init setup_node_range(int n
  * is the number of nodes split up and addr is adjusted to be at the end of the
  * last node allocated.
  */
-static int __init split_nodes_equally(struct bootnode *nodes, u64 *addr,
-				      u64 max_addr, int node_start,
+static int __init split_nodes_equally(u64 *addr, u64 max_addr, int node_start,
 				      int num_nodes)
 {
 	unsigned int big;
@@ -355,7 +382,7 @@ static int __init split_nodes_equally(st
 					break;
 				}
 			}
-		if (setup_node_range(i, nodes, addr, end - *addr, max_addr) < 0)
+		if (setup_node_range(i, addr, end - *addr, max_addr) < 0)
 			break;
 	}
 	return i - node_start + 1;
@@ -366,12 +393,12 @@ static int __init split_nodes_equally(st
  * always assigned to a final node and can be asymmetric.  Returns the number of
  * nodes split.
  */
-static int __init split_nodes_by_size(struct bootnode *nodes, u64 *addr,
-				      u64 max_addr, int node_start, u64 size)
+static int __init split_nodes_by_size(u64 *addr, u64 max_addr, int node_start,
+				      u64 size)
 {
 	int i = node_start;
 	size = (size << 20) & FAKE_NODE_MIN_HASH_MASK;
-	while (!setup_node_range(i++, nodes, addr, size, max_addr))
+	while (!setup_node_range(i++, addr, size, max_addr))
 		;
 	return i - node_start;
 }
@@ -382,7 +409,6 @@ static int __init split_nodes_by_size(st
  */
 static int __init numa_emulation(unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct bootnode nodes[MAX_NUMNODES];
 	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = end_pfn << PAGE_SHIFT;
 	int num_nodes = 0;
@@ -392,13 +418,18 @@ static int __init numa_emulation(unsigne
 	u64 size;
 	int i;
 
+	/*
+	 * Map the existing real NUMA toplogy to physical_node_map before the
+	 * information is cleared.
+	 */
+	memcpy(physical_node_map, nodes, sizeof(nodes));
 	memset(&nodes, 0, sizeof(nodes));
 	/*
 	 * If the numa=fake command-line is just a single number N, split the
 	 * system RAM into N fake nodes.
 	 */
 	if (!strchr(cmdline, '*') && !strchr(cmdline, ',')) {
-		num_nodes = split_nodes_equally(nodes, &addr, max_addr, 0,
+		num_nodes = split_nodes_equally(&addr, max_addr, 0,
 						simple_strtol(cmdline, NULL, 0));
 		if (num_nodes < 0)
 			return num_nodes;
@@ -426,8 +457,8 @@ static int __init numa_emulation(unsigne
 			size = ((u64)num << 20) & FAKE_NODE_MIN_HASH_MASK;
 			if (size)
 				for (i = 0; i < coeff; i++, num_nodes++)
-					if (setup_node_range(num_nodes, nodes,
-						&addr, size, max_addr) < 0)
+					if (setup_node_range(num_nodes, &addr,
+						size, max_addr) < 0)
 						goto done;
 			if (!*cmdline)
 				break;
@@ -443,7 +474,7 @@ done:
 	if (addr < max_addr) {
 		if (coeff_flag && coeff < 0) {
 			/* Split remaining nodes into num-sized chunks */
-			num_nodes += split_nodes_by_size(nodes, &addr, max_addr,
+			num_nodes += split_nodes_by_size(&addr, max_addr,
 							 num_nodes, num);
 			goto out;
 		}
@@ -452,7 +483,7 @@ done:
 			/* Split remaining nodes into coeff chunks */
 			if (coeff <= 0)
 				break;
-			num_nodes += split_nodes_equally(nodes, &addr, max_addr,
+			num_nodes += split_nodes_equally(&addr, max_addr,
 							 num_nodes, coeff);
 			break;
 		case ',':
@@ -460,13 +491,13 @@ done:
 			break;
 		default:
 			/* Give one final node */
-			setup_node_range(num_nodes, nodes, &addr,
-					 max_addr - addr, max_addr);
+			setup_node_range(num_nodes, &addr, max_addr - addr,
+					 max_addr);
 			num_nodes++;
 		}
 	}
 out:
-	memnode_shift = compute_hash_shift(nodes, num_nodes);
+	memnode_shift = compute_hash_shift(num_nodes);
 	if (memnode_shift < 0) {
 		memnode_shift = 0;
 		printk(KERN_ERR "No NUMA hash function found.  NUMA emulation "
@@ -492,30 +523,42 @@ out:
 
 void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 { 
+	unsigned long start_addr = start_pfn << PAGE_SHIFT;
+	unsigned long end_addr = end_pfn << PAGE_SHIFT;
+	int numa_fake = 0;
 	int i;
 
 #ifdef CONFIG_NUMA_EMU
-	if (cmdline && !numa_emulation(start_pfn, end_pfn))
- 		return;
+	/* Determine if we have a numa=fake command line */
+	if (cmdline != 0)
+		numa_fake = 1;
 #endif
 
 #ifdef CONFIG_ACPI_NUMA
-	if (!numa_off && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
-					  end_pfn << PAGE_SHIFT))
+	if (!numa_off && !numa_fake && !acpi_scan_nodes(start_addr, end_addr))
  		return;
 #endif
 
 #ifdef CONFIG_K8_NUMA
-	if (!numa_off && !k8_scan_nodes(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT))
-		return;
+	if (!numa_off && !k8_scan_nodes(start_addr, end_addr, numa_fake))
+		if (!numa_fake)
+			return;
 #endif
+
+#ifdef CONFIG_NUMA_EMU
+	if (numa_fake) {
+		numa_emu = !numa_emulation(start_pfn, end_pfn);
+		if (numa_emu)
+			return;
+	}
+#endif
+
 	printk(KERN_INFO "%s\n",
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
 
-	printk(KERN_INFO "Faking a node at %016lx-%016lx\n", 
-	       start_pfn << PAGE_SHIFT,
-	       end_pfn << PAGE_SHIFT); 
-		/* setup dummy node covering all memory */ 
+	printk(KERN_INFO "Faking a node at %016lx-%016lx\n", start_addr,
+	       end_addr);
+	/* setup dummy node covering all memory */
 	memnode_shift = 63; 
 	memnodemap = memnode.embedded_map;
 	memnodemap[0] = 0;
@@ -525,7 +568,7 @@ void __init numa_initmem_init(unsigned l
 		numa_set_node(i, 0);
 	node_to_cpumask[0] = cpumask_of_cpu(0);
 	e820_register_active_regions(0, start_pfn, end_pfn);
-	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, end_pfn << PAGE_SHIFT);
+	setup_node_bootmem(0, start_addr, end_addr);
 }
 
 __cpuinit void numa_add_cpu(int cpu)
diff -puN arch/x86_64/mm/srat.c~x86_64-map-fake-nodes-to-real-nodes arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c~x86_64-map-fake-nodes-to-real-nodes
+++ a/arch/x86_64/mm/srat.c
@@ -26,7 +26,6 @@ int acpi_numa __initdata;
 static struct acpi_table_slit *acpi_slit;
 
 static nodemask_t nodes_parsed __initdata;
-static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 static int found_add_area __initdata;
 int hotadd_percent __initdata = 0;
@@ -411,7 +410,7 @@ int __init acpi_scan_nodes(unsigned long
 		return -1;
 	}
 
-	memnode_shift = compute_hash_shift(nodes, MAX_NUMNODES);
+	memnode_shift = compute_hash_shift(MAX_NUMNODES);
 	if (memnode_shift < 0) {
 		printk(KERN_ERR
 		     "SRAT: No NUMA node hash function found. Contact maintainer\n");
@@ -461,6 +460,12 @@ int __node_distance(int a, int b)
 {
 	int index;
 
+#ifdef CONFIG_NUMA_EMU
+	/* In fake NUMA, the physical node is used for node distance. */
+	a = get_phys_node(a);
+	b = get_phys_node(b);
+#endif
+
 	if (!acpi_slit)
 		return a == b ? 10 : 20;
 	index = acpi_slit->locality_count * node_to_pxm(a);
diff -puN include/asm-x86_64/numa.h~x86_64-map-fake-nodes-to-real-nodes include/asm-x86_64/numa.h
--- a/include/asm-x86_64/numa.h~x86_64-map-fake-nodes-to-real-nodes
+++ a/include/asm-x86_64/numa.h
@@ -6,8 +6,8 @@
 struct bootnode {
 	u64 start,end; 
 };
-
-extern int compute_hash_shift(struct bootnode *nodes, int numnodes);
+extern struct bootnode nodes[MAX_NUMNODES];
+extern int compute_hash_shift(int numnodes);
 
 #define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
diff -puN include/asm-x86_64/proto.h~x86_64-map-fake-nodes-to-real-nodes include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~x86_64-map-fake-nodes-to-real-nodes
+++ a/include/asm-x86_64/proto.h
@@ -51,7 +51,7 @@ extern void early_printk(const char *fmt
 
 extern void early_identify_cpu(struct cpuinfo_x86 *c);
 
-extern int k8_scan_nodes(unsigned long start, unsigned long end);
+extern int k8_scan_nodes(unsigned long start, unsigned long end, int fake);
 
 extern void numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn);
 extern unsigned long numa_free_all_bootmem(void);
diff -puN include/asm-x86_64/topology.h~x86_64-map-fake-nodes-to-real-nodes include/asm-x86_64/topology.h
--- a/include/asm-x86_64/topology.h~x86_64-map-fake-nodes-to-real-nodes
+++ a/include/asm-x86_64/topology.h
@@ -67,5 +67,6 @@ extern int __node_distance(int, int);
 #include <asm-generic/topology.h>
 
 extern cpumask_t cpu_coregroup_map(int cpu);
+extern int get_phys_node(int nid);
 
 #endif
_

Patches currently in -mm which might be from rientjes@google.com are

x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
smaps-use-ptep_test_and_clear_young.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
