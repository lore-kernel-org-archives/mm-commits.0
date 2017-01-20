From: akpm@linux-foundation.org
Subject: + mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch added to -mm tree
Date: Thu, 19 Jan 2017 16:06:11 -0800
Message-ID: <58815473.jWUCf+2n4hZu2yTM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44884 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753520AbdATAHY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 19:07:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prepare for hot-{add, remove} of sub-section ranges
has been added to the -mm tree.  Its filename is
     mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch

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
Subject: mm: prepare for hot-{add, remove} of sub-section ranges

Prepare the memory hot-{add,remove} paths for handling sub-section ranges
by plumbing the starting page frame and number of pages being handled
through arch_{add,remove}_memory() to sparse_{add,remove}_one_section().

This is simply plumbing, small cleanups, and some identifier renames.  No
intended functional changes.

Link: http://lkml.kernel.org/r/148486364991.19694.14012559642668647057.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c          |   11 ++++
 include/linux/memory_hotplug.h |    6 +-
 mm/memory_hotplug.c            |   85 ++++++++++++++++---------------
 mm/sparse.c                    |    6 +-
 4 files changed, 65 insertions(+), 43 deletions(-)

diff -puN arch/x86/mm/init_64.c~mm-prepare-for-hot-add-remove-of-sub-section-ranges arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-prepare-for-hot-add-remove-of-sub-section-ranges
+++ a/arch/x86/mm/init_64.c
@@ -650,6 +650,17 @@ int arch_add_memory(int nid, u64 start,
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
+	/*
+	 * Only allow partial section hotplug for ZONE_DEVICE ranges,
+	 * since register_new_memory() requires section alignment, and
+	 * CONFIG_SPARSEMEM_VMEMMAP=n requires sections to be fully
+	 * populated.
+	 */
+	if ((!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) || !for_device)
+			&& ((start & ~PA_SECTION_MASK)
+				|| (size & ~PA_SECTION_MASK)))
+		return -EINVAL;
+
 	init_memory_mapping(start, start + size);
 
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
diff -puN include/linux/memory_hotplug.h~mm-prepare-for-hot-add-remove-of-sub-section-ranges include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-prepare-for-hot-add-remove-of-sub-section-ranges
+++ a/include/linux/memory_hotplug.h
@@ -279,8 +279,10 @@ extern int arch_add_memory(int nid, u64
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern void remove_memory(int nid, u64 start, u64 size);
-extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn);
-extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms,
+extern int sparse_add_section(struct zone *zone, unsigned long pfn,
+		unsigned long nr_pages);
+extern void sparse_remove_section(struct zone *zone, struct mem_section *ms,
+		unsigned long pfn, unsigned long nr_pages,
 		unsigned long map_offset);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
diff -puN mm/memory_hotplug.c~mm-prepare-for-hot-add-remove-of-sub-section-ranges mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-prepare-for-hot-add-remove-of-sub-section-ranges
+++ a/mm/memory_hotplug.c
@@ -468,10 +468,10 @@ static void __meminit grow_pgdat_span(st
 					pgdat->node_start_pfn;
 }
 
-static int __meminit __add_zone(struct zone *zone, unsigned long phys_start_pfn)
+static int __meminit __add_zone(struct zone *zone, unsigned long phys_start_pfn,
+		unsigned long nr_pages)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
-	int nr_pages = PAGES_PER_SECTION;
 	int nid = pgdat->node_id;
 	int zone_type;
 	unsigned long flags, pfn;
@@ -501,24 +501,21 @@ static int __meminit __add_zone(struct z
 }
 
 static int __meminit __add_section(int nid, struct zone *zone,
-					unsigned long phys_start_pfn)
+		unsigned long pfn, unsigned long nr_pages)
 {
 	int ret;
 
-	if (pfn_valid(phys_start_pfn))
-		return -EEXIST;
-
-	ret = sparse_add_one_section(zone, phys_start_pfn);
+	ret = sparse_add_section(zone, pfn, nr_pages);
 
 	if (ret < 0)
 		return ret;
 
-	ret = __add_zone(zone, phys_start_pfn);
+	ret = __add_zone(zone, pfn, nr_pages);
 
 	if (ret < 0)
 		return ret;
 
-	return register_new_memory(zone, nid, __pfn_to_section(phys_start_pfn));
+	return register_new_memory(zone, nid, __pfn_to_section(pfn));
 }
 
 /*
@@ -527,7 +524,7 @@ static int __meminit __add_section(int n
  * call this function after deciding the zone to which to
  * add the new pages.
  */
-int __ref __add_pages(int nid, struct zone *zone, unsigned long phys_start_pfn,
+int __ref __add_pages(int nid, struct zone *zone, unsigned long pfn,
 			unsigned long nr_pages)
 {
 	int err = 0, i, start_sec, end_sec;
@@ -535,16 +532,12 @@ int __ref __add_pages(int nid, struct zo
 
 	clear_zone_contiguous(zone);
 
-	/* during initialize mem_map, align hot-added range to section */
-	start_sec = pfn_to_section_nr(phys_start_pfn);
-	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
-
-	altmap = to_vmem_altmap((unsigned long) pfn_to_page(phys_start_pfn));
+	altmap = to_vmem_altmap((unsigned long) pfn_to_page(pfn));
 	if (altmap) {
 		/*
 		 * Validate altmap is within bounds of the total request
 		 */
-		if (altmap->base_pfn != phys_start_pfn
+		if (altmap->base_pfn != pfn
 				|| vmem_altmap_offset(altmap) > nr_pages) {
 			pr_warn_once("memory add fail, invalid altmap\n");
 			err = -EINVAL;
@@ -553,8 +546,16 @@ int __ref __add_pages(int nid, struct zo
 		altmap->alloc = 0;
 	}
 
+	start_sec = pfn_to_section_nr(pfn);
+	end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
 	for (i = start_sec; i <= end_sec; i++) {
-		err = __add_section(nid, zone, section_nr_to_pfn(i));
+		unsigned long pfns;
+
+		pfns = min(nr_pages, PAGES_PER_SECTION
+				- (pfn & ~PAGE_SECTION_MASK));
+		err = __add_section(nid, zone, pfn, pfns);
+		pfn += pfns;
+		nr_pages -= pfns;
 
 		/*
 		 * EEXIST is finally dealt with by ioresource collision
@@ -760,10 +761,10 @@ static void shrink_pgdat_span(struct pgl
 	pgdat->node_spanned_pages = 0;
 }
 
-static void __remove_zone(struct zone *zone, unsigned long start_pfn)
+static void __remove_zone(struct zone *zone, unsigned long start_pfn,
+		unsigned long nr_pages)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
-	int nr_pages = PAGES_PER_SECTION;
 	int zone_type;
 	unsigned long flags;
 
@@ -775,11 +776,10 @@ static void __remove_zone(struct zone *z
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 }
 
-static int __remove_section(struct zone *zone, struct mem_section *ms,
-		unsigned long map_offset)
+static int __remove_section(struct zone *zone, unsigned long pfn,
+		unsigned long nr_pages, unsigned long map_offset)
 {
-	unsigned long start_pfn;
-	int scn_nr;
+	struct mem_section *ms = __nr_to_section(pfn_to_section_nr(pfn));
 	int ret = -EINVAL;
 
 	if (!valid_section(ms))
@@ -789,11 +789,9 @@ static int __remove_section(struct zone
 	if (ret)
 		return ret;
 
-	scn_nr = __section_nr(ms);
-	start_pfn = section_nr_to_pfn(scn_nr);
-	__remove_zone(zone, start_pfn);
+	__remove_zone(zone, pfn, nr_pages);
 
-	sparse_remove_one_section(zone, ms, map_offset);
+	sparse_remove_section(zone, ms, pfn, nr_pages, map_offset);
 	return 0;
 }
 
@@ -808,16 +806,15 @@ static int __remove_section(struct zone
  * sure that pages are marked reserved and zones are adjust properly by
  * calling offline_pages().
  */
-int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
+int __remove_pages(struct zone *zone, unsigned long pfn,
 		 unsigned long nr_pages)
 {
-	unsigned long i;
 	unsigned long map_offset = 0;
-	int sections_to_remove, ret = 0;
+	int i, start_sec, end_sec, ret = 0;
 
 	/* In the ZONE_DEVICE case device driver owns the memory region */
 	if (is_dev_zone(zone)) {
-		struct page *page = pfn_to_page(phys_start_pfn);
+		struct page *page = pfn_to_page(pfn);
 		struct vmem_altmap *altmap;
 
 		altmap = to_vmem_altmap((unsigned long) page);
@@ -826,7 +823,7 @@ int __remove_pages(struct zone *zone, un
 	} else {
 		resource_size_t start, size;
 
-		start = phys_start_pfn << PAGE_SHIFT;
+		start = pfn << PAGE_SHIFT;
 		size = nr_pages * PAGE_SIZE;
 
 		ret = release_mem_region_adjustable(&iomem_resource, start,
@@ -842,16 +839,26 @@ int __remove_pages(struct zone *zone, un
 	clear_zone_contiguous(zone);
 
 	/*
-	 * We can only remove entire sections
+	 * Only ZONE_DEVICE memory is enabled to remove
+	 * section-unaligned ranges. See register_new_memory() which
+	 * assumes section alignment and is skipped for ZONE_DEVICE
+	 * ranges.
 	 */
-	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
-	BUG_ON(nr_pages % PAGES_PER_SECTION);
+	if (!is_dev_zone(zone) && ((pfn | nr_pages) & ~PAGE_SECTION_MASK)) {
+		WARN(1, "section unaligned removal not supported\n");
+		return -EINVAL;
+	}
 
-	sections_to_remove = nr_pages / PAGES_PER_SECTION;
-	for (i = 0; i < sections_to_remove; i++) {
-		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
+	start_sec = pfn_to_section_nr(pfn);
+	end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
+	for (i = start_sec; i <= end_sec; i++) {
+		unsigned long pfns;
 
-		ret = __remove_section(zone, __pfn_to_section(pfn), map_offset);
+		pfns = min(nr_pages, PAGES_PER_SECTION
+				- (pfn & ~PAGE_SECTION_MASK));
+		ret = __remove_section(zone, pfn, pfns, map_offset);
+		pfn += pfns;
+		nr_pages -= pfns;
 		map_offset = 0;
 		if (ret)
 			break;
diff -puN mm/sparse.c~mm-prepare-for-hot-add-remove-of-sub-section-ranges mm/sparse.c
--- a/mm/sparse.c~mm-prepare-for-hot-add-remove-of-sub-section-ranges
+++ a/mm/sparse.c
@@ -753,7 +753,8 @@ static void free_map_bootmem(struct page
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
-int __meminit sparse_add_one_section(struct zone *zone, unsigned long start_pfn)
+int __meminit sparse_add_section(struct zone *zone, unsigned long start_pfn,
+		unsigned long nr_pages)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct pglist_data *pgdat = zone->zone_pgdat;
@@ -855,7 +856,8 @@ static void free_section_usage(struct pa
 		free_map_bootmem(memmap);
 }
 
-void sparse_remove_one_section(struct zone *zone, struct mem_section *ms,
+void sparse_remove_section(struct zone *zone, struct mem_section *ms,
+		unsigned long pfn, unsigned long nr_pages,
 		unsigned long map_offset)
 {
 	unsigned long flags;
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

