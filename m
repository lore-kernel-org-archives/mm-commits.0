From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-track-active-portions-of-a-section-at-boot.patch removed from -mm tree
Date: Wed, 15 Feb 2017 13:51:53 -0800
Message-ID: <58a4cd79.XWsRu2q1Gmam7Jol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49706 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdBOVvy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 16:51:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, arnd@arndb.de, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: track active portions of a section at boot
has been removed from the -mm tree.  Its filename was
     mm-track-active-portions-of-a-section-at-boot.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: track active portions of a section at boot

Prepare for hot{plug,remove} of sub-ranges of a section by tracking a
section active bitmask, each bit representing 2MB (SECTION_SIZE (128M) /
map_active bitmask length (64)).

[akpm@linux-foundation.org: make section_active_init() init, use static inline for stub]
[arnd@arndb.de: fix __init markers]
  Link: http://lkml.kernel.org/r/20170123121509.3143377-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/148486363375.19694.14661926204436340901.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 +++++
 mm/page_alloc.c        |    4 ++
 mm/sparse.c            |   53 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-track-active-portions-of-a-section-at-boot include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-track-active-portions-of-a-section-at-boot
+++ a/include/linux/mmzone.h
@@ -1087,6 +1087,8 @@ struct mem_section_usage {
 	unsigned long pageblock_flags[0];
 };
 
+void __init section_active_init(unsigned long pfn, unsigned long nr_pages);
+
 struct page;
 struct page_ext;
 struct mem_section {
@@ -1228,6 +1230,11 @@ void sparse_init(void);
 #else
 #define sparse_init()	do {} while (0)
 #define sparse_index_init(_sec, _nid)  do {} while (0)
+static inline void section_active_init(unsigned long pfn,
+				       unsigned long nr_pages)
+{
+}
+#define section_active_init(_pfn, _nr_pages) do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
 /*
diff -puN mm/page_alloc.c~mm-track-active-portions-of-a-section-at-boot mm/page_alloc.c
--- a/mm/page_alloc.c~mm-track-active-portions-of-a-section-at-boot
+++ a/mm/page_alloc.c
@@ -6454,10 +6454,12 @@ void __init free_area_init_nodes(unsigne
 
 	/* Print out the early node map */
 	pr_info("Early memory node ranges\n");
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
 			(u64)start_pfn << PAGE_SHIFT,
 			((u64)end_pfn << PAGE_SHIFT) - 1);
+		section_active_init(start_pfn, end_pfn - start_pfn);
+	}
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
diff -puN mm/sparse.c~mm-track-active-portions-of-a-section-at-boot mm/sparse.c
--- a/mm/sparse.c~mm-track-active-portions-of-a-section-at-boot
+++ a/mm/sparse.c
@@ -168,6 +168,59 @@ void __meminit mminit_validate_memmodel_
 	}
 }
 
+static int __init section_active_index(phys_addr_t phys)
+{
+	return (phys & ~(PA_SECTION_MASK)) / SECTION_ACTIVE_SIZE;
+}
+
+static unsigned long section_active_mask(unsigned long pfn,
+					 unsigned long nr_pages)
+{
+	int idx_start, idx_size;
+	phys_addr_t start, size;
+
+	if (!nr_pages)
+		return 0;
+
+	start = PFN_PHYS(pfn);
+	size = PFN_PHYS(min(nr_pages, PAGES_PER_SECTION
+				- (pfn & ~PAGE_SECTION_MASK)));
+	size = ALIGN(size, SECTION_ACTIVE_SIZE);
+
+	idx_start = section_active_index(start);
+	idx_size = section_active_index(size);
+
+	if (idx_size == 0)
+		return -1;
+	return ((1UL << idx_size) - 1) << idx_start;
+}
+
+void __init section_active_init(unsigned long pfn, unsigned long nr_pages)
+{
+	int end_sec = pfn_to_section_nr(pfn + nr_pages - 1);
+	int i, start_sec = pfn_to_section_nr(pfn);
+
+	if (!nr_pages)
+		return;
+
+	for (i = start_sec; i <= end_sec; i++) {
+		struct mem_section *ms;
+		unsigned long mask;
+		unsigned long pfns;
+
+		pfns = min(nr_pages, PAGES_PER_SECTION
+				- (pfn & ~PAGE_SECTION_MASK));
+		mask = section_active_mask(pfn, pfns);
+
+		ms = __nr_to_section(i);
+		pr_debug("%s: sec: %d mask: %#018lx\n", __func__, i, mask);
+		ms->usage->map_active = mask;
+
+		pfn += pfns;
+		nr_pages -= pfns;
+	}
+}
+
 /* Record a memory area against a node. */
 void __init memory_present(int nid, unsigned long start, unsigned long end)
 {
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-register_new_memory-zone-type-detection.patch
mm-convert-kmalloc_section_memmap-to-populate_section_memmap.patch
mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch
mm-support-section-unaligned-zone_device-memory-ranges.patch
mm-enable-section-unaligned-devm_memremap_pages.patch
libnvdimm-pfn-dax-stop-padding-pmem-namespaces-to-section-alignment.patch
mm-fix-get_user_pages-vs-device-dax-pud-mappings.patch

