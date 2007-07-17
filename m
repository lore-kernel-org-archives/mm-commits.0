From: akpm@linux-foundation.org
Subject: - md-improve-message-about-invalid-superblock-during-autodetect.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:02 -0700
Message-ID: <200707172309.l6HN92AK012338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765189AbXGQXPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: improve message about invalid superblock during autodetect
has been removed from the -mm tree.  Its filename was
     md-improve-message-about-invalid-superblock-during-autodetect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5771,7 +5773,7 @@ static void autostart_arrays(int part)
 	for (i = 0; i < dev_cnt; i++) {
 		dev_t dev = detected_devices[i];
 
-		rdev = md_import_device(dev,0, 0);
+		rdev = md_import_device(dev,0, 90);
 		if (IS_ERR(rdev))
 			continue;
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
raid5-add-the-stripe_queue-object-for-tracking-raid.patch
raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2.patch
raid5-use-stripe_queues-to-prioritize-the-most.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
