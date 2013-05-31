From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch removed from -mm
 tree
Date: Fri, 31 May 2013 12:03:45 -0700
Message-ID: <51a8f411.FzKF7tMgTrsM4pzo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3EaTDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 15:03:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nyc@holomorphy.com, joe@perches.com, jkosina@suse.cz, chanho.min@lge.com, anish198519851985@gmail.com, akpm@linux-foundation.org

Subject: [folded-merged] lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,anish198519851985@gmail.com,chanho.min@lge.com,jkosina@suse.cz,joe@perches.com,nyc@holomorphy.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 12:03:45 -0700


The patch titled
     Subject: lib-bitmapc-speed-up-bitmap_find_free_region-fix
has been removed from the -mm tree.  Its filename was
     lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch

This patch was dropped because it was folded into lib-bitmapc-speed-up-bitmap_find_free_region.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-bitmapc-speed-up-bitmap_find_free_region-fix

reduce scope of locals, remove barely comprehensible comment

Cc: Chanho Min <chanho.min@lge.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: anish singh <anish198519851985@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-speed-up-bitmap_find_free_region-fix lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-speed-up-bitmap_find_free_region-fix
+++ a/lib/bitmap.c
@@ -1114,13 +1114,15 @@ done:
  */
 int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
 {
-	int pos, end, nbit, i;	/* scans bitmap by regions of size order */
 	int nlongs = BITS_TO_LONGS(bits);
+	int i;
 
 	for (i = 0; i < nlongs; i++)
 		if (bitmap[i] != ~0UL) {
-			pos = i * BITS_PER_LONG;
-			nbit = min(bits, pos + BITS_PER_LONG);
+			int pos = i * BITS_PER_LONG;
+			int nbit = min(bits, pos + BITS_PER_LONG);
+			int end;
+
 			for (; (end = pos + (1 << order)) <= nbit; pos = end) {
 				if (!__reg_op(bitmap, pos, order,
 					REG_OP_ISFREE))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel-fix.patch
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
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region.patch
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

