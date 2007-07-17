From: akpm@linux-foundation.org
Subject: - md-improve-the-is_mddev_idle-test-fix.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:04 -0700
Message-ID: <200707172309.l6HN94gx012341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765890AbXGQXPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: improve the is_mddev_idle test fix
has been removed from the -mm tree.  Its filename was
     md-improve-the-is_mddev_idle-test-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: improve the is_mddev_idle test fix
From: NeilBrown <neilb@suse.de>

Don't use 'unsigned' variable to track sync vs non-sync IO, as the only thing
we want to do with them is a signed comparison, and fix up the comment which
had become quite wrong.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c           |   35 ++++++++++++++++++++++-------------
 include/linux/raid/md_k.h |    2 +-
 2 files changed, 23 insertions(+), 14 deletions(-)

diff -puN drivers/md/md.c~md-improve-the-is_mddev_idle-test-fix drivers/md/md.c
--- a/drivers/md/md.c~md-improve-the-is_mddev_idle-test-fix
+++ a/drivers/md/md.c
@@ -5091,7 +5091,7 @@ static int is_mddev_idle(mddev_t *mddev)
 	mdk_rdev_t * rdev;
 	struct list_head *tmp;
 	int idle;
-	unsigned long curr_events;
+	long curr_events;
 
 	idle = 1;
 	ITERATE_RDEV(mddev,rdev,tmp) {
@@ -5099,20 +5099,29 @@ static int is_mddev_idle(mddev_t *mddev)
 		curr_events = disk_stat_read(disk, sectors[0]) + 
 				disk_stat_read(disk, sectors[1]) - 
 				atomic_read(&disk->sync_io);
-		/* The difference between curr_events and last_events
-		 * will be affected by any new non-sync IO (making
-		 * curr_events bigger) and any difference in the amount of
-		 * in-flight syncio (making current_events bigger or smaller)
-		 * The amount in-flight is currently limited to
-		 * 32*64K in raid1/10 and 256*PAGE_SIZE in raid5/6
-		 * which is at most 4096 sectors.
-		 * These numbers are fairly fragile and should be made
-		 * more robust, probably by enforcing the
-		 * 'window size' that md_do_sync sort-of uses.
+		/* sync IO will cause sync_io to increase before the disk_stats
+		 * as sync_io is counted when a request starts, and
+		 * disk_stats is counted when it completes.
+		 * So resync activity will cause curr_events to be smaller than
+		 * when there was no such activity.
+		 * non-sync IO will cause disk_stat to increase without
+		 * increasing sync_io so curr_events will (eventually)
+		 * be larger than it was before.  Once it becomes
+		 * substantially larger, the test below will cause
+		 * the array to appear non-idle, and resync will slow
+		 * down.
+		 * If there is a lot of outstanding resync activity when
+		 * we set last_event to curr_events, then all that activity
+		 * completing might cause the array to appear non-idle
+		 * and resync will be slowed down even though there might
+		 * not have been non-resync activity.  This will only
+		 * happen once though.  'last_events' will soon reflect
+		 * the state where there is little or no outstanding
+		 * resync requests, and further resync activity will
+		 * always make curr_events less than last_events.
 		 *
-		 * Note: the following is an unsigned comparison.
 		 */
-		if ((long)curr_events - (long)rdev->last_events > 4096) {
+		if (curr_events - rdev->last_events > 4096) {
 			rdev->last_events = curr_events;
 			idle = 0;
 		}
diff -puN include/linux/raid/md_k.h~md-improve-the-is_mddev_idle-test-fix include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-improve-the-is_mddev_idle-test-fix
+++ a/include/linux/raid/md_k.h
@@ -51,7 +51,7 @@ struct mdk_rdev_s
 
 	sector_t size;			/* Device size (in blocks) */
 	mddev_t *mddev;			/* RAID array if running */
-	unsigned long last_events;	/* IO event timestamp */
+	long last_events;		/* IO event timestamp */
 
 	struct block_device *bdev;	/* block device handle */
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
raid5-add-the-stripe_queue-object-for-tracking-raid.patch
raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2.patch
raid5-use-stripe_queues-to-prioritize-the-most.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
