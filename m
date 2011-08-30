From: akpm@linux-foundation.org
Subject: + dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:53:14 -0700
Message-ID: <201108302353.p7UNrFw7026530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759Ab1H3Xxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:53:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@linux.intel.com


The patch titled
     dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch

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
Subject: dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#63: FILE: fs/direct-io.c:1109:
+^I/* $

ERROR: trailing whitespace
#80: FILE: fs/direct-io.c:1127:
+^I^Iif (unlikely((addr & blocksize_mask) || $

WARNING: suspect code indent for conditional statements (24, 33)
#82: FILE: fs/direct-io.c:1129:
 			if (bdev)
+				 blkbits = blksize_bits(

ERROR: trailing whitespace
#99: FILE: fs/direct-io.c:1319:
+^Istruct block_device *bdev, const struct iovec *iov, loff_t offset, $

ERROR: trailing whitespace
#103: FILE: fs/direct-io.c:1323:
+^I/* $

ERROR: trailing whitespace
#108: FILE: fs/direct-io.c:1328:
+^I * $

total: 5 errors, 1 warnings, 80 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/dio-optimize-cache-misses-in-the-submission-path-v2.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/direct-io.c~dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes fs/direct-io.c
--- a/fs/direct-io.c~dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes
+++ a/fs/direct-io.c
@@ -1106,7 +1106,7 @@ do_blockdev_direct_IO(int rw, struct kio
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
 
-	/* 
+	/*
 	 * Avoid references to bdev if not absolutely needed to give
 	 * the early prefetch in the caller enough time.
 	 */
@@ -1124,10 +1124,10 @@ do_blockdev_direct_IO(int rw, struct kio
 		addr = (unsigned long)iov[seg].iov_base;
 		size = iov[seg].iov_len;
 		end += size;
-		if (unlikely((addr & blocksize_mask) || 
-			     (size & blocksize_mask)))  {
+		if (unlikely((addr & blocksize_mask) ||
+			     (size & blocksize_mask))) {
 			if (bdev)
-				 blkbits = blksize_bits(
+				blkbits = blksize_bits(
 					 bdev_logical_block_size(bdev));
 			blocksize_mask = (1 << blkbits) - 1;
 			if ((addr & blocksize_mask) || (size & blocksize_mask))
@@ -1316,16 +1316,16 @@ out:
 
 ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
+	struct block_device *bdev, const struct iovec *iov, loff_t offset,
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
 	dio_submit_t submit_io,	int flags)
 {
-	/* 
+	/*
 	 * The block device state is needed in the end to finally
 	 * submit everything.  Since it's likely to be cache cold
 	 * prefetch it here as first thing to hide some of the
 	 * latency.
-	 * 
+	 *
 	 * Attempt to prefetch the pieces we likely need later.
 	 */
 	prefetch(&bdev->bd_disk->part_tbl);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

headers_check-is-broken.patch
samples-hidraw-is-busted.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
block-document-blk-plug-fix.patch
mm.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
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
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
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

