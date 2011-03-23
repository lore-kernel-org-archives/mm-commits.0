From: akpm@linux-foundation.org
Subject: [merged] mm-move-anon_vma-ref-out-from-under-config_foo.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:19 -0700
Message-ID: <201103232039.p2NKdtVR028450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933387Ab1CWU4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: move anon_vma ref out from under CONFIG_foo
has been removed from the -mm tree.  Its filename was
     mm-move-anon_vma-ref-out-from-under-config_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move anon_vma ref out from under CONFIG_foo
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

We need the anon_vma refcount unconditionally to simplify the anon_vma
lifetime rules.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   40 ++++------------------------------------
 mm/rmap.c            |   14 ++++++--------
 2 files changed, 10 insertions(+), 44 deletions(-)

diff -puN include/linux/rmap.h~mm-move-anon_vma-ref-out-from-under-config_foo include/linux/rmap.h
--- a/include/linux/rmap.h~mm-move-anon_vma-ref-out-from-under-config_foo
+++ a/include/linux/rmap.h
@@ -27,18 +27,15 @@
 struct anon_vma {
 	struct anon_vma *root;	/* Root of this anon_vma tree */
 	spinlock_t lock;	/* Serialize access to vma list */
-#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
-
 	/*
-	 * The external_refcount is taken by either KSM or page migration
-	 * to take a reference to an anon_vma when there is no
+	 * The refcount is taken on an anon_vma when there is no
 	 * guarantee that the vma of page tables will exist for
 	 * the duration of the operation. A caller that takes
 	 * the reference is responsible for clearing up the
 	 * anon_vma if they are the last user on release
 	 */
-	atomic_t external_refcount;
-#endif
+	atomic_t refcount;
+
 	/*
 	 * NOTE: the LSB of the head.next is set by
 	 * mm_take_all_locks() _after_ taking the above lock. So the
@@ -71,41 +68,12 @@ struct anon_vma_chain {
 };
 
 #ifdef CONFIG_MMU
-#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
-static inline void anonvma_external_refcount_init(struct anon_vma *anon_vma)
-{
-	atomic_set(&anon_vma->external_refcount, 0);
-}
-
-static inline int anonvma_external_refcount(struct anon_vma *anon_vma)
-{
-	return atomic_read(&anon_vma->external_refcount);
-}
-
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
-	atomic_inc(&anon_vma->external_refcount);
+	atomic_inc(&anon_vma->refcount);
 }
 
 void put_anon_vma(struct anon_vma *);
-#else
-static inline void anonvma_external_refcount_init(struct anon_vma *anon_vma)
-{
-}
-
-static inline int anonvma_external_refcount(struct anon_vma *anon_vma)
-{
-	return 0;
-}
-
-static inline void get_anon_vma(struct anon_vma *anon_vma)
-{
-}
-
-static inline void put_anon_vma(struct anon_vma *anon_vma)
-{
-}
-#endif /* CONFIG_KSM */
 
 static inline struct anon_vma *page_anon_vma(struct page *page)
 {
diff -puN mm/rmap.c~mm-move-anon_vma-ref-out-from-under-config_foo mm/rmap.c
--- a/mm/rmap.c~mm-move-anon_vma-ref-out-from-under-config_foo
+++ a/mm/rmap.c
@@ -272,7 +272,7 @@ static void anon_vma_unlink(struct anon_
 	list_del(&anon_vma_chain->same_anon_vma);
 
 	/* We must garbage collect the anon_vma if it's empty */
-	empty = list_empty(&anon_vma->head) && !anonvma_external_refcount(anon_vma);
+	empty = list_empty(&anon_vma->head) && !atomic_read(&anon_vma->refcount);
 	anon_vma_unlock(anon_vma);
 
 	if (empty) {
@@ -303,7 +303,7 @@ static void anon_vma_ctor(void *data)
 	struct anon_vma *anon_vma = data;
 
 	spin_lock_init(&anon_vma->lock);
-	anonvma_external_refcount_init(anon_vma);
+	atomic_set(&anon_vma->refcount, 0);
 	INIT_LIST_HEAD(&anon_vma->head);
 }
 
@@ -1486,7 +1486,6 @@ int try_to_munlock(struct page *page)
 		return try_to_unmap_file(page, TTU_MUNLOCK);
 }
 
-#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
 /*
  * Drop an anon_vma refcount, freeing the anon_vma and anon_vma->root
  * if necessary.  Be careful to do all the tests under the lock.  Once
@@ -1495,8 +1494,8 @@ int try_to_munlock(struct page *page)
  */
 void put_anon_vma(struct anon_vma *anon_vma)
 {
-	BUG_ON(atomic_read(&anon_vma->external_refcount) <= 0);
-	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
+	BUG_ON(atomic_read(&anon_vma->refcount) <= 0);
+	if (atomic_dec_and_lock(&anon_vma->refcount, &anon_vma->root->lock)) {
 		struct anon_vma *root = anon_vma->root;
 		int empty = list_empty(&anon_vma->head);
 		int last_root_user = 0;
@@ -1507,8 +1506,8 @@ void put_anon_vma(struct anon_vma *anon_
 		 * the refcount on the root and check if we need to free it.
 		 */
 		if (empty && anon_vma != root) {
-			BUG_ON(atomic_read(&root->external_refcount) <= 0);
-			last_root_user = atomic_dec_and_test(&root->external_refcount);
+			BUG_ON(atomic_read(&root->refcount) <= 0);
+			last_root_user = atomic_dec_and_test(&root->refcount);
 			root_empty = list_empty(&root->head);
 		}
 		anon_vma_unlock(anon_vma);
@@ -1520,7 +1519,6 @@ void put_anon_vma(struct anon_vma *anon_
 		}
 	}
 }
-#endif
 
 #ifdef CONFIG_MIGRATION
 /*
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
net-convert-%p-usage-to-%pk.patch

