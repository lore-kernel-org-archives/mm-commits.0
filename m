From: akpm@linux-foundation.org
Subject: + mm-use-refcounts-for-page_lock_anon_vma.patch added to -mm tree
Date: Tue, 19 Apr 2011 13:10:48 -0700
Message-ID: <201104192010.p3JKAmPP020525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544Ab1DSUMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 16:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linux-sh.org, mel@csn.ul.ie, namhyung@gmail.com, npiggin@kernel.dk, richard@nod.at, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, tony.luck@intel.com


The patch titled
     mm: use refcounts for page_lock_anon_vma()
has been added to the -mm tree.  Its filename is
     mm-use-refcounts-for-page_lock_anon_vma.patch

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
Subject: mm: use refcounts for page_lock_anon_vma()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Convert page_lock_anon_vma() over to use refcounts.  This is done to
prepare for the conversion of anon_vma from spinlock to mutex.

Sadly this inceases the cost of page_lock_anon_vma() from one to two
atomics, a follow up patch addresses this, lets keep that simple for now.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   17 ++++-------------
 mm/rmap.c    |   42 +++++++++++++++++++++++++++---------------
 2 files changed, 31 insertions(+), 28 deletions(-)

diff -puN mm/migrate.c~mm-use-refcounts-for-page_lock_anon_vma mm/migrate.c
--- a/mm/migrate.c~mm-use-refcounts-for-page_lock_anon_vma
+++ a/mm/migrate.c
@@ -721,15 +721,11 @@ static int unmap_and_move(new_page_t get
 		 * Only page_lock_anon_vma() understands the subtleties of
 		 * getting a hold on an anon_vma from outside one of its mms.
 		 */
-		anon_vma = page_lock_anon_vma(page);
+		anon_vma = page_get_anon_vma(page);
 		if (anon_vma) {
 			/*
-			 * Take a reference count on the anon_vma if the
-			 * page is mapped so that it is guaranteed to
-			 * exist when the page is remapped later
+			 * Anon page
 			 */
-			get_anon_vma(anon_vma);
-			page_unlock_anon_vma(anon_vma);
 		} else if (PageSwapCache(page)) {
 			/*
 			 * We cannot be sure that the anon_vma of an unmapped
@@ -857,13 +853,8 @@ static int unmap_and_move_huge_page(new_
 		lock_page(hpage);
 	}
 
-	if (PageAnon(hpage)) {
-		anon_vma = page_lock_anon_vma(hpage);
-		if (anon_vma) {
-			get_anon_vma(anon_vma);
-			page_unlock_anon_vma(anon_vma);
-		}
-	}
+	if (PageAnon(hpage))
+		anon_vma = page_get_anon_vma(hpage);
 
 	try_to_unmap(hpage, TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 
diff -puN mm/rmap.c~mm-use-refcounts-for-page_lock_anon_vma mm/rmap.c
--- a/mm/rmap.c~mm-use-refcounts-for-page_lock_anon_vma
+++ a/mm/rmap.c
@@ -337,9 +337,9 @@ void __init anon_vma_init(void)
  * that the anon_vma pointer from page->mapping is valid if there is a
  * mapcount, we can dereference the anon_vma after observing those.
  */
-struct anon_vma *page_lock_anon_vma(struct page *page)
+struct anon_vma *page_get_anon_vma(struct page *page)
 {
-	struct anon_vma *anon_vma, *root_anon_vma;
+	struct anon_vma *anon_vma = NULL;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
@@ -350,30 +350,42 @@ struct anon_vma *page_lock_anon_vma(stru
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	root_anon_vma = ACCESS_ONCE(anon_vma->root);
-	spin_lock(&root_anon_vma->lock);
+	if (!atomic_inc_not_zero(&anon_vma->refcount)) {
+		anon_vma = NULL;
+		goto out;
+	}
 
 	/*
 	 * If this page is still mapped, then its anon_vma cannot have been
-	 * freed.  But if it has been unmapped, we have no security against
-	 * the anon_vma structure being freed and reused (for another anon_vma:
-	 * SLAB_DESTROY_BY_RCU guarantees that - so the spin_lock above cannot
-	 * corrupt): with anon_vma_prepare() or anon_vma_fork() redirecting
-	 * anon_vma->root before page_unlock_anon_vma() is called to unlock.
+	 * freed.  But if it has been unmapped, we have no security against the
+	 * anon_vma structure being freed and reused (for another anon_vma:
+	 * SLAB_DESTROY_BY_RCU guarantees that - so the atomic_inc_not_zero()
+	 * above cannot corrupt).
 	 */
-	if (page_mapped(page))
-		return anon_vma;
-
-	spin_unlock(&root_anon_vma->lock);
+	if (!page_mapped(page)) {
+		put_anon_vma(anon_vma);
+		anon_vma = NULL;
+	}
 out:
 	rcu_read_unlock();
-	return NULL;
+
+	return anon_vma;
+}
+
+struct anon_vma *page_lock_anon_vma(struct page *page)
+{
+	struct anon_vma *anon_vma = page_get_anon_vma(page);
+
+	if (anon_vma)
+		anon_vma_lock(anon_vma);
+
+	return anon_vma;
 }
 
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
 	anon_vma_unlock(anon_vma);
-	rcu_read_unlock();
+	put_anon_vma(anon_vma);
 }
 
 /*
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
net-convert-%p-usage-to-%pk.patch
mm-mmu_gather-rework.patch
mm-mmu_gather-rework-fix.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch

