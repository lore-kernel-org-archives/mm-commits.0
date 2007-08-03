From: akpm@linux-foundation.org
Subject: + fuse-fix-permission-checking-on-sticky-directories.patch added to -mm tree
Date: Fri, 03 Aug 2007 15:55:06 -0700
Message-ID: <200708032255.l73Mt6Y1031782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49086 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763505AbXHCWzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 18:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix permission checking on sticky directories
has been added to the -mm tree.  Its filename is
     fuse-fix-permission-checking-on-sticky-directories.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c    |    4 +++-
 fs/fuse/fuse_i.h |    4 ++++
 fs/fuse/inode.c  |   10 +++++++++-
 3 files changed, 16 insertions(+), 2 deletions(-)

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
+	/** The sticky bit in inode->i_mode may have been remved, so
+	    preserve the original mode */
+	mode_t orig_i_mode;
 };
 
 /** FUSE specific file data */
diff -puN fs/fuse/inode.c~fuse-fix-permission-checking-on-sticky-directories fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-permission-checking-on-sticky-directories
+++ a/fs/fuse/inode.c
@@ -120,10 +120,18 @@ static void fuse_truncate(struct address
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	loff_t oldsize;
 
 	inode->i_ino     = attr->ino;
-	inode->i_mode    = (inode->i_mode & S_IFMT) + (attr->mode & 07777);
+	fi->orig_i_mode  = (inode->i_mode & S_IFMT) + (attr->mode & 07777);
+	/*
+	 * Don't set the mode bits in i_mode, unless we want the VFS
+	 * to check permissions.  This prevents failures due to the
+	 * sticky bit check in may_delete().
+	 */
+	if (fc->flags & FUSE_DEFAULT_PERMISSIONS)
+		inode->i_mode = fi->orig_i_mode;
 	inode->i_nlink   = attr->nlink;
 	inode->i_uid     = attr->uid;
 	inode->i_gid     = attr->gid;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-convert-to-new-aops.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
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
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
