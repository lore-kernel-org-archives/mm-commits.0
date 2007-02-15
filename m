From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:02:54 -0800
Message-ID: <200702150502.l1F52sCl020378@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35027 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbXBOFM3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:12:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk


The patch titled
     r/o bind mounts: elevate write count for do_sys_utime() and touch_atime()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: elevate write count for do_sys_utime() and touch_atime()
From: Dave Hansen <hansendc@us.ibm.com>

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/inode.c~r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime fs/inode.c
--- a/fs/inode.c~r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime
+++ a/fs/inode.c
@@ -1163,22 +1163,23 @@ void touch_atime(struct vfsmount *mnt, s
 	struct inode *inode = dentry->d_inode;
 	struct timespec now;
 
-	if (inode->i_flags & S_NOATIME)
+	if (mnt && mnt_want_write(mnt))
 		return;
+	if (inode->i_flags & S_NOATIME)
+		goto out;
 	if (IS_NOATIME(inode))
-		return;
+		goto out;
 	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
-		return;
+		goto out;
 
 	/*
 	 * We may have a NULL vfsmount when coming from NFSD
 	 */
 	if (mnt) {
 		if (mnt->mnt_flags & MNT_NOATIME)
-			return;
+			goto out;
 		if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
-			return;
-
+			goto out;
 		if (mnt->mnt_flags & MNT_RELATIME) {
 			/*
 			 * With relative atime, only update atime if the
@@ -1189,16 +1190,19 @@ void touch_atime(struct vfsmount *mnt, s
 						&inode->i_atime) < 0 &&
 			    timespec_compare(&inode->i_ctime,
 						&inode->i_atime) < 0)
-				return;
+				goto out;
 		}
 	}
 
 	now = current_fs_time(inode->i_sb);
 	if (timespec_equal(&inode->i_atime, &now))
-		return;
+		goto out;
 
 	inode->i_atime = now;
 	mark_inode_dirty_sync(inode);
+out:
+	if (mnt)
+		mnt_drop_write(mnt);
 }
 EXPORT_SYMBOL(touch_atime);
 
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-document-nlink-function.patch
r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-ext3-remove-extra-is_rdonly-check.patch
r-o-bind-mounts-ext4-remove-extra-is_rdonly-check.patch
r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-mount_is_safe-add-comment.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-sb.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-remove-is_rdonly-from-permission.patch
r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch
