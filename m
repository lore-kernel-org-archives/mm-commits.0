From: akpm@linux-foundation.org
Subject: [merged] mempool-drop-unnecessary-and-incorrect-bug_on-from-mempool_destroy.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:31 -0800
Message-ID: <20120111212832.0CB3720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54553 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab2AKV2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:33 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44236eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mempool: drop unnecessary and incorrect BUG_ON() from mempool_destroy()
has been removed from the -mm tree.  Its filename was
     mempool-drop-unnecessary-and-incorrect-bug_on-from-mempool_destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
