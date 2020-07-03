From: akpm@linux-foundation.org
Subject: +
 mm-sparse-only-sub-section-aligned-range-would-be-populated.patch added to
 -mm tree
Date: Thu, 02 Jul 2020 21:08:32 -0700
Message-ID: <20200703040832.WnwTovA3r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCEIe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com


The patch titled
     Subject: mm/sparse: only sub-section aligned range would be populated
has been added to the -mm tree.  Its filename is
     mm-sparse-only-sub-section-aligned-range-would-be-populated.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-only-sub-section-aligned-range-would-be-populated.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-only-sub-section-aligned-range-would-be-populated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/sparse: only sub-section aligned range would be populated

There are two code path which invoke __populate_section_memmap()

  * sparse_init_nid()
  * sparse_add_section()

For both case, we are sure the memory range is sub-section aligned.

  * we pass PAGES_PER_SECTION to sparse_init_nid()
  * we check range by check_pfn_span() before calling
    sparse_add_section()

Also, the counterpart of __populate_section_memmap(), we don't do such
calculation and check since the range is checked by check_pfn_span() in
__remove_pages().

Clear the calculation and check to keep it simple and comply with its
counterpart.

Link: http://lkml.kernel.org/r/20200703031828.14645-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-only-sub-section-aligned-range-would-be-populated
+++ a/mm/sparse-vmemmap.c
@@ -247,20 +247,12 @@ int __meminit vmemmap_populate_basepages
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
 {
-	unsigned long start;
-	unsigned long end;
+	unsigned long start = (unsigned long) pfn_to_page(pfn);
+	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	/*
-	 * The minimum granularity of memmap extensions is
-	 * PAGES_PER_SUBSECTION as allocations are tracked in the
-	 * 'subsection_map' bitmap of the section.
-	 */
-	end = ALIGN(pfn + nr_pages, PAGES_PER_SUBSECTION);
-	pfn &= PAGE_SUBSECTION_MASK;
-	nr_pages = end - pfn;
