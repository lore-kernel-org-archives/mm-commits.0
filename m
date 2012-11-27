From: akpm@linux-foundation.org
Subject: [withdrawn] mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch removed from -mm tree
Date: Tue, 27 Nov 2012 11:11:21 -0800
Message-ID: <20121127191122.3627A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:65091 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab2K0TLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 14:11:23 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so1500515qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 11:11:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, highmem: makes flush_all_zero_pkmaps() return index of last flushed entry
has been removed from the -mm tree.  Its filename was
     mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, highmem: makes flush_all_zero_pkmaps() return index of last flushed entry

In current code, after flush_all_zero_pkmaps() is invoked we re-iterate
all pkmaps.  This can be optimized if flush_all_zero_pkmaps() returns an
index of flushed entry.  With this index, we can immediately map highmem
page to virtual address represented by index.  So change return type of
flush_all_zero_pkmaps() and return index of last flushed entry.

Additionally, update last_pkmap_nr to this index.  It is certain that
entry which is below this index is occupied by other mapping, therefore
updating last_pkmap_nr to this index is reasonable optimization.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    1 
 mm/highmem.c            |   75 ++++++++++++++++++++++----------------
 2 files changed, 45 insertions(+), 31 deletions(-)

diff -puN include/linux/highmem.h~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry include/linux/highmem.h
--- a/include/linux/highmem.h~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry
+++ a/include/linux/highmem.h
@@ -32,6 +32,7 @@ static inline void invalidate_kernel_vma
 
 #ifdef CONFIG_HIGHMEM
 #include <asm/highmem.h>
+#define PKMAP_INVALID_INDEX (LAST_PKMAP)
 
 /* declarations for linux/mm/highmem.c */
 unsigned int nr_free_highpages(void);
diff -puN mm/highmem.c~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry mm/highmem.c
--- a/mm/highmem.c~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry
+++ a/mm/highmem.c
@@ -107,10 +107,10 @@ struct page *kmap_to_page(void *vaddr)
 }
 EXPORT_SYMBOL(kmap_to_page);
 
-static void flush_all_zero_pkmaps(void)
+static unsigned int flush_all_zero_pkmaps(void)
 {
 	int i;
-	int need_flush = 0;
+	unsigned int index = PKMAP_INVALID_INDEX;
 
 	flush_cache_kmaps();
 
@@ -142,10 +142,13 @@ static void flush_all_zero_pkmaps(void)
 			  &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
-		need_flush = 1;
+		if (index == PKMAP_INVALID_INDEX)
+			index = i;
 	}
-	if (need_flush)
+	if (index != PKMAP_INVALID_INDEX)
 		flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
+
+	return index;
 }
 
 /**
@@ -153,14 +156,19 @@ static void flush_all_zero_pkmaps(void)
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
+	unsigned int index = PKMAP_INVALID_INDEX;
 	int count;
 
 start:
@@ -169,40 +177,45 @@ start:
 	for (;;) {
 		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
 		if (!last_pkmap_nr) {
-			flush_all_zero_pkmaps();
-			count = LAST_PKMAP;
+			index = flush_all_zero_pkmaps();
+			break;
 		}
-		if (!pkmap_count[last_pkmap_nr])
+		if (!pkmap_count[last_pkmap_nr]) {
+			index = last_pkmap_nr;
 			break;	/* Found a usable entry */
-		if (--count)
-			continue;
+		}
+		if (--count == 0)
+			break;
+	}
 
-		/*
-		 * Sleep for somebody else to unmap their entries
-		 */
-		{
-			DECLARE_WAITQUEUE(wait, current);
+	/*
+	 * Sleep for somebody else to unmap their entries
+	 */
+	if (index == PKMAP_INVALID_INDEX) {
+		DECLARE_WAITQUEUE(wait, current);
 
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			add_wait_queue(&pkmap_map_wait, &wait);
-			unlock_kmap();
-			schedule();
-			remove_wait_queue(&pkmap_map_wait, &wait);
-			lock_kmap();
-
-			/* Somebody else might have mapped it while we slept */
-			if (page_address(page))
-				return (unsigned long)page_address(page);
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		add_wait_queue(&pkmap_map_wait, &wait);
+		unlock_kmap();
+		schedule();
+		remove_wait_queue(&pkmap_map_wait, &wait);
+		lock_kmap();
+
+		/* Somebody else might have mapped it while we slept */
+		vaddr = (unsigned long)page_address(page);
+		if (vaddr)
+			return vaddr;
 
-			/* Re-start */
-			goto start;
-		}
+		/* Re-start */
+		goto start;
 	}
-	vaddr = PKMAP_ADDR(last_pkmap_nr);
+
+	vaddr = PKMAP_ADDR(index);
 	set_pte_at(&init_mm, vaddr,
-		   &(pkmap_page_table[last_pkmap_nr]), mk_pte(page, kmap_prot));
+		   &(pkmap_page_table[index]), mk_pte(page, kmap_prot));
 
-	pkmap_count[last_pkmap_nr] = 1;
+	pkmap_count[index] = 1;
+	last_pkmap_nr = index;
 	set_page_address(page, (void *)vaddr);
 
 	return vaddr;
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-remove-page_address_pool-list-v2.patch
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

