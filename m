From: akpm@linux-foundation.org
Subject: + bootmem-clean-up-free_all_bootmem_core.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:25 -0700
Message-ID: <200806082335.m58NZPfE025610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbYFHXgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, andi@firstfloor.org, mingo@elte.hu, yhlu.kernel@gmail.com


The patch titled
     bootmem: clean up free_all_bootmem_core
has been added to the -mm tree.  Its filename is
     bootmem-clean-up-free_all_bootmem_core.patch

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
Subject: bootmem: clean up free_all_bootmem_core
From: Johannes Weiner <hannes@saeurebad.de>

Rewrite the code in a more concise way using less variables.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   83 ++++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 45 deletions(-)

diff -puN mm/bootmem.c~bootmem-clean-up-free_all_bootmem_core mm/bootmem.c
--- a/mm/bootmem.c~bootmem-clean-up-free_all_bootmem_core
+++ a/mm/bootmem.c
@@ -144,66 +144,59 @@ unsigned long __init init_bootmem(unsign
 
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
+	int aligned;
 	struct page *page;
-	unsigned long pfn;
-	unsigned long i, count;
-	unsigned long idx, pages;
-	unsigned long *map;
-	int gofast = 0;
-
-	BUG_ON(!bdata->node_bootmem_map);
-
-	count = 0;
-	/* first extant page of the node */
-	pfn = PFN_DOWN(bdata->node_boot_start);
-	idx = bdata->node_low_pfn - pfn;
-	map = bdata->node_bootmem_map;
+	unsigned long start, end, pages, count = 0;
+
+	if (!bdata->node_bootmem_map)
+		return 0;
+
+	start = PFN_DOWN(bdata->node_boot_start);
+	end = bdata->node_low_pfn;
+
 	/*
-	 * Check if we are aligned to BITS_PER_LONG pages.  If so, we might
-	 * be able to free page orders of that size at once.
+	 * If the start is aligned to the machines wordsize, we might
+	 * be able to free pages in bulks of that order.
 	 */
-	if (!(pfn & (BITS_PER_LONG-1)))
-		gofast = 1;
+	aligned = !(start & (BITS_PER_LONG - 1));
+
+	bdebug("nid=%d start=%lx end=%lx aligned=%d\n",
+		bdata - bootmem_node_data, start, end, aligned);
+
+	while (start < end) {
+		unsigned long *map, idx, vec;
 
-	for (i = 0; i < idx; ) {
-		unsigned long v = ~map[i / BITS_PER_LONG];
+		map = bdata->node_bootmem_map;
+		idx = start - PFN_DOWN(bdata->node_boot_start);
+		vec = ~map[idx / BITS_PER_LONG];
 
-		if (gofast && v == ~0UL) {
-			int order;
+		if (aligned && vec == ~0UL && start + BITS_PER_LONG < end) {
+			int order = ilog2(BITS_PER_LONG);
 
-			page = pfn_to_page(pfn);
+			__free_pages_bootmem(pfn_to_page(start), order);
 			count += BITS_PER_LONG;
-			order = ffs(BITS_PER_LONG) - 1;
-			__free_pages_bootmem(page, order);
-			i += BITS_PER_LONG;
-			page += BITS_PER_LONG;
-		} else if (v) {
-			unsigned long m;
-
-			page = pfn_to_page(pfn);
-			for (m = 1; m && i < idx; m<<=1, page++, i++) {
-				if (v & m) {
-					count++;
+		} else {
+			unsigned long off = 0;
+
+			while (vec && off < BITS_PER_LONG) {
+				if (vec & 1) {
+					page = pfn_to_page(start + off);
 					__free_pages_bootmem(page, 0);
+					count++;
 				}
+				vec >>= 1;
+				off++;
 			}
-		} else {
-			i += BITS_PER_LONG;
 		}
-		pfn += BITS_PER_LONG;
+		start += BITS_PER_LONG;
 	}
 
-	/*
-	 * Now free the allocator bitmap itself, it's not
-	 * needed anymore:
-	 */
 	page = virt_to_page(bdata->node_bootmem_map);
 	pages = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
-	idx = bootmem_bootmap_pages(pages);
-	for (i = 0; i < idx; i++, page++)
-		__free_pages_bootmem(page, 0);
-	count += i;
-	bdata->node_bootmem_map = NULL;
+	pages = bootmem_bootmap_pages(pages);
+	count += pages;
+	while (pages--)
+		__free_pages_bootmem(page++, 0);
 
 	bdebug("nid=%d released=%lx\n", bdata - bootmem_node_data, count);
 
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
bootmem-clean-up-bootmemc-file-header.patch
bootmem-add-documentation-to-api-functions.patch
bootmem-add-debugging-framework.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch

