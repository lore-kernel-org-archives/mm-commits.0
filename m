From: akpm@linux-foundation.org
Subject: [merged]
 mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch removed
 from -mm tree
Date: Thu, 04 Jun 2020 10:20:47 -0700
Message-ID: <20200604172047.DZEVG8X75%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgFDRUt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm: fold and remove lru_cache_add_anon() and lru_cache_add_file()
has been removed from the -mm tree.  Its filename was
     mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: fold and remove lru_cache_add_anon() and lru_cache_add_file()

They're the same function, and for the purpose of all callers they are
equivalent to lru_cache_add().

[akpm@linux-foundation.org: fix it for local_lock changes]
Link: http://lkml.kernel.org/r/20200520232525.798933-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c       |   10 ++++-----
 fs/fuse/dev.c        |    2 -
 include/linux/swap.h |    2 -
 mm/khugepaged.c      |    8 +------
 mm/memory.c          |    2 -
 mm/shmem.c           |    6 ++---
 mm/swap.c            |   42 +++++++++--------------------------------
 mm/swap_state.c      |    2 -
 8 files changed, 23 insertions(+), 51 deletions(-)

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
@@ -1879,13 +1879,9 @@ xa_unlocked:
 
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
@@ -424,37 +424,6 @@ void mark_page_accessed(struct page *pag
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
-static void __lru_cache_add(struct page *page)
-{
-	struct pagevec *pvec;
-
-	local_lock(&lru_pvecs.lock);
-	pvec = this_cpu_ptr(&lru_pvecs.lru_add);
-	get_page(page);
-	if (!pagevec_add(pvec, page) || PageCompound(page))
-		__pagevec_lru_add(pvec);
-	local_unlock(&lru_pvecs.lock);
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
@@ -466,10 +435,19 @@ EXPORT_SYMBOL(lru_cache_add_file);
  */
 void lru_cache_add(struct page *page)
 {
+	struct pagevec *pvec;
+
 	VM_BUG_ON_PAGE(PageActive(page) && PageUnevictable(page), page);
 	VM_BUG_ON_PAGE(PageLRU(page), page);
-	__lru_cache_add(page);
+
+	get_page(page);
+	local_lock(&lru_pvecs.lock);
+	pvec = this_cpu_ptr(&lru_pvecs.lru_add);
+	if (!pagevec_add(pvec, page) || PageCompound(page))
+		__pagevec_lru_add(pvec);
+	local_unlock(&lru_pvecs.lock);
 }
+EXPORT_SYMBOL(lru_cache_add);
 
 /**
  * lru_cache_add_active_or_unevictable
--- a/mm/swap_state.c~mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file
+++ a/mm/swap_state.c
@@ -442,7 +442,7 @@ struct page *__read_swap_cache_async(swp
 
 	/* Caller will initiate read into locked page */
 	SetPageWorkingset(page);
-	lru_cache_add_anon(page);
+	lru_cache_add(page);
 	*new_page_allocated = true;
 	return page;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are
