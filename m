From: akpm@linux-foundation.org
Subject: + huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 16:16:03 -0700
Message-ID: <57044733.5ZV21pXgyfjQs32P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbcDEXQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: fix Mlocked meminfo, track huge & unhuge mlocks
has been added to the -mm tree.  Its filename is
     huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: fix Mlocked meminfo, track huge & unhuge mlocks

Up to this point, the huge tmpfs effort has barely looked at or touched
mm/mlock.c at all: just a PageTeam test to stop __munlock_pagevec_fill()
crashing (or hanging on a non-existent spinlock) on hugepage pmds.

/proc/meminfo's Mlocked count has been whatever happens to be shown if we
do nothing extra: a hugely mapped and mlocked team page would count as 4kB
instead of the 2MB you'd expect; or at least until the previous
(Unevictable) patch, which now requires lruvec locking for
hpage_nr_pages() on a team page (locking not given it in mlock.c), and
varies the amount returned by hpage_nr_pages().

It would be easy to correct the 4kB or variable amount to 2MB by using an
alternative to hpage_nr_pages() here.  And it would be fairly easy to
maintain an entirely independent PmdMlocked count, such that
Mlocked+PmdMlocked might amount to (almost) twice RAM size.  But is that
what observers of Mlocked want?  Probably not.

So we need a huge pmd mlock to count as 2MB, but discount 4kB for each
page within it that is already mlocked by pte somewhere, in this or
another process; and a small pte mlock to count usually as 4kB, but 0 if
the team head is already mlocked by pmd somewhere.

Can this be done by maintaining extra counts per team?  I did intend so,
but (a) space in team_usage is limited, and (b) mlock and munlock already
involve slow LRU switching, so might as well keep 4kB and 2MB in synch
manually; but most significantly (c): the trylocking around which mlock
was designed, makes it hard to work out just when a count does need to be
incremented.

The hard-won solution looks much simpler than I thought possible, but an
odd interface in its current implementation.  Not so much needed changing,
mainly just clear_page_mlock(), mlock_vma_page() munlock_vma_page() and
try_to_"unmap"_one().  The big difference from before, is that a team head
page might be being mlocked as a 4kB page or as a 2MB page, and the called
functions cannot tell: so now need an nr_pages argument.  But odd because
the PageTeam case immediately converts that to an iteration count, whereas
the anon THP case keeps it as the weight for a single iteration (and in
the munlock case has to reconfirm it under lruvec lock).  Not very nice,
but will do for now: it was so hard to get here, I'm very reluctant to
pull it apart in a hurry.

The TEAM_PMD_MLOCKED flag in team_usage does not play a large part, just
optimizes out the overhead in a couple of cases: we don't want to make yet
another pass down the team, whenever a team is last unmapped, just to
handle the unlikely mlocked-then-truncated case; and we don't want
munlocking one of many parallel huge mlocks to check every page.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageteam.h |   38 +++++++
 mm/huge_memory.c         |   15 ++-
 mm/internal.h            |   26 +++--
 mm/mlock.c               |  181 +++++++++++++++++++++----------------
 mm/rmap.c                |   44 +++++---
 5 files changed, 196 insertions(+), 108 deletions(-)

diff -puN include/linux/pageteam.h~huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks include/linux/pageteam.h
--- a/include/linux/pageteam.h~huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks
+++ a/include/linux/pageteam.h
@@ -36,8 +36,14 @@ static inline struct page *team_head(str
  */
 #define TEAM_LRU_WEIGHT_ONE	1L
 #define TEAM_LRU_WEIGHT_MASK	((1L << (HPAGE_PMD_ORDER + 1)) - 1)
+/*
+ * Single bit to indicate whether team is hugely mlocked (like PageMlocked).
+ * Then another bit reserved for experiments with other team flags.
+ */
+#define TEAM_PMD_MLOCKED	(1L << (HPAGE_PMD_ORDER + 1))
+#define TEAM_RESERVED_FLAG	(1L << (HPAGE_PMD_ORDER + 2))
 
-#define TEAM_HIGH_COUNTER	(1L << (HPAGE_PMD_ORDER + 1))
+#define TEAM_HIGH_COUNTER	(1L << (HPAGE_PMD_ORDER + 3))
 /*
  * Count how many pages of team are instantiated, as it is built up.
  */
@@ -97,6 +103,36 @@ static inline void clear_lru_weight(stru
 	atomic_long_set(&page->team_usage, 0);
 }
 
+static inline bool team_pmd_mlocked(struct page *head)
+{
+	VM_BUG_ON_PAGE(head != team_head(head), head);
+	return atomic_long_read(&head->team_usage) & TEAM_PMD_MLOCKED;
+}
+
+static inline void set_team_pmd_mlocked(struct page *head)
+{
+	long team_usage;
+
+	VM_BUG_ON_PAGE(head != team_head(head), head);
+	team_usage = atomic_long_read(&head->team_usage);
+	while (!(team_usage & TEAM_PMD_MLOCKED)) {
+		team_usage = atomic_long_cmpxchg(&head->team_usage,
+				team_usage, team_usage | TEAM_PMD_MLOCKED);
+	}
+}
+
+static inline void clear_team_pmd_mlocked(struct page *head)
+{
+	long team_usage;
+
+	VM_BUG_ON_PAGE(head != team_head(head), head);
+	team_usage = atomic_long_read(&head->team_usage);
+	while (team_usage & TEAM_PMD_MLOCKED) {
+		team_usage = atomic_long_cmpxchg(&head->team_usage,
+				team_usage, team_usage & ~TEAM_PMD_MLOCKED);
+	}
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 int map_team_by_pmd(struct vm_area_struct *vma,
 			unsigned long addr, pmd_t *pmd, struct page *page);
diff -puN mm/huge_memory.c~huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks mm/huge_memory.c
--- a/mm/huge_memory.c~huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks
+++ a/mm/huge_memory.c
@@ -1443,8 +1443,8 @@ struct page *follow_trans_huge_pmd(struc
 		touch_pmd(vma, addr, pmd);
 	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		/*
-		 * We don't mlock() pte-mapped THPs. This way we can avoid
-		 * leaking mlocked pages into non-VM_LOCKED VMAs.
+		 * We don't mlock() pte-mapped compound THPs. This way we
+		 * can avoid leaking mlocked pages into non-VM_LOCKED VMAs.
 		 *
 		 * In most cases the pmd is the only mapping of the page as we
 		 * break COW for the mlock() -- see gup_flags |= FOLL_WRITE for
@@ -1453,12 +1453,16 @@ struct page *follow_trans_huge_pmd(struc
 		 * The only scenario when we have the page shared here is if we
 		 * mlocking read-only mapping shared over fork(). We skip
 		 * mlocking such pages.
+		 *
+		 * But the huge tmpfs PageTeam case is handled differently:
+		 * there are no arbitrary restrictions on mlocking such pages,
+		 * and compound_mapcount() returns 0 even when they are mapped.
 		 */
-		if (compound_mapcount(page) == 1 && !PageDoubleMap(page) &&
+		if (compound_mapcount(page) <= 1 && !PageDoubleMap(page) &&
 				page->mapping && trylock_page(page)) {
 			lru_add_drain();
 			if (page->mapping)
-				mlock_vma_page(page);
+				mlock_vma_pages(page, HPAGE_PMD_NR);
 			unlock_page(page);
 		}
 	}
@@ -1710,6 +1714,9 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		pte_free(tlb->mm, pgtable_trans_huge_withdraw(tlb->mm, pmd));
 		atomic_long_dec(&tlb->mm->nr_ptes);
 		spin_unlock(ptl);
+		if (PageTeam(page) &&
+		    !team_pmd_mapped(page) && team_pmd_mlocked(page))
+			clear_pages_mlock(page, HPAGE_PMD_NR);
 		tlb_remove_page(tlb, page);
 	}
 	return 1;
diff -puN mm/internal.h~huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks mm/internal.h
--- a/mm/internal.h~huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks
+++ a/mm/internal.h
@@ -280,8 +280,16 @@ static inline void munlock_vma_pages_all
 /*
  * must be called with vma's mmap_sem held for read or write, and page locked.
  */
-extern void mlock_vma_page(struct page *page);
-extern unsigned int munlock_vma_page(struct page *page);
+extern void mlock_vma_pages(struct page *page, int nr_pages);
+static inline void mlock_vma_page(struct page *page)
+{
+	mlock_vma_pages(page, 1);
+}
+extern int munlock_vma_pages(struct page *page, int nr_pages);
+static inline void munlock_vma_page(struct page *page)
+{
+	munlock_vma_pages(page, 1);
+}
 
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
@@ -292,7 +300,11 @@ extern unsigned int munlock_vma_page(str
  * If called for a page that is still mapped by mlocked vmas, all we do
  * is revert to lazy LRU behaviour -- semantics are not broken.
  */
-extern void clear_page_mlock(struct page *page);
+extern void clear_pages_mlock(struct page *page, int nr_pages);
+static inline void clear_page_mlock(struct page *page)
+{
+	clear_pages_mlock(page, 1);
+}
 
 /*
  * mlock_migrate_page - called only from migrate_misplaced_transhuge_page()
@@ -333,13 +345,7 @@ vma_address(struct page *page, struct vm
 
 	return address;
 }
-
-#else /* !CONFIG_MMU */
-static inline void clear_page_mlock(struct page *page) { }
-static inline void mlock_vma_page(struct page *page) { }
-static inline void mlock_migrate_page(struct page *new, struct page *old) { }
-
-#endif /* !CONFIG_MMU */
+#endif /* CONFIG_MMU */
 
 /*
  * Return the mem_map entry representing the 'offset' subpage within
diff -puN mm/mlock.c~huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks mm/mlock.c
--- a/mm/mlock.c~huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks
+++ a/mm/mlock.c
@@ -11,6 +11,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/pagemap.h>
+#include <linux/pageteam.h>
 #include <linux/pagevec.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
@@ -51,43 +52,72 @@ EXPORT_SYMBOL(can_do_mlock);
  * (see mm/rmap.c).
  */
 
-/*
- *  LRU accounting for clear_page_mlock()
+/**
+ * clear_pages_mlock - clear mlock from a page or pages
+ * @page - page to be unlocked
+ * @nr_pages - usually 1, but HPAGE_PMD_NR if pmd mapping is zapped.
+ *
+ * Clear the page's PageMlocked().  This can be useful in a situation where
+ * we want to unconditionally remove a page from the pagecache -- e.g.,
+ * on truncation or freeing.
+ *
+ * It is legal to call this function for any page, mlocked or not.
+ * If called for a page that is still mapped by mlocked vmas, all we do
+ * is revert to lazy LRU behaviour -- semantics are not broken.
  */
-void clear_page_mlock(struct page *page)
+void clear_pages_mlock(struct page *page, int nr_pages)
 {
-	if (!TestClearPageMlocked(page))
-		return;
+	struct zone *zone = page_zone(page);
+	struct page *endpage = page + 1;
 
-	mod_zone_page_state(page_zone(page), NR_MLOCK,
-			    -hpage_nr_pages(page));
-	count_vm_event(UNEVICTABLE_PGCLEARED);
-	if (!isolate_lru_page(page)) {
-		putback_lru_page(page);
-	} else {
-		/*
-		 * We lost the race. the page already moved to evictable list.
-		 */
-		if (PageUnevictable(page))
+	if (nr_pages > 1 && PageTeam(page)) {
+		clear_team_pmd_mlocked(page);	/* page is team head */
+		endpage = page + nr_pages;
+		nr_pages = 1;
+	}
+
+	for (; page < endpage; page++) {
+		if (page_mapped(page))
+			continue;
+		if (!TestClearPageMlocked(page))
+			continue;
+		mod_zone_page_state(zone, NR_MLOCK, -nr_pages);
+		count_vm_event(UNEVICTABLE_PGCLEARED);
+		if (!isolate_lru_page(page))
+			putback_lru_page(page);
+		else if (PageUnevictable(page))
 			count_vm_event(UNEVICTABLE_PGSTRANDED);
 	}
 }
 
-/*
- * Mark page as mlocked if not already.
+/**
+ * mlock_vma_pages - mlock a vma page or pages
+ * @page - page to be unlocked
+ * @nr_pages - usually 1, but HPAGE_PMD_NR if pmd mapping is mlocked.
+ *
+ * Mark pages as mlocked if not already.
  * If page on LRU, isolate and putback to move to unevictable list.
  */
-void mlock_vma_page(struct page *page)
+void mlock_vma_pages(struct page *page, int nr_pages)
 {
-	/* Serialize with page migration */
-	BUG_ON(!PageLocked(page));
+	struct zone *zone = page_zone(page);
+	struct page *endpage = page + 1;
 
+	/* Serialize with page migration */
+	VM_BUG_ON_PAGE(!PageLocked(page) && !PageTeam(page), page);
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	VM_BUG_ON_PAGE(PageCompound(page) && PageDoubleMap(page), page);
 
-	if (!TestSetPageMlocked(page)) {
-		mod_zone_page_state(page_zone(page), NR_MLOCK,
-				    hpage_nr_pages(page));
+	if (nr_pages > 1 && PageTeam(page)) {
+		set_team_pmd_mlocked(page);	/* page is team head */
+		endpage = page + nr_pages;
+		nr_pages = 1;
+	}
+
+	for (; page < endpage; page++) {
+		if (TestSetPageMlocked(page))
+			continue;
+		mod_zone_page_state(zone, NR_MLOCK, nr_pages);
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
@@ -111,6 +141,18 @@ static bool __munlock_isolate_lru_page(s
 		return true;
 	}
 
+	/*
+	 * Perform accounting when page isolation fails in munlock.
+	 * There is nothing else to do because it means some other task has
+	 * already removed the page from the LRU. putback_lru_page() will take
+	 * care of removing the page from the unevictable list, if necessary.
+	 * vmscan [page_referenced()] will move the page back to the
+	 * unevictable list if some other vma has it mlocked.
+	 */
+	if (PageUnevictable(page))
+		__count_vm_event(UNEVICTABLE_PGSTRANDED);
+	else
+		__count_vm_event(UNEVICTABLE_PGMUNLOCKED);
 	return false;
 }
 
@@ -128,7 +170,7 @@ static void __munlock_isolated_page(stru
 	 * Optimization: if the page was mapped just once, that's our mapping
 	 * and we don't need to check all the other vmas.
 	 */
-	if (page_mapcount(page) > 1)
+	if (page_mapcount(page) > 1 || PageTeam(page))
 		ret = try_to_munlock(page);
 
 	/* Did try_to_unlock() succeed or punt? */
@@ -138,29 +180,12 @@ static void __munlock_isolated_page(stru
 	putback_lru_page(page);
 }
 
-/*
- * Accounting for page isolation fail during munlock
- *
- * Performs accounting when page isolation fails in munlock. There is nothing
- * else to do because it means some other task has already removed the page
- * from the LRU. putback_lru_page() will take care of removing the page from
- * the unevictable list, if necessary. vmscan [page_referenced()] will move
- * the page back to the unevictable list if some other vma has it mlocked.
- */
-static void __munlock_isolation_failed(struct page *page)
-{
-	if (PageUnevictable(page))
-		__count_vm_event(UNEVICTABLE_PGSTRANDED);
-	else
-		__count_vm_event(UNEVICTABLE_PGMUNLOCKED);
-}
-
 /**
- * munlock_vma_page - munlock a vma page
- * @page - page to be unlocked, either a normal page or THP page head
+ * munlock_vma_pages - munlock a vma page or pages
+ * @page - page to be unlocked
+ * @nr_pages - usually 1, but HPAGE_PMD_NR if pmd mapping is munlocked
  *
- * returns the size of the page as a page mask (0 for normal page,
- *         HPAGE_PMD_NR - 1 for THP head page)
+ * returns the size of the page (usually 1, but HPAGE_PMD_NR for huge page)
  *
  * called from munlock()/munmap() path with page supposedly on the LRU.
  * When we munlock a page, because the vma where we found the page is being
@@ -173,41 +198,56 @@ static void __munlock_isolation_failed(s
  * can't isolate the page, we leave it for putback_lru_page() and vmscan
  * [page_referenced()/try_to_unmap()] to deal with.
  */
-unsigned int munlock_vma_page(struct page *page)
+int munlock_vma_pages(struct page *page, int nr_pages)
 {
-	int nr_pages;
 	struct zone *zone = page_zone(page);
+	struct page *endpage = page + 1;
+	struct page *head = NULL;
+	int ret = nr_pages;
+	bool isolated;
 
 	/* For try_to_munlock() and to serialize with page migration */
-	BUG_ON(!PageLocked(page));
-
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
+	if (nr_pages > 1 && PageTeam(page)) {
+		head = page;
+		clear_team_pmd_mlocked(page);	/* page is team head */
+		endpage = page + nr_pages;
+		nr_pages = 1;
+	}
+
 	/*
-	 * Serialize with any parallel __split_huge_page_refcount() which
-	 * might otherwise copy PageMlocked to part of the tail pages before
-	 * we clear it in the head page. It also stabilizes hpage_nr_pages().
+	 * Serialize THP with any parallel __split_huge_page_tail() which
+	 * might otherwise copy PageMlocked to some of the tail pages before
+	 * we clear it in the head page.
 	 */
 	spin_lock_irq(&zone->lru_lock);
+	if (nr_pages > 1 && !PageTransHuge(page))
+		ret = nr_pages = 1;
 
-	nr_pages = hpage_nr_pages(page);
-	if (!TestClearPageMlocked(page))
-		goto unlock_out;
+	for (; page < endpage; page++) {
+		if (!TestClearPageMlocked(page))
+			continue;
 
-	__mod_zone_page_state(zone, NR_MLOCK, -nr_pages);
-
-	if (__munlock_isolate_lru_page(page, true)) {
+		__mod_zone_page_state(zone, NR_MLOCK, -nr_pages);
+		isolated = __munlock_isolate_lru_page(page, true);
 		spin_unlock_irq(&zone->lru_lock);
-		__munlock_isolated_page(page);
-		goto out;
-	}
-	__munlock_isolation_failed(page);
+		if (isolated)
+			__munlock_isolated_page(page);
 
-unlock_out:
+		/*
+		 * If try_to_munlock() found the huge page to be still
+		 * mlocked, don't waste more time munlocking and rmap
+		 * walking and re-mlocking each of the team's pages.
+		 */
+		if (!head || team_pmd_mlocked(head))
+			goto out;
+		spin_lock_irq(&zone->lru_lock);
+	}
 	spin_unlock_irq(&zone->lru_lock);
-
 out:
-	return nr_pages - 1;
+	return ret;
 }
 
 /*
@@ -300,8 +340,6 @@ static void __munlock_pagevec(struct pag
 			 */
 			if (__munlock_isolate_lru_page(page, false))
 				continue;
-			else
-				__munlock_isolation_failed(page);
 		}
 
 		/*
@@ -461,13 +499,8 @@ void munlock_vma_pages_range(struct vm_a
 				put_page(page); /* follow_page_mask() */
 			} else if (PageTransHuge(page) || PageTeam(page)) {
 				lock_page(page);
-				/*
-				 * Any THP page found by follow_page_mask() may
-				 * have gotten split before reaching
-				 * munlock_vma_page(), so we need to recompute
-				 * the page_mask here.
-				 */
-				page_mask = munlock_vma_page(page);
+				page_mask = munlock_vma_pages(page,
+							page_mask + 1) - 1;
 				unlock_page(page);
 				put_page(page); /* follow_page_mask() */
 			} else {
diff -puN mm/rmap.c~huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks mm/rmap.c
--- a/mm/rmap.c~huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks
+++ a/mm/rmap.c
@@ -837,10 +837,15 @@ again:
 			spin_unlock(ptl);
 			goto again;
 		}
-		pte = NULL;
+		if (ptep)
+			*ptep = NULL;
 		goto found;
 	}
 
+	/* TTU_MUNLOCK on PageTeam makes a second try for huge pmd only */
+	if (unlikely(!ptep))
+		return false;
+
 	pte = pte_offset_map(pmd, address);
 	if (!pte_present(*pte)) {
 		pte_unmap(pte);
@@ -861,8 +866,9 @@ check_pte:
 		pte_unmap_unlock(pte, ptl);
 		return false;
 	}
-found:
+
 	*ptep = pte;
+found:
 	*pmdp = pmd;
 	*ptlp = ptl;
 	return true;
@@ -1332,7 +1338,7 @@ static void page_remove_anon_compound_rm
 	}
 
 	if (unlikely(PageMlocked(page)))
-		clear_page_mlock(page);
+		clear_pages_mlock(page, HPAGE_PMD_NR);
 
 	if (nr) {
 		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES, -nr);
@@ -1418,8 +1424,17 @@ static int try_to_unmap_one(struct page
 			goto out;
 	}
 
-	if (!page_check_address_transhuge(page, mm, address, &pmd, &pte, &ptl))
-		goto out;
+	if (!page_check_address_transhuge(page, mm, address,
+							&pmd, &pte, &ptl)) {
+		if (!(flags & TTU_MUNLOCK) || !PageTeam(page))
+			goto out;
+		/* We need also to check whether head is hugely mapped here */
+		pte = NULL;
+		page = team_head(page);
+		if (!page_check_address_transhuge(page, mm, address,
+							&pmd, NULL, &ptl))
+			goto out;
+	}
 
 	/*
 	 * If the page is mlock()d, we cannot swap it out.
@@ -1429,7 +1444,7 @@ static int try_to_unmap_one(struct page
 	if (!(flags & TTU_IGNORE_MLOCK)) {
 		if (vma->vm_flags & VM_LOCKED) {
 			/* Holding pte lock, we do *not* need mmap_sem here */
-			mlock_vma_page(page);
+			mlock_vma_pages(page, pte ? 1 : HPAGE_PMD_NR);
 			ret = SWAP_MLOCK;
 			goto out_unmap;
 		}
@@ -1635,11 +1650,6 @@ int try_to_unmap(struct page *page, enum
 	return ret;
 }
 
-static int page_not_mapped(struct page *page)
-{
-	return !page_mapped(page);
-};
-
 /**
  * try_to_munlock - try to munlock a page
  * @page: the page to be munlocked
@@ -1657,24 +1667,20 @@ static int page_not_mapped(struct page *
  */
 int try_to_munlock(struct page *page)
 {
-	int ret;
 	struct rmap_private rp = {
 		.flags = TTU_MUNLOCK,
 		.lazyfreed = 0,
 	};
-
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
 		.arg = &rp,
-		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
-
 	};
 
-	VM_BUG_ON_PAGE(!PageLocked(page) || PageLRU(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(page) && !PageTeam(page), page);
+	VM_BUG_ON_PAGE(PageLRU(page), page);
 
-	ret = rmap_walk(page, &rwc);
-	return ret;
+	return rmap_walk(page, &rwc);
 }
 
 void __put_anon_vma(struct anon_vma *anon_vma)
@@ -1789,7 +1795,7 @@ static int rmap_walk_file(struct page *p
 	 * structure at mapping cannot be freed and reused yet,
 	 * so we can safely take mapping->i_mmap_rwsem.
 	 */
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(!PageLocked(page) && !PageTeam(page), page);
 
 	if (!mapping)
 		return ret;
_

Patches currently in -mm which might be from hughd@google.com are

mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m.patch
huge-tmpfs-include-shmem-freeholes-in-available-memory.patch
huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge.patch
huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team.patch
huge-tmpfs-avoid-team-pages-in-a-few-places.patch
huge-tmpfs-shrinker-to-migrate-and-free-underused-holes.patch
huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page.patch
huge-tmpfs-try_to_unmap_one-use-page_check_address_transhuge.patch
huge-tmpfs-avoid-premature-exposure-of-new-pagetable.patch
huge-tmpfs-map-shmem-by-huge-page-pmd-or-by-page-team-ptes.patch
huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure.patch
huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd.patch
huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch
huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch
huge-tmpfs-recovery-framework-for-reconstituting-huge-pages.patch
huge-tmpfs-recovery-shmem_recovery_populate-to-fill-huge-page.patch
huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch
huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask.patch

