From: akpm@osdl.org
Subject: - simplify-some-aspects-of-bd_mutex-nesting.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:32 -0800
Message-ID: <200612082000.kB8K0WDr001757@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56641 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426214AbWLHUAt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: simplify some aspects of bd_mutex nesting
has been removed from the -mm tree.  Its filename was
     simplify-some-aspects-of-bd_mutex-nesting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: simplify some aspects of bd_mutex nesting
From: NeilBrown <neilb@suse.de>

When we open (actually blkdev_get) a partition we need to also open (get) the
whole device that holds the partition.  The involves some limited recursion. 
This patch tries to simplify some aspects of this.

As well as opening the whole device, we need to increment ->bd_part_count when
a partition is opened (this is used by rescan_partitions to avoid a rescan if
any partition is active, as that would be confusing).

The main change this patch makes is to move the inc/dec of bd_part_count into
blkdev_{get,put} for the whole rather than doing it in blkdev_{get,put} for
the partition.

More specifically, we introduce __blkdev_get and __blkdev_put which do exactly
what blkdev_{get,put} did, only with an extra "for_part" argument
(blkget_{get,put} then call the __ version with a '0' for the extra argument).

If for_part is 1, then the blkdev is being get(put) because a partition is
being opened(closed) for the first(last) time, and so bd_part_count should be
updated (on success).  The particular advantage of pushing this function down
is that the bd_mutex lock (which is needed to update bd_part_count) is already
held at the lower level.

Note that this slightly changes the semantics of bd_part_count.  Instead of
updating it whenever a partition is opened or released, it is now only updated
on the first open or last release.  This is an adequate semantic as it is only
ever tested for "== 0".

Having introduced these functions we remove the current bd_part_count updates
from do_open (which is really the body of blkdev_get) and call
__blkdev_get(...  1).  Similarly in blkget_put we remove the old bd_part_count
updates and call __blkget_put(..., 1).  This call is moved to the end of
__blkdev_put to avoid nested locks of bd_mutex.

Finally the mutex_lock on whole->bd_mutex in do_open can be removed.  It was
only really needed to protect bd_part_count, and that is now managed (and
protected) within the recursive call.

The observation that bd_part_count is central to the locking issues, and the
modifications to create __blkdev_put are from Peter Zijlstra.

Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/block_dev.c |   51 ++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff -puN fs/block_dev.c~simplify-some-aspects-of-bd_mutex-nesting fs/block_dev.c
--- a/fs/block_dev.c~simplify-some-aspects-of-bd_mutex-nesting
+++ a/fs/block_dev.c
@@ -900,7 +900,10 @@ void bd_set_size(struct block_device *bd
 }
 EXPORT_SYMBOL(bd_set_size);
 
-static int do_open(struct block_device *bdev, struct file *file)
+static int __blkdev_get(struct block_device *bdev, mode_t mode, unsigned flags,
+			int for_part);
+
+static int do_open(struct block_device *bdev, struct file *file, int for_part)
 {
 	struct module *owner = NULL;
 	struct gendisk *disk;
@@ -944,25 +947,21 @@ static int do_open(struct block_device *
 			ret = -ENOMEM;
 			if (!whole)
 				goto out_first;
-			ret = blkdev_get(whole, file->f_mode, file->f_flags);
+			BUG_ON(for_part);
+			ret = __blkdev_get(whole, file->f_mode, file->f_flags, 1);
 			if (ret)
 				goto out_first;
 			bdev->bd_contains = whole;
-			mutex_lock(&whole->bd_mutex);
-			whole->bd_part_count++;
 			p = disk->part[part - 1];
 			bdev->bd_inode->i_data.backing_dev_info =
 			   whole->bd_inode->i_data.backing_dev_info;
 			if (!(disk->flags & GENHD_FL_UP) || !p || !p->nr_sects) {
-				whole->bd_part_count--;
-				mutex_unlock(&whole->bd_mutex);
 				ret = -ENXIO;
 				goto out_first;
 			}
 			kobject_get(&p->kobj);
 			bdev->bd_part = p;
 			bd_set_size(bdev, (loff_t) p->nr_sects << 9);
-			mutex_unlock(&whole->bd_mutex);
 		}
 	} else {
 		put_disk(disk);
@@ -975,13 +974,11 @@ static int do_open(struct block_device *
 			}
 			if (bdev->bd_invalidated)
 				rescan_partitions(bdev->bd_disk, bdev);
-		} else {
-			mutex_lock(&bdev->bd_contains->bd_mutex);
-			bdev->bd_contains->bd_part_count++;
-			mutex_unlock(&bdev->bd_contains->bd_mutex);
 		}
 	}
 	bdev->bd_openers++;
+	if (for_part)
+		bdev->bd_part_count++;
 	mutex_unlock(&bdev->bd_mutex);
 	unlock_kernel();
 	return 0;
@@ -1002,7 +999,8 @@ out:
 	return ret;
 }
 
-int blkdev_get(struct block_device *bdev, mode_t mode, unsigned flags)
+static int __blkdev_get(struct block_device *bdev, mode_t mode, unsigned flags,
+			int for_part)
 {
 	/*
 	 * This crockload is due to bad choice of ->open() type.
@@ -1017,9 +1015,13 @@ int blkdev_get(struct block_device *bdev
 	fake_file.f_dentry = &fake_dentry;
 	fake_dentry.d_inode = bdev->bd_inode;
 
-	return do_open(bdev, &fake_file);
+	return do_open(bdev, &fake_file, for_part);
 }
 
+int blkdev_get(struct block_device *bdev, mode_t mode, unsigned flags)
+{
+	return __blkdev_get(bdev, mode, flags, 0);
+}
 EXPORT_SYMBOL(blkdev_get);
 
 static int blkdev_open(struct inode * inode, struct file * filp)
@@ -1039,7 +1041,7 @@ static int blkdev_open(struct inode * in
 	if (bdev == NULL)
 		return -ENOMEM;
 
-	res = do_open(bdev, filp);
+	res = do_open(bdev, filp, 0);
 	if (res)
 		return res;
 
@@ -1053,14 +1055,18 @@ static int blkdev_open(struct inode * in
 	return res;
 }
 
-int blkdev_put(struct block_device *bdev)
+static int __blkdev_put(struct block_device *bdev, int for_part)
 {
 	int ret = 0;
 	struct inode *bd_inode = bdev->bd_inode;
 	struct gendisk *disk = bdev->bd_disk;
+	struct block_device *victim = NULL;
 
 	mutex_lock(&bdev->bd_mutex);
 	lock_kernel();
+	if (for_part)
+		bdev->bd_part_count--;
+
 	if (!--bdev->bd_openers) {
 		sync_blockdev(bdev);
 		kill_bdev(bdev);
@@ -1068,10 +1074,6 @@ int blkdev_put(struct block_device *bdev
 	if (bdev->bd_contains == bdev) {
 		if (disk->fops->release)
 			ret = disk->fops->release(bd_inode, NULL);
-	} else {
-		mutex_lock(&bdev->bd_contains->bd_mutex);
-		bdev->bd_contains->bd_part_count--;
-		mutex_unlock(&bdev->bd_contains->bd_mutex);
 	}
 	if (!bdev->bd_openers) {
 		struct module *owner = disk->fops->owner;
@@ -1085,17 +1087,22 @@ int blkdev_put(struct block_device *bdev
 		}
 		bdev->bd_disk = NULL;
 		bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
-		if (bdev != bdev->bd_contains) {
-			blkdev_put(bdev->bd_contains);
-		}
+		if (bdev != bdev->bd_contains)
+			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
 	}
 	unlock_kernel();
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
+	if (victim)
+		__blkdev_put(victim, 1);
 	return ret;
 }
 
+int blkdev_put(struct block_device *bdev)
+{
+	return __blkdev_put(bdev, 0);
+}
 EXPORT_SYMBOL(blkdev_put);
 
 static int blkdev_close(struct inode * inode, struct file * filp)
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch
nfs2-calculate-w-a-bit-later-in-nfsaclsvc_encode_getaclres.patch
nfs3-calculate-w-a-bit-later-in-nfs3svc_encode_getaclres.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch
md-define-raid5_mergeable_bvec.patch
md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch
md-enable-bypassing-cache-for-reads.patch
md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
md-conditionalize-some-code.patch
md-change-lifetime-rules-for-md-devices.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

