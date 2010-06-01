From: akpm@linux-foundation.org
Subject: + mm-extend-ksm-refcounts-to-the-anon_vma-root.patch added to -mm tree
Date: Tue, 01 Jun 2010 15:10:29 -0700
Message-ID: <201006012210.o51MAUAo021811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718Ab0FAWKq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 18:10:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lwoodman@redhat.com, mel@csn.ul.ie, minchan.kim@gmail.com, torvalds@linux-foundation.org


The patch titled
     mm: extend KSM refcounts to the anon_vma root
has been added to the -mm tree.  Its filename is
     mm-extend-ksm-refcounts-to-the-anon_vma-root.patch

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
Subject: mm: extend KSM refcounts to the anon_vma root
From: Rik van Riel <riel@redhat.com>

KSM reference counts can cause an anon_vma to exist after the processe it
belongs to have already exited.  Because the anon_vma lock now lives in
the root anon_vma, we need to ensure that the root anon_vma stays around
until after all the "child" anon_vmas have been freed.

The obvious way to do this is to have a "child" anon_vma take a reference
to the root in anon_vma_fork.  When the anon_vma is freed at munmap or
process exit, we drop the refcount in anon_vma_unlink and possibly free
the root anon_vma.

The KSM anon_vma reference count function also needs to be modified to
deal with the possibility of freeing 2 levels of anon_vma.  The easiest
way to do this is to break out the KSM magic and make it generic.

When compiling without CONFIG_KSM, this code is compiled out.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Larry Woodman <lwoodman@redhat.com>
Acked-by: Larry Woodman <lwoodman@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   15 +++++++++++++
 mm/ksm.c             |   17 +++++----------
 mm/migrate.c         |   10 ++-------
 mm/rmap.c            |   45 ++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 68 insertions(+), 19 deletions(-)

diff -puN include/linux/rmap.h~mm-extend-ksm-refcounts-to-the-anon_vma-root include/linux/rmap.h
--- a/include/linux/rmap.h~mm-extend-ksm-refcounts-to-the-anon_vma-root
+++ a/include/linux/rmap.h
@@ -81,6 +81,13 @@ static inline int anonvma_external_refco
 {
 	return atomic_read(&anon_vma->external_refcount);
 }
+
+static inline void get_anon_vma(struct anon_vma *anon_vma)
+{
+	atomic_inc(&anon_vma->external_refcount);
+}
+
+void drop_anon_vma(struct anon_vma *);
 #else
 static inline void anonvma_external_refcount_init(struct anon_vma *anon_vma)
 {
@@ -90,6 +97,14 @@ static inline int anonvma_external_refco
 {
 	return 0;
 }
+
+static inline void get_anon_vma(struct anon_vma *anon_vma)
+{
+}
+
+static inline void drop_anon_vma(struct anon_vma *anon_vma)
+{
+}
 #endif /* CONFIG_KSM */
 
 static inline struct anon_vma *page_anon_vma(struct page *page)
diff -puN mm/ksm.c~mm-extend-ksm-refcounts-to-the-anon_vma-root mm/ksm.c
--- a/mm/ksm.c~mm-extend-ksm-refcounts-to-the-anon_vma-root
+++ a/mm/ksm.c
@@ -318,19 +318,14 @@ static void hold_anon_vma(struct rmap_it
 			  struct anon_vma *anon_vma)
 {
 	rmap_item->anon_vma = anon_vma;
-	atomic_inc(&anon_vma->external_refcount);
+	get_anon_vma(anon_vma);
 }
 
-static void drop_anon_vma(struct rmap_item *rmap_item)
+static void ksm_drop_anon_vma(struct rmap_item *rmap_item)
 {
 	struct anon_vma *anon_vma = rmap_item->anon_vma;
 
-	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
-		int empty = list_empty(&anon_vma->head);
-		anon_vma_unlock(anon_vma);
-		if (empty)
-			anon_vma_free(anon_vma);
-	}
+	drop_anon_vma(anon_vma);
 }
 
 /*
@@ -415,7 +410,7 @@ static void break_cow(struct rmap_item *
 	 * It is not an accident that whenever we want to break COW
 	 * to undo, we also need to drop a reference to the anon_vma.
 	 */
-	drop_anon_vma(rmap_item);
+	ksm_drop_anon_vma(rmap_item);
 
 	down_read(&mm->mmap_sem);
 	if (ksm_test_exit(mm))
@@ -470,7 +465,7 @@ static void remove_node_from_stable_tree
 			ksm_pages_sharing--;
 		else
 			ksm_pages_shared--;
-		drop_anon_vma(rmap_item);
+		ksm_drop_anon_vma(rmap_item);
 		rmap_item->address &= PAGE_MASK;
 		cond_resched();
 	}
@@ -558,7 +553,7 @@ static void remove_rmap_item_from_tree(s
 		else
 			ksm_pages_shared--;
 
-		drop_anon_vma(rmap_item);
+		ksm_drop_anon_vma(rmap_item);
 		rmap_item->address &= PAGE_MASK;
 
 	} else if (rmap_item->address & UNSTABLE_FLAG) {
diff -puN mm/migrate.c~mm-extend-ksm-refcounts-to-the-anon_vma-root mm/migrate.c
--- a/mm/migrate.c~mm-extend-ksm-refcounts-to-the-anon_vma-root
+++ a/mm/migrate.c
@@ -639,7 +639,7 @@ static int unmap_and_move(new_page_t get
 			 * exist when the page is remapped later
 			 */
 			anon_vma = page_anon_vma(page);
-			atomic_inc(&anon_vma->external_refcount);
+			get_anon_vma(anon_vma);
 		}
 	}
 
@@ -682,12 +682,8 @@ skip_unmap:
 rcu_unlock:
 
 	/* Drop an anon_vma reference if we took one */
-	if (anon_vma && atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
-		int empty = list_empty(&anon_vma->head);
-		anon_vma_unlock(anon_vma);
-		if (empty)
-			anon_vma_free(anon_vma);
-	}
+	if (anon_vma)
+		drop_anon_vma(anon_vma);
 
 	if (rcu_locked)
 		rcu_read_unlock();
diff -puN mm/rmap.c~mm-extend-ksm-refcounts-to-the-anon_vma-root mm/rmap.c
--- a/mm/rmap.c~mm-extend-ksm-refcounts-to-the-anon_vma-root
+++ a/mm/rmap.c
@@ -235,6 +235,12 @@ int anon_vma_fork(struct vm_area_struct 
 	 * lock any of the anon_vmas in this anon_vma tree.
 	 */
 	anon_vma->root = pvma->anon_vma->root;
+	/*
+	 * With KSM refcounts, an anon_vma can stay around longer than the
+	 * process it belongs to.  The root anon_vma needs to be pinned
+	 * until this anon_vma is freed, because the lock lives in the root.
+	 */
+	get_anon_vma(anon_vma->root);
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
 	vma->anon_vma = anon_vma;
 	anon_vma_chain_link(vma, avc, anon_vma);
@@ -264,8 +270,11 @@ static void anon_vma_unlink(struct anon_
 	empty = list_empty(&anon_vma->head) && !anonvma_external_refcount(anon_vma);
 	anon_vma_unlock(anon_vma);
 
-	if (empty)
+	if (empty) {
+		/* We no longer need the root anon_vma */
+		drop_anon_vma(anon_vma->root);
 		anon_vma_free(anon_vma);
+	}
 }
 
 void unlink_anon_vmas(struct vm_area_struct *vma)
@@ -1389,6 +1398,40 @@ int try_to_munlock(struct page *page)
 		return try_to_unmap_file(page, TTU_MUNLOCK);
 }
 
+#if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
+/*
+ * Drop an anon_vma refcount, freeing the anon_vma and anon_vma->root
+ * if necessary.  Be careful to do all the tests under the lock.  Once
+ * we know we are the last user, nobody else can get a reference and we
+ * can do the freeing without the lock.
+ */
+void drop_anon_vma(struct anon_vma *anon_vma)
+{
+	if (atomic_dec_and_lock(&anon_vma->external_refcount, &anon_vma->root->lock)) {
+		struct anon_vma *root = anon_vma->root;
+		int empty = list_empty(&anon_vma->head);
+		int last_root_user = 0;
+		int root_empty = 0;
+
+		/*
+		 * The refcount on a non-root anon_vma got dropped.  Drop
+		 * the refcount on the root and check if we need to free it.
+		 */
+		if (empty && anon_vma != root) {
+			last_root_user = atomic_dec_and_test(&root->external_refcount);
+			root_empty = list_empty(&root->head);
+		}
+		anon_vma_unlock(anon_vma);
+
+		if (empty) {
+			anon_vma_free(anon_vma);
+			if (root_empty && last_root_user)
+				anon_vma_free(root);
+		}
+	}
+}
+#endif
+
 #ifdef CONFIG_MIGRATION
 /*
  * rmap_walk() and its helpers rmap_walk_anon() and rmap_walk_file():
_

Patches currently in -mm which might be from riel@redhat.com are

mm-revalidate-anon_vma-in-page_lock_anon_vma.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-track-the-root-oldest-anon_vma-fix.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch

