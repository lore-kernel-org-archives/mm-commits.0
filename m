From: akpm@linux-foundation.org
Subject: + md-restart-a-raid5-reshape-that-has-been-aborted-due-to-a-read-write-error.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:48:28 -0800
Message-ID: <200702212248.l1LMmSaS028961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53732 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423251AbXBUWsc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:48:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     From: NeilBrown <neilb@suse.de>
has been added to the -mm tree.  Its filename is
     md-restart-a-raid5-reshape-that-has-been-aborted-due-to-a-read-write-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: NeilBrown <neilb@suse.de>


An error always aborts any resync/recovery/reshape on the understanding
that it will immediately be restarted if that still makes sense.
However a reshape currently doesn't get restarted.  With this patch
it does.
To avoid restarting when it is not possible to do work, we call
into the personality to check that a reshape is ok, and strengthen
raid5_check_reshape to fail if there are too many failed devices.

We also break some code out into a separate function: remove_and_add_spares
as the indent level for that code was getting crazy.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c    |   74 ++++++++++++++++++++++++++-----------------
 drivers/md/raid5.c |    2 +
 2 files changed, 47 insertions(+), 29 deletions(-)

diff -puN drivers/md/md.c~md-restart-a-raid5-reshape-that-has-been-aborted-due-to-a-read-write-error drivers/md/md.c
--- a/drivers/md/md.c~md-restart-a-raid5-reshape-that-has-been-aborted-due-to-a-read-write-error
+++ a/drivers/md/md.c
@@ -5357,6 +5357,44 @@ void md_do_sync(mddev_t *mddev)
 EXPORT_SYMBOL_GPL(md_do_sync);
 
 
+static int remove_and_add_spares(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	struct list_head *rtmp;
+	int spares = 0;
+
+	ITERATE_RDEV(mddev,rdev,rtmp)
+		if (rdev->raid_disk >= 0 &&
+		    (test_bit(Faulty, &rdev->flags) ||
+		     ! test_bit(In_sync, &rdev->flags)) &&
+		    atomic_read(&rdev->nr_pending)==0) {
+			if (mddev->pers->hot_remove_disk(
+				    mddev, rdev->raid_disk)==0) {
+				char nm[20];
+				sprintf(nm,"rd%d", rdev->raid_disk);
+				sysfs_remove_link(&mddev->kobj, nm);
+				rdev->raid_disk = -1;
+			}
+		}
+
+	if (mddev->degraded) {
+		ITERATE_RDEV(mddev,rdev,rtmp)
+			if (rdev->raid_disk < 0
+			    && !test_bit(Faulty, &rdev->flags)) {
+				rdev->recovery_offset = 0;
+				if (mddev->pers->hot_add_disk(mddev,rdev)) {
+					char nm[20];
+					sprintf(nm, "rd%d", rdev->raid_disk);
+					sysfs_create_link(&mddev->kobj,
+							  &rdev->kobj, nm);
+					spares++;
+					md_new_event(mddev);
+				} else
+					break;
+			}
+	}
+	return spares;
+}
 /*
  * This routine is regularly called by all per-raid-array threads to
  * deal with generic issues like resync and super-block update.
@@ -5411,7 +5449,7 @@ void md_check_recovery(mddev_t *mddev)
 		return;
 
 	if (mddev_trylock(mddev)) {
-		int spares =0;
+		int spares = 0;
 
 		spin_lock_irq(&mddev->write_lock);
 		if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
@@ -5474,35 +5512,13 @@ void md_check_recovery(mddev_t *mddev)
 		 * Spare are also removed and re-added, to allow
 		 * the personality to fail the re-add.
 		 */
-		ITERATE_RDEV(mddev,rdev,rtmp)
-			if (rdev->raid_disk >= 0 &&
-			    (test_bit(Faulty, &rdev->flags) || ! test_bit(In_sync, &rdev->flags)) &&
-			    atomic_read(&rdev->nr_pending)==0) {
-				if (mddev->pers->hot_remove_disk(mddev, rdev->raid_disk)==0) {
-					char nm[20];
-					sprintf(nm,"rd%d", rdev->raid_disk);
-					sysfs_remove_link(&mddev->kobj, nm);
-					rdev->raid_disk = -1;
-				}
-			}
-
-		if (mddev->degraded) {
-			ITERATE_RDEV(mddev,rdev,rtmp)
-				if (rdev->raid_disk < 0
-				    && !test_bit(Faulty, &rdev->flags)) {
-					rdev->recovery_offset = 0;
-					if (mddev->pers->hot_add_disk(mddev,rdev)) {
-						char nm[20];
-						sprintf(nm, "rd%d", rdev->raid_disk);
-						sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
-						spares++;
-						md_new_event(mddev);
-					} else
-						break;
-				}
-		}
 
-		if (spares) {
+		if (mddev->reshape_position != MaxSector) {
+			if (mddev->pers->check_reshape(mddev) != 0)
+				/* Cannot proceed */
+				goto unlock;
+			set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+		} else if ((spares = remove_and_add_spares(mddev))) {
 			clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		} else if (mddev->recovery_cp < MaxSector) {
diff -puN drivers/md/raid5.c~md-restart-a-raid5-reshape-that-has-been-aborted-due-to-a-read-write-error drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-restart-a-raid5-reshape-that-has-been-aborted-due-to-a-read-write-error
+++ a/drivers/md/raid5.c
@@ -3814,6 +3814,8 @@ static int raid5_check_reshape(mddev_t *
 	if (err)
 		return err;
 
+	if (mddev->degraded > conf->max_degraded)
+		return -EINVAL;
 	/* looks like we might be able to manage this */
 	return 0;
 }
_

Patches currently in -mm which might be from neilb@suse.de are

fix-failure-paths-in-modules-init-in-umemc.patch
md-fix-raid10-recovery-problem.patch
md-raid6-clean-up-cpuid-and-fpu-enter-exit-code.patch
md-move-warning-about-creating-a-raid-array-on-partitions-of-the-one-device.patch
md-clean-out-unplug-and-other-queue-function-on-md-shutdown.patch
md-restart-a-raid5-reshape-that-has-been-aborted-due-to-a-read-write-error.patch
md-add-support-for-reshape-of-a-raid6.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous-tidy.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
