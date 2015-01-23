From: akpm@linux-foundation.org
Subject: + list_lru-add-helpers-to-isolate-items.patch added to -mm tree
Date: Fri, 23 Jan 2015 12:45:32 -0800
Message-ID: <54c2b2ec.smc7LaSj6wcXP++6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbAWUpd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jan 2015 15:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: list_lru: add helpers to isolate items
has been added to the -mm tree.  Its filename is
     list_lru-add-helpers-to-isolate-items.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list_lru-add-helpers-to-isolate-items.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list_lru-add-helpers-to-isolate-items.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: list_lru: add helpers to isolate items

Currently, the isolate callback passed to the list_lru_walk family of
functions is supposed to just delete an item from the list upon returning
LRU_REMOVED or LRU_REMOVED_RETRY, while nr_items counter is fixed by
__list_lru_walk_one after the callback returns.  Since the callback is
allowed to drop the lock after removing an item (it has to return
LRU_REMOVED_RETRY then), the nr_items can be less than the actual number
of elements on the list even if we check them under the lock.  This makes
it difficult to move items from one list_lru_one to another, which is
required for per-memcg list_lru reparenting - we can't just splice the
lists, we have to move entries one by one.

This patch therefore introduces helpers that must be used by callback
functions to isolate items instead of raw list_del/list_move.  These are
list_lru_isolate and list_lru_isolate_move.  They not only remove the
entry from the list, but also fix the nr_items counter, making sure
nr_items always reflects the actual number of elements on the list if
checked under the appropriate lock.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c              |   21 +++++++++++----------
 fs/gfs2/quota.c          |    5 +++--
 fs/inode.c               |    8 ++++----
 fs/xfs/xfs_buf.c         |    6 ++++--
 fs/xfs/xfs_qm.c          |    5 +++--
 include/linux/list_lru.h |    9 +++++++--
 mm/list_lru.c            |   19 ++++++++++++++++---
 mm/workingset.c          |    3 ++-
 8 files changed, 50 insertions(+), 26 deletions(-)

diff -puN fs/dcache.c~list_lru-add-helpers-to-isolate-items fs/dcache.c
--- a/fs/dcache.c~list_lru-add-helpers-to-isolate-items
+++ a/fs/dcache.c
@@ -400,19 +400,20 @@ static void d_shrink_add(struct dentry *
  * LRU lists entirely, while shrink_move moves it to the indicated
  * private list.
  */
-static void d_lru_isolate(struct dentry *dentry)
+static void d_lru_isolate(struct list_lru_one *lru, struct dentry *dentry)
 {
 	D_FLAG_VERIFY(dentry, DCACHE_LRU_LIST);
 	dentry->d_flags &= ~DCACHE_LRU_LIST;
 	this_cpu_dec(nr_dentry_unused);
-	list_del_init(&dentry->d_lru);
+	list_lru_isolate(lru, &dentry->d_lru);
 }
 
-static void d_lru_shrink_move(struct dentry *dentry, struct list_head *list)
+static void d_lru_shrink_move(struct list_lru_one *lru, struct dentry *dentry,
+			      struct list_head *list)
 {
 	D_FLAG_VERIFY(dentry, DCACHE_LRU_LIST);
 	dentry->d_flags |= DCACHE_SHRINK_LIST;
-	list_move_tail(&dentry->d_lru, list);
+	list_lru_isolate_move(lru, &dentry->d_lru, list);
 }
 
 /*
@@ -869,8 +870,8 @@ static void shrink_dentry_list(struct li
 	}
 }
 
-static enum lru_status
-dentry_lru_isolate(struct list_head *item, spinlock_t *lru_lock, void *arg)
+static enum lru_status dentry_lru_isolate(struct list_head *item,
+		struct list_lru_one *lru, spinlock_t *lru_lock, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
@@ -890,7 +891,7 @@ dentry_lru_isolate(struct list_head *ite
 	 * another pass through the LRU.
 	 */
 	if (dentry->d_lockref.count) {
-		d_lru_isolate(dentry);
+		d_lru_isolate(lru, dentry);
 		spin_unlock(&dentry->d_lock);
 		return LRU_REMOVED;
 	}
@@ -921,7 +922,7 @@ dentry_lru_isolate(struct list_head *ite
 		return LRU_ROTATE;
 	}
 
-	d_lru_shrink_move(dentry, freeable);
+	d_lru_shrink_move(lru, dentry, freeable);
 	spin_unlock(&dentry->d_lock);
 
 	return LRU_REMOVED;
@@ -951,7 +952,7 @@ long prune_dcache_sb(struct super_block
 }
 
 static enum lru_status dentry_lru_isolate_shrink(struct list_head *item,
-						spinlock_t *lru_lock, void *arg)
+		struct list_lru_one *lru, spinlock_t *lru_lock, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct dentry	*dentry = container_of(item, struct dentry, d_lru);
@@ -964,7 +965,7 @@ static enum lru_status dentry_lru_isolat
 	if (!spin_trylock(&dentry->d_lock))
 		return LRU_SKIP;
 
-	d_lru_shrink_move(dentry, freeable);
+	d_lru_shrink_move(lru, dentry, freeable);
 	spin_unlock(&dentry->d_lock);
 
 	return LRU_REMOVED;
diff -puN fs/gfs2/quota.c~list_lru-add-helpers-to-isolate-items fs/gfs2/quota.c
--- a/fs/gfs2/quota.c~list_lru-add-helpers-to-isolate-items
+++ a/fs/gfs2/quota.c
@@ -145,7 +145,8 @@ static void gfs2_qd_dispose(struct list_
 }
 
 
-static enum lru_status gfs2_qd_isolate(struct list_head *item, spinlock_t *lock, void *arg)
+static enum lru_status gfs2_qd_isolate(struct list_head *item,
+		struct list_lru_one *lru, spinlock_t *lru_lock, void *arg)
 {
 	struct list_head *dispose = arg;
 	struct gfs2_quota_data *qd = list_entry(item, struct gfs2_quota_data, qd_lru);
@@ -155,7 +156,7 @@ static enum lru_status gfs2_qd_isolate(s
 
 	if (qd->qd_lockref.count == 0) {
 		lockref_mark_dead(&qd->qd_lockref);
-		list_move(&qd->qd_lru, dispose);
+		list_lru_isolate_move(lru, &qd->qd_lru, dispose);
 	}
 
 	spin_unlock(&qd->qd_lockref.lock);
diff -puN fs/inode.c~list_lru-add-helpers-to-isolate-items fs/inode.c
--- a/fs/inode.c~list_lru-add-helpers-to-isolate-items
+++ a/fs/inode.c
@@ -684,8 +684,8 @@ int invalidate_inodes(struct super_block
  * LRU does not have strict ordering. Hence we don't want to reclaim inodes
  * with this flag set because they are the inodes that are out of order.
  */
-static enum lru_status
-inode_lru_isolate(struct list_head *item, spinlock_t *lru_lock, void *arg)
+static enum lru_status inode_lru_isolate(struct list_head *item,
+		struct list_lru_one *lru, spinlock_t *lru_lock, void *arg)
 {
 	struct list_head *freeable = arg;
 	struct inode	*inode = container_of(item, struct inode, i_lru);
@@ -703,7 +703,7 @@ inode_lru_isolate(struct list_head *item
 	 */
 	if (atomic_read(&inode->i_count) ||
 	    (inode->i_state & ~I_REFERENCED)) {
-		list_del_init(&inode->i_lru);
+		list_lru_isolate(lru, &inode->i_lru);
 		spin_unlock(&inode->i_lock);
 		this_cpu_dec(nr_unused);
 		return LRU_REMOVED;
@@ -737,7 +737,7 @@ inode_lru_isolate(struct list_head *item
 
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
-	list_move(&inode->i_lru, freeable);
+	list_lru_isolate_move(lru, &inode->i_lru, freeable);
 	spin_unlock(&inode->i_lock);
 
 	this_cpu_dec(nr_unused);
diff -puN fs/xfs/xfs_buf.c~list_lru-add-helpers-to-isolate-items fs/xfs/xfs_buf.c
--- a/fs/xfs/xfs_buf.c~list_lru-add-helpers-to-isolate-items
+++ a/fs/xfs/xfs_buf.c
@@ -1488,6 +1488,7 @@ xfs_buf_iomove(
 static enum lru_status
 xfs_buftarg_wait_rele(
 	struct list_head	*item,
+	struct list_lru_one	*lru,
 	spinlock_t		*lru_lock,
 	void			*arg)
 
@@ -1509,7 +1510,7 @@ xfs_buftarg_wait_rele(
 	 */
 	atomic_set(&bp->b_lru_ref, 0);
 	bp->b_state |= XFS_BSTATE_DISPOSE;
-	list_move(item, dispose);
+	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lock);
 	return LRU_REMOVED;
 }
@@ -1546,6 +1547,7 @@ xfs_wait_buftarg(
 static enum lru_status
 xfs_buftarg_isolate(
 	struct list_head	*item,
+	struct list_lru_one	*lru,
 	spinlock_t		*lru_lock,
 	void			*arg)
 {
@@ -1569,7 +1571,7 @@ xfs_buftarg_isolate(
 	}
 
 	bp->b_state |= XFS_BSTATE_DISPOSE;
-	list_move(item, dispose);
+	list_lru_isolate_move(lru, item, dispose);
 	spin_unlock(&bp->b_lock);
 	return LRU_REMOVED;
 }
diff -puN fs/xfs/xfs_qm.c~list_lru-add-helpers-to-isolate-items fs/xfs/xfs_qm.c
--- a/fs/xfs/xfs_qm.c~list_lru-add-helpers-to-isolate-items
+++ a/fs/xfs/xfs_qm.c
@@ -430,6 +430,7 @@ struct xfs_qm_isolate {
 static enum lru_status
 xfs_qm_dquot_isolate(
 	struct list_head	*item,
+	struct list_lru_one	*lru,
 	spinlock_t		*lru_lock,
 	void			*arg)
 		__releases(lru_lock) __acquires(lru_lock)
@@ -450,7 +451,7 @@ xfs_qm_dquot_isolate(
 		XFS_STATS_INC(xs_qm_dqwants);
 
 		trace_xfs_dqreclaim_want(dqp);
-		list_del_init(&dqp->q_lru);
+		list_lru_isolate(lru, &dqp->q_lru);
 		XFS_STATS_DEC(xs_qm_dquot_unused);
 		return LRU_REMOVED;
 	}
@@ -494,7 +495,7 @@ xfs_qm_dquot_isolate(
 	xfs_dqunlock(dqp);
 
 	ASSERT(dqp->q_nrefs == 0);
-	list_move_tail(&dqp->q_lru, &isol->dispose);
+	list_lru_isolate_move(lru, &dqp->q_lru, &isol->dispose);
 	XFS_STATS_DEC(xs_qm_dquot_unused);
 	trace_xfs_dqreclaim_done(dqp);
 	XFS_STATS_INC(xs_qm_dqreclaims);
diff -puN include/linux/list_lru.h~list_lru-add-helpers-to-isolate-items include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-add-helpers-to-isolate-items
+++ a/include/linux/list_lru.h
@@ -125,8 +125,13 @@ static inline unsigned long list_lru_cou
 	return count;
 }
 
-typedef enum lru_status
-(*list_lru_walk_cb)(struct list_head *item, spinlock_t *lock, void *cb_arg);
+void list_lru_isolate(struct list_lru_one *list, struct list_head *item);
+void list_lru_isolate_move(struct list_lru_one *list, struct list_head *item,
+			   struct list_head *head);
+
+typedef enum lru_status (*list_lru_walk_cb)(struct list_head *item,
+		struct list_lru_one *list, spinlock_t *lock, void *cb_arg);
+
 /**
  * list_lru_walk_one: walk a list_lru, isolating and disposing freeable items.
  * @lru: the lru pointer.
diff -puN mm/list_lru.c~list_lru-add-helpers-to-isolate-items mm/list_lru.c
--- a/mm/list_lru.c~list_lru-add-helpers-to-isolate-items
+++ a/mm/list_lru.c
@@ -132,6 +132,21 @@ bool list_lru_del(struct list_lru *lru,
 }
 EXPORT_SYMBOL_GPL(list_lru_del);
 
+void list_lru_isolate(struct list_lru_one *list, struct list_head *item)
+{
+	list_del_init(item);
+	list->nr_items--;
+}
+EXPORT_SYMBOL_GPL(list_lru_isolate);
+
+void list_lru_isolate_move(struct list_lru_one *list, struct list_head *item,
+			   struct list_head *head)
+{
+	list_move(item, head);
+	list->nr_items--;
+}
+EXPORT_SYMBOL_GPL(list_lru_isolate_move);
+
 static unsigned long __list_lru_count_one(struct list_lru *lru,
 					  int nid, int memcg_idx)
 {
@@ -194,13 +209,11 @@ restart:
 			break;
 		--*nr_to_walk;
 
-		ret = isolate(item, &nlru->lock, cb_arg);
+		ret = isolate(item, l, &nlru->lock, cb_arg);
 		switch (ret) {
 		case LRU_REMOVED_RETRY:
 			assert_spin_locked(&nlru->lock);
 		case LRU_REMOVED:
-			l->nr_items--;
-			WARN_ON_ONCE(l->nr_items < 0);
 			isolated++;
 			/*
 			 * If the lru lock has been dropped, our list
diff -puN mm/workingset.c~list_lru-add-helpers-to-isolate-items mm/workingset.c
--- a/mm/workingset.c~list_lru-add-helpers-to-isolate-items
+++ a/mm/workingset.c
@@ -302,6 +302,7 @@ static unsigned long count_shadow_nodes(
 }
 
 static enum lru_status shadow_lru_isolate(struct list_head *item,
+					  struct list_lru_one *lru,
 					  spinlock_t *lru_lock,
 					  void *arg)
 {
@@ -332,7 +333,7 @@ static enum lru_status shadow_lru_isolat
 		goto out;
 	}
 
-	list_del_init(item);
+	list_lru_isolate(lru, item);
 	spin_unlock(lru_lock);
 
 	/*
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-vmscan-fix-highidx-argument-type.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
mm-memcontrol-remove-unnecessary-soft-limit-tree-node-test.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch

