From: akpm@osdl.org
Subject: - x86_64-make-the-numa-hash-function-nodemap-allocation.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:04:58 -0800
Message-ID: <200612081104.kB8B4wQL018604@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48687 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425368AbWLHLFK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:05:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amul.shah@unisys.com, ak@suse.de, rohitseth@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: Make the NUMA hash function nodemap allocation dynamic and remove NODEMAPSIZE
has been removed from the -mm tree.  Its filename was
     x86_64-make-the-numa-hash-function-nodemap-allocation.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: x86_64: Make the NUMA hash function nodemap allocation dynamic and remove NODEMAPSIZE
From: Amul Shah <amul.shah@unisys.com>

Remove the statically allocated memory to NUMA node hash map in favor of a
dynamically allocated memory to node hash map (it is cache aligned).

This patch has the nice side effect in that it allows the hash map to grow
for systems with large amounts of memory (256GB - 1TB), but suffer from
having small PCI space tacked onto the boot node (which is somewhere
between 192MB to 512MB on the ES7000).

Signed-off-by: Amul Shah <amul.shah@unisys.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Rohit Seth <rohitseth@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/e820.c   |    6 ++
 arch/x86_64/kernel/setup.c  |    4 +
 arch/x86_64/mm/numa.c       |   73 +++++++++++++++++++++++++++++-----
 include/asm-x86_64/e820.h   |    1 
 include/asm-x86_64/mmzone.h |   13 +++---
 5 files changed, 82 insertions(+), 15 deletions(-)

diff -puN arch/x86_64/kernel/e820.c~x86_64-make-the-numa-hash-function-nodemap-allocation arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~x86_64-make-the-numa-hash-function-nodemap-allocation
+++ a/arch/x86_64/kernel/e820.c
@@ -83,6 +83,12 @@ static inline int bad_addr(unsigned long
 		return 1;
 	}
 
+	/* NUMA memory to node map */
+	if (last >= nodemap_addr && addr < nodemap_addr + nodemap_size) {
+		*addrp = nodemap_addr + nodemap_size;
+		return 1;
+	}
+
 	/* XXX ramdisk image here? */ 
 	return 0;
 } 
diff -puN arch/x86_64/kernel/setup.c~x86_64-make-the-numa-hash-function-nodemap-allocation arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~x86_64-make-the-numa-hash-function-nodemap-allocation
+++ a/arch/x86_64/kernel/setup.c
@@ -445,6 +445,10 @@ void __init setup_arch(char **cmdline_p)
 	if (ebda_addr)
 		reserve_bootmem_generic(ebda_addr, ebda_size);
 
+	/* reserve nodemap region */
+	if (nodemap_addr)
+		reserve_bootmem_generic(nodemap_addr, nodemap_size);
+
 #ifdef CONFIG_SMP
 	/*
 	 * But first pinch a few for the stack/trampoline stuff
diff -puN arch/x86_64/mm/numa.c~x86_64-make-the-numa-hash-function-nodemap-allocation arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-make-the-numa-hash-function-nodemap-allocation
+++ a/arch/x86_64/mm/numa.c
@@ -36,6 +36,8 @@ unsigned char apicid_to_node[MAX_LOCAL_A
 cpumask_t node_to_cpumask[MAX_NUMNODES] __read_mostly;
 
 int numa_off __initdata;
+unsigned long __initdata nodemap_addr;
+unsigned long __initdata nodemap_size;
 
 
 /*
@@ -52,34 +54,87 @@ populate_memnodemap(const struct bootnod
 	int res = -1;
 	unsigned long addr, end;
 
-	if (shift >= 64)
-		return -1;
-	memset(memnodemap, 0xff, sizeof(memnodemap));
+	memset(memnodemap, 0xff, memnodemapsize);
 	for (i = 0; i < numnodes; i++) {
 		addr = nodes[i].start;
 		end = nodes[i].end;
 		if (addr >= end)
 			continue;
-		if ((end >> shift) >= NODEMAPSIZE)
+		if ((end >> shift) >= memnodemapsize)
 			return 0;
 		do {
 			if (memnodemap[addr >> shift] != 0xff)
 				return -1;
 			memnodemap[addr >> shift] = i;
-                       addr += (1UL << shift);
+			addr += (1UL << shift);
 		} while (addr < end);
 		res = 1;
 	} 
 	return res;
 }
 
-int __init compute_hash_shift(struct bootnode *nodes, int numnodes)
+static int __init allocate_cachealigned_memnodemap(void)
+{
+	unsigned long pad, pad_addr;
+
+	memnodemap = memnode.embedded_map;
+	if (memnodemapsize <= 48) {
+		printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
+		       nodemap_addr, nodemap_addr + nodemap_size);
+		return 0;
+	}
+
+	pad = L1_CACHE_BYTES - 1;
+	pad_addr = 0x8000;
+	nodemap_size = pad + memnodemapsize;
+	nodemap_addr = find_e820_area(pad_addr, end_pfn<<PAGE_SHIFT,
+				      nodemap_size);
+	if (nodemap_addr == -1UL) {
+		printk(KERN_ERR
+		       "NUMA: Unable to allocate Memory to Node hash map\n");
+		nodemap_addr = nodemap_size = 0;
+		return -1;
+	}
+	pad_addr = (nodemap_addr + pad) & ~pad;
+	memnodemap = phys_to_virt(pad_addr);
+
+	printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
+	       nodemap_addr, nodemap_addr + nodemap_size);
+	return 0;
+}
+
+/*
+ * The LSB of all start and end addresses in the node map is the value of the
+ * maximum possible shift.
+ */
+static int __init
+extract_lsb_from_nodes (const struct bootnode *nodes, int numnodes)
 {
-	int shift = 20;
+	int i;
+	unsigned long start, end;
+	unsigned long bitfield = 0, memtop = 0;
 
-	while (populate_memnodemap(nodes, numnodes, shift + 1) >= 0)
-		shift++;
+	for (i = 0; i < numnodes; i++) {
+		start = nodes[i].start;
+		end = nodes[i].end;
+		if (start >= end)
+			continue;
+		bitfield |= start | end;
+		if (end > memtop)
+			memtop = end;
+	}
+	i = find_first_bit(&bitfield, sizeof(unsigned long)*8);
+	memnodemapsize = (memtop >> i)+1;
+	return i;
+}
+
+int __init compute_hash_shift(struct bootnode *nodes, int numnodes)
+{
+	int shift;
 
+	shift = extract_lsb_from_nodes(nodes, numnodes);
+	if (allocate_cachealigned_memnodemap())
+		return -1;
 	printk(KERN_DEBUG "NUMA: Using %d for the hash shift.\n",
 		shift);
 
diff -puN include/asm-x86_64/e820.h~x86_64-make-the-numa-hash-function-nodemap-allocation include/asm-x86_64/e820.h
--- a/include/asm-x86_64/e820.h~x86_64-make-the-numa-hash-function-nodemap-allocation
+++ a/include/asm-x86_64/e820.h
@@ -56,6 +56,7 @@ extern void finish_e820_parsing(void);
 extern struct e820map e820;
 
 extern unsigned ebda_addr, ebda_size;
+extern unsigned long nodemap_addr, nodemap_size;
 #endif/*!__ASSEMBLY__*/
 
 #endif/*__E820_HEADER*/
diff -puN include/asm-x86_64/mmzone.h~x86_64-make-the-numa-hash-function-nodemap-allocation include/asm-x86_64/mmzone.h
--- a/include/asm-x86_64/mmzone.h~x86_64-make-the-numa-hash-function-nodemap-allocation
+++ a/include/asm-x86_64/mmzone.h
@@ -11,24 +11,25 @@
 
 #include <asm/smp.h>
 
-/* Should really switch to dynamic allocation at some point */
-#define NODEMAPSIZE 0x4fff
-
 /* Simple perfect hash to map physical addresses to node numbers */
 struct memnode {
 	int shift;
-	u8 map[NODEMAPSIZE];
-} ____cacheline_aligned;
+	unsigned int mapsize;
+	u8 *map;
+	u8 embedded_map[64-16];
+} ____cacheline_aligned; /* total size = 64 bytes */
 extern struct memnode memnode;
 #define memnode_shift memnode.shift
 #define memnodemap memnode.map
+#define memnodemapsize memnode.mapsize
 
 extern struct pglist_data *node_data[];
 
 static inline __attribute__((pure)) int phys_to_nid(unsigned long addr) 
 { 
 	unsigned nid; 
-	VIRTUAL_BUG_ON((addr >> memnode_shift) >= NODEMAPSIZE);
+	VIRTUAL_BUG_ON(!memnodemap);
+	VIRTUAL_BUG_ON((addr >> memnode_shift) >= memnodemapsize);
 	nid = memnodemap[addr >> memnode_shift]; 
 	VIRTUAL_BUG_ON(nid >= MAX_NUMNODES || !node_data[nid]); 
 	return nid; 
_

Patches currently in -mm which might be from amul.shah@unisys.com are

x86_64-make-the-numa-hash-function-nodemap-allocation.patch
x86_64-make-the-numa-hash-function-nodemap-allocation-fix.patch

