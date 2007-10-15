From: akpm@linux-foundation.org
Subject: + md-make-sure-read-errors-are-auto-corrected-during-a-check-resync-in-raid1.patch added to -mm tree
Date: Sun, 14 Oct 2007 22:00:58 -0700
Message-ID: <200710150500.l9F50wYk018239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbXJOFBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 01:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: make sure read errors are auto-corrected during a 'check' resync in raid1
has been added to the -mm tree.  Its filename is
     md-make-sure-read-errors-are-auto-corrected-during-a-check-resync-in-raid1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-nfsd.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
shrink_dcache_sb-speedup.patch
menuconfig-transform-network-filesystems-menu.patch
fs-nfsd-exportc-make-3-functions-static.patch
md-software-raid-autodetect-dev-list-not-array.patch
bitmaph-remove-dead-artifacts.patch
md-fix-a-bug-in-some-never-used-code.patch
md-sync_action-in-sysfs-returns-wrong-value-for-readonly-arrays.patch
md-expose-the-degraded-status-of-an-assembled-array-through-sysfs.patch
md-make-sure-read-errors-are-auto-corrected-during-a-check-resync-in-raid1.patch
md-fix-type-that-is-stopping-raid5-grow-from-working.patch
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
xfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
