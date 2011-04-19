From: akpm@linux-foundation.org
Subject: + mm-revert-page_lock_anon_vma-lock-annotation.patch added to -mm tree
Date: Tue, 19 Apr 2011 13:10:42 -0700
Message-ID: <201104192010.p3JKAgX6020515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1DSUL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 16:11:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linux-sh.org, mel@csn.ul.ie, namhyung@gmail.com, npiggin@kernel.dk, richard@nod.at, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com, tony.luck@intel.com


The patch titled
     mm: revert page_lock_anon_vma() lock annotation
has been added to the -mm tree.  Its filename is
     mm-revert-page_lock_anon_vma-lock-annotation.patch

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
Subject: mm: revert page_lock_anon_vma() lock annotation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Its beyond ugly and gets in the way.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Tony Luck <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   15 +--------------
 mm/rmap.c            |    4 +---
 2 files changed, 2 insertions(+), 17 deletions(-)

diff -puN include/linux/rmap.h~mm-revert-page_lock_anon_vma-lock-annotation include/linux/rmap.h
--- a/include/linux/rmap.h~mm-revert-page_lock_anon_vma-lock-annotation
+++ a/include/linux/rmap.h
@@ -219,20 +219,7 @@ int try_to_munlock(struct page *);
 /*
  * Called by memory-failure.c to kill processes.
  */
-struct anon_vma *__page_lock_anon_vma(struct page *page);
-
-static inline struct anon_vma *page_lock_anon_vma(struct page *page)
-{
-	struct anon_vma *anon_vma;
-
-	__cond_lock(RCU, anon_vma = __page_lock_anon_vma(page));
-
-	/* (void) is needed to make gcc happy */
-	(void) __cond_lock(&anon_vma->root->lock, anon_vma);
-
-	return anon_vma;
-}
-
+struct anon_vma *page_lock_anon_vma(struct page *page);
 void page_unlock_anon_vma(struct anon_vma *anon_vma);
 int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
diff -puN mm/rmap.c~mm-revert-page_lock_anon_vma-lock-annotation mm/rmap.c
--- a/mm/rmap.c~mm-revert-page_lock_anon_vma-lock-annotation
+++ a/mm/rmap.c
@@ -323,7 +323,7 @@ void __init anon_vma_init(void)
  * Getting a lock on a stable anon_vma from a page off the LRU is
  * tricky: page_lock_anon_vma rely on RCU to guard against the races.
  */
-struct anon_vma *__page_lock_anon_vma(struct page *page)
+struct anon_vma *page_lock_anon_vma(struct page *page)
 {
 	struct anon_vma *anon_vma, *root_anon_vma;
 	unsigned long anon_mapping;
@@ -357,8 +357,6 @@ out:
 }
 
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
-	__releases(&anon_vma->root->lock)
-	__releases(RCU)
 {
 	anon_vma_unlock(anon_vma);
 	rcu_read_unlock();
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

