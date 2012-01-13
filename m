From: akpm@linux-foundation.org
Subject: [folded] dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:58:45 -0800
Message-ID: <20120113005845.B38C61E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:52901 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab2AMA6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:58:46 -0500
Received: by yhjj52 with SMTP id j52so8480yhj.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:58:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch

This patch was dropped because it was folded into dio-optimize-cache-misses-in-the-submission-path-v2.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes

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
@@ -1109,7 +1109,7 @@ do_blockdev_direct_IO(int rw, struct kio
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
 
-	/* 
+	/*
 	 * Avoid references to bdev if not absolutely needed to give
 	 * the early prefetch in the caller enough time.
 	 */
@@ -1127,10 +1127,10 @@ do_blockdev_direct_IO(int rw, struct kio
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
@@ -1319,16 +1319,16 @@ out:
 
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

origin.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-simplify-lru-handling-by-new-rule.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops.patch
drivers-parport-parport_pcc-fix-warnings.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch

