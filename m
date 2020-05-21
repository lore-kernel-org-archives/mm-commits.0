From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch added to
 -mm tree
Date: Wed, 20 May 2020 20:31:52 -0700
Message-ID: <20200521033152.dXWSpNWf4%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727974AbgEUDby (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:31:54 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: fold and remove lru_cache_add_anon() and lru_cache_add_file()
has been added to the -mm tree.  Its filename is
     mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: fold and remove lru_cache_add_anon() and lru_cache_add_file()

They're the same function, and for the purpose of all callers they are
equivalent to lru_cache_add().

Link: http://lkml.kernel.org/r/20200520232525.798933-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c       |   10 +++++-----
 fs/fuse/dev.c        |    2 +-
 include/linux/swap.h |    2 --
 mm/khugepaged.c      |    8 ++------
 mm/memory.c          |    2 +-
 mm/shmem.c           |    6 +++---
 mm/swap.c            |   38 ++++++++------------------------------
 mm/swap_state.c      |    2 +-
 8 files changed, 21 insertions(+), 49 deletions(-)

--- a/fs/cifs/file.c~mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file
+++ a/fs/cifs/file.c
@@ -4162,7 +4162,7 @@ cifs_readv_complete(struct work_struct *
 	for (i = 0; i < rdata->nr_pages; i++) {
 		struct page *page = rdata->pages[i];
 
-		lru_cache_add_file(page);
+		lru_cache_add(page);
 
 		if (rdata->result == 0 ||
 		    (rdata->result == -EAGAIN && got_bytes)) {
@@ -4232,7 +4232,7 @@ readpages_fill_pages(struct TCP_Server_I
 			 * fill them until the writes are flushed.
 			 */
 			zero_user(page, 0, PAGE_SIZE);
-			lru_cache_add_file(page);
+			lru_cache_add(page);
 			flush_dcache_page(page);
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -4242,7 +4242,7 @@ readpages_fill_pages(struct TCP_Server_I
 			continue;
 		} else {
 			/* no need to hold page hostage */
-			lru_cache_add_file(page);
+			lru_cache_add(page);
 			unlock_page(page);
 			put_page(page);
 			rdata->pages[i] = NULL;
@@ -4437,7 +4437,7 @@ static int cifs_readpages(struct file *f
 			/* best to give up if we're out of mem */
 			list_for_each_entry_safe(page, tpage, &tmplist, lru) {
 				list_del(&page->lru);
-				lru_cache_add_file(page);
+				lru_cache_add(page);
 				unlock_page(page);
 				put_page(page);
 			}
@@ -4475,7 +4475,7 @@ static int cifs_readpages(struct file *f
 			add_credits_and_wake_if(server, &rdata->credits, 0);
 			for (i = 0; i < rdata->nr_pages; i++) {
 				page = rdata->pages[i];
-				lru_cache_add_file(page);
+				lru_cache_add(page);
 				unlock_page(page);
 				put_page(page);
 			}
--- a/fs/fuse/dev.c~mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file
+++ a/fs/fuse/dev.c
@@ -840,7 +840,7 @@ static int fuse_try_move_page(struct fus
 	get_page(newpage);
 
 	if (!(buf->flags & PIPE_BUF_FLAG_LRU))
-		lru_cache_add_file(newpage);
+		lru_cache_add(newpage);
 
 	err = 0;
 	spin_lock(&cs->req->waitq.lock);
--- a/include/linux/swap.h~mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file
+++ a/include/linux/swap.h
@@ -335,8 +335,6 @@ extern unsigned long nr_free_pagecache_p
 
 /* linux/mm/swap.c */
 extern void lru_cache_add(struct page *);
-extern void lru_cache_add_anon(struct page *page);
-extern void lru_cache_add_file(struct page *page);
 extern void lru_add_page_tail(struct page *page, struct page *page_tail,
 			 struct lruvec *lruvec, struct list_head *head);
 extern void activate_page(struct page *);
--- a/mm/khugepaged.c~mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file
+++ a/mm/khugepaged.c
@@ -1775,13 +1775,9 @@ xa_unlocked:
 
 		SetPageUptodate(new_page);
 		page_ref_add(new_page, HPAGE_PMD_NR - 1);
-
-		if (is_shmem) {
+		if (is_shmem)
 			set_page_dirty(new_page);
-			lru_cache_add_anon(new_page);
-		} else {
-			lru_cache_add_file(new_page);
-		}
+		lru_cache_add(new_page);
 
 		/*
 		 * Remove pte page tables, so we can re-fault the page as huge.
--- a/mm/memory.c~mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file
+++ a/mm/memory.c
@@ -3139,7 +3139,7 @@ vm_fault_t do_swap_page(struct vm_fault
 				if (err)
 					goto out_page;
 
-				lru_cache_add_anon(page);
+				lru_cache_add(page);
 				swap_readpage(page, true);
 			}
 		} else {
--- a/mm/shmem.c~mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file
+++ a/mm/shmem.c
@@ -1609,7 +1609,7 @@ static int shmem_replace_page(struct pag
 		 */
 		oldpage = newpage;
 	} else {
-		lru_cache_add_anon(newpage);
+		lru_cache_add(newpage);
 		*pagep = newpage;
 	}
 
@@ -1860,7 +1860,7 @@ alloc_nohuge:
 					charge_mm);
 	if (error)
 		goto unacct;
-	lru_cache_add_anon(page);
+	lru_cache_add(page);
 
 	spin_lock_irq(&info->lock);
 	info->alloced += compound_nr(page);
@@ -2376,7 +2376,7 @@ static int shmem_mfill_atomic_pte(struct
 	if (!pte_none(*dst_pte))
 		goto out_release_unlock;
 
-	lru_cache_add_anon(page);
+	lru_cache_add(page);
 
 	spin_lock_irq(&info->lock);
 	info->alloced++;
--- a/mm/swap.c~mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file
+++ a/mm/swap.c
@@ -403,35 +403,6 @@ void mark_page_accessed(struct page *pag
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
-static void __lru_cache_add(struct page *page)
-{
-	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
-
-	get_page(page);
-	if (!pagevec_add(pvec, page) || PageCompound(page))
-		__pagevec_lru_add(pvec);
-	put_cpu_var(lru_add_pvec);
-}
-
-/**
- * lru_cache_add_anon - add a page to the page lists
- * @page: the page to add
- */
-void lru_cache_add_anon(struct page *page)
-{
-	if (PageActive(page))
-		ClearPageActive(page);
-	__lru_cache_add(page);
-}
-
-void lru_cache_add_file(struct page *page)
-{
-	if (PageActive(page))
-		ClearPageActive(page);
-	__lru_cache_add(page);
-}
-EXPORT_SYMBOL(lru_cache_add_file);
-
 /**
  * lru_cache_add - add a page to a page list
  * @page: the page to be added to the LRU.
@@ -443,10 +414,17 @@ EXPORT_SYMBOL(lru_cache_add_file);
  */
 void lru_cache_add(struct page *page)
 {
+	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
+
 	VM_BUG_ON_PAGE(PageActive(page) && PageUnevictable(page), page);
 	VM_BUG_ON_PAGE(PageLRU(page), page);
-	__lru_cache_add(page);
+
+	get_page(page);
+	if (!pagevec_add(pvec, page) || PageCompound(page))
+		__pagevec_lru_add(pvec);
+	put_cpu_var(lru_add_pvec);
 }
+EXPORT_SYMBOL(lru_cache_add);
 
 /**
  * lru_cache_add_active_or_unevictable
--- a/mm/swap_state.c~mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file
+++ a/mm/swap_state.c
@@ -432,7 +432,7 @@ struct page *__read_swap_cache_async(swp
 
 	/* Initiate read into locked page */
 	SetPageWorkingset(page);
-	lru_cache_add_anon(page);
+	lru_cache_add(page);
 	*new_page_allocated = true;
 	return page;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-shmem-remove-rare-optimization-when-swapin-races-with-hole-punching.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter-fix.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
mm-fix-lru-balancing-effect-of-new-transparent-huge-pages.patch
mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity.patch
mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset.patch
mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch
mm-workingset-let-cache-workingset-challenge-anon.patch
mm-remove-use-once-cache-bias-from-lru-balancing.patch
mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch
mm-base-lru-balancing-on-an-explicit-cost-model.patch
mm-deactivations-shouldnt-bias-the-lru-balance.patch
mm-only-count-actual-rotations-as-lru-reclaim-cost.patch
mm-balance-lru-lists-based-on-relative-thrashing.patch
mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch
mm-vmscan-reclaim-writepage-is-io-cost.patch
mm-vmscan-limit-the-range-of-lru-type-balancing.patch
