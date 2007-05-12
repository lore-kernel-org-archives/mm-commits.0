From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-anonymous-inode-source.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:54 -0700
Message-ID: <200705120534.l4C5YsHd002234@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbXELFe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     signal/timer/event fds: anonymous inode source
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-anonymous-inode-source.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: signal/timer/event fds: anonymous inode source
From: Davide Libenzi <davidel@xmailserver.org>

This patch add an anonymous inode source, to be used for files that need
and inode only in order to create a file*. We do not care of having an
inode for each file, and we do not even care of having different names in
the associated dentries (dentry names will be same for classes of file*).
This allow code reuse, and will be used by epoll, signalfd and timerfd
(and whatever else there'll be).

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Makefile                 |    1 
 fs/anon_inodes.c            |  200 ++++++++++++++++++++++++++++++++++
 include/linux/anon_inodes.h |   16 ++
 include/linux/magic.h       |    1 
 init/Kconfig                |   10 +
 5 files changed, 228 insertions(+)

diff -puN fs/Makefile~signal-timer-event-fds-v9-anonymous-inode-source fs/Makefile
--- a/fs/Makefile~signal-timer-event-fds-v9-anonymous-inode-source
+++ a/fs/Makefile
@@ -22,6 +22,7 @@ endif
 obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
+obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
diff -puN /dev/null fs/anon_inodes.c
--- /dev/null
+++ a/fs/anon_inodes.c
@@ -0,0 +1,200 @@
+/*
+ *  fs/anon_inodes.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ *  Thanks to Arnd Bergmann for code review and suggestions.
+ *  More changes for Thomas Gleixner suggestions.
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
+#include <linux/magic.h>
+#include <linux/anon_inodes.h>
+
+#include <asm/uaccess.h>
+
+static struct vfsmount *anon_inode_mnt __read_mostly;
+static struct inode *anon_inode_inode;
+static const struct file_operations anon_inode_fops;
+
+static int anon_inodefs_get_sb(struct file_system_type *fs_type, int flags,
+			       const char *dev_name, void *data,
+			       struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "anon_inode:", NULL, ANON_INODE_FS_MAGIC,
+			     mnt);
+}
+
+static int anon_inodefs_delete_dentry(struct dentry *dentry)
+{
+	/*
+	 * We faked vfs to believe the dentry was hashed when we created it.
+	 * Now we restore the flag so that dput() will work correctly.
+	 */
+	dentry->d_flags |= DCACHE_UNHASHED;
+	return 1;
+}
+
+static struct file_system_type anon_inode_fs_type = {
+	.name		= "anon_inodefs",
+	.get_sb		= anon_inodefs_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+static struct dentry_operations anon_inodefs_dentry_operations = {
+	.d_delete	= anon_inodefs_delete_dentry,
+};
+
+/**
+ * anon_inode_getfd - creates a new file instance by hooking it up to and
+ *                    anonymous inode, and a dentry that describe the "class"
+ *                    of the file
+ *
+ * @pfd:     [out]   pointer to the file descriptor
+ * @dpinode: [out]   pointer to the inode
+ * @pfile:   [out]   pointer to the file struct
+ * @name:    [in]    name of the "class" of the new file
+ * @fops     [in]    file operations for the new file
+ * @priv     [in]    private data for the new file (will be file's private_data)
+ *
+ * Creates a new file by hooking it on a single inode. This is useful for files
+ * that do not need to have a full-fledged inode in order to operate correctly.
+ * All the files created with anon_inode_getfd() will share a single inode, by
+ * hence saving memory and avoiding code duplication for the file/inode/dentry
+ * setup.
+ */
+int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
+		     const char *name, const struct file_operations *fops,
+		     void *priv)
+{
+	struct qstr this;
+	struct dentry *dentry;
+	struct inode *inode;
+	struct file *file;
+	int error, fd;
+
+	if (IS_ERR(anon_inode_inode))
+		return -ENODEV;
+	file = get_empty_filp();
+	if (!file)
+		return -ENFILE;
+
+	inode = igrab(anon_inode_inode);
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
+		goto err_put_filp;
+	}
+
+	error = get_unused_fd();
+	if (error < 0)
+		goto err_iput;
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
+	dentry = d_alloc(anon_inode_mnt->mnt_sb->s_root, &this);
+	if (!dentry)
+		goto err_put_unused_fd;
+	dentry->d_op = &anon_inodefs_dentry_operations;
+	/* Do not publish this dentry inside the global dentry hash table */
+	dentry->d_flags &= ~DCACHE_UNHASHED;
+	d_instantiate(dentry, inode);
+
+	file->f_path.mnt = mntget(anon_inode_mnt);
+	file->f_path.dentry = dentry;
+	file->f_mapping = inode->i_mapping;
+
+	file->f_pos = 0;
+	file->f_flags = O_RDWR;
+	file->f_op = fops;
+	file->f_mode = FMODE_READ | FMODE_WRITE;
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
+err_put_unused_fd:
+	put_unused_fd(fd);
+err_iput:
+	iput(inode);
+err_put_filp:
+	put_filp(file);
+	return error;
+}
+
+/*
+ * A single inode exist for all anon_inode files. Contrary to pipes,
+ * anon_inode inodes has no per-instance data associated, so we can avoid
+ * the allocation of multiple of them.
+ */
+static struct inode *anon_inode_mkinode(void)
+{
+	struct inode *inode = new_inode(anon_inode_mnt->mnt_sb);
+
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	inode->i_fop = &anon_inode_fops;
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
+}
+
+static int __init anon_inode_init(void)
+{
+	int error;
+
+	error = register_filesystem(&anon_inode_fs_type);
+	if (error)
+		goto err_exit;
+	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
+	if (IS_ERR(anon_inode_mnt)) {
+		error = PTR_ERR(anon_inode_mnt);
+		goto err_unregister_filesystem;
+	}
+	anon_inode_inode = anon_inode_mkinode();
+	if (IS_ERR(anon_inode_inode)) {
+		error = PTR_ERR(anon_inode_inode);
+		goto err_mntput;
+	}
+
+	return 0;
+
+err_mntput:
+	mntput(anon_inode_mnt);
+err_unregister_filesystem:
+	unregister_filesystem(&anon_inode_fs_type);
+err_exit:
+	panic(KERN_ERR "anon_inode_init() failed (%d)\n", error);
+}
+
+fs_initcall(anon_inode_init);
+
diff -puN /dev/null include/linux/anon_inodes.h
--- /dev/null
+++ a/include/linux/anon_inodes.h
@@ -0,0 +1,16 @@
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
+int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
+		     const char *name, const struct file_operations *fops,
+		     void *priv);
+
+#endif /* _LINUX_ANON_INODES_H */
+
diff -puN include/linux/magic.h~signal-timer-event-fds-v9-anonymous-inode-source include/linux/magic.h
--- a/include/linux/magic.h~signal-timer-event-fds-v9-anonymous-inode-source
+++ a/include/linux/magic.h
@@ -14,6 +14,7 @@
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
 #define KVMFS_SUPER_MAGIC	0x19700426
+#define ANON_INODE_FS_MAGIC	0x09041934
 
 #define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix fs, 30 char names */
diff -puN init/Kconfig~signal-timer-event-fds-v9-anonymous-inode-source init/Kconfig
--- a/init/Kconfig~signal-timer-event-fds-v9-anonymous-inode-source
+++ a/init/Kconfig
@@ -475,9 +475,19 @@ config FUTEX
 	  support for "fast userspace mutexes".  The resulting kernel may not
 	  run glibc-based applications correctly.
 
+config ANON_INODES
+	bool "Enable anonymous inode source" if EMBEDDED
+	default y
+	help
+	  Anonymous inode source for pseudo-files like epoll, signalfd,
+	  timerfd and eventfd.
+
+	  If unsure, say Y.
+
 config EPOLL
 	bool "Enable eventpoll support" if EMBEDDED
 	default y
+	depends on ANON_INODES
 	help
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
