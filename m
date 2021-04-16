Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9664BC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 19:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 646E2613C8
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 19:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbhDPTrP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 15:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236085AbhDPTrP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 15:47:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87B76613C1;
        Fri, 16 Apr 2021 19:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618602408;
        bh=76q1M7w3hj9nmGy2pvbQOrzzyc1eVgTPVlkqQ3jThS8=;
        h=Date:From:To:Subject:From;
        b=KgCJ+nAS7lXyyqjhpG9tFOAx7Xhz4JR7/jWukzNzDeLqaGwuZ2oDTuMO2w3JeCSW0
         OUfFX4wpCPHW0ieS1h/SjB6xBAVC8OIB+vTzeozb+A3kB+XOzE5jtEzn3WnO4MwqCB
         2BZS/33k5XFG4FxZr00hwiOtJES6tlsgASpOwz5I=
Date:   Fri, 16 Apr 2021 12:46:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        pasha.tatashin@soleen.com, mhocko@suse.com, mhocko@kernel.org,
        david@redhat.com, anshuman.khandual@arm.com, osalvador@suse.de
Subject:  [to-be-updated]
 mmmemory_hotplug-allocate-memmap-from-the-added-memory-range.patch removed
 from -mm tree
Message-ID: <20210416194648.tDr_1%akpm@linux-foundation.org>
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
which specifies the number of vmemmap_pages at the beginning.  This patch
also introduces the following functions:

 - mhp_init_memmap_on_memory:

   Initializes vmemmap pages by calling move_pfn_range_to_zone(), calls
   kasan_add_zero_shadow(), and onlines as many sections as vmemmap pages
   fully span.

 - mhp_deinit_memmap_on_memory:

   Undoes what mhp_init_memmap_on_memory.

The new function memory_block_online() calls mhp_init_memmap_on_memory()
before doing the actual online_pages().  Should online_pages() fail, we
clean up by calling mhp_deinit_memmap_on_memory().  Adjusting of
present_pages is done at the end once we know that online_pages()
succedeed.

On offline, memory_block_offline() needs to unaccount vmemmap pages from
present_pages() before calling offline_pages().  This is necessary because
offline_pages() tears down some structures based on the fact whether the
node or the zone become empty.  If offline_pages() fails, we account back
vmemmap pages.  If it succeeds, we call mhp_deinit_memmap_on_memory().

Hot-remove:

 We need to be careful when removing memory, as adding and
 removing memory needs to be done with the same granularity.
 To check that this assumption is not violated, we check the
 memory range we want to remove and if a) any memory block has
 vmemmap pages and b) the range spans more than a single memory
 block, we scream out loud and refuse to proceed.

 If all is good and the range was using memmap on memory (aka vmemmap pages),
 we construct an altmap structure so free_hugepage_table does the right
 thing and calls vmem_altmap_free instead of free_pagetable.

Link: https://lkml.kernel.org/r/20210416102153.8794-5-osalvador@suse.de
Link: https://lkml.kernel.org/r/20210416112411.9826-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   71 ++++++++++++-
 include/linux/memory.h         |    8 +
 include/linux/memory_hotplug.h |   15 ++
 include/linux/memremap.h       |    2 
 include/linux/mmzone.h         |    7 -
 mm/Kconfig                     |    5 
 mm/memory_hotplug.c            |  159 +++++++++++++++++++++++++++++--
 mm/sparse.c                    |    2 
 8 files changed, 247 insertions(+), 22 deletions(-)

--- a/drivers/base/memory.c~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range
+++ a/drivers/base/memory.c
@@ -173,16 +173,72 @@ static int memory_block_online(struct me
 {
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
+	unsigned long nr_vmemmap_pages = mem->nr_vmemmap_pages;
+	struct zone *zone;
+	int ret;
+
+	zone = zone_for_pfn_range(mem->online_type, mem->nid, start_pfn, nr_pages);
+
+	/*
+	 * Although vmemmap pages have a different lifecycle than the pages
+	 * they describe (they remain until the memory is unplugged), doing
+	 * their initialization and accounting at memory onlining/offlining
+	 * stage simplifies things a lot.
+	 */
+	if (nr_vmemmap_pages) {
+		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
+		if (ret)
+			return ret;
+	}
+
+	ret = online_pages(start_pfn + nr_vmemmap_pages,
+			   nr_pages - nr_vmemmap_pages, zone);
+	if (ret) {
+		if (nr_vmemmap_pages)
+			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
+		return ret;
+	}
+
+	/*
+	 * Account once onlining succeeded. If the zone was unpopulated, it is
+	 * now already properly populated.
+	 */
+	if (nr_vmemmap_pages)
+		adjust_present_page_count(zone, nr_vmemmap_pages);
 
-	return online_pages(start_pfn, nr_pages, mem->online_type, mem->nid);
+	return ret;
 }
 
 static int memory_block_offline(struct memory_block *mem)
 {
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
+	unsigned long nr_vmemmap_pages = mem->nr_vmemmap_pages;
+	struct zone *zone;
+	int ret;
+
+	zone = page_zone(pfn_to_page(start_pfn));
+
+	/*
+	 * Unaccount before offlining, such that unpopulated zone and kthreads
+	 * can properly be torn down in offline_pages().
+	 */
+	if (nr_vmemmap_pages)
+		adjust_present_page_count(zone, -nr_vmemmap_pages);
 
-	return offline_pages(start_pfn, nr_pages);
+	ret = offline_pages(start_pfn + nr_vmemmap_pages,
+			    nr_pages - nr_vmemmap_pages);
+	if (ret) {
+		/* offline_pages() failed. Account back. */
+		if (nr_vmemmap_pages)
+			adjust_present_page_count(zone, nr_vmemmap_pages);
+		return ret;
+	}
+
+	if (nr_vmemmap_pages)
+		mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
+
+	return ret;
 }
 
 /*
@@ -576,7 +632,8 @@ int register_memory(struct memory_block
 	return ret;
 }
 
-static int init_memory_block(unsigned long block_id, unsigned long state)
+static int init_memory_block(unsigned long block_id, unsigned long state,
+			     unsigned long nr_vmemmap_pages)
 {
 	struct memory_block *mem;
 	int ret = 0;
@@ -593,6 +650,7 @@ static int init_memory_block(unsigned lo
 	mem->start_section_nr = block_id * sections_per_block;
 	mem->state = state;
 	mem->nid = NUMA_NO_NODE;
+	mem->nr_vmemmap_pages = nr_vmemmap_pages;
 
 	ret = register_memory(mem);
 
@@ -612,7 +670,7 @@ static int add_memory_block(unsigned lon
 	if (section_count == 0)
 		return 0;
 	return init_memory_block(memory_block_id(base_section_nr),
-				 MEM_ONLINE);
+				 MEM_ONLINE, 0);
 }
 
 static void unregister_memory(struct memory_block *memory)
@@ -634,7 +692,8 @@ static void unregister_memory(struct mem
  *
  * Called under device_hotplug_lock.
  */
-int create_memory_block_devices(unsigned long start, unsigned long size)
+int create_memory_block_devices(unsigned long start, unsigned long size,
+				unsigned long vmemmap_pages)
 {
 	const unsigned long start_block_id = pfn_to_block_id(PFN_DOWN(start));
 	unsigned long end_block_id = pfn_to_block_id(PFN_DOWN(start + size));
@@ -647,7 +706,7 @@ int create_memory_block_devices(unsigned
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
@@ -99,9 +107,13 @@ static inline void zone_seqlock_init(str
 extern int zone_grow_free_lists(struct zone *zone, unsigned long new_nr_pages);
 extern int zone_grow_waitqueues(struct zone *zone, unsigned long nr_pages);
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
+extern void adjust_present_page_count(struct zone *zone, long nr_pages);
 /* VM interface that may be used by firmware interface */
+extern int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
+				     struct zone *zone);
+extern void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages);
 extern int online_pages(unsigned long pfn, unsigned long nr_pages,
-			int online_type, int nid);
+			struct zone *zone);
 extern struct zone *test_pages_in_a_zone(unsigned long start_pfn,
 					 unsigned long end_pfn);
 extern void __offline_isolated_pages(unsigned long start_pfn,
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
+	 * 7. Memory-hotplug: when using memmap_on_memory and onlining the memory
+	 *    to the MOVABLE zone, the vmemmap pages are also placed in such
+	 *    zone. Such pages cannot be really moved around as they are
+	 *    self-stored in the range, but they are treated as movable when
+	 *    the range they describe is about to be offlined.
 	 *
 	 * In general, no unmovable allocations that degrade memory offlining
 	 * should end up in ZONE_MOVABLE. Allocators (like alloc_contig_range())
@@ -1387,10 +1392,8 @@ static inline int online_section_nr(unsi
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn);
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn);
 #endif
-#endif
 
 static inline struct mem_section *__pfn_to_section(unsigned long pfn)
 {
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
@@ -641,7 +643,12 @@ EXPORT_SYMBOL_GPL(generic_online_page);
 static void online_pages_range(unsigned long start_pfn, unsigned long nr_pages)
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
-	unsigned long pfn;
+	unsigned long pfn = start_pfn;
+
+	while (!IS_ALIGNED(pfn, MAX_ORDER_NR_PAGES)) {
+		(*online_page_callback)(pfn_to_page(pfn), pageblock_order);
+		pfn += pageblock_nr_pages;
+	}
 
 	/*
 	 * Online the pages in MAX_ORDER - 1 aligned chunks. The callback might
@@ -649,7 +656,7 @@ static void online_pages_range(unsigned
 	 * later). We account all pages as being online and belonging to this
 	 * zone ("present").
 	 */
-	for (pfn = start_pfn; pfn < end_pfn; pfn += MAX_ORDER_NR_PAGES)
+	for (; pfn < end_pfn; pfn += MAX_ORDER_NR_PAGES)
 		(*online_page_callback)(pfn_to_page(pfn), MAX_ORDER - 1);
 
 	/* mark all involved sections as online */
@@ -829,7 +836,11 @@ struct zone * zone_for_pfn_range(int onl
 	return default_zone_for_pfn(nid, start_pfn, nr_pages);
 }
 
-static void adjust_present_page_count(struct zone *zone, long nr_pages)
+/*
+ * This function should only be called by memory_block_{online,offline},
+ * and {online,offline}_pages.
+ */
+void adjust_present_page_count(struct zone *zone, long nr_pages)
 {
 	unsigned long flags;
 
@@ -839,12 +850,54 @@ static void adjust_present_page_count(st
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 }
 
-int __ref online_pages(unsigned long pfn, unsigned long nr_pages,
-		       int online_type, int nid)
+int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
+			      struct zone *zone)
+{
+	unsigned long end_pfn = pfn + nr_pages;
+	int ret;
+
+	ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
+	if (ret)
+		return ret;
+
+	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE);
+
+	/*
+	 * It might be that the vmemmap_pages fully span sections. If that is
+	 * the case, mark those sections online here as otherwise they will be
+	 * left offline.
+	 */
+	if (nr_pages >= PAGES_PER_SECTION)
+	        online_mem_sections(pfn, ALIGN_DOWN(end_pfn, PAGES_PER_SECTION));
+
+	return ret;
+}
+
+void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages)
+{
+	unsigned long end_pfn = pfn + nr_pages;
+
+	/*
+	 * It might be that the vmemmap_pages fully span sections. If that is
+	 * the case, mark those sections offline here as otherwise they will be
+	 * left online.
+	 */
+	if (nr_pages >= PAGES_PER_SECTION)
+		offline_mem_sections(pfn, ALIGN_DOWN(end_pfn, PAGES_PER_SECTION));
+
+        /*
+	 * The pages associated with this vmemmap have been offlined, so
+	 * we can reset its state here.
+	 */
+	remove_pfn_range_from_zone(page_zone(pfn_to_page(pfn)), pfn, nr_pages);
+	kasan_remove_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
+}
+
+int __ref online_pages(unsigned long pfn, unsigned long nr_pages, struct zone *zone)
 {
 	unsigned long flags;
-	struct zone *zone;
 	int need_zonelists_rebuild = 0;
+	const int nid = zone_to_nid(zone);
 	int ret;
 	struct memory_notify arg;
 
@@ -861,7 +914,6 @@ int __ref online_pages(unsigned long pfn
 	mem_hotplug_begin();
 
 	/* associate pfn range with the zone */
-	zone = zone_for_pfn_range(online_type, nid, pfn, nr_pages);
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_ISOLATE);
 
 	arg.start_pfn = pfn;
@@ -1075,6 +1127,45 @@ static int online_memory_block(struct me
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
+	 *       fully populate a PMD, it is not the right place to check for
+	 *       this. A much better solution involves improving vmemmap code
+	 *       to fallback to base pages when trying to populate vmemmap using
+	 *       altmap as an alternative source of memory, and we do not exactly
+	 *       populate a single PMD.
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
@@ -1084,6 +1175,7 @@ static int online_memory_block(struct me
 int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	struct vmem_altmap mhp_altmap = {};
 	u64 start, size;
 	bool new_node = false;
 	int ret;
@@ -1110,13 +1202,26 @@ int __ref add_memory_resource(int nid, s
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
@@ -1763,6 +1868,14 @@ static int check_memblock_offlined_cb(st
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
@@ -1837,6 +1950,9 @@ EXPORT_SYMBOL(try_offline_node);
 static int __ref try_remove_memory(int nid, u64 start, u64 size)
 {
 	int rc = 0;
+	struct vmem_altmap mhp_altmap = {};
+	struct vmem_altmap *altmap = NULL;
+	unsigned long nr_vmemmap_pages;
 
 	BUG_ON(check_hotplug_memory_range(start, size));
 
@@ -1849,6 +1965,31 @@ static int __ref try_remove_memory(int n
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
+					start, start + size);
+				return -EINVAL;
+			}
+
+			/*
+			 * Let remove_pmd_table->free_hugepage_table do the
+			 * right thing if we used vmem_altmap when hot-adding
+			 * the range.
+			 */
+			mhp_altmap.alloc = nr_vmemmap_pages;
+			altmap = &mhp_altmap;
+		}
+	}
+
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
 
@@ -1860,7 +2001,7 @@ static int __ref try_remove_memory(int n
 
 	mem_hotplug_begin();
 
-	arch_remove_memory(nid, start, size, NULL);
+	arch_remove_memory(nid, start, size, altmap);
 
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
 		memblock_free(start, size);
--- a/mm/sparse.c~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range
+++ a/mm/sparse.c
@@ -624,7 +624,6 @@ void online_mem_sections(unsigned long s
 	}
 }
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 /* Mark all memory sections within the pfn range as offline */
 void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -645,7 +644,6 @@ void offline_mem_sections(unsigned long
 		ms->section_mem_map &= ~SECTION_IS_ONLINE;
 	}
 }
-#endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
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

