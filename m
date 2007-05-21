From: akpm@linux-foundation.org
Subject: + md-improve-the-is_mddev_idle-test-fix.patch added to -mm tree
Date: Sun, 20 May 2007 21:33:38 -0700
Message-ID: <200705210433.l4L4XbPe002445@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754556AbXEUEet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: improve the is_mddev_idle test fix
has been added to the -mm tree.  Its filename is
     md-improve-the-is_mddev_idle-test-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -5092,7 +5092,7 @@ static int is_mddev_idle(mddev_t *mddev)
 	mdk_rdev_t * rdev;
 	struct list_head *tmp;
 	int idle;
-	unsigned long curr_events;
+	long curr_events;
 
 	idle = 1;
 	ITERATE_RDEV(mddev,rdev,tmp) {
@@ -5100,20 +5100,29 @@ static int is_mddev_idle(mddev_t *mddev)
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

git-md-accel.patch
md-avoid-overflow-in-raid0-calculation-with-large-components.patch
md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap.patch
md-fix-bug-with-linear-hot-add-and-elsewhere.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
nfsd-warning-fix.patch
use-menuconfig-objects-ii-md.patch
md-improve-message-about-invalid-superblock-during-autodetect.patch
md-improve-the-is_mddev_idle-test-fix.patch
md-check-that-internal-bitmap-does-not-overlap-other-data.patch
md-change-bitmap_unplug-and-others-to-void-functions.patch
