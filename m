From: akpm@linux-foundation.org
Subject: [merged] nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 06 Sep 2011 12:16:58 -0700
Message-ID: <201109061912.p86JCkge022223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab1IFTMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 15:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Paul.Clements@steeleye.com, amwang@redhat.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#30: FILE: drivers/block/nbd.c:578:
+^I        dev_info(disk_to_dev(lo->disk), "NBD_DISCONNECT\n");$

total: 1 errors, 0 warnings, 35 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/nbd-replace-some-printk-with-dev_warn-and-dev_info.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/nbd.c~nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes
+++ a/drivers/block/nbd.c
@@ -575,7 +575,7 @@ static int __nbd_ioctl(struct block_devi
 	case NBD_DISCONNECT: {
 		struct request sreq;
 
-	        dev_info(disk_to_dev(lo->disk), "NBD_DISCONNECT\n");
+		dev_info(disk_to_dev(lo->disk), "NBD_DISCONNECT\n");
 
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_SPECIAL;
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
block-document-blk-plug-fix.patch
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

