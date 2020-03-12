From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-sparsec-introduce-new-function-fill_subsection_map.patch added to -mm
 tree
Date: Thu, 12 Mar 2020 16:41:13 -0700
Message-ID: <20200312234113.7segADIJB%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgCLXlP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 19:41:15 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com


The patch titled
     Subject: mm/sparse.c: introduce new function fill_subsection_map()
has been added to the -mm tree.  Its filename is
     mm-sparsec-introduce-new-function-fill_subsection_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsec-introduce-new-function-fill_subsection_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsec-introduce-new-function-fill_subsection_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -771,24 +771,15 @@ static void section_deactivate(unsigned
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
@@ -799,6 +790,25 @@ static struct page * __meminit section_a
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

Patches currently in -mm which might be from bhe@redhat.com are

mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case.patch
mm-sparsec-use-kvmalloc_node-kvfree-to-alloc-free-memmap-for-the-classic-sparse.patch
mm-hotplug-only-respect-mem=-parameter-during-boot-stage.patch
mm-sparsec-introduce-new-function-fill_subsection_map.patch
mm-sparsec-introduce-a-new-function-clear_subsection_map.patch
mm-sparsec-only-use-subsection-map-in-vmemmap-case.patch
mm-sparsec-add-note-about-only-vmemmap-supporting-sub-section-hotplug.patch
mm-sparsec-move-subsection_map-related-functions-together.patch
