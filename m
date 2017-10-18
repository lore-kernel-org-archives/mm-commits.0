From: akpm@linux-foundation.org
Subject: + mm-remove-cold-parameter-from-free_hot_cold_page.patch added to -mm tree
Date: Wed, 18 Oct 2017 15:16:57 -0700
Message-ID: <59e7d2d9.HIB7Hsw5MdznxzGV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbdJRWQ6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 18:16:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove cold parameter from free_hot_cold_page*
has been added to the -mm tree.  Its filename is
     mm-remove-cold-parameter-from-free_hot_cold_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-cold-parameter-from-free_hot_cold_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-cold-parameter-from-free_hot_cold_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: remove cold parameter from free_hot_cold_page*

Most callers users of free_hot_cold_page claim the pages being released
are cache hot.  The exception is the page reclaim paths where it is likely
that enough pages will be freed in the near future that the per-cpu lists
are going to be recycled and the cache hotness information is lost.  As no
one really cares about the hotness of pages being released to the
allocator, just ditch the parameter.

The APIs are renamed to indicate that it's no longer about hot/cold pages.
It should also be less confusing as there are subtle differences between
them.  __free_pages drops a reference and frees a page when the refcount
reaches zero.  free_hot_cold_page handled pages whose refcount was already
zero which is non-obvious from the name.  free_unref_page should be more
obvious.

No performance impact is expected as the overhead is marginal.  The
parameter is removed simply because it is a bit stupid to have a useless
parameter copied everywhere.

Link: http://lkml.kernel.org/r/20171018075952.10627-8-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mmu_context_book3s64.c |    2 -
 arch/powerpc/mm/pgtable_64.c           |    2 -
 arch/sparc/mm/init_64.c                |    2 -
 arch/tile/mm/homecache.c               |    2 -
 include/linux/gfp.h                    |    4 +--
 include/trace/events/kmem.h            |   11 +++-----
 mm/page_alloc.c                        |   29 +++++++++--------------
 mm/rmap.c                              |    2 -
 mm/swap.c                              |    4 +--
 mm/vmscan.c                            |    6 ++--
 10 files changed, 28 insertions(+), 36 deletions(-)

diff -puN arch/powerpc/mm/mmu_context_book3s64.c~mm-remove-cold-parameter-from-free_hot_cold_page arch/powerpc/mm/mmu_context_book3s64.c
--- a/arch/powerpc/mm/mmu_context_book3s64.c~mm-remove-cold-parameter-from-free_hot_cold_page
+++ a/arch/powerpc/mm/mmu_context_book3s64.c
@@ -200,7 +200,7 @@ static void destroy_pagetable_page(struc
 	/* We allow PTE_FRAG_NR fragments from a PTE page */
 	if (page_ref_sub_and_test(page, PTE_FRAG_NR - count)) {
 		pgtable_page_dtor(page);
-		free_hot_cold_page(page, 0);
+		free_unref_page(page);
 	}
 }
 
diff -puN arch/powerpc/mm/pgtable_64.c~mm-remove-cold-parameter-from-free_hot_cold_page arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~mm-remove-cold-parameter-from-free_hot_cold_page
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -404,7 +404,7 @@ void pte_fragment_free(unsigned long *ta
 	if (put_page_testzero(page)) {
 		if (!kernel)
 			pgtable_page_dtor(page);
-		free_hot_cold_page(page, 0);
+		free_unref_page(page);
 	}
 }
 
diff -puN arch/sparc/mm/init_64.c~mm-remove-cold-parameter-from-free_hot_cold_page arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~mm-remove-cold-parameter-from-free_hot_cold_page
+++ a/arch/sparc/mm/init_64.c
@@ -2938,7 +2938,7 @@ pgtable_t pte_alloc_one(struct mm_struct
 	if (!page)
 		return NULL;
 	if (!pgtable_page_ctor(page)) {
-		free_hot_cold_page(page, 0);
+		free_unref_page(page);
 		return NULL;
 	}
 	return (pte_t *) page_address(page);
diff -puN arch/tile/mm/homecache.c~mm-remove-cold-parameter-from-free_hot_cold_page arch/tile/mm/homecache.c
--- a/arch/tile/mm/homecache.c~mm-remove-cold-parameter-from-free_hot_cold_page
+++ a/arch/tile/mm/homecache.c
@@ -409,7 +409,7 @@ void __homecache_free_pages(struct page
 	if (put_page_testzero(page)) {
 		homecache_change_page_home(page, order, PAGE_HOME_HASH);
 		if (order == 0) {
-			free_hot_cold_page(page, false);
+			free_unref_page(page);
 		} else {
 			init_page_count(page);
 			__free_pages(page, order);
diff -puN include/linux/gfp.h~mm-remove-cold-parameter-from-free_hot_cold_page include/linux/gfp.h
--- a/include/linux/gfp.h~mm-remove-cold-parameter-from-free_hot_cold_page
+++ a/include/linux/gfp.h
@@ -529,8 +529,8 @@ void * __meminit alloc_pages_exact_nid(i
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
-extern void free_hot_cold_page(struct page *page, bool cold);
-extern void free_hot_cold_page_list(struct list_head *list, bool cold);
+extern void free_unref_page(struct page *page);
+extern void free_unref_page_list(struct list_head *list);
 
 struct page_frag_cache;
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
diff -puN include/trace/events/kmem.h~mm-remove-cold-parameter-from-free_hot_cold_page include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~mm-remove-cold-parameter-from-free_hot_cold_page
+++ a/include/trace/events/kmem.h
@@ -171,24 +171,21 @@ TRACE_EVENT(mm_page_free,
 
 TRACE_EVENT(mm_page_free_batched,
 
-	TP_PROTO(struct page *page, int cold),
+	TP_PROTO(struct page *page),
 
-	TP_ARGS(page, cold),
+	TP_ARGS(page),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	pfn		)
-		__field(	int,		cold		)
 	),
 
 	TP_fast_assign(
 		__entry->pfn		= page_to_pfn(page);
-		__entry->cold		= cold;
 	),
 
-	TP_printk("page=%p pfn=%lu order=0 cold=%d",
+	TP_printk("page=%p pfn=%lu order=0",
 			pfn_to_page(__entry->pfn),
-			__entry->pfn,
-			__entry->cold)
+			__entry->pfn)
 );
 
 TRACE_EVENT(mm_page_alloc,
diff -puN mm/page_alloc.c~mm-remove-cold-parameter-from-free_hot_cold_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-cold-parameter-from-free_hot_cold_page
+++ a/mm/page_alloc.c
@@ -2587,7 +2587,7 @@ void mark_free_pages(struct zone *zone)
 }
 #endif /* CONFIG_PM */
 
-static bool free_hot_cold_page_prepare(struct page *page, unsigned long pfn)
+static bool free_unref_page_prepare(struct page *page, unsigned long pfn)
 {
 	int migratetype;
 
@@ -2599,8 +2599,7 @@ static bool free_hot_cold_page_prepare(s
 	return true;
 }
 
-static void free_hot_cold_page_commit(struct page *page, unsigned long pfn,
-				bool cold)
+static void free_unref_page_commit(struct page *page, unsigned long pfn)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
@@ -2625,10 +2624,7 @@ static void free_hot_cold_page_commit(st
 	}
 
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
-	if (!cold)
-		list_add(&page->lru, &pcp->lists[migratetype]);
-	else
-		list_add_tail(&page->lru, &pcp->lists[migratetype]);
+	list_add_tail(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
 		unsigned long batch = READ_ONCE(pcp->batch);
@@ -2639,25 +2635,24 @@ static void free_hot_cold_page_commit(st
 
 /*
  * Free a 0-order page
- * cold == true ? free a cold page : free a hot page
  */
-void free_hot_cold_page(struct page *page, bool cold)
+void free_unref_page(struct page *page)
 {
 	unsigned long flags;
 	unsigned long pfn = page_to_pfn(page);
 
-	if (!free_hot_cold_page_prepare(page, pfn))
+	if (!free_unref_page_prepare(page, pfn))
 		return;
 
 	local_irq_save(flags);
-	free_hot_cold_page_commit(page, pfn, cold);
+	free_unref_page_commit(page, pfn);
 	local_irq_restore(flags);
 }
 
 /*
  * Free a list of 0-order pages
  */
-void free_hot_cold_page_list(struct list_head *list, bool cold)
+void free_unref_page_list(struct list_head *list)
 {
 	struct page *page, *next;
 	unsigned long flags, pfn;
@@ -2665,7 +2660,7 @@ void free_hot_cold_page_list(struct list
 	/* Prepare pages for freeing */
 	list_for_each_entry_safe(page, next, list, lru) {
 		pfn = page_to_pfn(page);
-		if (!free_hot_cold_page_prepare(page, pfn))
+		if (!free_unref_page_prepare(page, pfn))
 			list_del(&page->lru);
 		set_page_private(page, pfn);
 	}
@@ -2675,8 +2670,8 @@ void free_hot_cold_page_list(struct list
 		unsigned long pfn = page_private(page);
 
 		set_page_private(page, 0);
-		trace_mm_page_free_batched(page, cold);
-		free_hot_cold_page_commit(page, pfn, cold);
+		trace_mm_page_free_batched(page);
+		free_unref_page_commit(page, pfn);
 	}
 	local_irq_restore(flags);
 }
@@ -4277,7 +4272,7 @@ void __free_pages(struct page *page, uns
 {
 	if (put_page_testzero(page)) {
 		if (order == 0)
-			free_hot_cold_page(page, false);
+			free_unref_page(page);
 		else
 			__free_pages_ok(page, order);
 	}
@@ -4335,7 +4330,7 @@ void __page_frag_cache_drain(struct page
 		unsigned int order = compound_order(page);
 
 		if (order == 0)
-			free_hot_cold_page(page, false);
+			free_unref_page(page);
 		else
 			__free_pages_ok(page, order);
 	}
diff -puN mm/rmap.c~mm-remove-cold-parameter-from-free_hot_cold_page mm/rmap.c
--- a/mm/rmap.c~mm-remove-cold-parameter-from-free_hot_cold_page
+++ a/mm/rmap.c
@@ -1321,7 +1321,7 @@ void page_remove_rmap(struct page *page,
 	 * It would be tidy to reset the PageAnon mapping here,
 	 * but that might overwrite a racing page_add_anon_rmap
 	 * which increments mapcount after us but sets mapping
-	 * before us: so leave the reset to free_hot_cold_page,
+	 * before us: so leave the reset to free_unref_page,
 	 * and remember that it's only reliable while mapped.
 	 * Leaving it set also helps swapoff to reinstate ptes
 	 * faster for those pages still in swapcache.
diff -puN mm/swap.c~mm-remove-cold-parameter-from-free_hot_cold_page mm/swap.c
--- a/mm/swap.c~mm-remove-cold-parameter-from-free_hot_cold_page
+++ a/mm/swap.c
@@ -76,7 +76,7 @@ static void __page_cache_release(struct
 static void __put_single_page(struct page *page)
 {
 	__page_cache_release(page);
-	free_hot_cold_page(page, false);
+	free_unref_page(page);
 }
 
 static void __put_compound_page(struct page *page)
@@ -817,7 +817,7 @@ void release_pages(struct page **pages,
 		spin_unlock_irqrestore(&locked_pgdat->lru_lock, flags);
 
 	mem_cgroup_uncharge_list(&pages_to_free);
-	free_hot_cold_page_list(&pages_to_free, 0);
+	free_unref_page_list(&pages_to_free);
 }
 EXPORT_SYMBOL(release_pages);
 
diff -puN mm/vmscan.c~mm-remove-cold-parameter-from-free_hot_cold_page mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-cold-parameter-from-free_hot_cold_page
+++ a/mm/vmscan.c
@@ -1348,7 +1348,7 @@ keep:
 
 	mem_cgroup_uncharge_list(&free_pages);
 	try_to_unmap_flush();
-	free_hot_cold_page_list(&free_pages, true);
+	free_unref_page_list(&free_pages);
 
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
@@ -1823,7 +1823,7 @@ shrink_inactive_list(unsigned long nr_to
 	spin_unlock_irq(&pgdat->lru_lock);
 
 	mem_cgroup_uncharge_list(&page_list);
-	free_hot_cold_page_list(&page_list, true);
+	free_unref_page_list(&page_list);
 
 	/*
 	 * If reclaim is isolating dirty pages under writeback, it implies
@@ -2062,7 +2062,7 @@ static void shrink_active_list(unsigned
 	spin_unlock_irq(&pgdat->lru_lock);
 
 	mem_cgroup_uncharge_list(&l_hold);
-	free_hot_cold_page_list(&l_hold, true);
+	free_unref_page_list(&l_hold);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
 }
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages.patch
mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix.patch
mm-truncate-do-not-check-mapping-for-every-page-being-truncated.patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch
mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch
mm-pagevec-remove-cold-parameter-for-pagevecs.patch
mm-remove-cold-parameter-for-release_pages.patch
mm-remove-cold-parameter-from-free_hot_cold_page.patch
mm-remove-__gfp_cold.patch

