From: akpm@linux-foundation.org
Subject: - md-set-and-test-the-persistent-flag-for-md-devices-more-consistently.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:54 -0800
Message-ID: <200802070029.m170TZBT007290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58215 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933838AbYBGAn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: set and test the ->persistent flag for md devices more consistently
has been removed from the -mm tree.  Its filename was
     md-set-and-test-the-persistent-flag-for-md-devices-more-consistently.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: set and test the ->persistent flag for md devices more consistently
From: NeilBrown <neilb@suse.de>

If you try to start an array for which the number of raid disks is listed as
zero, md will currently try to read metadata off any devices that have been
given.  This was done because the value of raid_disks is used to signal
whether array details have been provided by userspace (raid_disks > 0) or must
be read from the devices (raid_disks == 0).

However for an array without persistent metadata (or with externally managed
metadata) this is the wrong thing to do.  So we add a test in do_md_run to
give an error if raid_disks is zero for non-persistent arrays.

This requires that mddev->persistent is set corrently at this point, which it
currently isn't for in-kernel autodetected arrays.

So set ->persistent for autodetect arrays, and remove the settign in
super_*_validate which is now redundant.

Also clear ->persistent when stopping an array so it is consistently zero when
starting an array.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/md/md.c~md-set-and-test-the-persistent-flag-for-md-devices-more-consistently drivers/md/md.c
--- a/drivers/md/md.c~md-set-and-test-the-persistent-flag-for-md-devices-more-consistently
+++ a/drivers/md/md.c
@@ -779,7 +779,6 @@ static int super_90_validate(mddev_t *md
 		mddev->major_version = 0;
 		mddev->minor_version = sb->minor_version;
 		mddev->patch_version = sb->patch_version;
-		mddev->persistent = 1;
 		mddev->external = 0;
 		mddev->chunk_size = sb->chunk_size;
 		mddev->ctime = sb->ctime;
@@ -1159,7 +1158,6 @@ static int super_1_validate(mddev_t *mdd
 	if (mddev->raid_disks == 0) {
 		mddev->major_version = 1;
 		mddev->patch_version = 0;
-		mddev->persistent = 1;
 		mddev->external = 0;
 		mddev->chunk_size = le32_to_cpu(sb->chunksize) << 9;
 		mddev->ctime = le64_to_cpu(sb->ctime) & ((1ULL << 32)-1);
@@ -3213,8 +3211,11 @@ static int do_md_run(mddev_t * mddev)
 	/*
 	 * Analyze all RAID superblock(s)
 	 */
-	if (!mddev->raid_disks)
+	if (!mddev->raid_disks) {
+		if (!mddev->persistent)
+			return -EINVAL;
 		analyze_sbs(mddev);
+	}
 
 	chunk_size = mddev->chunk_size;
 
@@ -3621,6 +3622,7 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->resync_max = MaxSector;
 		mddev->reshape_position = MaxSector;
 		mddev->external = 0;
+		mddev->persistent = 0;
 
 	} else if (mddev->pers)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
@@ -3729,6 +3731,7 @@ static void autorun_devices(int part)
 			mddev_unlock(mddev);
 		} else {
 			printk(KERN_INFO "md: created %s\n", mdname(mddev));
+			mddev->persistent = 1;
 			ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
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
