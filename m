From: akpm@linux-foundation.org
Subject: + mm-remove-unused-free_bootmem_with_active_regions.patch
 added to -mm tree
Date: Wed, 15 Apr 2020 20:39:42 -0700
Message-ID: <20200416033942.qohuseq9H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391128AbgDPDjn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 23:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove unused free_bootmem_with_active_regions
has been added to the -mm tree.  Its filename is
     mm-remove-unused-free_bootmem_with_active_regions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unused-free_bootmem_with_active_regions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unused-free_bootmem_with_active_regions.patch

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
Subject: mm/page_alloc.c: remove unused free_bootmem_with_active_regions

Since commit 397dc00e249ec64e10 ("mips: sgi-ip27: switch from DISCONTIGMEM
to SPARSEMEM"), the last caller of free_bootmem_with_active_regions() was
gone.  Now no user calls it any more.

Let's remove it.

Link: http://lkml.kernel.org/r/20200402143455.5145-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ----
 mm/page_alloc.c    |   25 -------------------------
 2 files changed, 29 deletions(-)

--- a/include/linux/mm.h~mm-remove-unused-free_bootmem_with_active_regions
+++ a/include/linux/mm.h
@@ -2352,8 +2352,6 @@ static inline unsigned long get_num_phys
  * 	memblock_add_node(base, size, nid)
  * free_area_init(max_zone_pfns);
  *
- * free_bootmem_with_active_regions() calls free_bootmem_node() for each
- * registered physical page range.  Similarly
  * sparse_memory_present_with_active_regions() calls memory_present() for
  * each range when SPARSEMEM is enabled.
  */
@@ -2366,8 +2364,6 @@ extern unsigned long absent_pages_in_ran
 extern void get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn);
 extern unsigned long find_min_pfn_with_active_regions(void);
-extern void free_bootmem_with_active_regions(int nid,
-						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
--- a/mm/page_alloc.c~mm-remove-unused-free_bootmem_with_active_regions
+++ a/mm/page_alloc.c
@@ -6296,31 +6296,6 @@ void __meminit init_currently_empty_zone
 }
 
 /**
- * free_bootmem_with_active_regions - Call memblock_free_early_nid for each active range
- * @nid: The node to free memory on. If MAX_NUMNODES, all nodes are freed.
- * @max_low_pfn: The highest PFN that will be passed to memblock_free_early_nid
- *
- * If an architecture guarantees that all ranges registered contain no holes
- * and may be freed, this this function may be used instead of calling
- * memblock_free_early_nid() manually.
- */
-void __init free_bootmem_with_active_regions(int nid, unsigned long max_low_pfn)
-{
-	unsigned long start_pfn, end_pfn;
-	int i, this_nid;
-
-	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, &this_nid) {
-		start_pfn = min(start_pfn, max_low_pfn);
-		end_pfn = min(end_pfn, max_low_pfn);
-
-		if (start_pfn < end_pfn)
-			memblock_free_early_nid(PFN_PHYS(start_pfn),
-					(end_pfn - start_pfn) << PAGE_SHIFT,
-					this_nid);
-	}
-}
