From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-sparsec-move-subsection_map-related-functions-together-fix.patch added
 to -mm tree
Date: Sat, 21 Mar 2020 14:14:17 -0700
Message-ID: <20200321211417.mKmiOzzk5%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgCUVOT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 17:14:19 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm/sparse.c: move functions into CONFIG_MEMORY_HOTPLUG ifdeffery scope
has been added to the -mm tree.  Its filename is
     mm-sparsec-move-subsection_map-related-functions-together-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsec-move-subsection_map-related-functions-together-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsec-move-subsection_map-related-functions-together-fix.patch

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

mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case.patch
mm-sparsec-use-kvmalloc-kvfree-to-alloc-free-memmap-for-the-classic-sparse.patch
mm-hotplug-only-respect-mem=-parameter-during-boot-stage.patch
mm-sparsec-introduce-new-function-fill_subsection_map.patch
mm-sparsec-introduce-a-new-function-clear_subsection_map.patch
mm-sparsec-only-use-subsection-map-in-vmemmap-case.patch
mm-sparsec-add-note-about-only-vmemmap-supporting-sub-section-hotplug.patch
mm-sparsec-move-subsection_map-related-functions-together.patch
mm-sparsec-move-subsection_map-related-functions-together-fix.patch
