From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-r-o-bind-mounts-stub-functions.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:32:48 -0800
Message-ID: <200702150832.l1F8Wm8j024576@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39485 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965288AbXBOIdt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: r/o bind mounts: stub functions
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-r-o-bind-mounts-stub-functions.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: r/o bind mounts: stub functions
From: Dave Hansen <hansendc@us.ibm.com>

This patch adds two function mnt_want_write() and mnt_drop_write().  These are
used like a lock pair around and fs operations that might cause a write to the
filesystem.

Before these can become useful, we must first cover each place in the VFS
where writes are performed with a want/drop pair.  When that is complete, we
can actually introduce code that will safely check the counts before allowing
r/w<->r/o transitions to occur.

Note that we put the linux/fs.h #include as far down in mount.h as possible. 
This is to keep the mount.h->fs.h-> sched.h->mount.h include dependency from
biting us.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |   13 +++++++++++++
 include/linux/mount.h |   13 +++++++++++++
 2 files changed, 26 insertions(+)

diff -puN fs/namespace.c~r-o-bind-mounts-r-o-bind-mounts-stub-functions fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-r-o-bind-mounts-stub-functions
+++ a/fs/namespace.c
@@ -76,6 +76,19 @@ struct vfsmount *alloc_vfsmnt(const char
 	return mnt;
 }
 
+int mnt_want_write(struct vfsmount *mnt)
+{
+	if (__mnt_is_readonly(mnt));
+		return -EROFS;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mnt_want_write);
+
+void mnt_drop_write(struct vfsmount *mnt)
+{
+}
+EXPORT_SYMBOL_GPL(mnt_drop_write);
+
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
diff -puN include/linux/mount.h~r-o-bind-mounts-r-o-bind-mounts-stub-functions include/linux/mount.h
--- a/include/linux/mount.h~r-o-bind-mounts-r-o-bind-mounts-stub-functions
+++ a/include/linux/mount.h
@@ -70,6 +70,19 @@ static inline struct vfsmount *mntget(st
 	return mnt;
 }
 
+#include <linux/fs.h>
+
+/*
+ * This shouldn't be used directly ouside of the VFS,
+ * use mnt_want/drop_write() instead.
+ */
+static inline int __mnt_is_readonly(struct vfsmount *mnt)
+{
+	return (mnt->mnt_sb->s_flags & MS_RDONLY);
+}
+
+extern int mnt_want_write(struct vfsmount *mnt);
+extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

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
