Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3595D8E0
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 20:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711398957; cv=none; b=EpeluZ9YW18G+5m08H3kpAEew5O1/W++mA84foaayGayEYyamK5kehnJyVet1nuaeWI9u8nXYylhX7zdGd99p2/JwiqOlEoYSlGLLQamybJSHMIJCY8B7A2fRi9SeWUdPM1po7T8ZpzsynVGS8Fb/omicTp+ww4EDKNrcMP+zS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711398957; c=relaxed/simple;
	bh=YpPflfKVHfU1kSLLV6W5X4ul4n6Q37X53HrI+dc+ygc=;
	h=Date:To:From:Subject:Message-Id; b=n/4WzMZwYELD46Lt84LNsrBm7TsKStpujPc9hkxFxHBgRrYqGUPiiHKTI5zmniO2NPsPTUBMQNzBD5vTdciOMVOvaMpYkeOGk0j5Mt/wMfMCXEa01ymY68FxUEIvSAc19xy2JqshWmSlQ7QK0MxOCdwJWjysoILWfBe8wZqk7DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FfrT2Gkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FfrT2Gkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8197C433C7;
	Mon, 25 Mar 2024 20:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711398957;
	bh=YpPflfKVHfU1kSLLV6W5X4ul4n6Q37X53HrI+dc+ygc=;
	h=Date:To:From:Subject:From;
	b=FfrT2GklBTvGLOKguUzVVIdZ+Y4JZyn2k5AVSpOvkb+D9PNhUooBGsVcF6GHpn7dS
	 pCSFzr0T6lwkpoFiy8FDUmaQF3d1upjNq2XQatKKPnwBHGDsnBq+Z/gDWTw5uYO20x
	 Od9wHZdifnnei5kA3ByJNU+LA/VQsSwn8qn73EtE=
Date: Mon, 25 Mar 2024 13:35:56 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zswap-replace-rb-tree-with-xarray.patch removed from -mm tree
Message-Id: <20240325203556.E8197C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zswap: replace RB tree with xarray
has been removed from the -mm tree.  Its filename was
     zswap-replace-rb-tree-with-xarray.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chris Li <chrisl@kernel.org>
Subject: zswap: replace RB tree with xarray
Date: Wed, 20 Mar 2024 12:31:38 -0700

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

Notice the zswap_rb_search and zswap_rb_insert always followed by
zswap_rb_erase.  Use xa_erase and xa_store directly.  That saves one tree
lookup as well.

Remove zswap_invalidate_entry due to no need to call zswap_rb_erase any
more.  Use zswap_free_entry instead.

The "struct zswap_tree" has been replaced by "struct xarray".  The tree
spin lock has transferred to the xarray lock.

Run the kernel build testing 10 times for each version, averages:
(memory.max=2GB, zswap shrinker and writeback enabled, one 50GB swapfile,
24 HT core, 32 jobs)

           mm-unstable-a824831a082f     xarray v7
user       3547.264			3541.509
sys        531.176                      526.111
real       200.752                      201.334

Link: https://lkml.kernel.org/r/20240320-zswap-xarray-v8-1-dc08ee9f8744@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  178 +++++++++++++++------------------------------------
 1 file changed, 53 insertions(+), 125 deletions(-)

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
@@ -196,7 +195,6 @@ static struct shrinker *zswap_shrinker;
  * This structure contains the metadata for tracking a single compressed
  * page within zswap.
  *
- * rbnode - links the entry into red-black tree for the appropriate swap type
  * swpentry - associated swap entry, the offset indexes into the red-black tree
  * length - the length in bytes of the compressed page data.  Needed during
  *          decompression. For a same value filled page length is 0, and both
@@ -208,7 +206,6 @@ static struct shrinker *zswap_shrinker;
  * lru - handle to the pool's lru used to evict pages.
  */
 struct zswap_entry {
-	struct rb_node rbnode;
 	swp_entry_t swpentry;
 	unsigned int length;
 	struct zswap_pool *pool;
@@ -220,12 +217,7 @@ struct zswap_entry {
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
@@ -253,7 +245,7 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
-static inline struct zswap_tree *swap_zswap_tree(swp_entry_t swp)
+static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 {
 	return &zswap_trees[swp_type(swp)][swp_offset(swp)
 		>> SWAP_ADDRESS_SPACE_SHIFT];
@@ -793,63 +785,6 @@ void zswap_memcg_offline_cleanup(struct
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
@@ -860,7 +795,6 @@ static struct zswap_entry *zswap_entry_c
 	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
 	if (!entry)
 		return NULL;
-	RB_CLEAR_NODE(&entry->rbnode);
 	return entry;
 }
 
@@ -896,17 +830,6 @@ static void zswap_entry_free(struct zswa
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
@@ -1106,7 +1029,8 @@ static void zswap_decompress(struct zswa
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
-	struct zswap_tree *tree;
+	struct xarray *tree;
+	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
@@ -1143,19 +1067,13 @@ static int zswap_writeback_entry(struct
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
@@ -1475,8 +1393,8 @@ bool zswap_store(struct folio *folio)
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
@@ -1564,28 +1482,44 @@ bool zswap_store(struct folio *folio)
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
 		atomic_inc(&zswap_nr_stored);
 	}
-	spin_unlock(&tree->lock);
 
 	/* update stats */
 	atomic_inc(&zswap_stored_pages);
@@ -1593,8 +1527,14 @@ insert_entry:
 
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
@@ -1605,11 +1545,9 @@ check_old:
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
@@ -1622,20 +1560,15 @@ bool zswap_load(struct folio *folio)
 	swp_entry_t swp = folio->swap;
 	pgoff_t offset = swp_offset(swp);
 	struct page *page = &folio->page;
-	struct zswap_tree *tree = swap_zswap_tree(swp);
+	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 	u8 *dst;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
-	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
-	if (!entry) {
-		spin_unlock(&tree->lock);
+	entry = xa_erase(tree, offset);
+	if (!entry)
 		return false;
-	}
-	zswap_rb_erase(&tree->rbroot, entry);
-	spin_unlock(&tree->lock);
 
 	if (entry->length)
 		zswap_decompress(entry, page);
@@ -1659,19 +1592,17 @@ bool zswap_load(struct folio *folio)
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
@@ -1681,11 +1612,8 @@ int zswap_swapon(int type, unsigned long
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
@@ -1694,7 +1622,7 @@ int zswap_swapon(int type, unsigned long
 
 void zswap_swapoff(int type)
 {
-	struct zswap_tree *trees = zswap_trees[type];
+	struct xarray *trees = zswap_trees[type];
 	unsigned int i;
 
 	if (!trees)
@@ -1702,7 +1630,7 @@ void zswap_swapoff(int type)
 
 	/* try_to_unuse() invalidated all the entries already */
 	for (i = 0; i < nr_zswap_trees[type]; i++)
-		WARN_ON_ONCE(!RB_EMPTY_ROOT(&trees[i].rbroot));
+		WARN_ON_ONCE(!xa_empty(trees + i));
 
 	kvfree(trees);
 	nr_zswap_trees[type] = 0;
_

Patches currently in -mm which might be from chrisl@kernel.org are


