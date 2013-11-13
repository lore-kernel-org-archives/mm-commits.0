From: akpm@linux-foundation.org
Subject: [merged] mm-zswap-refoctor-the-get-put-routines.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:39:32 -0800
Message-ID: <5283e384.8+lgNlaGv+iXxjfD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3KMUjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjennings@variantweb.net, minchan@kernel.org, bob.liu@oracle.com, weijie.yang@samsung.com

Subject: [merged] mm-zswap-refoctor-the-get-put-routines.patch removed from -mm tree
To: weijie.yang@samsung.com,bob.liu@oracle.com,minchan@kernel.org,sjennings@variantweb.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:32 -0800


The patch titled
     Subject: mm/zswap: refactor the get/put routines
has been removed from the -mm tree.  Its filename was
     mm-zswap-refoctor-the-get-put-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/zswap: refactor the get/put routines

The refcount routine was not fit the kernel get/put semantic exactly,
There were too many judgement statements on refcount and it could be
minus.

This patch does the following:

- move refcount judgement to zswap_entry_put() to hide resource free function.

- add a new function zswap_entry_find_get(), so that callers can use easily
in the following pattern:

   zswap_entry_find_get
   .../* do something */
   zswap_entry_put

- to eliminate compile error, move some functions declaration

This patch is based on Minchan Kim <minchan@kernel.org> 's idea and suggestion.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  182 ++++++++++++++++++++++++---------------------------
 1 file changed, 88 insertions(+), 94 deletions(-)

diff -puN mm/zswap.c~mm-zswap-refoctor-the-get-put-routines mm/zswap.c
--- a/mm/zswap.c~mm-zswap-refoctor-the-get-put-routines
+++ a/mm/zswap.c
@@ -217,6 +217,7 @@ static struct zswap_entry *zswap_entry_c
 	if (!entry)
 		return NULL;
 	entry->refcount = 1;
+	RB_CLEAR_NODE(&entry->rbnode);
 	return entry;
 }
 
@@ -225,19 +226,6 @@ static void zswap_entry_cache_free(struc
 	kmem_cache_free(zswap_entry_cache, entry);
 }
 
-/* caller must hold the tree lock */
-static void zswap_entry_get(struct zswap_entry *entry)
-{
-	entry->refcount++;
-}
-
-/* caller must hold the tree lock */
-static int zswap_entry_put(struct zswap_entry *entry)
-{
-	entry->refcount--;
-	return entry->refcount;
-}
-
 /*********************************
 * rbtree functions
 **********************************/
@@ -285,6 +273,61 @@ static int zswap_rb_insert(struct rb_roo
 	return 0;
 }
 
+static void zswap_rb_erase(struct rb_root *root, struct zswap_entry *entry)
+{
+	if (!RB_EMPTY_NODE(&entry->rbnode)) {
+		rb_erase(&entry->rbnode, root);
+		RB_CLEAR_NODE(&entry->rbnode);
+	}
+}
+
+/*
+ * Carries out the common pattern of freeing and entry's zsmalloc allocation,
+ * freeing the entry itself, and decrementing the number of stored pages.
+ */
+static void zswap_free_entry(struct zswap_tree *tree,
+			struct zswap_entry *entry)
+{
+	zbud_free(tree->pool, entry->handle);
+	zswap_entry_cache_free(entry);
+	atomic_dec(&zswap_stored_pages);
+	zswap_pool_pages = zbud_get_pool_size(tree->pool);
+}
+
+/* caller must hold the tree lock */
+static void zswap_entry_get(struct zswap_entry *entry)
+{
+	entry->refcount++;
+}
+
+/* caller must hold the tree lock
+* remove from the tree and free it, if nobody reference the entry
+*/
+static void zswap_entry_put(struct zswap_tree *tree,
+			struct zswap_entry *entry)
+{
+	int refcount = --entry->refcount;
+
+	BUG_ON(refcount < 0);
+	if (refcount == 0) {
+		zswap_rb_erase(&tree->rbroot, entry);
+		zswap_free_entry(tree, entry);
+	}
+}
+
+/* caller must hold the tree lock */
+static struct zswap_entry *zswap_entry_find_get(struct rb_root *root,
+				pgoff_t offset)
+{
+	struct zswap_entry *entry = NULL;
+
+	entry = zswap_rb_search(root, offset);
+	if (entry)
+		zswap_entry_get(entry);
+
+	return entry;
+}
+
 /*********************************
 * per-cpu code
 **********************************/
@@ -368,18 +411,6 @@ static bool zswap_is_full(void)
 		zswap_pool_pages);
 }
 
-/*
- * Carries out the common pattern of freeing and entry's zsmalloc allocation,
- * freeing the entry itself, and decrementing the number of stored pages.
- */
-static void zswap_free_entry(struct zswap_tree *tree, struct zswap_entry *entry)
-{
-	zbud_free(tree->pool, entry->handle);
-	zswap_entry_cache_free(entry);
-	atomic_dec(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(tree->pool);
-}
-
 /*********************************
 * writeback code
 **********************************/
@@ -503,7 +534,7 @@ static int zswap_writeback_entry(struct
 	struct page *page;
 	u8 *src, *dst;
 	unsigned int dlen;
-	int ret, refcount;
+	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
 	};
@@ -518,13 +549,12 @@ static int zswap_writeback_entry(struct
 
 	/* find and ref zswap entry */
 	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
+	entry = zswap_entry_find_get(&tree->rbroot, offset);
 	if (!entry) {
 		/* entry was invalidated */
 		spin_unlock(&tree->lock);
 		return 0;
 	}
-	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 	BUG_ON(offset != entry->offset);
 
@@ -566,42 +596,35 @@ static int zswap_writeback_entry(struct
 	zswap_written_back_pages++;
 
 	spin_lock(&tree->lock);
-
 	/* drop local reference */
-	zswap_entry_put(entry);
-	/* drop the initial reference from entry creation */
-	refcount = zswap_entry_put(entry);
+	zswap_entry_put(tree, entry);
 
 	/*
-	 * There are three possible values for refcount here:
-	 * (1) refcount is 1, load is in progress, unlink from rbtree,
-	 *     load will free
-	 * (2) refcount is 0, (normal case) entry is valid,
-	 *     remove from rbtree and free entry
-	 * (3) refcount is -1, invalidate happened during writeback,
-	 *     free entry
-	 */
-	if (refcount >= 0) {
-		/* no invalidate yet, remove from rbtree */
-		rb_erase(&entry->rbnode, &tree->rbroot);
-	}
+	* There are two possible situations for entry here:
+	* (1) refcount is 1(normal case),  entry is valid and on the tree
+	* (2) refcount is 0, entry is freed and not on the tree
+	*     because invalidate happened during writeback
+	*  search the tree and free the entry if find entry
+	*/
+	if (entry == zswap_rb_search(&tree->rbroot, offset))
+		zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
-	if (refcount <= 0) {
-		/* free the entry */
-		zswap_free_entry(tree, entry);
-		return 0;
-	}
-	return -EAGAIN;
 
+	goto end;
+
+	/*
+	* if we get here due to ZSWAP_SWAPCACHE_EXIST
+	* a load may happening concurrently
+	* it is safe and okay to not free the entry
+	* if we free the entry in the following put
+	* it it either okay to return !0
+	*/
 fail:
 	spin_lock(&tree->lock);
-	refcount = zswap_entry_put(entry);
-	if (refcount <= 0) {
-		/* invalidate happened, consider writeback as success */
-		zswap_free_entry(tree, entry);
-		ret = 0;
-	}
+	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
+
+end:
 	return ret;
 }
 
@@ -685,11 +708,8 @@ static int zswap_frontswap_store(unsigne
 		if (ret == -EEXIST) {
 			zswap_duplicate_entry++;
 			/* remove from rbtree */
-			rb_erase(&dupentry->rbnode, &tree->rbroot);
-			if (!zswap_entry_put(dupentry)) {
-				/* free */
-				zswap_free_entry(tree, dupentry);
-			}
+			zswap_rb_erase(&tree->rbroot, dupentry);
+			zswap_entry_put(tree, dupentry);
 		}
 	} while (ret == -EEXIST);
 	spin_unlock(&tree->lock);
@@ -718,17 +738,16 @@ static int zswap_frontswap_load(unsigned
 	struct zswap_entry *entry;
 	u8 *src, *dst;
 	unsigned int dlen;
-	int refcount, ret;
+	int ret;
 
 	/* find */
 	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
+	entry = zswap_entry_find_get(&tree->rbroot, offset);
 	if (!entry) {
 		/* entry was written back */
 		spin_unlock(&tree->lock);
 		return -1;
 	}
-	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 
 	/* decompress */
@@ -743,22 +762,9 @@ static int zswap_frontswap_load(unsigned
 	BUG_ON(ret);
 
 	spin_lock(&tree->lock);
-	refcount = zswap_entry_put(entry);
-	if (likely(refcount)) {
-		spin_unlock(&tree->lock);
-		return 0;
-	}
+	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
 
-	/*
-	 * We don't have to unlink from the rbtree because
-	 * zswap_writeback_entry() or zswap_frontswap_invalidate page()
-	 * has already done this for us if we are the last reference.
-	 */
-	/* free */
-
-	zswap_free_entry(tree, entry);
-
 	return 0;
 }
 
@@ -767,7 +773,6 @@ static void zswap_frontswap_invalidate_p
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
-	int refcount;
 
 	/* find */
 	spin_lock(&tree->lock);
@@ -779,20 +784,12 @@ static void zswap_frontswap_invalidate_p
 	}
 
 	/* remove from rbtree */
-	rb_erase(&entry->rbnode, &tree->rbroot);
+	zswap_rb_erase(&tree->rbroot, entry);
 
 	/* drop the initial reference from entry creation */
-	refcount = zswap_entry_put(entry);
+	zswap_entry_put(tree, entry);
 
 	spin_unlock(&tree->lock);
-
-	if (refcount) {
-		/* writeback in progress, writeback will free */
-		return;
-	}
-
-	/* free */
-	zswap_free_entry(tree, entry);
 }
 
 /* frees all zswap entries for the given swap type */
@@ -806,11 +803,8 @@ static void zswap_frontswap_invalidate_a
 
 	/* walk the tree and free everything */
 	spin_lock(&tree->lock);
-	rbtree_postorder_for_each_entry_safe(entry, n, &tree->rbroot, rbnode) {
-		zbud_free(tree->pool, entry->handle);
-		zswap_entry_cache_free(entry);
-		atomic_dec(&zswap_stored_pages);
-	}
+	rbtree_postorder_for_each_entry_safe(entry, n, &tree->rbroot, rbnode)
+		zswap_free_entry(tree, entry);
 	tree->rbroot = RB_ROOT;
 	spin_unlock(&tree->lock);
 
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

origin.patch

