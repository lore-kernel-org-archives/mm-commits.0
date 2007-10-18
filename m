From: akpm@linux-foundation.org
Subject: - md-make-sure-read-errors-are-auto-corrected-during-a-check-resync-in-raid1.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:04 -0700
Message-ID: <200710180703.l9I734CG031401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761123AbXJRHPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: make sure read errors are auto-corrected during a 'check' resync in raid1
has been removed from the -mm tree.  Its filename was
     md-make-sure-read-errors-are-auto-corrected-during-a-check-resync-in-raid1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: make sure read errors are auto-corrected during a 'check' resync in raid1
From: NeilBrown <neilb@suse.de>

Whenever a read error is found, we should attempt to overwrite with correct
data to 'fix' it.

However when do a 'check' pass (which compares data blocks that are
successfully read, but doesn't normally overwrite) we don't do that.  We
should.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/md/raid1.c~md-make-sure-read-errors-are-auto-corrected-during-a-check-resync-in-raid1 drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-make-sure-read-errors-are-auto-corrected-during-a-check-resync-in-raid1
+++ a/drivers/md/raid1.c
@@ -1214,7 +1214,8 @@ static void sync_request_write(mddev_t *
 					j = 0;
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
-				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
+				if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
+					      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
 					sbio->bi_end_io = NULL;
 					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 				} else {
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
git-md-accel.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
