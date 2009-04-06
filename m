From: akpm@linux-foundation.org
Subject: [folded] nilfs2-super-block-operations-fix.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:35:18 -0700
Message-ID: <200904062235.n36MZIKh018066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756451AbZDFWhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2-super-block-operations-fix
has been removed from the -mm tree.  Its filename was
     nilfs2-super-block-operations-fix.patch

This patch was dropped because it was folded into nilfs2-super-block-operations.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2-super-block-operations-fix
From: Andrew Morton <akpm@linux-foundation.org>

Update for linux-next changes.

Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/nilfs2/super.c~nilfs2-super-block-operations-fix fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-super-block-operations-fix
+++ a/fs/nilfs2/super.c
@@ -1125,7 +1125,7 @@ nilfs_get_sb(struct file_system_type *fs
 	struct the_nilfs *nilfs = NULL;
 	int err, need_to_close = 1;
 
-	sd.bdev = open_bdev_excl(dev_name, flags, fs_type);
+	sd.bdev = open_bdev_exclusive(dev_name, flags, fs_type);
 	if (IS_ERR(sd.bdev))
 		return PTR_ERR(sd.bdev);
 
@@ -1190,9 +1190,9 @@ nilfs_get_sb(struct file_system_type *fs
 			  nilfs_set_bdev_super, &sd);
 		deactivate_super(s);
 		/*
-		 * Although deactivate_super() invokes close_bdev_excl() at
+		 * Although deactivate_super() invokes close_bdev_exclusive() at
 		 * kill_block_super().  Here, s is an existent mount; we need
-		 * one more close_bdev_excl() call.
+		 * one more close_bdev_exclusive() call.
 		 */
 		s = s2;
 		if (IS_ERR(s))
@@ -1219,20 +1219,20 @@ nilfs_get_sb(struct file_system_type *fs
 	up(&sd.bdev->bd_mount_sem);
 	put_nilfs(nilfs);
 	if (need_to_close)
-		close_bdev_excl(sd.bdev);
+		close_bdev_exclusive(sd.bdev, flags);
 	return simple_set_mnt(mnt, s);
 
  error_s:
 	up(&sd.bdev->bd_mount_sem);
 	if (nilfs)
 		put_nilfs(nilfs);
-	close_bdev_excl(sd.bdev);
+	close_bdev_exclusive(sd.bdev, flags);
 	return PTR_ERR(s);
 
  failed_unlock:
 	up(&sd.bdev->bd_mount_sem);
  failed:
-	close_bdev_excl(sd.bdev);
+	close_bdev_exclusive(sd.bdev, flags);
 
 	return err;
 
@@ -1244,7 +1244,7 @@ nilfs_get_sb(struct file_system_type *fs
 	up_write(&s->s_umount);
 	deactivate_super(s);
 	/*
-	 * deactivate_super() invokes close_bdev_excl().
+	 * deactivate_super() invokes close_bdev_exclusive().
 	 * We must finish all post-cleaning before this call;
 	 * put_nilfs() and unlocking bd_mount_sem need the block device.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-add-proc-controls-for-pdflush-threads.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
nilfs2-integrated-block-mapping.patch
nilfs2-super-block-operations.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

