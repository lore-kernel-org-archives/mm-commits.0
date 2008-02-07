From: akpm@linux-foundation.org
Subject: - md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:50 -0800
Message-ID: <200802070029.m170TVOY007280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934335AbYBGAna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: give userspace control over removing failed devices when external metdata in use
has been removed from the -mm tree.  Its filename was
     md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: give userspace control over removing failed devices when external metdata in use
From: NeilBrown <neilb@suse.de>

When a device fails, we must not allow an further writes to the array until
the device failure has been recorded in array metadata.  When metadata is
managed externally, this requires some synchronisation...

Allow/require userspace to explicitly remove failed devices from active
service in the array by writing 'none' to the 'slot' attribute.  If this
reduces the number of failed devices to 0, the write block will automatically
be lowered.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff -puN drivers/md/md.c~md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use drivers/md/md.c
--- a/drivers/md/md.c~md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use
+++ a/drivers/md/md.c
@@ -1891,20 +1891,44 @@ static ssize_t
 slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
 	char *e;
+	int err;
+	char nm[20];
 	int slot = simple_strtoul(buf, &e, 10);
 	if (strncmp(buf, "none", 4)==0)
 		slot = -1;
 	else if (e==buf || (*e && *e!= '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
-		/* Cannot set slot in active array (yet) */
-		return -EBUSY;
-	if (slot >= rdev->mddev->raid_disks)
-		return -ENOSPC;
-	rdev->raid_disk = slot;
-	/* assume it is working */
-	rdev->flags = 0;
-	set_bit(In_sync, &rdev->flags);
+	if (rdev->mddev->pers) {
+		/* Setting 'slot' on an active array requires also
+		 * updating the 'rd%d' link, and communicating
+		 * with the personality with ->hot_*_disk.
+		 * For now we only support removing
+		 * failed/spare devices.  This normally happens automatically,
+		 * but not when the metadata is externally managed.
+		 */
+		if (slot != -1)
+			return -EBUSY;
+		if (rdev->raid_disk == -1)
+			return -EEXIST;
+		/* personality does all needed checks */
+		if (rdev->mddev->pers->hot_add_disk == NULL)
+			return -EINVAL;
+		err = rdev->mddev->pers->
+			hot_remove_disk(rdev->mddev, rdev->raid_disk);
+		if (err)
+			return err;
+		sprintf(nm, "rd%d", rdev->raid_disk);
+		sysfs_remove_link(&rdev->mddev->kobj, nm);
+		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
+		md_wakeup_thread(rdev->mddev->thread);
+	} else {
+		if (slot >= rdev->mddev->raid_disks)
+			return -ENOSPC;
+		rdev->raid_disk = slot;
+		/* assume it is working */
+		rdev->flags = 0;
+		set_bit(In_sync, &rdev->flags);
+	}
 	return len;
 }
 
@@ -5549,6 +5573,7 @@ static int remove_and_add_spares(mddev_t
 
 	ITERATE_RDEV(mddev,rdev,rtmp)
 		if (rdev->raid_disk >= 0 &&
+		    !mddev->external &&
 		    (test_bit(Faulty, &rdev->flags) ||
 		     ! test_bit(In_sync, &rdev->flags)) &&
 		    atomic_read(&rdev->nr_pending)==0) {
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
