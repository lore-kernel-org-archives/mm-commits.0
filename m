From: akpm@linux-foundation.org
Subject: - md-restart-recovery-cleanly-after-device-failure.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:22 -0700
Message-ID: <200805270727.m4R7RM66014764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755611AbYE0H2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:28:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, ivan@kasenna.com, mm-commits@vger.kernel.org


The patch titled
     md: restart recovery cleanly after device failure.
has been removed from the -mm tree.  Its filename was
     md-restart-recovery-cleanly-after-device-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: restart recovery cleanly after device failure.
From: NeilBrown <neilb@suse.de>

When we get any IO error during a recovery (rebuilding a spare), we abort
the recovery and restart it.

For RAID6 (and multi-drive RAID1) it may not be best to restart at the
beginning: when multiple failures can be tolerated, the recovery may be
able to continue and re-doing all that has already been done doesn't make
sense.

We already have the infrastructure to record where a recovery is up to
and restart from there, but it is not being used properly.
This is because:
  - We sometimes abort with MD_RECOVERY_ERR rather than just MD_RECOVERY_INTR,
    which causes the recovery not be be checkpointed.
  - We remove spares and then re-added them which loses important state
    information.

The distinction between MD_RECOVERY_ERR and MD_RECOVERY_INTR really isn't
needed.  If there is an error, the relevant drive will be marked as
Faulty, and that is enough to ensure correct handling of the error.  So we
first remove MD_RECOVERY_ERR, changing some of the uses of it to
MD_RECOVERY_INTR.

Then we cause the attempt to remove a non-faulty device from an array to
fail (unless recovery is impossible as the array is too degraded).  Then
when remove_and_add_spares attempts to remove the devices on which
recovery can continue, it will fail, they will remain in place, and
recovery will continue on them as desired.

Issue:  If we are halfway through rebuilding a spare and another drive
fails, and a new spare is immediately available,  do we want to:
 1/ complete the current rebuild, then go back and rebuild the new spare or
 2/ restart the rebuild from the start and rebuild both devices in
    parallel.

Both options can be argued for.  The code currently takes option 2 as
  a/ this requires least code change
  b/ this results in a minimally-degraded array in minimal time.

Cc: "Eivind Sarto" <ivan@kasenna.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c           |   22 +++++++++++-----------
 drivers/md/multipath.c    |    3 ++-
 drivers/md/raid1.c        |   10 +++++++++-
 drivers/md/raid10.c       |   14 ++++++++++++--
 drivers/md/raid5.c        |   10 +++++++++-
 include/linux/raid/md_k.h |    4 +---
 6 files changed, 44 insertions(+), 19 deletions(-)

diff -puN drivers/md/md.c~md-restart-recovery-cleanly-after-device-failure drivers/md/md.c
--- a/drivers/md/md.c~md-restart-recovery-cleanly-after-device-failure
+++ a/drivers/md/md.c
@@ -5434,7 +5434,7 @@ void md_done_sync(mddev_t *mddev, int bl
 	atomic_sub(blocks, &mddev->recovery_active);
 	wake_up(&mddev->recovery_wait);
 	if (!ok) {
-		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 		// stop recovery, signal do_sync ....
 	}
@@ -5690,7 +5690,7 @@ void md_do_sync(mddev_t *mddev)
 		sectors = mddev->pers->sync_request(mddev, j, &skipped,
 						  currspeed < speed_min(mddev));
 		if (sectors == 0) {
-			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto out;
 		}
 
@@ -5713,8 +5713,7 @@ void md_do_sync(mddev_t *mddev)
 
 		last_check = io_sectors;
 
-		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery) ||
-		    test_bit(MD_RECOVERY_ERR, &mddev->recovery))
+		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
 	repeat:
@@ -5768,8 +5767,7 @@ void md_do_sync(mddev_t *mddev)
 	/* tell personality that we are finished */
 	mddev->pers->sync_request(mddev, max_sectors, &skipped, 1);
 
-	if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
+	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > 2) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
@@ -5838,7 +5836,10 @@ static int remove_and_add_spares(mddev_t
 		}
 
 	if (mddev->degraded) {
-		rdev_for_each(rdev, rtmp, mddev)
+		rdev_for_each(rdev, rtmp, mddev) {
+			if (rdev->raid_disk >= 0 &&
+			    !test_bit(In_sync, &rdev->flags))
+				spares++;
 			if (rdev->raid_disk < 0
 			    && !test_bit(Faulty, &rdev->flags)) {
 				rdev->recovery_offset = 0;
@@ -5856,6 +5857,7 @@ static int remove_and_add_spares(mddev_t
 				} else
 					break;
 			}
+		}
 	}
 	return spares;
 }
@@ -5869,7 +5871,7 @@ static int remove_and_add_spares(mddev_t
  * to do that as needed.
  * When it is determined that resync is needed, we set MD_RECOVERY_RUNNING in
  * "->recovery" and create a thread at ->sync_thread.
- * When the thread finishes it sets MD_RECOVERY_DONE (and might set MD_RECOVERY_ERR)
+ * When the thread finishes it sets MD_RECOVERY_DONE
  * and wakeups up this thread which will reap the thread and finish up.
  * This thread also removes any faulty devices (with nr_pending == 0).
  *
@@ -5944,8 +5946,7 @@ void md_check_recovery(mddev_t *mddev)
 			/* resync has finished, collect result */
 			md_unregister_thread(mddev->sync_thread);
 			mddev->sync_thread = NULL;
-			if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
-			    !test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
+			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 				/* success...*/
 				/* activate any spares */
 				mddev->pers->spare_active(mddev);
@@ -5969,7 +5970,6 @@ void md_check_recovery(mddev_t *mddev)
 		 * might be left set
 		 */
 		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-		clear_bit(MD_RECOVERY_ERR, &mddev->recovery);
 		clear_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 
diff -puN drivers/md/multipath.c~md-restart-recovery-cleanly-after-device-failure drivers/md/multipath.c
--- a/drivers/md/multipath.c~md-restart-recovery-cleanly-after-device-failure
+++ a/drivers/md/multipath.c
@@ -327,7 +327,8 @@ static int multipath_remove_disk(mddev_t
 	if (rdev) {
 		if (test_bit(In_sync, &rdev->flags) ||
 		    atomic_read(&rdev->nr_pending)) {
-			printk(KERN_ERR "hot-remove-disk, slot %d is identified"				" but is still operational!\n", number);
+			printk(KERN_ERR "hot-remove-disk, slot %d is identified"
+			       " but is still operational!\n", number);
 			err = -EBUSY;
 			goto abort;
 		}
diff -puN drivers/md/raid1.c~md-restart-recovery-cleanly-after-device-failure drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-restart-recovery-cleanly-after-device-failure
+++ a/drivers/md/raid1.c
@@ -1027,7 +1027,7 @@ static void error(mddev_t *mddev, mdk_rd
 		/*
 		 * if recovery is running, make sure it aborts.
 		 */
-		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	} else
 		set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
@@ -1148,6 +1148,14 @@ static int raid1_remove_disk(mddev_t *md
 			err = -EBUSY;
 			goto abort;
 		}
+		/* Only remove non-faulty devices is recovery
+		 * is not possible.
+		 */
+		if (!test_bit(Faulty, &rdev->flags) &&
+		    mddev->degraded < conf->raid_disks) {
+			err = -EBUSY;
+			goto abort;
+		}
 		p->rdev = NULL;
 		synchronize_rcu();
 		if (atomic_read(&rdev->nr_pending)) {
diff -puN drivers/md/raid10.c~md-restart-recovery-cleanly-after-device-failure drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-restart-recovery-cleanly-after-device-failure
+++ a/drivers/md/raid10.c
@@ -1020,7 +1020,7 @@ static void error(mddev_t *mddev, mdk_rd
 		/*
 		 * if recovery is running, make sure it aborts.
 		 */
-		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	}
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
@@ -1171,6 +1171,14 @@ static int raid10_remove_disk(mddev_t *m
 			err = -EBUSY;
 			goto abort;
 		}
+		/* Only remove faulty devices in recovery
+		 * is not possible.
+		 */
+		if (!test_bit(Faulty, &rdev->flags) &&
+		    enough(conf)) {
+			err = -EBUSY;
+			goto abort;
+		}
 		p->rdev = NULL;
 		synchronize_rcu();
 		if (atomic_read(&rdev->nr_pending)) {
@@ -1237,6 +1245,7 @@ static void end_sync_write(struct bio *b
 
 	if (!uptodate)
 		md_error(mddev, conf->mirrors[d].rdev);
+
 	update_head_pos(i, r10_bio);
 
 	while (atomic_dec_and_test(&r10_bio->remaining)) {
@@ -1844,7 +1853,8 @@ static sector_t sync_request(mddev_t *md
 					if (rb2)
 						atomic_dec(&rb2->remaining);
 					r10_bio = rb2;
-					if (!test_and_set_bit(MD_RECOVERY_ERR, &mddev->recovery))
+					if (!test_and_set_bit(MD_RECOVERY_INTR,
+							      &mddev->recovery))
 						printk(KERN_INFO "raid10: %s: insufficient working devices for recovery.\n",
 						       mdname(mddev));
 					break;
diff -puN drivers/md/raid5.c~md-restart-recovery-cleanly-after-device-failure drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-restart-recovery-cleanly-after-device-failure
+++ a/drivers/md/raid5.c
@@ -1268,7 +1268,7 @@ static void error(mddev_t *mddev, mdk_rd
 			/*
 			 * if recovery was running, make sure it aborts.
 			 */
-			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		}
 		set_bit(Faulty, &rdev->flags);
 		printk (KERN_ALERT
@@ -4574,6 +4574,14 @@ static int raid5_remove_disk(mddev_t *md
 			err = -EBUSY;
 			goto abort;
 		}
+		/* Only remove non-faulty devices if recovery
+		 * isn't possible.
+		 */
+		if (!test_bit(Faulty, &rdev->flags) &&
+		    mddev->degraded <= conf->max_degraded) {
+			err = -EBUSY;
+			goto abort;
+		}
 		p->rdev = NULL;
 		synchronize_rcu();
 		if (atomic_read(&rdev->nr_pending)) {
diff -puN include/linux/raid/md_k.h~md-restart-recovery-cleanly-after-device-failure include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-restart-recovery-cleanly-after-device-failure
+++ a/include/linux/raid/md_k.h
@@ -188,8 +188,7 @@ struct mddev_s
 	 * NEEDED:   we might need to start a resync/recover
 	 * RUNNING:  a thread is running, or about to be started
 	 * SYNC:     actually doing a resync, not a recovery
-	 * ERR:      and IO error was detected - abort the resync/recovery
-	 * INTR:     someone requested a (clean) early abort.
+	 * INTR:     resync needs to be aborted for some reason
 	 * DONE:     thread is done and is waiting to be reaped
 	 * REQUEST:  user-space has requested a sync (used with SYNC)
 	 * CHECK:    user-space request for for check-only, no repair
@@ -199,7 +198,6 @@ struct mddev_s
 	 */
 #define	MD_RECOVERY_RUNNING	0
 #define	MD_RECOVERY_SYNC	1
-#define	MD_RECOVERY_ERR		2
 #define	MD_RECOVERY_INTR	3
 #define	MD_RECOVERY_DONE	4
 #define	MD_RECOVERY_NEEDED	5
_

Patches currently in -mm which might be from neilb@suse.de are

md-fix-prexor-vs-sync_request-race.patch
md-fix-uninitialized-use-of-mddev-recovery_wait.patch
md-do-not-compute-parity-unless-it-is-on-a-failed-drive.patch
linux-next.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch

