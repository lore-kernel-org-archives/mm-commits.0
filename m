From: akpm@linux-foundation.org
Subject: + mm-track-active-portions-of-a-section-at-boot.patch added to
 -mm tree
Date: Thu, 19 Jan 2017 16:06:00 -0800
Message-ID: <58815468.en2B6k4udCBC8mZC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44872 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753390AbdATAHY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 19:07:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: track active portions of a section at boot
has been added to the -mm tree.  Its filename is
     mm-track-active-portions-of-a-section-at-boot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-track-active-portions-of-a-section-at-boot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-track-active-portions-of-a-section-at-boot.patch

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
Subject: mm: track active portions of a section at boot

Prepare for hot{plug,remove} of sub-ranges of a section by tracking a
section active bitmask, each bit representing 2MB (SECTION_SIZE (128M) /
map_active bitmask length (64)).

Link: http://lkml.kernel.org/r/148486363375.19694.14661926204436340901.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 ++
 mm/page_alloc.c        |    4 ++
 mm/sparse.c            |   53 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-track-active-portions-of-a-section-at-boot include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-track-active-portions-of-a-section-at-boot
+++ a/include/linux/mmzone.h
@@ -1083,6 +1083,8 @@ struct mem_section_usage {
 	unsigned long pageblock_flags[0];
 };
 
+void section_active_init(unsigned long pfn, unsigned long nr_pages);
+
 struct page;
 struct page_ext;
 struct mem_section {
@@ -1224,6 +1226,7 @@ void sparse_init(void);
 #else
 #define sparse_init()	do {} while (0)
 #define sparse_index_init(_sec, _nid)  do {} while (0)
+#define section_active_init(_pfn, _nr_pages) do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
 /*
diff -puN mm/page_alloc.c~mm-track-active-portions-of-a-section-at-boot mm/page_alloc.c
--- a/mm/page_alloc.c~mm-track-active-portions-of-a-section-at-boot
+++ a/mm/page_alloc.c
@@ -6428,10 +6428,12 @@ void __init free_area_init_nodes(unsigne
 
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
 
+static int section_active_index(phys_addr_t phys)
+{
+	return (phys & ~(PA_SECTION_MASK)) / SECTION_ACTIVE_SIZE;
+}
+
+static unsigned long section_active_mask(unsigned long pfn,
+		unsigned long nr_pages)
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
+void section_active_init(unsigned long pfn, unsigned long nr_pages)
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

