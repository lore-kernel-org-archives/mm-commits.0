From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 058/166] mm/sparse.c: introduce new function
 fill_subsection_map()
Date: Mon, 06 Apr 2020 20:07:00 -0700
Message-ID: <20200407030700.MqBZGplM7%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDHB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:01 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, torvalds@linux-foundation.org

From: Baoquan He <bhe@redhat.com>
Subject: mm/sparse.c: introduce new function fill_subsection_map()

Patch series "mm/hotplug: Only use subsection map for VMEMMAP", v4.

Memory sub-section hotplug was added to fix the issue that nvdimm could be
mapped at non-section aligned starting address.  A subsection map is added
into struct mem_section_usage to implement it.

However, config ZONE_DEVICE depends on SPARSEMEM_VMEMMAP.  It means
subsection map only makes sense when SPARSEMEM_VMEMMAP enabled.  For the
classic sparse, subsection map is meaningless and confusing.

About the classic sparse which doesn't support subsection hotplug, Dan
said it's more because the effort and maintenance burden outweighs the
benefit.  Besides, the current 64 bit ARCHes all enable
SPARSEMEM_VMEMMAP_ENABLE by default.


This patch (of 5):

Factor out the code that fills the subsection map from section_activate()
into fill_subsection_map(), this makes section_activate() cleaner and
easier to follow.

Link: http://lkml.kernel.org/r/20200312124414.439-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/mm/sparse.c~mm-sparsec-introduce-new-function-fill_subsection_map
+++ a/mm/sparse.c
@@ -777,24 +777,15 @@ static void section_deactivate(unsigned
 		ms->section_mem_map = (unsigned long)NULL;
 }
 
-static struct page * __meminit section_activate(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap)
+static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
 {
-	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
 	struct mem_section *ms = __pfn_to_section(pfn);
-	struct mem_section_usage *usage = NULL;
+	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
 	unsigned long *subsection_map;
-	struct page *memmap;
 	int rc = 0;
 
 	subsection_mask_set(map, pfn, nr_pages);
 
-	if (!ms->usage) {
-		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
-		if (!usage)
-			return ERR_PTR(-ENOMEM);
-		ms->usage = usage;
-	}
 	subsection_map = &ms->usage->subsection_map[0];
 
 	if (bitmap_empty(map, SUBSECTIONS_PER_SECTION))
@@ -805,6 +796,25 @@ static struct page * __meminit section_a
 		bitmap_or(subsection_map, map, subsection_map,
 				SUBSECTIONS_PER_SECTION);
 
+	return rc;
+}
+
+static struct page * __meminit section_activate(int nid, unsigned long pfn,
+		unsigned long nr_pages, struct vmem_altmap *altmap)
+{
+	struct mem_section *ms = __pfn_to_section(pfn);
+	struct mem_section_usage *usage = NULL;
+	struct page *memmap;
+	int rc = 0;
+
+	if (!ms->usage) {
+		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
+		if (!usage)
+			return ERR_PTR(-ENOMEM);
+		ms->usage = usage;
+	}
+
+	rc = fill_subsection_map(pfn, nr_pages);
 	if (rc) {
 		if (usage)
 			ms->usage = NULL;
_
