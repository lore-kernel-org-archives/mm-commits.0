From: akpm@linux-foundation.org
Subject: [merged]
 x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch removed
 from -mm tree
Date: Thu, 18 Sep 2014 11:31:21 -0700
Message-ID: <541b24f9.z+y94FUnqzElpRLi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaIRSbW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 14:31:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lcapitulino@redhat.com, andi@firstfloor.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, mingo@elte.hu, riel@redhat.com, rientjes@google.com, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: numa: setup_node_data(): drop dead code and rename function
has been removed from the -mm tree.  Its filename was
     x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: x86: numa: setup_node_data(): drop dead code and rename function

The setup_node_data() function allocates a pg_data_t object, inserts it
into the node_data[] array and initializes the following fields: node_id,
node_start_pfn and node_spanned_pages.

However, a few function calls later during the kernel boot,
free_area_init_node() re-initializes those fields, possibly with
setup_node_data() is not used.

This causes a small glitch when running Linux as a hyperv numa guest:

[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x02 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x03 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x80200000-0xf7ffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x100000000-0x1081fffff]
[    0.000000] NUMA: Node 1 [mem 0x80200000-0xf7ffffff] + [mem 0x100000000-0x1081fffff] -> [mem 0x80200000-0x1081fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x7fffffff]
[    0.000000]   NODE_DATA [mem 0x7ffdc000-0x7ffeffff]
[    0.000000] Initmem setup node 1 [mem 0x80800000-0x1081fffff]
[    0.000000]   NODE_DATA [mem 0x1081ea000-0x1081fdfff]
[    0.000000] crashkernel: memory value expected
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007de00000-ffff88007fdfffff] on node 0
[    0.000000]  [ffffea0002000000-ffffea00043fffff] PMD -> [ffff880105600000-ffff8801077fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x1081fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7ffeffff]
[    0.000000]   node   1: [mem 0x80200000-0xf7ffffff]
[    0.000000]   node   1: [mem 0x100000000-0x1081fffff]
[    0.000000] On node 0 totalpages: 524174
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8128 pages used for memmap
[    0.000000]   DMA32 zone: 520176 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 524288
[    0.000000]   DMA32 zone: 7672 pages used for memmap
[    0.000000]   DMA32 zone: 491008 pages, LIFO batch:31
[    0.000000]   Normal zone: 520 pages used for memmap
[    0.000000]   Normal zone: 33280 pages, LIFO batch:7

In this dmesg, the SRAT table reports that the memory range for node 1
starts at 0x80200000.  However, the line starting with "Initmem" reports
that node 1 memory range starts at 0x80800000.  The "Initmem" line is
reported by setup_node_data() and is wrong, because the kernel ends up
using the range as reported in the SRAT table.

This commit drops all that dead code from setup_node_data(), renames it to
alloc_node_data() and adds a printk() to free_area_init_node() so that we
report a node's memory range accurately.

Here's the same dmesg section with this patch applied:

[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x02 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x03 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x80200000-0xf7ffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x100000000-0x1081fffff]
[    0.000000] NUMA: Node 1 [mem 0x80200000-0xf7ffffff] + [mem 0x100000000-0x1081fffff] -> [mem 0x80200000-0x1081fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x7ffdc000-0x7ffeffff]
[    0.000000] NODE_DATA(1) allocated [mem 0x1081ea000-0x1081fdfff]
[    0.000000] crashkernel: memory value expected
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007de00000-ffff88007fdfffff] on node 0
[    0.000000]  [ffffea0002000000-ffffea00043fffff] PMD -> [ffff880105600000-ffff8801077fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x1081fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7ffeffff]
[    0.000000]   node   1: [mem 0x80200000-0xf7ffffff]
[    0.000000]   node   1: [mem 0x100000000-0x1081fffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x7ffeffff]
[    0.000000] On node 0 totalpages: 524174
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8128 pages used for memmap
[    0.000000]   DMA32 zone: 520176 pages, LIFO batch:31
[    0.000000] Initmem setup node 1 [mem 0x80200000-0x1081fffff]
[    0.000000] On node 1 totalpages: 524288
[    0.000000]   DMA32 zone: 7672 pages used for memmap
[    0.000000]   DMA32 zone: 491008 pages, LIFO batch:31
[    0.000000]   Normal zone: 520 pages used for memmap
[    0.000000]   Normal zone: 33280 pages, LIFO batch:7

This commit was tested on a two node bare-metal NUMA machine and Linux as
a numa guest on hyperv and qemu/kvm.

PS: The wrong memory range reported by setup_node_data() seems to be
    harmless in the current kernel because it's just not used.  However,
    that bad range is used in kernel 2.6.32 to initialize the old boot
    memory allocator, which causes a crash during boot.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/numa.h |    1 -
 arch/x86/mm/numa.c          |   34 ++++++++++++++--------------------
 mm/page_alloc.c             |    2 ++
 3 files changed, 16 insertions(+), 21 deletions(-)

diff -puN arch/x86/include/asm/numa.h~x86-numa-setup_node_data-drop-dead-code-and-rename-function arch/x86/include/asm/numa.h
--- a/arch/x86/include/asm/numa.h~x86-numa-setup_node_data-drop-dead-code-and-rename-function
+++ a/arch/x86/include/asm/numa.h
@@ -9,7 +9,6 @@
 #ifdef CONFIG_NUMA
 
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
-#define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
 /*
  * Too small node sizes may confuse the VM badly. Usually they
diff -puN arch/x86/mm/numa.c~x86-numa-setup_node_data-drop-dead-code-and-rename-function arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~x86-numa-setup_node_data-drop-dead-code-and-rename-function
+++ a/arch/x86/mm/numa.c
@@ -185,8 +185,8 @@ int __init numa_add_memblk(int nid, u64
 	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
 }
 
-/* Initialize NODE_DATA for a node on the local memory */
-static void __init setup_node_data(int nid, u64 start, u64 end)
+/* Allocate NODE_DATA for a node on the local memory */
+static void __init alloc_node_data(int nid)
 {
 	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	u64 nd_pa;
@@ -194,18 +194,6 @@ static void __init setup_node_data(int n
 	int tnid;
 
 	/*
-	 * Don't confuse VM with a node that doesn't have the
-	 * minimum amount of memory:
-	 */
-	if (end && (end - start) < NODE_MIN_SIZE)
-		return;
-
-	start = roundup(start, ZONE_ALIGN);
-
-	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n",
-	       nid, start, end - 1);
-
-	/*
 	 * Allocate node data.  Try node-local memory and then any node.
 	 * Never allocate in DMA zone.
 	 */
@@ -222,7 +210,7 @@ static void __init setup_node_data(int n
 	nd = __va(nd_pa);
 
 	/* report and initialize */
-	printk(KERN_INFO "  NODE_DATA [mem %#010Lx-%#010Lx]\n",
+	printk(KERN_INFO "NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
 	       nd_pa, nd_pa + nd_size - 1);
 	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
 	if (tnid != nid)
@@ -230,9 +218,6 @@ static void __init setup_node_data(int n
 
 	node_data[nid] = nd;
 	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
-	NODE_DATA(nid)->node_id = nid;
-	NODE_DATA(nid)->node_start_pfn = start >> PAGE_SHIFT;
-	NODE_DATA(nid)->node_spanned_pages = (end - start) >> PAGE_SHIFT;
 
 	node_set_online(nid);
 }
@@ -523,8 +508,17 @@ static int __init numa_register_memblks(
 			end = max(mi->blk[i].end, end);
 		}
 
-		if (start < end)
-			setup_node_data(nid, start, end);
+		if (start >= end)
+			continue;
+
+		/*
+		 * Don't confuse VM with a node that doesn't have the
+		 * minimum amount of memory:
+		 */
+		if (end && (end - start) < NODE_MIN_SIZE)
+			continue;
+
+		alloc_node_data(nid);
 	}
 
 	/* Dump memblock with node info and return. */
diff -puN mm/page_alloc.c~x86-numa-setup_node_data-drop-dead-code-and-rename-function mm/page_alloc.c
--- a/mm/page_alloc.c~x86-numa-setup_node_data-drop-dead-code-and-rename-function
+++ a/mm/page_alloc.c
@@ -4976,6 +4976,8 @@ void __paginginit free_area_init_node(in
 	pgdat->node_start_pfn = node_start_pfn;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n", nid,
+			(u64) start_pfn << PAGE_SHIFT, (u64) (end_pfn << PAGE_SHIFT) - 1);
 #endif
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
 				  zones_size, zholes_size);
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

linux-next.patch

