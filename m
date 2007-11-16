From: akpm@linux-foundation.org
Subject: + page-allocator-get-rid-of-the-list-of-cold-pages.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:27:42 -0800
Message-ID: <200711160027.lAG0RglI023690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393AbXKPA2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:28:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mbligh@mbligh.org, mel@csn.ul.ie


The patch titled
     Page allocator: get rid of the list of cold pages
has been added to the -mm tree.  Its filename is
     page-allocator-get-rid-of-the-list-of-cold-pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Page allocator: get rid of the list of cold pages
From: Christoph Lameter <clameter@sgi.com>

We have repeatedly discussed if the cold pages still have a point. There is
one way to join the two lists: Use a single list and put the cold pages at the
end and the hot pages at the beginning. That way a single list can serve for
both types of allocations.

The discussion of the RFC for this and Mel's measurements indicate that
there may not be too much of a point left to having separate lists for
hot and cold pages (see http://marc.info/?t=119492914200001&r=1&w=2).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Martin Bligh <mbligh@mbligh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 -
 mm/page_alloc.c        |   54 ++++++++++++++++++---------------------
 mm/vmstat.c            |   30 ++++++++-------------
 3 files changed, 39 insertions(+), 47 deletions(-)

diff -puN include/linux/mmzone.h~page-allocator-get-rid-of-the-list-of-cold-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~page-allocator-get-rid-of-the-list-of-cold-pages
+++ a/include/linux/mmzone.h
@@ -113,7 +113,7 @@ struct per_cpu_pages {
 };
 
 struct per_cpu_pageset {
-	struct per_cpu_pages pcp[2];	/* 0: hot.  1: cold */
+	struct per_cpu_pages pcp;
 #ifdef CONFIG_NUMA
 	s8 expire;
 #endif
diff -puN mm/page_alloc.c~page-allocator-get-rid-of-the-list-of-cold-pages mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-get-rid-of-the-list-of-cold-pages
+++ a/mm/page_alloc.c
@@ -895,20 +895,18 @@ static void drain_pages(unsigned int cpu
 
 	for_each_zone(zone) {
 		struct per_cpu_pageset *pset;
+		struct per_cpu_pages *pcp;
 
 		if (!populated_zone(zone))
 			continue;
 
 		pset = zone_pcp(zone, cpu);
-		for (i = 0; i < ARRAY_SIZE(pset->pcp); i++) {
-			struct per_cpu_pages *pcp;
 
-			pcp = &pset->pcp[i];
-			local_irq_save(flags);
-			free_pages_bulk(zone, pcp->count, &pcp->list, 0);
-			pcp->count = 0;
-			local_irq_restore(flags);
-		}
+		pcp = &pset->pcp;
+		local_irq_save(flags);
+		free_pages_bulk(zone, pcp->count, &pcp->list, 0);
+		pcp->count = 0;
+		local_irq_restore(flags);
 	}
 }
 
@@ -983,10 +981,13 @@ static void fastcall free_hot_cold_page(
 	arch_free_page(page, 0);
 	kernel_map_pages(page, 1, 0);
 
-	pcp = &zone_pcp(zone, get_cpu())->pcp[cold];
+	pcp = &zone_pcp(zone, get_cpu())->pcp;
 	local_irq_save(flags);
 	__count_vm_event(PGFREE);
-	list_add(&page->lru, &pcp->list);
+	if (cold)
+		list_add_tail(&page->lru, &pcp->list);
+	else
+		list_add(&page->lru, &pcp->list);
 	set_page_private(page, get_pageblock_migratetype(page));
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
@@ -1044,7 +1045,7 @@ again:
 	if (likely(order == 0)) {
 		struct per_cpu_pages *pcp;
 
-		pcp = &zone_pcp(zone, cpu)->pcp[cold];
+		pcp = &zone_pcp(zone, cpu)->pcp;
 		local_irq_save(flags);
 		if (!pcp->count) {
 			pcp->count = rmqueue_bulk(zone, 0,
@@ -1054,9 +1055,15 @@ again:
 		}
 
 		/* Find a page of the appropriate migrate type */
-		list_for_each_entry(page, &pcp->list, lru)
-			if (page_private(page) == migratetype)
-				break;
+		if (cold) {
+			list_for_each_entry_reverse(page, &pcp->list, lru)
+				if (page_private(page) == migratetype)
+					break;
+		} else {
+			list_for_each_entry(page, &pcp->list, lru)
+				if (page_private(page) == migratetype)
+					break;
+		}
 
 		/* Allocate more to the pcp list if necessary */
 		if (unlikely(&page->lru == &pcp->list)) {
@@ -1783,12 +1790,9 @@ void show_free_areas(void)
 
 			pageset = zone_pcp(zone, cpu);
 
-			printk("CPU %4d: Hot: hi:%5d, btch:%4d usd:%4d   "
-			       "Cold: hi:%5d, btch:%4d usd:%4d\n",
-			       cpu, pageset->pcp[0].high,
-			       pageset->pcp[0].batch, pageset->pcp[0].count,
-			       pageset->pcp[1].high, pageset->pcp[1].batch,
-			       pageset->pcp[1].count);
+			printk("CPU %4d: hi:%5d, btch:%4d usd:%4d\n",
+			       cpu, pageset->pcp.high,
+			       pageset->pcp.batch, pageset->pcp.count);
 		}
 	}
 
@@ -2586,17 +2590,11 @@ inline void setup_pageset(struct per_cpu
 
 	memset(p, 0, sizeof(*p));
 
-	pcp = &p->pcp[0];		/* hot */
+	pcp = &p->pcp;
 	pcp->count = 0;
 	pcp->high = 6 * batch;
 	pcp->batch = max(1UL, 1 * batch);
 	INIT_LIST_HEAD(&pcp->list);
-
-	pcp = &p->pcp[1];		/* cold*/
-	pcp->count = 0;
-	pcp->high = 2 * batch;
-	pcp->batch = max(1UL, batch/2);
-	INIT_LIST_HEAD(&pcp->list);
 }
 
 /*
@@ -2609,7 +2607,7 @@ static void setup_pagelist_highmark(stru
 {
 	struct per_cpu_pages *pcp;
 
-	pcp = &p->pcp[0]; /* hot list */
+	pcp = &p->pcp;
 	pcp->high = high;
 	pcp->batch = max(1UL, high/4);
 	if ((high/4) > (PAGE_SHIFT * 8))
diff -puN mm/vmstat.c~page-allocator-get-rid-of-the-list-of-cold-pages mm/vmstat.c
--- a/mm/vmstat.c~page-allocator-get-rid-of-the-list-of-cold-pages
+++ a/mm/vmstat.c
@@ -337,7 +337,7 @@ void refresh_cpu_vm_stats(int cpu)
 		 * Check if there are pages remaining in this pageset
 		 * if not then there is nothing to expire.
 		 */
-		if (!p->expire || (!p->pcp[0].count && !p->pcp[1].count))
+		if (!p->expire || !p->pcp.count)
 			continue;
 
 		/*
@@ -352,11 +352,8 @@ void refresh_cpu_vm_stats(int cpu)
 		if (p->expire)
 			continue;
 
-		if (p->pcp[0].count)
-			drain_zone_pages(zone, p->pcp + 0);
-
-		if (p->pcp[1].count)
-			drain_zone_pages(zone, p->pcp + 1);
+		if (p->pcp.count)
+			drain_zone_pages(zone, &p->pcp);
 #endif
 	}
 
@@ -693,20 +690,17 @@ static void zoneinfo_show_print(struct s
 		   "\n  pagesets");
 	for_each_online_cpu(i) {
 		struct per_cpu_pageset *pageset;
-		int j;
 
 		pageset = zone_pcp(zone, i);
-		for (j = 0; j < ARRAY_SIZE(pageset->pcp); j++) {
-			seq_printf(m,
-				   "\n    cpu: %i pcp: %i"
-				   "\n              count: %i"
-				   "\n              high:  %i"
-				   "\n              batch: %i",
-				   i, j,
-				   pageset->pcp[j].count,
-				   pageset->pcp[j].high,
-				   pageset->pcp[j].batch);
-			}
+		seq_printf(m,
+			   "\n    cpu: %i"
+			   "\n              count: %i"
+			   "\n              high:  %i"
+			   "\n              batch: %i",
+			   i,
+			   pageset->pcp.count,
+			   pageset->pcp.high,
+			   pageset->pcp.batch);
 #ifdef CONFIG_SMP
 		seq_printf(m, "\n  vm stats threshold: %d",
 				pageset->stat_threshold);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
x86_64-clean-up-stack-allocation-and-free.patch
x86_64-configure-stack-size.patch
x86_64-configure-stack-size-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-fix.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
