From: akpm@linux-foundation.org
Subject: - md-allow-a-maximum-extent-to-be-set-for-resyncing.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:52 -0800
Message-ID: <200802070029.m170TXqq007283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934984AbYBGAnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: allow a maximum extent to be set for resyncing
has been removed from the -mm tree.  Its filename was
     md-allow-a-maximum-extent-to-be-set-for-resyncing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: allow a maximum extent to be set for resyncing
From: NeilBrown <neilb@suse.de>

This allows userspace to control resync/reshape progress and synchronise it
with other activities, such as shared access in a SAN, or backing up critical
sections during a tricky reshape.

Writing a number of sectors (which must be a multiple of the chunk size if
such is meaningful) causes a resync to pause when it gets to that point.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/md.txt      |   10 ++++
 drivers/md/md.c           |   75 +++++++++++++++++++++++++++++++-----
 drivers/md/raid1.c        |    2 
 drivers/md/raid10.c       |    3 +
 drivers/md/raid5.c        |   25 ++++++++++++
 include/linux/raid/md_k.h |    2 
 6 files changed, 107 insertions(+), 10 deletions(-)

diff -puN Documentation/md.txt~md-allow-a-maximum-extent-to-be-set-for-resyncing Documentation/md.txt
--- a/Documentation/md.txt~md-allow-a-maximum-extent-to-be-set-for-resyncing
+++ a/Documentation/md.txt
@@ -416,6 +416,16 @@ also have
      sectors in total that could need to be processed.  The two
      numbers are separated by a '/'  thus effectively showing one
      value, a fraction of the process that is complete.
+     A 'select' on this attribute will return when resync completes,
+     when it reaches the current sync_max (below) and possibly at
+     other times.
+
+   sync_max
+     This is a number of sectors at which point a resync/recovery
+     process will pause.  When a resync is active, the value can
+     only ever be increased, never decreased.  The value of 'max'
+     effectively disables the limit.
+
 
    sync_speed
      This shows the current actual speed, in K/sec, of the current
diff -puN drivers/md/md.c~md-allow-a-maximum-extent-to-be-set-for-resyncing drivers/md/md.c
--- a/drivers/md/md.c~md-allow-a-maximum-extent-to-be-set-for-resyncing
+++ a/drivers/md/md.c
@@ -275,6 +275,7 @@ static mddev_t * mddev_find(dev_t unit)
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
 	new->reshape_position = MaxSector;
+	new->resync_max = MaxSector;
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
@@ -2921,6 +2922,43 @@ sync_completed_show(mddev_t *mddev, char
 static struct md_sysfs_entry md_sync_completed = __ATTR_RO(sync_completed);
 
 static ssize_t
+max_sync_show(mddev_t *mddev, char *page)
+{
+	if (mddev->resync_max == MaxSector)
+		return sprintf(page, "max\n");
+	else
+		return sprintf(page, "%llu\n",
+			       (unsigned long long)mddev->resync_max);
+}
+static ssize_t
+max_sync_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	if (strncmp(buf, "max", 3) == 0)
+		mddev->resync_max = MaxSector;
+	else {
+		char *ep;
+		unsigned long long max = simple_strtoull(buf, &ep, 10);
+		if (ep == buf || (*ep != 0 && *ep != '\n'))
+			return -EINVAL;
+		if (max < mddev->resync_max &&
+		    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+			return -EBUSY;
+
+		/* Must be a multiple of chunk_size */
+		if (mddev->chunk_size) {
+			if (max & (sector_t)((mddev->chunk_size>>9)-1))
+				return -EINVAL;
+		}
+		mddev->resync_max = max;
+	}
+	wake_up(&mddev->recovery_wait);
+	return len;
+}
+
+static struct md_sysfs_entry md_max_sync =
+__ATTR(sync_max, S_IRUGO|S_IWUSR, max_sync_show, max_sync_store);
+
+static ssize_t
 suspend_lo_show(mddev_t *mddev, char *page)
 {
 	return sprintf(page, "%llu\n", (unsigned long long)mddev->suspend_lo);
@@ -3030,6 +3068,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_max.attr,
 	&md_sync_speed.attr,
 	&md_sync_completed.attr,
+	&md_max_sync.attr,
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
 	&md_bitmap.attr,
@@ -3579,6 +3618,7 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->size = 0;
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
+		mddev->resync_max = MaxSector;
 		mddev->reshape_position = MaxSector;
 		mddev->external = 0;
 
@@ -5443,8 +5483,16 @@ void md_do_sync(mddev_t *mddev)
 		sector_t sectors;
 
 		skipped = 0;
+		if (j >= mddev->resync_max) {
+			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
+			wait_event(mddev->recovery_wait,
+				   mddev->resync_max > j
+				   || kthread_should_stop());
+		}
+		if (kthread_should_stop())
+			goto interrupted;
 		sectors = mddev->pers->sync_request(mddev, j, &skipped,
-					    currspeed < speed_min(mddev));
+						  currspeed < speed_min(mddev));
 		if (sectors == 0) {
 			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 			goto out;
@@ -5486,15 +5534,9 @@ void md_do_sync(mddev_t *mddev)
 		}
 
 
-		if (kthread_should_stop()) {
-			/*
-			 * got a signal, exit.
-			 */
-			printk(KERN_INFO 
-				"md: md_do_sync() got signal ... exiting\n");
-			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			goto out;
-		}
+		if (kthread_should_stop())
+			goto interrupted;
+
 
 		/*
 		 * this loop exits only if either when we are slower than
@@ -5558,9 +5600,22 @@ void md_do_sync(mddev_t *mddev)
 
  skip:
 	mddev->curr_resync = 0;
+	mddev->resync_max = MaxSector;
+	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	wake_up(&resync_wait);
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
+	return;
+
+ interrupted:
+	/*
+	 * got a signal, exit.
+	 */
+	printk(KERN_INFO
+	       "md: md_do_sync() got signal ... exiting\n");
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+	goto out;
+
 }
 EXPORT_SYMBOL_GPL(md_do_sync);
 
diff -puN drivers/md/raid1.c~md-allow-a-maximum-extent-to-be-set-for-resyncing drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-allow-a-maximum-extent-to-be-set-for-resyncing
+++ a/drivers/md/raid1.c
@@ -1767,6 +1767,8 @@ static sector_t sync_request(mddev_t *md
 		return rv;
 	}
 
+	if (max_sector > mddev->resync_max)
+		max_sector = mddev->resync_max; /* Don't do IO beyond here */
 	nr_sectors = 0;
 	sync_blocks = 0;
 	do {
diff -puN drivers/md/raid10.c~md-allow-a-maximum-extent-to-be-set-for-resyncing drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-allow-a-maximum-extent-to-be-set-for-resyncing
+++ a/drivers/md/raid10.c
@@ -1657,6 +1657,9 @@ static sector_t sync_request(mddev_t *md
 		return (max_sector - sector_nr) + sectors_skipped;
 	}
 
+	if (max_sector > mddev->resync_max)
+		max_sector = mddev->resync_max; /* Don't do IO beyond here */
+
 	/* make sure whole request will fit in a chunk - if chunks
 	 * are meaningful
 	 */
diff -puN drivers/md/raid5.c~md-allow-a-maximum-extent-to-be-set-for-resyncing drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-allow-a-maximum-extent-to-be-set-for-resyncing
+++ a/drivers/md/raid5.c
@@ -3698,6 +3698,25 @@ static sector_t reshape_request(mddev_t 
 		release_stripe(sh);
 		first_sector += STRIPE_SECTORS;
 	}
+	/* If this takes us to the resync_max point where we have to pause,
+	 * then we need to write out the superblock.
+	 */
+	sector_nr += conf->chunk_size>>9;
+	if (sector_nr >= mddev->resync_max) {
+		/* Cannot proceed until we've updated the superblock... */
+		wait_event(conf->wait_for_overlap,
+			   atomic_read(&conf->reshape_stripes) == 0);
+		mddev->reshape_position = conf->expand_progress;
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		md_wakeup_thread(mddev->thread);
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_CHANGE_DEVS, &mddev->flags)
+			   || kthread_should_stop());
+		spin_lock_irq(&conf->device_lock);
+		conf->expand_lo = mddev->reshape_position;
+		spin_unlock_irq(&conf->device_lock);
+		wake_up(&conf->wait_for_overlap);
+	}
 	return conf->chunk_size>>9;
 }
 
@@ -3734,6 +3753,12 @@ static inline sector_t sync_request(mdde
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return reshape_request(mddev, sector_nr, skipped);
 
+	/* No need to check resync_max as we never do more than one
+	 * stripe, and as resync_max will always be on a chunk boundary,
+	 * if the check in md_do_sync didn't fire, there is no chance
+	 * of overstepping resync_max here
+	 */
+
 	/* if there is too many failed drives and we are trying
 	 * to resync, then assert that we are finished, because there is
 	 * nothing we can do.
diff -puN include/linux/raid/md_k.h~md-allow-a-maximum-extent-to-be-set-for-resyncing include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-allow-a-maximum-extent-to-be-set-for-resyncing
+++ a/include/linux/raid/md_k.h
@@ -219,6 +219,8 @@ struct mddev_s
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
+	sector_t			resync_max;	/* resync should pause
+							 * when it gets here */
 
 	spinlock_t			write_lock;
 	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
d_path-make-d_path-use-a-struct-path-fix.patch
