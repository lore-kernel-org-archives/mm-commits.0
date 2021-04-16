Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7FCC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 18:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D266137D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 18:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237480AbhDPSMt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 14:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236084AbhDPSMt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 14:12:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F113460FEF;
        Fri, 16 Apr 2021 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618596743;
        bh=4uZGjNzxejYw93cFxTQW7kBrfWCPTIB2J6GgNB5bP/E=;
        h=Date:From:To:Subject:From;
        b=tqbl2rKBDjo5kDVZUKRMoymp981iFXe+AKHXiW67aZ0MeZJ7/LrzLo/3vPb1AN7gz
         EyHKITQO6NNB5jBgBC7+GTIZmB8j0FJsFtbdtxuI77L+lOlzRALdc837SY+gT4x6pv
         RV9mnZliLKRvnKMWQgi7VfuIWYlqnB7x7vcQ8yRE=
Date:   Fri, 16 Apr 2021 11:12:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        pasha.tatashin@soleen.com, mhocko@kernel.org, david@redhat.com,
        anshuman.khandual@arm.com, osalvador@suse.de
Subject:  [to-be-updated]
 mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch removed
 from -mm tree
Message-ID: <20210416181222.PoFzl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,memory_hotplug: allocate memmap from the added memory range
has been removed from the -mm tree.  Its filename was
     mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,memory_hotplug: allocate memmap from the added memory range

Patch series "Allocate memmap from hotadded memory (per device)", v5.

The primary goal of this patchset is to reduce memory overhead of the
hot-added memory (at least for SPARSEMEM_VMEMMAP memory model).  The
current way we use to populate memmap (struct page array) has two main
drawbacks:

a) it consumes an additional memory until the hotadded memory itself is
   onlined and

b) memmap might end up on a different numa node which is especially
   true for movable_node configuration.

c) due to fragmentation we might end up populating memmap with base
   pages

One way to mitigate all these issues is to simply allocate memmap array
(which is the largest memory footprint of the physical memory hotplug)
from the hot-added memory itself.  SPARSEMEM_VMEMMAP memory model allows
us to map any pfn range so the memory doesn't need to be online to be
usable for the array.  See patch 3 for more details.  This feature is only
usable when CONFIG_SPARSEMEM_VMEMMAP is set.

[Overall design]:

Implementation wise we reuse vmem_altmap infrastructure to override the
default allocator used by vmemap_populate.  memory_block structure gained
a new field called nr_vmemmap_pages.  This plays well for two reasons:

1) {offline/online}_pages know the difference between start_pfn and
   buddy_start_pfn, which is start_pfn + nr_vmemmap_pages.  In this way
   all isolation/migration operations are done to within the right range
   of memory without vmemmap pages.  This allows us for a much cleaner
   handling.

2) In try_remove_memory, we construct a new vmemap_altmap struct with
   the right information based on memory_block->nr_vmemap_pages, so we end
   up calling vmem_altmap_free instead of free_pagetable when removing the
   memory.


This patch (of 5):

Physical memory hotadd has to allocate a memmap (struct page array) for
the newly added memory section.  Currently, alloc_pages_node() is used for
those allocations.

This has some disadvantages:
 a) an existing memory is consumed for that purpose
    (eg: ~2MB per 128MB memory section on x86_64)
 b) if the whole node is movable then we have off-node struct pages
    which has performance drawbacks.
 c) It might be there are no PMD_ALIGNED chunks so memmap array gets
    populated with base pages.

This can be improved when CONFIG_SPARSEMEM_VMEMMAP is enabled.

Vmemap page tables can map arbitrary memory.  That means that we can
simply use the beginning of each memory section and map struct pages
there.  struct pages which back the allocated space then just need to be
treated carefully.

Implementation wise we will reuse vmem_altmap infrastructure to override
the default allocator used by __populate_section_memmap.  Part of the
implementation also relies on memory_block structure gaining a new field
which specifies the number of vmemmap_pages at the beginning.  This comes
in handy as in {online,offline}_pages, all the isolation and migration is
being done on (buddy_start_pfn, end_pfn] range, being buddy_start_pfn =
start_pfn + nr_vmemmap_pages.

In this way, we have:

[start_pfn, buddy_start_pfn - 1] = Initialized and PageReserved
[buddy_start_pfn, end_pfn - 1]       = Initialized and sent to buddy

Hot-remove:

 We need to be careful when removing memory, as adding and removing
 memory needs to be done with the same granularity.  To check that this
 assumption is not violated, we check the memory range we want to remove
 and if a) any memory block has vmemmap pages and b) the range spans more
 than a single memory block, we scream out loud and refuse to proceed.

 If all is good and the range was using memmap on memory (aka vmemmap
 pages), we construct an altmap structure so free_hugepage_table does the
 right thing and calls vmem_altmap_free instead of free_pagetable.

Link: https://lkml.kernel.org/r/20210319092635.6214-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20210319092635.6214-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   20 ++-
 include/linux/memory.h         |    8 +
 include/linux/memory_hotplug.h |   21 +++-
 include/linux/memremap.h       |    2 
 include/linux/mmzone.h         |    5 
 mm/Kconfig                     |    5 
 mm/memory_hotplug.c            |  158 ++++++++++++++++++++++++++-----
 mm/page_alloc.c                |    4 
 8 files changed, 187 insertions(+), 36 deletions(-)

--- a/drivers/base/memory.c~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range
+++ a/drivers/base/memory.c
@@ -175,7 +175,7 @@ int memory_notify(unsigned long val, voi
  */
 static int
 memory_block_action(unsigned long start_section_nr, unsigned long action,
-		    int online_type, int nid)
+		    int online_type, int nid, unsigned long nr_vmemmap_pages)
 {
 	unsigned long start_pfn;
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
@@ -185,10 +185,11 @@ memory_block_action(unsigned long start_
 
 	switch (action) {
 	case MEM_ONLINE:
-		ret = online_pages(start_pfn, nr_pages, online_type, nid);
+		ret = online_pages(start_pfn, nr_pages, nr_vmemmap_pages,
+				   online_type, nid);
 		break;
 	case MEM_OFFLINE:
-		ret = offline_pages(start_pfn, nr_pages);
+		ret = offline_pages(start_pfn, nr_pages, nr_vmemmap_pages);
 		break;
 	default:
 		WARN(1, KERN_WARNING "%s(%ld, %ld) unknown action: "
@@ -211,7 +212,7 @@ static int memory_block_change_state(str
 		mem->state = MEM_GOING_OFFLINE;
 
 	ret = memory_block_action(mem->start_section_nr, to_state,
-				  mem->online_type, mem->nid);
+				  mem->online_type, mem->nid, mem->nr_vmemmap_pages);
 
 	mem->state = ret ? from_state_req : to_state;
 
@@ -567,7 +568,8 @@ int register_memory(struct memory_block
 	return ret;
 }
 
-static int init_memory_block(unsigned long block_id, unsigned long state)
+static int init_memory_block(unsigned long block_id, unsigned long state,
+			     unsigned long nr_vmemmap_pages)
 {
 	struct memory_block *mem;
 	int ret = 0;
@@ -584,6 +586,7 @@ static int init_memory_block(unsigned lo
 	mem->start_section_nr = block_id * sections_per_block;
 	mem->state = state;
 	mem->nid = NUMA_NO_NODE;
+	mem->nr_vmemmap_pages = nr_vmemmap_pages;
 
 	ret = register_memory(mem);
 
@@ -603,7 +606,7 @@ static int add_memory_block(unsigned lon
 	if (section_count == 0)
 		return 0;
 	return init_memory_block(memory_block_id(base_section_nr),
-				 MEM_ONLINE);
+				 MEM_ONLINE, 0);
 }
 
 static void unregister_memory(struct memory_block *memory)
@@ -625,7 +628,8 @@ static void unregister_memory(struct mem
  *
  * Called under device_hotplug_lock.
  */
-int create_memory_block_devices(unsigned long start, unsigned long size)
+int create_memory_block_devices(unsigned long start, unsigned long size,
+				unsigned long vmemmap_pages)
 {
 	const unsigned long start_block_id = pfn_to_block_id(PFN_DOWN(start));
 	unsigned long end_block_id = pfn_to_block_id(PFN_DOWN(start + size));
@@ -638,7 +642,7 @@ int create_memory_block_devices(unsigned
 		return -EINVAL;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		ret = init_memory_block(block_id, MEM_OFFLINE);
+		ret = init_memory_block(block_id, MEM_OFFLINE, vmemmap_pages);
 		if (ret)
 			break;
 	}
--- a/include/linux/memory.h~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range
+++ a/include/linux/memory.h
@@ -29,6 +29,11 @@ struct memory_block {
 	int online_type;		/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	struct device dev;
+	/*
+	 * Number of vmemmap pages. These pages
+	 * lay at the beginning of the memory block.
+	 */
+	unsigned long nr_vmemmap_pages;
 };
 
 int arch_get_memory_phys_device(unsigned long start_pfn);
@@ -80,7 +85,8 @@ static inline int memory_notify(unsigned
 #else
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
-int create_memory_block_devices(unsigned long start, unsigned long size);
+int create_memory_block_devices(unsigned long start, unsigned long size,
+				unsigned long vmemmap_pages);
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
--- a/include/linux/memory_hotplug.h~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range
+++ a/include/linux/memory_hotplug.h
@@ -56,6 +56,14 @@ typedef int __bitwise mhp_t;
 #define MHP_MERGE_RESOURCE	((__force mhp_t)BIT(0))
 
 /*
+ * We want memmap (struct page array) to be self contained.
+ * To do so, we will use the beginning of the hot-added range to build
+ * the page tables for the memmap array that describes the entire range.
+ * Only selected architectures support it with SPARSE_VMEMMAP.
+ */
+#define MHP_MEMMAP_ON_MEMORY   ((__force mhp_t)BIT(1))
+
+/*
  * Extended parameters for memory hotplug:
  * altmap: alternative allocator for memmap array (optional)
  * pgprot: page protection flags to apply to newly created page tables
@@ -101,11 +109,13 @@ extern int zone_grow_waitqueues(struct z
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
 /* VM interface that may be used by firmware interface */
 extern int online_pages(unsigned long pfn, unsigned long nr_pages,
-			int online_type, int nid);
+			unsigned long nr_vmemmap_pages, int online_type,
+			int nid);
 extern struct zone *test_pages_in_a_zone(unsigned long start_pfn,
 					 unsigned long end_pfn);
 extern void __offline_isolated_pages(unsigned long start_pfn,
-				     unsigned long end_pfn);
+				     unsigned long end_pfn,
+				     unsigned long buddy_start_pfn);
 
 typedef void (*online_page_callback_t)(struct page *page, unsigned int order);
 
@@ -307,7 +317,8 @@ static inline void pgdat_resize_init(str
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern void try_offline_node(int nid);
-extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
+extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
+			 unsigned long nr_vmemmap_pages);
 extern int remove_memory(int nid, u64 start, u64 size);
 extern void __remove_memory(int nid, u64 start, u64 size);
 extern int offline_and_remove_memory(int nid, u64 start, u64 size);
@@ -315,7 +326,8 @@ extern int offline_and_remove_memory(int
 #else
 static inline void try_offline_node(int nid) {}
 
-static inline int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
+static inline int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
+				unsigned long nr_vmemmap_pages)
 {
 	return -EINVAL;
 }
@@ -359,6 +371,7 @@ extern struct zone *zone_for_pfn_range(i
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+extern bool mhp_supports_memmap_on_memory(unsigned long size);
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
--- a/include/linux/memremap.h~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range
+++ a/include/linux/memremap.h
@@ -17,7 +17,7 @@ struct device;
  * @alloc: track pages consumed, private to vmemmap_populate()
  */
 struct vmem_altmap {
-	const unsigned long base_pfn;
+	unsigned long base_pfn;
 	const unsigned long end_pfn;
 	const unsigned long reserve;
 	unsigned long free;
--- a/include/linux/mmzone.h~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range
+++ a/include/linux/mmzone.h
@@ -436,6 +436,11 @@ enum zone_type {
 	 *    situations where ZERO_PAGE(0) which is allocated differently
 	 *    on different platforms may end up in a movable zone. ZERO_PAGE(0)
 	 *    cannot be migrated.
+	 * 7. Memory-hotplug: when using memmap_on_memory and onlining the
+	 *    memory to the MOVABLE zone, the vmemmap pages are also placed in
+	 *    such zone. Such pages cannot be really moved around as they are
+	 *    self-stored in the range, but they are treated as movable when
+	 *    the range they describe is about to be offlined.
 	 *
 	 * In general, no unmovable allocations that degrade memory offlining
 	 * should end up in ZONE_MOVABLE. Allocators (like alloc_contig_range())
--- a/mm/Kconfig~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range
+++ a/mm/Kconfig
@@ -188,6 +188,11 @@ config MEMORY_HOTREMOVE
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
+config MHP_MEMMAP_ON_MEMORY
+	def_bool y
+	depends on MEMORY_HOTPLUG && SPARSEMEM_VMEMMAP
+	depends on ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
+
 # Heavily threaded applications may benefit from splitting the mm-wide
 # page_table_lock, so that faults on different parts of the user address
 # space can be handled with less contention: split it at this NR_CPUS.
--- a/mm/memory_hotplug.c~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range
+++ a/mm/memory_hotplug.c
@@ -42,6 +42,8 @@
 #include "internal.h"
 #include "shuffle.h"
 
+static bool memmap_on_memory;
+
 /*
  * online_page_callback contains pointer to current page onlining function.
  * Initially it is generic_online_page(). If it is required it could be
@@ -638,10 +640,22 @@ void generic_online_page(struct page *pa
 }
 EXPORT_SYMBOL_GPL(generic_online_page);
 
-static void online_pages_range(unsigned long start_pfn, unsigned long nr_pages)
+static void online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
+			       unsigned long buddy_start_pfn)
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
-	unsigned long pfn;
+	unsigned long pfn = buddy_start_pfn;
+
+	/*
+	 * When using memmap_on_memory, the range might be unaligned as the
+	 * first pfns are used for vmemmap pages. Align it in case we need to.
+	 */
+	VM_BUG_ON(!IS_ALIGNED(pfn, pageblock_nr_pages));
+
+	while (!IS_ALIGNED(pfn, MAX_ORDER_NR_PAGES)) {
+		(*online_page_callback)(pfn_to_page(pfn), pageblock_order);
+		pfn += pageblock_nr_pages;
+	}
 
 	/*
 	 * Online the pages in MAX_ORDER - 1 aligned chunks. The callback might
@@ -649,7 +663,7 @@ static void online_pages_range(unsigned
 	 * later). We account all pages as being online and belonging to this
 	 * zone ("present").
 	 */
-	for (pfn = start_pfn; pfn < end_pfn; pfn += MAX_ORDER_NR_PAGES)
+	for (; pfn < end_pfn; pfn += MAX_ORDER_NR_PAGES)
 		(*online_page_callback)(pfn_to_page(pfn), MAX_ORDER - 1);
 
 	/* mark all involved sections as online */
@@ -830,9 +844,9 @@ struct zone * zone_for_pfn_range(int onl
 }
 
 int __ref online_pages(unsigned long pfn, unsigned long nr_pages,
-		       int online_type, int nid)
+		       unsigned long nr_vmemmap_pages, int online_type, int nid)
 {
-	unsigned long flags;
+	unsigned long flags, buddy_start_pfn, buddy_nr_pages;
 	struct zone *zone;
 	int need_zonelists_rebuild = 0;
 	int ret;
@@ -843,11 +857,18 @@ int __ref online_pages(unsigned long pfn
 			 !IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
+	buddy_start_pfn = pfn + nr_vmemmap_pages;
+	buddy_nr_pages = nr_pages - nr_vmemmap_pages;
+
 	mem_hotplug_begin();
 
 	/* associate pfn range with the zone */
 	zone = zone_for_pfn_range(online_type, nid, pfn, nr_pages);
-	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_ISOLATE);
+	if (nr_vmemmap_pages)
+		move_pfn_range_to_zone(zone, pfn, nr_vmemmap_pages, NULL,
+				       MIGRATE_UNMOVABLE);
+	move_pfn_range_to_zone(zone, buddy_start_pfn, buddy_nr_pages, NULL,
+			       MIGRATE_ISOLATE);
 
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
@@ -863,7 +884,7 @@ int __ref online_pages(unsigned long pfn
 	 * onlining, such that undo_isolate_page_range() works correctly.
 	 */
 	spin_lock_irqsave(&zone->lock, flags);
-	zone->nr_isolate_pageblock += nr_pages / pageblock_nr_pages;
+	zone->nr_isolate_pageblock += buddy_nr_pages / pageblock_nr_pages;
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	/*
@@ -876,7 +897,7 @@ int __ref online_pages(unsigned long pfn
 		setup_zone_pageset(zone);
 	}
 
-	online_pages_range(pfn, nr_pages);
+	online_pages_range(pfn, nr_pages, buddy_start_pfn);
 	zone->present_pages += nr_pages;
 
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
@@ -889,7 +910,9 @@ int __ref online_pages(unsigned long pfn
 	zone_pcp_update(zone);
 
 	/* Basic onlining is complete, allow allocation of onlined pages. */
-	undo_isolate_page_range(pfn, pfn + nr_pages, MIGRATE_MOVABLE);
+	undo_isolate_page_range(buddy_start_pfn,
+				buddy_start_pfn + buddy_nr_pages,
+				MIGRATE_MOVABLE);
 
 	/*
 	 * Freshly onlined pages aren't shuffled (e.g., all pages are placed to
@@ -1064,6 +1087,45 @@ static int online_memory_block(struct me
 	return device_online(&mem->dev);
 }
 
+bool mhp_supports_memmap_on_memory(unsigned long size)
+{
+	unsigned long nr_vmemmap_pages = size / PAGE_SIZE;
+	unsigned long vmemmap_size = nr_vmemmap_pages * sizeof(struct page);
+	unsigned long remaining_size = size - vmemmap_size;
+
+	/*
+	 * Besides having arch support and the feature enabled at runtime, we
+	 * need a few more assumptions to hold true:
+	 *
+	 * a) We span a single memory block: memory onlining/offlinin;g happens
+	 *    in memory block granularity. We don't want the vmemmap of online
+	 *    memory blocks to reside on offline memory blocks. In the future,
+	 *    we might want to support variable-sized memory blocks to make the
+	 *    feature more versatile.
+	 *
+	 * b) The vmemmap pages span complete PMDs: We don't want vmemmap code
+	 *    to populate memory from the altmap for unrelated parts (i.e.,
+	 *    other memory blocks)
+	 *
+	 * c) The vmemmap pages (and thereby the pages that will be exposed to
+	 *    the buddy) have to cover full pageblocks: memory onlining/offlining
+	 *    code requires applicable ranges to be page-aligned, for example, to
+	 *    set the migratetypes properly.
+	 *
+	 * TODO: Although we have a check here to make sure that vmemmap pages
+	 *	 fully populate a PMD, it is not the right place to check for
+	 *	 this. A much better solution involves improving vmemmap code
+	 *	 to fallback to base pages when trying to populate vmemmap using
+	 *	 altmap as an alternative source of memory, and we do not exactly
+	 *	 populate a single PMD.
+	 */
+	return memmap_on_memory &&
+	       IS_ENABLED(CONFIG_MHP_MEMMAP_ON_MEMORY) &&
+	       size == memory_block_size_bytes() &&
+	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
+	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
+}
+
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1073,6 +1135,7 @@ static int online_memory_block(struct me
 int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	struct vmem_altmap mhp_altmap = {};
 	u64 start, size;
 	bool new_node = false;
 	int ret;
@@ -1099,13 +1162,26 @@ int __ref add_memory_resource(int nid, s
 		goto error;
 	new_node = ret;
 
+	/*
+	 * Self hosted memmap array
+	 */
+	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
+		if (!mhp_supports_memmap_on_memory(size)) {
+			ret = -EINVAL;
+			goto error;
+		}
+		mhp_altmap.free = PHYS_PFN(size);
+		mhp_altmap.base_pfn = PHYS_PFN(start);
+		params.altmap = &mhp_altmap;
+	}
+
 	/* call arch's memory hotadd */
 	ret = arch_add_memory(nid, start, size, &params);
 	if (ret < 0)
 		goto error;
 
 	/* create memory block devices after memory was added */
-	ret = create_memory_block_devices(start, size);
+	ret = create_memory_block_devices(start, size, mhp_altmap.alloc);
 	if (ret) {
 		arch_remove_memory(nid, start, size, NULL);
 		goto error;
@@ -1563,10 +1639,11 @@ static int count_system_ram_pages_cb(uns
 	return 0;
 }
 
-int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages)
+int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages,
+			unsigned long nr_vmemmap_pages)
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
-	unsigned long pfn, system_ram_pages = 0;
+	unsigned long pfn, buddy_start_pfn, buddy_nr_pages, system_ram_pages = 0;
 	unsigned long flags;
 	struct zone *zone;
 	struct memory_notify arg;
@@ -1578,6 +1655,9 @@ int __ref offline_pages(unsigned long st
 			 !IS_ALIGNED(start_pfn | nr_pages, PAGES_PER_SECTION)))
 		return -EINVAL;
 
+	buddy_start_pfn = start_pfn + nr_vmemmap_pages;
+	buddy_nr_pages = nr_pages - nr_vmemmap_pages;
+
 	mem_hotplug_begin();
 
 	/*
@@ -1614,7 +1694,7 @@ int __ref offline_pages(unsigned long st
 	lru_cache_disable();
 
 	/* set above range as isolated */
-	ret = start_isolate_page_range(start_pfn, end_pfn,
+	ret = start_isolate_page_range(buddy_start_pfn, end_pfn,
 				       MIGRATE_MOVABLE,
 				       MEMORY_OFFLINE | REPORT_FAILURE);
 	if (ret) {
@@ -1634,7 +1714,7 @@ int __ref offline_pages(unsigned long st
 	}
 
 	do {
-		pfn = start_pfn;
+		pfn = buddy_start_pfn;
 		do {
 			if (signal_pending(current)) {
 				ret = -EINTR;
@@ -1664,18 +1744,18 @@ int __ref offline_pages(unsigned long st
 		 * offlining actually in order to make hugetlbfs's object
 		 * counting consistent.
 		 */
-		ret = dissolve_free_huge_pages(start_pfn, end_pfn);
+		ret = dissolve_free_huge_pages(buddy_start_pfn, end_pfn);
 		if (ret) {
 			reason = "failure to dissolve huge pages";
 			goto failed_removal_isolated;
 		}
 
-		ret = test_pages_isolated(start_pfn, end_pfn, MEMORY_OFFLINE);
+		ret = test_pages_isolated(buddy_start_pfn, end_pfn, MEMORY_OFFLINE);
 
 	} while (ret);
 
 	/* Mark all sections offline and remove free pages from the buddy. */
-	__offline_isolated_pages(start_pfn, end_pfn);
+	__offline_isolated_pages(start_pfn, end_pfn, buddy_start_pfn);
 	pr_debug("Offlined Pages %ld\n", nr_pages);
 
 	/*
@@ -1684,14 +1764,14 @@ int __ref offline_pages(unsigned long st
 	 * of isolated pageblocks, memory onlining will properly revert this.
 	 */
 	spin_lock_irqsave(&zone->lock, flags);
-	zone->nr_isolate_pageblock -= nr_pages / pageblock_nr_pages;
+	zone->nr_isolate_pageblock -= buddy_nr_pages / pageblock_nr_pages;
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	lru_cache_enable();
 	zone_pcp_enable(zone);
 
 	/* removal success */
-	adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
+	adjust_managed_page_count(pfn_to_page(start_pfn), -buddy_nr_pages);
 	zone->present_pages -= nr_pages;
 
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
@@ -1720,7 +1800,7 @@ int __ref offline_pages(unsigned long st
 	return 0;
 
 failed_removal_isolated:
-	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
+	undo_isolate_page_range(buddy_start_pfn, end_pfn, MIGRATE_MOVABLE);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 failed_removal_pcplists_disabled:
 	zone_pcp_enable(zone);
@@ -1751,6 +1831,14 @@ static int check_memblock_offlined_cb(st
 	return 0;
 }
 
+static int get_nr_vmemmap_pages_cb(struct memory_block *mem, void *arg)
+{
+	/*
+	 * If not set, continue with the next block.
+	 */
+	return mem->nr_vmemmap_pages;
+}
+
 static int check_cpu_on_node(pg_data_t *pgdat)
 {
 	int cpu;
@@ -1825,6 +1913,9 @@ EXPORT_SYMBOL(try_offline_node);
 static int __ref try_remove_memory(int nid, u64 start, u64 size)
 {
 	int rc = 0;
+	struct vmem_altmap mhp_altmap = {};
+	struct vmem_altmap *altmap = NULL;
+	unsigned long nr_vmemmap_pages = 0;
 
 	BUG_ON(check_hotplug_memory_range(start, size));
 
@@ -1837,6 +1928,31 @@ static int __ref try_remove_memory(int n
 	if (rc)
 		return rc;
 
+	/*
+	 * We only support removing memory added with MHP_MEMMAP_ON_MEMORY in
+	 * the same granularity it was added - a single memory block.
+	 */
+	if (memmap_on_memory) {
+		nr_vmemmap_pages = walk_memory_blocks(start, size, NULL,
+						      get_nr_vmemmap_pages_cb);
+		if (nr_vmemmap_pages) {
+			if (size != memory_block_size_bytes()) {
+				pr_warn("Refuse to remove %#llx - %#llx,"
+					"wrong granularity\n",
+					 start, start + size);
+				return -EINVAL;
+			}
+
+			/*
+			 * Let remove_pmd_table->free_hugepage_table
+			 * do the right thing if we used vmem_altmap
+			 * when hot-adding the range.
+			 */
+			mhp_altmap.alloc = nr_vmemmap_pages;
+			altmap = &mhp_altmap;
+		}
+	}
+
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
 
@@ -1848,7 +1964,7 @@ static int __ref try_remove_memory(int n
 
 	mem_hotplug_begin();
 
-	arch_remove_memory(nid, start, size, NULL);
+	arch_remove_memory(nid, start, size, altmap);
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
 		memblock_free(start, size);
--- a/mm/page_alloc.c~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range
+++ a/mm/page_alloc.c
@@ -9042,7 +9042,8 @@ void zone_pcp_reset(struct zone *zone)
  * All pages in the range must be in a single zone, must not contain holes,
  * must span full sections, and must be isolated before calling this function.
  */
-void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
+void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn,
+			      unsigned long buddy_start_pfn)
 {
 	unsigned long pfn = start_pfn;
 	struct page *page;
@@ -9053,6 +9054,7 @@ void __offline_isolated_pages(unsigned l
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
 	spin_lock_irqsave(&zone->lock, flags);
+	pfn = buddy_start_pfn;
 	while (pfn < end_pfn) {
 		page = pfn_to_page(pfn);
 		/*
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
acpimemhotplug-enable-mhp_memmap_on_memory-when-supported.patch
mmmemory_hotplug-add-kernel-boot-option-to-enable-memmap_on_memory.patch
x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

