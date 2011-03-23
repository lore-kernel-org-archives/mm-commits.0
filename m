From: akpm@linux-foundation.org
Subject: [merged] mm-rename-drop_anon_vma-to-put_anon_vma.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:16 -0700
Message-ID: <201103232039.p2NKdqvT028446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329Ab1CWUko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:40:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: rename drop_anon_vma() to put_anon_vma()
has been removed from the -mm tree.  Its filename was
     mm-rename-drop_anon_vma-to-put_anon_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: rename drop_anon_vma() to put_anon_vma()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The normal code pattern used in the kernel is: get/put.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++--
 mm/ksm.c             |   23 +++++------------------
 mm/migrate.c         |    4 ++--
 mm/rmap.c            |    4 ++--
 4 files changed, 11 insertions(+), 24 deletions(-)

diff -puN include/linux/rmap.h~mm-rename-drop_anon_vma-to-put_anon_vma include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rename-drop_anon_vma-to-put_anon_vma
+++ a/include/linux/rmap.h
@@ -87,7 +87,7 @@ static inline void get_anon_vma(struct a
 	atomic_inc(&anon_vma->external_refcount);
 }
 
-void drop_anon_vma(struct anon_vma *);
+void put_anon_vma(struct anon_vma *);
 #else
 static inline void anonvma_external_refcount_init(struct anon_vma *anon_vma)
 {
@@ -102,7 +102,7 @@ static inline void get_anon_vma(struct a
 {
 }
 
-static inline void drop_anon_vma(struct anon_vma *anon_vma)
+static inline void put_anon_vma(struct anon_vma *anon_vma)
 {
 }
 #endif /* CONFIG_KSM */
diff -puN mm/ksm.c~mm-rename-drop_anon_vma-to-put_anon_vma mm/ksm.c
--- a/mm/ksm.c~mm-rename-drop_anon_vma-to-put_anon_vma
+++ a/mm/ksm.c
@@ -301,20 +301,6 @@ static inline int in_stable_tree(struct 
 	return rmap_item->address & STABLE_FLAG;
 }
 
-static void hold_anon_vma(struct rmap_item *rmap_item,
-			  struct anon_vma *anon_vma)
-{
-	rmap_item->anon_vma = anon_vma;
-	get_anon_vma(anon_vma);
-}
-
-static void ksm_drop_anon_vma(struct rmap_item *rmap_item)
-{
-	struct anon_vma *anon_vma = rmap_item->anon_vma;
-
-	drop_anon_vma(anon_vma);
-}
-
 /*
  * ksmd, and unmerge_and_remove_all_rmap_items(), must not touch an mm's
  * page tables after it has passed through ksm_exit() - which, if necessary,
@@ -397,7 +383,7 @@ static void break_cow(struct rmap_item *
 	 * It is not an accident that whenever we want to break COW
 	 * to undo, we also need to drop a reference to the anon_vma.
 	 */
-	ksm_drop_anon_vma(rmap_item);
+	put_anon_vma(rmap_item->anon_vma);
 
 	down_read(&mm->mmap_sem);
 	if (ksm_test_exit(mm))
@@ -466,7 +452,7 @@ static void remove_node_from_stable_tree
 			ksm_pages_sharing--;
 		else
 			ksm_pages_shared--;
-		ksm_drop_anon_vma(rmap_item);
+		put_anon_vma(rmap_item->anon_vma);
 		rmap_item->address &= PAGE_MASK;
 		cond_resched();
 	}
@@ -554,7 +540,7 @@ static void remove_rmap_item_from_tree(s
 		else
 			ksm_pages_shared--;
 
-		ksm_drop_anon_vma(rmap_item);
+		put_anon_vma(rmap_item->anon_vma);
 		rmap_item->address &= PAGE_MASK;
 
 	} else if (rmap_item->address & UNSTABLE_FLAG) {
@@ -949,7 +935,8 @@ static int try_to_merge_with_ksm_page(st
 		goto out;
 
 	/* Must get reference to anon_vma while still holding mmap_sem */
-	hold_anon_vma(rmap_item, vma->anon_vma);
+	rmap_item->anon_vma = vma->anon_vma;
+	get_anon_vma(vma->anon_vma);
 out:
 	up_read(&mm->mmap_sem);
 	return err;
diff -puN mm/migrate.c~mm-rename-drop_anon_vma-to-put_anon_vma mm/migrate.c
--- a/mm/migrate.c~mm-rename-drop_anon_vma-to-put_anon_vma
+++ a/mm/migrate.c
@@ -764,7 +764,7 @@ skip_unmap:
 
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
-		drop_anon_vma(anon_vma);
+		put_anon_vma(anon_vma);
 
 uncharge:
 	if (!charge)
@@ -856,7 +856,7 @@ static int unmap_and_move_huge_page(new_
 		remove_migration_ptes(hpage, hpage);
 
 	if (anon_vma)
-		drop_anon_vma(anon_vma);
+		put_anon_vma(anon_vma);
 out:
 	unlock_page(hpage);
 
diff -puN mm/rmap.c~mm-rename-drop_anon_vma-to-put_anon_vma mm/rmap.c
--- a/mm/rmap.c~mm-rename-drop_anon_vma-to-put_anon_vma
+++ a/mm/rmap.c
@@ -278,7 +278,7 @@ static void anon_vma_unlink(struct anon_
 	if (empty) {
 		/* We no longer need the root anon_vma */
 		if (anon_vma->root != anon_vma)
-			drop_anon_vma(anon_vma->root);
+			put_anon_vma(anon_vma->root);
 		anon_vma_free(anon_vma);
 	}
 }
@@ -1493,7 +1493,7 @@ int try_to_munlock(struct page *page)
  * we know we are the last user, nobody else can get a reference and we
  * can do the freeing without the lock.
  */
-void drop_anon_vma(struct anon_vma *anon_vma)
+void put_anon_vma(struct anon_vma *anon_vma)
 {
 	BUG_ON(atomic_read(&anon_vma->external_refcount) <= 0);
 	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
net-convert-%p-usage-to-%pk.patch

