From: akpm@linux-foundation.org
Subject: + affs-implement-drop_inode.patch added to -mm tree
Date: Wed, 14 Feb 2007 22:45:06 -0800
Message-ID: <200702150645.l1F6j6JT022185@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36706 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964921AbXBOGpQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 01:45:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, zippel@linux-m68k.org


The patch titled
     affs: implement ->drop_inode
has been added to the -mm tree.  Its filename is
     affs-implement-drop_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: affs: implement ->drop_inode
From: Christoph Hellwig <hch@lst.de>

affs wants to truncate the inode when the last user goes away, currently it
does that through a potentially racy i_count check in ->put_inode.  But we
already have a method that's called just after the we dropped the last
reference, ->drop_inode.  This patch implements affs_drop_inode to take
advantage of this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h  |    1 +
 fs/affs/inode.c |   17 +++++++++++------
 fs/affs/super.c |    1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

diff -puN fs/affs/affs.h~affs-implement-drop_inode fs/affs/affs.h
--- a/fs/affs/affs.h~affs-implement-drop_inode
+++ a/fs/affs/affs.h
@@ -171,6 +171,7 @@ extern unsigned long		 affs_parent_ino(s
 extern struct inode		*affs_new_inode(struct inode *dir);
 extern int			 affs_notify_change(struct dentry *dentry, struct iattr *attr);
 extern void			 affs_put_inode(struct inode *inode);
+extern void			 affs_drop_inode(struct inode *inode);
 extern void			 affs_delete_inode(struct inode *inode);
 extern void			 affs_clear_inode(struct inode *inode);
 extern void			 affs_read_inode(struct inode *inode);
diff -puN fs/affs/inode.c~affs-implement-drop_inode fs/affs/inode.c
--- a/fs/affs/inode.c~affs-implement-drop_inode
+++ a/fs/affs/inode.c
@@ -243,12 +243,17 @@ affs_put_inode(struct inode *inode)
 {
 	pr_debug("AFFS: put_inode(ino=%lu, nlink=%u)\n", inode->i_ino, inode->i_nlink);
 	affs_free_prealloc(inode);
-	if (atomic_read(&inode->i_count) == 1) {
-		mutex_lock(&inode->i_mutex);
-		if (inode->i_size != AFFS_I(inode)->mmu_private)
-			affs_truncate(inode);
-		mutex_unlock(&inode->i_mutex);
-	}
+}
+
+void
+affs_drop_inode(struct inode *inode)
+{
+	mutex_lock(&inode->i_mutex);
+	if (inode->i_size != AFFS_I(inode)->mmu_private)
+		affs_truncate(inode);
+	mutex_unlock(&inode->i_mutex);
+
+	generic_drop_inode(inode);
 }
 
 void
diff -puN fs/affs/super.c~affs-implement-drop_inode fs/affs/super.c
--- a/fs/affs/super.c~affs-implement-drop_inode
+++ a/fs/affs/super.c
@@ -118,6 +118,7 @@ static const struct super_operations aff
 	.read_inode	= affs_read_inode,
 	.write_inode	= affs_write_inode,
 	.put_inode	= affs_put_inode,
+	.drop_inode	= affs_drop_inode,
 	.delete_inode	= affs_delete_inode,
 	.clear_inode	= affs_clear_inode,
 	.put_super	= affs_put_super,
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
affs-implement-drop_inode.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
r-o-bind-mounts-document-nlink-function.patch
r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions-fix.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack.patch
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
