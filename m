From: akpm@linux-foundation.org
Subject: [merged]
 list_lru-remove-special-case-function-list_lru_dispose_all.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 14:16:05 -0700
Message-ID: <52338095.OWsH71b2u9un9d0X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab3IMVQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:16:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, glommer@openvz.org, dchinner@redhat.com, glommer@gmail.com

Subject: [merged] list_lru-remove-special-case-function-list_lru_dispose_all.patch removed from -mm tree
To: glommer@gmail.com,dchinner@redhat.com,glommer@openvz.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:16:05 -0700


The patch titled
     Subject: list_lru: remove special case function list_lru_dispose_all.
has been removed from the -mm tree.  Its filename was
     list_lru-remove-special-case-function-list_lru_dispose_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@gmail.com>
Subject: list_lru: remove special case function list_lru_dispose_all.

The list_lru implementation has one function, list_lru_dispose_all, with
only one user (the dentry code).  At first, such function appears to make
sense because we are really not interested in the result of isolating each
dentry separately - all of them are going away anyway.  However, it's
implementation is buggy in the following way:

When we call list_lru_dispose_all in fs/dcache.c, we scan all dentries
marking them with DCACHE_SHRINK_LIST.  However, this is done without the
nlru->lock taken.  The imediate result of that is that someone else may
add or remove the dentry from the LRU at the same time.  When list_lru_del
happens in that scenario we will see an element that is not yet marked
with DCACHE_SHRINK_LIST (even though it will be in the future) and
obviously remove it from an lru where the element no longer is.  Since
list_lru_dispose_all will in effect count down nlru's nr_items and
list_lru_del will do the same, this will lead to an imbalance.

The solution for this would not be so simple: we can obviously just keep
the lru_lock taken, but then we have no guarantees that we will be able to
acquire the dentry lock (dentry->d_lock).  To properly solve this, we need
a communication mechanism between the lru and dentry code, so they can
coordinate this with each other.

Such mechanism already exists in the form of the list_lru_walk_cb
callback.  So it is possible to construct a dcache-side prune function
that does the right thing only by calling list_lru_walk in a loop until no
more dentries are available.

With only one user, plus the fact that a sane solution for the problem
would involve boucing between dcache and list_lru anyway, I see little
justification to keep the special case list_lru_dispose_all in tree.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Michal Hocko <mhocko@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c              |   49 +++++++++++++++++++++----------------
 include/linux/list_lru.h |   17 ------------
 mm/list_lru.c            |   42 -------------------------------
 3 files changed, 29 insertions(+), 79 deletions(-)

diff -puN fs/dcache.c~list_lru-remove-special-case-function-list_lru_dispose_all fs/dcache.c
--- a/fs/dcache.c~list_lru-remove-special-case-function-list_lru_dispose_all
+++ a/fs/dcache.c
@@ -911,27 +911,29 @@ long prune_dcache_sb(struct super_block
 	return freed;
 }
 
-/*
- * Mark all the dentries as on being the dispose list so we don't think they are
- * still on the LRU if we try to kill them from ascending the parent chain in
- * try_prune_one_dentry() rather than directly from the dispose list.
- */
-static void
-shrink_dcache_list(
-	struct list_head *dispose)
+static enum lru_status dentry_lru_isolate_shrink(struct list_head *item,
+						spinlock_t *lru_lock, void *arg)
 {
-	struct dentry *dentry;
+	struct list_head *freeable = arg;
+	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
+
+	/*
+	 * we are inverting the lru lock/dentry->d_lock here,
+	 * so use a trylock. If we fail to get the lock, just skip
+	 * it
+	 */
+	if (!spin_trylock(&dentry->d_lock))
+		return LRU_SKIP;
+
+	dentry->d_flags |= DCACHE_SHRINK_LIST;
+	list_move_tail(&dentry->d_lru, freeable);
+	this_cpu_dec(nr_dentry_unused);
+	spin_unlock(&dentry->d_lock);
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(dentry, dispose, d_lru) {
-		spin_lock(&dentry->d_lock);
-		dentry->d_flags |= DCACHE_SHRINK_LIST;
-		spin_unlock(&dentry->d_lock);
-	}
-	rcu_read_unlock();
-	shrink_dentry_list(dispose);
+	return LRU_REMOVED;
 }
 
+
 /**
  * shrink_dcache_sb - shrink dcache for a superblock
  * @sb: superblock
@@ -941,10 +943,17 @@ shrink_dcache_list(
  */
 void shrink_dcache_sb(struct super_block *sb)
 {
-	long disposed;
+	long freed;
+
+	do {
+		LIST_HEAD(dispose);
+
+		freed = list_lru_walk(&sb->s_dentry_lru,
+			dentry_lru_isolate_shrink, &dispose, UINT_MAX);
 
-	disposed = list_lru_dispose_all(&sb->s_dentry_lru, shrink_dcache_list);
-	this_cpu_sub(nr_dentry_unused, disposed);
+		this_cpu_sub(nr_dentry_unused, freed);
+		shrink_dentry_list(&dispose);
+	} while (freed > 0);
 }
 EXPORT_SYMBOL(shrink_dcache_sb);
 
diff -puN include/linux/list_lru.h~list_lru-remove-special-case-function-list_lru_dispose_all include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-remove-special-case-function-list_lru_dispose_all
+++ a/include/linux/list_lru.h
@@ -137,21 +137,4 @@ list_lru_walk(struct list_lru *lru, list
 	}
 	return isolated;
 }
-
-typedef void (*list_lru_dispose_cb)(struct list_head *dispose_list);
-/**
- * list_lru_dispose_all: forceably flush all elements in an @lru
- * @lru: the lru pointer
- * @dispose: callback function to be called for each lru list.
- *
- * This function will forceably isolate all elements into the dispose list, and
- * call the @dispose callback to flush the list. Please note that the callback
- * should expect items in any state, clean or dirty, and be able to flush all of
- * them.
- *
- * Return value: how many objects were freed. It should be equal to all objects
- * in the list_lru.
- */
-unsigned long
-list_lru_dispose_all(struct list_lru *lru, list_lru_dispose_cb dispose);
 #endif /* _LRU_LIST_H */
diff -puN mm/list_lru.c~list_lru-remove-special-case-function-list_lru_dispose_all mm/list_lru.c
--- a/mm/list_lru.c~list_lru-remove-special-case-function-list_lru_dispose_all
+++ a/mm/list_lru.c
@@ -112,48 +112,6 @@ restart:
 }
 EXPORT_SYMBOL_GPL(list_lru_walk_node);
 
-static unsigned long list_lru_dispose_all_node(struct list_lru *lru, int nid,
-					       list_lru_dispose_cb dispose)
-{
-	struct list_lru_node	*nlru = &lru->node[nid];
-	LIST_HEAD(dispose_list);
-	unsigned long disposed = 0;
-
-	spin_lock(&nlru->lock);
-	while (!list_empty(&nlru->list)) {
-		list_splice_init(&nlru->list, &dispose_list);
-		disposed += nlru->nr_items;
-		nlru->nr_items = 0;
-		node_clear(nid, lru->active_nodes);
-		spin_unlock(&nlru->lock);
-
-		dispose(&dispose_list);
-
-		spin_lock(&nlru->lock);
-	}
-	spin_unlock(&nlru->lock);
-	return disposed;
-}
-
-unsigned long list_lru_dispose_all(struct list_lru *lru,
-				   list_lru_dispose_cb dispose)
-{
-	unsigned long disposed;
-	unsigned long total = 0;
-	int nid;
-
-	do {
-		disposed = 0;
-		for_each_node_mask(nid, lru->active_nodes) {
-			disposed += list_lru_dispose_all_node(lru, nid,
-							      dispose);
-		}
-		total += disposed;
-	} while (disposed != 0);
-
-	return total;
-}
