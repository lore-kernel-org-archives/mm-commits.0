From: akpm@linux-foundation.org
Subject: - md-correctly-update-sysfs-when-a-raid1-is-reshaped.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:47 -0700
Message-ID: <200708242056.l7OKul0f014097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760181AbXHXVIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: correctly update sysfs when a raid1 is reshaped
has been removed from the -mm tree.  Its filename was
     md-correctly-update-sysfs-when-a-raid1-is-reshaped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: correctly update sysfs when a raid1 is reshaped
From: NeilBrown <neilb@suse.de>

When a raid1 array is reshaped (number of drives changed), the list of devices
is compacted, so that slots for missing devices are filled with working
devices from later slots.  This requires the "rd%d" symlinks in sysfs to be
updated.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid1.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff -puN drivers/md/raid1.c~md-correctly-update-sysfs-when-a-raid1-is-reshaped drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-correctly-update-sysfs-when-a-raid1-is-reshaped
+++ a/drivers/md/raid1.c
@@ -2154,11 +2154,25 @@ static int raid1_reshape(mddev_t *mddev)
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
 
-	for (d=d2=0; d < conf->raid_disks; d++)
-		if (conf->mirrors[d].rdev) {
-			conf->mirrors[d].rdev->raid_disk = d2;
-			newmirrors[d2++].rdev = conf->mirrors[d].rdev;
+	for (d = d2 = 0; d < conf->raid_disks; d++) {
+		mdk_rdev_t *rdev = conf->mirrors[d].rdev;
+		if (rdev && rdev->raid_disk != d2) {
+			char nm[20];
+			sprintf(nm, "rd%d", rdev->raid_disk);
+			sysfs_remove_link(&mddev->kobj, nm);
+			rdev->raid_disk = d2;
+			sprintf(nm, "rd%d", rdev->raid_disk);
+			sysfs_remove_link(&mddev->kobj, nm);
+			if (sysfs_create_link(&mddev->kobj,
+					      &rdev->kobj, nm))
+				printk(KERN_WARNING
+				       "md/raid1: cannot register "
+				       "%s for %s\n",
+				       nm, mdname(mddev));
 		}
+		if (rdev)
+			newmirrors[d2++].rdev = rdev;
+	}
 	kfree(conf->mirrors);
 	conf->mirrors = newmirrors;
 	kfree(conf->poolinfo);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
git-nfsd.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
fs-nfsd-exportc-make-3-functions-static.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
