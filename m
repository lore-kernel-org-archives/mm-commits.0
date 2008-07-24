From: akpm@linux-foundation.org
Subject: - bootmem-clean-up-free_all_bootmem_core.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:59 -0700
Message-ID: <200807242323.m6ONNxGJ010734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754861AbYGXXYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, andi@firstfloor.org, mingo@elte.hu, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     bootmem: clean up free_all_bootmem_core
has been removed from the -mm tree.  Its filename was
     bootmem-clean-up-free_all_bootmem_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: clean up free_all_bootmem_core
From: Johannes Weiner <hannes@saeurebad.de>

Rewrite the code in a more concise way using less variables.

[akpm@linux-foundation.org: fix printk warnings]
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
+	bdebug("nid=%td start=%lx end=%lx aligned=%d\n",
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
 
 	bdebug("nid=%td released=%lx\n", bdata - bootmem_node_data, count);
 
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

