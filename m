From: akpm@linux-foundation.org
Subject: [merged]
 mm-sparse-use-memblock-apis-for-early-memory-allocations.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:14:12 -0800
Message-ID: <52e02694.Lvzbf1qQuIngFIY9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaAVUON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, santosh.shilimkar@ti.com

Subject: [merged] mm-sparse-use-memblock-apis-for-early-memory-allocations.patch removed from -mm tree
To: santosh.shilimkar@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:12 -0800


The patch titled
     Subject: mm/sparse: use memblock apis for early memory allocations
has been removed from the -mm tree.  Its filename was
     mm-sparse-use-memblock-apis-for-early-memory-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: mm/sparse: use memblock apis for early memory allocations

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator.  No functional change in beahvior than what it is in
current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock interfaces
instead of bootmem wrappers build on top of memblock.  And the archs which
still uses bootmem, these new apis just fallback to exiting bootmem APIs.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    6 ++++--
 mm/sparse.c         |   27 +++++++++++++++------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff -puN mm/sparse-vmemmap.c~mm-sparse-use-memblock-apis-for-early-memory-allocations mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-sparse-use-memblock-apis-for-early-memory-allocations
+++ a/mm/sparse-vmemmap.c
@@ -40,7 +40,8 @@ static void * __init_refok __earlyonly_b
 				unsigned long align,
 				unsigned long goal)
 {
-	return __alloc_bootmem_node_high(NODE_DATA(node), size, align, goal);
+	return memblock_virt_alloc_try_nid(size, align, goal,
+					    BOOTMEM_ALLOC_ACCESSIBLE, node);
 }
 
 static void *vmemmap_buf;
@@ -226,7 +227,8 @@ void __init sparse_mem_maps_populate_nod
 
 	if (vmemmap_buf_start) {
 		/* need to free left buf */
-		free_bootmem(__pa(vmemmap_buf), vmemmap_buf_end - vmemmap_buf);
+		memblock_free_early(__pa(vmemmap_buf),
+				    vmemmap_buf_end - vmemmap_buf);
 		vmemmap_buf = NULL;
 		vmemmap_buf_end = NULL;
 	}
diff -puN mm/sparse.c~mm-sparse-use-memblock-apis-for-early-memory-allocations mm/sparse.c
--- a/mm/sparse.c~mm-sparse-use-memblock-apis-for-early-memory-allocations
+++ a/mm/sparse.c
@@ -69,7 +69,7 @@ static struct mem_section noinline __ini
 		else
 			section = kzalloc(array_size, GFP_KERNEL);
 	} else {
-		section = alloc_bootmem_node(NODE_DATA(nid), array_size);
+		section = memblock_virt_alloc_node(array_size, nid);
 	}
 
 	return section;
@@ -279,8 +279,9 @@ sparse_early_usemaps_alloc_pgdat_section
 	limit = goal + (1UL << PA_SECTION_SHIFT);
 	nid = early_pfn_to_nid(goal >> PAGE_SHIFT);
 again:
-	p = ___alloc_bootmem_node_nopanic(NODE_DATA(nid), size,
-					  SMP_CACHE_BYTES, goal, limit);
+	p = memblock_virt_alloc_try_nid_nopanic(size,
+						SMP_CACHE_BYTES, goal, limit,
+						nid);
 	if (!p && limit) {
 		limit = 0;
 		goto again;
@@ -331,7 +332,7 @@ static unsigned long * __init
 sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
 					 unsigned long size)
 {
-	return alloc_bootmem_node_nopanic(pgdat, size);
+	return memblock_virt_alloc_node_nopanic(size, pgdat->node_id);
 }
 
 static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
@@ -376,8 +377,9 @@ struct page __init *sparse_mem_map_popul
 		return map;
 
 	size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
-	map = __alloc_bootmem_node_high(NODE_DATA(nid), size,
-					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	map = memblock_virt_alloc_try_nid(size,
+					  PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
+					  BOOTMEM_ALLOC_ACCESSIBLE, nid);
 	return map;
 }
 void __init sparse_mem_maps_populate_node(struct page **map_map,
@@ -401,8 +403,9 @@ void __init sparse_mem_maps_populate_nod
 	}
 
 	size = PAGE_ALIGN(size);
-	map = __alloc_bootmem_node_high(NODE_DATA(nodeid), size * map_count,
-					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	map = memblock_virt_alloc_try_nid(size * map_count,
+					  PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
+					  BOOTMEM_ALLOC_ACCESSIBLE, nodeid);
 	if (map) {
 		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
 			if (!present_section_nr(pnum))
@@ -545,7 +548,7 @@ void __init sparse_init(void)
 	 * sparse_early_mem_map_alloc, so allocate usemap_map at first.
 	 */
 	size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
-	usemap_map = alloc_bootmem(size);
+	usemap_map = memblock_virt_alloc(size, 0);
 	if (!usemap_map)
 		panic("can not allocate usemap_map\n");
 	alloc_usemap_and_memmap(sparse_early_usemaps_alloc_node,
@@ -553,7 +556,7 @@ void __init sparse_init(void)
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
-	map_map = alloc_bootmem(size2);
+	map_map = memblock_virt_alloc(size2, 0);
 	if (!map_map)
 		panic("can not allocate map_map\n");
 	alloc_usemap_and_memmap(sparse_early_mem_maps_alloc_node,
@@ -583,9 +586,9 @@ void __init sparse_init(void)
 	vmemmap_populate_print_last();
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
-	free_bootmem(__pa(map_map), size2);
+	memblock_free_early(__pa(map_map), size2);
 #endif
-	free_bootmem(__pa(usemap_map), size);
+	memblock_free_early(__pa(usemap_map), size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
linux-next.patch

