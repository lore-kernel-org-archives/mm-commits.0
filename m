From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently.patch removed from -mm tree
Date: Mon, 14 Oct 2013 15:15:38 -0700
Message-ID: <525c6d0a.EKJX+YpHx30rQJzq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab3JNWPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Oct 2013 18:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, sjenning@linux.vnet.ibm.com, minchan@kernel.org, bob.liu@oracle.com, weijie.yang@samsung.com

Subject: [to-be-updated] mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently.patch removed from -mm tree
To: weijie.yang@samsung.com,bob.liu@oracle.com,minchan@kernel.org,sjenning@linux.vnet.ibm.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 14 Oct 2013 15:15:38 -0700


The patch titled
     Subject: mm/zswap: bugfix: memory leak when invalidate and reclaim occur concurrently
has been removed from the -mm tree.  Its filename was
     mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/zswap: bugfix: memory leak when invalidate and reclaim occur concurrently

Consider the following scenario:

thread 0: reclaim entry x (get refcount, but not call
          zswap_get_swap_cache_page)

thread 1: call zswap_frontswap_invalidate_page to invalidate
          entry x.  finished, entry x and its zbud is not freed as its
          refcount != 0 now, the swap_map[x] = 0

thread 0: now call zswap_get_swap_cache_page swapcache_prepare
          return -ENOENT because entry x is not used any more
          zswap_get_swap_cache_page return ZSWAP_SWAPCACHE_NOMEM
          zswap_writeback_entry do nothing except put refcount

Now, the memory of zswap_entry x and its zpage leak.

Modify:
 - check the refcount in fail path, free memory if it is not referenced.
 - use ZSWAP_SWAPCACHE_FAIL instead of ZSWAP_SWAPCACHE_NOMEM as the fail path
can be not only caused by nomem but also by invalidate.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  116 ++++++++++++++++++++++-----------------------------
 1 file changed, 52 insertions(+), 64 deletions(-)

diff -puN mm/zswap.c~mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently mm/zswap.c
--- a/mm/zswap.c~mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently
+++ a/mm/zswap.c
@@ -217,6 +217,7 @@ static struct zswap_entry *zswap_entry_c
 	if (!entry)
 		return NULL;
 	entry->refcount = 1;
+	RB_CLEAR_NODE(&entry->rbnode);
 	return entry;
 }
 
@@ -232,10 +233,20 @@ static void zswap_entry_get(struct zswap
 }
 
 /* caller must hold the tree lock */
-static int zswap_entry_put(struct zswap_entry *entry)
+static int zswap_entry_put(struct zswap_tree *tree, struct zswap_entry *entry)
 {
-	entry->refcount--;
-	return entry->refcount;
+	int refcount = --entry->refcount;
+
+	if (refcount <= 0) {
+		if (!RB_EMPTY_NODE(&entry->rbnode)) {
+			rb_erase(&entry->rbnode, &tree->rbroot);
+			RB_CLEAR_NODE(&entry->rbnode);
+		}
+
+		zswap_free_entry(tree, entry);
+	}
+
+	return refcount;
 }
 
 /*********************************
@@ -258,6 +269,17 @@ static struct zswap_entry *zswap_rb_sear
 	return NULL;
 }
 
+static struct zswap_entry *zswap_entry_find_get(struct rb_root *root, pgoff_t offset)
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
 /*
  * In the case that a entry with the same offset is found, a pointer to
  * the existing entry is stored in dupentry and the function returns -EEXIST
@@ -387,7 +409,7 @@ static void zswap_free_entry(struct zswa
 enum zswap_get_swap_ret {
 	ZSWAP_SWAPCACHE_NEW,
 	ZSWAP_SWAPCACHE_EXIST,
-	ZSWAP_SWAPCACHE_NOMEM
+	ZSWAP_SWAPCACHE_FAIL,
 };
 
 /*
@@ -401,9 +423,9 @@ enum zswap_get_swap_ret {
  * added to the swap cache, and returned in retpage.
  *
  * If success, the swap cache page is returned in retpage
- * Returns 0 if page was already in the swap cache, page is not locked
- * Returns 1 if the new page needs to be populated, page is locked
- * Returns <0 on error
+ * Returns ZSWAP_SWAPCACHE_EXIST if page was already in the swap cache
+ * Returns ZSWAP_SWAPCACHE_NEW if the new page needs to be populated, page is locked
+ * Returns ZSWAP_SWAPCACHE_FAIL on error
  */
 static int zswap_get_swap_cache_page(swp_entry_t entry,
 				struct page **retpage)
@@ -475,7 +497,7 @@ static int zswap_get_swap_cache_page(swp
 	if (new_page)
 		page_cache_release(new_page);
 	if (!found_page)
-		return ZSWAP_SWAPCACHE_NOMEM;
+		return ZSWAP_SWAPCACHE_FAIL;
 	*retpage = found_page;
 	return ZSWAP_SWAPCACHE_EXIST;
 }
@@ -517,23 +539,22 @@ static int zswap_writeback_entry(struct
 
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
 
 	/* try to allocate swap cache page */
 	switch (zswap_get_swap_cache_page(swpentry, &page)) {
-	case ZSWAP_SWAPCACHE_NOMEM: /* no memory */
+	case ZSWAP_SWAPCACHE_FAIL: /* no memory or invalidate happened */
 		ret = -ENOMEM;
 		goto fail;
 
-	case ZSWAP_SWAPCACHE_EXIST: /* page is unlocked */
+	case ZSWAP_SWAPCACHE_EXIST:
 		/* page is already in the swap cache, ignore for now */
 		page_cache_release(page);
 		ret = -EEXIST;
@@ -562,38 +583,28 @@ static int zswap_writeback_entry(struct
 	zswap_written_back_pages++;
 
 	spin_lock(&tree->lock);
-
 	/* drop local reference */
-	zswap_entry_put(entry);
+	refcount = zswap_entry_put(tree, entry);
 	/* drop the initial reference from entry creation */
-	refcount = zswap_entry_put(entry);
-
-	/*
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
+	if (refcount > 0) {
 		rb_erase(&entry->rbnode, &tree->rbroot);
+		RB_CLEAR_NODE(&entry->rbnode);
+		refcount = zswap_entry_put(tree, entry);
 	}
 	spin_unlock(&tree->lock);
-	if (refcount <= 0) {
-		/* free the entry */
-		zswap_free_entry(tree, entry);
-		return 0;
-	}
-	return -EAGAIN;
+
+	goto end;
 
 fail:
 	spin_lock(&tree->lock);
-	zswap_entry_put(entry);
+	refcount = zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
-	return ret;
+
+end:
+	if (refcount <= 0)
+		return 0;
+	else
+		return -EAGAIN;
 }
 
 /*********************************
@@ -677,10 +688,8 @@ static int zswap_frontswap_store(unsigne
 			zswap_duplicate_entry++;
 			/* remove from rbtree */
 			rb_erase(&dupentry->rbnode, &tree->rbroot);
-			if (!zswap_entry_put(dupentry)) {
-				/* free */
-				zswap_free_entry(tree, dupentry);
-			}
+			RB_CLEAR_NODE(&dupentry->rbnode);
+			zswap_entry_put(tree, dupentry);
 		}
 	} while (ret == -EEXIST);
 	spin_unlock(&tree->lock);
@@ -713,13 +722,12 @@ static int zswap_frontswap_load(unsigned
 
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
@@ -734,22 +742,9 @@ static int zswap_frontswap_load(unsigned
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
 
@@ -771,19 +766,12 @@ static void zswap_frontswap_invalidate_p
 
 	/* remove from rbtree */
 	rb_erase(&entry->rbnode, &tree->rbroot);
+	RB_CLEAR_NODE(&entry->rbnode);
 
 	/* drop the initial reference from entry creation */
-	refcount = zswap_entry_put(entry);
+	zswap_entry_put(tree, entry);
 
 	spin_unlock(&tree->lock);
-
-	if (refcount) {
-		/* writeback in progress, writeback will free */
-		return;
-	}
