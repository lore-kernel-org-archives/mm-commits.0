From: akpm@linux-foundation.org
Subject: - enable-partitions-for-lguest-block-device.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:11:39 -0700
Message-ID: <200708201911.l7KJBdiK018275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbXHTTMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Enable partitions for lguest block device
has been removed from the -mm tree.  Its filename was
     enable-partitions-for-lguest-block-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Enable partitions for lguest block device
From: Rusty Russell <rusty@rustcorp.com.au>

The lguest block device only requests one minor, which means
partitions don't work (eg "root=/dev/lgba1").

Let's follow the crowd and ask for 16.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/lguest_blk.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/block/lguest_blk.c~enable-partitions-for-lguest-block-device drivers/block/lguest_blk.c
--- a/drivers/block/lguest_blk.c~enable-partitions-for-lguest-block-device
+++ a/drivers/block/lguest_blk.c
@@ -308,9 +308,13 @@ static int lguestblk_probe(struct lguest
 	}
 
 	/* This allocates a "struct gendisk" where we pack all the information
-	 * about the disk which the rest of Linux sees.  We ask for one minor
-	 * number; I do wonder if we should be asking for more. */
-	bd->disk = alloc_disk(1);
+	 * about the disk which the rest of Linux sees.  The argument is the
+	 * number of minor devices desired: we need one minor for the main
+	 * disk, and one for each partition.  Of course, we can't possibly know
+	 * how many partitions are on the disk (add_disk does that).
+	 *
+	 * Worst.  Interface.  Ever. */
+	bd->disk = alloc_disk(16);
 	if (!bd->disk) {
 		err = -ENOMEM;
 		goto out_unregister_blkdev;
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
