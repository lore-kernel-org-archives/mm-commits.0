From: akpm@linux-foundation.org
Subject: + thp-tail-page-refcounting-fix-5.patch added to -mm tree
Date: Thu, 01 Sep 2011 17:04:17 -0700
Message-ID: <201109020004.p8204IkI004934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932747Ab1IBAJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2011 20:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, minchan.kim@gmail.com, walken@google.com


The patch titled
     mm: thp: tail page refcounting fix
has been added to the -mm tree.  Its filename is
     thp-tail-page-refcounting-fix-5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: thp: tail page refcounting fix
From: Andrea Arcangeli <aarcange@redhat.com>

Michel while working on the working set estimation code, noticed that
calling get_page_unless_zero() on a random pfn_to_page(random_pfn) wasn't
safe, if the pfn ended up being a tail page of a transparent hugepage
under splitting by __split_huge_page_refcount().  He then found the
problem could also theoretically materialize with
page_cache_get_speculative() during the speculative radix tree lookups
that uses get_page_unless_zero() in SMP if the radix tree page is freed
and reallocated and get_user_pages is called on it before
page_cache_get_speculative has a chance to call get_page_unless_zero().

So the best way to fix the problem is to keep page_tail->_count zero at
all times.  This will guarantee that get_page_unless_zero() can never
succeed on any tail page.  page_tail->_mapcount is guaranteed zero and is
unused for all tail pages of a compound page, so we can simply account the
tail page references there and transfer them to tail_page->_count in
__split_huge_page_refcount() (in addition to the head_page->_mapcount).

While debugging this s/_count/_mapcount/ change I also noticed get_page is
called by direct-io.c on pages returned by get_user_pages.  That wasn't
entirely safe because the two atomic_inc in get_page weren't atomic.  As
opposed other get_user_page users like secondary-MMU page fault to
establish the shadow pagetables would never call any superflous get_page
after get_user_page returns.  It's safer to make get_page universally safe
for tail pages and to use get_page_foll() within follow_page (inside
get_user_pages()).  get_page_foll() is safe to do the refcounting for tail
pages without taking any locks because it is run within PT lock protected
critical sections (PT lock for pte and page_table_lock for
pmd_trans_huge).  The standard get_page() as invoked by direct-io instead
will now take the compound_lock but still only for tail pages.  The
direct-io paths are usually I/O bound and the compound_lock is per THP so
very finegrined, so there's no risk of scalability issues with it.  A
simple direct-io benchmarks with all lockdep prove locking and spinlock
debugging infrastructure enabled shows identical performance and no
overhead.  So it's worth it.  Ideally direct-io should stop calling
get_page() on pages returned by get_user_pages().  The spinlock in
get_page() is already optimized away for no-THP builds but doing
get_page() on tail pages returned by GUP is generally a rare operation and
usually only run in I/O paths.

This new refcounting on page_tail->_mapcount in addition to avoiding new
RCU critical sections will also allow the working set estimation code to
work without any further complexity associated to the tail page
refcounting with THP.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/gup.c    |    5 +-
 arch/x86/mm/gup.c        |    5 +-
 include/linux/mm.h       |   56 ++++++++++----------------
 include/linux/mm_types.h |   21 ++++++++--
 mm/huge_memory.c         |   37 ++++++++++++-----
 mm/internal.h            |   41 +++++++++++++++++++
 mm/memory.c              |    2 
 mm/swap.c                |   77 ++++++++++++++++++++++---------------
 8 files changed, 160 insertions(+), 84 deletions(-)

diff -puN arch/powerpc/mm/gup.c~thp-tail-page-refcounting-fix-5 arch/powerpc/mm/gup.c
--- a/arch/powerpc/mm/gup.c~thp-tail-page-refcounting-fix-5
+++ a/arch/powerpc/mm/gup.c
@@ -22,8 +22,9 @@ static inline void get_huge_page_tail(st
 	 * __split_huge_page_refcount() cannot run
 	 * from under us.
 	 */
-	VM_BUG_ON(atomic_read(&page->_count) < 0);
-	atomic_inc(&page->_count);
+	VM_BUG_ON(page_mapcount(page) < 0);
+	VM_BUG_ON(atomic_read(&page->_count) != 0);
+	atomic_inc(&page->_mapcount);
 }
 
 /*
diff -puN arch/x86/mm/gup.c~thp-tail-page-refcounting-fix-5 arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~thp-tail-page-refcounting-fix-5
+++ a/arch/x86/mm/gup.c
@@ -114,8 +114,9 @@ static inline void get_huge_page_tail(st
 	 * __split_huge_page_refcount() cannot run
 	 * from under us.
 	 */
-	VM_BUG_ON(atomic_read(&page->_count) < 0);
-	atomic_inc(&page->_count);
+	VM_BUG_ON(page_mapcount(page) < 0);
+	VM_BUG_ON(atomic_read(&page->_count) != 0);
+	atomic_inc(&page->_mapcount);
 }
 
 static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
diff -puN include/linux/mm.h~thp-tail-page-refcounting-fix-5 include/linux/mm.h
--- a/include/linux/mm.h~thp-tail-page-refcounting-fix-5
+++ a/include/linux/mm.h
@@ -357,36 +357,39 @@ static inline struct page *compound_head
 	return page;
 }
 
+/*
+ * The atomic page->_mapcount, starts from -1: so that transitions
+ * both from it and to it can be tracked, using atomic_inc_and_test
+ * and atomic_add_negative(-1).
+ */
+static inline void reset_page_mapcount(struct page *page)
+{
+	atomic_set(&(page)->_mapcount, -1);
+}
+
+static inline int page_mapcount(struct page *page)
+{
+	return atomic_read(&(page)->_mapcount) + 1;
+}
+
 static inline int page_count(struct page *page)
 {
 	return atomic_read(&compound_head(page)->_count);
 }
 
+extern int __get_page_tail(struct page *page);
+
 static inline void get_page(struct page *page)
 {
+	if (unlikely(PageTail(page)))
+		if (likely(__get_page_tail(page)))
+			return;
 	/*
 	 * Getting a normal page or the head of a compound page
-	 * requires to already have an elevated page->_count. Only if
-	 * we're getting a tail page, the elevated page->_count is
-	 * required only in the head page, so for tail pages the
-	 * bugcheck only verifies that the page->_count isn't
-	 * negative.
+	 * requires to already have an elevated page->_count.
 	 */
-	VM_BUG_ON(atomic_read(&page->_count) < !PageTail(page));
+	VM_BUG_ON(atomic_read(&page->_count) <= 0);
 	atomic_inc(&page->_count);
-	/*
-	 * Getting a tail page will elevate both the head and tail
-	 * page->_count(s).
-	 */
-	if (unlikely(PageTail(page))) {
-		/*
-		 * This is safe only because
-		 * __split_huge_page_refcount can't run under
-		 * get_page().
-		 */
-		VM_BUG_ON(atomic_read(&page->first_page->_count) <= 0);
-		atomic_inc(&page->first_page->_count);
-	}
 }
 
 static inline struct page *virt_to_head_page(const void *x)
@@ -805,21 +808,6 @@ static inline pgoff_t page_index(struct 
 }
 
 /*
- * The atomic page->_mapcount, like _count, starts from -1:
- * so that transitions both from it and to it can be tracked,
- * using atomic_inc_and_test and atomic_add_negative(-1).
- */
-static inline void reset_page_mapcount(struct page *page)
-{
-	atomic_set(&(page)->_mapcount, -1);
-}
-
-static inline int page_mapcount(struct page *page)
-{
-	return atomic_read(&(page)->_mapcount) + 1;
-}
-
-/*
  * Return true if this page is mapped into pagetables.
  */
 static inline int page_mapped(struct page *page)
diff -puN include/linux/mm_types.h~thp-tail-page-refcounting-fix-5 include/linux/mm_types.h
--- a/include/linux/mm_types.h~thp-tail-page-refcounting-fix-5
+++ a/include/linux/mm_types.h
@@ -62,10 +62,23 @@ struct page {
 			struct {
 
 				union {
-					atomic_t _mapcount;	/* Count of ptes mapped in mms,
-							 * to show when page is mapped
-							 * & limit reverse map searches.
-							 */
+					/*
+					 * Count of ptes mapped in
+					 * mms, to show when page is
+					 * mapped & limit reverse map
+					 * searches.
+					 *
+					 * Used also for tail pages
+					 * refcounting instead of
+					 * _count. Tail pages cannot
+					 * be mapped and keeping the
+					 * tail page _count zero at
+					 * all times guarantees
+					 * get_page_unless_zero() will
+					 * never succeed on tail
+					 * pages.
+					 */
+					atomic_t _mapcount;
 
 					struct {
 						unsigned inuse:16;
diff -puN mm/huge_memory.c~thp-tail-page-refcounting-fix-5 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-tail-page-refcounting-fix-5
+++ a/mm/huge_memory.c
@@ -989,7 +989,7 @@ struct page *follow_trans_huge_pmd(struc
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON(!PageCompound(page));
 	if (flags & FOLL_GET)
-		get_page(page);
+		get_page_foll(page);
 
 out:
 	return page;
@@ -1201,6 +1201,7 @@ static void __split_huge_page_refcount(s
 	unsigned long head_index = page->index;
 	struct zone *zone = page_zone(page);
 	int zonestat;
+	int tail_count = 0;
 
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
 	spin_lock_irq(&zone->lru_lock);
@@ -1209,11 +1210,27 @@ static void __split_huge_page_refcount(s
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		struct page *page_tail = page + i;
 
-		/* tail_page->_count cannot change */
-		atomic_sub(atomic_read(&page_tail->_count), &page->_count);
-		BUG_ON(page_count(page) <= 0);
-		atomic_add(page_mapcount(page) + 1, &page_tail->_count);
-		BUG_ON(atomic_read(&page_tail->_count) <= 0);
+		/* tail_page->_mapcount cannot change */
+		BUG_ON(page_mapcount(page_tail) < 0);
+		tail_count += page_mapcount(page_tail);
+		/* check for overflow */
+		BUG_ON(tail_count < 0);
+		BUG_ON(atomic_read(&page_tail->_count) != 0);
+		/*
+		 * tail_page->_count is zero and not changing from
+		 * under us. But get_page_unless_zero() may be running
+		 * from under us on the tail_page. If we used
+		 * atomic_set() below instead of atomic_add(), we
+		 * would then run atomic_set() concurrently with
+		 * get_page_unless_zero(), and atomic_set() is
+		 * implemented in C not using locked ops. spin_unlock
+		 * on x86 sometime uses locked ops because of PPro
+		 * errata 66, 92, so unless somebody can guarantee
+		 * atomic_set() here would be safe on all archs (and
+		 * not only on x86), it's safer to use atomic_add().
+		 */
+		atomic_add(page_mapcount(page) + page_mapcount(page_tail) + 1,
+			   &page_tail->_count);
 
 		/* after clearing PageTail the gup refcount can be released */
 		smp_mb();
@@ -1231,10 +1248,7 @@ static void __split_huge_page_refcount(s
 				      (1L << PG_uptodate)));
 		page_tail->flags |= (1L << PG_dirty);
 
-		/*
-		 * 1) clear PageTail before overwriting first_page
-		 * 2) clear PageTail before clearing PageHead for VM_BUG_ON
-		 */
+		/* clear PageTail before overwriting first_page */
 		smp_wmb();
 
 		/*
@@ -1251,7 +1265,6 @@ static void __split_huge_page_refcount(s
 		 * status is achieved setting a reserved bit in the
 		 * pmd, not by clearing the present bit.
 		*/
-		BUG_ON(page_mapcount(page_tail));
 		page_tail->_mapcount = page->_mapcount;
 
 		BUG_ON(page_tail->mapping);
@@ -1268,6 +1281,8 @@ static void __split_huge_page_refcount(s
 
 		lru_add_page_tail(zone, page, page_tail);
 	}
+	atomic_sub(tail_count, &page->_count);
+	BUG_ON(atomic_read(&page->_count) <= 0);
 
 	__dec_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
 	__mod_zone_page_state(zone, NR_ANON_PAGES, HPAGE_PMD_NR);
diff -puN mm/internal.h~thp-tail-page-refcounting-fix-5 mm/internal.h
--- a/mm/internal.h~thp-tail-page-refcounting-fix-5
+++ a/mm/internal.h
@@ -37,6 +37,47 @@ static inline void __put_page(struct pag
 	atomic_dec(&page->_count);
 }
 
+static inline void __get_page_tail_foll(struct page *page,
+					bool get_page_head)
+{
+	/*
+	 * If we're getting a tail page, the elevated page->_count is
+	 * required only in the head page and we will elevate the head
+	 * page->_count and tail page->_mapcount.
+	 *
+	 * We elevate page_tail->_mapcount for tail pages to force
+	 * page_tail->_count to be zero at all times to avoid getting
+	 * false positives from get_page_unless_zero() with
+	 * speculative page access (like in
+	 * page_cache_get_speculative()) on tail pages.
+	 */
+	VM_BUG_ON(atomic_read(&page->first_page->_count) <= 0);
+	VM_BUG_ON(atomic_read(&page->_count) != 0);
+	VM_BUG_ON(page_mapcount(page) < 0);
+	if (get_page_head)
+		atomic_inc(&page->first_page->_count);
+	atomic_inc(&page->_mapcount);
+}
+
+static inline void get_page_foll(struct page *page)
+{
+	if (unlikely(PageTail(page)))
+		/*
+		 * This is safe only because
+		 * __split_huge_page_refcount() can't run under
+		 * get_page_foll() because we hold the proper PT lock.
+		 */
+		__get_page_tail_foll(page, true);
+	else {
+		/*
+		 * Getting a normal page or the head of a compound page
+		 * requires to already have an elevated page->_count.
+		 */
+		VM_BUG_ON(atomic_read(&page->_count) <= 0);
+		atomic_inc(&page->_count);
+	}
+}
+
 extern unsigned long highest_memmap_pfn;
 
 /*
diff -puN mm/memory.c~thp-tail-page-refcounting-fix-5 mm/memory.c
--- a/mm/memory.c~thp-tail-page-refcounting-fix-5
+++ a/mm/memory.c
@@ -1503,7 +1503,7 @@ split_fallthrough:
 	}
 
 	if (flags & FOLL_GET)
-		get_page(page);
+		get_page_foll(page);
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
diff -puN mm/swap.c~thp-tail-page-refcounting-fix-5 mm/swap.c
--- a/mm/swap.c~thp-tail-page-refcounting-fix-5
+++ a/mm/swap.c
@@ -78,39 +78,21 @@ static void put_compound_page(struct pag
 {
 	if (unlikely(PageTail(page))) {
 		/* __split_huge_page_refcount can run under us */
-		struct page *page_head = page->first_page;
-		smp_rmb();
-		/*
-		 * If PageTail is still set after smp_rmb() we can be sure
-		 * that the page->first_page we read wasn't a dangling pointer.
-		 * See __split_huge_page_refcount() smp_wmb().
-		 */
-		if (likely(PageTail(page) && get_page_unless_zero(page_head))) {
+		struct page *page_head = compound_trans_head(page);
+		if (likely(page != page_head &&
+			   get_page_unless_zero(page_head))) {
 			unsigned long flags;
 			/*
-			 * Verify that our page_head wasn't converted
-			 * to a a regular page before we got a
-			 * reference on it.
+			 * page_head wasn't a dangling pointer but it
+			 * may not be a head page anymore by the time
+			 * we obtain the lock. That is ok as long as it
+			 * can't be freed from under us.
 			 */
-			if (unlikely(!PageHead(page_head))) {
-				/* PageHead is cleared after PageTail */
-				smp_rmb();
-				VM_BUG_ON(PageTail(page));
-				goto out_put_head;
-			}
-			/*
-			 * Only run compound_lock on a valid PageHead,
-			 * after having it pinned with
-			 * get_page_unless_zero() above.
-			 */
-			smp_mb();
-			/* page_head wasn't a dangling pointer */
 			flags = compound_lock_irqsave(page_head);
 			if (unlikely(!PageTail(page))) {
 				/* __split_huge_page_refcount run before us */
 				compound_unlock_irqrestore(page_head, flags);
 				VM_BUG_ON(PageHead(page_head));
-			out_put_head:
 				if (put_page_testzero(page_head))
 					__put_single_page(page_head);
 			out_put_single:
@@ -121,16 +103,17 @@ static void put_compound_page(struct pag
 			VM_BUG_ON(page_head != page->first_page);
 			/*
 			 * We can release the refcount taken by
-			 * get_page_unless_zero now that
-			 * split_huge_page_refcount is blocked on the
-			 * compound_lock.
+			 * get_page_unless_zero() now that
+			 * __split_huge_page_refcount() is blocked on
+			 * the compound_lock.
 			 */
 			if (put_page_testzero(page_head))
 				VM_BUG_ON(1);
 			/* __split_huge_page_refcount will wait now */
-			VM_BUG_ON(atomic_read(&page->_count) <= 0);
-			atomic_dec(&page->_count);
+			VM_BUG_ON(page_mapcount(page) <= 0);
+			atomic_dec(&page->_mapcount);
 			VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
+			VM_BUG_ON(atomic_read(&page->_count) != 0);
 			compound_unlock_irqrestore(page_head, flags);
 			if (put_page_testzero(page_head)) {
 				if (PageHead(page_head))
@@ -160,6 +143,40 @@ void put_page(struct page *page)
 }
 EXPORT_SYMBOL(put_page);
 
+int __get_page_tail(struct page *page)
+{
+	/*
+	 * This takes care of get_page() if run on a tail page
+	 * returned by one of the get_user_pages/follow_page variants.
+	 * get_user_pages/follow_page itself doesn't need the compound
+	 * lock because it runs __get_page_tail_foll() under the
+	 * proper PT lock that already serializes against
+	 * split_huge_page().
+	 */
+	unsigned long flags;
+	int got = 0;
+	struct page *page_head = compound_trans_head(page);
+	if (likely(page != page_head && get_page_unless_zero(page_head))) {
+		/*
+		 * page_head wasn't a dangling pointer but it
+		 * may not be a head page anymore by the time
+		 * we obtain the lock. That is ok as long as it
+		 * can't be freed from under us.
+		 */
+		flags = compound_lock_irqsave(page_head);
+		/* here __split_huge_page_refcount won't run anymore */
+		if (likely(PageTail(page))) {
+			__get_page_tail_foll(page, false);
+			got = 1;
+		}
+		compound_unlock_irqrestore(page_head, flags);
+		if (unlikely(!got))
+			put_page(page_head);
+	}
+	return got;
+}
+EXPORT_SYMBOL(__get_page_tail);
+
 /**
  * put_pages_list() - release a list of pages
  * @pages: list of pages threaded on page->lru
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix-fix.patch
thp-tail-page-refcounting-fix-5.patch

