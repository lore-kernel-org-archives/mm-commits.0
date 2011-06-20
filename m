From: akpm@linux-foundation.org
Subject: + mm-memory-failurec-fix-spinlock-vs-mutex-order.patch added to -mm tree
Date: Mon, 20 Jun 2011 16:47:10 -0700
Message-ID: <201106202347.p5KNlABo030553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165Ab1FTXr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 19:47:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, ak@linux.intel.com


The patch titled
     mm/memory-failure.c: fix spinlock vs mutex order
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-fix-spinlock-vs-mutex-order.patch

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
Subject: mm/memory-failure.c: fix spinlock vs mutex order
From: Peter Zijlstra <peterz@infradead.org>

We cannot take a mutex while holding a spinlock, so flip the order and
fix the locking documentation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   21 ++++++---------------
 mm/rmap.c           |    5 ++---
 2 files changed, 8 insertions(+), 18 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-fix-spinlock-vs-mutex-order mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-fix-spinlock-vs-mutex-order
+++ a/mm/memory-failure.c
@@ -391,10 +391,11 @@ static void collect_procs_anon(struct pa
 	struct task_struct *tsk;
 	struct anon_vma *av;
 
-	read_lock(&tasklist_lock);
 	av = page_lock_anon_vma(page);
 	if (av == NULL)	/* Not actually mapped anymore */
-		goto out;
+		return;
+
+	read_lock(&tasklist_lock);
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
 
@@ -408,9 +409,8 @@ static void collect_procs_anon(struct pa
 				add_to_kill(tsk, page, vma, to_kill, tkc);
 		}
 	}
-	page_unlock_anon_vma(av);
-out:
 	read_unlock(&tasklist_lock);
+	page_unlock_anon_vma(av);
 }
 
 /*
@@ -424,17 +424,8 @@ static void collect_procs_file(struct pa
 	struct prio_tree_iter iter;
 	struct address_space *mapping = page->mapping;
 
-	/*
-	 * A note on the locking order between the two locks.
-	 * We don't rely on this particular order.
-	 * If you have some other code that needs a different order
-	 * feel free to switch them around. Or add a reverse link
-	 * from mm_struct to task_struct, then this could be all
-	 * done without taking tasklist_lock and looping over all tasks.
-	 */
-
-	read_lock(&tasklist_lock);
 	mutex_lock(&mapping->i_mmap_mutex);
+	read_lock(&tasklist_lock);
 	for_each_process(tsk) {
 		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 
@@ -454,8 +445,8 @@ static void collect_procs_file(struct pa
 				add_to_kill(tsk, page, vma, to_kill, tkc);
 		}
 	}
-	mutex_unlock(&mapping->i_mmap_mutex);
 	read_unlock(&tasklist_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 }
 
 /*
diff -puN mm/rmap.c~mm-memory-failurec-fix-spinlock-vs-mutex-order mm/rmap.c
--- a/mm/rmap.c~mm-memory-failurec-fix-spinlock-vs-mutex-order
+++ a/mm/rmap.c
@@ -38,9 +38,8 @@
  *                           in arch-dependent flush_dcache_mmap_lock,
  *                           within inode_wb_list_lock in __sync_single_inode)
  *
- * (code doesn't rely on that order so it could be switched around)
- * ->tasklist_lock
- *   anon_vma->mutex      (memory_failure, collect_procs_anon)
+ * anon_vma->mutex,mapping->i_mutex      (memory_failure, collect_procs_anon)
+ *   ->tasklist_lock
  *     pte map lock
  */
 
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
mm-memory-failurec-fix-spinlock-vs-mutex-order.patch
linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

