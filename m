From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-convert-kmalloc_section_memmap-to-populate_section_memmap.patch removed
 from -mm tree
Date: Wed, 15 Feb 2017 13:51:59 -0800
Message-ID: <58a4cd7f.ukNNdPH56GvrbyoS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbdBOVwF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 16:52:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert kmalloc_section_memmap() to populate_section_memmap()
has been removed from the -mm tree.  Its filename was
     mm-convert-kmalloc_section_memmap-to-populate_section_memmap.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: convert kmalloc_section_memmap() to populate_section_memmap()

Allow sub-section sized ranges to be added to the memmap. 
populate_section_memmap() takes an explict pfn range rather than assuming
a full section, and those parameters are plumbed all the way through to
vmmemap_populate().  There should be no sub-section in current code.  New
warnings are added to clarify which memmap allocation paths are
sub-section capable.

Link: http://lkml.kernel.org/r/148486364441.19694.15498867968502173386.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    4 ++
 include/linux/mm.h    |    3 +-
 mm/sparse-vmemmap.c   |   24 +++++++++++-----
 mm/sparse.c           |   60 ++++++++++++++++++++++++++--------------
 4 files changed, 61 insertions(+), 30 deletions(-)

diff -puN arch/x86/mm/init_64.c~mm-convert-kmalloc_section_memmap-to-populate_section_memmap arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-convert-kmalloc_section_memmap-to-populate_section_memmap
+++ a/arch/x86/mm/init_64.c
@@ -1220,7 +1220,9 @@ int __meminit vmemmap_populate(unsigned
 	struct vmem_altmap *altmap = to_vmem_altmap(start);
 	int err;
 
-	if (boot_cpu_has(X86_FEATURE_PSE))
+	if (end - start < PAGES_PER_SECTION * sizeof(struct page))
+		err = vmemmap_populate_basepages(start, end, node);
+	else if (boot_cpu_has(X86_FEATURE_PSE))
 		err = vmemmap_populate_hugepages(start, end, node, altmap);
 	else if (altmap) {
 		pr_err_once("%s: no cpu support for altmap allocations\n",
diff -puN include/linux/mm.h~mm-convert-kmalloc_section_memmap-to-populate_section_memmap include/linux/mm.h
--- a/include/linux/mm.h~mm-convert-kmalloc_section_memmap-to-populate_section_memmap
+++ a/include/linux/mm.h
@@ -2345,7 +2345,8 @@ void sparse_mem_maps_populate_node(struc
 				   unsigned long map_count,
 				   int nodeid);
 
-struct page *sparse_mem_map_populate(unsigned long pnum, int nid);
+struct page *__populate_section_memmap(unsigned long pfn,
+		unsigned long nr_pages, int nid);
 pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
 pud_t *vmemmap_pud_populate(pgd_t *pgd, unsigned long addr, int node);
 pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
diff -puN mm/sparse-vmemmap.c~mm-convert-kmalloc_section_memmap-to-populate_section_memmap mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-convert-kmalloc_section_memmap-to-populate_section_memmap
+++ a/mm/sparse-vmemmap.c
@@ -248,20 +248,28 @@ int __meminit vmemmap_populate_basepages
 	return 0;
 }
 
-struct page * __meminit sparse_mem_map_populate(unsigned long pnum, int nid)
+struct page * __meminit __populate_section_memmap(unsigned long pfn,
+		unsigned long nr_pages, int nid)
 {
 	unsigned long start;
 	unsigned long end;
-	struct page *map;
 
-	map = pfn_to_page(pnum * PAGES_PER_SECTION);
-	start = (unsigned long)map;
-	end = (unsigned long)(map + PAGES_PER_SECTION);
+	/*
+	 * The minimum granularity of memmap extensions is
+	 * SECTION_ACTIVE_SIZE as allocations are tracked in the
+	 * 'map_active' bitmap of the section.
+	 */
+	end = ALIGN(pfn + nr_pages, PHYS_PFN(SECTION_ACTIVE_SIZE));
+	pfn &= PHYS_PFN(SECTION_ACTIVE_MASK);
+	nr_pages = end - pfn;
+
+	start = (unsigned long) pfn_to_page(pfn);
+	end = start + nr_pages * sizeof(struct page);
 
 	if (vmemmap_populate(start, end, nid))
 		return NULL;
 
-	return map;
+	return pfn_to_page(pfn);
 }
 
 void __init sparse_mem_maps_populate_node(struct page **map_map,
@@ -284,11 +292,13 @@ void __init sparse_mem_maps_populate_nod
 
 	for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
 		struct mem_section *ms;
+		unsigned long pfn = section_nr_to_pfn(pnum);
 
 		if (!present_section_nr(pnum))
 			continue;
 
-		map_map[pnum] = sparse_mem_map_populate(pnum, nodeid);
+		map_map[pnum] = __populate_section_memmap(pfn,
+				PAGES_PER_SECTION, nodeid);
 		if (map_map[pnum])
 			continue;
 		ms = __nr_to_section(pnum);
diff -puN mm/sparse.c~mm-convert-kmalloc_section_memmap-to-populate_section_memmap mm/sparse.c
--- a/mm/sparse.c~mm-convert-kmalloc_section_memmap-to-populate_section_memmap
+++ a/mm/sparse.c
@@ -423,7 +423,8 @@ static void __init sparse_early_usemaps_
 }
 
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
-struct page __init *sparse_mem_map_populate(unsigned long pnum, int nid)
+struct page __init *__populate_section_memmap(unsigned long pfn,
+		unsigned long nr_pages, int nid)
 {
 	struct page *map;
 	unsigned long size;
@@ -475,10 +476,12 @@ void __init sparse_mem_maps_populate_nod
 	/* fallback */
 	for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
 		struct mem_section *ms;
+		unsigned long pfn = section_nr_to_pfn(pnum);
 
 		if (!present_section_nr(pnum))
 			continue;
-		map_map[pnum] = sparse_mem_map_populate(pnum, nodeid);
+		map_map[pnum] = __populate_section_memmap(pfn,
+				PAGES_PER_SECTION, nodeid);
 		if (map_map[pnum])
 			continue;
 		ms = __nr_to_section(pnum);
@@ -506,7 +509,8 @@ static struct page __init *sparse_early_
 	struct mem_section *ms = __nr_to_section(pnum);
 	int nid = sparse_early_nid(ms);
 
-	map = sparse_mem_map_populate(pnum, nid);
+	map = __populate_section_memmap(section_nr_to_pfn(pnum),
+			PAGES_PER_SECTION, nid);
 	if (map)
 		return map;
 
@@ -648,15 +652,16 @@ void __init sparse_init(void)
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid)
+static struct page *populate_section_memmap(unsigned long pfn,
+		unsigned long nr_pages, int nid)
 {
-	/* This will make the necessary allocations eventually. */
-	return sparse_mem_map_populate(pnum, nid);
+	return __populate_section_memmap(pfn, nr_pages, nid);
 }
-static void __kfree_section_memmap(struct page *memmap)
+
+static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages)
 {
-	unsigned long start = (unsigned long)memmap;
-	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
+	unsigned long start = (unsigned long) pfn_to_page(pfn);
+	unsigned long end = start + nr_pages * sizeof(struct page);
 
 	vmemmap_free(start, end);
 }
@@ -670,11 +675,18 @@ static void free_map_bootmem(struct page
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 #else
-static struct page *__kmalloc_section_memmap(void)
+struct page *populate_section_memmap(unsigned long pfn,
+		unsigned long nr_pages, int nid)
 {
 	struct page *page, *ret;
 	unsigned long memmap_size = sizeof(struct page) * PAGES_PER_SECTION;
 
+	if ((pfn & ~PAGE_SECTION_MASK) || nr_pages != PAGES_PER_SECTION) {
+		WARN(1, "%s: called with section unaligned parameters\n",
+				__func__);
+		return NULL;
+	}
+
 	page = alloc_pages(GFP_KERNEL|__GFP_NOWARN, get_order(memmap_size));
 	if (page)
 		goto got_map_page;
@@ -691,13 +703,16 @@ got_map_ptr:
 	return ret;
 }
 
-static inline struct page *kmalloc_section_memmap(unsigned long pnum, int nid)
+static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages)
 {
-	return __kmalloc_section_memmap();
-}
+	struct page *memmap = pfn_to_page(pfn);
+
+	if ((pfn & ~PAGE_SECTION_MASK) || nr_pages != PAGES_PER_SECTION) {
+		WARN(1, "%s: called with section unaligned parameters\n",
+				__func__);
+		return;
+	}
 
-static void __kfree_section_memmap(struct page *memmap)
-{
 	if (is_vmalloc_addr(memmap))
 		vfree(memmap);
 	else
@@ -755,12 +770,13 @@ int __meminit sparse_add_one_section(str
 	ret = sparse_index_init(section_nr, pgdat->node_id);
 	if (ret < 0 && ret != -EEXIST)
 		return ret;
-	memmap = kmalloc_section_memmap(section_nr, pgdat->node_id);
+	memmap = populate_section_memmap(start_pfn, PAGES_PER_SECTION,
+			pgdat->node_id);
 	if (!memmap)
 		return -ENOMEM;
 	usage = __alloc_section_usage();
 	if (!usage) {
-		__kfree_section_memmap(memmap);
+		depopulate_section_memmap(start_pfn, PAGES_PER_SECTION);
 		return -ENOMEM;
 	}
 
@@ -782,7 +798,7 @@ out:
 	pgdat_resize_unlock(pgdat, &flags);
 	if (ret < 0 && ret != -EEXIST) {
 		kfree(usage);
-		__kfree_section_memmap(memmap);
+		depopulate_section_memmap(start_pfn, PAGES_PER_SECTION);
 		return ret;
 	}
 	return 0;
@@ -811,7 +827,8 @@ static inline void clear_hwpoisoned_page
 #endif
 
 static void free_section_usage(struct page *memmap,
-		struct mem_section_usage *usage)
+		struct mem_section_usage *usage, unsigned long pfn,
+		unsigned long nr_pages)
 {
 	struct page *usemap_page;
 
@@ -825,7 +842,7 @@ static void free_section_usage(struct pa
 	if (PageSlab(usemap_page) || PageCompound(usemap_page)) {
 		kfree(usage);
 		if (memmap)
-			__kfree_section_memmap(memmap);
+			depopulate_section_memmap(pfn, nr_pages);
 		return;
 	}
 
@@ -858,7 +875,8 @@ void sparse_remove_one_section(struct zo
 
 	clear_hwpoisoned_pages(memmap + map_offset,
 			PAGES_PER_SECTION - map_offset);
-	free_section_usage(memmap, usage);
+	free_section_usage(memmap, usage, section_nr_to_pfn(__section_nr(ms)),
+			PAGES_PER_SECTION);
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch
mm-support-section-unaligned-zone_device-memory-ranges.patch
mm-enable-section-unaligned-devm_memremap_pages.patch
libnvdimm-pfn-dax-stop-padding-pmem-namespaces-to-section-alignment.patch
mm-fix-get_user_pages-vs-device-dax-pud-mappings.patch

