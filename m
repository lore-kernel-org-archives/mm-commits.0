From: akpm@linux-foundation.org
Subject: + drivers-convert-shrinkers-to-new-count-scan-api-fix.patch added to -mm tree
Date: Thu, 06 Jun 2013 15:41:15 -0700
Message-ID: <51b1100b.8XFtGOTU8lVeNJeM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3FFWlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 18:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, akpm@linux-foundation.org

Subject: + drivers-convert-shrinkers-to-new-count-scan-api-fix.patch added to -mm tree
To: akpm@linux-foundation.org,dchinner@redhat.com,glommer@openvz.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 15:41:15 -0700


The patch titled
     Subject: drivers-convert-shrinkers-to-new-count-scan-api-fix
has been added to the -mm tree.  Its filename is
     drivers-convert-shrinkers-to-new-count-scan-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 drivers/staging/zcache/zcache-main.c      |   10 ++++----
 7 files changed, 45 insertions(+), 42 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem.c~drivers-convert-shrinkers-to-new-count-scan-api-fix drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~drivers-convert-shrinkers-to-new-count-scan-api-fix
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -53,10 +53,10 @@ static void i915_gem_object_update_fence
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
@@ -4483,7 +4483,7 @@ static bool mutex_is_locked_by(struct mu
 #endif
 }
 
-static long
+static unsigned long
 i915_gem_inactive_count(struct shrinker *shrinker, struct shrink_control *sc)
 {
 	struct drm_i915_private *dev_priv =
@@ -4493,7 +4493,7 @@ i915_gem_inactive_count(struct shrinker
 	struct drm_device *dev = dev_priv->dev;
 	struct drm_i915_gem_object *obj;
 	bool unlock = true;
-	long cnt;
+	unsigned long count;
 
 	if (!mutex_trylock(&dev->struct_mutex)) {
 		if (!mutex_is_locked_by(&dev->struct_mutex, current))
@@ -4505,19 +4505,20 @@ i915_gem_inactive_count(struct shrinker
 		unlock = false;
 	}
 
-	cnt = 0;
+	count = 0;
 	list_for_each_entry(obj, &dev_priv->mm.unbound_list, global_list)
 		if (obj->pages_pin_count == 0)
-			cnt += obj->base.size >> PAGE_SHIFT;
+			count += obj->base.size >> PAGE_SHIFT;
 	list_for_each_entry(obj, &dev_priv->mm.inactive_list, global_list)
 		if (obj->pin_count == 0 && obj->pages_pin_count == 0)
-			cnt += obj->base.size >> PAGE_SHIFT;
+			count += obj->base.size >> PAGE_SHIFT;
 
 	if (unlock)
 		mutex_unlock(&dev->struct_mutex);
-	return cnt;
+	return count;
 }
-static long
+
+static unsigned long
 i915_gem_inactive_scan(struct shrinker *shrinker, struct shrink_control *sc)
 {
 	struct drm_i915_private *dev_priv =
@@ -4526,7 +4527,7 @@ i915_gem_inactive_scan(struct shrinker *
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
@@ -598,12 +598,13 @@ static int mca_reap(struct btree *b, str
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
@@ -658,7 +659,8 @@ out:
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
@@ -1419,13 +1419,13 @@ static long __scan(struct dm_bufio_clien
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
@@ -1436,13 +1436,13 @@ dm_bufio_shrink_scan(struct shrinker *sh
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
@@ -1451,7 +1451,6 @@ dm_bufio_shrink_count(struct shrinker *s
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
diff -puN drivers/staging/zcache/zcache-main.c~drivers-convert-shrinkers-to-new-count-scan-api-fix drivers/staging/zcache/zcache-main.c
--- a/drivers/staging/zcache/zcache-main.c~drivers-convert-shrinkers-to-new-count-scan-api-fix
+++ a/drivers/staging/zcache/zcache-main.c
@@ -1140,15 +1140,15 @@ static bool zcache_freeze;
  * pageframes in use.  FIXME POLICY: Probably the writeback should only occur
  * if the eviction doesn't free enough pages.
  */
-static long scan_zcache_memory(struct shrinker *shrink,
-			       struct shrink_control *sc)
+static unsigned long scan_zcache_memory(struct shrinker *shrink,
+					struct shrink_control *sc)
 {
 	static bool in_progress;
 	int nr_evict = 0;
 	int nr_writeback = 0;
 	struct page *page;
 	int  file_pageframes_inuse, anon_pageframes_inuse;
-	long freed = 0;
+	unsigned long freed = 0;
 
 	/* don't allow more than one eviction thread at a time */
 	if (in_progress)
@@ -1200,10 +1200,10 @@ static long scan_zcache_memory(struct sh
 	return freed;
 }
 
-static long count_zcache_memory(struct shrinker *shrink,
+static unsigned long count_zcache_memory(struct shrinker *shrink,
 				struct shrink_control *sc)
 {
-	int ret = -1;
+	long ret = -1;
 
 	/* resample: has changed, but maybe not all the way yet */
 	zcache_last_active_file_pageframes =
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel-fix.patch
drivers-base-cpuc-fix-maxcpus-boot-option-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

