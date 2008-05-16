From: akpm@linux-foundation.org
Subject: - remove-blkdev-warning-triggered-by-using-md.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:31 -0700
Message-ID: <200805162253.m4GMrVCZ003147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758239AbYEPWys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, alistair@devzero.co.uk, dan.j.williams@intel.com, difrost.kernel@gmail.com, jens.axboe@oracle.com, npiggin@suse.de, prakash@punnoor.de, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Remove blkdev warning triggered by using md
has been removed from the -mm tree.  Its filename was
     remove-blkdev-warning-triggered-by-using-md.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove blkdev warning triggered by using md
From: Neil Brown <neilb@suse.de>

As setting and clearing queue flags now requires that we hold a spinlock
on the queue, and as blk_queue_stack_limits is called without that lock,
get the lock inside blk_queue_stack_limits.

For blk_queue_stack_limits to be able to find the right lock, each md
personality needs to set q->queue_lock to point to the appropriate lock. 
Those personalities which didn't previously use a spin_lock, us
q->__queue_lock.  So always initialise that lock when allocated.

With this in place, setting/clearing of the QUEUE_FLAG_PLUGGED bit will no
longer cause warnings as it will be clear that the proper lock is held.

Thanks to Dan Williams for review and fixing the silly bugs.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Nick Piggin <npiggin@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Prakash Punnoor <prakash@punnoor.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c       |    5 ++---
 block/blk-settings.c   |    8 +++++++-
 drivers/md/linear.c    |    1 +
 drivers/md/multipath.c |    1 +
 drivers/md/raid0.c     |    1 +
 drivers/md/raid1.c     |    4 +++-
 drivers/md/raid10.c    |    4 +++-
 drivers/md/raid5.c     |    1 +
 8 files changed, 19 insertions(+), 6 deletions(-)

diff -puN block/blk-core.c~remove-blkdev-warning-triggered-by-using-md block/blk-core.c
--- a/block/blk-core.c~remove-blkdev-warning-triggered-by-using-md
+++ a/block/blk-core.c
@@ -482,6 +482,7 @@ struct request_queue *blk_alloc_queue_no
 	kobject_init(&q->kobj, &blk_queue_ktype);
 
 	mutex_init(&q->sysfs_lock);
+	spin_lock_init(&q->__queue_lock);
 
 	return q;
 }
@@ -544,10 +545,8 @@ blk_init_queue_node(request_fn_proc *rfn
 	 * if caller didn't supply a lock, they get per-queue locking with
 	 * our embedded lock
 	 */
-	if (!lock) {
-		spin_lock_init(&q->__queue_lock);
+	if (!lock)
 		lock = &q->__queue_lock;
-	}
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
diff -puN block/blk-settings.c~remove-blkdev-warning-triggered-by-using-md block/blk-settings.c
--- a/block/blk-settings.c~remove-blkdev-warning-triggered-by-using-md
+++ a/block/blk-settings.c
@@ -286,8 +286,14 @@ void blk_queue_stack_limits(struct reque
 	t->max_hw_segments = min(t->max_hw_segments, b->max_hw_segments);
 	t->max_segment_size = min(t->max_segment_size, b->max_segment_size);
 	t->hardsect_size = max(t->hardsect_size, b->hardsect_size);
-	if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags))
+	if (!t->queue_lock)
+		WARN_ON_ONCE(1);
+	else if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags)) {
+		unsigned long flags;
+		spin_lock_irqsave(t->queue_lock, flags);
 		queue_flag_clear(QUEUE_FLAG_CLUSTER, t);
+		spin_unlock_irqrestore(t->queue_lock, flags);
+	}
 }
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
diff -puN drivers/md/linear.c~remove-blkdev-warning-triggered-by-using-md drivers/md/linear.c
--- a/drivers/md/linear.c~remove-blkdev-warning-triggered-by-using-md
+++ a/drivers/md/linear.c
@@ -250,6 +250,7 @@ static int linear_run (mddev_t *mddev)
 {
 	linear_conf_t *conf;
 
+	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 	conf = linear_conf(mddev, mddev->raid_disks);
 
 	if (!conf)
diff -puN drivers/md/multipath.c~remove-blkdev-warning-triggered-by-using-md drivers/md/multipath.c
--- a/drivers/md/multipath.c~remove-blkdev-warning-triggered-by-using-md
+++ a/drivers/md/multipath.c
@@ -417,6 +417,7 @@ static int multipath_run (mddev_t *mddev
 	 * bookkeeping area. [whatever we allocate in multipath_run(),
 	 * should be freed in multipath_stop()]
 	 */
+	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	conf = kzalloc(sizeof(multipath_conf_t), GFP_KERNEL);
 	mddev->private = conf;
diff -puN drivers/md/raid0.c~remove-blkdev-warning-triggered-by-using-md drivers/md/raid0.c
--- a/drivers/md/raid0.c~remove-blkdev-warning-triggered-by-using-md
+++ a/drivers/md/raid0.c
@@ -280,6 +280,7 @@ static int raid0_run (mddev_t *mddev)
 	       (mddev->chunk_size>>1)-1);
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
 	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
+	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
 	if (!conf)
diff -puN drivers/md/raid1.c~remove-blkdev-warning-triggered-by-using-md drivers/md/raid1.c
--- a/drivers/md/raid1.c~remove-blkdev-warning-triggered-by-using-md
+++ a/drivers/md/raid1.c
@@ -1935,6 +1935,9 @@ static int run(mddev_t *mddev)
 	if (!conf->r1bio_pool)
 		goto out_no_mem;
 
+	spin_lock_init(&conf->device_lock);
+	mddev->queue->queue_lock = &conf->device_lock;
+
 	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -1958,7 +1961,6 @@ static int run(mddev_t *mddev)
 	}
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
-	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	spin_lock_init(&conf->resync_lock);
diff -puN drivers/md/raid10.c~remove-blkdev-warning-triggered-by-using-md drivers/md/raid10.c
--- a/drivers/md/raid10.c~remove-blkdev-warning-triggered-by-using-md
+++ a/drivers/md/raid10.c
@@ -2082,6 +2082,9 @@ static int run(mddev_t *mddev)
 		goto out_free_conf;
 	}
 
+	spin_lock_init(&conf->device_lock);
+	mddev->queue->queue_lock = &conf->device_lock;
+
 	rdev_for_each(rdev, tmp, mddev) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -2103,7 +2106,6 @@ static int run(mddev_t *mddev)
 
 		disk->head_position = 0;
 	}
-	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	spin_lock_init(&conf->resync_lock);
diff -puN drivers/md/raid5.c~remove-blkdev-warning-triggered-by-using-md drivers/md/raid5.c
--- a/drivers/md/raid5.c~remove-blkdev-warning-triggered-by-using-md
+++ a/drivers/md/raid5.c
@@ -4257,6 +4257,7 @@ static int run(mddev_t *mddev)
 			goto abort;
 	}
 	spin_lock_init(&conf->device_lock);
+	mddev->queue->queue_lock = &conf->device_lock;
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch

