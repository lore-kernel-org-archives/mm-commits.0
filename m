From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch removed from
 -mm tree
Date: Tue, 10 Sep 2013 15:32:21 -0700
Message-ID: <522f9df5.Q7E0/LPQUHwcMiI1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3IJWcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 18:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch removed from -mm tree
To: akpm@linux-foundation.org,dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 15:32:21 -0700


The patch titled
     Subject: drivers-convert-shrinkers-to-new-count-scan-api-fix-2
has been removed from the -mm tree.  Its filename was
     drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch

This patch was dropped because it was folded into drivers-convert-shrinkers-to-new-count-scan-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-convert-shrinkers-to-new-count-scan-api-fix-2

fix warnings

Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/gpu/drm/ttm/ttm_page_alloc_dma.c~drivers-convert-shrinkers-to-new-count-scan-api-fix-2 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c~drivers-convert-shrinkers-to-new-count-scan-api-fix-2
+++ a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -1000,7 +1000,7 @@ EXPORT_SYMBOL_GPL(ttm_dma_unpopulate);
  * I'm getting sadder as I hear more pathetical whimpers about needing per-pool
  * shrinkers
  */
-static long
+static unsigned long
 ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	static atomic_t start_pool = ATOMIC_INIT(0);
@@ -1008,7 +1008,7 @@ ttm_dma_pool_shrink_scan(struct shrinker
 	unsigned pool_offset = atomic_add_return(1, &start_pool);
 	unsigned shrink_pages = sc->nr_to_scan;
 	struct device_pools *p;
-	long freed = 0;
+	unsigned long freed = 0;
 
 	if (list_empty(&_manager->pools))
 		return SHRINK_STOP;
@@ -1037,11 +1037,11 @@ ttm_dma_pool_shrink_scan(struct shrinker
 	return freed;
 }
 
-static long
+static unsigned long
 ttm_dma_pool_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct device_pools *p;
-	long count = 0;
+	unsigned long count = 0;
 
 	mutex_lock(&_manager->lock);
 	list_for_each_entry(p, &_manager->pools, pools)
@@ -1052,7 +1052,7 @@ ttm_dma_pool_shrink_count(struct shrinke
 
 static void ttm_dma_pool_mm_shrink_init(struct ttm_pool_manager *manager)
 {
-	manager->mm_shrink.count_objects = &ttm_dma_pool_shrink_count;
+	manager->mm_shrink.count_objects = ttm_dma_pool_shrink_count;
 	manager->mm_shrink.scan_objects = &ttm_dma_pool_shrink_scan;
 	manager->mm_shrink.seeks = 1;
 	register_shrinker(&manager->mm_shrink);
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

