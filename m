From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-unused-free_bootmem_with_active_regions.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:17:58 -0700
Message-ID: <20200604171758.Me9xna86p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbgFDRR7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove unused free_bootmem_with_active_regions
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-free_bootmem_with_active_regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2415,8 +2415,6 @@ static inline unsigned long get_num_phys
  * 	memblock_add_node(base, size, nid)
  * free_area_init(max_zone_pfns);
  *
- * free_bootmem_with_active_regions() calls free_bootmem_node() for each
- * registered physical page range.  Similarly
  * sparse_memory_present_with_active_regions() calls memory_present() for
  * each range when SPARSEMEM is enabled.
  */
@@ -2429,8 +2427,6 @@ extern unsigned long absent_pages_in_ran
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
