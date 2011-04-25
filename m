From: akpm@linux-foundation.org
Subject: + vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch added to -mm tree
Date: Mon, 25 Apr 2011 15:36:10 -0700
Message-ID: <201104252236.p3PMaAsN015122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756974Ab1DYWg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 18:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, xemul@openvz.org


The patch titled
     vmscan: change shrinker API by passing shrink_control struct
has been added to the -mm tree.  Its filename is
     vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: change shrinker API by passing shrink_control struct
From: Ying Han <yinghan@google.com>

Change each shrinker's API by consolidating the existing parameters into
shrink_control struct.  This will simplify any further features added w/o
touching each file of shrinker.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c                   |    3 ++-
 drivers/gpu/drm/i915/i915_gem.c      |    5 ++---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    4 +++-
 drivers/staging/zcache/zcache.c      |    5 ++++-
 fs/dcache.c                          |    8 ++++++--
 fs/gfs2/glock.c                      |    5 ++++-
 fs/inode.c                           |    6 +++++-
 fs/mbcache.c                         |   10 ++++++----
 fs/nfs/dir.c                         |    5 ++++-
 fs/nfs/internal.h                    |    2 +-
 fs/quota/dquot.c                     |    5 ++++-
 fs/xfs/linux-2.6/xfs_buf.c           |    4 ++--
 fs/xfs/linux-2.6/xfs_sync.c          |    5 +++--
 fs/xfs/quota/xfs_qm.c                |    7 ++++---
 include/linux/mm.h                   |   15 +++++++++------
 mm/vmscan.c                          |   11 +++++++----
 net/sunrpc/auth.c                    |    4 +++-
 17 files changed, 69 insertions(+), 35 deletions(-)

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
+	int nr_to_scan = sc->nr_slab_to_reclaim;
 
 	if (nr_to_scan == 0)
 		goto out;
diff -puN drivers/gpu/drm/i915/i915_gem.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -4094,9 +4094,7 @@ i915_gpu_is_active(struct drm_device *de
 }
 
 static int
-i915_gem_inactive_shrink(struct shrinker *shrinker,
-			 int nr_to_scan,
-			 gfp_t gfp_mask)
+i915_gem_inactive_shrink(struct shrinker *shrinker, struct shrink_control *sc)
 {
 	struct drm_i915_private *dev_priv =
 		container_of(shrinker,
@@ -4104,6 +4102,7 @@ i915_gem_inactive_shrink(struct shrinker
 			     mm.inactive_shrinker);
 	struct drm_device *dev = dev_priv->dev;
 	struct drm_i915_gem_object *obj, *next;
+	int nr_to_scan = sc->nr_slab_to_reclaim;
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
+	int shrink_pages = sc->nr_slab_to_reclaim;
 
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
+	int nr = sc->nr_slab_to_reclaim;
+	gfp_t gfp_mask = sc->gfp_mask;
 
 	if (nr >= 0) {
 		if (!(gfp_mask & __GFP_FS))
diff -puN fs/dcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/dcache.c
--- a/fs/dcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/dcache.c
@@ -1229,7 +1229,7 @@ void shrink_dcache_parent(struct dentry 
 EXPORT_SYMBOL(shrink_dcache_parent);
 
 /*
- * Scan `nr' dentries and return the number which remain.
+ * Scan `sc->nr_slab_to_reclaim' dentries and return the number which remain.
  *
  * We need to avoid reentering the filesystem if the caller is performing a
  * GFP_NOFS allocation attempt.  One example deadlock is:
@@ -1240,8 +1240,12 @@ EXPORT_SYMBOL(shrink_dcache_parent);
  *
  * In this case we return -1 to tell the caller that we baled.
  */
-static int shrink_dcache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+static int shrink_dcache_memory(struct shrinker *shrink,
+				struct shrink_control *sc)
 {
+	int nr = sc->nr_slab_to_reclaim;
+	gfp_t gfp_mask = sc->gfp_mask;
+
 	if (nr) {
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
diff -puN fs/gfs2/glock.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/gfs2/glock.c
@@ -1353,11 +1353,14 @@ void gfs2_glock_complete(struct gfs2_glo
 }
 
 
-static int gfs2_shrink_glock_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+static int gfs2_shrink_glock_memory(struct shrinker *shrink,
+				    struct shrink_control *sc)
 {
 	struct gfs2_glock *gl;
 	int may_demote;
 	int nr_skipped = 0;
+	int nr = sc->nr_slab_to_reclaim;
+	gfp_t gfp_mask = sc->gfp_mask;
 	LIST_HEAD(skipped);
 
 	if (nr == 0)
diff -puN fs/inode.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/inode.c
--- a/fs/inode.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/inode.c
@@ -750,8 +750,12 @@ static void prune_icache(int nr_to_scan)
  * This function is passed the number of inodes to scan, and it returns the
  * total number of remaining possibly-reclaimable inodes.
  */
-static int shrink_icache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+static int shrink_icache_memory(struct shrinker *shrink,
+				struct shrink_control *sc)
 {
+	int nr = sc->nr_slab_to_reclaim;
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
+	int nr_to_scan = sc->nr_slab_to_reclaim;
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
+	int nr_to_scan = sc->nr_slab_to_reclaim;
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
+	int nr = sc->nr_slab_to_reclaim;
+
 	if (nr) {
 		spin_lock(&dq_list_lock);
 		prune_dqcache(nr);
diff -puN fs/xfs/linux-2.6/xfs_buf.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -1402,12 +1402,12 @@ restart:
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
+	int nr_to_scan = sc->nr_slab_to_reclaim;
 	LIST_HEAD(dispose);
 
 	if (!nr_to_scan)
diff -puN fs/xfs/linux-2.6/xfs_sync.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct fs/xfs/linux-2.6/xfs_sync.c
--- a/fs/xfs/linux-2.6/xfs_sync.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/fs/xfs/linux-2.6/xfs_sync.c
@@ -1021,13 +1021,14 @@ xfs_reclaim_inodes(
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
+	int nr_to_scan = sc->nr_slab_to_reclaim;
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
@@ -2009,10 +2009,11 @@ xfs_qm_shake_freelist(
 STATIC int
 xfs_qm_shake(
 	struct shrinker	*shrink,
-	int		nr_to_scan,
-	gfp_t		gfp_mask)
+	struct shrink_control *sc)
 {
 	int	ndqused, nfree, n;
+	int nr_to_scan = sc->nr_slab_to_reclaim;
+	gfp_t gfp_mask = sc->gfp_mask;
 
 	if (!kmem_shake_allow(gfp_mask))
 		return 0;
diff -puN include/linux/mm.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct include/linux/mm.h
--- a/include/linux/mm.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/include/linux/mm.h
@@ -1146,16 +1146,19 @@ static inline void sync_mm_rss(struct ta
 struct shrink_control {
 	unsigned long nr_scanned;
 	gfp_t gfp_mask;
+
+	/* How many slab objects shrinker() should reclaim */
+	unsigned long nr_slab_to_reclaim;
 };
 
 /*
  * A callback you can register to apply pressure to ageable caches.
  *
- * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should
- * look through the least-recently-used 'nr_to_scan' entries and
- * attempt to free them up.  It should return the number of objects
- * which remain in the cache.  If it returns -1, it means it cannot do
- * any scanning at this time (eg. there is a risk of deadlock).
+ * 'sc' is passed shrink_control which includes a count 'nr_slab_to_reclaim'
+ * and a 'gfpmask'.  It should look through the least-recently-us
+ * 'nr_slab_to_reclaim' entries and attempt to free them up.  It should return
+ * the number of objects which remain in the cache.  If it returns -1, it means
+ * it cannot do any scanning at this time (eg. there is a risk of deadlock).
  *
  * The 'gfpmask' refers to the allocation we are currently trying to
  * fulfil.
@@ -1164,7 +1167,7 @@ struct shrink_control {
  * querying the cache size, so a fastpath for that case is appropriate.
  */
 struct shrinker {
-	int (*shrink)(struct shrinker *, int nr_to_scan, gfp_t gfp_mask);
+	int (*shrink)(struct shrinker *, struct shrink_control *sc);
 	int seeks;	/* seeks to recreate an obj */
 
 	/* These are for internal use */
diff -puN mm/vmscan.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct mm/vmscan.c
--- a/mm/vmscan.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct
+++ a/mm/vmscan.c
@@ -240,7 +240,8 @@ unsigned long shrink_slab(struct shrink_
 		unsigned long total_scan;
 		unsigned long max_pass;
 
-		max_pass = (*shrinker->shrink)(shrinker, 0, gfp_mask);
+		shrink->nr_slab_to_reclaim = 0;
+		max_pass = (*shrinker->shrink)(shrinker, shrink);
 		delta = (4 * scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
@@ -268,9 +269,11 @@ unsigned long shrink_slab(struct shrink_
 			int shrink_ret;
 			int nr_before;
 
-			nr_before = (*shrinker->shrink)(shrinker, 0, gfp_mask);
-			shrink_ret = (*shrinker->shrink)(shrinker, this_scan,
-								gfp_mask);
+			shrink->nr_slab_to_reclaim = 0;
+			nr_before = (*shrinker->shrink)(shrinker, shrink);
+			shrink->nr_slab_to_reclaim = this_scan;
+			shrink_ret = (*shrinker->shrink)(shrinker, shrink);
+
 			if (shrink_ret == -1)
 				break;
 			if (shrink_ret < nr_before)
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
+	int nr_to_scan = sc->nr_slab_to_reclaim;
+	gfp_t gfp_mask = sc->gfp_mask;
 
 	if ((gfp_mask & GFP_KERNEL) != GFP_KERNEL)
 		return (nr_to_scan == 0) ? 0 : -1;
_

Patches currently in -mm which might be from yinghan@google.com are

vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch

