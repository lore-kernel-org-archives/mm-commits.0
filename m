From: akpm@linux-foundation.org
Subject: + md-sync_action-in-sysfs-returns-wrong-value-for-readonly-arrays.patch added to -mm tree
Date: Sun, 14 Oct 2007 22:00:55 -0700
Message-ID: <200710150500.l9F50tC1018233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbXJOFA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 01:00:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: 'sync_action' in sysfs returns wrong value for readonly arrays
has been added to the -mm tree.  Its filename is
     md-sync_action-in-sysfs-returns-wrong-value-for-readonly-arrays.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: 'sync_action' in sysfs returns wrong value for readonly arrays
From: NeilBrown <neilb@suse.de>

When an array is started read-only, MD_RECOVERY_NEEDED can be set but no
recovery will be running.  This causes 'sync_action' to report the wrong
value.

We could remove the test for MD_RECOVERY_NEEDED, but doing so would leave a
small gap after requesting a sync action, where 'sync_action' would still
report the old value.

So make sure that for a read-only array, 'sync_action' always returns 'idle'.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-sync_action-in-sysfs-returns-wrong-value-for-readonly-arrays drivers/md/md.c
--- a/drivers/md/md.c~md-sync_action-in-sysfs-returns-wrong-value-for-readonly-arrays
+++ a/drivers/md/md.c
@@ -2714,7 +2714,7 @@ action_show(mddev_t *mddev, char *page)
 {
 	char *type = "idle";
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-	    test_bit(MD_RECOVERY_NEEDED, &mddev->recovery)) {
+	    (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))) {
 		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 			type = "reshape";
 		else if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
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
