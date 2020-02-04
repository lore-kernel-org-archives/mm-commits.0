From: akpm@linux-foundation.org
Subject: [merged] mm-factor-out-next_present_section_nr.patch
 removed from -mm tree
Date: Tue, 04 Feb 2020 10:40:06 -0800
Message-ID: <20200204184006.ZHD6sG19x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBDSkH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, kirill.shutemov@linux.intel.com, kirill@shutemov.name, mgorman@suse.de, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pasha.tatashin@oracle.com, vbabka@suse.cz, zhi.jin@intel.com


The patch titled
     Subject: mm: factor out next_present_section_nr()
has been removed from the -mm tree.  Its filename was
     mm-factor-out-next_present_section_nr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: factor out next_present_section_nr()

Let's move it to the header and use the shorter variant from
mm/page_alloc.c (the original one will also check
"__highest_present_section_nr + 1", which is not necessary).  While at it,
make the section_nr in next_pfn() const.

In next_pfn(), we now return section_nr_to_pfn(-1) instead of -1 once we
exceed __highest_present_section_nr, which doesn't make a difference i= n
the caller as it is big enough (>= all sane end_pfn).

Link: http://lkml.kernel.org/r/20200113144035.10848-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Jin, Zhi" <zhi.jin@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 ++++++++++
 mm/page_alloc.c        |   11 ++---------
 mm/sparse.c            |   10 ----------
 3 files changed, 12 insertions(+), 19 deletions(-)

--- a/include/linux/mmzone.h~mm-factor-out-next_present_section_nr
+++ a/include/linux/mmzone.h
@@ -1379,6 +1379,16 @@ static inline int pfn_present(unsigned l
 	return present_section(__nr_to_section(pfn_to_section_nr(pfn)));
 }
 
+static inline unsigned long next_present_section_nr(unsigned long section_nr)
+{
+	while (++section_nr <= __highest_present_section_nr) {
+		if (present_section_nr(section_nr))
+			return section_nr;
+	}
+
+	return -1;
+}
+
 /*
  * These are _only_ used during initialisation, therefore they
  * can use __initdata ...  They could have names to indicate
--- a/mm/page_alloc.c~mm-factor-out-next_present_section_nr
+++ a/mm/page_alloc.c
@@ -5852,18 +5852,11 @@ overlap_memmap_init(unsigned long zone,
 /* Skip PFNs that belong to non-present sections */
 static inline __meminit unsigned long next_pfn(unsigned long pfn)
 {
-	unsigned long section_nr;
+	const unsigned long section_nr = pfn_to_section_nr(++pfn);
 
-	section_nr = pfn_to_section_nr(++pfn);
 	if (present_section_nr(section_nr))
 		return pfn;
-
-	while (++section_nr <= __highest_present_section_nr) {
-		if (present_section_nr(section_nr))
-			return section_nr_to_pfn(section_nr);
-	}
-
-	return -1;
+	return section_nr_to_pfn(next_present_section_nr(section_nr));
 }
 #else
 static inline __meminit unsigned long next_pfn(unsigned long pfn)
--- a/mm/sparse.c~mm-factor-out-next_present_section_nr
+++ a/mm/sparse.c
@@ -198,16 +198,6 @@ static void section_mark_present(struct
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 
-static inline unsigned long next_present_section_nr(unsigned long section_nr)
-{
-	do {
-		section_nr++;
-		if (present_section_nr(section_nr))
-			return section_nr;
-	} while ((section_nr <= __highest_present_section_nr));
