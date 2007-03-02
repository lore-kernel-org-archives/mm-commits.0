From: akpm@linux-foundation.org
Subject: + x86_64-configurable-fake-numa-node-sizes.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:03:30 -0800
Message-ID: <200703020103.l2213Uts028210@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33134 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643AbXCBBDl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:03:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, pj@sgi.com


The patch titled
     x86_64: configurable fake numa node sizes
has been added to the -mm tree.  Its filename is
     x86_64-configurable-fake-numa-node-sizes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: configurable fake numa node sizes
From: David Rientjes <rientjes@google.com>

Extends the numa=fake x86_64 command-line option to allow for configurable
node sizes.  These nodes can be used in conjunction with cpusets for coarse
memory resource management.

The old command-line option is still supported:
  numa=fake=32	gives 32 fake NUMA nodes, ignoring the NUMA setup of the
		actual machine.

But now you may configure your system for the node sizes of your choice:
  numa=fake=2*512,1024,2*256
		gives two 512M nodes, one 1024M node, two 256M nodes, and
		the rest of system memory to a sixth node.

The existing hash function is maintained to support the various node sizes
that are possible with this implementation.

Each node of the same size receives roughly the same amount of available
pages, regardless of any reserved memory with its address range.  The total
available pages on the system is calculated and divided by the number of equal
nodes to allocate.  These nodes are then dynamically allocated and their
borders extended until such time as their number of available pages reaches
the required size.

Configurable node sizes are recommended when used in conjunction with cpusets
for memory control because it eliminates the overhead associated with scanning
the zonelists of many smaller full nodes on page_alloc().

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    8 
 arch/x86_64/mm/numa.c                 |  253 +++++++++++++-----------
 include/asm-x86_64/mmzone.h           |    2 
 3 files changed, 154 insertions(+), 109 deletions(-)

diff -puN Documentation/x86_64/boot-options.txt~x86_64-configurable-fake-numa-node-sizes Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86_64-configurable-fake-numa-node-sizes
+++ a/Documentation/x86_64/boot-options.txt
@@ -149,7 +149,13 @@ NUMA
 
   numa=noacpi   Don't parse the SRAT table for NUMA setup
 
-  numa=fake=X   Fake X nodes and ignore NUMA setup of the actual machine.
+  numa=fake=CMDLINE
+		If a number, fakes CMDLINE nodes and ignores NUMA setup of the
+		actual machine.  Otherwise, system memory is configured
+		depending on the sizes and coefficients listed.  For example:
+			numa=fake=2*512,1024,4*256
+		gives two 512M nodes, a 1024M node, and four 256M nodes.  The
+		remaining system RAM is allocated to an additional node.
 
   numa=hotadd=percent
 		Only allow hotadd memory to preallocate page structures upto
diff -puN arch/x86_64/mm/numa.c~x86_64-configurable-fake-numa-node-sizes arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-configurable-fake-numa-node-sizes
+++ a/arch/x86_64/mm/numa.c
@@ -273,125 +273,166 @@ void __init numa_init_array(void)
 
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
-int numa_fake __initdata = 0;
+#define E820_ADDR_HOLE_SIZE(start, end)					\
+	(e820_hole_size((start) >> PAGE_SHIFT, (end) >> PAGE_SHIFT) <<	\
+	PAGE_SHIFT)
+char *cmdline __initdata;
 
 /*
- * This function is used to find out if the start and end correspond to
- * different zones.
+ * Setups up nid to range from addr to addr + size.  If the end boundary is
+ * greater than max_addr, then max_addr is used instead.  The return value is 0
+ * if there is additional memory left for allocation past addr and -1 otherwise.
+ * addr is adjusted to be at the end of the node.
  */
-int zone_cross_over(unsigned long start, unsigned long end)
+static int __init setup_node_range(int nid, struct bootnode *nodes, u64 *addr,
+				   u64 size, u64 max_addr)
 {
-	if ((start < (MAX_DMA32_PFN << PAGE_SHIFT)) &&
-			(end >= (MAX_DMA32_PFN << PAGE_SHIFT)))
-		return 1;
-	return 0;
+	int ret = 0;
+	nodes[nid].start = *addr;
+	*addr += size;
+	if (*addr >= max_addr) {
+		*addr = max_addr;
+		ret = -1;
+	}
+	nodes[nid].end = *addr;
+	node_set_online(nid);
+	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
+	       nodes[nid].start, nodes[nid].end,
+	       (nodes[nid].end - nodes[nid].start) >> 20);
+	return ret;
 }
 
-static int __init numa_emulation(unsigned long start_pfn, unsigned long end_pfn)
+/*
+ * Splits num_nodes nodes up equally starting at node_start.  The return value
+ * is the number of nodes split up and addr is adjusted to be at the end of the
+ * last node allocated.
+ */
+static int __init split_nodes_equally(struct bootnode *nodes, u64 *addr,
+				      u64 max_addr, int node_start,
+				      int num_nodes)
 {
- 	int i, big;
- 	struct bootnode nodes[MAX_NUMNODES];
- 	unsigned long sz, old_sz;
-	unsigned long hole_size;
-	unsigned long start, end;
-	unsigned long max_addr = (end_pfn << PAGE_SHIFT);
-
-	start = (start_pfn << PAGE_SHIFT);
-	hole_size = e820_hole_size(start, max_addr);
-	sz = (max_addr - start - hole_size) / numa_fake;
-
- 	/* Kludge needed for the hash function */
+	unsigned int big;
+	u64 size;
+	int i;
 
-	old_sz = sz;
+	if (num_nodes <= 0)
+		return -1;
+	if (num_nodes > MAX_NUMNODES)
+		num_nodes = MAX_NUMNODES;
+	size = (max_addr - *addr - E820_ADDR_HOLE_SIZE(*addr, max_addr)) /
+	       num_nodes;
 	/*
-	 * Round down to the nearest FAKE_NODE_MIN_SIZE.
+	 * Calculate the number of big nodes that can be allocated as a result
+	 * of consolidating the leftovers.
 	 */
-	sz &= FAKE_NODE_MIN_HASH_MASK;
+	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * num_nodes) /
+	      FAKE_NODE_MIN_SIZE;
 
-	/*
-	 * We ensure that each node is at least 64MB big.  Smaller than this
-	 * size can cause VM hiccups.
-	 */
-	if (sz == 0) {
-		printk(KERN_INFO "Not enough memory for %d nodes.  Reducing "
-				"the number of nodes\n", numa_fake);
-		numa_fake = (max_addr - start - hole_size) / FAKE_NODE_MIN_SIZE;
-		printk(KERN_INFO "Number of fake nodes will be = %d\n",
-				numa_fake);
-		sz = FAKE_NODE_MIN_SIZE;
+	/* Round down to nearest FAKE_NODE_MIN_SIZE. */
+	size &= FAKE_NODE_MIN_HASH_MASK;
+	if (!size) {
+		printk(KERN_ERR "Not enough memory for each node.  "
+		       "NUMA emulation disabled.\n");
+		return -1;
 	}
-	/*
-	 * Find out how many nodes can get an extra NODE_MIN_SIZE granule.
-	 * This logic ensures the extra memory gets distributed among as many
-	 * nodes as possible (as compared to one single node getting all that
-	 * extra memory.
-	 */
-	big = ((old_sz - sz) * numa_fake) / FAKE_NODE_MIN_SIZE;
-	printk(KERN_INFO "Fake node Size: %luMB hole_size: %luMB big nodes: "
-			"%d\n",
-			(sz >> 20), (hole_size >> 20), big);
- 	memset(&nodes,0,sizeof(nodes));
-	end = start;
- 	for (i = 0; i < numa_fake; i++) {
-		/*
-		 * In case we are not able to allocate enough memory for all
-		 * the nodes, we reduce the number of fake nodes.
-		 */
-		if (end >= max_addr) {
-			numa_fake = i - 1;
-			break;
-		}
- 		start = nodes[i].start = end;
-		/*
-		 * Final node can have all the remaining memory.
-		 */
- 		if (i == numa_fake-1)
- 			sz = max_addr - start;
- 		end = nodes[i].start + sz;
-		/*
-		 * Fir "big" number of nodes get extra granule.
-		 */
+
+	for (i = node_start; i < num_nodes + node_start; i++) {
+		u64 end = *addr + size;
 		if (i < big)
 			end += FAKE_NODE_MIN_SIZE;
 		/*
-		 * Iterate over the range to ensure that this node gets at
-		 * least sz amount of RAM (excluding holes)
+		 * The final node can have the remaining system RAM.  Other
+		 * nodes receive roughly the same amount of available pages.
 		 */
-		while ((end - start - e820_hole_size(start, end)) < sz) {
-			end += FAKE_NODE_MIN_SIZE;
-			if (end >= max_addr)
-				break;
+		if (i == num_nodes + node_start - 1)
+			end = max_addr;
+		else
+			while (end - *addr - E820_ADDR_HOLE_SIZE(*addr, end) <
+			       size) {
+				end += FAKE_NODE_MIN_SIZE;
+				if (end > max_addr) {
+					end = max_addr;
+					break;
+				}
+			}
+		if (setup_node_range(i, nodes, addr, end - *addr, max_addr) < 0)
+			break;
+	}
+	return i - node_start + 1;
+}
+
+/*
+ * Sets up the system RAM area from start_pfn to end_pfn according to the
+ * numa=fake command-line option.
+ */
+static int __init numa_emulation(unsigned long start_pfn, unsigned long end_pfn)
+{
+	struct bootnode nodes[MAX_NUMNODES];
+	u64 addr = start_pfn << PAGE_SHIFT;
+	u64 max_addr = end_pfn << PAGE_SHIFT;
+	unsigned int coeff;
+	unsigned int num = 0;
+	int num_nodes = 0;
+	u64 size;
+	int i;
+
+	memset(&nodes, 0, sizeof(nodes));
+	/*
+	 * If the numa=fake command-line is just a single number N, split the
+	 * system RAM into N fake nodes.
+	 */
+	if (!strchr(cmdline, '*') && !strchr(cmdline, ',')) {
+		num_nodes = split_nodes_equally(nodes, &addr, max_addr, 0,
+						simple_strtol(cmdline, NULL, 0));
+		if (num_nodes < 0)
+			return num_nodes;
+		goto out;
+	}
+
+	/* Parse the command line. */
+	for (coeff = 1; ; cmdline++) {
+		if (*cmdline && isdigit(*cmdline)) {
+			num = num * 10 + *cmdline - '0';
+			continue;
 		}
-		/*
-		 * Look at the next node to make sure there is some real memory
-		 * to map.  Bad things happen when the only memory present
-		 * in a zone on a fake node is IO hole.
-		 */
-		while (e820_hole_size(end, end + FAKE_NODE_MIN_SIZE) > 0) {
-			if (zone_cross_over(start, end + sz)) {
-				end = (MAX_DMA32_PFN << PAGE_SHIFT);
-				break;
+		if (*cmdline == '*')
+			coeff = num;
+		if (!*cmdline || *cmdline == ',') {
+			/*
+			 * Round down to the nearest FAKE_NODE_MIN_SIZE.
+			 * Command-line coefficients are in megabytes.
+			 */
+			size = ((u64)num << 20) & FAKE_NODE_MIN_HASH_MASK;
+			if (size) {
+				for (i = 0; i < coeff; i++, num_nodes++)
+					if (setup_node_range(num_nodes, nodes,
+						&addr, size, max_addr) < 0)
+						goto done;
+				coeff = 1;
 			}
-			if (end >= max_addr)
-				break;
-			end += FAKE_NODE_MIN_SIZE;
 		}
-		if (end > max_addr)
-			end = max_addr;
-		nodes[i].end = end;
- 		printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n",
- 		       i,
- 		       nodes[i].start, nodes[i].end,
- 		       (nodes[i].end - nodes[i].start) >> 20);
-		node_set_online(i);
- 	}
- 	memnode_shift = compute_hash_shift(nodes, numa_fake);
- 	if (memnode_shift < 0) {
- 		memnode_shift = 0;
- 		printk(KERN_ERR "No NUMA hash function found. Emulation disabled.\n");
- 		return -1;
- 	}
- 	for_each_online_node(i) {
+		if (!*cmdline)
+			break;
+		num = 0;
+	}
+done:
+	if (!num_nodes)
+		return -1;
+	/* Fill remainder of system RAM with a final node, if appropriate. */
+	if (addr < max_addr) {
+		setup_node_range(num_nodes, nodes, &addr, max_addr - addr,
+				 max_addr);
+		num_nodes++;
+	}
+out:
+	memnode_shift = compute_hash_shift(nodes, num_nodes);
+	if (memnode_shift < 0) {
+		memnode_shift = 0;
+		printk(KERN_ERR "No NUMA hash function found.  NUMA emulation "
+		       "disabled.\n");
+		return -1;
+	}
+	for_each_online_node(i) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
@@ -399,14 +440,15 @@ static int __init numa_emulation(unsigne
  	numa_init_array();
  	return 0;
 }
-#endif
+#undef E820_ADDR_HOLE_SIZE
+#endif /* CONFIG_NUMA_EMU */
 
 void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 { 
 	int i;
 
 #ifdef CONFIG_NUMA_EMU
-	if (numa_fake && !numa_emulation(start_pfn, end_pfn))
+	if (cmdline && !numa_emulation(start_pfn, end_pfn))
  		return;
 #endif
 
@@ -486,11 +528,8 @@ static __init int numa_setup(char *opt)
 	if (!strncmp(opt,"off",3))
 		numa_off = 1;
 #ifdef CONFIG_NUMA_EMU
-	if(!strncmp(opt, "fake=", 5)) {
-		numa_fake = simple_strtoul(opt+5,NULL,0); ;
-		if (numa_fake >= MAX_NUMNODES)
-			numa_fake = MAX_NUMNODES;
-	}
+	if (!strncmp(opt, "fake=", 5))
+		cmdline = opt + 5;
 #endif
 #ifdef CONFIG_ACPI_NUMA
  	if (!strncmp(opt,"noacpi",6))
diff -puN include/asm-x86_64/mmzone.h~x86_64-configurable-fake-numa-node-sizes include/asm-x86_64/mmzone.h
--- a/include/asm-x86_64/mmzone.h~x86_64-configurable-fake-numa-node-sizes
+++ a/include/asm-x86_64/mmzone.h
@@ -49,7 +49,7 @@ extern int pfn_valid(unsigned long pfn);
 
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	(64*1024*1024)
-#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1ul))
+#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1uL))
 #endif
 
 #endif
_

Patches currently in -mm which might be from rientjes@google.com are

x86_64-configurable-fake-numa-node-sizes.patch
x86_64-split-remaining-fake-nodes-equally.patch
x86_64-fixed-size-remaining-fake-nodes.patch
x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
x86_64-fake-numa-for-cpusets-document.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
