From: akpm@linux-foundation.org
Subject: + memblock-free-allocated-memblock_reserved_regions-later.patch added to -mm tree
Date: Fri, 29 Jun 2012 14:21:01 -0700
Message-ID: <20120629212101.AC7A8A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55695 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab2F2VVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 17:21:03 -0400
Received: by vcbfl13 with SMTP id fl13so423650vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 14:21:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, benh@kernel.crashing.org, levinsasha928@gmail.com, tj@kernel.org


The patch titled
     Subject: memblock: free allocated memblock_reserved_regions later
has been added to the -mm tree.  Its filename is
     memblock-free-allocated-memblock_reserved_regions-later.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: memblock: free allocated memblock_reserved_regions later

memblock_free_reserved_regions() calls memblock_free(), but
memblock_free() would double reserved.regions too, so we could free the
old range for reserved.regions.

Also tj said there is another bug could be related to this too.

| I don't think we're saving any noticeable
| amount by doing this "free - give it to page allocator - reserve
| again" dancing.  We should just allocate regions aligned to page
| boundaries and free them later when memblock is no longer in use.

So try to allocate that in PAGE_SIZE alignment and free that later.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
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
Subject: Subject: memblock: free allocated memblock_reserved_regions later

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
mm-fix-goal-calculating-with-usemap.patch
memblock-free-allocated-memblock_reserved_regions-later.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch

