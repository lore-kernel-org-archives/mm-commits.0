From: akpm@linux-foundation.org
Subject: - reiserfs-fix-up-lockdep-warnings.patch removed from -mm tree
Date: Thu, 18 Oct 2007 14:00:56 -0700
Message-ID: <200710182100.l9IL0uSM030841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758879AbXJRVB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, a.p.zijlstra@chello.nl, hch@lst.de, mason@suse.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix up lockdep warnings
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-up-lockdep-warnings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: reiserfs: fix up lockdep warnings
From: Jeff Mahoney <jeffm@suse.com>

Add I_MUTEX_XATTR annotations to the inode locking in the reiserfs xattr code.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <mason@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/xattr.c~reiserfs-fix-up-lockdep-warnings fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~reiserfs-fix-up-lockdep-warnings
+++ a/fs/reiserfs/xattr.c
@@ -484,7 +484,7 @@ reiserfs_xattr_set(struct inode *inode, 
 	/* Resize it so we're ok to write there */
 	newattrs.ia_size = buffer_size;
 	newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
-	mutex_lock(&xinode->i_mutex);
+	mutex_lock_nested(&xinode->i_mutex, I_MUTEX_XATTR);
 	err = notify_change(fp->f_path.dentry, &newattrs);
 	if (err)
 		goto out_filp;
@@ -1223,7 +1223,8 @@ int reiserfs_xattr_init(struct super_blo
 		if (!IS_ERR(dentry)) {
 			if (!(mount_flags & MS_RDONLY) && !dentry->d_inode) {
 				struct inode *inode = dentry->d_parent->d_inode;
-				mutex_lock(&inode->i_mutex);
+				mutex_lock_nested(&inode->i_mutex,
+				                  I_MUTEX_XATTR);
 				err = inode->i_op->mkdir(inode, dentry, 0700);
 				mutex_unlock(&inode->i_mutex);
 				if (err) {
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
reiserfs-fix-up-lockdep-warnings.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-dont-use-bug-when-panicking.patch
reiserfs-use-is_reusable-to-catch-corruption.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-fix-memset-byte-count-during-resize.patch
reiserfs-ignore-on-disk-s_bmap_nr-value.patch
reiserfs-ignore-on-disk-s_bmap_nr-value-checkpatch-fixes.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
reiserfs-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
