From: akpm@linux-foundation.org
Subject: [merged] mm-simplify-anon_vma-refcounts.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:21 -0700
Message-ID: <201103232039.p2NKdvWP028456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329Ab1CWU4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: simplify anon_vma refcounts
has been removed from the -mm tree.  Its filename was
     mm-simplify-anon_vma-refcounts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: simplify anon_vma refcounts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

This patch changes the anon_vma refcount to be 0 when the object is free. 
It does this by adding 1 ref to being in use in the anon_vma structure
(iow.  the anon_vma->head list is not empty).

This allows a simpler release scheme without having to check both the
refcount and the list as well as avoids taking a ref for each entry on the
list.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   11 ++++-
 mm/rmap.c            |   78 +++++++++++++++--------------------------
 2 files changed, 38 insertions(+), 51 deletions(-)

diff -puN include/linux/rmap.h~mm-simplify-anon_vma-refcounts include/linux/rmap.h
--- a/include/linux/rmap.h~mm-simplify-anon_vma-refcounts
+++ a/include/linux/rmap.h
@@ -73,7 +73,13 @@ static inline void get_anon_vma(struct a
 	atomic_inc(&anon_vma->refcount);
 }
 
-void put_anon_vma(struct anon_vma *);
+void __put_anon_vma(struct anon_vma *anon_vma);
+
+static inline void put_anon_vma(struct anon_vma *anon_vma)
+{
+	if (atomic_dec_and_test(&anon_vma->refcount))
+		__put_anon_vma(anon_vma);
+}
 
 static inline struct anon_vma *page_anon_vma(struct page *page)
 {
@@ -116,7 +122,6 @@ void unlink_anon_vmas(struct vm_area_str
 int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
 int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
 void __anon_vma_link(struct vm_area_struct *);
-void anon_vma_free(struct anon_vma *);
 
 static inline void anon_vma_merge(struct vm_area_struct *vma,
 				  struct vm_area_struct *next)
@@ -125,6 +130,8 @@ static inline void anon_vma_merge(struct
 	unlink_anon_vmas(next);
 }
 
+struct anon_vma *page_get_anon_vma(struct page *page);
+
 /*
  * rmap interfaces called when adding or removing pte of page
  */
diff -puN mm/rmap.c~mm-simplify-anon_vma-refcounts mm/rmap.c
--- a/mm/rmap.c~mm-simplify-anon_vma-refcounts
+++ a/mm/rmap.c
@@ -67,11 +67,24 @@ static struct kmem_cache *anon_vma_chain
 
 static inline struct anon_vma *anon_vma_alloc(void)
 {
-	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
+	struct anon_vma *anon_vma;
+
+	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
+	if (anon_vma) {
+		atomic_set(&anon_vma->refcount, 1);
+		/*
+		 * Initialise the anon_vma root to point to itself. If called
+		 * from fork, the root will be reset to the parents anon_vma.
+		 */
+		anon_vma->root = anon_vma;
+	}
+
+	return anon_vma;
 }
 
-void anon_vma_free(struct anon_vma *anon_vma)
+static inline void anon_vma_free(struct anon_vma *anon_vma)
 {
+	VM_BUG_ON(atomic_read(&anon_vma->refcount));
 	kmem_cache_free(anon_vma_cachep, anon_vma);
 }
 
@@ -133,11 +146,6 @@ int anon_vma_prepare(struct vm_area_stru
 			if (unlikely(!anon_vma))
 				goto out_enomem_free_avc;
 			allocated = anon_vma;
-			/*
-			 * This VMA had no anon_vma yet.  This anon_vma is
-			 * the root of any anon_vma tree that might form.
-			 */
-			anon_vma->root = anon_vma;
 		}
 
 		anon_vma_lock(anon_vma);
@@ -156,7 +164,7 @@ int anon_vma_prepare(struct vm_area_stru
 		anon_vma_unlock(anon_vma);
 
 		if (unlikely(allocated))
-			anon_vma_free(allocated);
+			put_anon_vma(allocated);
 		if (unlikely(avc))
 			anon_vma_chain_free(avc);
 	}
@@ -241,9 +249,9 @@ int anon_vma_fork(struct vm_area_struct 
 	 */
 	anon_vma->root = pvma->anon_vma->root;
 	/*
-	 * With KSM refcounts, an anon_vma can stay around longer than the
-	 * process it belongs to.  The root anon_vma needs to be pinned
-	 * until this anon_vma is freed, because the lock lives in the root.
+	 * With refcounts, an anon_vma can stay around longer than the
+	 * process it belongs to. The root anon_vma needs to be pinned until
+	 * this anon_vma is freed, because the lock lives in the root.
 	 */
 	get_anon_vma(anon_vma->root);
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
@@ -253,7 +261,7 @@ int anon_vma_fork(struct vm_area_struct 
 	return 0;
 
  out_error_free_anon_vma:
-	anon_vma_free(anon_vma);
+	put_anon_vma(anon_vma);
  out_error:
 	unlink_anon_vmas(vma);
 	return -ENOMEM;
@@ -272,15 +280,11 @@ static void anon_vma_unlink(struct anon_
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
-	empty = list_empty(&anon_vma->head) && !atomic_read(&anon_vma->refcount);
+	empty = list_empty(&anon_vma->head);
 	anon_vma_unlock(anon_vma);
 
-	if (empty) {
-		/* We no longer need the root anon_vma */
-		if (anon_vma->root != anon_vma)
-			put_anon_vma(anon_vma->root);
-		anon_vma_free(anon_vma);
-	}
+	if (empty)
+		put_anon_vma(anon_vma);
 }
 
 void unlink_anon_vmas(struct vm_area_struct *vma)
@@ -1486,38 +1490,14 @@ int try_to_munlock(struct page *page)
 		return try_to_unmap_file(page, TTU_MUNLOCK);
 }
 
-/*
- * Drop an anon_vma refcount, freeing the anon_vma and anon_vma->root
- * if necessary.  Be careful to do all the tests under the lock.  Once
- * we know we are the last user, nobody else can get a reference and we
- * can do the freeing without the lock.
- */
-void put_anon_vma(struct anon_vma *anon_vma)
-{
-	BUG_ON(atomic_read(&anon_vma->refcount) <= 0);
-	if (atomic_dec_and_lock(&anon_vma->refcount, &anon_vma->root->lock)) {
-		struct anon_vma *root = anon_vma->root;
-		int empty = list_empty(&anon_vma->head);
-		int last_root_user = 0;
-		int root_empty = 0;
+void __put_anon_vma(struct anon_vma *anon_vma)
+{
+	struct anon_vma *root = anon_vma->root;
 
-		/*
-		 * The refcount on a non-root anon_vma got dropped.  Drop
-		 * the refcount on the root and check if we need to free it.
-		 */
-		if (empty && anon_vma != root) {
-			BUG_ON(atomic_read(&root->refcount) <= 0);
-			last_root_user = atomic_dec_and_test(&root->refcount);
-			root_empty = list_empty(&root->head);
-		}
-		anon_vma_unlock(anon_vma);
+	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
+		anon_vma_free(root);
 
-		if (empty) {
-			anon_vma_free(anon_vma);
-			if (root_empty && last_root_user)
-				anon_vma_free(root);
-		}
-	}
+	anon_vma_free(anon_vma);
 }
 
 #ifdef CONFIG_MIGRATION
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
net-convert-%p-usage-to-%pk.patch

