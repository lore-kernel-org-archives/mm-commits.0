From: akpm@linux-foundation.org
Subject: - add-file-position-info-to-proc.patch removed from -mm tree
Date: Mon, 26 Mar 2007 17:43:40 -0700
Message-ID: <200703270045.l2R0jkdx003085@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33791 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933863AbXC0Aqb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 20:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     add file position info to proc
has been removed from the -mm tree.  Its filename was
     add-file-position-info-to-proc.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: add file position info to proc
From: Miklos Szeredi <mszeredi@suse.cz>

Add support for finding out the current file position, open flags and
possibly other info in the future.

These new entries are added:

  /proc/PID/fdinfo/FD
  /proc/PID/task/TID/fdinfo/FD

For each fd the information is provided in the following format:

pos:	1234
flags:	0100002

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |  132 ++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 114 insertions(+), 18 deletions(-)

diff -puN fs/proc/base.c~add-file-position-info-to-proc fs/proc/base.c
--- a/fs/proc/base.c~add-file-position-info-to-proc
+++ a/fs/proc/base.c
@@ -1233,7 +1233,10 @@ out:
 	return ~0U;
 }
 
-static int proc_fd_link(struct inode *inode, struct dentry **dentry, struct vfsmount **mnt)
+#define PROC_FDINFO_MAX 64
+
+static int proc_fd_info(struct inode *inode, struct dentry **dentry,
+			struct vfsmount **mnt, char *info)
 {
 	struct task_struct *task = get_proc_task(inode);
 	struct files_struct *files = NULL;
@@ -1252,8 +1255,16 @@ static int proc_fd_link(struct inode *in
 		spin_lock(&files->file_lock);
 		file = fcheck_files(files, fd);
 		if (file) {
-			*mnt = mntget(file->f_path.mnt);
-			*dentry = dget(file->f_path.dentry);
+			if (mnt)
+				*mnt = mntget(file->f_path.mnt);
+			if (dentry)
+				*dentry = dget(file->f_path.dentry);
+			if (info)
+				snprintf(info, PROC_FDINFO_MAX,
+					 "pos:\t%lli\n"
+					 "flags:\t0%o\n",
+					 (long long) file->f_pos,
+					 file->f_flags);
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;
@@ -1264,6 +1275,12 @@ static int proc_fd_link(struct inode *in
 	return -ENOENT;
 }
 
+static int proc_fd_link(struct inode *inode, struct dentry **dentry,
+			struct vfsmount **mnt)
+{
+	return proc_fd_info(inode, dentry, mnt, NULL);
+}
+
 static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
@@ -1359,7 +1376,9 @@ out_iput:
 	goto out;
 }
 
-static struct dentry *proc_lookupfd(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *proc_lookupfd_common(struct inode *dir,
+					   struct dentry *dentry,
+					   instantiate_t instantiate)
 {
 	struct task_struct *task = get_proc_task(dir);
 	unsigned fd = name_to_int(dentry);
@@ -1370,23 +1389,15 @@ static struct dentry *proc_lookupfd(stru
 	if (fd == ~0U)
 		goto out;
 
-	result = proc_fd_instantiate(dir, dentry, task, &fd);
+	result = instantiate(dir, dentry, task, &fd);
 out:
 	put_task_struct(task);
 out_no_task:
 	return result;
 }
 
-static int proc_fd_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
-	struct task_struct *task, int fd)
-{
-	char name[PROC_NUMBUF];
-	int len = snprintf(name, sizeof(name), "%d", fd);
-	return proc_fill_cache(filp, dirent, filldir, name, len,
-				proc_fd_instantiate, task, &fd);
-}
-
-static int proc_readfd(struct file * filp, void * dirent, filldir_t filldir)
+static int proc_readfd_common(struct file * filp, void * dirent,
+			      filldir_t filldir, instantiate_t instantiate)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
@@ -1422,12 +1433,17 @@ static int proc_readfd(struct file * fil
 			for (fd = filp->f_pos-2;
 			     fd < fdt->max_fds;
 			     fd++, filp->f_pos++) {
+				char name[PROC_NUMBUF];
+				int len;
 
 				if (!fcheck_files(files, fd))
 					continue;
 				rcu_read_unlock();
 
-				if (proc_fd_fill_cache(filp, dirent, filldir, p, fd) < 0) {
+				len = snprintf(name, sizeof(name), "%d", fd);
+				if (proc_fill_cache(filp, dirent, filldir,
+						    name, len, instantiate,
+						    p, &fd) < 0) {
 					rcu_read_lock();
 					break;
 				}
@@ -1442,6 +1458,32 @@ out_no_task:
 	return retval;
 }
 
+static struct dentry *proc_lookupfd(struct inode *dir, struct dentry *dentry,
+				    struct nameidata *nd)
+{
+	return proc_lookupfd_common(dir, dentry, proc_fd_instantiate);
+}
+
+static int proc_readfd(struct file *filp, void *dirent, filldir_t filldir)
+{
+	return proc_readfd_common(filp, dirent, filldir, proc_fd_instantiate);
+}
+
+static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
+				      size_t len, loff_t *ppos)
+{
+	char tmp[PROC_FDINFO_MAX];
+	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, NULL, tmp);
+	if (!err)
+		err = simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
+	return err;
+}
+
+const struct file_operations proc_fdinfo_file_operations = {
+	.open		= nonseekable_open,
+	.read		= proc_fdinfo_read,
+};
+
 static const struct file_operations proc_fd_operations = {
 	.read		= generic_read_dir,
 	.readdir	= proc_readfd,
@@ -1473,6 +1515,58 @@ static const struct inode_operations pro
 	.setattr	= proc_setattr,
 };
 
+static struct dentry *proc_fdinfo_instantiate(struct inode *dir,
+	struct dentry *dentry, struct task_struct *task, void *ptr)
+{
+	unsigned fd = *(unsigned *)ptr;
+ 	struct inode *inode;
+ 	struct proc_inode *ei;
+	struct dentry *error = ERR_PTR(-ENOENT);
+
+	inode = proc_pid_make_inode(dir->i_sb, task);
+	if (!inode)
+		goto out;
+	ei = PROC_I(inode);
+	ei->fd = fd;
+	inode->i_mode = S_IFREG | S_IRUSR;
+	inode->i_fop = &proc_fdinfo_file_operations;
+	dentry->d_op = &tid_fd_dentry_operations;
+	d_add(dentry, inode);
+	/* Close the race of the process dying before we return the dentry */
+	if (tid_fd_revalidate(dentry, NULL))
+		error = NULL;
+
+ out:
+	return error;
+}
+
+static struct dentry *proc_lookupfdinfo(struct inode *dir,
+					struct dentry *dentry,
+					struct nameidata *nd)
+{
+	return proc_lookupfd_common(dir, dentry, proc_fdinfo_instantiate);
+}
+
+static int proc_readfdinfo(struct file *filp, void *dirent, filldir_t filldir)
+{
+	return proc_readfd_common(filp, dirent, filldir,
+				  proc_fdinfo_instantiate);
+}
+
+static const struct file_operations proc_fdinfo_operations = {
+	.read		= generic_read_dir,
+	.readdir	= proc_readfdinfo,
+};
+
+/*
+ * proc directories can do almost nothing..
+ */
+static const struct inode_operations proc_fdinfo_inode_operations = {
+	.lookup		= proc_lookupfdinfo,
+	.setattr	= proc_setattr,
+};
+
+
 static struct dentry *proc_pident_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
@@ -1883,6 +1977,7 @@ static const struct inode_operations pro
 static const struct pid_entry tgid_base_stuff[] = {
 	DIR("task",       S_IRUGO|S_IXUGO, task),
 	DIR("fd",         S_IRUSR|S_IXUSR, fd),
+	DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
 	INF("environ",    S_IRUSR, pid_environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	INF("status",     S_IRUGO, pid_status),
@@ -2036,7 +2131,7 @@ static struct dentry *proc_pid_instantia
 	inode->i_op = &proc_tgid_base_inode_operations;
 	inode->i_fop = &proc_tgid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
-	inode->i_nlink = 4;
+	inode->i_nlink = 5;
 #ifdef CONFIG_SECURITY
 	inode->i_nlink += 1;
 #endif
@@ -2166,6 +2261,7 @@ out_no_task:
  */
 static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, fd),
+	DIR("fdinfo",    S_IRUSR|S_IXUSR, fdinfo),
 	INF("environ",   S_IRUSR, pid_environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	INF("status",    S_IRUGO, pid_status),
@@ -2246,7 +2342,7 @@ static struct dentry *proc_task_instanti
 	inode->i_op = &proc_tid_base_inode_operations;
 	inode->i_fop = &proc_tid_base_operations;
 	inode->i_flags|=S_IMMUTABLE;
-	inode->i_nlink = 3;
+	inode->i_nlink = 4;
 #ifdef CONFIG_SECURITY
 	inode->i_nlink += 1;
 #endif
_

Patches currently in -mm which might be from mszeredi@suse.cz are

shmem-fix-bug-in-shmem_writepage.patch
shmem-dont-release-lock-for-hole-punching.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
add-file-position-info-to-proc.patch
consolidate-generic_writepages-and-mpage_writepages.patch
