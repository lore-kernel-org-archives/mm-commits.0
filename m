From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-sparsec-move-subsection_map-related-functions-together-fix.patch removed
 from -mm tree
Date: Mon, 06 Apr 2020 18:44:22 -0700
Message-ID: <20200407014422.n0KzouK37%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGBoX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 21:44:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm/sparse.c: move functions into CONFIG_MEMORY_HOTPLUG ifdeffery scope
has been removed from the -mm tree.  Its filename was
     mm-sparsec-move-subsection_map-related-functions-together-fix.patch

This patch was dropped because it was folded into mm-sparsec-move-subsection_map-related-functions-together.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/sparse.c: move functions into CONFIG_MEMORY_HOTPLUG ifdeffery scope

Stephen reported warnings are seen with allnoconfig on x86_64:

mm/sparse.c:311:12: warning: 'fill_subsection_map' defined but not used [-Wunused-function]
  311 | static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
      |            ^~~~~~~~~~~~~~~~~~~
mm/sparse.c:306:13: warning: 'is_subsection_map_empty' defined but not used [-Wunused-function]
  306 | static bool is_subsection_map_empty(struct mem_section *ms)
      |             ^~~~~~~~~~~~~~~~~~~~~~~
mm/sparse.c:301:12: warning: 'clear_subsection_map' defined but not used [-Wunused-function]
  301 | static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
      |            ^~~~~~~~~~~~~~~~~~~~

This is because allnoconfig on x86_64 sets  CONFIG_SPARSEMEM=y and
CONFIG_MEMORY_HOTPLUG=n. Functions clear_subsection_map(),
is_subsection_map_empty() and fill_subsection_map() are all defined
outside CONFIG_MEMORY_HOTPLUG ifdeffery scope. However, their callers,
section_activate() and section_deactivate() are inside CONFIG_MEMORY_HOTPLUG
ifdeffery scope.

So let's move them into the CONFIG_MEMORY_HOTPLUG iddeffery scope which
includes their callers.

Link: http://lkml.kernel.org/r/20200316045804.GC3486@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>	[compile tested]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |  128 +++++++++++++++++++++++++-------------------------
 1 file changed, 64 insertions(+), 64 deletions(-)

--- a/mm/sparse.c~mm-sparsec-move-subsection_map-related-functions-together-fix
+++ a/mm/sparse.c
@@ -244,74 +244,10 @@ void __init subsection_map_init(unsigned
 		nr_pages -= pfns;
 	}
 }
-
-static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
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
-	return 0;
-}
-
-static bool is_subsection_map_empty(struct mem_section *ms)
-{
-	return bitmap_empty(&ms->usage->subsection_map[0],
-			    SUBSECTIONS_PER_SECTION);
-}
-
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
 #else
 void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
 {
 }
-
-static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	return 0;
-}
-
-static bool is_subsection_map_empty(struct mem_section *ms)
-{
-	return true;
-}
-
-static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	return 0;
-}
 #endif
 
 /* Record a memory area against a node. */
@@ -730,6 +666,55 @@ static void free_map_bootmem(struct page
 
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
@@ -773,6 +758,21 @@ static void free_map_bootmem(struct page
 			put_page_bootmem(page);
 	}
 }
+
+static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
+{
+	return 0;
+}
+
+static bool is_subsection_map_empty(struct mem_section *ms)
+{
+	return true;
+}
+
+static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
+{
+	return 0;
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 /*
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-hotplug-only-respect-mem=-parameter-during-boot-stage.patch
mm-sparsec-introduce-new-function-fill_subsection_map.patch
mm-sparsec-introduce-a-new-function-clear_subsection_map.patch
mm-sparsec-only-use-subsection-map-in-vmemmap-case.patch
mm-sparsec-add-note-about-only-vmemmap-supporting-sub-section-hotplug.patch
mm-sparsec-move-subsection_map-related-functions-together.patch
