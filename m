From: akpm@linux-foundation.org
Subject: + md-move-warning-about-creating-a-raid-array-on-partitions-of-the-one-device.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:48:22 -0800
Message-ID: <200702212248.l1LMmMew028955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423249AbXBUWs0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:48:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     From: NeilBrown <neilb@suse.de>
has been added to the -mm tree.  Its filename is
     md-move-warning-about-creating-a-raid-array-on-partitions-of-the-one-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: NeilBrown <neilb@suse.de>


md tries to warn the user if they e.g. create a raid1 using two partitions
of the same device, as this does not provide true redundancy.

However it also warns if a raid0 is created like this, and there is
nothing wrong with that.

At the place where the warning is currently printer, we don't necessarily
know what level the array will be, so move the warning from the point
where the device is added to the point where the array is started.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 1 file changed, 37 insertions(+), 26 deletions(-)

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   63 +++++++++++++++++++++++++++-------------------
 1 files changed, 37 insertions(+), 26 deletions(-)

diff -puN drivers/md/md.c~md-move-warning-about-creating-a-raid-array-on-partitions-of-the-one-device drivers/md/md.c
--- a/drivers/md/md.c~md-move-warning-about-creating-a-raid-array-on-partitions-of-the-one-device
+++ a/drivers/md/md.c
@@ -1296,27 +1296,17 @@ static struct super_type super_types[] =
 		.sync_super	= super_1_sync,
 	},
 };
-	
-static mdk_rdev_t * match_dev_unit(mddev_t *mddev, mdk_rdev_t *dev)
-{
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
-
-	ITERATE_RDEV(mddev,rdev,tmp)
-		if (rdev->bdev->bd_contains == dev->bdev->bd_contains)
-			return rdev;
-
-	return NULL;
-}
 
 static int match_mddev_units(mddev_t *mddev1, mddev_t *mddev2)
 {
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
+	struct list_head *tmp, *tmp2;
+	mdk_rdev_t *rdev, *rdev2;
 
 	ITERATE_RDEV(mddev1,rdev,tmp)
-		if (match_dev_unit(mddev2, rdev))
-			return 1;
+		ITERATE_RDEV(mddev2, rdev2, tmp2)
+			if (rdev->bdev->bd_contains ==
+			    rdev2->bdev->bd_contains)
+				return 1;
 
 	return 0;
 }
@@ -1325,8 +1315,7 @@ static LIST_HEAD(pending_raid_disks);
 
 static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 {
-	mdk_rdev_t *same_pdev;
-	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
+	char b[BDEVNAME_SIZE];
 	struct kobject *ko;
 	char *s;
 
@@ -1342,14 +1331,6 @@ static int bind_rdev_to_array(mdk_rdev_t
 		else
 			mddev->size = rdev->size;
 	}
-	same_pdev = match_dev_unit(mddev, rdev);
-	if (same_pdev)
-		printk(KERN_WARNING
-			"%s: WARNING: %s appears to be on the same physical"
-	 		" disk as %s. True\n     protection against single-disk"
-			" failure might be compromised.\n",
-			mdname(mddev), bdevname(rdev->bdev,b),
-			bdevname(same_pdev->bdev,b2));
 
 	/* Verify rdev->desc_nr is unique.
 	 * If it is -1, assign a free number, else
@@ -3109,6 +3090,36 @@ static int do_md_run(mddev_t * mddev)
 		return -EINVAL;
 	}
 
+	if (pers->sync_request) {
+		/* Warn if this is a potentially silly
+		 * configuration.
+		 */
+		char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
+		mdk_rdev_t *rdev2;
+		struct list_head *tmp2;
+		int warned = 0;
+		ITERATE_RDEV(mddev, rdev, tmp) {
+			ITERATE_RDEV(mddev, rdev2, tmp2) {
+				if (rdev < rdev2 &&
+				    rdev->bdev->bd_contains ==
+				    rdev2->bdev->bd_contains) {
+					printk(KERN_WARNING
+					       "%s: WARNING: %s appears to be"
+					       " on the same physical disk as"
+					       " %s.\n",
+					       mdname(mddev),
+					       bdevname(rdev->bdev,b),
+					       bdevname(rdev2->bdev,b2));
+					warned = 1;
+				}
+			}
+		}
+		if (warned)
+			printk(KERN_WARNING
+			       "True protection against single-disk"
+			       " failure might be compromised.\n");
+	}
+
 	mddev->recovery = 0;
 	mddev->resync_max_sectors = mddev->size << 1; /* may be over-ridden by personality */
 	mddev->barriers_work = 1;
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
