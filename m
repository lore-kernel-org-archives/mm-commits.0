From: akpm@osdl.org
Subject: - fsstack-introduce-fsstack_copy_attrinode_.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:21 -0800
Message-ID: <200612082001.kB8K1L0v001839@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426323AbWLHUFb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, bunk@stusta.de, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fsstack: Introduce fsstack_copy_{attr,inode}_*
has been removed from the -mm tree.  Its filename was
     fsstack-introduce-fsstack_copy_attrinode_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fsstack: Introduce fsstack_copy_{attr,inode}_*
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Introduce several fsstack_copy_* functions which allow stackable filesystems
(such as eCryptfs and Unionfs) to easily copy over (currently only) inode
attributes.  This prevents code duplication and allows for code reuse.

[akpm@osdl.org: Remove unneeded wrapper]
[bunk@stusta.de: fs/stack.c should #include <linux/fs_stack.h>]
Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/Makefile              |    3 +-
 fs/stack.c               |   40 +++++++++++++++++++++++++++++++++++++
 include/linux/fs_stack.h |   31 ++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 1 deletion(-)

diff -puN fs/Makefile~fsstack-introduce-fsstack_copy_attrinode_ fs/Makefile
--- a/fs/Makefile~fsstack-introduce-fsstack_copy_attrinode_
+++ a/fs/Makefile
@@ -10,7 +10,8 @@ obj-y :=	open.o read_write.o file_table.
 		ioctl.o readdir.o select.o fifo.o locks.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
-		pnode.o drop_caches.o splice.o sync.o utimes.o
+		pnode.o drop_caches.o splice.o sync.o utimes.o \
+		stack.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff -puN /dev/null fs/stack.c
--- /dev/null
+++ a/fs/stack.c
@@ -0,0 +1,40 @@
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/fs_stack.h>
+
+/* does _NOT_ require i_mutex to be held.
+ *
+ * This function cannot be inlined since i_size_{read,write} is rather
+ * heavy-weight on 32-bit systems
+ */
+void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
+{
+	i_size_write(dst, i_size_read((struct inode *)src));
+	dst->i_blocks = src->i_blocks;
+}
+EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
+
+/* copy all attributes; get_nlinks is optional way to override the i_nlink
+ * copying
+ */
+void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
+				int (*get_nlinks)(struct inode *))
+{
+	if (!get_nlinks)
+		dest->i_nlink = src->i_nlink;
+	else
+		dest->i_nlink = (*get_nlinks)(dest);
+
+	dest->i_mode = src->i_mode;
+	dest->i_uid = src->i_uid;
+	dest->i_gid = src->i_gid;
+	dest->i_rdev = src->i_rdev;
+	dest->i_atime = src->i_atime;
+	dest->i_mtime = src->i_mtime;
+	dest->i_ctime = src->i_ctime;
+	dest->i_blkbits = src->i_blkbits;
+	dest->i_flags = src->i_flags;
+
+	fsstack_copy_inode_size(dest, src);
+}
+EXPORT_SYMBOL_GPL(fsstack_copy_attr_all);
diff -puN /dev/null include/linux/fs_stack.h
--- /dev/null
+++ a/include/linux/fs_stack.h
@@ -0,0 +1,31 @@
+#ifndef _LINUX_FS_STACK_H
+#define _LINUX_FS_STACK_H
+
+/* This file defines generic functions used primarily by stackable
+ * filesystems; none of these functions require i_mutex to be held.
+ */
+
+#include <linux/fs.h>
+
+/* externs for fs/stack.c */
+extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
+				int (*get_nlinks)(struct inode *));
+
+extern void fsstack_copy_inode_size(struct inode *dst, const struct inode *src);
+
+/* inlines */
+static inline void fsstack_copy_attr_atime(struct inode *dest,
+					   const struct inode *src)
+{
+	dest->i_atime = src->i_atime;
+}
+
+static inline void fsstack_copy_attr_times(struct inode *dest,
+					   const struct inode *src)
+{
+	dest->i_atime = src->i_atime;
+	dest->i_mtime = src->i_mtime;
+	dest->i_ctime = src->i_ctime;
+}
+
+#endif /* _LINUX_FS_STACK_H */
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

fsstack-introduce-fsstack_copy_attrinode_.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr.patch
struct-path-rename-reiserfss-struct-path.patch
struct-path-rename-dms-struct-path.patch
struct-path-move-struct-path-from-fs-nameic-into.patch
struct-path-make-ecryptfs-a-user-of-struct-path.patch
vfs-change-struct-file-to-use-struct-path.patch
sysfs-change-uses-of-f_dentry.patch
proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext4-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
fat-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
isofs-change-uses-of-f_dentry.patch
nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

