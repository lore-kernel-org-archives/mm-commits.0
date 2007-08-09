From: akpm@linux-foundation.org
Subject: + fix-execute-checking-in-permission.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:32:23 -0700
Message-ID: <200708092132.l79LWN8f020583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755149AbXHIVdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     fix execute checking in permission()
has been added to the -mm tree.  Its filename is
     fix-execute-checking-in-permission.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix execute checking in permission()
From: Miklos Szeredi <mszeredi@suse.cz>

permission() checks that MAY_EXEC is only allowed on regular files if at least
one execute bit is set in the file mode.

generic_permission() already ensures this, so the extra check in permission()
is superfluous.

If the filesystem defines it's own ->permission() the check may still be
needed.  In this case move it after ->permission().  This is needed because
filesystems such as FUSE may need to refresh the inode attributes before
checking permissions.

This check should be moved inside ->permission(), but that's another story.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff -puN fs/namei.c~fix-execute-checking-in-permission fs/namei.c
--- a/fs/namei.c~fix-execute-checking-in-permission
+++ a/fs/namei.c
@@ -227,10 +227,10 @@ int generic_permission(struct inode *ino
 
 int permission(struct inode *inode, int mask, struct nameidata *nd)
 {
-	umode_t mode = inode->i_mode;
 	int retval, submask;
 
 	if (mask & MAY_WRITE) {
+		umode_t mode = inode->i_mode;
 
 		/*
 		 * Nobody gets write access to a read-only fs.
@@ -246,22 +246,34 @@ int permission(struct inode *inode, int 
 			return -EACCES;
 	}
 
-
-	/*
-	 * MAY_EXEC on regular files requires special handling: We override
-	 * filesystem execute permissions if the mode bits aren't set or
-	 * the fs is mounted with the "noexec" flag.
-	 */
-	if ((mask & MAY_EXEC) && S_ISREG(mode) && (!(mode & S_IXUGO) ||
-			(nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))))
-		return -EACCES;
+	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode)) {
+		/*
+		 * MAY_EXEC on regular files is denied if the fs is mounted
+		 * with the "noexec" flag.
+		 */
+		if (nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))
+			return -EACCES;
+	}
 
 	/* Ordinary permission routines do not understand MAY_APPEND. */
 	submask = mask & ~MAY_APPEND;
-	if (inode->i_op && inode->i_op->permission)
+	if (inode->i_op && inode->i_op->permission) {
 		retval = inode->i_op->permission(inode, submask, nd);
-	else
+		if (!retval) {
+			/*
+			 * Exec permission on a regular file is denied if none
+			 * of the execute bits are set.
+			 *
+			 * This check should be done by the ->permission()
+			 * method.
+			 */
+			if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
+			    !(inode->i_mode & S_IXUGO))
+				return -EACCES;
+		}
+	} else {
 		retval = generic_permission(inode, submask, NULL);
+	}
 	if (retval)
 		return retval;
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-convert-to-new-aops.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
vfs-check-nanoseconds-in-utimensat.patch
fix-execute-checking-in-permission.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
fuse-update-backing_dev_info-congestion-state.patch
fuse-fix-reserved-request-wake-up.patch
fuse-add-reference-counting-to-fuse_file.patch
fuse-truncate-on-spontaneous-size-change.patch
fuse-fix-page-invalidation.patch
fuse-set-i_nlink-to-sane-value-after-mount.patch
fuse-refresh-stale-attributes-in-fuse_permission.patch
fuse-fix-permission-checking-on-sticky-directories.patch
fuse-fix-permission-checking-on-sticky-directories-fix.patch
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
fuse-fix-setting-i_mode-bits.patch
fuse-clean-up-execute-permission-checking.patch
clean-out-unused-code-in-dentry-pruning.patch
uml-remove-unnecessary-hostfs_getattr.patch
fix-warnings-in-revoked_inodec.patch
