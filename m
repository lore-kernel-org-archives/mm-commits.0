Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9141F7553
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 21:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730755198; cv=none; b=jEAMVuiQ7g4qr0SB3W7DIvqmjvRmyVx7mtNNtWeAaHlhij8z3pEf43Wh2FfhQBwUVpKU+Rflm21rKu0hTscEpTA6LlvHertxpTmF2rmpaN2MspTVhUNzv40XEsM/Ex5kYtGmGC41yyxzaufbF8WbZ0gjoFjkATuaSRY3FqnOINc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730755198; c=relaxed/simple;
	bh=BbkZUFuI0kKpUJD3xkv7Jn6T9tLxj+Uol9gzFPu00k0=;
	h=Date:To:From:Subject:Message-Id; b=GzsE+wTIQ9bgahdxSR2OzT/4ekfJTJPNvh2c6wb5qDIZ+x9bH4klZWgWtnDyS2XuENHXHsgAkAip7vx30uJnoQ2W/m7649zGdosak4QDc3NRFMww+r940BMhNx9TQb/+nZKfjT4EQqEwDjU5I/+JYRaHkObuwFri0La3Cfxn/NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K0VsX2Ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K0VsX2Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC74BC4CECE;
	Mon,  4 Nov 2024 21:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730755198;
	bh=BbkZUFuI0kKpUJD3xkv7Jn6T9tLxj+Uol9gzFPu00k0=;
	h=Date:To:From:Subject:From;
	b=K0VsX2Ot1I5VXvENQYCSR050xfMftmDO0DV4DsLJm34nrrlczOG95utKR3LaRBPgN
	 /8ZcKvmoXHGloJVeWyJxLYJj/nWLKnaj1J2//kGCeg7IIYyl0hIf/kHrZu03RpY5GZ
	 o8/dAzS01yVaQWHdaJc/6q85c7bmGebo2KrRczJU=
Date: Mon, 04 Nov 2024 13:19:57 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,longman@redhat.com,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-simplify-the-list_lru-walk-callback-function.patch added to mm-unstable branch
Message-Id: <20241104211957.EC74BC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/list_lru: simplify the list_lru walk callback function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-simplify-the-list_lru-walk-callback-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-simplify-the-list_lru-walk-callback-function.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/list_lru: simplify the list_lru walk callback function
Date: Tue, 5 Nov 2024 01:52:57 +0800

Now isolation no longer takes the list_lru global node lock, only use the
per-cgroup lock instead.  And this lock is inside the list_lru_one being
walked, no longer needed to pass the lock explicitly.

Link: https://lkml.kernel.org/r/20241104175257.60853-7-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder_alloc.c |    7 +++----
 drivers/android/binder_alloc.h |    2 +-
 fs/dcache.c                    |    4 ++--
 fs/gfs2/quota.c                |    2 +-
 fs/inode.c                     |    4 ++--
 fs/nfs/nfs42xattr.c            |    4 ++--
 fs/nfsd/filecache.c            |    5 +----
 fs/xfs/xfs_buf.c               |    2 --
 fs/xfs/xfs_qm.c                |    5 ++---
 include/linux/list_lru.h       |    2 +-
 mm/list_lru.c                  |    2 +-
 mm/workingset.c                |   15 +++++++--------
 mm/zswap.c                     |    4 ++--
 13 files changed, 25 insertions(+), 33 deletions(-)

--- a/drivers/android/binder_alloc.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/drivers/android/binder_alloc.c
@@ -1047,7 +1047,7 @@ void binder_alloc_vma_close(struct binde
 /**
  * binder_alloc_free_page() - shrinker callback to free pages
  * @item:   item to free
- * @lock:   lock protecting the item
+ * @lru:    list_lru instance of the item
  * @cb_arg: callback argument
  *
  * Called from list_lru_walk() in binder_shrink_scan() to free
@@ -1055,9 +1055,8 @@ void binder_alloc_vma_close(struct binde
  */
 enum lru_status binder_alloc_free_page(struct list_head *item,
 				       struct list_lru_one *lru,
-				       spinlock_t *lock,
 				       void *cb_arg)
-	__must_hold(lock)
+	__must_hold(&lru->lock)
 {
 	struct binder_lru_page *page = container_of(item, typeof(*page), lru);
 	struct binder_alloc *alloc = page->alloc;
@@ -1092,7 +1091,7 @@ enum lru_status binder_alloc_free_page(s
 
 	list_lru_isolate(lru, item);
 	spin_unlock(&alloc->lock);
-	spin_unlock(lock);
+	spin_unlock(&lru->lock);
 
 	if (vma) {
 		trace_binder_unmap_user_start(alloc, index);
--- a/drivers/android/binder_alloc.h~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/drivers/android/binder_alloc.h
@@ -118,7 +118,7 @@ static inline void binder_selftest_alloc
 #endif
 enum lru_status binder_alloc_free_page(struct list_head *item,
 				       struct list_lru_one *lru,
-				       spinlock_t *lock, void *cb_arg);
+				       void *cb_arg);
 struct binder_buffer *binder_alloc_new_buf(struct binder_alloc *alloc,
 					   size_t data_size,
 					   size_t offsets_size,
--- a/fs/dcache.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/fs/dcache.c
@@ -1089,7 +1089,7 @@ void shrink_dentry_list(struct list_head
 }
 
 static enum lru_status dentry_lru_isolate(struct list_head *item,
-		struct list_lru_one *lru, spinlock_t *lru_lock, void *arg)
+		struct list_lru_one *lru, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
@@ -1170,7 +1170,7 @@ long prune_dcache_sb(struct super_block
 }
 
 static enum lru_status dentry_lru_isolate_shrink(struct list_head *item,
-		struct list_lru_one *lru, spinlock_t *lru_lock, void *arg)
+		struct list_lru_one *lru, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
--- a/fs/gfs2/quota.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/fs/gfs2/quota.c
@@ -149,7 +149,7 @@ static void gfs2_qd_list_dispose(struct
 
 
 static enum lru_status gfs2_qd_isolate(struct list_head *item,
-		struct list_lru_one *lru, spinlock_t *lru_lock, void *arg)
+		struct list_lru_one *lru, void *arg)
 {
 	struct list_head *dispose = arg;
 	struct gfs2_quota_data *qd =
--- a/fs/inode.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/fs/inode.c
@@ -881,7 +881,7 @@ again:
  * with this flag set because they are the inodes that are out of order.
  */
 static enum lru_status inode_lru_isolate(struct list_head *item,
-		struct list_lru_one *lru, spinlock_t *lru_lock, void *arg)
+		struct list_lru_one *lru, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct inode	*inode = container_of(item, struct inode, i_lru);
@@ -923,7 +923,7 @@ static enum lru_status inode_lru_isolate
 	if (inode_has_buffers(inode) || !mapping_empty(&inode->i_data)) {
 		inode_pin_lru_isolating(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(lru_lock);
+		spin_unlock(&lru->lock);
 		if (remove_inode_buffers(inode)) {
 			unsigned long reap;
 			reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
--- a/fs/nfsd/filecache.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/fs/nfsd/filecache.c
@@ -487,7 +487,6 @@ void nfsd_file_net_dispose(struct nfsd_n
  * nfsd_file_lru_cb - Examine an entry on the LRU list
  * @item: LRU entry to examine
  * @lru: controlling LRU
- * @lock: LRU list lock (unused)
  * @arg: dispose list
  *
  * Return values:
@@ -497,9 +496,7 @@ void nfsd_file_net_dispose(struct nfsd_n
  */
 static enum lru_status
 nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
-		 spinlock_t *lock, void *arg)
-	__releases(lock)
-	__acquires(lock)
+		 void *arg)
 {
 	struct list_head *head = arg;
 	struct nfsd_file *nf = list_entry(item, struct nfsd_file, nf_lru);
--- a/fs/nfs/nfs42xattr.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/fs/nfs/nfs42xattr.c
@@ -802,7 +802,7 @@ static struct shrinker *nfs4_xattr_large
 
 static enum lru_status
 cache_lru_isolate(struct list_head *item,
-	struct list_lru_one *lru, spinlock_t *lru_lock, void *arg)
+	struct list_lru_one *lru, void *arg)
 {
 	struct list_head *dispose = arg;
 	struct inode *inode;
@@ -867,7 +867,7 @@ nfs4_xattr_cache_count(struct shrinker *
 
 static enum lru_status
 entry_lru_isolate(struct list_head *item,
-	struct list_lru_one *lru, spinlock_t *lru_lock, void *arg)
+	struct list_lru_one *lru, void *arg)
 {
 	struct list_head *dispose = arg;
 	struct nfs4_xattr_bucket *bucket;
--- a/fs/xfs/xfs_buf.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/fs/xfs/xfs_buf.c
@@ -1857,7 +1857,6 @@ static enum lru_status
 xfs_buftarg_drain_rele(
 	struct list_head	*item,
 	struct list_lru_one	*lru,
-	spinlock_t		*lru_lock,
 	void			*arg)
 
 {
@@ -1956,7 +1955,6 @@ static enum lru_status
 xfs_buftarg_isolate(
 	struct list_head	*item,
 	struct list_lru_one	*lru,
-	spinlock_t		*lru_lock,
 	void			*arg)
 {
 	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
--- a/fs/xfs/xfs_qm.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/fs/xfs/xfs_qm.c
@@ -412,9 +412,8 @@ static enum lru_status
 xfs_qm_dquot_isolate(
 	struct list_head	*item,
 	struct list_lru_one	*lru,
-	spinlock_t		*lru_lock,
 	void			*arg)
-		__releases(lru_lock) __acquires(lru_lock)
+		__releases(&lru->lock) __acquires(&lru->lock)
 {
 	struct xfs_dquot	*dqp = container_of(item,
 						struct xfs_dquot, q_lru);
@@ -460,7 +459,7 @@ xfs_qm_dquot_isolate(
 		trace_xfs_dqreclaim_dirty(dqp);
 
 		/* we have to drop the LRU lock to flush the dquot */
-		spin_unlock(lru_lock);
+		spin_unlock(&lru->lock);
 
 		error = xfs_qm_dqflush(dqp, &bp);
 		if (error)
--- a/include/linux/list_lru.h~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/include/linux/list_lru.h
@@ -184,7 +184,7 @@ void list_lru_isolate_move(struct list_l
 			   struct list_head *head);
 
 typedef enum lru_status (*list_lru_walk_cb)(struct list_head *item,
-		struct list_lru_one *list, spinlock_t *lock, void *cb_arg);
+		struct list_lru_one *list, void *cb_arg);
 
 /**
  * list_lru_walk_one: walk a @lru, isolating and disposing freeable items.
--- a/mm/list_lru.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/mm/list_lru.c
@@ -298,7 +298,7 @@ restart:
 			break;
 		--*nr_to_walk;
 
-		ret = isolate(item, l, &l->lock, cb_arg);
+		ret = isolate(item, l, cb_arg);
 		switch (ret) {
 		/*
 		 * LRU_RETRY, LRU_REMOVED_RETRY and LRU_STOP will drop the lru
--- a/mm/workingset.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/mm/workingset.c
@@ -702,8 +702,7 @@ static unsigned long count_shadow_nodes(
 
 static enum lru_status shadow_lru_isolate(struct list_head *item,
 					  struct list_lru_one *lru,
-					  spinlock_t *lru_lock,
-					  void *arg) __must_hold(lru_lock)
+					  void *arg) __must_hold(lru->lock)
 {
 	struct xa_node *node = container_of(item, struct xa_node, private_list);
 	struct address_space *mapping;
@@ -712,20 +711,20 @@ static enum lru_status shadow_lru_isolat
 	/*
 	 * Page cache insertions and deletions synchronously maintain
 	 * the shadow node LRU under the i_pages lock and the
-	 * lru_lock.  Because the page cache tree is emptied before
-	 * the inode can be destroyed, holding the lru_lock pins any
+	 * &lru->lock. Because the page cache tree is emptied before
+	 * the inode can be destroyed, holding the &lru->lock pins any
 	 * address_space that has nodes on the LRU.
 	 *
 	 * We can then safely transition to the i_pages lock to
 	 * pin only the address_space of the particular node we want
-	 * to reclaim, take the node off-LRU, and drop the lru_lock.
+	 * to reclaim, take the node off-LRU, and drop the &lru->lock.
 	 */
 
 	mapping = container_of(node->array, struct address_space, i_pages);
 
 	/* Coming from the list, invert the lock order */
 	if (!xa_trylock(&mapping->i_pages)) {
-		spin_unlock_irq(lru_lock);
+		spin_unlock_irq(&lru->lock);
 		ret = LRU_RETRY;
 		goto out;
 	}
@@ -734,7 +733,7 @@ static enum lru_status shadow_lru_isolat
 	if (mapping->host != NULL) {
 		if (!spin_trylock(&mapping->host->i_lock)) {
 			xa_unlock(&mapping->i_pages);
-			spin_unlock_irq(lru_lock);
+			spin_unlock_irq(&lru->lock);
 			ret = LRU_RETRY;
 			goto out;
 		}
@@ -743,7 +742,7 @@ static enum lru_status shadow_lru_isolat
 	list_lru_isolate(lru, item);
 	__dec_node_page_state(virt_to_page(node), WORKINGSET_NODES);
 
-	spin_unlock(lru_lock);
+	spin_unlock(&lru->lock);
 
 	/*
 	 * The nodes should only contain one or more shadow entries,
--- a/mm/zswap.c~mm-list_lru-simplify-the-list_lru-walk-callback-function
+++ a/mm/zswap.c
@@ -1102,7 +1102,7 @@ static int zswap_writeback_entry(struct
  *    for reclaim by this ratio.
  */
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
-				       spinlock_t *lock, void *arg)
+				       void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
 	bool *encountered_page_in_swapcache = (bool *)arg;
@@ -1158,7 +1158,7 @@ static enum lru_status shrink_memcg_cb(s
 	 * It's safe to drop the lock here because we return either
 	 * LRU_REMOVED_RETRY or LRU_RETRY.
 	 */
-	spin_unlock(lock);
+	spin_unlock(&l->lock);
 
 	writeback_result = zswap_writeback_entry(entry, swpentry);
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-zswap-avoid-touching-xarray-for-unnecessary-invalidation.patch
mm-list_lru-dont-pass-unnecessary-key-parameters.patch
mm-list_lru-dont-export-list_lru_add.patch
mm-list_lru-code-clean-up-for-reparenting.patch
mm-list_lru-simplify-reparenting-and-initial-allocation.patch
mm-list_lru-split-the-lock-to-per-cgroup-scope.patch
mm-list_lru-simplify-the-list_lru-walk-callback-function.patch

