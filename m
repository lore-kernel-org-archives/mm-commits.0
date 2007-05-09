From: akpm@linux-foundation.org
Subject: - md-improve-partition-detection-in-md-array.patch removed from -mm tree
Date: Wed, 09 May 2007 14:55:02 -0700
Message-ID: <200705092155.l49Lt2DD003223@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759325AbXEIVzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: improve partition detection in md array
has been removed from the -mm tree.  Its filename was
     md-improve-partition-detection-in-md-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: improve partition detection in md array
From: NeilBrown <neilb@suse.de>

md currently uses ->media_changed to make sure rescan_partitions
is call on md array after they are assembled.

However that doesn't happen until the array is opened, which is later
than some people would like.

So use blkdev_ioctl to do the rescan immediately that the
array has been assembled.

This means we can remove all the ->change infrastructure as it was only used
to trigger a partition rescan.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c           |   26 ++++++++------------------
 drivers/md/raid1.c        |    1 -
 drivers/md/raid5.c        |    2 --
 include/linux/raid/md_k.h |    1 -
 4 files changed, 8 insertions(+), 22 deletions(-)

diff -puN drivers/md/md.c~md-improve-partition-detection-in-md-array drivers/md/md.c
--- a/drivers/md/md.c~md-improve-partition-detection-in-md-array
+++ a/drivers/md/md.c
@@ -3104,6 +3104,7 @@ static int do_md_run(mddev_t * mddev)
 	struct gendisk *disk;
 	struct mdk_personality *pers;
 	char b[BDEVNAME_SIZE];
+	struct block_device *bdev;
 
 	if (list_empty(&mddev->disks))
 		/* cannot run an array with no devices.. */
@@ -3331,7 +3332,13 @@ static int do_md_run(mddev_t * mddev)
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
 
-	mddev->changed = 1;
+	bdev = bdget_disk(mddev->gendisk, 0);
+	if (bdev) {
+		bd_set_size(bdev, mddev->array_size << 1);
+		blkdev_ioctl(bdev->bd_inode, NULL, BLKRRPART, 0);
+		bdput(bdev);
+	}
+
 	md_new_event(mddev);
 	kobject_uevent(&mddev->gendisk->kobj, KOBJ_CHANGE);
 	return 0;
@@ -3453,7 +3460,6 @@ static int do_md_stop(mddev_t * mddev, i
 			mddev->pers = NULL;
 
 			set_capacity(disk, 0);
-			mddev->changed = 1;
 
 			if (mddev->ro)
 				mddev->ro = 0;
@@ -4593,20 +4599,6 @@ static int md_release(struct inode *inod
 	return 0;
 }
 
-static int md_media_changed(struct gendisk *disk)
-{
-	mddev_t *mddev = disk->private_data;
-
-	return mddev->changed;
-}
-
-static int md_revalidate(struct gendisk *disk)
-{
-	mddev_t *mddev = disk->private_data;
-
-	mddev->changed = 0;
-	return 0;
-}
 static struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
@@ -4614,8 +4606,6 @@ static struct block_device_operations md
 	.release	= md_release,
 	.ioctl		= md_ioctl,
 	.getgeo		= md_getgeo,
-	.media_changed	= md_media_changed,
-	.revalidate_disk= md_revalidate,
 };
 
 static int md_thread(void * arg)
diff -puN drivers/md/raid1.c~md-improve-partition-detection-in-md-array drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-improve-partition-detection-in-md-array
+++ a/drivers/md/raid1.c
@@ -2063,7 +2063,6 @@ static int raid1_resize(mddev_t *mddev, 
 	 */
 	mddev->array_size = sectors>>1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
-	mddev->changed = 1;
 	if (mddev->array_size > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
diff -puN drivers/md/raid5.c~md-improve-partition-detection-in-md-array drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-improve-partition-detection-in-md-array
+++ a/drivers/md/raid5.c
@@ -3864,7 +3864,6 @@ static int raid5_resize(mddev_t *mddev, 
 	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
 	mddev->array_size = (sectors * (mddev->raid_disks-conf->max_degraded))>>1;
 	set_capacity(mddev->gendisk, mddev->array_size << 1);
-	mddev->changed = 1;
 	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
 		mddev->recovery_cp = mddev->size << 1;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -3999,7 +3998,6 @@ static void end_reshape(raid5_conf_t *co
 		conf->mddev->array_size = conf->mddev->size *
 			(conf->raid_disks - conf->max_degraded);
 		set_capacity(conf->mddev->gendisk, conf->mddev->array_size << 1);
-		conf->mddev->changed = 1;
 
 		bdev = bdget_disk(conf->mddev->gendisk, 0);
 		if (bdev) {
diff -puN include/linux/raid/md_k.h~md-improve-partition-detection-in-md-array include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-improve-partition-detection-in-md-array
+++ a/include/linux/raid/md_k.h
@@ -201,7 +201,6 @@ struct mddev_s
 	struct mutex			reconfig_mutex;
 	atomic_t			active;
 
-	int				changed;	/* true if we might need to reread partition info */
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
git-md-accel.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
