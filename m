From: akpm@linux-foundation.org
Subject: [merged] vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:41 -0700
Message-ID: <201105252028.p4PKS4q4014644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658Ab1EYUxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:53:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     vmscan: change shrinker API by passing shrink_control struct
has been removed from the -mm tree.  Its filename was
     vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: change shrinker API by passing shrink_control struct
From: Ying Han <yinghan@google.com>

Change each shrinker's API by consolidating the existing parameters into
shrink_control struct.  This will simplify any further features added w/o
touching each file of shrinker.

[akpm@linux-foundation.org: fix build]
[akpm@linux-foundation.org: fix warning]
[kosaki.motohiro@jp.fujitsu.com: fix up new shrinker API]
[akpm@linux-foundation.org: fix xfs warning]
[akpm@linux-foundation.org: update gfs2]
Signed-off-by: Ying Han <yinghan@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c                   |    3 +-
 drivers/gpu/drm/i915/i915_gem.c      |    9 ++----
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    4 ++
 drivers/staging/zcache/zcache.c      |    5 ++-
 fs/dcache.c                          |    8 ++++-
 fs/drop_caches.c                     |    3 --
 fs/gfs2/glock.c                      |    5 ++-
 fs/gfs2/quota.c                      |   12 +++++---
 fs/gfs2/quota.h                      |    4 ++
 fs/inode.c                           |    6 +++-
 fs/mbcache.c                         |   10 ++++---
 fs/nfs/dir.c                         |    5 ++-
 fs/nfs/internal.h                    |    2 -
 fs/quota/dquot.c                     |    5 ++-
 fs/xfs/linux-2.6/xfs_buf.c           |    4 +-
 fs/xfs/linux-2.6/xfs_sync.c          |    5 ++-
 fs/xfs/quota/xfs_qm.c                |    6 ++--
 include/linux/mm.h                   |   19 ++++++++-----
 mm/memory-failure.c                  |    3 --
 mm/vmscan.c                          |   34 +++++++++++++------------
 net/sunrpc/auth.c                    |    4 ++
 21 files changed, 95 insertions(+), 61 deletions(-)

diff -puN arch/x86/kvm/mmu.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/arch/x86/kvm/mmu.c
@@ -3545,10 +3545,11 @@ static int kvm_mmu_remove_some_alloc_mmu
 	return kvm_mmu_prepare_zap_page(kvm, page, invalid_list);
 }
 
-static int mmu_shrink(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
+static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct kvm *kvm;
 	struct kvm *kvm_freed = NULL;
+	int nr_to_scan = sc->nr_to_scan;
 
 	if (nr_to_scan == 0)
 		goto out;
diff -puN drivers/gpu/drm/i915/i915_gem.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -56,9 +56,7 @@ static int i915_gem_phys_pwrite(struct d
 static void i915_gem_free_object_tail(struct drm_i915_gem_object *obj);
 
 static int i915_gem_inactive_shrink(struct shrinker *shrinker,
-				    int nr_to_scan,
-				    gfp_t gfp_mask);
-
+				    struct shrink_control *sc);
 
 /* some bookkeeping */
 static void i915_gem_info_add_obj(struct drm_i915_private *dev_priv,
@@ -4094,9 +4092,7 @@ i915_gpu_is_active(struct drm_device *de
 }
 
 static int
-i915_gem_inactive_shrink(struct shrinker *shrinker,
-			 int nr_to_scan,
-			 gfp_t gfp_mask)
+i915_gem_inactive_shrink(struct shrinker *shrinker, struct shrink_control *sc)
 {
 	struct drm_i915_private *dev_priv =
 		container_of(shrinker,
@@ -4104,6 +4100,7 @@ i915_gem_inactive_shrink(struct shrinker
 			     mm.inactive_shrinker);
 	struct drm_device *dev = dev_priv->dev;
 	struct drm_i915_gem_object *obj, *next;
+	int nr_to_scan = sc->nr_to_scan;
 	int cnt;
 
 	if (!mutex_trylock(&dev->struct_mutex))
diff -puN drivers/gpu/drm/ttm/ttm_page_alloc.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct drivers/gpu/drm/ttm/ttm_page_alloc.c
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -395,12 +395,14 @@ static int ttm_pool_get_num_unused_pages
 /**
  * Callback for mm to request pool to reduce number of page held.
  */
-static int ttm_pool_mm_shrink(struct shrinker *shrink, int shrink_pages, gfp_t gfp_mask)
+static int ttm_pool_mm_shrink(struct shrinker *shrink,
+			      struct shrink_control *sc)
 {
 	static atomic_t start_pool = ATOMIC_INIT(0);
 	unsigned i;
 	unsigned pool_offset = atomic_add_return(1, &start_pool);
 	struct ttm_page_pool *pool;
+	int shrink_pages = sc->nr_to_scan;
 
 	pool_offset = pool_offset % NUM_POOLS;
 	/* select start pool in round robin fashion */
diff -puN drivers/staging/zcache/zcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct drivers/staging/zcache/zcache.c
--- a/drivers/staging/zcache/zcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/drivers/staging/zcache/zcache.c
@@ -1181,9 +1181,12 @@ static bool zcache_freeze;
 /*
  * zcache shrinker interface (only useful for ephemeral pages, so zbud only)
  */
-static int shrink_zcache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+static int shrink_zcache_memory(struct shrinker *shrink,
+				struct shrink_control *sc)
 {
 	int ret = -1;
+	int nr = sc->nr_to_scan;
+	gfp_t gfp_mask = sc->gfp_mask;
 
 	if (nr >= 0) {
 		if (!(gfp_mask & __GFP_FS))
diff -puN fs/dcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/dcache.c
--- a/fs/dcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/dcache.c
@@ -1220,7 +1220,7 @@ void shrink_dcache_parent(struct dentry 
 EXPORT_SYMBOL(shrink_dcache_parent);
 
 /*
- * Scan `nr' dentries and return the number which remain.
+ * Scan `sc->nr_slab_to_reclaim' dentries and return the number which remain.
  *
  * We need to avoid reentering the filesystem if the caller is performing a
  * GFP_NOFS allocation attempt.  One example deadlock is:
@@ -1231,8 +1231,12 @@ EXPORT_SYMBOL(shrink_dcache_parent);
  *
  * In this case we return -1 to tell the caller that we baled.
  */
-static int shrink_dcache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+static int shrink_dcache_memory(struct shrinker *shrink,
+				struct shrink_control *sc)
 {
+	int nr = sc->nr_to_scan;
+	gfp_t gfp_mask = sc->gfp_mask;
+
 	if (nr) {
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
diff -puN fs/drop_caches.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/drop_caches.c
--- a/fs/drop_caches.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/drop_caches.c
@@ -42,11 +42,10 @@ static void drop_slab(void)
 	int nr_objects;
 	struct shrink_control shrink = {
 		.gfp_mask = GFP_KERNEL,
-		.nr_scanned = 1000,
 	};
 
 	do {
-		nr_objects = shrink_slab(&shrink, 1000);
+		nr_objects = shrink_slab(&shrink, 1000, 1000);
 	} while (nr_objects > 10);
 }
 
diff -puN fs/gfs2/glock.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/gfs2/glock.c
@@ -1346,11 +1346,14 @@ void gfs2_glock_complete(struct gfs2_glo
 }
 
 
-static int gfs2_shrink_glock_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+static int gfs2_shrink_glock_memory(struct shrinker *shrink,
+				    struct shrink_control *sc)
 {
 	struct gfs2_glock *gl;
 	int may_demote;
 	int nr_skipped = 0;
+	int nr = sc->nr_to_scan;
+	gfp_t gfp_mask = sc->gfp_mask;
 	LIST_HEAD(skipped);
 
 	if (nr == 0)
diff -puN fs/gfs2/quota.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/gfs2/quota.c
--- a/fs/gfs2/quota.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/gfs2/quota.c
@@ -38,6 +38,7 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
@@ -77,19 +78,20 @@ static LIST_HEAD(qd_lru_list);
 static atomic_t qd_lru_count = ATOMIC_INIT(0);
 static DEFINE_SPINLOCK(qd_lru_lock);
 
-int gfs2_shrink_qd_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+int gfs2_shrink_qd_memory(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct gfs2_quota_data *qd;
 	struct gfs2_sbd *sdp;
+	int nr_to_scan = sc->nr_to_scan;
 
-	if (nr == 0)
+	if (nr_to_scan == 0)
 		goto out;
 
-	if (!(gfp_mask & __GFP_FS))
+	if (!(sc->gfp_mask & __GFP_FS))
 		return -1;
 
 	spin_lock(&qd_lru_lock);
-	while (nr && !list_empty(&qd_lru_list)) {
+	while (nr_to_scan && !list_empty(&qd_lru_list)) {
 		qd = list_entry(qd_lru_list.next,
 				struct gfs2_quota_data, qd_reclaim);
 		sdp = qd->qd_gl->gl_sbd;
@@ -110,7 +112,7 @@ int gfs2_shrink_qd_memory(struct shrinke
 		spin_unlock(&qd_lru_lock);
 		kmem_cache_free(gfs2_quotad_cachep, qd);
 		spin_lock(&qd_lru_lock);
-		nr--;
+		nr_to_scan--;
 	}
 	spin_unlock(&qd_lru_lock);
 
diff -puN fs/gfs2/quota.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/gfs2/quota.h
--- a/fs/gfs2/quota.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/gfs2/quota.h
@@ -12,6 +12,7 @@
 
 struct gfs2_inode;
 struct gfs2_sbd;
+struct shrink_control;
 
 #define NO_QUOTA_CHANGE ((u32)-1)
 
@@ -51,7 +52,8 @@ static inline int gfs2_quota_lock_check(
 	return ret;
 }
 
-extern int gfs2_shrink_qd_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask);
+extern int gfs2_shrink_qd_memory(struct shrinker *shrink,
+				 struct shrink_control *sc);
 extern const struct quotactl_ops gfs2_quotactl_ops;
 
 #endif /* __QUOTA_DOT_H__ */
diff -puN fs/inode.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/inode.c
--- a/fs/inode.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/inode.c
@@ -751,8 +751,12 @@ static void prune_icache(int nr_to_scan)
  * This function is passed the number of inodes to scan, and it returns the
  * total number of remaining possibly-reclaimable inodes.
  */
-static int shrink_icache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+static int shrink_icache_memory(struct shrinker *shrink,
+				struct shrink_control *sc)
 {
+	int nr = sc->nr_to_scan;
+	gfp_t gfp_mask = sc->gfp_mask;
+
 	if (nr) {
 		/*
 		 * Nasty deadlock avoidance.  We may hold various FS locks,
diff -puN fs/mbcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/mbcache.c
--- a/fs/mbcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/mbcache.c
@@ -90,7 +90,8 @@ static DEFINE_SPINLOCK(mb_cache_spinlock
  * What the mbcache registers as to get shrunk dynamically.
  */
 
-static int mb_cache_shrink_fn(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask);
+static int mb_cache_shrink_fn(struct shrinker *shrink,
+			      struct shrink_control *sc);
 
 static struct shrinker mb_cache_shrinker = {
 	.shrink = mb_cache_shrink_fn,
@@ -156,18 +157,19 @@ forget:
  * gets low.
  *
  * @shrink: (ignored)
- * @nr_to_scan: Number of objects to scan
- * @gfp_mask: (ignored)
+ * @sc: shrink_control passed from reclaim
  *
  * Returns the number of objects which are present in the cache.
  */
 static int
-mb_cache_shrink_fn(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
+mb_cache_shrink_fn(struct shrinker *shrink, struct shrink_control *sc)
 {
 	LIST_HEAD(free_list);
 	struct mb_cache *cache;
 	struct mb_cache_entry *entry, *tmp;
 	int count = 0;
+	int nr_to_scan = sc->nr_to_scan;
+	gfp_t gfp_mask = sc->gfp_mask;
 
 	mb_debug("trying to free %d entries", nr_to_scan);
 	spin_lock(&mb_cache_spinlock);
diff -puN fs/nfs/dir.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/nfs/dir.c
--- a/fs/nfs/dir.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/nfs/dir.c
@@ -2042,11 +2042,14 @@ static void nfs_access_free_list(struct 
 	}
 }
 
-int nfs_access_cache_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
+int nfs_access_cache_shrinker(struct shrinker *shrink,
+			      struct shrink_control *sc)
 {
 	LIST_HEAD(head);
 	struct nfs_inode *nfsi, *next;
 	struct nfs_access_entry *cache;
+	int nr_to_scan = sc->nr_to_scan;
+	gfp_t gfp_mask = sc->gfp_mask;
 
 	if ((gfp_mask & GFP_KERNEL) != GFP_KERNEL)
 		return (nr_to_scan == 0) ? 0 : -1;
diff -puN fs/nfs/internal.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/nfs/internal.h
--- a/fs/nfs/internal.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/nfs/internal.h
@@ -234,7 +234,7 @@ extern int nfs_init_client(struct nfs_cl
 
 /* dir.c */
 extern int nfs_access_cache_shrinker(struct shrinker *shrink,
-					int nr_to_scan, gfp_t gfp_mask);
+					struct shrink_control *sc);
 
 /* inode.c */
 extern struct workqueue_struct *nfsiod_workqueue;
diff -puN fs/quota/dquot.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/quota/dquot.c
--- a/fs/quota/dquot.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/quota/dquot.c
@@ -691,8 +691,11 @@ static void prune_dqcache(int count)
  * This is called from kswapd when we think we need some
  * more memory
  */
-static int shrink_dqcache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+static int shrink_dqcache_memory(struct shrinker *shrink,
+				 struct shrink_control *sc)
 {
+	int nr = sc->nr_to_scan;
+
 	if (nr) {
 		spin_lock(&dq_list_lock);
 		prune_dqcache(nr);
diff -puN fs/xfs/linux-2.6/xfs_buf.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -1422,12 +1422,12 @@ restart:
 int
 xfs_buftarg_shrink(
 	struct shrinker		*shrink,
-	int			nr_to_scan,
-	gfp_t			mask)
+	struct shrink_control	*sc)
 {
 	struct xfs_buftarg	*btp = container_of(shrink,
 					struct xfs_buftarg, bt_shrinker);
 	struct xfs_buf		*bp;
+	int nr_to_scan = sc->nr_to_scan;
 	LIST_HEAD(dispose);
 
 	if (!nr_to_scan)
diff -puN fs/xfs/linux-2.6/xfs_sync.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/xfs/linux-2.6/xfs_sync.c
--- a/fs/xfs/linux-2.6/xfs_sync.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/xfs/linux-2.6/xfs_sync.c
@@ -1032,13 +1032,14 @@ xfs_reclaim_inodes(
 static int
 xfs_reclaim_inode_shrink(
 	struct shrinker	*shrink,
-	int		nr_to_scan,
-	gfp_t		gfp_mask)
+	struct shrink_control *sc)
 {
 	struct xfs_mount *mp;
 	struct xfs_perag *pag;
 	xfs_agnumber_t	ag;
 	int		reclaimable;
+	int nr_to_scan = sc->nr_to_scan;
+	gfp_t gfp_mask = sc->gfp_mask;
 
 	mp = container_of(shrink, struct xfs_mount, m_inode_shrink);
 	if (nr_to_scan) {
diff -puN fs/xfs/quota/xfs_qm.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/xfs/quota/xfs_qm.c
--- a/fs/xfs/quota/xfs_qm.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/xfs/quota/xfs_qm.c
@@ -60,7 +60,7 @@ STATIC void	xfs_qm_list_destroy(xfs_dqli
 
 STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
 STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
-STATIC int	xfs_qm_shake(struct shrinker *, int, gfp_t);
+STATIC int	xfs_qm_shake(struct shrinker *, struct shrink_control *);
 
 static struct shrinker xfs_qm_shaker = {
 	.shrink = xfs_qm_shake,
@@ -2009,10 +2009,10 @@ xfs_qm_shake_freelist(
 STATIC int
 xfs_qm_shake(
 	struct shrinker	*shrink,
-	int		nr_to_scan,
-	gfp_t		gfp_mask)
+	struct shrink_control *sc)
 {
 	int	ndqused, nfree, n;
+	gfp_t gfp_mask = sc->gfp_mask;
 
 	if (!kmem_shake_allow(gfp_mask))
 		return 0;
diff -puN include/linux/mm.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct include/linux/mm.h
--- a/include/linux/mm.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/include/linux/mm.h
@@ -1166,18 +1166,20 @@ static inline void sync_mm_rss(struct ta
  * We consolidate the values for easier extention later.
  */
 struct shrink_control {
-	unsigned long nr_scanned;
 	gfp_t gfp_mask;
+
+	/* How many slab objects shrinker() should scan and try to reclaim */
+	unsigned long nr_to_scan;
 };
 
 /*
  * A callback you can register to apply pressure to ageable caches.
  *
- * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should
- * look through the least-recently-used 'nr_to_scan' entries and
- * attempt to free them up.  It should return the number of objects
- * which remain in the cache.  If it returns -1, it means it cannot do
- * any scanning at this time (eg. there is a risk of deadlock).
+ * 'sc' is passed shrink_control which includes a count 'nr_to_scan'
+ * and a 'gfpmask'.  It should look through the least-recently-used
+ * 'nr_to_scan' entries and attempt to free them up.  It should return
+ * the number of objects which remain in the cache.  If it returns -1, it means
+ * it cannot do any scanning at this time (eg. there is a risk of deadlock).
  *
  * The 'gfpmask' refers to the allocation we are currently trying to
  * fulfil.
@@ -1186,7 +1188,7 @@ struct shrink_control {
  * querying the cache size, so a fastpath for that case is appropriate.
  */
 struct shrinker {
-	int (*shrink)(struct shrinker *, int nr_to_scan, gfp_t gfp_mask);
+	int (*shrink)(struct shrinker *, struct shrink_control *sc);
 	int seeks;	/* seeks to recreate an obj */
 
 	/* These are for internal use */
@@ -1643,7 +1645,8 @@ int in_gate_area_no_mm(unsigned long add
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(struct shrink_control *shrink,
-				unsigned long lru_pages);
+			  unsigned long nr_pages_scanned,
+			  unsigned long lru_pages);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
diff -puN mm/memory-failure.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct mm/memory-failure.c
--- a/mm/memory-failure.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/mm/memory-failure.c
@@ -241,10 +241,9 @@ void shake_page(struct page *p, int acce
 		do {
 			struct shrink_control shrink = {
 				.gfp_mask = GFP_KERNEL,
-				.nr_scanned = 1000,
 			};
 
-			nr = shrink_slab(&shrink, 1000);
+			nr = shrink_slab(&shrink, 1000, 1000);
 			if (page_count(p) == 1)
 				break;
 		} while (nr > 10);
diff -puN mm/vmscan.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct mm/vmscan.c
--- a/mm/vmscan.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/mm/vmscan.c
@@ -202,6 +202,14 @@ void unregister_shrinker(struct shrinker
 }
 EXPORT_SYMBOL(unregister_shrinker);
 
+static inline int do_shrinker_shrink(struct shrinker *shrinker,
+				     struct shrink_control *sc,
+				     unsigned long nr_to_scan)
+{
+	sc->nr_to_scan = nr_to_scan;
+	return (*shrinker->shrink)(shrinker, sc);
+}
+
 #define SHRINK_BATCH 128
 /*
  * Call the shrink functions to age shrinkable caches
@@ -223,15 +231,14 @@ EXPORT_SYMBOL(unregister_shrinker);
  * Returns the number of slab objects which we shrunk.
  */
 unsigned long shrink_slab(struct shrink_control *shrink,
+			  unsigned long nr_pages_scanned,
 			  unsigned long lru_pages)
 {
 	struct shrinker *shrinker;
 	unsigned long ret = 0;
-	unsigned long scanned = shrink->nr_scanned;
-	gfp_t gfp_mask = shrink->gfp_mask;
 
-	if (scanned == 0)
-		scanned = SWAP_CLUSTER_MAX;
+	if (nr_pages_scanned == 0)
+		nr_pages_scanned = SWAP_CLUSTER_MAX;
 
 	if (!down_read_trylock(&shrinker_rwsem)) {
 		/* Assume we'll be able to shrink next time */
@@ -244,8 +251,8 @@ unsigned long shrink_slab(struct shrink_
 		unsigned long total_scan;
 		unsigned long max_pass;
 
-		max_pass = (*shrinker->shrink)(shrinker, 0, gfp_mask);
-		delta = (4 * scanned) / shrinker->seeks;
+		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
+		delta = (4 * nr_pages_scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
 		shrinker->nr += delta;
@@ -272,9 +279,9 @@ unsigned long shrink_slab(struct shrink_
 			int shrink_ret;
 			int nr_before;
 
-			nr_before = (*shrinker->shrink)(shrinker, 0, gfp_mask);
-			shrink_ret = (*shrinker->shrink)(shrinker, this_scan,
-								gfp_mask);
+			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
+			shrink_ret = do_shrinker_shrink(shrinker, shrink,
+							this_scan);
 			if (shrink_ret == -1)
 				break;
 			if (shrink_ret < nr_before)
@@ -2072,8 +2079,7 @@ static unsigned long do_try_to_free_page
 				lru_pages += zone_reclaimable_pages(zone);
 			}
 
-			shrink->nr_scanned = sc->nr_scanned;
-			shrink_slab(shrink, lru_pages);
+			shrink_slab(shrink, sc->nr_scanned, lru_pages);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
@@ -2456,8 +2462,7 @@ loop_again:
 					end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
-			shrink.nr_scanned = sc.nr_scanned;
-			nr_slab = shrink_slab(&shrink, lru_pages);
+			nr_slab = shrink_slab(&shrink, sc.nr_scanned, lru_pages);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 
@@ -3025,7 +3030,6 @@ static int __zone_reclaim(struct zone *z
 	}
 
 	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
-	shrink.nr_scanned = sc.nr_scanned;
 	if (nr_slab_pages0 > zone->min_slab_pages) {
 		/*
 		 * shrink_slab() does not currently allow us to determine how
@@ -3041,7 +3045,7 @@ static int __zone_reclaim(struct zone *z
 			unsigned long lru_pages = zone_reclaimable_pages(zone);
 
 			/* No reclaimable slab or very low memory pressure */
-			if (!shrink_slab(&shrink, lru_pages))
+			if (!shrink_slab(&shrink, sc.nr_scanned, lru_pages))
 				break;
 
 			/* Freed enough memory */
diff -puN net/sunrpc/auth.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct net/sunrpc/auth.c
--- a/net/sunrpc/auth.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/net/sunrpc/auth.c
@@ -326,10 +326,12 @@ rpcauth_prune_expired(struct list_head *
  * Run memory cache shrinker.
  */
 static int
-rpcauth_cache_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
+rpcauth_cache_shrinker(struct shrinker *shrink, struct shrink_control *sc)
 {
 	LIST_HEAD(free);
 	int res;
+	int nr_to_scan = sc->nr_to_scan;
+	gfp_t gfp_mask = sc->gfp_mask;
 
 	if ((gfp_mask & GFP_KERNEL) != GFP_KERNEL)
 		return (nr_to_scan == 0) ? 0 : -1;
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch
memcg-add-memorynumastat-api-for-numa-statistics.patch
memcg-add-memorynumastat-api-for-numa-statistics-v5.patch
add-the-pagefault-count-into-memcg-stats.patch

