From: akpm@linux-foundation.org
Subject: [merged] mm-zswap-support-multiple-swap-devices.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:13:36 -0700
Message-ID: <53446680.mdnxG3OiW7BvD7nG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbaDHVNh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:13:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang.kh@gmail.com, sjennings@variantweb.net, cai.liu@samsung.com, bob.liu@oracle.com, minchan@kernel.org

Subject: [merged] mm-zswap-support-multiple-swap-devices.patch removed from -mm tree
To: minchan@kernel.org,bob.liu@oracle.com,cai.liu@samsung.com,sjennings@variantweb.net,weijie.yang.kh@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:13:36 -0700


The patch titled
     Subject: mm/zswap: support multiple swap devices
has been removed from the -mm tree.  Its filename was
     mm-zswap-support-multiple-swap-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/zswap: support multiple swap devices

Cai Liu reporeted that now zbud pool pages counting has a problem when
multiple swap is used because it just counts only one swap intead of all
of swap so zswap cannot control writeback properly.  The result is
unnecessary writeback or no writeback when we should really writeback.

IOW, it made zswap crazy.

Another problem in zswap is:

For example, let's assume we use two swap A and B with different priority
and A already has charged 19% long time ago and let's assume that A swap
is full now so VM start to use B so that B has charged 1% recently.  It
menas zswap charged (19% + 1%) is full by default.  Then, if VM want to
swap out more pages into B, zbud_reclaim_page would be evict one of pages
in B's pool and it would be repeated continuously.  It's totally LRU
reverse problem and swap thrashing in B would happen.

This patch makes zswap consider mutliple swap by creating *a* zbud pool
which will be shared by multiple swap so all of zswap pages in multiple
swap keep order by LRU so it can prevent above two problems.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Cai Liu <cai.liu@samsung.com>
Suggested-by: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   64 ++++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff -puN mm/zswap.c~mm-zswap-support-multiple-swap-devices mm/zswap.c
--- a/mm/zswap.c~mm-zswap-support-multiple-swap-devices
+++ a/mm/zswap.c
@@ -89,6 +89,9 @@ static unsigned int zswap_max_pool_perce
 module_param_named(max_pool_percent,
 			zswap_max_pool_percent, uint, 0644);
 
+/* zbud_pool is shared by all of zswap backend  */
+static struct zbud_pool *zswap_pool;
+
 /*********************************
 * compression functions
 **********************************/
@@ -189,7 +192,6 @@ struct zswap_header {
 struct zswap_tree {
 	struct rb_root rbroot;
 	spinlock_t lock;
-	struct zbud_pool *pool;
 };
 
 static struct zswap_tree *zswap_trees[MAX_SWAPFILES];
@@ -285,13 +287,12 @@ static void zswap_rb_erase(struct rb_roo
  * Carries out the common pattern of freeing and entry's zbud allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
-static void zswap_free_entry(struct zswap_tree *tree,
-			struct zswap_entry *entry)
+static void zswap_free_entry(struct zswap_entry *entry)
 {
-	zbud_free(tree->pool, entry->handle);
+	zbud_free(zswap_pool, entry->handle);
 	zswap_entry_cache_free(entry);
 	atomic_dec(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(tree->pool);
+	zswap_pool_pages = zbud_get_pool_size(zswap_pool);
 }
 
 /* caller must hold the tree lock */
@@ -311,7 +312,7 @@ static void zswap_entry_put(struct zswap
 	BUG_ON(refcount < 0);
 	if (refcount == 0) {
 		zswap_rb_erase(&tree->rbroot, entry);
-		zswap_free_entry(tree, entry);
+		zswap_free_entry(entry);
 	}
 }
 
@@ -545,7 +546,6 @@ static int zswap_writeback_entry(struct
 	zbud_unmap(pool, handle);
 	tree = zswap_trees[swp_type(swpentry)];
 	offset = swp_offset(swpentry);
-	BUG_ON(pool != tree->pool);
 
 	/* find and ref zswap entry */
 	spin_lock(&tree->lock);
@@ -573,13 +573,13 @@ static int zswap_writeback_entry(struct
 	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
 		/* decompress */
 		dlen = PAGE_SIZE;
-		src = (u8 *)zbud_map(tree->pool, entry->handle) +
+		src = (u8 *)zbud_map(zswap_pool, entry->handle) +
 			sizeof(struct zswap_header);
 		dst = kmap_atomic(page);
 		ret = zswap_comp_op(ZSWAP_COMPOP_DECOMPRESS, src,
 				entry->length, dst, &dlen);
 		kunmap_atomic(dst);
-		zbud_unmap(tree->pool, entry->handle);
+		zbud_unmap(zswap_pool, entry->handle);
 		BUG_ON(ret);
 		BUG_ON(dlen != PAGE_SIZE);
 
@@ -652,7 +652,7 @@ static int zswap_frontswap_store(unsigne
 	/* reclaim space if needed */
 	if (zswap_is_full()) {
 		zswap_pool_limit_hit++;
-		if (zbud_reclaim_page(tree->pool, 8)) {
+		if (zbud_reclaim_page(zswap_pool, 8)) {
 			zswap_reject_reclaim_fail++;
 			ret = -ENOMEM;
 			goto reject;
@@ -679,7 +679,7 @@ static int zswap_frontswap_store(unsigne
 
 	/* store */
 	len = dlen + sizeof(struct zswap_header);
-	ret = zbud_alloc(tree->pool, len, __GFP_NORETRY | __GFP_NOWARN,
+	ret = zbud_alloc(zswap_pool, len, __GFP_NORETRY | __GFP_NOWARN,
 		&handle);
 	if (ret == -ENOSPC) {
 		zswap_reject_compress_poor++;
@@ -689,11 +689,11 @@ static int zswap_frontswap_store(unsigne
 		zswap_reject_alloc_fail++;
 		goto freepage;
 	}
-	zhdr = zbud_map(tree->pool, handle);
+	zhdr = zbud_map(zswap_pool, handle);
 	zhdr->swpentry = swp_entry(type, offset);
 	buf = (u8 *)(zhdr + 1);
 	memcpy(buf, dst, dlen);
-	zbud_unmap(tree->pool, handle);
+	zbud_unmap(zswap_pool, handle);
 	put_cpu_var(zswap_dstmem);
 
 	/* populate entry */
@@ -716,7 +716,7 @@ static int zswap_frontswap_store(unsigne
 
 	/* update stats */
 	atomic_inc(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(tree->pool);
+	zswap_pool_pages = zbud_get_pool_size(zswap_pool);
 
 	return 0;
 
@@ -752,13 +752,13 @@ static int zswap_frontswap_load(unsigned
 
 	/* decompress */
 	dlen = PAGE_SIZE;
-	src = (u8 *)zbud_map(tree->pool, entry->handle) +
+	src = (u8 *)zbud_map(zswap_pool, entry->handle) +
 			sizeof(struct zswap_header);
 	dst = kmap_atomic(page);
 	ret = zswap_comp_op(ZSWAP_COMPOP_DECOMPRESS, src, entry->length,
 		dst, &dlen);
 	kunmap_atomic(dst);
-	zbud_unmap(tree->pool, entry->handle);
+	zbud_unmap(zswap_pool, entry->handle);
 	BUG_ON(ret);
 
 	spin_lock(&tree->lock);
@@ -804,11 +804,9 @@ static void zswap_frontswap_invalidate_a
 	/* walk the tree and free everything */
 	spin_lock(&tree->lock);
 	rbtree_postorder_for_each_entry_safe(entry, n, &tree->rbroot, rbnode)
-		zswap_free_entry(tree, entry);
+		zswap_free_entry(entry);
 	tree->rbroot = RB_ROOT;
 	spin_unlock(&tree->lock);
-
-	zbud_destroy_pool(tree->pool);
 	kfree(tree);
 	zswap_trees[type] = NULL;
 }
@@ -822,20 +820,14 @@ static void zswap_frontswap_init(unsigne
 	struct zswap_tree *tree;
 
 	tree = kzalloc(sizeof(struct zswap_tree), GFP_KERNEL);
-	if (!tree)
-		goto err;
-	tree->pool = zbud_create_pool(GFP_KERNEL, &zswap_zbud_ops);
-	if (!tree->pool)
-		goto freetree;
+	if (!tree) {
+		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
+		return;
+	}
+
 	tree->rbroot = RB_ROOT;
 	spin_lock_init(&tree->lock);
 	zswap_trees[type] = tree;
-	return;
-
-freetree:
-	kfree(tree);
-err:
-	pr_err("alloc failed, zswap disabled for swap type %d\n", type);
 }
 
 static struct frontswap_ops zswap_frontswap_ops = {
@@ -907,9 +899,16 @@ static int __init init_zswap(void)
 		return 0;
 
 	pr_info("loading zswap\n");
+
+	zswap_pool = zbud_create_pool(GFP_KERNEL, &zswap_zbud_ops);
+	if (!zswap_pool) {
+		pr_err("zbud pool creation failed\n");
+		goto error;
+	}
+
 	if (zswap_entry_cache_create()) {
 		pr_err("entry cache creation failed\n");
-		goto error;
+		goto cachefail;
 	}
 	if (zswap_comp_init()) {
 		pr_err("compressor initialization failed\n");
@@ -919,6 +918,7 @@ static int __init init_zswap(void)
 		pr_err("per-cpu initialization failed\n");
 		goto pcpufail;
 	}
+
 	frontswap_register_ops(&zswap_frontswap_ops);
 	if (zswap_debugfs_init())
 		pr_warn("debugfs initialization failed\n");
@@ -927,6 +927,8 @@ pcpufail:
 	zswap_comp_exit();
 compfail:
 	zswap_entry_cache_destory();
+cachefail:
+	zbud_destroy_pool(zswap_pool);
 error:
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch

