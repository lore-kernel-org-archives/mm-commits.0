From: akpm@linux-foundation.org
Subject: [merged] memblock-free-allocated-memblock_reserved_regions-later.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:49 -0700
Message-ID: <20120712193750.2CAF05C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44293 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934236Ab2GLThw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:52 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr14so146132wib.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, benh@kernel.crashing.org, levinsasha928@gmail.com, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: free allocated memblock_reserved_regions later
has been removed from the -mm tree.  Its filename was
     memblock-free-allocated-memblock_reserved_regions-later.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: memblock: free allocated memblock_reserved_regions later

memblock_free_reserved_regions() calls memblock_free(), but
memblock_free() would double reserved.regions too, so we could free the
old range for reserved.regions.

Also tj said there is another bug which could be related to this.

| I don't think we're saving any noticeable
| amount by doing this "free - give it to page allocator - reserve
| again" dancing.  We should just allocate regions aligned to page
| boundaries and free them later when memblock is no longer in use.

in that case, when DEBUG_PAGEALLOC, will get panic.
[    0.000000]    memblock_free: [0x0000102febc080-0x0000102febf080]
memblock_free_reserved_regions+0x37/0x39
[    0.000000] BUG: unable to handle kernel paging request at ffff88102febd948
[    0.000000] IP: [<ffffffff836a5774>] __next_free_mem_range+0x9b/0x155
[    0.000000] PGD 4826063 PUD cf67a067 PMD cf7fa067 PTE 800000102febd160
[    0.000000] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.000000] CPU 0
[    0.000000] Pid: 0, comm: swapper Not tainted
3.5.0-rc2-next-20120614-sasha #447
[    0.000000] RIP: 0010:[<ffffffff836a5774>]  [<ffffffff836a5774>]
__next_free_mem_range+0x9b/0x155

See the discussion at https://lkml.org/lkml/2012/6/13/469

So try to allocate with PAGE_SIZE alignment and free it later.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 --
 mm/memblock.c            |   51 ++++++++++++++++---------------------
 mm/nobootmem.c           |   36 +++++++++++++++-----------
 3 files changed, 46 insertions(+), 45 deletions(-)

diff -puN include/linux/memblock.h~memblock-free-allocated-memblock_reserved_regions-later include/linux/memblock.h
--- a/include/linux/memblock.h~memblock-free-allocated-memblock_reserved_regions-later
+++ a/include/linux/memblock.h
@@ -50,9 +50,7 @@ phys_addr_t memblock_find_in_range_node(
 				phys_addr_t size, phys_addr_t align, int nid);
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
-int memblock_free_reserved_regions(void);
-int memblock_reserve_reserved_regions(void);
-
+phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
 void memblock_allow_resize(void);
 int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_add(phys_addr_t base, phys_addr_t size);
diff -puN mm/memblock.c~memblock-free-allocated-memblock_reserved_regions-later mm/memblock.c
--- a/mm/memblock.c~memblock-free-allocated-memblock_reserved_regions-later
+++ a/mm/memblock.c
@@ -143,30 +143,6 @@ phys_addr_t __init_memblock memblock_fin
 					   MAX_NUMNODES);
 }
 
-/*
- * Free memblock.reserved.regions
- */
-int __init_memblock memblock_free_reserved_regions(void)
-{
-	if (memblock.reserved.regions == memblock_reserved_init_regions)
-		return 0;
-
-	return memblock_free(__pa(memblock.reserved.regions),
-		 sizeof(struct memblock_region) * memblock.reserved.max);
-}
-
-/*
- * Reserve memblock.reserved.regions
- */
-int __init_memblock memblock_reserve_reserved_regions(void)
-{
-	if (memblock.reserved.regions == memblock_reserved_init_regions)
-		return 0;
-
-	return memblock_reserve(__pa(memblock.reserved.regions),
-		 sizeof(struct memblock_region) * memblock.reserved.max);
-}
-
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
 {
 	type->total_size -= type->regions[r].size;
@@ -184,6 +160,18 @@ static void __init_memblock memblock_rem
 	}
 }
 
+phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
+					phys_addr_t *addr)
+{
+	if (memblock.reserved.regions == memblock_reserved_init_regions)
+		return 0;
+
+	*addr = __pa(memblock.reserved.regions);
+
+	return PAGE_ALIGN(sizeof(struct memblock_region) *
+			  memblock.reserved.max);
+}
+
 /**
  * memblock_double_array - double the size of the memblock regions array
  * @type: memblock type of the regions array being doubled
@@ -204,6 +192,7 @@ static int __init_memblock memblock_doub
 						phys_addr_t new_area_size)
 {
 	struct memblock_region *new_array, *old_array;
+	phys_addr_t old_alloc_size, new_alloc_size;
 	phys_addr_t old_size, new_size, addr;
 	int use_slab = slab_is_available();
 	int *in_slab;
@@ -217,6 +206,12 @@ static int __init_memblock memblock_doub
 	/* Calculate new doubled size */
 	old_size = type->max * sizeof(struct memblock_region);
 	new_size = old_size << 1;
+	/*
+	 * We need to allocated new one align to PAGE_SIZE,
+	 *   so we can free them completely later.
+	 */
+	old_alloc_size = PAGE_ALIGN(old_size);
+	new_alloc_size = PAGE_ALIGN(new_size);
 
 	/* Retrieve the slab flag */
 	if (type == &memblock.memory)
@@ -245,11 +240,11 @@ static int __init_memblock memblock_doub
 
 		addr = memblock_find_in_range(new_area_start + new_area_size,
 						memblock.current_limit,
-						new_size, sizeof(phys_addr_t));
+						new_alloc_size, PAGE_SIZE);
 		if (!addr && new_area_size)
 			addr = memblock_find_in_range(0,
 					min(new_area_start, memblock.current_limit),
-					new_size, sizeof(phys_addr_t));
+					new_alloc_size, PAGE_SIZE);
 
 		new_array = addr ? __va(addr) : 0;
 	}
@@ -279,13 +274,13 @@ static int __init_memblock memblock_doub
 		kfree(old_array);
 	else if (old_array != memblock_memory_init_regions &&
 		 old_array != memblock_reserved_init_regions)
-		memblock_free(__pa(old_array), old_size);
+		memblock_free(__pa(old_array), old_alloc_size);
 
 	/* Reserve the new array if that comes from the memblock.
 	 * Otherwise, we needn't do it
 	 */
 	if (!use_slab)
-		BUG_ON(memblock_reserve(addr, new_size));
+		BUG_ON(memblock_reserve(addr, new_alloc_size));
 
 	/* Update slab flag */
 	*in_slab = use_slab;
diff -puN mm/nobootmem.c~memblock-free-allocated-memblock_reserved_regions-later mm/nobootmem.c
--- a/mm/nobootmem.c~memblock-free-allocated-memblock_reserved_regions-later
+++ a/mm/nobootmem.c
@@ -105,27 +105,35 @@ static void __init __free_pages_memory(u
 		__free_pages_bootmem(pfn_to_page(i), 0);
 }
 
+static unsigned long __init __free_memory_core(phys_addr_t start,
+				 phys_addr_t end)
+{
+	unsigned long start_pfn = PFN_UP(start);
+	unsigned long end_pfn = min_t(unsigned long,
+				      PFN_DOWN(end), max_low_pfn);
+
+	if (start_pfn > end_pfn)
+		return 0;
+
+	__free_pages_memory(start_pfn, end_pfn);
+
+	return end_pfn - start_pfn;
+}
+
 unsigned long __init free_low_memory_core_early(int nodeid)
 {
 	unsigned long count = 0;
-	phys_addr_t start, end;
+	phys_addr_t start, end, size;
 	u64 i;
 
-	/* free reserved array temporarily so that it's treated as free area */
-	memblock_free_reserved_regions();
+	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL)
+		count += __free_memory_core(start, end);
 
-	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL) {
-		unsigned long start_pfn = PFN_UP(start);
-		unsigned long end_pfn = min_t(unsigned long,
-					      PFN_DOWN(end), max_low_pfn);
-		if (start_pfn < end_pfn) {
-			__free_pages_memory(start_pfn, end_pfn);
-			count += end_pfn - start_pfn;
-		}
-	}
+	/* free range that is used for reserved array if we allocate it */
+	size = get_allocated_memblock_reserved_regions_info(&start);
+	if (size)
+		count += __free_memory_core(start, start + size);
 
-	/* put region array back? */
-	memblock_reserve_reserved_regions();
 	return count;
 }
 
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

