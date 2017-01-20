From: akpm@linux-foundation.org
Subject: +
 mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section.patch added to -mm tree
Date: Thu, 19 Jan 2017 16:05:53 -0800
Message-ID: <58815461.7OSs0TN9wTVdLH1h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44944 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753500AbdATANw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 19:13:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce struct mem_section_usage to track partial population of a section
has been added to the -mm tree.  Its filename is
     mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: introduce struct mem_section_usage to track partial population of a section

'struct mem_section_usage' combines the existing 'pageblock_flags' bitmap
with a new 'map_active' bitmap.  The new bitmap enables the memory
hot{plug,remove} implementation to act on incremental sub-divisions of a
section.  The primary impetus for this functionality is to support
platforms that mix "System RAM" and "Persistent Memory" within a single
section.  We want to be able to hotplug "Persistent Memory" to extend a
partially populated section and share that section between ZONE_DEVICE and
ZONE_NORMAL/MOVABLE memory.

This introduces a pointer to the new 'map_active' bitmap through struct
mem_section, but otherwise should not change any behavior.

Link: http://lkml.kernel.org/r/148486361735.19694.17147399375362860739.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   21 +++++++-
 mm/memory_hotplug.c    |    4 -
 mm/page_alloc.c        |    2 
 mm/sparse.c            |   98 +++++++++++++++++++++------------------
 4 files changed, 75 insertions(+), 50 deletions(-)

diff -puN include/linux/mmzone.h~mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section
+++ a/include/linux/mmzone.h
@@ -1068,6 +1068,19 @@ static inline unsigned long early_pfn_to
 #define SECTION_ALIGN_UP(pfn)	(((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
 #define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
 
+#define SECTION_ACTIVE_SIZE ((1UL << SECTION_SIZE_BITS) / BITS_PER_LONG)
+#define SECTION_ACTIVE_MASK (~(SECTION_ACTIVE_SIZE - 1))
+
+struct mem_section_usage {
+	/*
+	 * SECTION_ACTIVE_SIZE portions of the section that are populated in
+	 * the memmap
+	 */
+	unsigned long map_active;
+	/* See declaration of similar field in struct zone */
+	unsigned long pageblock_flags[0];
+};
+
 struct page;
 struct page_ext;
 struct mem_section {
@@ -1085,8 +1098,7 @@ struct mem_section {
 	 */
 	unsigned long section_mem_map;
 
-	/* See declaration of similar field in struct zone */
-	unsigned long *pageblock_flags;
+	struct mem_section_usage *usage;
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
@@ -1117,6 +1129,11 @@ extern struct mem_section *mem_section[N
 extern struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT];
 #endif
 
+static inline unsigned long *section_to_usemap(struct mem_section *ms)
+{
+	return ms->usage->pageblock_flags;
+}
+
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
 	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
diff -puN mm/memory_hotplug.c~mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section
+++ a/mm/memory_hotplug.c
@@ -229,7 +229,7 @@ static void register_page_bootmem_info_s
 	for (i = 0; i < mapsize; i++, page++)
 		get_page_bootmem(section_nr, page, SECTION_INFO);
 
-	usemap = __nr_to_section(section_nr)->pageblock_flags;
+	usemap = section_to_usemap(__nr_to_section(section_nr));
 	page = virt_to_page(usemap);
 
 	mapsize = PAGE_ALIGN(usemap_size()) >> PAGE_SHIFT;
@@ -255,7 +255,7 @@ static void register_page_bootmem_info_s
 
 	register_page_bootmem_memmap(section_nr, memmap, PAGES_PER_SECTION);
 
-	usemap = __nr_to_section(section_nr)->pageblock_flags;
+	usemap = section_to_usemap(__nr_to_section(section_nr));
 	page = virt_to_page(usemap);
 
 	mapsize = PAGE_ALIGN(usemap_size()) >> PAGE_SHIFT;
diff -puN mm/page_alloc.c~mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section
+++ a/mm/page_alloc.c
@@ -353,7 +353,7 @@ static inline unsigned long *get_pageblo
 							unsigned long pfn)
 {
 #ifdef CONFIG_SPARSEMEM
-	return __pfn_to_section(pfn)->pageblock_flags;
+	return section_to_usemap(__pfn_to_section(pfn));
 #else
 	return page_zone(page)->pageblock_flags;
 #endif /* CONFIG_SPARSEMEM */
diff -puN mm/sparse.c~mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section mm/sparse.c
--- a/mm/sparse.c~mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section
+++ a/mm/sparse.c
@@ -233,15 +233,15 @@ struct page *sparse_decode_mem_map(unsig
 
 static int __meminit sparse_init_one_section(struct mem_section *ms,
 		unsigned long pnum, struct page *mem_map,
-		unsigned long *pageblock_bitmap)
+		struct mem_section_usage *usage)
 {
 	if (!present_section(ms))
 		return -EINVAL;
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
 	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum) |
-							SECTION_HAS_MEM_MAP;
- 	ms->pageblock_flags = pageblock_bitmap;
+		SECTION_HAS_MEM_MAP;
+	ms->usage = usage;
 
 	return 1;
 }
@@ -255,9 +255,13 @@ unsigned long usemap_size(void)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-static unsigned long *__kmalloc_section_usemap(void)
+static struct mem_section_usage *__alloc_section_usage(void)
 {
-	return kmalloc(usemap_size(), GFP_KERNEL);
+	struct mem_section_usage *usage;
+
+	usage = kzalloc(sizeof(*usage) + usemap_size(), GFP_KERNEL);
+	/* TODO: allocate the map_active bitmap */
+	return usage;
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
@@ -293,7 +297,8 @@ again:
 	return p;
 }
 
-static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
+static void __init check_usemap_section_nr(int nid,
+		struct mem_section_usage *usage)
 {
 	unsigned long usemap_snr, pgdat_snr;
 	static unsigned long old_usemap_snr = NR_MEM_SECTIONS;
@@ -301,7 +306,7 @@ static void __init check_usemap_section_
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	int usemap_nid;
 
-	usemap_snr = pfn_to_section_nr(__pa(usemap) >> PAGE_SHIFT);
+	usemap_snr = pfn_to_section_nr(__pa(usage) >> PAGE_SHIFT);
 	pgdat_snr = pfn_to_section_nr(__pa(pgdat) >> PAGE_SHIFT);
 	if (usemap_snr == pgdat_snr)
 		return;
@@ -336,7 +341,8 @@ sparse_early_usemaps_alloc_pgdat_section
 	return memblock_virt_alloc_node_nopanic(size, pgdat->node_id);
 }
 
-static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
+static void __init check_usemap_section_nr(int nid,
+		struct mem_section_usage *usage)
 {
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
@@ -344,26 +350,27 @@ static void __init check_usemap_section_
 static void __init sparse_early_usemaps_alloc_node(void *data,
 				 unsigned long pnum_begin,
 				 unsigned long pnum_end,
-				 unsigned long usemap_count, int nodeid)
+				 unsigned long usage_count, int nodeid)
 {
-	void *usemap;
+	void *usage;
 	unsigned long pnum;
-	unsigned long **usemap_map = (unsigned long **)data;
-	int size = usemap_size();
+	struct mem_section_usage **usage_map = data;
+	int size = sizeof(struct mem_section_usage) + usemap_size();
 
-	usemap = sparse_early_usemaps_alloc_pgdat_section(NODE_DATA(nodeid),
-							  size * usemap_count);
-	if (!usemap) {
+	usage = sparse_early_usemaps_alloc_pgdat_section(NODE_DATA(nodeid),
+							  size * usage_count);
+	if (!usage) {
 		pr_warn("%s: allocation failed\n", __func__);
 		return;
 	}
 
+	memset(usage, 0, size * usage_count);
 	for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
-		usemap_map[pnum] = usemap;
-		usemap += size;
-		check_usemap_section_nr(nodeid, usemap_map[pnum]);
+		usage_map[pnum] = usage;
+		usage += size;
+		check_usemap_section_nr(nodeid, usage_map[pnum]);
 	}
 }
 
@@ -468,7 +475,7 @@ void __weak __meminit vmemmap_populate_p
 
 /**
  *  alloc_usemap_and_memmap - memory alloction for pageblock flags and vmemmap
- *  @map: usemap_map for pageblock flags or mmap_map for vmemmap
+ *  @map: usage_map for mem_section_usage or mmap_map for vmemmap
  */
 static void __init alloc_usemap_and_memmap(void (*alloc_func)
 					(void *, unsigned long, unsigned long,
@@ -521,10 +528,9 @@ static void __init alloc_usemap_and_memm
  */
 void __init sparse_init(void)
 {
+	struct mem_section_usage *usage, **usage_map;
 	unsigned long pnum;
 	struct page *map;
-	unsigned long *usemap;
-	unsigned long **usemap_map;
 	int size;
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	int size2;
@@ -539,21 +545,21 @@ void __init sparse_init(void)
 
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
-	 * usemap is less one page (aka 24 bytes)
+	 * usage is less one page (aka 24 bytes)
 	 * so alloc 2M (with 2M align) and 24 bytes in turn will
 	 * make next 2M slip to one more 2M later.
 	 * then in big system, the memory will have a lot of holes...
 	 * here try to allocate 2M pages continuously.
 	 *
 	 * powerpc need to call sparse_init_one_section right after each
-	 * sparse_early_mem_map_alloc, so allocate usemap_map at first.
+	 * sparse_early_mem_map_alloc, so allocate usage_map at first.
 	 */
-	size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
-	usemap_map = memblock_virt_alloc(size, 0);
-	if (!usemap_map)
-		panic("can not allocate usemap_map\n");
+	size = sizeof(struct mem_section_usage *) * NR_MEM_SECTIONS;
+	usage_map = memblock_virt_alloc(size, 0);
+	if (!usage_map)
+		panic("can not allocate usage_map\n");
 	alloc_usemap_and_memmap(sparse_early_usemaps_alloc_node,
-							(void *)usemap_map);
+							(void *)usage_map);
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
@@ -568,8 +574,8 @@ void __init sparse_init(void)
 		if (!present_section_nr(pnum))
 			continue;
 
-		usemap = usemap_map[pnum];
-		if (!usemap)
+		usage = usage_map[pnum];
+		if (!usage)
 			continue;
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
@@ -581,7 +587,7 @@ void __init sparse_init(void)
 			continue;
 
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
-								usemap);
+								usage);
 	}
 
 	vmemmap_populate_print_last();
@@ -589,7 +595,7 @@ void __init sparse_init(void)
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	memblock_free_early(__pa(map_map), size2);
 #endif
-	memblock_free_early(__pa(usemap_map), size);
+	memblock_free_early(__pa(usage_map), size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -693,9 +699,9 @@ int __meminit sparse_add_one_section(str
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct pglist_data *pgdat = zone->zone_pgdat;
+	static struct mem_section_usage *usage;
 	struct mem_section *ms;
 	struct page *memmap;
-	unsigned long *usemap;
 	unsigned long flags;
 	int ret;
 
@@ -709,8 +715,8 @@ int __meminit sparse_add_one_section(str
 	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id);
 	if (!memmap)
 		return -ENOMEM;
-	usemap = __kmalloc_section_usemap();
-	if (!usemap) {
+	usage = __alloc_section_usage();
+	if (!usage) {
 		__kfree_section_memmap(memmap);
 		return -ENOMEM;
 	}
@@ -727,12 +733,12 @@ int __meminit sparse_add_one_section(str
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
-	ret = sparse_init_one_section(ms, section_nr, memmap, usemap);
+	ret = sparse_init_one_section(ms, section_nr, memmap, usage);
 
 out:
 	pgdat_resize_unlock(pgdat, &flags);
 	if (ret <= 0) {
-		kfree(usemap);
+		kfree(usage);
 		__kfree_section_memmap(memmap);
 	}
 	return ret;
@@ -760,19 +766,20 @@ static inline void clear_hwpoisoned_page
 }
 #endif
 
-static void free_section_usemap(struct page *memmap, unsigned long *usemap)
+static void free_section_usage(struct page *memmap,
+		struct mem_section_usage *usage)
 {
 	struct page *usemap_page;
 
-	if (!usemap)
+	if (!usage)
 		return;
 
-	usemap_page = virt_to_page(usemap);
+	usemap_page = virt_to_page(usage->pageblock_flags);
 	/*
 	 * Check to see if allocation came from hot-plug-add
 	 */
 	if (PageSlab(usemap_page) || PageCompound(usemap_page)) {
-		kfree(usemap);
+		kfree(usage);
 		if (memmap)
 			__kfree_section_memmap(memmap);
 		return;
@@ -790,23 +797,24 @@ static void free_section_usemap(struct p
 void sparse_remove_one_section(struct zone *zone, struct mem_section *ms,
 		unsigned long map_offset)
 {
+	unsigned long flags;
 	struct page *memmap = NULL;
-	unsigned long *usemap = NULL, flags;
+	struct mem_section_usage *usage = NULL;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 
 	pgdat_resize_lock(pgdat, &flags);
 	if (ms->section_mem_map) {
-		usemap = ms->pageblock_flags;
+		usage = ms->usage;
 		memmap = sparse_decode_mem_map(ms->section_mem_map,
 						__section_nr(ms));
 		ms->section_mem_map = 0;
-		ms->pageblock_flags = NULL;
+		ms->usage = NULL;
 	}
 	pgdat_resize_unlock(pgdat, &flags);
 
 	clear_hwpoisoned_pages(memmap + map_offset,
 			PAGES_PER_SECTION - map_offset);
-	free_section_usemap(memmap, usemap);
+	free_section_usage(memmap, usage);
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-type-width-of-section-to-from-pfn-conversion-macros.patch
mm-devm_memremap_pages-use-multi-order-radix-for-zone_device-lookups.patch
mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section.patch
mm-introduce-common-definitions-for-the-size-and-mask-of-a-section.patch
mm-cleanup-sparse_init_one_section-return-value.patch
mm-track-active-portions-of-a-section-at-boot.patch
mm-fix-register_new_memory-zone-type-detection.patch
mm-convert-kmalloc_section_memmap-to-populate_section_memmap.patch
mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch
mm-support-section-unaligned-zone_device-memory-ranges.patch
mm-enable-section-unaligned-devm_memremap_pages.patch
libnvdimm-pfn-dax-stop-padding-pmem-namespaces-to-section-alignment.patch

