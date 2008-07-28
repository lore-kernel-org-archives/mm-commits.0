From: akpm@linux-foundation.org
Subject: + mm-remove-find_max_pfn_with_active_regions.patch added to -mm tree
Date: Sun, 27 Jul 2008 20:13:17 -0700
Message-ID: <200807280313.m6S3DHDk017400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbYG1DNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 23:13:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, mel@csn.ul.ie


The patch titled
     mm: remove find_max_pfn_with_active_regions
has been added to the -mm tree.  Its filename is
     mm-remove-find_max_pfn_with_active_regions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove find_max_pfn_with_active_regions
From: Yinghai Lu <yhlu.kernel@gmail.com>

It has no user now

Also print out info about adding/removing active regions.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/page_alloc.c    |   22 ++--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

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
@@ -3572,8 +3572,7 @@ void __init add_active_range(unsigned in
 {
 	int i;
 
-	mminit_dprintk(MMINIT_TRACE, "memory_register",
-			"Entering add_active_range(%d, %#lx, %#lx) "
+	printk(KERN_INFO "Adding active range (%d, %#lx, %#lx) "
 			"%d entries of %d used\n",
 			nid, start_pfn, end_pfn,
 			nr_nodemap_entries, MAX_ACTIVE_REGIONS);
@@ -3635,7 +3634,7 @@ void __init remove_active_range(unsigned
 	int i, j;
 	int removed = 0;
 
-	printk(KERN_DEBUG "remove_active_range (%d, %lu, %lu)\n",
+	printk(KERN_INFO "Removing active range (%d, %#lx, %#lx)\n",
 			  nid, start_pfn, end_pfn);
 
 	/* Find the old active region end and shrink */
@@ -3753,23 +3752,6 @@ unsigned long __init find_min_pfn_with_a
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
