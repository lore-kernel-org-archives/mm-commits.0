From: akpm@linux-foundation.org
Subject: [folded] block-document-blk-plug-fix.patch removed from -mm tree
Date: Tue, 06 Sep 2011 12:45:51 -0700
Message-ID: <201109061945.p86JjpNG025073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419Ab1IFTp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 15:45:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, corbet@lwn.net, shaohua.li@intel.com, sjayaraman@suse.de, mm-commits@vger.kernel.org


The patch titled
     block-document-blk-plug-fix
has been removed from the -mm tree.  Its filename was
     block-document-blk-plug-fix.patch

This patch was dropped because it was folded into block-document-blk-plug.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block-document-blk-plug-fix
From: Andrew Morton <akpm@linux-foundation.org>

grammatical and spelling tweaks

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c       |    2 +-
 include/linux/blkdev.h |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN block/blk-core.c~block-document-blk-plug-fix block/blk-core.c
--- a/block/blk-core.c~block-document-blk-plug-fix
+++ a/block/blk-core.c
@@ -2641,7 +2641,7 @@ EXPORT_SYMBOL(kblockd_schedule_delayed_w
  *   for a memory allocation, memory reclaim could end up wanting to free a
  *   page belonging to that request that is currently residing in our private
  *   plug. By flushing the pending I/O when the process goes to sleep, we avoid
- *   this kind of deadlocks.
+ *   this kind of deadlock.
  */
 void blk_start_plug(struct blk_plug *plug)
 {
diff -puN include/linux/blkdev.h~block-document-blk-plug-fix include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-document-blk-plug-fix
+++ a/include/linux/blkdev.h
@@ -863,16 +863,16 @@ struct request_queue *blk_alloc_queue_no
 extern void blk_put_queue(struct request_queue *);
 
 /*
- * blk_plug allows to build up a queue of related requests by holding the I/O
+ * blk_plug permits building a queue of related requests by holding the I/O
  * fragments for a short period. This allows merging of sequential requests
- * into single larger request. As the requests are moved from per-task list to
- * the device's request_queue in a batch, this results in improved
- * scalability as the lock contention for request_queue lock is reduced.
+ * into single larger request. As the requests are moved from a per-task list to
+ * the device's request_queue in a batch, this results in improved scalability
+ * as the lock contention for request_queue lock is reduced.
  *
- * Note: Code in between changing the blk_plug list/cb_list or element of such
- * lists is preemptable, but such code can't do sleep (or be very careful),
- * otherwise data is corrupted. For details, please check schedule() where
- * blk_schedule_flush_plug() is called.
+ * Note: code in between changing the blk_plug list/cb_list or an element of
+ * these lists is preemptible, but such code cannot sleep (or must be very
+ * careful), otherwise data is corrupted. For details, please check schedule()
+ * where blk_schedule_flush_plug() is called.
  */
 struct blk_plug {
 	unsigned long magic; /* detect uninitialized use-cases */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
block-document-blk-plug.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
aio-allocate-kiocbs-in-batches-fix.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

