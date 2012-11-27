From: akpm@linux-foundation.org
Subject: [folded-merged] mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2.patch removed from -mm tree
Date: Tue, 27 Nov 2012 11:06:23 -0800
Message-ID: <20121127190624.A2523100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:58745 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab2K0TG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 14:06:28 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so973946vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 11:06:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2
has been removed from the -mm tree.  Its filename was
     mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2.patch

This patch was dropped because it was folded into mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2

In current code, after flush_all_zero_pkmaps() is invoked,
then re-iterate all pkmaps. It can be optimized if flush_all_zero_pkmaps()
return index of first flushed entry. With this index,
we can immediately map highmem page to virtual address represented by index.
So change return type of flush_all_zero_pkmaps()
and return index of first flushed entry.

Additionally, update last_pkmap_nr to this index.
It is certain that entry which is below this index is occupied by other mapping,
therefore updating last_pkmap_nr to this index is reasonable optimization.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 mm/highmem.c            |   24 +++++++++++++++---------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff -puN include/linux/highmem.h~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2 include/linux/highmem.h
--- a/include/linux/highmem.h~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2
+++ a/include/linux/highmem.h
@@ -32,7 +32,7 @@ static inline void invalidate_kernel_vma
 
 #ifdef CONFIG_HIGHMEM
 #include <asm/highmem.h>
-#define PKMAP_INDEX_INVAL (-1)
+#define PKMAP_INVALID_INDEX (LAST_PKMAP)
 
 /* declarations for linux/mm/highmem.c */
 unsigned int nr_free_highpages(void);
diff -puN mm/highmem.c~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2 mm/highmem.c
--- a/mm/highmem.c~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2
+++ a/mm/highmem.c
@@ -107,10 +107,10 @@ struct page *kmap_to_page(void *vaddr)
 }
 EXPORT_SYMBOL(kmap_to_page);
 
-static int flush_all_zero_pkmaps(void)
+static unsigned int flush_all_zero_pkmaps(void)
 {
 	int i;
-	int index = PKMAP_INDEX_INVAL;
+	unsigned int index = PKMAP_INVALID_INDEX;
 
 	flush_cache_kmaps();
 
@@ -142,9 +142,10 @@ static int flush_all_zero_pkmaps(void)
 			  &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
-		index = i;
+		if (index == PKMAP_INVALID_INDEX)
+			index = i;
 	}
-	if (index != PKMAP_INDEX_INVAL)
+	if (index != PKMAP_INVALID_INDEX)
 		flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
 
 	return index;
@@ -155,15 +156,19 @@ static int flush_all_zero_pkmaps(void)
  */
 void kmap_flush_unused(void)
 {
+	unsigned int index;
+
 	lock_kmap();
-	flush_all_zero_pkmaps();
+	index = flush_all_zero_pkmaps();
+	if (index != PKMAP_INVALID_INDEX && (index < last_pkmap_nr))
+		last_pkmap_nr = index;
 	unlock_kmap();
 }
 
 static inline unsigned long map_new_virtual(struct page *page)
 {
 	unsigned long vaddr;
-	int index = PKMAP_INDEX_INVAL;
+	unsigned int index = PKMAP_INVALID_INDEX;
 	int count;
 
 start:
@@ -173,8 +178,7 @@ start:
 		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
 		if (!last_pkmap_nr) {
 			index = flush_all_zero_pkmaps();
-			if (index != PKMAP_INDEX_INVAL)
-				break; /* Found a usable entry */
+			break;
 		}
 		if (!pkmap_count[last_pkmap_nr]) {
 			index = last_pkmap_nr;
@@ -187,7 +191,7 @@ start:
 	/*
 	 * Sleep for somebody else to unmap their entries
 	 */
-	if (index == PKMAP_INDEX_INVAL) {
+	if (index == PKMAP_INVALID_INDEX) {
 		DECLARE_WAITQUEUE(wait, current);
 
 		__set_current_state(TASK_UNINTERRUPTIBLE);
@@ -211,6 +215,7 @@ start:
 		   &(pkmap_page_table[index]), mk_pte(page, kmap_prot));
 
 	pkmap_count[index] = 1;
+	last_pkmap_nr = index;
 	set_page_address(page, (void *)vaddr);
 
 	return vaddr;
@@ -332,6 +337,7 @@ struct page_address_map {
 	void *virtual;
 	struct list_head list;
 };
+
 static struct page_address_map page_address_maps[LAST_PKMAP];
 
 /*
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-remove-page_address_pool-list-v2.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch
mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node.patch
avr32-kconfig-remove-have_arch_bootmem.patch
bootmem-remove-alloc_arch_preferred_bootmem.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-warn_on_once-if-f_op-mmap-change-vmas-start-address.patch

