From: akpm@linux-foundation.org
Subject: + md-fix-two-raid10-bugs.patch added to -mm tree
Date: Mon, 11 Jun 2007 18:15:06 -0700
Message-ID: <200706120115.l5C1F64A001072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756047AbXFLBP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 21:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, stable@kernel.org


The patch titled
     md: fix two raid10 bugs
has been added to the -mm tree.  Its filename is
     md-fix-two-raid10-bugs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: fix two raid10 bugs
From: NeilBrown <neilb@suse.de>

1/ When resyncing a degraded raid10 which has more than 2 copies of each block,
  garbage can get synced on top of good data.

2/ We round the wrong way in part of the device size calculation, which
  can cause confusion.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid10.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/md/raid10.c~md-fix-two-raid10-bugs drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-fix-two-raid10-bugs
+++ a/drivers/md/raid10.c
@@ -1867,6 +1867,7 @@ static sector_t sync_request(mddev_t *md
 			int d = r10_bio->devs[i].devnum;
 			bio = r10_bio->devs[i].bio;
 			bio->bi_end_io = NULL;
+			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 			if (conf->mirrors[d].rdev == NULL ||
 			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
 				continue;
@@ -2037,6 +2038,11 @@ static int run(mddev_t *mddev)
 	/* 'size' is now the number of chunks in the array */
 	/* calculate "used chunks per device" in 'stride' */
 	stride = size * conf->copies;
+
+	/* We need to round up when dividing by raid_disks to
+	 * get the stride size.
+	 */
+	stride += conf->raid_disks - 1;
 	sector_div(stride, conf->raid_disks);
 	mddev->size = stride  << (conf->chunk_shift-1);
 
_

Patches currently in -mm which might be from neilb@suse.de are

md-fix-two-raid10-bugs.patch
git-md-accel.patch
block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
fix-read-truncate-race.patch
make-sure-readv-stops-reading-when-it-hits-end-of-file.patch
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
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
