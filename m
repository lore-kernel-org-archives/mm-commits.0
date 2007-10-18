From: akpm@linux-foundation.org
Subject: - md-sync_action-in-sysfs-returns-wrong-value-for-readonly-arrays.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:02:59 -0700
Message-ID: <200710180702.l9I72xtG031320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52318 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760067AbXJRHPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: 'sync_action' in sysfs returns wrong value for readonly arrays
has been removed from the -mm tree.  Its filename was
     md-sync_action-in-sysfs-returns-wrong-value-for-readonly-arrays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
