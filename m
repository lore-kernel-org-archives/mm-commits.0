From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-for-file_update_time.patch removed from -mm tree
Date: Thu, 14 Feb 2008 21:31:18 -0800
Message-ID: <200802150531.m1F5VILR021765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbYBOFbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 00:31:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     r-o-bind-mounts: elevate write count for file_update_time
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-for-file_update_time.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r-o-bind-mounts: elevate write count for file_update_time
From: Dave Hansen <haveblue@us.ibm.com>

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/inode.c~r-o-bind-mounts-elevate-write-count-for-file_update_time fs/inode.c
--- a/fs/inode.c~r-o-bind-mounts-elevate-write-count-for-file_update_time
+++ a/fs/inode.c
@@ -1259,10 +1259,19 @@ void file_update_time(struct file *file)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct timespec now;
 	int sync_it = 0;
+	int err = 0;
 
 	if (IS_NOCMTIME(inode))
 		return;
-	if (IS_RDONLY(inode))
+	/*
+	 * Ideally, we want to guarantee that 'f_vfsmnt'
+	 * is non-NULL here.  But, NFS exports need to
+	 * be fixed up before we can do that.  So, check
+	 * it for now. - Dave Hansen
+	 */
+	if (file->f_vfsmnt)
+		err = mnt_want_write(file->f_vfsmnt);
+	if (err)
 		return;
 
 	now = current_fs_time(inode->i_sb);
@@ -1283,6 +1292,8 @@ void file_update_time(struct file *file)
 
 	if (sync_it)
 		mark_inode_dirty_sync(inode);
+	if (file->f_vfsmnt)
+		mnt_drop_write(file->f_vfsmnt);
 }
 
 EXPORT_SYMBOL(file_update_time);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
