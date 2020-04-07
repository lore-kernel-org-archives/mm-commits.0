From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 062/166] mm/sparse.c: move subsection_map related
 functions together
Date: Mon, 06 Apr 2020 20:07:13 -0700
Message-ID: <20200407030713.hhAkS_xgs%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDHP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:15 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com, sfr@canb.auug.org.au, torvalds@linux-foundation.org

From: Baoquan He <bhe@redhat.com>
Subject: mm/sparse.c: move subsection_map related functions together

No functional change.

[bhe@redhat.com: move functions into CONFIG_MEMORY_HOTPLUG ifdeffery scope]
  Link: http://lkml.kernel.org/r/20200316045804.GC3486@MiWiFi-R3L-srv
Link: http://lkml.kernel.org/r/20200312124414.439-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |  110 ++++++++++++++++++++++++--------------------------
 1 file changed, 53 insertions(+), 57 deletions(-)

--- a/mm/sparse.c~mm-sparsec-move-subsection_map-related-functions-together
+++ a/mm/sparse.c
@@ -666,6 +666,55 @@ static void free_map_bootmem(struct page
 
 	vmemmap_free(start, end, NULL);
 }
+
+static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
+{
+	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
+	DECLARE_BITMAP(tmp, SUBSECTIONS_PER_SECTION) = { 0 };
+	struct mem_section *ms = __pfn_to_section(pfn);
+	unsigned long *subsection_map = ms->usage
+		? &ms->usage->subsection_map[0] : NULL;
+
+	subsection_mask_set(map, pfn, nr_pages);
+	if (subsection_map)
+		bitmap_and(tmp, map, subsection_map, SUBSECTIONS_PER_SECTION);
+
+	if (WARN(!subsection_map || !bitmap_equal(tmp, map, SUBSECTIONS_PER_SECTION),
+				"section already deactivated (%#lx + %ld)\n",
+				pfn, nr_pages))
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
+
+static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
+{
+	struct mem_section *ms = __pfn_to_section(pfn);
+	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
+	unsigned long *subsection_map;
+	int rc = 0;
+
+	subsection_mask_set(map, pfn, nr_pages);
+
+	subsection_map = &ms->usage->subsection_map[0];
+
+	if (bitmap_empty(map, SUBSECTIONS_PER_SECTION))
+		rc = -EINVAL;
+	else if (bitmap_intersects(map, subsection_map, SUBSECTIONS_PER_SECTION))
+		rc = -EEXIST;
+	else
+		bitmap_or(subsection_map, map, subsection_map,
+				SUBSECTIONS_PER_SECTION);
+
+	return rc;
+}
 #else
 struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
@@ -709,46 +758,22 @@ static void free_map_bootmem(struct page
 			put_page_bootmem(page);
 	}
 }
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
 static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
 {
-	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
-	DECLARE_BITMAP(tmp, SUBSECTIONS_PER_SECTION) = { 0 };
-	struct mem_section *ms = __pfn_to_section(pfn);
-	unsigned long *subsection_map = ms->usage
-		? &ms->usage->subsection_map[0] : NULL;
-
-	subsection_mask_set(map, pfn, nr_pages);
-	if (subsection_map)
-		bitmap_and(tmp, map, subsection_map, SUBSECTIONS_PER_SECTION);
-
-	if (WARN(!subsection_map || !bitmap_equal(tmp, map, SUBSECTIONS_PER_SECTION),
-				"section already deactivated (%#lx + %ld)\n",
-				pfn, nr_pages))
-		return -EINVAL;
-
-	bitmap_xor(subsection_map, map, subsection_map, SUBSECTIONS_PER_SECTION);
 	return 0;
 }
 
 static bool is_subsection_map_empty(struct mem_section *ms)
 {
-	return bitmap_empty(&ms->usage->subsection_map[0],
-			    SUBSECTIONS_PER_SECTION);
-}
-#else
-static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	return 0;
+	return true;
 }
 
-static bool is_subsection_map_empty(struct mem_section *ms)
+static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
 {
-	return true;
+	return 0;
 }
-#endif
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 /*
  * To deactivate a memory region, there are 3 cases to handle across
@@ -810,35 +835,6 @@ static void section_deactivate(unsigned
 		ms->section_mem_map = (unsigned long)NULL;
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	struct mem_section *ms = __pfn_to_section(pfn);
-	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
-	unsigned long *subsection_map;
-	int rc = 0;
-
-	subsection_mask_set(map, pfn, nr_pages);
-
-	subsection_map = &ms->usage->subsection_map[0];
-
-	if (bitmap_empty(map, SUBSECTIONS_PER_SECTION))
-		rc = -EINVAL;
-	else if (bitmap_intersects(map, subsection_map, SUBSECTIONS_PER_SECTION))
-		rc = -EEXIST;
-	else
-		bitmap_or(subsection_map, map, subsection_map,
-				SUBSECTIONS_PER_SECTION);
-
-	return rc;
-}
-#else
-static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	return 0;
-}
-#endif
