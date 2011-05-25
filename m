From: akpm@linux-foundation.org
Subject: [merged] mm-use-refcounts-for-page_lock_anon_vma.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:59 -0700
Message-ID: <201105252027.p4PKRM5w014571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097Ab1EYU23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linu


The patch titled
     mm: use refcounts for page_lock_anon_vma()
has been removed from the -mm tree.  Its filename was
     mm-use-refcounts-for-page_lock_anon_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch

