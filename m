From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-sparsec-introduce-a-new-function-clear_subsection_map.patch added to -mm
 tree
Date: Thu, 12 Mar 2020 16:41:16 -0700
Message-ID: <20200312234116.6O7wvUK1v%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgCLXlR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 19:41:17 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com


The patch titled
     Subject: mm/sparse.c: introduce a new function clear_subsection_map()
has been added to the -mm tree.  Its filename is
     mm-sparsec-introduce-a-new-function-clear_subsection_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsec-introduce-a-new-function-clear_subsection_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsec-introduce-a-new-function-clear_subsection_map.patch

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
Subject: mm/sparse.c: introduce a new function clear_subsection_map()

Factor out the code which clear subsection map of one memory region from
section_deactivate() into clear_subsection_map().

And also add helper function is_subsection_map_empty() to check if the
current subsection map is empty or not.

Link: http://lkml.kernel.org/r/20200312124414.439-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/mm/sparse.c~mm-sparsec-introduce-a-new-function-clear_subsection_map
+++ a/mm/sparse.c
@@ -705,15 +705,11 @@ static void free_map_bootmem(struct page
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
-static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
 {
 	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
 	DECLARE_BITMAP(tmp, SUBSECTIONS_PER_SECTION) = { 0 };
 	struct mem_section *ms = __pfn_to_section(pfn);
-	bool section_is_early = early_section(ms);
-	struct page *memmap = NULL;
-	bool empty;
 	unsigned long *subsection_map = ms->usage
 		? &ms->usage->subsection_map[0] : NULL;
 
@@ -724,8 +720,28 @@ static void section_deactivate(unsigned
 	if (WARN(!subsection_map || !bitmap_equal(tmp, map, SUBSECTIONS_PER_SECTION),
 				"section already deactivated (%#lx + %ld)\n",
 				pfn, nr_pages))
-		return;
+		return -EINVAL;
+
+	bitmap_xor(subsection_map, map, subsection_map, SUBSECTIONS_PER_SECTION);
+	return 0;
+}
+
+static bool is_subsection_map_empty(struct mem_section *ms)
+{
+	return bitmap_empty(&ms->usage->subsection_map[0],
+			    SUBSECTIONS_PER_SECTION);
+}
 
+static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap)
+{
+	struct mem_section *ms = __pfn_to_section(pfn);
+	bool section_is_early = early_section(ms);
+	struct page *memmap = NULL;
+	bool empty;
+
+	if (clear_subsection_map(pfn, nr_pages))
+		return;
 	/*
 	 * There are 3 cases to handle across two configurations
 	 * (SPARSEMEM_VMEMMAP={y,n}):
@@ -743,8 +759,7 @@ static void section_deactivate(unsigned
 	 *
 	 * For 2/ and 3/ the SPARSEMEM_VMEMMAP={y,n} cases are unified
 	 */
-	bitmap_xor(subsection_map, map, subsection_map, SUBSECTIONS_PER_SECTION);
-	empty = bitmap_empty(subsection_map, SUBSECTIONS_PER_SECTION);
+	empty = is_subsection_map_empty(ms);
 	if (empty) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
 
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
