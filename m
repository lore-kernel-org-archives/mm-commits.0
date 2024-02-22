Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21EC28E3
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560094; cv=none; b=RDBHioagluVPHUBZjsuHjpGTFo2LRoizXS1dql0kv9d36CBoZ3oCgzmioz6MO7rygoFeTB4iMdWEeb80DmIAO4ASkyNLA5/k+r1JIcdhCcooj9IyzY2HRfhW8aF1hzGbP+tvzfIgaActNGmrwPjgDc3iIfDuLIDYsia2mLkqDLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560094; c=relaxed/simple;
	bh=sqEPikkS7LBGFkBI5bj4Szhlp1w1jgQ/AxymzRZWJKg=;
	h=Date:To:From:Subject:Message-Id; b=o3Am+YEhdbPEtXcYG803wKV+JW3pwSqyIki9KeBjJMsjcg5Cf1BgB+4EY35KfdFZlBJhDxnN+BGC/iLHpfW4ZIpLVfmhID+F6YvdYxGSr3MILQqOulf+/vJDUR8oOaVJos/MKONGO5ABxf5lqZpIyRgMkuXwiUObGXKpqQ8+pG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JhLmVRXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JhLmVRXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5843C43399;
	Thu, 22 Feb 2024 00:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560094;
	bh=sqEPikkS7LBGFkBI5bj4Szhlp1w1jgQ/AxymzRZWJKg=;
	h=Date:To:From:Subject:From;
	b=JhLmVRXFKT3bkOY5j0RYYFwoR6xuGLoJC9TSIy225F7nVm0Wuy9/TVlianKJazKUb
	 R94mzLxmPAE88TnBm9fLN+JhmzDIAMBXaDTN2CLeuN8nZuERlDQ4aMqMB7z+hRNVkX
	 J2swNIjUQJGn5sglEsEfORqDuIHtMOF2Q026rdbw=
Date: Wed, 21 Feb 2024 16:01:34 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-split-zswap-rb-tree.patch removed from -mm tree
Message-Id: <20240222000134.A5843C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: split zswap rb-tree
has been removed from the -mm tree.  Its filename was
     mm-zswap-split-zswap-rb-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: split zswap rb-tree
Date: Fri, 19 Jan 2024 11:22:23 +0000

Each swapfile has one rb-tree to search the mapping of swp_entry_t to
zswap_entry, that use a spinlock to protect, which can cause heavy lock
contention if multiple tasks zswap_store/load concurrently.

Optimize the scalability problem by splitting the zswap rb-tree into
multiple rb-trees, each corresponds to SWAP_ADDRESS_SPACE_PAGES (64M),
just like we did in the swap cache address_space splitting.

Although this method can't solve the spinlock contention completely, it
can mitigate much of that contention.  Below is the results of kernel
build in tmpfs with zswap shrinker enabled:

     linux-next  zswap-lock-optimize
real 1m9.181s    1m3.820s
user 17m44.036s  17m40.100s
sys  7m37.297s   4m54.622s

So there are clearly improvements.

Link: https://lkml.kernel.org/r/20240117-b4-zswap-lock-optimize-v2-2-b5cc55479090@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chris Li <chriscli@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    4 +-
 mm/swapfile.c         |    2 -
 mm/zswap.c            |   71 +++++++++++++++++++++++++---------------
 3 files changed, 49 insertions(+), 28 deletions(-)

--- a/include/linux/zswap.h~mm-zswap-split-zswap-rb-tree
+++ a/include/linux/zswap.h
@@ -30,7 +30,7 @@ struct zswap_lruvec_state {
 bool zswap_store(struct folio *folio);
 bool zswap_load(struct folio *folio);
 void zswap_invalidate(int type, pgoff_t offset);
-int zswap_swapon(int type);
+int zswap_swapon(int type, unsigned long nr_pages);
 void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
 void zswap_lruvec_state_init(struct lruvec *lruvec);
@@ -51,7 +51,7 @@ static inline bool zswap_load(struct fol
 }
 
 static inline void zswap_invalidate(int type, pgoff_t offset) {}
-static inline int zswap_swapon(int type)
+static inline int zswap_swapon(int type, unsigned long nr_pages)
 {
 	return 0;
 }
--- a/mm/swapfile.c~mm-zswap-split-zswap-rb-tree
+++ a/mm/swapfile.c
@@ -3165,7 +3165,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	error = zswap_swapon(p->type);
+	error = zswap_swapon(p->type, maxpages);
 	if (error)
 		goto free_swap_address_space;
 
--- a/mm/zswap.c~mm-zswap-split-zswap-rb-tree
+++ a/mm/zswap.c
@@ -239,6 +239,7 @@ struct zswap_tree {
 };
 
 static struct zswap_tree *zswap_trees[MAX_SWAPFILES];
+static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
 /* RCU-protected iteration */
 static LIST_HEAD(zswap_pools);
@@ -265,6 +266,12 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
+static inline struct zswap_tree *swap_zswap_tree(swp_entry_t swp)
+{
+	return &zswap_trees[swp_type(swp)][swp_offset(swp)
+		>> SWAP_ADDRESS_SPACE_SHIFT];
+}
+
 #define zswap_pool_debug(msg, p)				\
 	pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,		\
 		 zpool_get_type((p)->zpools[0]))
@@ -864,7 +871,7 @@ static enum lru_status shrink_memcg_cb(s
 	 * until the entry is verified to still be alive in the tree.
 	 */
 	swpoffset = swp_offset(entry->swpentry);
-	tree = zswap_trees[swp_type(entry->swpentry)];
+	tree = swap_zswap_tree(entry->swpentry);
 	list_lru_isolate(l, item);
 	/*
 	 * It's safe to drop the lock here because we return either
@@ -1493,10 +1500,9 @@ static void zswap_fill_page(void *ptr, u
 bool zswap_store(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
-	int type = swp_type(swp);
 	pgoff_t offset = swp_offset(swp);
 	struct page *page = &folio->page;
-	struct zswap_tree *tree = zswap_trees[type];
+	struct zswap_tree *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry, *dupentry;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
@@ -1569,7 +1575,7 @@ bool zswap_store(struct folio *folio)
 		src = kmap_local_page(page);
 		if (zswap_is_page_same_filled(src, &value)) {
 			kunmap_local(src);
-			entry->swpentry = swp_entry(type, offset);
+			entry->swpentry = swp;
 			entry->length = 0;
 			entry->value = value;
 			atomic_inc(&zswap_same_filled_pages);
@@ -1651,7 +1657,7 @@ bool zswap_store(struct folio *folio)
 	mutex_unlock(&acomp_ctx->mutex);
 
 	/* populate entry */
-	entry->swpentry = swp_entry(type, offset);
+	entry->swpentry = swp;
 	entry->handle = handle;
 	entry->length = dlen;
 
@@ -1711,10 +1717,9 @@ shrink:
 bool zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
-	int type = swp_type(swp);
 	pgoff_t offset = swp_offset(swp);
 	struct page *page = &folio->page;
-	struct zswap_tree *tree = zswap_trees[type];
+	struct zswap_tree *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 	u8 *dst;
 
@@ -1757,7 +1762,7 @@ bool zswap_load(struct folio *folio)
 
 void zswap_invalidate(int type, pgoff_t offset)
 {
-	struct zswap_tree *tree = zswap_trees[type];
+	struct zswap_tree *tree = swap_zswap_tree(swp_entry(type, offset));
 	struct zswap_entry *entry;
 
 	/* find */
@@ -1772,37 +1777,53 @@ void zswap_invalidate(int type, pgoff_t
 	spin_unlock(&tree->lock);
 }
 
-int zswap_swapon(int type)
+int zswap_swapon(int type, unsigned long nr_pages)
 {
-	struct zswap_tree *tree;
+	struct zswap_tree *trees, *tree;
+	unsigned int nr, i;
 
-	tree = kzalloc(sizeof(*tree), GFP_KERNEL);
-	if (!tree) {
+	nr = DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
+	trees = kvcalloc(nr, sizeof(*tree), GFP_KERNEL);
+	if (!trees) {
 		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
 		return -ENOMEM;
 	}
 
-	tree->rbroot = RB_ROOT;
-	spin_lock_init(&tree->lock);
-	zswap_trees[type] = tree;
+	for (i = 0; i < nr; i++) {
+		tree = trees + i;
+		tree->rbroot = RB_ROOT;
+		spin_lock_init(&tree->lock);
+	}
+
+	nr_zswap_trees[type] = nr;
+	zswap_trees[type] = trees;
 	return 0;
 }
 
 void zswap_swapoff(int type)
 {
-	struct zswap_tree *tree = zswap_trees[type];
-	struct zswap_entry *entry, *n;
+	struct zswap_tree *trees = zswap_trees[type];
+	unsigned int i;
 
-	if (!tree)
+	if (!trees)
 		return;
 
-	/* walk the tree and free everything */
-	spin_lock(&tree->lock);
-	rbtree_postorder_for_each_entry_safe(entry, n, &tree->rbroot, rbnode)
-		zswap_free_entry(entry);
-	tree->rbroot = RB_ROOT;
-	spin_unlock(&tree->lock);
-	kfree(tree);
+	for (i = 0; i < nr_zswap_trees[type]; i++) {
+		struct zswap_tree *tree = trees + i;
+		struct zswap_entry *entry, *n;
+
+		/* walk the tree and free everything */
+		spin_lock(&tree->lock);
+		rbtree_postorder_for_each_entry_safe(entry, n,
+						     &tree->rbroot,
+						     rbnode)
+			zswap_free_entry(entry);
+		tree->rbroot = RB_ROOT;
+		spin_unlock(&tree->lock);
+	}
+
+	kvfree(trees);
+	nr_zswap_trees[type] = 0;
 	zswap_trees[type] = NULL;
 }
 
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch
maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch

