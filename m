Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA3718658
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091417; cv=none; b=KA6KMbM3Ni5nGSIvGLTcJcr37BHC2UQbfdCELgeASMixDZTb/EXw08eNH/WKZmMitMu2SMU/FbX8CSYaxcS/zFjOhNJPF9lDHrY8upOOA7Xk+CocxFC6OrKNvpdljzoN7f7ONdtUQ1t6G+Sm3LsWUlEe+KcU42yThC3ASCzhEp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091417; c=relaxed/simple;
	bh=bDWyl/SGKZZGay0AESgvgcwqUXL8HBFJfXNMDtQGCKU=;
	h=Date:To:From:Subject:Message-Id; b=R4YlfrZs3xfpznk8Epar/GimauAw5GY6CB3sbN52I9sGR0yKNFhl1izPY65op74xPmfHVcxZ7lEOPiPBb7aoefpl4BX1VL4hN+QIJm7LIxJI/xUoXxT0O6otB8FlHp9rezSKh+hZhhgJSWRAXVL5vmw6VkbFHeKDFFTvk43ZEoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JkCb7CRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JkCb7CRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4E0C433C7;
	Wed, 24 Jan 2024 10:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091417;
	bh=bDWyl/SGKZZGay0AESgvgcwqUXL8HBFJfXNMDtQGCKU=;
	h=Date:To:From:Subject:From;
	b=JkCb7CRjw/+91a8QIOeEQ+oLh6OeC4Ta930U0u5EUKoKGTsp0mPEt+IuVISMfCN1i
	 9BSya5hbnC+aJUL+TRrHYGUarYVc3JiUJ/N+cPGfFWDwaDIyiva22XzBlP/Mnr83jm
	 531Nc3Ox5zM3pZ8fxhq0gqNiGeFsTHK7jdfW2U14=
Date: Wed, 24 Jan 2024 02:16:54 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-split-zswap-rb-tree.patch added to mm-unstable branch
Message-Id: <20240124101656.2F4E0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: split zswap rb-tree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-split-zswap-rb-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-split-zswap-rb-tree.patch

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
@@ -865,7 +872,7 @@ static enum lru_status shrink_memcg_cb(s
 	 * until the entry is verified to still be alive in the tree.
 	 */
 	swpoffset = swp_offset(entry->swpentry);
-	tree = zswap_trees[swp_type(entry->swpentry)];
+	tree = swap_zswap_tree(entry->swpentry);
 	list_lru_isolate(l, item);
 	/*
 	 * It's safe to drop the lock here because we return either
@@ -1494,10 +1501,9 @@ static void zswap_fill_page(void *ptr, u
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

mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch

