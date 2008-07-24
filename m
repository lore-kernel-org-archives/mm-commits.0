From: akpm@linux-foundation.org
Subject: - mm-fix-free_all_bootmem_core-alignment-check.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:02 -0700
Message-ID: <200807242321.m6ONL2xB010380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179AbYGXXVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, apw@shadowen.org, cl@linux-foundation.org, mel@csn.ul.ie, mingo@elte.hu, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix free_all_bootmem_core alignment check
has been removed from the -mm tree.  Its filename was
     mm-fix-free_all_bootmem_core-alignment-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix free_all_bootmem_core alignment check
From: Johannes Weiner <hannes@saeurebad.de>

The check for node_boot_start is bogus because we start freeing at the
corresponding pfn.  So check if the pfn is properly aligned instead in a more
readable way and adjust the documentation.

Also remove an unneeded accounting variable.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN mm/bootmem.c~mm-fix-free_all_bootmem_core-alignment-check mm/bootmem.c
--- a/mm/bootmem.c~mm-fix-free_all_bootmem_core-alignment-check
+++ a/mm/bootmem.c
@@ -377,7 +377,7 @@ static unsigned long __init free_all_boo
 	struct page *page;
 	unsigned long pfn;
 	bootmem_data_t *bdata = pgdat->bdata;
-	unsigned long i, count, total = 0;
+	unsigned long i, count;
 	unsigned long idx;
 	unsigned long *map; 
 	int gofast = 0;
@@ -389,10 +389,13 @@ static unsigned long __init free_all_boo
 	pfn = PFN_DOWN(bdata->node_boot_start);
 	idx = bdata->node_low_pfn - pfn;
 	map = bdata->node_bootmem_map;
-	/* Check physaddr is O(LOG2(BITS_PER_LONG)) page aligned */
-	if (bdata->node_boot_start == 0 ||
-	    ffs(bdata->node_boot_start) - PAGE_SHIFT > ffs(BITS_PER_LONG))
+	/*
+	 * Check if we are aligned to BITS_PER_LONG pages.  If so, we might
+	 * be able to free page orders of that size at once.
+	 */
+	if (!(pfn & (BITS_PER_LONG-1)))
 		gofast = 1;
+
 	for (i = 0; i < idx; ) {
 		unsigned long v = ~map[i / BITS_PER_LONG];
 
@@ -420,23 +423,19 @@ static unsigned long __init free_all_boo
 		}
 		pfn += BITS_PER_LONG;
 	}
-	total += count;
 
 	/*
 	 * Now free the allocator bitmap itself, it's not
 	 * needed anymore:
 	 */
 	page = virt_to_page(bdata->node_bootmem_map);
-	count = 0;
 	idx = (get_mapsize(bdata) + PAGE_SIZE-1) >> PAGE_SHIFT;
-	for (i = 0; i < idx; i++, page++) {
+	for (i = 0; i < idx; i++, page++)
 		__free_pages_bootmem(page, 0);
-		count++;
-	}
-	total += count;
+	count += i;
 	bdata->node_bootmem_map = NULL;
 
-	return total;
+	return count;
 }
 
 unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
linux-next.patch
git-xtensa.patch
documentation-update-codingstyle-tips-for-emacs-users-v2.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
alpha-use-generic-show_mem.patch
avr32-use-generic-show_mem.patch
blackfin-use-generic-show_mem.patch
xtensa-use-generic-show_mem.patch
x86-use-generic-show_mem.patch
um-use-generic-show_mem.patch
sparc64-use-generic-show_mem.patch
sh-use-generic-show_mem.patch
s390-use-generic-show_mem.patch
powerpc-use-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
h8300-use-generic-show_mem.patch
mips-use-generic-show_mem.patch
m68knommu-use-generic-show_mem.patch
m68k-use-generic-show_mem.patch
m32r-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
cris-use-generic-show_mem.patch

