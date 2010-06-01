From: akpm@linux-foundation.org
Subject: + mm-always-lock-the-root-oldest-anon_vma.patch added to -mm tree
Date: Tue, 01 Jun 2010 15:10:27 -0700
Message-ID: <201006012210.o51MARJf021808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab0FAWLB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 18:11:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lwoodman@redhat.com, mel@csn.ul.ie, minchan.kim@gmail.com, torvalds@linux-foundation.org


The patch titled
     mm: always lock the root (oldest) anon_vma
has been added to the -mm tree.  Its filename is
     mm-always-lock-the-root-oldest-anon_vma.patch

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
Subject: mm: always lock the root (oldest) anon_vma
From: Rik van Riel <riel@redhat.com>

Always (and only) lock the root (oldest) anon_vma whenever we do something
in an anon_vma.  The recently introduced anon_vma scalability is due to
the rmap code scanning only the VMAs that need to be scanned.  Many common
operations still took the anon_vma lock on the root anon_vma, so always
taking that lock is not expected to introduce any scalability issues.

However, always taking the same lock does mean we only need to take one
lock, which means rmap_walk on pages from any anon_vma in the vma is
excluded from occurring during an munmap, expand_stack or other operation
that needs to exclude rmap_walk and similar functions.

Also add the proper locking to vma_adjust.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Larry Woodman <lwoodman@redhat.com>
Acked-by: Larry Woodman <lwoodman@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    8 ++++----
 mm/ksm.c             |    2 +-
 mm/migrate.c         |    2 +-
 mm/mmap.c            |   30 ++++++++++++++++++++++--------
 4 files changed, 28 insertions(+), 14 deletions(-)

diff -puN include/linux/rmap.h~mm-always-lock-the-root-oldest-anon_vma include/linux/rmap.h
--- a/include/linux/rmap.h~mm-always-lock-the-root-oldest-anon_vma
+++ a/include/linux/rmap.h
@@ -104,24 +104,24 @@ static inline void vma_lock_anon_vma(str
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		spin_lock(&anon_vma->lock);
+		spin_lock(&anon_vma->root->lock);
 }
 
 static inline void vma_unlock_anon_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	if (anon_vma)
-		spin_unlock(&anon_vma->lock);
+		spin_unlock(&anon_vma->root->lock);
 }
 
 static inline void anon_vma_lock(struct anon_vma *anon_vma)
 {
-	spin_lock(&anon_vma->lock);
+	spin_lock(&anon_vma->root->lock);
 }
 
 static inline void anon_vma_unlock(struct anon_vma *anon_vma)
 {
-	spin_unlock(&anon_vma->lock);
+	spin_unlock(&anon_vma->root->lock);
 }
 
 /*
diff -puN mm/ksm.c~mm-always-lock-the-root-oldest-anon_vma mm/ksm.c
--- a/mm/ksm.c~mm-always-lock-the-root-oldest-anon_vma
+++ a/mm/ksm.c
@@ -325,7 +325,7 @@ static void drop_anon_vma(struct rmap_it
 {
 	struct anon_vma *anon_vma = rmap_item->anon_vma;
 
-	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
+	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
 		int empty = list_empty(&anon_vma->head);
 		anon_vma_unlock(anon_vma);
 		if (empty)
diff -puN mm/migrate.c~mm-always-lock-the-root-oldest-anon_vma mm/migrate.c
--- a/mm/migrate.c~mm-always-lock-the-root-oldest-anon_vma
+++ a/mm/migrate.c
@@ -682,7 +682,7 @@ skip_unmap:
 rcu_unlock:
 
 	/* Drop an anon_vma reference if we took one */
-	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->lock)) {
+	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
 		int empty = list_empty(&anon_vma->head);
 		anon_vma_unlock(anon_vma);
 		if (empty)
diff -puN mm/mmap.c~mm-always-lock-the-root-oldest-anon_vma mm/mmap.c
--- a/mm/mmap.c~mm-always-lock-the-root-oldest-anon_vma
+++ a/mm/mmap.c
@@ -506,6 +506,7 @@ int vma_adjust(struct vm_area_struct *vm
 	struct vm_area_struct *importer = NULL;
 	struct address_space *mapping = NULL;
 	struct prio_tree_root *root = NULL;
+	struct anon_vma *anon_vma = NULL;
 	struct file *file = vma->vm_file;
 	long adjust_next = 0;
 	int remove_next = 0;
@@ -578,6 +579,17 @@ again:			remove_next = 1 + (end > next->
 		}
 	}
 
+	/*
+	 * When changing only vma->vm_end, we don't really need anon_vma
+	 * lock. This is a fairly rare case by itself, but the anon_vma
+	 * lock may be shared between many sibling processes.  Skipping
+	 * the lock for brk adjustments makes a difference sometimes.
+	 */
+	if (vma->anon_vma && (insert || importer || start != vma->vm_start)) {
+		anon_vma = vma->anon_vma;
+		anon_vma_lock(anon_vma);
+	}
+
 	if (root) {
 		flush_dcache_mmap_lock(mapping);
 		vma_prio_tree_remove(vma, root);
@@ -617,6 +629,8 @@ again:			remove_next = 1 + (end > next->
 		__insert_vm_struct(mm, insert);
 	}
 
+	if (anon_vma)
+		anon_vma_unlock(anon_vma);
 	if (mapping)
 		spin_unlock(&mapping->i_mmap_lock);
 
@@ -2466,23 +2480,23 @@ static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
-	if (!test_bit(0, (unsigned long *) &anon_vma->head.next)) {
+	if (!test_bit(0, (unsigned long *) &anon_vma->root->head.next)) {
 		/*
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		spin_lock_nest_lock(&anon_vma->lock, &mm->mmap_sem);
+		spin_lock_nest_lock(&anon_vma->root->lock, &mm->mmap_sem);
 		/*
 		 * We can safely modify head.next after taking the
-		 * anon_vma->lock. If some other vma in this mm shares
+		 * anon_vma->root->lock. If some other vma in this mm shares
 		 * the same anon_vma we won't take it again.
 		 *
 		 * No need of atomic instructions here, head.next
 		 * can't change from under us thanks to the
-		 * anon_vma->lock.
+		 * anon_vma->root->lock.
 		 */
 		if (__test_and_set_bit(0, (unsigned long *)
-				       &anon_vma->head.next))
+				       &anon_vma->root->head.next))
 			BUG();
 	}
 }
@@ -2573,7 +2587,7 @@ out_unlock:
 
 static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 {
-	if (test_bit(0, (unsigned long *) &anon_vma->head.next)) {
+	if (test_bit(0, (unsigned long *) &anon_vma->root->head.next)) {
 		/*
 		 * The LSB of head.next can't change to 0 from under
 		 * us because we hold the mm_all_locks_mutex.
@@ -2584,10 +2598,10 @@ static void vm_unlock_anon_vma(struct an
 		 *
 		 * No need of atomic instructions here, head.next
 		 * can't change from under us until we release the
-		 * anon_vma->lock.
+		 * anon_vma->root->lock.
 		 */
 		if (!__test_and_clear_bit(0, (unsigned long *)
-					  &anon_vma->head.next))
+					  &anon_vma->root->head.next))
 			BUG();
 		anon_vma_unlock(anon_vma);
 	}
_

Patches currently in -mm which might be from riel@redhat.com are

mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-track-the-root-oldest-anon_vma-fix.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch

