From: akpm@linux-foundation.org
Subject: - lockdep-annotate-blkpg_del_partition.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:41 -0800
Message-ID: <200702211046.l1LAkfnf006487@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47008 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620AbXBUKrO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:47:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     lockdep: annotate BLKPG_DEL_PARTITION
has been removed from the -mm tree.  Its filename was
     lockdep-annotate-blkpg_del_partition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: annotate BLKPG_DEL_PARTITION
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

>=============================================
>[ INFO: possible recursive locking detected ]
>2.6.19-1.2909.fc7 #1
>---------------------------------------------
>anaconda/587 is trying to acquire lock:
> (&bdev->bd_mutex){--..}, at: [<c05fb380>] mutex_lock+0x21/0x24
>
>but task is already holding lock:
> (&bdev->bd_mutex){--..}, at: [<c05fb380>] mutex_lock+0x21/0x24
>
>other info that might help us debug this:
>1 lock held by anaconda/587:
> #0:  (&bdev->bd_mutex){--..}, at: [<c05fb380>] mutex_lock+0x21/0x24
>
>stack backtrace:
> [<c0405812>] show_trace_log_lvl+0x1a/0x2f
> [<c0405db2>] show_trace+0x12/0x14
> [<c0405e36>] dump_stack+0x16/0x18
> [<c043bd84>] __lock_acquire+0x116/0xa09
> [<c043c960>] lock_acquire+0x56/0x6f
> [<c05fb1fa>] __mutex_lock_slowpath+0xe5/0x24a
> [<c05fb380>] mutex_lock+0x21/0x24
> [<c04d82fb>] blkdev_ioctl+0x600/0x76d
> [<c04946b1>] block_ioctl+0x1b/0x1f
> [<c047ed5a>] do_ioctl+0x22/0x68
> [<c047eff2>] vfs_ioctl+0x252/0x265
> [<c047f04e>] sys_ioctl+0x49/0x63
> [<c0404070>] syscall_call+0x7/0xb

Annotate BLKPG_DEL_PARTITION's bd_mutex locking and add a little comment
clarifying the bd_mutex locking, because I confused myself and initially
thought the lock order was wrong too.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ioctl.c  |    2 +-
 fs/block_dev.c |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN block/ioctl.c~lockdep-annotate-blkpg_del_partition block/ioctl.c
--- a/block/ioctl.c~lockdep-annotate-blkpg_del_partition
+++ a/block/ioctl.c
@@ -82,7 +82,7 @@ static int blkpg_ioctl(struct block_devi
 			fsync_bdev(bdevp);
 			invalidate_bdev(bdevp, 0);
 
-			mutex_lock(&bdev->bd_mutex);
+			mutex_lock_nested(&bdev->bd_mutex, 1);
 			delete_partition(disk, part);
 			mutex_unlock(&bdev->bd_mutex);
 			mutex_unlock(&bdevp->bd_mutex);
diff -puN fs/block_dev.c~lockdep-annotate-blkpg_del_partition fs/block_dev.c
--- a/fs/block_dev.c~lockdep-annotate-blkpg_del_partition
+++ a/fs/block_dev.c
@@ -1101,6 +1101,13 @@ static int __blkdev_get(struct block_dev
 			int for_part);
 static int __blkdev_put(struct block_device *bdev, int for_part);
 
+/*
+ * bd_mutex locking:
+ *
+ *  mutex_lock(part->bd_mutex)
+ *    mutex_lock_nested(whole->bd_mutex, 1)
+ */
+
 static int do_open(struct block_device *bdev, struct file *file, int for_part)
 {
 	struct module *owner = NULL;
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

nfs-fix-congestion-control-v4.patch
lumpy-reclaim-v2.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
