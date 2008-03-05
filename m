From: akpm@linux-foundation.org
Subject: - md-clean-up-irregularity-with-raid-autodetect.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:27 -0800
Message-ID: <200803050746.m257kRgA021772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763419AbYCEHqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: clean up irregularity with raid autodetect
has been removed from the -mm tree.  Its filename was
     md-clean-up-irregularity-with-raid-autodetect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: clean up irregularity with raid autodetect
From: NeilBrown <neilb@suse.de>

When a raid1 array is stopped, all components currently get added to the list
for auto-detection.  However we should really only add components that were
found by autodetection in the first place.  So add a flag to record that
information, and use it.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c           |    4 +++-
 include/linux/raid/md_k.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-clean-up-irregularity-with-raid-autodetect drivers/md/md.c
--- a/drivers/md/md.c~md-clean-up-irregularity-with-raid-autodetect
+++ a/drivers/md/md.c
@@ -1503,7 +1503,8 @@ static void export_rdev(mdk_rdev_t * rde
 	free_disk_sb(rdev);
 	list_del_init(&rdev->same_set);
 #ifndef MODULE
-	md_autodetect_dev(rdev->bdev->bd_dev);
+	if (test_bit(AutoDetected, &rdev->flags))
+		md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
 	unlock_rdev(rdev);
 	kobject_put(&rdev->kobj);
@@ -6025,6 +6026,7 @@ static void autostart_arrays(int part)
 			MD_BUG();
 			continue;
 		}
+		set_bit(AutoDetected, &rdev->flags);
 		list_add(&rdev->same_set, &pending_raid_disks);
 		i_passed++;
 	}
diff -puN include/linux/raid/md_k.h~md-clean-up-irregularity-with-raid-autodetect include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-clean-up-irregularity-with-raid-autodetect
+++ a/include/linux/raid/md_k.h
@@ -83,6 +83,7 @@ struct mdk_rdev_s
 #define	BarriersNotsupp	5		/* BIO_RW_BARRIER is not supported */
 #define	AllReserved	6		/* If whole device is reserved for
 					 * one array */
+#define	AutoDetected	7		/* added by auto-detect */
 
 	int desc_nr;			/* descriptor index in the superblock */
 	int raid_disk;			/* role of device in array */
_

Patches currently in -mm which might be from neilb@suse.de are

git-nfsd.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch

