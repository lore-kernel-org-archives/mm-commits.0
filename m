From: akpm@linux-foundation.org
Subject: + drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
 added to -mm tree
Date: Thu, 06 Jun 2013 15:59:37 -0700
Message-ID: <51b11459.CvjjtUlCAlbTTo7C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3FFW7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 18:59:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, akpm@linux-foundation.org

Subject: + drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch added to -mm tree
To: akpm@linux-foundation.org,dchinner@redhat.com,glommer@openvz.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 15:59:37 -0700


The patch titled
     Subject: drivers-convert-shrinkers-to-new-count-scan-api-fix-2
has been added to the -mm tree.  Its filename is
     drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch

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
xfs-convert-buftarg-lru-to-generic-code-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
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

