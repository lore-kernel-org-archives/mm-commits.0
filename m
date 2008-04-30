From: akpm@linux-foundation.org
Subject: + mm-fix-free_all_bootmem_core-alignment-check.patch added to -mm tree
Date: Wed, 30 Apr 2008 12:30:05 -0700
Message-ID: <200804301930.m3UJU6LM031161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135AbYD3Tak (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 15:30:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, apw@shadowen.org, clameter@sgi.com, mel@csn.ul.ie, mingo@elte.hu, yhlu.kernel@gmail.com


The patch titled
     mm: fix free_all_bootmem_core alignment check
has been added to the -mm tree.  Its filename is
     mm-fix-free_all_bootmem_core-alignment-check.patch

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
Subject: mm: fix free_all_bootmem_core alignment check
From: Johannes Weiner <hannes@saeurebad.de>

The check for node_boot_start is bogus because we start freeing at the
corresponding pfn.  So check if the pfn is properly aligned instead in a more
readable way and adjust the documentation.

Also remove an unneeded accounting variable.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
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
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch

