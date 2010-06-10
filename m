From: akpm@linux-foundation.org
Subject: + mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch added to -mm tree
Date: Wed, 09 Jun 2010 19:07:31 -0700
Message-ID: <201006100207.o5A27PoU002141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815Ab0FJCIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 22:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, catalin.marinas@arm.com, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     only drop root anon_vma if not self (kmemleak)
has been added to the -mm tree.  Its filename is
     mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch

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
Subject: only drop root anon_vma if not self (kmemleak)
From: Rik van Riel <riel@redhat.com>

With the new anon_vma code we take a refcount on the root anon_vma.
However, the root anon_vma does not have a refcount on itself, so
we should not try to do a drop on itself when it is being unlinked.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c      |    3 ++-
 mm/rmap.c.orig |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-extend-ksm-refcounts-to-the-anon_vma-root-fix mm/rmap.c
--- a/mm/rmap.c~mm-extend-ksm-refcounts-to-the-anon_vma-root-fix
+++ a/mm/rmap.c
@@ -273,7 +273,8 @@ static void anon_vma_unlink(struct anon_
 
 	if (empty) {
 		/* We no longer need the root anon_vma */
-		drop_anon_vma(anon_vma->root);
+		if (anon_vma->root != anon_vma)
+			drop_anon_vma(anon_vma->root);
 		anon_vma_free(anon_vma);
 	}
 }
diff -puN mm/rmap.c.orig~mm-extend-ksm-refcounts-to-the-anon_vma-root-fix mm/rmap.c.orig
--- a/mm/rmap.c.orig~mm-extend-ksm-refcounts-to-the-anon_vma-root-fix
+++ a/mm/rmap.c.orig
@@ -236,6 +236,12 @@ int anon_vma_fork(struct vm_area_struct 
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
@@ -265,8 +271,11 @@ static void anon_vma_unlink(struct anon_
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
@@ -1398,6 +1407,40 @@ int try_to_munlock(struct page *page)
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

mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-track-the-root-oldest-anon_vma-fix.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch

