From: akpm@linux-foundation.org
Subject: - fuse-fix-permission-checking-on-sticky-directories.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:03:32 -0700
Message-ID: <200710180703.l9I73Ws8031447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756332AbXJRH0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:26:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, jengelh@linux01.gwdg.de, mm-commits@vger.kernel.org


The patch titled
     fuse: fix permission checking on sticky directories
has been removed from the -mm tree.  Its filename was
     fuse-fix-permission-checking-on-sticky-directories.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: fix permission checking on sticky directories
From: Miklos Szeredi <mszeredi@suse.cz>

The VFS checks sticky bits on the parent directory even if the filesystem
defines it's own ->permission().  In some situations (sshfs, mountlo, etc) the
user does have permission to delete a file even if the attribute based
checking would not allow it.

So work around this by storing the permission bits separately and returning
them in stat(), but cutting the permission bits off from inode->i_mode.

This is slightly hackish, but it's probably not worth it to add new
infrastructure in VFS and a slight performance penalty for all filesystems,
just for the sake of fuse.

[Jan Engelhardt] cosmetic fixes
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c    |    4 +++-
 fs/fuse/fuse_i.h |    4 ++++
 fs/fuse/inode.c  |   12 +++++++++++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff -puN fs/fuse/dir.c~fuse-fix-permission-checking-on-sticky-directories fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-permission-checking-on-sticky-directories
+++ a/fs/fuse/dir.c
@@ -1054,8 +1054,10 @@ static int fuse_getattr(struct vfsmount 
 	if (fi->i_time < get_jiffies_64())
 		err = fuse_do_getattr(inode);
 
-	if (!err)
+	if (!err) {
 		generic_fillattr(inode, stat);
+		stat->mode = fi->orig_i_mode;
+	}
 
 	return err;
 }
diff -puN fs/fuse/fuse_i.h~fuse-fix-permission-checking-on-sticky-directories fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-fix-permission-checking-on-sticky-directories
+++ a/fs/fuse/fuse_i.h
@@ -63,6 +63,10 @@ struct fuse_inode {
 
 	/** Time in jiffies until the file attributes are valid */
 	u64 i_time;
+
+	/** The sticky bit in inode->i_mode may have been removed, so
+	    preserve the original mode */
+	mode_t orig_i_mode;
 };
 
 /** FUSE specific file data */
diff -puN fs/fuse/inode.c~fuse-fix-permission-checking-on-sticky-directories fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-permission-checking-on-sticky-directories
+++ a/fs/fuse/inode.c
@@ -120,10 +120,11 @@ static void fuse_truncate(struct address
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	loff_t oldsize;
 
 	inode->i_ino     = attr->ino;
-	inode->i_mode    = (inode->i_mode & S_IFMT) + (attr->mode & 07777);
+	inode->i_mode    = (inode->i_mode & S_IFMT) | (attr->mode & 07777);
 	inode->i_nlink   = attr->nlink;
 	inode->i_uid     = attr->uid;
 	inode->i_gid     = attr->gid;
@@ -135,6 +136,15 @@ void fuse_change_attributes(struct inode
 	inode->i_ctime.tv_sec   = attr->ctime;
 	inode->i_ctime.tv_nsec  = attr->ctimensec;
 
+	/*
+	 * Don't set the sticky bit in i_mode, unless we want the VFS
+	 * to check permissions.  This prevents failures due to the
+	 * check in may_delete().
+	 */
+	fi->orig_i_mode = inode->i_mode;
+	if (!(fc->flags & FUSE_DEFAULT_PERMISSIONS))
+		inode->i_mode &= ~S_ISVTX;
+
 	spin_lock(&fc->lock);
 	oldsize = inode->i_size;
 	i_size_write(inode, attr->size);
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
