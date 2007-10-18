From: akpm@linux-foundation.org
Subject: - fix-execute-checking-in-permission.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:04 -0700
Message-ID: <200710180656.l9I6u4HX030672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36101 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757491AbXJRHdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:33:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix execute checking in permission()
has been removed from the -mm tree.  Its filename was
     fix-execute-checking-in-permission.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 24 insertions(+), 12 deletions(-)

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

origin.patch
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
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
fuse-fix-allowing-operations.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
fuse-clean-up-open-file-passing-in-setattr.patch
vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
fuse-improve-utimes-support.patch
fuse-add-atomic-opentruncate-support.patch
fuse-support-bsd-locking-semantics.patch
fuse-add-list-of-writable-files-to-fuse_inode.patch
fuse-add-helper-for-asynchronous-writes.patch
fuse-add-support-for-mandatory-locking.patch
fuse-add-blksize-field-to-fuse_attr.patch
