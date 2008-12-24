From: akpm@linux-foundation.org
Subject: + dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch added to -mm tree
Date: Wed, 24 Dec 2008 10:38:29 -0800
Message-ID: <200812241838.mBOIcTGI003790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067AbYLXSiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Dec 2008 13:38:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dbaryshkov@gmail.com, hannes@cmpxchg.org, mingo@elte.hu, penguin-kernel@i-love.sakura.ne.jp


The patch titled
     dma_alloc_from_coherent(): fix fallback to generic memory
has been added to the -mm tree.  Its filename is
     dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch

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
Subject: dma_alloc_from_coherent(): fix fallback to generic memory
From: Andrew Morton <akpm@linux-foundation.org>

If bitmap_find_free_region() fails and DMA_MEMORY_EXCLUSIVE is not set,
the function will fail to write anything to *ret and will return 1.             This will cause dma_alloc_coherent() to return an uninitialised value,
crashing the kernel, perhaps via DMA to a random address.

Fix that by changing it to return zero in this case, so the caller will
proceed to allocate the memory from the generic memory allocator.

Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma-coherent.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN kernel/dma-coherent.c~dma_alloc_from_coherent-fix-fallback-to-generic-memory kernel/dma-coherent.c
--- a/kernel/dma-coherent.c~dma_alloc_from_coherent-fix-fallback-to-generic-memory
+++ a/kernel/dma-coherent.c
@@ -116,11 +116,25 @@ int dma_alloc_from_coherent(struct devic
 		int page = bitmap_find_free_region(mem->bitmap, mem->size,
 						     order);
 		if (page >= 0) {
+			/*
+			 * Memory was found in the per-device arena.
+			 */
 			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
 			*ret = mem->virt_base + (page << PAGE_SHIFT);
 			memset(*ret, 0, size);
-		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE)
+		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE) {
+			/*
+			 * The per-device arena is exhausted and we are not
+			 * permitted to fall back to generic memory.
+			 */
 			*ret = NULL;
+		} else {
+			/*
+			 * The per-device arena is exhausted and we are
+			 * permitted to fall back to generic memory.
+			 */
+			 return 0;
+		}
 	}
 	return (mem != NULL);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

w1-fix-slave-selection-on-big-endian-systems.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
revert-sched-fix-uneven-per-cpu-task_group-share-distribution.patch
fs-dlm-astc-fix-warning.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-hrtimerc-kill-warning.patch
binfmtsh-include-listh-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch
dma_alloc_coherent-clean-it-up.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

