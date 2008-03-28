From: akpm@linux-foundation.org
Subject: - vfs-mountinfo-allow-using-process-root.patch removed from -mm tree
Date: Fri, 28 Mar 2008 12:06:37 -0700
Message-ID: <200803281906.m2SJ6bAV005401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968AbYC1THD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 15:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: mountinfo: allow using process root
has been removed from the -mm tree.  Its filename was
     vfs-mountinfo-allow-using-process-root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: mountinfo: allow using process root
From: Miklos Szeredi <mszeredi@suse.cz>

Allow /proc/<pid>/mountinfo to use the root of <pid> to calculate mountpoints.

 - move definition of 'struct proc_mounts' to <linux/mnt_namespace.h>
 - add the process's namespace and root to this structure
 - pass a pointer to 'struct proc_mounts' into seq_operations

In addition the following cleanups are made:

 - use a common open function for /proc/<pid>/{mounts,mountstat}
 - surround namespace.c part of these proc files with #ifdef CONFIG_PROC_FS
 - make the seq_operations structures const

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c                |   14 ++--
 fs/proc/base.c                |  108 +++++++++++++++-----------------
 include/linux/mnt_namespace.h |   11 +++
 3 files changed, 70 insertions(+), 63 deletions(-)

diff -puN fs/namespace.c~vfs-mountinfo-allow-using-process-root fs/namespace.c
--- a/fs/namespace.c~vfs-mountinfo-allow-using-process-root
+++ a/fs/namespace.c
@@ -731,20 +731,21 @@ void save_mount_options(struct super_blo
 }
 EXPORT_SYMBOL(save_mount_options);
 
+#ifdef CONFIG_PROC_FS
 /* iterator */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
-	struct mnt_namespace *n = m->private;
+	struct proc_mounts *p = m->private;
 
 	down_read(&namespace_sem);
-	return seq_list_start(&n->list, *pos);
+	return seq_list_start(&p->ns->list, *pos);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct mnt_namespace *n = m->private;
+	struct proc_mounts *p = m->private;
 
-	return seq_list_next(v, &n->list, pos);
+	return seq_list_next(v, &p->ns->list, pos);
 }
 
 static void m_stop(struct seq_file *m, void *v)
@@ -801,7 +802,7 @@ static int show_vfsmnt(struct seq_file *
 	return err;
 }
 
-struct seq_operations mounts_op = {
+const struct seq_operations mounts_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
@@ -840,12 +841,13 @@ static int show_vfsstat(struct seq_file 
 	return err;
 }
 
-struct seq_operations mountstats_op = {
+const struct seq_operations mountstats_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
 	.show	= show_vfsstat,
 };
+#endif  /* CONFIG_PROC_FS */
 
 /**
  * may_umount_tree - check if a mount tree is busy
diff -puN fs/proc/base.c~vfs-mountinfo-allow-using-process-root fs/proc/base.c
--- a/fs/proc/base.c~vfs-mountinfo-allow-using-process-root
+++ a/fs/proc/base.c
@@ -502,17 +502,14 @@ static const struct inode_operations pro
 	.setattr	= proc_setattr,
 };
 
-extern const struct seq_operations mounts_op;
-struct proc_mounts {
-	struct seq_file m;
-	int event;
-};
-
-static int mounts_open(struct inode *inode, struct file *file)
+static int mounts_open_common(struct inode *inode, struct file *file,
+			      const struct seq_operations *op)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct nsproxy *nsp;
 	struct mnt_namespace *ns = NULL;
+	struct fs_struct *fs = NULL;
+	struct path root;
 	struct proc_mounts *p;
 	int ret = -EINVAL;
 
@@ -525,40 +522,61 @@ static int mounts_open(struct inode *ino
 				get_mnt_ns(ns);
 		}
 		rcu_read_unlock();
-
+		if (ns)
+			fs = get_fs_struct(task);
 		put_task_struct(task);
 	}
 
-	if (ns) {
-		ret = -ENOMEM;
-		p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
-		if (p) {
-			file->private_data = &p->m;
-			ret = seq_open(file, &mounts_op);
-			if (!ret) {
-				p->m.private = ns;
-				p->event = ns->event;
-				return 0;
-			}
-			kfree(p);
-		}
-		put_mnt_ns(ns);
-	}
+	if (!ns)
+		goto err;
+	if (!fs)
+		goto err_put_ns;
+
+	read_lock(&fs->lock);
+	root = fs->root;
+	path_get(&root);
+	read_unlock(&fs->lock);
+	put_fs_struct(fs);
+
+	ret = -ENOMEM;
+	p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
+	if (!p)
+		goto err_put_path;
+
+	file->private_data = &p->m;
+	ret = seq_open(file, op);
+	if (ret)
+		goto err_free;
+
+	p->m.private = p;
+	p->ns = ns;
+	p->root = root;
+	p->event = ns->event;
+
+	return 0;
+
+ err_free:
+	kfree(p);
+ err_put_path:
+	path_put(&root);
+ err_put_ns:
+	put_mnt_ns(ns);
+ err:
 	return ret;
 }
 
 static int mounts_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *m = file->private_data;
-	struct mnt_namespace *ns = m->private;
-	put_mnt_ns(ns);
+	struct proc_mounts *p = file->private_data;
+	path_put(&p->root);
+	put_mnt_ns(p->ns);
 	return seq_release(inode, file);
 }
 
 static unsigned mounts_poll(struct file *file, poll_table *wait)
 {
 	struct proc_mounts *p = file->private_data;
-	struct mnt_namespace *ns = p->m.private;
+	struct mnt_namespace *ns = p->ns;
 	unsigned res = 0;
 
 	poll_wait(file, &ns->poll, wait);
@@ -573,6 +591,11 @@ static unsigned mounts_poll(struct file 
 	return res;
 }
 
+static int mounts_open(struct inode *inode, struct file *file)
+{
+	return mounts_open_common(inode, file, &mounts_op);
+}
+
 static const struct file_operations proc_mounts_operations = {
 	.open		= mounts_open,
 	.read		= seq_read,
@@ -581,38 +604,9 @@ static const struct file_operations proc
 	.poll		= mounts_poll,
 };
 
-extern const struct seq_operations mountstats_op;
 static int mountstats_open(struct inode *inode, struct file *file)
 {
-	int ret = seq_open(file, &mountstats_op);
-
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		struct nsproxy *nsp;
-		struct mnt_namespace *mnt_ns = NULL;
-		struct task_struct *task = get_proc_task(inode);
-
-		if (task) {
-			rcu_read_lock();
-			nsp = task_nsproxy(task);
-			if (nsp) {
-				mnt_ns = nsp->mnt_ns;
-				if (mnt_ns)
-					get_mnt_ns(mnt_ns);
-			}
-			rcu_read_unlock();
-
-			put_task_struct(task);
-		}
-
-		if (mnt_ns)
-			m->private = mnt_ns;
-		else {
-			seq_release(inode, file);
-			ret = -EINVAL;
-		}
-	}
-	return ret;
+	return mounts_open_common(inode, file, &mountstats_op);
 }
 
 static const struct file_operations proc_mountstats_operations = {
diff -puN include/linux/mnt_namespace.h~vfs-mountinfo-allow-using-process-root include/linux/mnt_namespace.h
--- a/include/linux/mnt_namespace.h~vfs-mountinfo-allow-using-process-root
+++ a/include/linux/mnt_namespace.h
@@ -5,6 +5,7 @@
 #include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/nsproxy.h>
+#include <linux/seq_file.h>
 
 struct mnt_namespace {
 	atomic_t		count;
@@ -14,6 +15,13 @@ struct mnt_namespace {
 	int event;
 };
 
+struct proc_mounts {
+	struct seq_file m; /* must be the first element */
+	struct mnt_namespace *ns;
+	struct path root;
+	int event;
+};
+
 extern struct mnt_namespace *copy_mnt_ns(unsigned long, struct mnt_namespace *,
 		struct fs_struct *);
 extern void __put_mnt_ns(struct mnt_namespace *ns);
@@ -37,5 +45,8 @@ static inline void get_mnt_ns(struct mnt
 	atomic_inc(&ns->count);
 }
 
+extern const struct seq_operations mounts_op;
+extern const struct seq_operations mountstats_op;
+
 #endif
 #endif
_

Patches currently in -mm which might be from mszeredi@suse.cz are

git-vfs.patch
mm-rotate_reclaimable_page-cleanup.patch
vfs-remove-lives_below_in_same_fs.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch

