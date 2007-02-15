From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:33:37 -0800
Message-ID: <200702150833.l1F8XbV2024652@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39784 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965277AbXBOInM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:43:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate write count for do_sys_utime() and touch_atime()
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch

This patch was dropped because it had testing failures

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

r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-remove-is_rdonly-from-permission.patch
r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch
