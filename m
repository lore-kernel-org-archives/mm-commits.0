From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-move-lazy-free-pages-to-inactive-list.patch
 removed from -mm tree
Date: Mon, 02 Nov 2015 14:53:44 -0800
Message-ID: <5637e978.5riszk/20FEdXS8r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbKBWxp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:53:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, Yalin.Wang@sonymobile.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move lazily freed pages to inactive list
has been removed from the -mm tree.  Its filename was
     mm-move-lazy-free-pages-to-inactive-list.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: move lazily freed pages to inactive list

MADV_FREE is a hint that it's okay to discard pages if there is memory
pressure and we use reclaimers(ie, kswapd and direct reclaim) to free them
so there is no value keeping them in the active anonymous LRU so this
patch moves them to inactive LRU list's head.

This means that MADV_FREE-ed pages which were living on the inactive list
are reclaimed first because they are more likely to be cold rather than
recently active pages.

An arguable issue for the approach would be whether we should put the page
to the head or tail of the inactive list.  I chose head because the kernel
cannot make sure it's really cold or warm for every MADV_FREE usecase but
at least we know it's not *hot*, so landing of inactive head would be a
comprimise for various usecases.

This fixes suboptimal behavior of MADV_FREE when pages living on the
active list will sit there for a long time even under memory pressure
while the inactive list is reclaimed heavily.  This basically breaks the
whole purpose of using MADV_FREE to help the system to free memory which
is might not be used.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Wang, Yalin <Yalin.Wang@sonymobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/madvise.c         |    2 +
 mm/swap.c            |   44 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff -puN include/linux/swap.h~mm-move-lazy-free-pages-to-inactive-list include/linux/swap.h
--- a/include/linux/swap.h~mm-move-lazy-free-pages-to-inactive-list
+++ a/include/linux/swap.h
@@ -308,6 +308,7 @@ extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_file_page(struct page *page);
+extern void deactivate_page(struct page *page);
 extern void swap_setup(void);
 
 extern void add_page_to_unevictable_list(struct page *page);
diff -puN mm/madvise.c~mm-move-lazy-free-pages-to-inactive-list mm/madvise.c
--- a/mm/madvise.c~mm-move-lazy-free-pages-to-inactive-list
+++ a/mm/madvise.c
@@ -344,6 +344,8 @@ static int madvise_free_pte_range(pmd_t
 		ptent = pte_mkold(ptent);
 		ptent = pte_mkclean(ptent);
 		set_pte_at(mm, addr, pte, ptent);
+		if (PageActive(page))
+			deactivate_page(page);
 		tlb_remove_tlb_entry(tlb, pte, addr);
 	}
 
diff -puN mm/swap.c~mm-move-lazy-free-pages-to-inactive-list mm/swap.c
--- a/mm/swap.c~mm-move-lazy-free-pages-to-inactive-list
+++ a/mm/swap.c
@@ -45,6 +45,7 @@ int page_cluster;
 static DEFINE_PER_CPU(struct pagevec, lru_add_pvec);
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_file_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -554,6 +555,24 @@ static void lru_deactivate_file_fn(struc
 	update_page_reclaim_stat(lruvec, file, 0);
 }
 
+
+static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
+			    void *arg)
+{
+	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
+		int file = page_is_file_cache(page);
+		int lru = page_lru_base_type(page);
+
+		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
+		ClearPageActive(page);
+		ClearPageReferenced(page);
+		add_page_to_lru_list(page, lruvec, lru);
+
+		__count_vm_event(PGDEACTIVATE);
+		update_page_reclaim_stat(lruvec, file, 0);
+	}
+}
+
 /*
  * Drain pages out of the cpu's pagevecs.
  * Either "cpu" is the current CPU, and preemption has already been
@@ -580,6 +599,10 @@ void lru_add_drain_cpu(int cpu)
 	if (pagevec_count(pvec))
 		pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, NULL);
 
+	pvec = &per_cpu(lru_deactivate_pvecs, cpu);
+	if (pagevec_count(pvec))
+		pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
+
 	activate_page_drain(cpu);
 }
 
@@ -609,6 +632,26 @@ void deactivate_file_page(struct page *p
 	}
 }
 
+/**
+ * deactivate_page - deactivate a page
+ * @page: page to deactivate
+ *
+ * deactivate_page() moves @page to the inactive list if @page was on the active
+ * list and was not an unevictable page.  This is done to accelerate the reclaim
+ * of @page.
+ */
+void deactivate_page(struct page *page)
+{
+	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
+		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
+
+		page_cache_get(page);
+		if (!pagevec_add(pvec, page))
+			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
+		put_cpu_var(lru_deactivate_pvecs);
+	}
+}
+
 void lru_add_drain(void)
 {
 	lru_add_drain_cpu(get_cpu());
@@ -638,6 +681,7 @@ void lru_add_drain_all(void)
 		if (pagevec_count(&per_cpu(lru_add_pvec, cpu)) ||
 		    pagevec_count(&per_cpu(lru_rotate_pvecs, cpu)) ||
 		    pagevec_count(&per_cpu(lru_deactivate_file_pvecs, cpu)) ||
+		    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
 		    need_activate_page_drain(cpu)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
 			schedule_work_on(cpu, work);
_

Patches currently in -mm which might be from minchan@kernel.org are

x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch

