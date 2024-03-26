Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2D1FC0E
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711484358; cv=none; b=hvqeZEyiggkgzg1lw2RotHz4VmXK3IwlFwkE4AYUXFZhe/TsV/aoUkdyfPtBc0HKEVKu+FndlJd5nuGw/86kmBwfk57h0tNkGDAybBsGSjvFtSTz9aF842oALHS6LhyW0CxORiUsUxuGz1ceO7ypzCGDrlFG9qm+NozKdi6FKtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711484358; c=relaxed/simple;
	bh=zTrcjDrbepXA3xb2ep0BnMcW+c7fkcmFjfRmFCyuo3s=;
	h=Date:To:From:Subject:Message-Id; b=QTJBJGLb4kIvGkH/GBESHr1TKsQIq8Kpj4YKTEML2mPXpqY676/kYuBSFG8n6RoTbcchw/IwQwMCG+9t+6hoatC2r5iHWoRGPcBKfdqOFGjYw/bWQzB9iOhXyeTZZJ5oGOxjt9Lb62UMj8AlItb21nBRaoU1nr1M+lCM4Cu8E0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z7Z4Wqk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z7Z4Wqk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40584C43390;
	Tue, 26 Mar 2024 20:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711484358;
	bh=zTrcjDrbepXA3xb2ep0BnMcW+c7fkcmFjfRmFCyuo3s=;
	h=Date:To:From:Subject:From;
	b=z7Z4Wqk1UL5Njdoag7jOvX7OgG1Ac31olmKFSMKik8bNYJCfAVvROsiZ2j4rUHH7e
	 /p1tlSXC7aJTPPEg+wtOkY58Tk/I14GHKyfPMFGmUIiQanogZL02aXJTYAsxCIWS7I
	 RZUCWdWU2sCg9L//J8ZswLcmEtd5jcWvr6qAZwCY=
Date: Tue, 26 Mar 2024 13:19:17 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-replace-rb-tree-with-xarray.patch added to mm-unstable branch
Message-Id: <20240326201918.40584C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zswap: replace RB tree with xarray
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-replace-rb-tree-with-xarray.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-replace-rb-tree-with-xarray.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chris Li <chrisl@kernel.org>
Subject: zswap: replace RB tree with xarray
Date: Tue, 26 Mar 2024 11:35:43 -0700

Very deep RB tree requires rebalance at times.  That contributes to the
zswap fault latencies.  Xarray does not need to perform tree rebalance. 
Replacing RB tree to xarray can have some small performance gain.

One small difference is that xarray insert might fail with ENOMEM, while
RB tree insert does not allocate additional memory.

The zswap_entry size will reduce a bit due to removing the RB node, which
has two pointers and a color field.  Xarray store the pointer in the
xarray tree rather than the zswap_entry.  Every entry has one pointer from
the xarray tree.  Overall, switching to xarray should save some memory, if
the swap entries are densely packed.

Notice the zswap_rb_search and zswap_rb_insert often followed by
zswap_rb_erase.  Use xa_erase and xa_store directly.  That saves one tree
lookup as well.

Remove zswap_invalidate_entry due to no need to call zswap_rb_erase any
more.  Use zswap_free_entry instead.

The "struct zswap_tree" has been replaced by "struct xarray".  The tree
spin lock has transferred to the xarray lock.

Run the kernel build testing 5 times for each version, averages:
(memory.max=2GB, zswap shrinker and writeback enabled, one 50GB swapfile,
24 HT core, 32 jobs)

           mm-unstable-4aaccadb5c04     xarray v9
user       3548.902 			3534.375
sys        522.232                      520.976
real       202.796                      200.864

Link: https://lkml.kernel.org/r/20240326-zswap-xarray-v9-1-d2891a65dfc7@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  185 +++++++++++++++------------------------------------
 1 file changed, 58 insertions(+), 127 deletions(-)

--- a/mm/zswap.c~zswap-replace-rb-tree-with-xarray
+++ a/mm/zswap.c
@@ -20,7 +20,6 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/atomic.h>
-#include <linux/rbtree.h>
 #include <linux/swap.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
@@ -194,7 +193,6 @@ static struct shrinker *zswap_shrinker;
  * This structure contains the metadata for tracking a single compressed
  * page within zswap.
  *
- * rbnode - links the entry into red-black tree for the appropriate swap type
  * swpentry - associated swap entry, the offset indexes into the red-black tree
  * length - the length in bytes of the compressed page data.  Needed during
  *          decompression. For a same value filled page length is 0, and both
@@ -206,7 +204,6 @@ static struct shrinker *zswap_shrinker;
  * lru - handle to the pool's lru used to evict pages.
  */
 struct zswap_entry {
-	struct rb_node rbnode;
 	swp_entry_t swpentry;
 	unsigned int length;
 	struct zswap_pool *pool;
@@ -218,12 +215,7 @@ struct zswap_entry {
 	struct list_head lru;
 };
 
-struct zswap_tree {
-	struct rb_root rbroot;
-	spinlock_t lock;
-};
-
-static struct zswap_tree *zswap_trees[MAX_SWAPFILES];
+static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
 /* RCU-protected iteration */
@@ -251,7 +243,7 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
-static inline struct zswap_tree *swap_zswap_tree(swp_entry_t swp)
+static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 {
 	return &zswap_trees[swp_type(swp)][swp_offset(swp)
 		>> SWAP_ADDRESS_SPACE_SHIFT];
@@ -791,63 +783,6 @@ void zswap_memcg_offline_cleanup(struct
 }
 
 /*********************************
-* rbtree functions
-**********************************/
-static struct zswap_entry *zswap_rb_search(struct rb_root *root, pgoff_t offset)
-{
-	struct rb_node *node = root->rb_node;
-	struct zswap_entry *entry;
-	pgoff_t entry_offset;
-
-	while (node) {
-		entry = rb_entry(node, struct zswap_entry, rbnode);
-		entry_offset = swp_offset(entry->swpentry);
-		if (entry_offset > offset)
-			node = node->rb_left;
-		else if (entry_offset < offset)
-			node = node->rb_right;
-		else
-			return entry;
-	}
-	return NULL;
-}
-
-/*
- * In the case that a entry with the same offset is found, a pointer to
- * the existing entry is stored in dupentry and the function returns -EEXIST
- */
-static int zswap_rb_insert(struct rb_root *root, struct zswap_entry *entry,
-			struct zswap_entry **dupentry)
-{
-	struct rb_node **link = &root->rb_node, *parent = NULL;
-	struct zswap_entry *myentry;
-	pgoff_t myentry_offset, entry_offset = swp_offset(entry->swpentry);
-
-	while (*link) {
-		parent = *link;
-		myentry = rb_entry(parent, struct zswap_entry, rbnode);
-		myentry_offset = swp_offset(myentry->swpentry);
-		if (myentry_offset > entry_offset)
-			link = &(*link)->rb_left;
-		else if (myentry_offset < entry_offset)
-			link = &(*link)->rb_right;
-		else {
-			*dupentry = myentry;
-			return -EEXIST;
-		}
-	}
-	rb_link_node(&entry->rbnode, parent, link);
-	rb_insert_color(&entry->rbnode, root);
-	return 0;
-}
-
-static void zswap_rb_erase(struct rb_root *root, struct zswap_entry *entry)
-{
-	rb_erase(&entry->rbnode, root);
-	RB_CLEAR_NODE(&entry->rbnode);
-}
-
-/*********************************
 * zswap entry functions
 **********************************/
 static struct kmem_cache *zswap_entry_cache;
@@ -858,7 +793,6 @@ static struct zswap_entry *zswap_entry_c
 	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
 	if (!entry)
 		return NULL;
-	RB_CLEAR_NODE(&entry->rbnode);
 	return entry;
 }
 
@@ -893,17 +827,6 @@ static void zswap_entry_free(struct zswa
 	atomic_dec(&zswap_stored_pages);
 }
 
-/*
- * The caller hold the tree lock and search the entry from the tree,
- * so it must be on the tree, remove it from the tree and free it.
- */
-static void zswap_invalidate_entry(struct zswap_tree *tree,
-				   struct zswap_entry *entry)
-{
-	zswap_rb_erase(&tree->rbroot, entry);
-	zswap_entry_free(entry);
-}
-
 /*********************************
 * compressed storage functions
 **********************************/
@@ -1103,7 +1026,8 @@ static void zswap_decompress(struct zswa
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
-	struct zswap_tree *tree;
+	struct xarray *tree;
+	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
@@ -1140,19 +1064,13 @@ static int zswap_writeback_entry(struct
 	 * be dereferenced.
 	 */
 	tree = swap_zswap_tree(swpentry);
-	spin_lock(&tree->lock);
-	if (zswap_rb_search(&tree->rbroot, swp_offset(swpentry)) != entry) {
-		spin_unlock(&tree->lock);
+	if (entry != xa_cmpxchg(tree, offset, entry, NULL, GFP_KERNEL)) {
 		delete_from_swap_cache(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 		return -ENOMEM;
 	}
 
-	/* Safe to deref entry after the entry is verified above. */
-	zswap_rb_erase(&tree->rbroot, entry);
-	spin_unlock(&tree->lock);
-
 	zswap_decompress(entry, &folio->page);
 
 	count_vm_event(ZSWPWB);
@@ -1477,8 +1395,8 @@ bool zswap_store(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
 	pgoff_t offset = swp_offset(swp);
-	struct zswap_tree *tree = swap_zswap_tree(swp);
-	struct zswap_entry *entry, *dupentry;
+	struct xarray *tree = swap_zswap_tree(swp);
+	struct zswap_entry *entry, *old;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
 	unsigned long max_pages, cur_pages;
@@ -1566,27 +1484,43 @@ bool zswap_store(struct folio *folio)
 insert_entry:
 	entry->swpentry = swp;
 	entry->objcg = objcg;
+
+	old = xa_store(tree, offset, entry, GFP_KERNEL);
+	if (xa_is_err(old)) {
+		int err = xa_err(old);
+
+		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
+		zswap_reject_alloc_fail++;
+		goto store_failed;
+	}
+
+	/*
+	 * We may have had an existing entry that became stale when
+	 * the folio was redirtied and now the new version is being
+	 * swapped out. Get rid of the old.
+	 */
+	if (old)
+		zswap_entry_free(old);
+
 	if (objcg) {
 		obj_cgroup_charge_zswap(objcg, entry->length);
-		/* Account before objcg ref is moved to tree */
 		count_objcg_event(objcg, ZSWPOUT);
 	}
 
-	/* map */
-	spin_lock(&tree->lock);
 	/*
-	 * The folio may have been dirtied again, invalidate the
-	 * possibly stale entry before inserting the new entry.
+	 * We finish initializing the entry while it's already in xarray.
+	 * This is safe because:
+	 *
+	 * 1. Concurrent stores and invalidations are excluded by folio lock.
+	 *
+	 * 2. Writeback is excluded by the entry not being on the LRU yet.
+	 *    The publishing order matters to prevent writeback from seeing
+	 *    an incoherent entry.
 	 */
-	if (zswap_rb_insert(&tree->rbroot, entry, &dupentry) == -EEXIST) {
-		zswap_invalidate_entry(tree, dupentry);
-		WARN_ON(zswap_rb_insert(&tree->rbroot, entry, &dupentry));
-	}
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
 		zswap_lru_add(&zswap_list_lru, entry);
 	}
-	spin_unlock(&tree->lock);
 
 	/* update stats */
 	atomic_inc(&zswap_stored_pages);
@@ -1594,8 +1528,14 @@ insert_entry:
 
 	return true;
 
+store_failed:
+	if (!entry->length)
+		atomic_dec(&zswap_same_filled_pages);
+	else {
+		zpool_free(zswap_find_zpool(entry), entry->handle);
 put_pool:
-	zswap_pool_put(entry->pool);
+		zswap_pool_put(entry->pool);
+	}
 freepage:
 	zswap_entry_cache_free(entry);
 reject:
@@ -1606,11 +1546,9 @@ check_old:
 	 * possibly stale entry which was previously stored at this offset.
 	 * Otherwise, writeback could overwrite the new data in the swapfile.
 	 */
-	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
+	entry = xa_erase(tree, offset);
 	if (entry)
-		zswap_invalidate_entry(tree, entry);
-	spin_unlock(&tree->lock);
+		zswap_entry_free(entry);
 	return false;
 
 shrink:
@@ -1624,20 +1562,14 @@ bool zswap_load(struct folio *folio)
 	pgoff_t offset = swp_offset(swp);
 	struct page *page = &folio->page;
 	bool swapcache = folio_test_swapcache(folio);
-	struct zswap_tree *tree = swap_zswap_tree(swp);
+	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 	u8 *dst;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
-	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
-	if (!entry) {
-		spin_unlock(&tree->lock);
-		return false;
-	}
 	/*
-	 * When reading into the swapcache, invalidate our entry. The
+	 * When reading into the swapcache, erase our entry. The
 	 * swapcache can be the authoritative owner of the page and
 	 * its mappings, and the pressure that results from having two
 	 * in-memory copies outweighs any benefits of caching the
@@ -1649,8 +1581,12 @@ bool zswap_load(struct folio *folio)
 	 * the fault fails. We remain the primary owner of the entry.)
 	 */
 	if (swapcache)
-		zswap_rb_erase(&tree->rbroot, entry);
-	spin_unlock(&tree->lock);
+		entry = xa_erase(tree, offset);
+	else
+		entry = xa_load(tree, offset);
+
+	if (!entry)
+		return false;
 
 	if (entry->length)
 		zswap_decompress(entry, page);
@@ -1675,19 +1611,17 @@ bool zswap_load(struct folio *folio)
 void zswap_invalidate(swp_entry_t swp)
 {
 	pgoff_t offset = swp_offset(swp);
-	struct zswap_tree *tree = swap_zswap_tree(swp);
+	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 
-	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
+	entry = xa_erase(tree, offset);
 	if (entry)
-		zswap_invalidate_entry(tree, entry);
-	spin_unlock(&tree->lock);
+		zswap_entry_free(entry);
 }
 
 int zswap_swapon(int type, unsigned long nr_pages)
 {
-	struct zswap_tree *trees, *tree;
+	struct xarray *trees, *tree;
 	unsigned int nr, i;
 
 	nr = DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
@@ -1697,11 +1631,8 @@ int zswap_swapon(int type, unsigned long
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < nr; i++) {
-		tree = trees + i;
-		tree->rbroot = RB_ROOT;
-		spin_lock_init(&tree->lock);
-	}
+	for (i = 0; i < nr; i++)
+		xa_init(trees + i);
 
 	nr_zswap_trees[type] = nr;
 	zswap_trees[type] = trees;
@@ -1710,7 +1641,7 @@ int zswap_swapon(int type, unsigned long
 
 void zswap_swapoff(int type)
 {
-	struct zswap_tree *trees = zswap_trees[type];
+	struct xarray *trees = zswap_trees[type];
 	unsigned int i;
 
 	if (!trees)
@@ -1718,7 +1649,7 @@ void zswap_swapoff(int type)
 
 	/* try_to_unuse() invalidated all the entries already */
 	for (i = 0; i < nr_zswap_trees[type]; i++)
-		WARN_ON_ONCE(!RB_EMPTY_ROOT(&trees[i].rbroot));
+		WARN_ON_ONCE(!xa_empty(trees + i));
 
 	kvfree(trees);
 	nr_zswap_trees[type] = 0;
_

Patches currently in -mm which might be from chrisl@kernel.org are

zswap-replace-rb-tree-with-xarray.patch

