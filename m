Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4066C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbiBPAaw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:30:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245165AbiBPAas (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:30:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E8BFA231
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:30:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C6A5B81C01
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07827C340EB;
        Wed, 16 Feb 2022 00:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644971430;
        bh=MyOmzMkEqjvyi12Y2Ed029ZixUrsYv1A8utRrgs3G/Y=;
        h=Date:To:From:Subject:From;
        b=RrqrwR+9fSUr4fqLuZPToiqSG75DKqKoDS3AaJeVenHoHXPqEpcjgOwoemFQoERop
         J+Lv6Dvkm7Kl62/SDlQgJdmu3NBwhzTbRh21gbvlnwrRGMLyJZrqotx0vb18LtH0qC
         NzSqBpW4nF5OlHG9yjhQ4qj7Q4aOSjGlBWZHmDZo=
Date:   Tue, 15 Feb 2022 16:30:29 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch added to -mm tree
Message-Id: <20220216003030.07827C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: mlock_page() munlock_page() batch by pagevec
has been added to the -mm tree.  Its filename is
     mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: mlock_page() munlock_page() batch by pagevec

A weakness of the page->mlock_count approach is the need for lruvec lock
while holding page table lock.  That is not an overhead we would allow on
normal pages, but I think acceptable just for pages in an mlocked area. 
But let's try to amortize the extra cost by gathering on per-cpu pagevec
before acquiring the lruvec lock.

I have an unverified conjecture that the mlock pagevec might work out well
for delaying the mlock processing of new file pages until they have got
off lru_cache_add()'s pagevec and on to LRU.

The initialization of page->mlock_count is subject to races and awkward: 0
or !!PageMlocked or 1?  Was it wrong even in the implementation before
this commit, which just widens the window?  I haven't gone back to think
it through.  Maybe someone can point out a better way to initialize it.

Bringing lru_cache_add_inactive_or_unevictable()'s mlock initialization
into mm/mlock.c has helped: mlock_new_page(), using the mlock pagevec,
rather than lru_cache_add()'s pagevec.

Experimented with various orderings: the right thing seems to be for
mlock_page() and mlock_new_page() to TestSetPageMlocked before adding to
pagevec, but munlock_page() to leave TestClearPageMlocked to the later
pagevec processing.

Dropped the VM_BUG_ON_PAGE(PageTail)s this time around: they have made
their point, and the thp_nr_page()s already contain a VM_BUG_ON_PGFLAGS()
for that.

This still leaves acquiring lruvec locks under page table lock each time
the pagevec fills (or a THP is added): which I suppose is rather silly,
since they sit on pagevec waiting to be processed long after page table
lock has been dropped; but I'm disinclined to uglify the calling sequence
until some load shows an actual problem with it (nothing wrong with taking
lruvec lock under page table lock, just "nicer" to do it less).

Link: https://lkml.kernel.org/r/1abb94ee-fe72-dba9-3eb0-d1e576d148e6@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    9 +-
 mm/mlock.c    |  212 ++++++++++++++++++++++++++++++++++++++++--------
 mm/swap.c     |   27 +++---
 3 files changed, 201 insertions(+), 47 deletions(-)

--- a/mm/internal.h~mm-munlock-mlock_page-munlock_page-batch-by-pagevec
+++ a/mm/internal.h
@@ -402,7 +402,8 @@ extern int mlock_future_check(struct mm_
  *
  * mlock is usually called at the end of page_add_*_rmap(),
  * munlock at the end of page_remove_rmap(); but new anon
- * pages are managed in lru_cache_add_inactive_or_unevictable().
+ * pages are managed by lru_cache_add_inactive_or_unevictable()
+ * calling mlock_new_page().
  *
  * @compound is used to include pmd mappings of THPs, but filter out
  * pte mappings of THPs, which cannot be consistently counted: a pte
@@ -425,6 +426,9 @@ static inline void munlock_vma_page(stru
 	    (compound || !PageTransCompound(page)))
 		munlock_page(page);
 }
+void mlock_new_page(struct page *page);
+bool need_mlock_page_drain(int cpu);
+void mlock_page_drain(int cpu);
 
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
@@ -503,6 +507,9 @@ static inline void mlock_vma_page(struct
 			struct vm_area_struct *vma, bool compound) { }
 static inline void munlock_vma_page(struct page *page,
 			struct vm_area_struct *vma, bool compound) { }
+static inline void mlock_new_page(struct page *page) { }
+static inline bool need_mlock_page_drain(int cpu) { return false; }
+static inline void mlock_page_drain(int cpu) { }
 static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
 {
 }
--- a/mm/mlock.c~mm-munlock-mlock_page-munlock_page-batch-by-pagevec
+++ a/mm/mlock.c
@@ -28,6 +28,8 @@
 
 #include "internal.h"
 
+static DEFINE_PER_CPU(struct pagevec, mlock_pvec);
+
 bool can_do_mlock(void)
 {
 	if (rlimit(RLIMIT_MEMLOCK) != 0)
@@ -49,57 +51,79 @@ EXPORT_SYMBOL(can_do_mlock);
  * PageUnevictable is set to indicate the unevictable state.
  */
 
-/**
- * mlock_page - mlock a page
- * @page: page to be mlocked, either a normal page or a THP head.
- */
-void mlock_page(struct page *page)
+static struct lruvec *__mlock_page(struct page *page, struct lruvec *lruvec)
 {
-	struct lruvec *lruvec;
-	int nr_pages = thp_nr_pages(page);
+	/* There is nothing more we can do while it's off LRU */
+	if (!TestClearPageLRU(page))
+		return lruvec;
 
-	VM_BUG_ON_PAGE(PageTail(page), page);
+	lruvec = folio_lruvec_relock_irq(page_folio(page), lruvec);
 
-	if (!TestSetPageMlocked(page)) {
-		mod_zone_page_state(page_zone(page), NR_MLOCK, nr_pages);
-		__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
+	if (unlikely(page_evictable(page))) {
+		/*
+		 * This is a little surprising, but quite possible:
+		 * PageMlocked must have got cleared already by another CPU.
+		 * Could this page be on the Unevictable LRU?  I'm not sure,
+		 * but move it now if so.
+		 */
+		if (PageUnevictable(page)) {
+			del_page_from_lru_list(page, lruvec);
+			ClearPageUnevictable(page);
+			add_page_to_lru_list(page, lruvec);
+			__count_vm_events(UNEVICTABLE_PGRESCUED,
+					  thp_nr_pages(page));
+		}
+		goto out;
 	}
 
-	/* There is nothing more we can do while it's off LRU */
-	if (!TestClearPageLRU(page))
-		return;
-
-	lruvec = folio_lruvec_lock_irq(page_folio(page));
 	if (PageUnevictable(page)) {
-		page->mlock_count++;
+		if (PageMlocked(page))
+			page->mlock_count++;
 		goto out;
 	}
 
 	del_page_from_lru_list(page, lruvec);
 	ClearPageActive(page);
 	SetPageUnevictable(page);
-	page->mlock_count = 1;
+	page->mlock_count = !!PageMlocked(page);
 	add_page_to_lru_list(page, lruvec);
-	__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
+	__count_vm_events(UNEVICTABLE_PGCULLED, thp_nr_pages(page));
 out:
 	SetPageLRU(page);
-	unlock_page_lruvec_irq(lruvec);
+	return lruvec;
 }
 
-/**
- * munlock_page - munlock a page
- * @page: page to be munlocked, either a normal page or a THP head.
- */
-void munlock_page(struct page *page)
+static struct lruvec *__mlock_new_page(struct page *page, struct lruvec *lruvec)
+{
+	VM_BUG_ON_PAGE(PageLRU(page), page);
+
+	lruvec = folio_lruvec_relock_irq(page_folio(page), lruvec);
+
+	/* As above, this is a little surprising, but possible */
+	if (unlikely(page_evictable(page)))
+		goto out;
+
+	SetPageUnevictable(page);
+	page->mlock_count = !!PageMlocked(page);
+	__count_vm_events(UNEVICTABLE_PGCULLED, thp_nr_pages(page));
+out:
+	add_page_to_lru_list(page, lruvec);
+	SetPageLRU(page);
+	return lruvec;
+}
+
+static struct lruvec *__munlock_page(struct page *page, struct lruvec *lruvec)
 {
-	struct lruvec *lruvec;
 	int nr_pages = thp_nr_pages(page);
+	bool isolated = false;
 
-	VM_BUG_ON_PAGE(PageTail(page), page);
+	if (!TestClearPageLRU(page))
+		goto munlock;
 
-	lock_page_memcg(page);
-	lruvec = folio_lruvec_lock_irq(page_folio(page));
-	if (PageLRU(page) && PageUnevictable(page)) {
+	isolated = true;
+	lruvec = folio_lruvec_relock_irq(page_folio(page), lruvec);
+
+	if (PageUnevictable(page)) {
 		/* Then mlock_count is maintained, but might undercount */
 		if (page->mlock_count)
 			page->mlock_count--;
@@ -108,24 +132,144 @@ void munlock_page(struct page *page)
 	}
 	/* else assume that was the last mlock: reclaim will fix it if not */
 
+munlock:
 	if (TestClearPageMlocked(page)) {
 		__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
-		if (PageLRU(page) || !PageUnevictable(page))
+		if (isolated || !PageUnevictable(page))
 			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
 		else
 			__count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
 	}
 
 	/* page_evictable() has to be checked *after* clearing Mlocked */
-	if (PageLRU(page) && PageUnevictable(page) && page_evictable(page)) {
+	if (isolated && PageUnevictable(page) && page_evictable(page)) {
 		del_page_from_lru_list(page, lruvec);
 		ClearPageUnevictable(page);
 		add_page_to_lru_list(page, lruvec);
 		__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
 	}
 out:
-	unlock_page_lruvec_irq(lruvec);
-	unlock_page_memcg(page);
+	if (isolated)
+		SetPageLRU(page);
+	return lruvec;
+}
+
+/*
+ * Flags held in the low bits of a struct page pointer on the mlock_pvec.
+ */
+#define LRU_PAGE 0x1
+#define NEW_PAGE 0x2
+#define mlock_lru(page) ((struct page *)((unsigned long)page + LRU_PAGE))
+#define mlock_new(page) ((struct page *)((unsigned long)page + NEW_PAGE))
+
+/*
+ * mlock_pagevec() is derived from pagevec_lru_move_fn():
+ * perhaps that can make use of such page pointer flags in future,
+ * but for now just keep it for mlock.  We could use three separate
+ * pagevecs instead, but one feels better (munlocking a full pagevec
+ * does not need to drain mlocking pagevecs first).
+ */
+static void mlock_pagevec(struct pagevec *pvec)
+{
+	struct lruvec *lruvec = NULL;
+	unsigned long mlock;
+	struct page *page;
+	int i;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		page = pvec->pages[i];
+		mlock = (unsigned long)page & (LRU_PAGE | NEW_PAGE);
+		page = (struct page *)((unsigned long)page - mlock);
+		pvec->pages[i] = page;
+
+		if (mlock & LRU_PAGE)
+			lruvec = __mlock_page(page, lruvec);
+		else if (mlock & NEW_PAGE)
+			lruvec = __mlock_new_page(page, lruvec);
+		else
+			lruvec = __munlock_page(page, lruvec);
+	}
+
+	if (lruvec)
+		unlock_page_lruvec_irq(lruvec);
+	release_pages(pvec->pages, pvec->nr);
+	pagevec_reinit(pvec);
+}
+
+void mlock_page_drain(int cpu)
+{
+	struct pagevec *pvec;
+
+	pvec = &per_cpu(mlock_pvec, cpu);
+	if (pagevec_count(pvec))
+		mlock_pagevec(pvec);
+}
+
+bool need_mlock_page_drain(int cpu)
+{
+	return pagevec_count(&per_cpu(mlock_pvec, cpu));
+}
+
+/**
+ * mlock_page - mlock a page already on (or temporarily off) LRU
+ * @page: page to be mlocked, either a normal page or a THP head.
+ */
+void mlock_page(struct page *page)
+{
+	struct pagevec *pvec = &get_cpu_var(mlock_pvec);
+
+	if (!TestSetPageMlocked(page)) {
+		int nr_pages = thp_nr_pages(page);
+
+		mod_zone_page_state(page_zone(page), NR_MLOCK, nr_pages);
+		__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
+	}
+
+	get_page(page);
+	if (!pagevec_add(pvec, mlock_lru(page)) ||
+	    PageHead(page) || lru_cache_disabled())
+		mlock_pagevec(pvec);
+	put_cpu_var(mlock_pvec);
+}
+
+/**
+ * mlock_new_page - mlock a newly allocated page not yet on LRU
+ * @page: page to be mlocked, either a normal page or a THP head.
+ */
+void mlock_new_page(struct page *page)
+{
+	struct pagevec *pvec = &get_cpu_var(mlock_pvec);
+	int nr_pages = thp_nr_pages(page);
+
+	SetPageMlocked(page);
+	mod_zone_page_state(page_zone(page), NR_MLOCK, nr_pages);
+	__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
+
+	get_page(page);
+	if (!pagevec_add(pvec, mlock_new(page)) ||
+	    PageHead(page) || lru_cache_disabled())
+		mlock_pagevec(pvec);
+	put_cpu_var(mlock_pvec);
+}
+
+/**
+ * munlock_page - munlock a page
+ * @page: page to be munlocked, either a normal page or a THP head.
+ */
+void munlock_page(struct page *page)
+{
+	struct pagevec *pvec = &get_cpu_var(mlock_pvec);
+
+	/*
+	 * TestClearPageMlocked(page) must be left to __munlock_page(),
+	 * which will check whether the page is multiply mlocked.
+	 */
+
+	get_page(page);
+	if (!pagevec_add(pvec, page) ||
+	    PageHead(page) || lru_cache_disabled())
+		mlock_pagevec(pvec);
+	put_cpu_var(mlock_pvec);
 }
 
 static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
--- a/mm/swap.c~mm-munlock-mlock_page-munlock_page-batch-by-pagevec
+++ a/mm/swap.c
@@ -490,18 +490,12 @@ EXPORT_SYMBOL(folio_add_lru);
 void lru_cache_add_inactive_or_unevictable(struct page *page,
 					 struct vm_area_struct *vma)
 {
-	bool unevictable;
-
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
-	unevictable = (vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED;
-	if (unlikely(unevictable) && !TestSetPageMlocked(page)) {
-		int nr_pages = thp_nr_pages(page);
-
-		mod_zone_page_state(page_zone(page), NR_MLOCK, nr_pages);
-		count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
-	}
-	lru_cache_add(page);
+	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
+		mlock_new_page(page);
+	else
+		lru_cache_add(page);
 }
 
 /*
@@ -640,6 +634,7 @@ void lru_add_drain_cpu(int cpu)
 		pagevec_lru_move_fn(pvec, lru_lazyfree_fn);
 
 	activate_page_drain(cpu);
+	mlock_page_drain(cpu);
 }
 
 /**
@@ -842,6 +837,7 @@ inline void __lru_add_drain_all(bool for
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_lazyfree, cpu)) ||
 		    need_activate_page_drain(cpu) ||
+		    need_mlock_page_drain(cpu) ||
 		    has_bh_in_lru(cpu, NULL)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
 			queue_work_on(cpu, mm_percpu_wq, work);
@@ -1030,7 +1026,7 @@ static void __pagevec_lru_add_fn(struct
 	 * Is an smp_mb__after_atomic() still required here, before
 	 * folio_evictable() tests PageMlocked, to rule out the possibility
 	 * of stranding an evictable folio on an unevictable LRU?  I think
-	 * not, because munlock_page() only clears PageMlocked while the LRU
+	 * not, because __munlock_page() only clears PageMlocked while the LRU
 	 * lock is held.
 	 *
 	 * (That is not true of __page_cache_release(), and not necessarily
@@ -1043,7 +1039,14 @@ static void __pagevec_lru_add_fn(struct
 	} else {
 		folio_clear_active(folio);
 		folio_set_unevictable(folio);
-		folio->mlock_count = !!folio_test_mlocked(folio);
+		/*
+		 * folio->mlock_count = !!folio_test_mlocked(folio)?
+		 * But that leaves __mlock_page() in doubt whether another
+		 * actor has already counted the mlock or not.  Err on the
+		 * safe side, underestimate, let page reclaim fix it, rather
+		 * than leaving a page on the unevictable LRU indefinitely.
+		 */
+		folio->mlock_count = 0;
 		if (!was_unevictable)
 			__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
 	}
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

