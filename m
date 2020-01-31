From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-skip-non-present-sections-on-zone-initialization.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:18:27 -0800
Message-ID: <20200131231827.BiP6OE8Ch%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXS2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, kirill.shutemov@linux.intel.com, kirill@shutemov.name, mgorman@suse.de, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pasha.tatashin@oracle.com, vbabka@suse.cz, zhi.jin@intel.com


The patch titled
     Subject: mm/page_alloc: skip non present sections on zone initialization
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-skip-non-present-sections-on-zone-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm/page_alloc: skip non present sections on zone initialization

memmap_init_zone() can be called on the ranges with holes during the boot.
It will skip any non-valid PFNs one-by-one.  It works fine as long as
holes are not too big.

But huge holes in the memory map causes a problem.  It takes over 20
seconds to walk 32TiB hole.  x86-64 with 5-level paging allows for much
larger holes in the memory map which would practically hang the system.

Deferred struct page init doesn't help here.  It only works on the present
ranges.

Skipping non-present sections would fix the issue.

Link: http://lkml.kernel.org/r/20191230093828.24613-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Jin, Zhi" <zhi.jin@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-skip-non-present-sections-on-zone-initialization
+++ a/mm/page_alloc.c
@@ -5848,6 +5848,30 @@ overlap_memmap_init(unsigned long zone,
 	return false;
 }
 
+#ifdef CONFIG_SPARSEMEM
+/* Skip PFNs that belong to non-present sections */
+static inline __meminit unsigned long next_pfn(unsigned long pfn)
+{
+	unsigned long section_nr;
+
+	section_nr = pfn_to_section_nr(++pfn);
+	if (present_section_nr(section_nr))
+		return pfn;
+
+	while (++section_nr <= __highest_present_section_nr) {
+		if (present_section_nr(section_nr))
+			return section_nr_to_pfn(section_nr);
+	}
+
+	return -1;
+}
+#else
+static inline __meminit unsigned long next_pfn(unsigned long pfn)
+{
+	return pfn++;
+}
+#endif
+
 /*
  * Initially all pages are reserved - free ones are freed
  * up by memblock_free_all() once the early boot process is
@@ -5887,8 +5911,10 @@ void __meminit memmap_init_zone(unsigned
 		 * function.  They do not exist on hotplugged memory.
 		 */
 		if (context == MEMMAP_EARLY) {
-			if (!early_pfn_valid(pfn))
+			if (!early_pfn_valid(pfn)) {
+				pfn = next_pfn(pfn) - 1;
 				continue;
+			}
 			if (!early_pfn_in_nid(pfn, nid))
 				continue;
 			if (overlap_memmap_init(zone, &pfn))
_

Patches currently in -mm which might be from kirill@shutemov.name are
