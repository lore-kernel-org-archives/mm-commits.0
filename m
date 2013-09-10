From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-convert-shrinkers-to-new-count-scan-api-fix.patch removed from -mm
 tree
Date: Tue, 10 Sep 2013 15:32:19 -0700
Message-ID: <522f9df3.C3Zr2ATAlSUCqHx4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3IJWcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 18:32:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] drivers-convert-shrinkers-to-new-count-scan-api-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 15:32:19 -0700


The patch titled
     Subject: drivers-convert-shrinkers-to-new-count-scan-api-fix
has been removed from the -mm tree.  Its filename was
     drivers-convert-shrinkers-to-new-count-scan-api-fix.patch

This patch was dropped because it was folded into drivers-convert-shrinkers-to-new-count-scan-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-convert-shrinkers-to-new-count-scan-api-fix

fix warnings

Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem.c           |   25 ++++++++++----------
 drivers/gpu/drm/ttm/ttm_page_alloc.c      |   12 ++++-----
 drivers/md/bcache/btree.c                 |    8 ++++--
 drivers/md/dm-bufio.c                     |   17 ++++++-------
 drivers/staging/android/ashmem.c          |    6 ++--
 drivers/staging/android/lowmemorykiller.c |    9 ++++---
 6 files changed, 40 insertions(+), 37 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem.c~drivers-convert-shrinkers-to-new-count-scan-api-fix drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~drivers-convert-shrinkers-to-new-count-scan-api-fix
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -57,10 +57,10 @@ static void i915_gem_object_update_fence
 					 struct drm_i915_fence_reg *fence,
 					 bool enable);
 
-static long i915_gem_inactive_count(struct shrinker *shrinker,
-				    struct shrink_control *sc);
-static long i915_gem_inactive_scan(struct shrinker *shrinker,
-				   struct shrink_control *sc);
+static unsigned long i915_gem_inactive_count(struct shrinker *shrinker,
+					     struct shrink_control *sc);
+static unsigned long i915_gem_inactive_scan(struct shrinker *shrinker,
+					    struct shrink_control *sc);
 static long i915_gem_purge(struct drm_i915_private *dev_priv, long target);
 static long i915_gem_shrink_all(struct drm_i915_private *dev_priv);
 static void i915_gem_object_truncate(struct drm_i915_gem_object *obj);
@@ -4757,7 +4757,7 @@ static bool mutex_is_locked_by(struct mu
 #endif
 }
 
-static long
+static unsigned long
 i915_gem_inactive_count(struct shrinker *shrinker, struct shrink_control *sc)
 {
 	struct drm_i915_private *dev_priv =
@@ -4767,7 +4767,7 @@ i915_gem_inactive_count(struct shrinker
 	struct drm_device *dev = dev_priv->dev;
 	struct drm_i915_gem_object *obj;
 	bool unlock = true;
-	long cnt;
+	unsigned long count;
 
 	if (!mutex_trylock(&dev->struct_mutex)) {
 		if (!mutex_is_locked_by(&dev->struct_mutex, current))
@@ -4779,22 +4779,22 @@ i915_gem_inactive_count(struct shrinker
 		unlock = false;
 	}
 
-	cnt = 0;
+	count = 0;
 	list_for_each_entry(obj, &dev_priv->mm.unbound_list, global_list)
 		if (obj->pages_pin_count == 0)
-			cnt += obj->base.size >> PAGE_SHIFT;
+			count += obj->base.size >> PAGE_SHIFT;
 
 	list_for_each_entry(obj, &dev_priv->mm.bound_list, global_list) {
 		if (obj->active)
 			continue;
 
 		if (obj->pin_count == 0 && obj->pages_pin_count == 0)
-			cnt += obj->base.size >> PAGE_SHIFT;
+			count += obj->base.size >> PAGE_SHIFT;
 	}
 
 	if (unlock)
 		mutex_unlock(&dev->struct_mutex);
-	return cnt;
+	return count;
 }
 
 /* All the new VM stuff */
@@ -4881,7 +4881,8 @@ i915_gem_obj_lookup_or_create_vma(struct
 
 	return vma;
 }
-static long
+
+static unsigned long
 i915_gem_inactive_scan(struct shrinker *shrinker, struct shrink_control *sc)
 {
 	struct drm_i915_private *dev_priv =
@@ -4890,7 +4891,7 @@ i915_gem_inactive_scan(struct shrinker *
 			     mm.inactive_shrinker);
 	struct drm_device *dev = dev_priv->dev;
 	int nr_to_scan = sc->nr_to_scan;
-	long freed;
+	unsigned long freed;
 	bool unlock = true;
 
 	if (!mutex_trylock(&dev->struct_mutex)) {
diff -puN drivers/gpu/drm/ttm/ttm_page_alloc.c~drivers-convert-shrinkers-to-new-count-scan-api-fix drivers/gpu/drm/ttm/ttm_page_alloc.c
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c~drivers-convert-shrinkers-to-new-count-scan-api-fix
+++ a/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -388,7 +388,7 @@ out:
  *
  * This code is crying out for a shrinker per pool....
  */
-static long
+static unsigned long
 ttm_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	static atomic_t start_pool = ATOMIC_INIT(0);
@@ -396,7 +396,7 @@ ttm_pool_shrink_scan(struct shrinker *sh
 	unsigned pool_offset = atomic_add_return(1, &start_pool);
 	struct ttm_page_pool *pool;
 	int shrink_pages = sc->nr_to_scan;
-	long freed = 0;
+	unsigned long freed = 0;
 
 	pool_offset = pool_offset % NUM_POOLS;
 	/* select start pool in round robin fashion */
@@ -412,11 +412,11 @@ ttm_pool_shrink_scan(struct shrinker *sh
 }
 
 
-static long
+static unsigned long
 ttm_pool_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	unsigned i;
-	long count = 0;
+	unsigned long count = 0;
 
 	for (i = 0; i < NUM_POOLS; ++i)
 		count += _manager->pools[i].npages;
@@ -426,8 +426,8 @@ ttm_pool_shrink_count(struct shrinker *s
 
 static void ttm_pool_mm_shrink_init(struct ttm_pool_manager *manager)
 {
-	manager->mm_shrink.count_objects = &ttm_pool_shrink_count;
-	manager->mm_shrink.scan_objects = &ttm_pool_shrink_scan;
+	manager->mm_shrink.count_objects = ttm_pool_shrink_count;
+	manager->mm_shrink.scan_objects = ttm_pool_shrink_scan;
 	manager->mm_shrink.seeks = 1;
 	register_shrinker(&manager->mm_shrink);
 }
diff -puN drivers/md/bcache/btree.c~drivers-convert-shrinkers-to-new-count-scan-api-fix drivers/md/bcache/btree.c
--- a/drivers/md/bcache/btree.c~drivers-convert-shrinkers-to-new-count-scan-api-fix
+++ a/drivers/md/bcache/btree.c
@@ -597,12 +597,13 @@ static int mca_reap(struct btree *b, str
 	return 0;
 }
 
-static long bch_mca_scan(struct shrinker *shrink, struct shrink_control *sc)
+static unsigned long bch_mca_scan(struct shrinker *shrink,
+				  struct shrink_control *sc)
 {
 	struct cache_set *c = container_of(shrink, struct cache_set, shrink);
 	struct btree *b, *t;
 	unsigned long i, nr = sc->nr_to_scan;
-	long freed = 0;
+	unsigned long freed = 0;
 
 	if (c->shrinker_disabled)
 		return SHRINK_STOP;
@@ -664,7 +665,8 @@ out:
 	return freed;
 }
 
-static long bch_mca_count(struct shrinker *shrink, struct shrink_control *sc)
+static unsigned long bch_mca_count(struct shrinker *shrink,
+				   struct shrink_control *sc)
 {
 	struct cache_set *c = container_of(shrink, struct cache_set, shrink);
 
diff -puN drivers/md/dm-bufio.c~drivers-convert-shrinkers-to-new-count-scan-api-fix drivers/md/dm-bufio.c
--- a/drivers/md/dm-bufio.c~drivers-convert-shrinkers-to-new-count-scan-api-fix
+++ a/drivers/md/dm-bufio.c
@@ -1462,13 +1462,13 @@ static long __scan(struct dm_bufio_clien
 	return freed;
 }
 
-static long
+static unsigned long
 dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
-	struct dm_bufio_client *c =
-	    container_of(shrink, struct dm_bufio_client, shrinker);
-	long freed;
+	struct dm_bufio_client *c;
+	unsigned long freed;
 
+	c = container_of(shrink, struct dm_bufio_client, shrinker);
 	if (sc->gfp_mask & __GFP_IO)
 		dm_bufio_lock(c);
 	else if (!dm_bufio_trylock(c))
@@ -1479,13 +1479,13 @@ dm_bufio_shrink_scan(struct shrinker *sh
 	return freed;
 }
 
-static long
+static unsigned long
 dm_bufio_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	struct dm_bufio_client *c =
-	    container_of(shrink, struct dm_bufio_client, shrinker);
-	long count;
+	struct dm_bufio_client *c;
+	unsigned long count;
 
+	c = container_of(shrink, struct dm_bufio_client, shrinker);
 	if (sc->gfp_mask & __GFP_IO)
 		dm_bufio_lock(c);
 	else if (!dm_bufio_trylock(c))
@@ -1494,7 +1494,6 @@ dm_bufio_shrink_count(struct shrinker *s
 	count = c->n_buffers[LIST_CLEAN] + c->n_buffers[LIST_DIRTY];
 	dm_bufio_unlock(c);
 	return count;
-
 }
 
 /*
diff -puN drivers/staging/android/ashmem.c~drivers-convert-shrinkers-to-new-count-scan-api-fix drivers/staging/android/ashmem.c
--- a/drivers/staging/android/ashmem.c~drivers-convert-shrinkers-to-new-count-scan-api-fix
+++ a/drivers/staging/android/ashmem.c
@@ -352,11 +352,11 @@ out:
  * chunks of ashmem regions LRU-wise one-at-a-time until we hit 'nr_to_scan'
  * pages freed.
  */
-static long
+static unsigned long
 ashmem_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct ashmem_range *range, *next;
-	long freed = 0;
+	unsigned long freed = 0;
 
 	/* We might recurse into filesystem code, so bail out if necessary */
 	if (!(sc->gfp_mask & __GFP_FS))
@@ -381,7 +381,7 @@ ashmem_shrink_scan(struct shrinker *shri
 	return freed;
 }
 
-static long
+static unsigned long
 ashmem_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	/*
diff -puN drivers/staging/android/lowmemorykiller.c~drivers-convert-shrinkers-to-new-count-scan-api-fix drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~drivers-convert-shrinkers-to-new-count-scan-api-fix
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -66,7 +66,8 @@ static unsigned long lowmem_deathpending
 			pr_info(x);			\
 	} while (0)
 
-static long lowmem_count(struct shrinker *s, struct shrink_control *sc)
+static unsigned long lowmem_count(struct shrinker *s,
+				  struct shrink_control *sc)
 {
 	return global_page_state(NR_ACTIVE_ANON) +
 		global_page_state(NR_ACTIVE_FILE) +
@@ -74,11 +75,11 @@ static long lowmem_count(struct shrinker
 		global_page_state(NR_INACTIVE_FILE);
 }
 
-static long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
+static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
 {
 	struct task_struct *tsk;
 	struct task_struct *selected = NULL;
-	int rem = 0;
+	unsigned long rem = 0;
 	int tasksize;
 	int i;
 	short min_score_adj = OOM_SCORE_ADJ_MAX + 1;
@@ -163,7 +164,7 @@ static long lowmem_scan(struct shrinker
 		rem += selected_tasksize;
 	}
 
-	lowmem_print(4, "lowmem_scan %lu, %x, return %d\n",
+	lowmem_print(4, "lowmem_scan %lu, %x, return %lu\n",
 		     sc->nr_to_scan, sc->gfp_mask, rem);
 	rcu_read_unlock();
 	return rem;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-page-writebackc-add-strictlimit-feature-fix.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
vfs-allow-umount-to-handle-mountpoints-without-revalidating-them-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
revert-1.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

