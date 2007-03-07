From: akpm@linux-foundation.org
Subject: + add-an-anonymous-inode-source.patch added to -mm tree
Date: Tue, 06 Mar 2007 16:58:04 -0800
Message-ID: <200703070058.l270w56E014828@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40679 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161079AbXCGA6M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 19:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org


The patch titled
     add an anonymous inode source
has been added to the -mm tree.  Its filename is
     add-an-anonymous-inode-source.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add an anonymous inode source
From: Davide Libenzi <davidel@xmailserver.org>

Add an anonymous inode source, to be used for files that need and inode
only in order to create a file*.  We do not care of having an inode for
each file, and we do not even care of having different names in the
associated dentries (dentry names will be same for classes of file*).  This
allow code reuse, and will be used by epoll, signalfd and timerfd (and
whatever else there'll be).

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Makefile                 |    2 
 fs/anon_inodes.c            |  205 ++++++++++++++++++++++++++++++++++
 include/linux/anon_inodes.h |   15 ++
 3 files changed, 221 insertions(+), 1 deletion(-)

diff -puN fs/Makefile~add-an-anonymous-inode-source fs/Makefile
--- a/fs/Makefile~add-an-anonymous-inode-source
+++ a/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o
+		stack.o anon_inodes.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff -puN /dev/null fs/anon_inodes.c
--- /dev/null
+++ a/fs/anon_inodes.c
@@ -0,0 +1,205 @@
+/*
+ *  fs/anon_inodes.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/anon_inodes.h>
+
+#include <asm/uaccess.h>
+
+
+
+#define AINOFS_MAGIC 0x09041934
+
+
+static int ainofs_delete_dentry(struct dentry *dentry);
+static struct inode *aino_getinode(void);
+static struct inode *aino_mkinode(void);
+static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
+			     const char *dev_name, void *data, struct vfsmount *mnt);
+
+
+
+static struct vfsmount *aino_mnt __read_mostly;
+static struct inode *aino_inode;
+static struct file_operations aino_fops = { };
+static struct file_system_type aino_fs_type = {
+	.name		= "ainofs",
+	.get_sb		= ainofs_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+static struct dentry_operations ainofs_dentry_operations = {
+	.d_delete	= ainofs_delete_dentry,
+};
+
+
+
+int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
+	       char const *name, const struct file_operations *fops, void *priv)
+{
+	struct qstr this;
+	struct dentry *dentry;
+	struct inode *inode;
+	struct file *file;
+	int error, fd;
+
+	error = -ENFILE;
+	file = get_empty_filp();
+	if (!file)
+		goto eexit_1;
+
+	inode = aino_getinode();
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
+		goto eexit_2;
+	}
+
+	error = get_unused_fd();
+	if (error < 0)
+		goto eexit_3;
+	fd = error;
+
+	/*
+	 * Link the inode to a directory entry by creating a unique name
+	 * using the inode sequence number.
+	 */
+	error = -ENOMEM;
+	this.name = name;
+	this.len = strlen(name);
+	this.hash = 0;
+	dentry = d_alloc(aino_mnt->mnt_sb->s_root, &this);
+	if (!dentry)
+		goto eexit_4;
+	dentry->d_op = &ainofs_dentry_operations;
+	/* Do not publish this dentry inside the global dentry hash table */
+	dentry->d_flags &= ~DCACHE_UNHASHED;
+	d_instantiate(dentry, inode);
+
+	file->f_path.mnt = mntget(aino_mnt);
+	file->f_path.dentry = dentry;
+	file->f_mapping = inode->i_mapping;
+
+	file->f_pos = 0;
+	file->f_flags = O_RDONLY;
+	file->f_op = fops;
+	file->f_mode = FMODE_READ;
+	file->f_version = 0;
+	file->private_data = priv;
+
+	fd_install(fd, file);
+
+	*pfd = fd;
+	*pinode = inode;
+	*pfile = file;
+	return 0;
+
+eexit_4:
+	put_unused_fd(fd);
+eexit_3:
+	iput(inode);
+eexit_2:
+	put_filp(file);
+eexit_1:
+	return error;
+}
+
+
+static int ainofs_delete_dentry(struct dentry *dentry)
+{
+	/*
+	 * We faked vfs to believe the dentry was hashed when we created it.
+	 * Now we restore the flag so that dput() will work correctly.
+	 */
+	dentry->d_flags |= DCACHE_UNHASHED;
+	return 1;
+}
+
+
+static struct inode *aino_getinode(void)
+{
+	return igrab(aino_inode);
+}
+
+
+/*
+ * A single inode exist for all aino files. On the contrary of pipes,
+ * aino inodes has no per-instance data associated, so we can avoid
+ * the allocation of multiple of them.
+ */
+static struct inode *aino_mkinode(void)
+{
+	int error = -ENOMEM;
+	struct inode *inode = new_inode(aino_mnt->mnt_sb);
+
+	if (!inode)
+		goto eexit_1;
+
+	inode->i_fop = &aino_fops;
+
+	/*
+	 * Mark the inode dirty from the very beginning,
+	 * that way it will never be moved to the dirty
+	 * list because mark_inode_dirty() will think
+	 * that it already _is_ on the dirty list.
+	 */
+	inode->i_state = I_DIRTY;
+	inode->i_mode = S_IRUSR | S_IWUSR;
+	inode->i_uid = current->fsuid;
+	inode->i_gid = current->fsgid;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	return inode;
+
+eexit_1:
+	return ERR_PTR(error);
+}
+
+
+static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
+			     const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "aino:", NULL, AINOFS_MAGIC, mnt);
+}
+
+
+static int __init aino_init(void)
+{
+
+	if (register_filesystem(&aino_fs_type))
+		goto epanic;
+
+	aino_mnt = kern_mount(&aino_fs_type);
+	if (IS_ERR(aino_mnt))
+		goto epanic;
+
+	aino_inode = aino_mkinode();
+	if (IS_ERR(aino_inode))
+		goto epanic;
+
+	return 0;
+
+epanic:
+	panic("aino_init() failed\n");
+}
+
+
+static void __exit aino_exit(void)
+{
+	iput(aino_inode);
+	unregister_filesystem(&aino_fs_type);
+	mntput(aino_mnt);
+}
+
+module_init(aino_init);
+module_exit(aino_exit);
+
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/anon_inodes.h
--- /dev/null
+++ a/include/linux/anon_inodes.h
@@ -0,0 +1,15 @@
+/*
+ *  include/linux/anon_inodes.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_ANON_INODES_H
+#define _LINUX_ANON_INODES_H
+
+int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
+	       char const *name, const struct file_operations *fops, void *priv);
+
+#endif /* _LINUX_ANON_INODES_H */
+
_

Patches currently in -mm which might be from davidel@xmailserver.org are

add-epoll-compat_-code-to-fs-compatc.patch
epoll-optimizations-and-cleanups.patch
epoll-optimizations-and-cleanups-tidy.patch
add-an-anonymous-inode-source.patch
add-an-anonymous-inode-source-tidy.patch
epoll-use-anonymous.patch
