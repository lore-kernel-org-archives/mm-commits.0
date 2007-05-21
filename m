From: akpm@linux-foundation.org
Subject: + md-improve-message-about-invalid-superblock-during-autodetect.patch added to -mm tree
Date: Sun, 20 May 2007 21:33:20 -0700
Message-ID: <200705210433.l4L4XJNT002442@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbXEUEed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:34:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: improve message about invalid superblock during autodetect
has been added to the -mm tree.  Its filename is
     md-improve-message-about-invalid-superblock-during-autodetect.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: improve message about invalid superblock during autodetect
From: NeilBrown <neilb@suse.de>

People try to use raid auto-detect with version-1 superblocks (which is not
supported) and get confused when they are told they have an invalid
superblock.

So be more explicit, and say it it is not a valid v0.90 superblock.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/md/md.c~md-improve-message-about-invalid-superblock-during-autodetect drivers/md/md.c
--- a/drivers/md/md.c~md-improve-message-about-invalid-superblock-during-autodetect
+++ a/drivers/md/md.c
@@ -2073,9 +2073,11 @@ static mdk_rdev_t *md_import_device(dev_
 		err = super_types[super_format].
 			load_super(rdev, NULL, super_minor);
 		if (err == -EINVAL) {
-			printk(KERN_WARNING 
-				"md: %s has invalid sb, not importing!\n",
-				bdevname(rdev->bdev,b));
+			printk(KERN_WARNING
+				"md: %s does not have a valid v%d.%d "
+			       "superblock, not importing!\n",
+				bdevname(rdev->bdev,b),
+			       super_format, super_minor);
 			goto abort_free;
 		}
 		if (err < 0) {
@@ -5772,7 +5774,7 @@ static void autostart_arrays(int part)
 	for (i = 0; i < dev_cnt; i++) {
 		dev_t dev = detected_devices[i];
 
-		rdev = md_import_device(dev,0, 0);
+		rdev = md_import_device(dev,0, 90);
 		if (IS_ERR(rdev))
 			continue;
 
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
