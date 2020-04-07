From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 060/166] mm/sparse.c: only use subsection map in
 VMEMMAP case
Date: Mon, 06 Apr 2020 20:07:06 -0700
Message-ID: <20200407030706.W1btM3O1y%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDHI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:08 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, torvalds@linux-foundation.org

From: Baoquan He <bhe@redhat.com>
Subject: mm/sparse.c: only use subsection map in VMEMMAP case

Currently, to support subsection aligned memory region adding for pmem,
subsection map is added to track which subsection is present.

However, config ZONE_DEVICE depends on SPARSEMEM_VMEMMAP.  It means
subsection map only makes sense when SPARSEMEM_VMEMMAP enabled.  For the
classic sparse, it's meaningless.  Even worse, it may confuse people when
checking code related to the classic sparse.

About the classic sparse which doesn't support subsection hotplug, Dan
said it's more because the effort and maintenance burden outweighs the
benefit.  Besides, the current 64 bit ARCHes all enable
SPARSEMEM_VMEMMAP_ENABLE by default.

Combining the above reasons, no need to provide subsection map and the
relevant handling for the classic sparse.  Let's remove them.

Link: http://lkml.kernel.org/r/20200312124414.439-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/sparse.c            |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

--- a/include/linux/mmzone.h~mm-sparsec-only-use-subsection-map-in-vmemmap-case
+++ a/include/linux/mmzone.h
@@ -1143,7 +1143,9 @@ static inline unsigned long section_nr_t
 #define SUBSECTION_ALIGN_DOWN(pfn) ((pfn) & PAGE_SUBSECTION_MASK)
 
 struct mem_section_usage {
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 	DECLARE_BITMAP(subsection_map, SUBSECTIONS_PER_SECTION);
+#endif
 	/* See declaration of similar field in struct zone */
 	unsigned long pageblock_flags[0];
 };
--- a/mm/sparse.c~mm-sparsec-only-use-subsection-map-in-vmemmap-case
+++ a/mm/sparse.c
@@ -209,6 +209,7 @@ static inline unsigned long first_presen
 	return next_present_section_nr(-1);
 }
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 static void subsection_mask_set(unsigned long *map, unsigned long pfn,
 		unsigned long nr_pages)
 {
@@ -243,6 +244,11 @@ void __init subsection_map_init(unsigned
 		nr_pages -= pfns;
 	}
 }
+#else
+void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
+{
+}
+#endif
 
 /* Record a memory area against a node. */
 void __init memory_present(int nid, unsigned long start, unsigned long end)
@@ -705,6 +711,7 @@ static void free_map_bootmem(struct page
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
 {
 	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
@@ -731,6 +738,17 @@ static bool is_subsection_map_empty(stru
 	return bitmap_empty(&ms->usage->subsection_map[0],
 			    SUBSECTIONS_PER_SECTION);
 }
+#else
+static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
+{
+	return 0;
+}
+
+static bool is_subsection_map_empty(struct mem_section *ms)
+{
+	return true;
+}
+#endif
 
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap)
@@ -792,6 +810,7 @@ static void section_deactivate(unsigned
 		ms->section_mem_map = (unsigned long)NULL;
 }
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
@@ -813,6 +832,12 @@ static int fill_subsection_map(unsigned
 
 	return rc;
 }
+#else
+static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
+{
+	return 0;
+}
+#endif
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap)
_
