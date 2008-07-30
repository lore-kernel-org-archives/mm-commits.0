From: akpm@linux-foundation.org
Subject: - mm-remove-find_max_pfn_with_active_regions.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:02 -0700
Message-ID: <200807301914.m6UJE2q6010880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbYG3TOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, mel@csn.ul.ie, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     mm: remove find_max_pfn_with_active_regions
has been removed from the -mm tree.  Its filename was
     mm-remove-find_max_pfn_with_active_regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove find_max_pfn_with_active_regions
From: Yinghai Lu <yhlu.kernel@gmail.com>

It has no user now

Also print out info about adding/removing active regions.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/page_alloc.c    |   17 -----------------
 2 files changed, 18 deletions(-)

diff -puN include/linux/mm.h~mm-remove-find_max_pfn_with_active_regions include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-find_max_pfn_with_active_regions
+++ a/include/linux/mm.h
@@ -1041,7 +1041,6 @@ extern unsigned long absent_pages_in_ran
 extern void get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn);
 extern unsigned long find_min_pfn_with_active_regions(void);
-extern unsigned long find_max_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
diff -puN mm/page_alloc.c~mm-remove-find_max_pfn_with_active_regions mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-find_max_pfn_with_active_regions
+++ a/mm/page_alloc.c
@@ -3753,23 +3753,6 @@ unsigned long __init find_min_pfn_with_a
 	return find_min_pfn_for_node(MAX_NUMNODES);
 }
 
-/**
- * find_max_pfn_with_active_regions - Find the maximum PFN registered
- *
- * It returns the maximum PFN based on information provided via
- * add_active_range().
- */
-unsigned long __init find_max_pfn_with_active_regions(void)
-{
-	int i;
-	unsigned long max_pfn = 0;
-
-	for (i = 0; i < nr_nodemap_entries; i++)
-		max_pfn = max(max_pfn, early_node_map[i].end_pfn);
-
-	return max_pfn;
-}
