From: akpm@linux-foundation.org
Subject: + mempool-drop-unnecessary-and-incorrect-bug_on-from-mempool_destroy.patch added to -mm tree
Date: Wed, 21 Dec 2011 16:33:07 -0800
Message-ID: <20111222003308.8FE705C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49222 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1LVAdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2011 19:33:10 -0500
Received: by eaak10 with SMTP id k10so21169eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2011 16:33:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org


The patch titled
     Subject: mempool: drop unnecessary and incorrect BUG_ON() from mempool_destroy()
has been added to the -mm tree.  Its filename is
     mempool-drop-unnecessary-and-incorrect-bug_on-from-mempool_destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mempool: drop unnecessary and incorrect BUG_ON() from mempool_destroy()

mempool_destroy() is a thin wrapper around free_pool().  The only thing it
adds is BUG_ON(pool->curr_nr != pool->min_nr).  The intention seems to be
to enforce that all allocated elements are freed; however, the BUG_ON()
can't achieve that (it doesn't know anything about objects above min_nr)
and incorrect as mempool_resize() is allowed to leave the pool extended
but not filled.  Furthermore, panicking is way worse than any memory leak
and there are better debug tools to track memory leaks.

Drop the BUG_ON() from mempool_destory() and as that leaves the function
identical to free_pool(), replace it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff -puN mm/mempool.c~mempool-drop-unnecessary-and-incorrect-bug_on-from-mempool_destroy mm/mempool.c
--- a/mm/mempool.c~mempool-drop-unnecessary-and-incorrect-bug_on-from-mempool_destroy
+++ a/mm/mempool.c
@@ -27,7 +27,15 @@ static void *remove_element(mempool_t *p
 	return pool->elements[--pool->curr_nr];
 }
 
-static void free_pool(mempool_t *pool)
+/**
+ * mempool_destroy - deallocate a memory pool
+ * @pool:      pointer to the memory pool which was allocated via
+ *             mempool_create().
+ *
+ * Free all reserved elements in @pool and @pool itself.  This function
+ * only sleeps if the free_fn() function sleeps.
+ */
+void mempool_destroy(mempool_t *pool)
 {
 	while (pool->curr_nr) {
 		void *element = remove_element(pool);
@@ -36,6 +44,7 @@ static void free_pool(mempool_t *pool)
 	kfree(pool->elements);
 	kfree(pool);
 }
+EXPORT_SYMBOL(mempool_destroy);
 
 /**
  * mempool_create - create a memory pool
@@ -86,7 +95,7 @@ mempool_t *mempool_create_node(int min_n
 
 		element = pool->alloc(GFP_KERNEL, pool->pool_data);
 		if (unlikely(!element)) {
-			free_pool(pool);
+			mempool_destroy(pool);
 			return NULL;
 		}
 		add_element(pool, element);
@@ -172,23 +181,6 @@ out:
 EXPORT_SYMBOL(mempool_resize);
 
 /**
- * mempool_destroy - deallocate a memory pool
- * @pool:      pointer to the memory pool which was allocated via
- *             mempool_create().
- *
- * this function only sleeps if the free_fn() function sleeps. The caller
- * has to guarantee that all elements have been returned to the pool (ie:
- * freed) prior to calling mempool_destroy().
- */
-void mempool_destroy(mempool_t *pool)
-{
-	/* Check for outstanding elements */
-	BUG_ON(pool->curr_nr != pool->min_nr);
-	free_pool(pool);
-}
-EXPORT_SYMBOL(mempool_destroy);
-
-/**
  * mempool_alloc - allocate an element from a specific memory pool
  * @pool:      pointer to the memory pool which was allocated via
  *             mempool_create().
_
Subject: Subject: mempool: drop unnecessary and incorrect BUG_ON() from mempool_destroy()

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch
mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patch
mm-bootmem-try-harder-to-free-pages-in-bulk.patch
mempool-fix-and-document-synchronization-and-memory-barrier-usage.patch
mempool-drop-unnecessary-and-incorrect-bug_on-from-mempool_destroy.patch
mempool-fix-first-round-failure-behavior.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
sysctl-add-the-kernelns_last_pid-control.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

