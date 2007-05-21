From: akpm@linux-foundation.org
Subject: + md-fix-bug-with-linear-hot-add-and-elsewhere.patch added to -mm tree
Date: Sun, 20 May 2007 21:32:11 -0700
Message-ID: <200705210432.l4L4WAWR002417@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUEdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: fix bug with linear hot-add and elsewhere
has been added to the -mm tree.  Its filename is
     md-fix-bug-with-linear-hot-add-and-elsewhere.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: fix bug with linear hot-add and elsewhere
From: NeilBrown <neilb@suse.de>

Adding a drive to a linear array seems to have stopped working, due to changes
elsewhere in md, and insufficient ongoing testing...

So the patch to make linear hot-add work in the first place introduced a
subtle bug elsewhere that interracts poorly with older version of mdadm.

This fixes it all up.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/linear.c |   10 +++++-----
 drivers/md/md.c     |   20 ++++++++++++++------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff -puN drivers/md/linear.c~md-fix-bug-with-linear-hot-add-and-elsewhere drivers/md/linear.c
--- a/drivers/md/linear.c~md-fix-bug-with-linear-hot-add-and-elsewhere
+++ a/drivers/md/linear.c
@@ -139,8 +139,6 @@ static linear_conf_t *linear_conf(mddev_
 	if (!conf)
 		return NULL;
 
-	mddev->private = conf;
-
 	cnt = 0;
 	conf->array_size = 0;
 
@@ -232,7 +230,7 @@ static linear_conf_t *linear_conf(mddev_
 	 * First calculate the device offsets.
 	 */
 	conf->disks[0].offset = 0;
-	for (i=1; i<mddev->raid_disks; i++)
+	for (i = 1; i < raid_disks; i++)
 		conf->disks[i].offset =
 			conf->disks[i-1].offset +
 			conf->disks[i-1].size;
@@ -244,7 +242,7 @@ static linear_conf_t *linear_conf(mddev_
 	     curr_offset < conf->array_size;
 	     curr_offset += conf->hash_spacing) {
 
-		while (i < mddev->raid_disks-1 &&
+		while (i < raid_disks-1 &&
 		       curr_offset >= conf->disks[i+1].offset)
 			i++;
 
@@ -299,9 +297,11 @@ static int linear_add(mddev_t *mddev, md
 	 */
 	linear_conf_t *newconf;
 
-	if (rdev->raid_disk != mddev->raid_disks)
+	if (rdev->saved_raid_disk != mddev->raid_disks)
 		return -EINVAL;
 
+	rdev->raid_disk = rdev->saved_raid_disk;
+
 	newconf = linear_conf(mddev,mddev->raid_disks+1);
 
 	if (!newconf)
diff -puN drivers/md/md.c~md-fix-bug-with-linear-hot-add-and-elsewhere drivers/md/md.c
--- a/drivers/md/md.c~md-fix-bug-with-linear-hot-add-and-elsewhere
+++ a/drivers/md/md.c
@@ -1298,8 +1298,9 @@ static void super_1_sync(mddev_t *mddev,
 	ITERATE_RDEV(mddev,rdev2,tmp)
 		if (rdev2->desc_nr+1 > max_dev)
 			max_dev = rdev2->desc_nr+1;
-	
-	sb->max_dev = cpu_to_le32(max_dev);
+
+	if (max_dev > le32_to_cpu(sb->max_dev))
+		sb->max_dev = cpu_to_le32(max_dev);
 	for (i=0; i<max_dev;i++)
 		sb->dev_roles[i] = cpu_to_le16(0xfffe);
 	
@@ -1365,10 +1366,14 @@ static int bind_rdev_to_array(mdk_rdev_t
 	}
 	/* make sure rdev->size exceeds mddev->size */
 	if (rdev->size && (mddev->size == 0 || rdev->size < mddev->size)) {
-		if (mddev->pers)
-			/* Cannot change size, so fail */
-			return -ENOSPC;
-		else
+		if (mddev->pers) {
+			/* Cannot change size, so fail
+			 * If mddev->level <= 0, then we don't care
+			 * about aligning sizes (e.g. linear)
+			 */
+			if (mddev->level > 0)
+				return -ENOSPC;
+		} else
 			mddev->size = rdev->size;
 	}
 
@@ -2142,6 +2147,9 @@ static void analyze_sbs(mddev_t * mddev)
 			rdev->desc_nr = i++;
 			rdev->raid_disk = rdev->desc_nr;
 			set_bit(In_sync, &rdev->flags);
+		} else if (rdev->raid_disk >= mddev->raid_disks) {
+			rdev->raid_disk = -1;
+			clear_bit(In_sync, &rdev->flags);
 		}
 	}
 
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
