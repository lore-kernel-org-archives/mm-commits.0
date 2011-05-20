From: akpm@linux-foundation.org
Subject: + vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch added to -mm tree
Date: Fri, 20 May 2011 11:59:15 -0700
Message-ID: <201105201859.p4KIxGrK024683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933899Ab1ETTAR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 May 2011 15:00:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, xemul@openvz.org, yinghan@google.com


The patch titled
     vmscan: fix up new shrinker API
has been added to the -mm tree.  Its filename is
     vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch

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
Subject: vmscan: fix up new shrinker API
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Current new shrinker API submission has some easy mistake. Fix it up.

- remove nr_scanned field from shrink_control.
   we don't have to expose vmscan internal to shrinkers.
- rename nr_slab_to_reclaim to nr_to_scan.
   to_reclaim is very wrong name. shrinker API allow shrinker
   don't reclaim an slab object if they were recently accessed.
- typo: least-recently-us

This patch also make do_shrinker_shrink() helper function. It
increase code readability a bit.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c                   |    2 -
 drivers/gpu/drm/i915/i915_gem.c      |    2 -
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    2 -
 drivers/staging/zcache/zcache.c      |    2 -
 fs/dcache.c                          |    2 -
 fs/drop_caches.c                     |    3 --
 fs/gfs2/glock.c                      |    2 -
 fs/inode.c                           |    2 -
 fs/mbcache.c                         |    2 -
 fs/nfs/dir.c                         |    2 -
 fs/quota/dquot.c                     |    2 -
 fs/xfs/linux-2.6/xfs_buf.c           |    2 -
 fs/xfs/linux-2.6/xfs_sync.c          |    2 -
 fs/xfs/quota/xfs_qm.c                |    2 -
 include/linux/mm.h                   |   14 ++++-----
 mm/memory-failure.c                  |    3 --
 mm/vmscan.c                          |   36 +++++++++++++------------
 17 files changed, 41 insertions(+), 41 deletions(-)

diff -puN arch/x86/kvm/mmu.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/arch/x86/kvm/mmu.c
@@ -3549,7 +3549,7 @@ static int mmu_shrink(struct shrinker *s
 {
 	struct kvm *kvm;
 	struct kvm *kvm_freed = NULL;
-	int nr_to_scan = sc->nr_slab_to_reclaim;
+	int nr_to_scan = sc->nr_to_scan;
 
 	if (nr_to_scan == 0)
 		goto out;
diff -puN drivers/gpu/drm/i915/i915_gem.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -4098,7 +4098,7 @@ i915_gem_inactive_shrink(struct shrinker
 			     mm.inactive_shrinker);
 	struct drm_device *dev = dev_priv->dev;
 	struct drm_i915_gem_object *obj, *next;
-	int nr_to_scan = sc->nr_slab_to_reclaim;
+	int nr_to_scan = sc->nr_to_scan;
 	int cnt;
 
 	if (!mutex_trylock(&dev->struct_mutex))
diff -puN drivers/gpu/drm/ttm/ttm_page_alloc.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 drivers/gpu/drm/ttm/ttm_page_alloc.c
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -402,7 +402,7 @@ static int ttm_pool_mm_shrink(struct shr
 	unsigned i;
 	unsigned pool_offset = atomic_add_return(1, &start_pool);
 	struct ttm_page_pool *pool;
-	int shrink_pages = sc->nr_slab_to_reclaim;
+	int shrink_pages = sc->nr_to_scan;
 
 	pool_offset = pool_offset % NUM_POOLS;
 	/* select start pool in round robin fashion */
diff -puN drivers/staging/zcache/zcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 drivers/staging/zcache/zcache.c
--- a/drivers/staging/zcache/zcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/drivers/staging/zcache/zcache.c
@@ -1185,7 +1185,7 @@ static int shrink_zcache_memory(struct s
 				struct shrink_control *sc)
 {
 	int ret = -1;
-	int nr = sc->nr_slab_to_reclaim;
+	int nr = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 
 	if (nr >= 0) {
diff -puN fs/dcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 fs/dcache.c
--- a/fs/dcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/fs/dcache.c
@@ -1234,7 +1234,7 @@ EXPORT_SYMBOL(shrink_dcache_parent);
 static int shrink_dcache_memory(struct shrinker *shrink,
 				struct shrink_control *sc)
 {
-	int nr = sc->nr_slab_to_reclaim;
+	int nr = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 
 	if (nr) {
diff -puN fs/drop_caches.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 fs/drop_caches.c
--- a/fs/drop_caches.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
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
 
diff -puN fs/gfs2/glock.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/fs/gfs2/glock.c
@@ -1352,7 +1352,7 @@ static int gfs2_shrink_glock_memory(stru
 	struct gfs2_glock *gl;
 	int may_demote;
 	int nr_skipped = 0;
-	int nr = sc->nr_slab_to_reclaim;
+	int nr = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 	LIST_HEAD(skipped);
 
diff -puN fs/inode.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 fs/inode.c
--- a/fs/inode.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/fs/inode.c
@@ -753,7 +753,7 @@ static void prune_icache(int nr_to_scan)
 static int shrink_icache_memory(struct shrinker *shrink,
 				struct shrink_control *sc)
 {
-	int nr = sc->nr_slab_to_reclaim;
+	int nr = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 
 	if (nr) {
diff -puN fs/mbcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 fs/mbcache.c
--- a/fs/mbcache.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/fs/mbcache.c
@@ -168,7 +168,7 @@ mb_cache_shrink_fn(struct shrinker *shri
 	struct mb_cache *cache;
 	struct mb_cache_entry *entry, *tmp;
 	int count = 0;
-	int nr_to_scan = sc->nr_slab_to_reclaim;
+	int nr_to_scan = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 
 	mb_debug("trying to free %d entries", nr_to_scan);
diff -puN fs/nfs/dir.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 fs/nfs/dir.c
--- a/fs/nfs/dir.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/fs/nfs/dir.c
@@ -2048,7 +2048,7 @@ int nfs_access_cache_shrinker(struct shr
 	LIST_HEAD(head);
 	struct nfs_inode *nfsi, *next;
 	struct nfs_access_entry *cache;
-	int nr_to_scan = sc->nr_slab_to_reclaim;
+	int nr_to_scan = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 
 	if ((gfp_mask & GFP_KERNEL) != GFP_KERNEL)
diff -puN fs/quota/dquot.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 fs/quota/dquot.c
--- a/fs/quota/dquot.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/fs/quota/dquot.c
@@ -694,7 +694,7 @@ static void prune_dqcache(int count)
 static int shrink_dqcache_memory(struct shrinker *shrink,
 				 struct shrink_control *sc)
 {
-	int nr = sc->nr_slab_to_reclaim;
+	int nr = sc->nr_to_scan;
 
 	if (nr) {
 		spin_lock(&dq_list_lock);
diff -puN fs/xfs/linux-2.6/xfs_buf.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -1406,7 +1406,7 @@ xfs_buftarg_shrink(
 	struct xfs_buftarg	*btp = container_of(shrink,
 					struct xfs_buftarg, bt_shrinker);
 	struct xfs_buf		*bp;
-	int nr_to_scan = sc->nr_slab_to_reclaim;
+	int nr_to_scan = sc->nr_to_scan;
 	LIST_HEAD(dispose);
 
 	if (!nr_to_scan)
diff -puN fs/xfs/linux-2.6/xfs_sync.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 fs/xfs/linux-2.6/xfs_sync.c
--- a/fs/xfs/linux-2.6/xfs_sync.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/fs/xfs/linux-2.6/xfs_sync.c
@@ -1028,7 +1028,7 @@ xfs_reclaim_inode_shrink(
 	struct xfs_perag *pag;
 	xfs_agnumber_t	ag;
 	int		reclaimable;
-	int nr_to_scan = sc->nr_slab_to_reclaim;
+	int nr_to_scan = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 
 	mp = container_of(shrink, struct xfs_mount, m_inode_shrink);
diff -puN fs/xfs/quota/xfs_qm.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 fs/xfs/quota/xfs_qm.c
--- a/fs/xfs/quota/xfs_qm.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/fs/xfs/quota/xfs_qm.c
@@ -2012,7 +2012,7 @@ xfs_qm_shake(
 	struct shrink_control *sc)
 {
 	int	ndqused, nfree, n;
-	int nr_to_scan = sc->nr_slab_to_reclaim;
+	int nr_to_scan = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 
 	if (!kmem_shake_allow(gfp_mask))
diff -puN include/linux/mm.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 include/linux/mm.h
--- a/include/linux/mm.h~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/include/linux/mm.h
@@ -1166,19 +1166,18 @@ static inline void sync_mm_rss(struct ta
  * We consolidate the values for easier extention later.
  */
 struct shrink_control {
-	unsigned long nr_scanned;
 	gfp_t gfp_mask;
 
-	/* How many slab objects shrinker() should reclaim */
-	unsigned long nr_slab_to_reclaim;
+	/* How many slab objects shrinker() should scan and try to reclaim */
+	unsigned long nr_to_scan;
 };
 
 /*
  * A callback you can register to apply pressure to ageable caches.
  *
- * 'sc' is passed shrink_control which includes a count 'nr_slab_to_reclaim'
- * and a 'gfpmask'.  It should look through the least-recently-us
- * 'nr_slab_to_reclaim' entries and attempt to free them up.  It should return
+ * 'sc' is passed shrink_control which includes a count 'nr_to_scan'
+ * and a 'gfpmask'.  It should look through the least-recently-used
+ * 'nr_to_scan' entries and attempt to free them up.  It should return
  * the number of objects which remain in the cache.  If it returns -1, it means
  * it cannot do any scanning at this time (eg. there is a risk of deadlock).
  *
@@ -1646,7 +1645,8 @@ int in_gate_area_no_mm(unsigned long add
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(struct shrink_control *shrink,
-				unsigned long lru_pages);
+			  unsigned long nr_pages_scanned,
+			  unsigned long lru_pages);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
diff -puN mm/memory-failure.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 mm/memory-failure.c
--- a/mm/memory-failure.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
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
diff -puN mm/vmscan.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3 mm/vmscan.c
--- a/mm/vmscan.c~vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3
+++ a/mm/vmscan.c
@@ -201,6 +201,14 @@ void unregister_shrinker(struct shrinker
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
@@ -222,14 +230,14 @@ EXPORT_SYMBOL(unregister_shrinker);
  * Returns the number of slab objects which we shrunk.
  */
 unsigned long shrink_slab(struct shrink_control *shrink,
+			  unsigned long nr_pages_scanned,
 			  unsigned long lru_pages)
 {
 	struct shrinker *shrinker;
 	unsigned long ret = 0;
-	unsigned long scanned = shrink->nr_scanned;
 
-	if (scanned == 0)
-		scanned = SWAP_CLUSTER_MAX;
+	if (nr_pages_scanned == 0)
+		nr_pages_scanned = SWAP_CLUSTER_MAX;
 
 	if (!down_read_trylock(&shrinker_rwsem))
 		return 1;	/* Assume we'll be able to shrink next time */
@@ -239,9 +247,8 @@ unsigned long shrink_slab(struct shrink_
 		unsigned long total_scan;
 		unsigned long max_pass;
 
-		shrink->nr_slab_to_reclaim = 0;
-		max_pass = (*shrinker->shrink)(shrinker, shrink);
-		delta = (4 * scanned) / shrinker->seeks;
+		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
+		delta = (4 * nr_pages_scanned) / shrinker->seeks;
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
 		shrinker->nr += delta;
@@ -268,11 +275,9 @@ unsigned long shrink_slab(struct shrink_
 			int shrink_ret;
 			int nr_before;
 
-			shrink->nr_slab_to_reclaim = 0;
-			nr_before = (*shrinker->shrink)(shrinker, shrink);
-			shrink->nr_slab_to_reclaim = this_scan;
-			shrink_ret = (*shrinker->shrink)(shrinker, shrink);
-
+			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
+			shrink_ret = do_shrinker_shrink(shrinker, shrink,
+							this_scan);
 			if (shrink_ret == -1)
 				break;
 			if (shrink_ret < nr_before)
@@ -2068,8 +2073,7 @@ static unsigned long do_try_to_free_page
 				lru_pages += zone_reclaimable_pages(zone);
 			}
 
-			shrink->nr_scanned = sc->nr_scanned;
-			shrink_slab(shrink, lru_pages);
+			shrink_slab(shrink, sc->nr_scanned, lru_pages);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
@@ -2456,8 +2460,7 @@ loop_again:
 					end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
-			shrink.nr_scanned = sc.nr_scanned;
-			nr_slab = shrink_slab(&shrink, lru_pages);
+			nr_slab = shrink_slab(&shrink, sc.nr_scanned, lru_pages);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 
@@ -3025,7 +3028,6 @@ static int __zone_reclaim(struct zone *z
 	}
 
 	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
-	shrink.nr_scanned = sc.nr_scanned;
 	if (nr_slab_pages0 > zone->min_slab_pages) {
 		/*
 		 * shrink_slab() does not currently allow us to determine how
@@ -3041,7 +3043,7 @@ static int __zone_reclaim(struct zone *z
 			unsigned long lru_pages = zone_reclaimable_pages(zone);
 
 			/* No reclaimable slab or very low memory pressure */
-			if (!shrink_slab(&shrink, lru_pages))
+			if (!shrink_slab(&shrink, sc.nr_scanned, lru_pages))
 				break;
 
 			/* Freed enough memory */
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
slab-use-numa_no_node.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix-2.patch
mm-increase-reclaim_distance-to-30.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
mem-hotplug-call-isolate_lru_page-with-elevated-refcount.patch
mem-hwpoison-fix-page-refcount-around-isolate_lru_page.patch
mm-strictly-require-elevated-page-refcount-in-isolate_lru_page.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix.patch
mm-check-if-any-page-in-a-pageblock-is-reserved-before-marking-it-migrate_reserve-fix-2.patch
readahead-readahead-page-allocations-are-ok-to-fail.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch
mm-export-get_vma_policy.patch
mm-use-walk_page_range-instead-of-custom-page-table-walking-code.patch
mm-remove-mpol_mf_stats.patch
mm-make-gather_stats-type-safe-and-remove-forward-declaration.patch
mm-remove-check_huge_range.patch
mm-declare-mpol_to_str-when-config_tmpfs=n.patch
mm-proc-move-show_numa_map-to-fs-proc-task_mmuc.patch
proc-make-struct-proc_maps_private-truly-private.patch
proc-allocate-storage-for-numa_maps-statistics-once.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
alpha-replace-with-new-cpumask-apis.patch
m32r-convert-cpumask-api.patch
m32r-fix-spin_lock_irqsave-misuse.patch
m32r-remove-redundant-declaration.patch
mn10300-convert-old-cpumask-api-into-new-one.patch
cris-convert-old-cpumask-api-into-new-one.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
sparse-define-dummy-build_bug_on-definition-for-sparse.patch
sparse-define-__must_be_array-for-__checker__.patch
sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch
getdelays-show-average-cpu-io-swap-reclaim-delays.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

