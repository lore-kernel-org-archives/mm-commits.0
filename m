From: akpm@linux-foundation.org
Subject: - scsi_scan-warning-at-include-linux-blkdevh-431-blk_queue_init_tags0x107-0x120.patch removed from -mm tree
Date: Thu, 08 May 2008 12:31:57 -0700
Message-ID: <200805081931.m48JVvie001912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755464AbYEHTdb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:33:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     scsi_scan: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x107/0x120()
has been removed from the -mm tree.  Its filename was
     scsi_scan-warning-at-include-linux-blkdevh-431-blk_queue_init_tags0x107-0x120.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi_scan: WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x107/0x120()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Fri, 2 May 2008 00:43:30 +0200 (CEST)
Jesper Juhl <jesper.juhl@gmail.com> wrote:

> Hi,
>
> For your information;
>
> I just build and booted the tip of Linus' git tree (HEAD at
> 886c35fbcf6fb2eee15687efc2d64d99b6ad9a4a) and got this in dmesg during
> bootup :
>
> ------------[ cut here ]------------
> WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x107/0x120()
> Modules linked in:
> Pid: 432, comm: scsi_scan_0 Not tainted 2.6.25-07351-g886c35f #1
>  [<c0129684>] warn_on_slowpath+0x54/0x70
>  [<c017a7c3>] ? check_object+0xe3/0x1f0
>  [<c0200ae9>] ? init_tag_map+0x59/0xb0
>  [<c014b1e7>] ? mark_held_locks+0x47/0x80
>  [<c017cbeb>] ? __kmalloc+0x6b/0x100
>  [<c014b379>] ? trace_hardirqs_on+0xb9/0x150
>  [<c0200ae9>] ? init_tag_map+0x59/0xb0
>  [<c0200ae9>] ? init_tag_map+0x59/0xb0
>  [<c0200ae9>] ? init_tag_map+0x59/0xb0
>  [<c0200c34>] ? __blk_queue_init_tags+0x24/0x70
>  [<c0200c45>] ? __blk_queue_init_tags+0x35/0x70
>  [<c0200e57>] blk_queue_init_tags+0x107/0x120
>  [<c02b5a91>] ahc_platform_set_tags+0x191/0x1d0
>  [<c02b5bd3>] ahc_linux_slave_configure+0x103/0x170
>  [<c02a1f65>] scsi_probe_and_add_lun+0x6e5/0x920
>  [<c02a2468>] __scsi_scan_target+0xe8/0x5d0
>  [<c0108e17>] ? native_sched_clock+0x87/0xd0
>  [<c0148c89>] ? get_lock_stats+0x29/0x50
>  [<c0148cbd>] ? put_lock_stats+0xd/0x30
>  [<c014b1e7>] ? mark_held_locks+0x47/0x80
>  [<c035e247>] ? mutex_lock_nested+0x1b7/0x2a0
>  [<c014b379>] ? trace_hardirqs_on+0xb9/0x150
>  [<c035e23a>] ? mutex_lock_nested+0x1aa/0x2a0
>  [<c02a2a1a>] ? scsi_scan_host_selected+0x3a/0xf0
>  [<c02a29c0>] scsi_scan_channel+0x70/0x90
>  [<c02a2a9d>] scsi_scan_host_selected+0xbd/0xf0
>  [<c02a2b50>] ? do_scan_async+0x0/0x140
>  [<c02a2b48>] do_scsi_scan_host+0x78/0x80
>  [<c02a2b64>] do_scan_async+0x14/0x140
>  [<c011f6e8>] ? complete+0x48/0x60
>  [<c02a2b50>] ? do_scan_async+0x0/0x140
>  [<c013c8d2>] kthread+0x42/0x70
>  [<c013c890>] ? kthread+0x0/0x70
>  [<c0103ceb>] kernel_thread_helper+0x7/0x1c

The problem is that the commit 75ad23b expects that we hold the queue
lock for __blk_queue_free_tags, blk_queue_free_tags and
blk_queue_init_tags but we haven't.

The simple fix is using queue_flag_set/clear_unlocked for them, then
it should work as before. However, it would be better to hold the
queue lock for blk_queue_free_tags and blk_queue_init_tags (we can
hold the queue lock in scsi_activate_tcq and scsi_deactivate_tcq).

(akpm: queued this up assuming that a final/formal version will be
forthcoming?)

Tested-by: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-tag.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN block/blk-tag.c~scsi_scan-warning-at-include-linux-blkdevh-431-blk_queue_init_tags0x107-0x120 block/blk-tag.c
--- a/block/blk-tag.c~scsi_scan-warning-at-include-linux-blkdevh-431-blk_queue_init_tags0x107-0x120
+++ a/block/blk-tag.c
@@ -70,7 +70,7 @@ void __blk_queue_free_tags(struct reques
 	__blk_free_tags(bqt);
 
 	q->queue_tags = NULL;
-	queue_flag_clear(QUEUE_FLAG_QUEUED, q);
+	queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
 }
 
 /**
@@ -98,7 +98,7 @@ EXPORT_SYMBOL(blk_free_tags);
  **/
 void blk_queue_free_tags(struct request_queue *q)
 {
-	queue_flag_clear(QUEUE_FLAG_QUEUED, q);
+	queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
 }
 EXPORT_SYMBOL(blk_queue_free_tags);
 
@@ -197,7 +197,7 @@ int blk_queue_init_tags(struct request_q
 	 * assign it, all done
 	 */
 	q->queue_tags = tags;
-	queue_flag_set(QUEUE_FLAG_QUEUED, q);
+	queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, q);
 	INIT_LIST_HEAD(&q->tag_busy_list);
 	return 0;
 fail:
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch

