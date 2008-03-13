From: akpm@linux-foundation.org
Subject: + vfs-mountinfo-only-show-mounts-under-tasks-root.patch added to -mm tree
Date: Thu, 13 Mar 2008 15:51:00 -0700
Message-ID: <200803132251.m2DMp12l004549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbYCMWwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 18:52:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, haveblue@us.ibm.com, hch@lst.de, jblunck@suse.de, linuxram@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: mountinfo: only show mounts under tasks root
has been added to the -mm tree.  Its filename is
     vfs-mountinfo-only-show-mounts-under-tasks-root.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: mountinfo: only show mounts under tasks root
From: Miklos Szeredi <mszeredi@suse.cz>

1. Only show reachable mounts in /proc/<pid>/mountinfo, this makes
mountpoints unambiguous for chrooted processes.

2. Instead of showing mountpoints relative to the current root, always
show them relative to the queried task's root.

This means, that a particular mountinfo file will always have the same
contents, regardless of which process is reading the file.  Which is a
lot more consistent, than the current behavior of /proc/<pid>/mounts.

Addressed comments from Jan Blunck and Ram Pai.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c                   |   16 ++++---
 fs/namespace.c                |   23 +++++++---
 fs/pnode.c                    |   28 ++++++++++---
 fs/pnode.h                    |    2 
 fs/proc/base.c                |   68 ++++++++++++++++++++------------
 fs/seq_file.c                 |   25 +++++++++++
 include/linux/dcache.h        |    1 
 include/linux/mnt_namespace.h |    8 +++
 include/linux/seq_file.h      |    2 
 9 files changed, 128 insertions(+), 45 deletions(-)

diff -puN fs/dcache.c~vfs-mountinfo-only-show-mounts-under-tasks-root fs/dcache.c
--- a/fs/dcache.c~vfs-mountinfo-only-show-mounts-under-tasks-root
+++ a/fs/dcache.c
@@ -1759,12 +1759,12 @@ static int prepend(char **buffer, int *b
 
 /**
  * d_path - return the path of a dentry
- * @dentry: dentry to report
- * @vfsmnt: vfsmnt to which the dentry belongs
+ * @path: the dentry/vfsmount to report
  * @root: root dentry
  * @rootmnt: vfsmnt to which the root dentry belongs
  * @buffer: buffer to return value in
  * @buflen: buffer length
+ * @only_reachable: if true, then path must be reachable from root
  *
  * Convert a dentry into an ASCII path name. If the entry has been deleted
  * the string " (deleted)" is appended. Note that this is ambiguous.
@@ -1773,9 +1773,11 @@ static int prepend(char **buffer, int *b
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  */
-static char *__d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-		       struct path *root, char *buffer, int buflen)
+char *__d_path(struct path *path, struct path *root, char *buffer, int buflen,
+	       bool only_reachable)
 {
+	struct dentry *dentry = path->dentry;
+	struct vfsmount *vfsmnt = path->mnt;
 	char * end = buffer+buflen;
 	char * retval;
 
@@ -1820,6 +1822,8 @@ static char *__d_path(struct dentry *den
 	return retval;
 
 global_root:
+	if (only_reachable)
+		return ERR_PTR(-EINVAL);
 	retval += 1;	/* hit the slash */
 	if (prepend(&retval, &buflen, dentry->d_name.name,
 		    dentry->d_name.len) != 0)
@@ -1862,7 +1866,7 @@ char *d_path(struct path *path, char *bu
 	path_get(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(path->dentry, path->mnt, &root, buf, buflen);
+	res = __d_path(path, &root, buf, buflen, false);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -1975,7 +1979,7 @@ asmlinkage long sys_getcwd(char __user *
 		unsigned long len;
 		char * cwd;
 
-		cwd = __d_path(pwd.dentry, pwd.mnt, &root, page, PAGE_SIZE);
+		cwd = __d_path(&pwd, &root, page, PAGE_SIZE, false);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
diff -puN fs/namespace.c~vfs-mountinfo-only-show-mounts-under-tasks-root fs/namespace.c
--- a/fs/namespace.c~vfs-mountinfo-only-show-mounts-under-tasks-root
+++ a/fs/namespace.c
@@ -694,17 +694,17 @@ EXPORT_SYMBOL(save_mount_options);
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
@@ -790,6 +790,8 @@ const struct seq_operations mounts_op = 
 
 static int show_mountinfo(struct seq_file *m, void *v)
 {
+	struct proc_mounts *p = m->private;
+	size_t count_save = m->count;
 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
 	struct super_block *sb = mnt->mnt_sb;
 	struct path mnt_path = { .dentry = mnt->mnt_root, .mnt = mnt };
@@ -803,7 +805,11 @@ static int show_mountinfo(struct seq_fil
 	seq_putc(m, ' ');
 	seq_dentry(m, mnt->mnt_root, " \t\n\\");
 	seq_putc(m, ' ');
-	seq_path(m, &mnt_path, " \t\n\\");
+	if (seq_path_root(m, &mnt_path, &p->root, " \t\n\\") == -EINVAL) {
+		/* path is outside root */
+		m->count = count_save;
+		return 0;
+	}
 	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? " ro" : " rw");
 	show_mnt_opts(m, mnt);
 	seq_puts(m, sb->s_flags & MS_RDONLY ? " ro" : " rw");
@@ -815,14 +821,15 @@ static int show_mountinfo(struct seq_fil
 		if (IS_MNT_SHARED(mnt))
 			seq_printf(m, "shared:%i", get_peer_group_id(mnt));
 		if (IS_MNT_SLAVE(mnt)) {
-			int dominator_id = get_dominator_id_same_ns(mnt);
+			int dominator;
 
 			if (IS_MNT_SHARED(mnt))
 				seq_putc(m, ',');
 
 			seq_printf(m, "slave:%i", get_master_group_id(mnt));
-			if (dominator_id != -1)
-				seq_printf(m, ":%i", dominator_id);
+			dominator = get_dominator_id_same_root(mnt, &p->root);
+			if (dominator != -1)
+				seq_printf(m, ":%i", dominator);
 		}
 	} else if (IS_MNT_UNBINDABLE(mnt)) {
 		seq_printf(m, "unbindable");
diff -puN fs/pnode.c~vfs-mountinfo-only-show-mounts-under-tasks-root fs/pnode.c
--- a/fs/pnode.c~vfs-mountinfo-only-show-mounts-under-tasks-root
+++ a/fs/pnode.c
@@ -89,28 +89,46 @@ int get_master_group_id(struct vfsmount 
 	return id;
 }
 
-static struct vfsmount *get_peer_in_ns(struct vfsmount *mnt,
-				       struct mnt_namespace *ns)
+/*
+ * Return true if path is reachable from root
+ *
+ * Caller must hold vfsmount_lock
+ */
+static bool is_path_reachable(struct vfsmount *mnt, struct dentry *dentry,
+			 const struct path *root)
+{
+	while (mnt != root->mnt && mnt->mnt_parent != mnt) {
+		dentry = mnt->mnt_mountpoint;
+		mnt = mnt->mnt_parent;
+	}
+	return mnt == root->mnt && is_subdir(dentry, root->dentry);
+}
+
+static struct vfsmount *get_peer_under_root(struct vfsmount *mnt,
+					    struct mnt_namespace *ns,
+					    const struct path *root)
 {
 	struct vfsmount *m = mnt;
 
 	do {
-		if (m->mnt_ns == ns)
+		/* Check the namespace first for optimization */
+		if (m->mnt_ns == ns && is_path_reachable(m, m->mnt_root, root))
 			return m;
+
 		m = next_peer(m);
 	} while (m != mnt);
 
 	return NULL;
 }
 
-int get_dominator_id_same_ns(struct vfsmount *mnt)
+int get_dominator_id_same_root(struct vfsmount *mnt, const struct path *root)
 {
 	int id = -1;
 	struct vfsmount *m;
 
 	spin_lock(&vfsmount_lock);
 	for (m = mnt->mnt_master; m != NULL; m = m->mnt_master) {
-		struct vfsmount *d = get_peer_in_ns(m, mnt->mnt_ns);
+		struct vfsmount *d = get_peer_under_root(m, mnt->mnt_ns, root);
 		if (d) {
 			id = d->mnt_pgid;
 			break;
diff -puN fs/pnode.h~vfs-mountinfo-only-show-mounts-under-tasks-root fs/pnode.h
--- a/fs/pnode.h~vfs-mountinfo-only-show-mounts-under-tasks-root
+++ a/fs/pnode.h
@@ -34,6 +34,6 @@ int propagate_mount_busy(struct vfsmount
 
 int get_peer_group_id(struct vfsmount *);
 int get_master_group_id(struct vfsmount *);
-int get_dominator_id_same_ns(struct vfsmount *);
+int get_dominator_id_same_root(struct vfsmount *, const struct path *);
 
 #endif /* _LINUX_PNODE_H */
diff -puN fs/proc/base.c~vfs-mountinfo-only-show-mounts-under-tasks-root fs/proc/base.c
--- a/fs/proc/base.c~vfs-mountinfo-only-show-mounts-under-tasks-root
+++ a/fs/proc/base.c
@@ -502,17 +502,14 @@ static const struct inode_operations pro
 	.setattr	= proc_setattr,
 };
 
-struct proc_mounts {
-	struct seq_file m;
-	int event;
-};
-
 static int mounts_open_common(struct inode *inode, struct file *file,
 			      const struct seq_operations *op)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct nsproxy *nsp;
 	struct mnt_namespace *ns = NULL;
+	struct fs_struct *fs = NULL;
+	struct path root;
 	struct proc_mounts *p;
 	int ret = -EINVAL;
 
@@ -525,40 +522,61 @@ static int mounts_open_common(struct ino
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
-			ret = seq_open(file, op);
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
diff -puN fs/seq_file.c~vfs-mountinfo-only-show-mounts-under-tasks-root fs/seq_file.c
--- a/fs/seq_file.c~vfs-mountinfo-only-show-mounts-under-tasks-root
+++ a/fs/seq_file.c
@@ -385,6 +385,31 @@ int seq_path(struct seq_file *m, struct 
 EXPORT_SYMBOL(seq_path);
 
 #ifdef CONFIG_PROC_FS
+int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
+		  char *esc)
+{
+	int err = -ENAMETOOLONG;
+	if (m->count < m->size) {
+		char *s = m->buf + m->count;
+		char *p;
+
+		spin_lock(&dcache_lock);
+		p = __d_path(path, root, s, m->size - m->count, true);
+		spin_unlock(&dcache_lock);
+		err = PTR_ERR(p);
+		if (!IS_ERR(p)) {
+			s = mangle_path(s, p, esc);
+			if (s) {
+				p = m->buf + m->count;
+				m->count = s - m->buf;
+				return 0;
+			}
+		}
+	}
+	m->count = m->size;
+	return err;
+}
+
 /*
  * returns the path of the 'dentry' from the root of its filesystem.
  */
diff -puN include/linux/dcache.h~vfs-mountinfo-only-show-mounts-under-tasks-root include/linux/dcache.h
--- a/include/linux/dcache.h~vfs-mountinfo-only-show-mounts-under-tasks-root
+++ a/include/linux/dcache.h
@@ -302,6 +302,7 @@ extern int d_validate(struct dentry *, s
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
+extern char *__d_path(struct path *path, struct path *root, char *, int, bool);
 extern char *d_path(struct path *, char *, int);
 
 #ifdef CONFIG_PROC_FS
diff -puN include/linux/mnt_namespace.h~vfs-mountinfo-only-show-mounts-under-tasks-root include/linux/mnt_namespace.h
--- a/include/linux/mnt_namespace.h~vfs-mountinfo-only-show-mounts-under-tasks-root
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
diff -puN include/linux/seq_file.h~vfs-mountinfo-only-show-mounts-under-tasks-root include/linux/seq_file.h
--- a/include/linux/seq_file.h~vfs-mountinfo-only-show-mounts-under-tasks-root
+++ a/include/linux/seq_file.h
@@ -45,6 +45,8 @@ int seq_printf(struct seq_file *, const 
 int seq_path(struct seq_file *, struct path *, char *);
 
 #ifdef CONFIG_PROC_FS
+int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
+		  char *esc);
 int seq_dentry(struct seq_file *, struct dentry *, char *);
 #endif /* CONFIG_PROC_FS */
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
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

