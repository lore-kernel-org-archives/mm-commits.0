From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 059/166] mm/sparse.c: introduce a new function
 clear_subsection_map()
Date: Mon, 06 Apr 2020 20:07:03 -0700
Message-ID: <20200407030703.eQJgEk0Bs%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDHG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:06 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, torvalds@linux-foundation.org

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
