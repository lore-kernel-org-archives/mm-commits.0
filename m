From: akpm@linux-foundation.org
Subject: + vfs-properly-notify-block-layer-of-sync-writes.patch added to -mm tree
Date: Tue, 01 Jul 2008 16:39:57 -0700
Message-ID: <200807012339.m61NdvkU020843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757452AbYGAXlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 19:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jens.axboe@oracle.com, ming.m.lin@intel.com, stable@kernel.org


The patch titled
     vfs: properly notify block layer of sync writes
has been added to the -mm tree.  Its filename is
     vfs-properly-notify-block-layer-of-sync-writes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: properly notify block layer of sync writes
From: Jens Axboe <jens.axboe@oracle.com>

fsync_buffers_list() and sync_dirty_buffer() both issue async writes and
then immediately wait on them.  Conceptually, that makes them sync writes
and we should treat them as such so that the IO schedulers can handle them
appropriately.

This patch fixes a write starvation issue that Lin Ming reported, where xx
is stuck for more than 2 minutes because of a large number of synchronous
IO in the system:

INFO: task kjournald:20558 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
kjournald     D ffff810010820978  6712 20558      2
ffff81022ddb1d10 0000000000000046 ffff81022e7baa10 ffffffff803ba6f2
ffff81022ecd0000 ffff8101e6dc9160 ffff81022ecd0348 000000008048b6cb
0000000000000086 ffff81022c4e8d30 0000000000000000 ffffffff80247537
Call Trace:
[<ffffffff803ba6f2>] kobject_get+0x12/0x17
[<ffffffff80247537>] getnstimeofday+0x2f/0x83
[<ffffffff8029c1ac>] sync_buffer+0x0/0x3f
[<ffffffff8066d195>] io_schedule+0x5d/0x9f
[<ffffffff8029c1e7>] sync_buffer+0x3b/0x3f
[<ffffffff8066d3f0>] __wait_on_bit+0x40/0x6f
[<ffffffff8029c1ac>] sync_buffer+0x0/0x3f
[<ffffffff8066d48b>] out_of_line_wait_on_bit+0x6c/0x78
[<ffffffff80243909>] wake_bit_function+0x0/0x23
[<ffffffff8029e3ad>] sync_dirty_buffer+0x98/0xcb
[<ffffffff8030056b>] journal_commit_transaction+0x97d/0xcb6
[<ffffffff8023a676>] lock_timer_base+0x26/0x4b
[<ffffffff8030300a>] kjournald+0xc1/0x1fb
[<ffffffff802438db>] autoremove_wake_function+0x0/0x2e
[<ffffffff80302f49>] kjournald+0x0/0x1fb
[<ffffffff802437bb>] kthread+0x47/0x74
[<ffffffff8022de51>] schedule_tail+0x28/0x5d
[<ffffffff8020cac8>] child_rip+0xa/0x12
[<ffffffff80243774>] kthread+0x0/0x74
[<ffffffff8020cabe>] child_rip+0x0/0x12

Lin Ming confirms that this patch fixes the issue. I've run tests with
it for the past week and no ill effects have been observed, so I'm
proposing it for inclusion into 2.6.26.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Tested-by: Lin Ming <ming.m.lin@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c        |   13 ++++++++-----
 include/linux/fs.h |    1 +
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/buffer.c~vfs-properly-notify-block-layer-of-sync-writes fs/buffer.c
--- a/fs/buffer.c~vfs-properly-notify-block-layer-of-sync-writes
+++ a/fs/buffer.c
@@ -821,7 +821,7 @@ static int fsync_buffers_list(spinlock_t
 				 * contents - it is a noop if I/O is still in
 				 * flight on potentially older contents.
 				 */
-				ll_rw_block(SWRITE, 1, &bh);
+				ll_rw_block(SWRITE_SYNC, 1, &bh);
 				brelse(bh);
 				spin_lock(lock);
 			}
@@ -2940,16 +2940,19 @@ void ll_rw_block(int rw, int nr, struct 
 	for (i = 0; i < nr; i++) {
 		struct buffer_head *bh = bhs[i];
 
-		if (rw == SWRITE)
+		if (rw == SWRITE || rw == SWRITE_SYNC)
 			lock_buffer(bh);
 		else if (test_set_buffer_locked(bh))
 			continue;
 
-		if (rw == WRITE || rw == SWRITE) {
+		if (rw == WRITE || rw == SWRITE || rw == SWRITE_SYNC) {
 			if (test_clear_buffer_dirty(bh)) {
 				bh->b_end_io = end_buffer_write_sync;
 				get_bh(bh);
-				submit_bh(WRITE, bh);
+				if (rw == SWRITE_SYNC)
+					submit_bh(WRITE_SYNC, bh);
+				else
+					submit_bh(WRITE, bh);
 				continue;
 			}
 		} else {
@@ -2978,7 +2981,7 @@ int sync_dirty_buffer(struct buffer_head
 	if (test_clear_buffer_dirty(bh)) {
 		get_bh(bh);
 		bh->b_end_io = end_buffer_write_sync;
-		ret = submit_bh(WRITE, bh);
+		ret = submit_bh(WRITE_SYNC, bh);
 		wait_on_buffer(bh);
 		if (buffer_eopnotsupp(bh)) {
 			clear_buffer_eopnotsupp(bh);
diff -puN include/linux/fs.h~vfs-properly-notify-block-layer-of-sync-writes include/linux/fs.h
--- a/include/linux/fs.h~vfs-properly-notify-block-layer-of-sync-writes
+++ a/include/linux/fs.h
@@ -83,6 +83,7 @@ extern int dir_notify_enable;
 #define READ_SYNC	(READ | (1 << BIO_RW_SYNC))
 #define READ_META	(READ | (1 << BIO_RW_META))
 #define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNC))
+#define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNC))
 #define WRITE_BARRIER	((1 << BIO_RW) | (1 << BIO_RW_BARRIER))
 
 #define SEL_IN		1
_

Patches currently in -mm which might be from jens.axboe@oracle.com are

vfs-properly-notify-block-layer-of-sync-writes.patch
cciss-read-config-to-obtain-max-outstanding-commands-per-controller.patch
cdrom-dont-check-cdc_play_audio-in-cdrom_count_tracks.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
block-use-get_unaligned_-helpers.patch
paride-push-ioctl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
dac960-push-down-bkl.patch
block-add-blk_queue_update_dma_pad.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch
ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch
scsi-sr-avoids-useless-buffer-allocation.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
drivers-block-pktcdvdc-avoid-useless-memset.patch
ramfs-enable-splice-write.patch
block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case.patch
block-fix-bio_add_page-for-non-trivial-merge_bvec_fn-case-fix.patch
block-request_module-use-format-string.patch
vfs-path_getput-cleanups.patch
splice-fix-generic_file_splice_read-race-with-page-invalidation.patch
ide-cd-use-the-new-object_is_in_stack-helper.patch
block-blk-mapc-use-the-new-object_is_on_stack-helper.patch
fs-partition-checkc-fix-return-value-warning.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops.patch
i2o-handle-sysfs_create_link-failures.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
reiser4.patch

