From: akpm@linux-foundation.org
Subject: [merged] mm-revert-page_lock_anon_vma-lock-annotation.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:53 -0700
Message-ID: <201105252027.p4PKRGrl014561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496Ab1EYUxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linu


The patch titled
     mm: revert page_lock_anon_vma() lock annotation
has been removed from the -mm tree.  Its filename was
     mm-revert-page_lock_anon_vma-lock-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch

