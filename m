From: akpm@osdl.org
Subject: - proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:40 -0800
Message-ID: <200612082001.kB8K1erP001891@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426217AbWLHUBv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     proc: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: proc: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the proc
filesystem code.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/base.c       |   36 ++++++++++++++++++------------------
 fs/proc/generic.c    |   10 +++++-----
 fs/proc/nommu.c      |    4 ++--
 fs/proc/task_mmu.c   |    8 ++++----
 fs/proc/task_nommu.c |    4 ++--
 5 files changed, 31 insertions(+), 31 deletions(-)

diff -puN fs/proc/base.c~proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/proc/base.c
--- a/fs/proc/base.c~proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/proc/base.c
@@ -472,7 +472,7 @@ static struct file_operations proc_mount
 static ssize_t proc_info_read(struct file * file, char __user * buf,
 			  size_t count, loff_t *ppos)
 {
-	struct inode * inode = file->f_dentry->d_inode;
+	struct inode * inode = file->f_path.dentry->d_inode;
 	unsigned long page;
 	ssize_t length;
 	struct task_struct *task = get_proc_task(inode);
@@ -512,7 +512,7 @@ static int mem_open(struct inode* inode,
 static ssize_t mem_read(struct file * file, char __user * buf,
 			size_t count, loff_t *ppos)
 {
-	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 	char *page;
 	unsigned long src = *ppos;
 	int ret = -ESRCH;
@@ -584,7 +584,7 @@ static ssize_t mem_write(struct file * f
 {
 	int copied;
 	char *page;
-	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 	unsigned long dst = *ppos;
 
 	copied = -ESRCH;
@@ -654,7 +654,7 @@ static struct file_operations proc_mem_o
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 	char buffer[PROC_NUMBUF];
 	size_t len;
 	int oom_adjust;
@@ -694,7 +694,7 @@ static ssize_t oom_adjust_write(struct f
 		return -EINVAL;
 	if (*end == '\n')
 		end++;
-	task = get_proc_task(file->f_dentry->d_inode);
+	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
 	if (oom_adjust < task->oomkilladj && !capable(CAP_SYS_RESOURCE)) {
@@ -718,7 +718,7 @@ static struct file_operations proc_oom_a
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
 				  size_t count, loff_t *ppos)
 {
-	struct inode * inode = file->f_dentry->d_inode;
+	struct inode * inode = file->f_path.dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
 	ssize_t length;
 	char tmpbuf[TMPBUFLEN];
@@ -734,7 +734,7 @@ static ssize_t proc_loginuid_read(struct
 static ssize_t proc_loginuid_write(struct file * file, const char __user * buf,
 				   size_t count, loff_t *ppos)
 {
-	struct inode * inode = file->f_dentry->d_inode;
+	struct inode * inode = file->f_path.dentry->d_inode;
 	char *page, *tmp;
 	ssize_t length;
 	uid_t loginuid;
@@ -1078,7 +1078,7 @@ static int proc_fill_cache(struct file *
 	char *name, int len,
 	instantiate_t instantiate, struct task_struct *task, void *ptr)
 {
-	struct dentry *child, *dir = filp->f_dentry;
+	struct dentry *child, *dir = filp->f_path.dentry;
 	struct inode *inode;
 	struct qstr qname;
 	ino_t ino = 0;
@@ -1157,8 +1157,8 @@ static int proc_fd_link(struct inode *in
 		spin_lock(&files->file_lock);
 		file = fcheck_files(files, fd);
 		if (file) {
-			*mnt = mntget(file->f_vfsmnt);
-			*dentry = dget(file->f_dentry);
+			*mnt = mntget(file->f_path.mnt);
+			*dentry = dget(file->f_path.dentry);
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;
@@ -1293,7 +1293,7 @@ static int proc_fd_fill_cache(struct fil
 
 static int proc_readfd(struct file * filp, void * dirent, filldir_t filldir)
 {
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *p = get_proc_task(inode);
 	unsigned int fd, tid, ino;
@@ -1440,7 +1440,7 @@ static int proc_pident_readdir(struct fi
 {
 	int i;
 	int pid;
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
 	struct pid_entry *p, *last;
@@ -1496,7 +1496,7 @@ out_no_task:
 static ssize_t proc_pid_attr_read(struct file * file, char __user * buf,
 				  size_t count, loff_t *ppos)
 {
-	struct inode * inode = file->f_dentry->d_inode;
+	struct inode * inode = file->f_path.dentry->d_inode;
 	unsigned long page;
 	ssize_t length;
 	struct task_struct *task = get_proc_task(inode);
@@ -1512,7 +1512,7 @@ static ssize_t proc_pid_attr_read(struct
 		goto out;
 
 	length = security_getprocattr(task,
-				      (char*)file->f_dentry->d_name.name,
+				      (char*)file->f_path.dentry->d_name.name,
 				      (void*)page, count);
 	if (length >= 0)
 		length = simple_read_from_buffer(buf, count, ppos, (char *)page, length);
@@ -1526,7 +1526,7 @@ out_no_task:
 static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 				   size_t count, loff_t *ppos)
 {
-	struct inode * inode = file->f_dentry->d_inode;
+	struct inode * inode = file->f_path.dentry->d_inode;
 	char *page;
 	ssize_t length;
 	struct task_struct *task = get_proc_task(inode);
@@ -1552,7 +1552,7 @@ static ssize_t proc_pid_attr_write(struc
 		goto out_free;
 
 	length = security_setprocattr(task,
-				      (char*)file->f_dentry->d_name.name,
+				      (char*)file->f_path.dentry->d_name.name,
 				      (void*)page, count);
 out_free:
 	free_page((unsigned long) page);
@@ -1994,7 +1994,7 @@ static int proc_pid_fill_cache(struct fi
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
 	unsigned int nr = filp->f_pos - FIRST_PROCESS_ENTRY;
-	struct task_struct *reaper = get_proc_task(filp->f_dentry->d_inode);
+	struct task_struct *reaper = get_proc_task(filp->f_path.dentry->d_inode);
 	struct task_struct *task;
 	int tgid;
 
@@ -2235,7 +2235,7 @@ static int proc_task_fill_cache(struct f
 /* for the /proc/TGID/task/ directories */
 static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *leader = get_proc_task(inode);
 	struct task_struct *task;
diff -puN fs/proc/generic.c~proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/proc/generic.c
--- a/fs/proc/generic.c~proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/proc/generic.c
@@ -52,7 +52,7 @@ static ssize_t
 proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 	       loff_t *ppos)
 {
-	struct inode * inode = file->f_dentry->d_inode;
+	struct inode * inode = file->f_path.dentry->d_inode;
 	char 	*page;
 	ssize_t	retval=0;
 	int	eof=0;
@@ -203,7 +203,7 @@ static ssize_t
 proc_file_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct proc_dir_entry * dp;
 	
 	dp = PDE(inode);
@@ -432,7 +432,7 @@ int proc_readdir(struct file * filp,
 	struct proc_dir_entry * de;
 	unsigned int ino;
 	int i;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	int ret = 0;
 
 	lock_kernel();
@@ -453,7 +453,7 @@ int proc_readdir(struct file * filp,
 			/* fall through */
 		case 1:
 			if (filldir(dirent, "..", 2, i,
-				    parent_ino(filp->f_dentry),
+				    parent_ino(filp->f_path.dentry),
 				    DT_DIR) < 0)
 				goto out;
 			i++;
@@ -558,7 +558,7 @@ static void proc_kill_inodes(struct proc
 	file_list_lock();
 	list_for_each(p, &sb->s_files) {
 		struct file * filp = list_entry(p, struct file, f_u.fu_list);
-		struct dentry * dentry = filp->f_dentry;
+		struct dentry * dentry = filp->f_path.dentry;
 		struct inode * inode;
 		const struct file_operations *fops;
 
diff -puN fs/proc/nommu.c~proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/proc/nommu.c
--- a/fs/proc/nommu.c~proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/proc/nommu.c
@@ -46,7 +46,7 @@ int nommu_vma_show(struct seq_file *m, s
 	file = vma->vm_file;
 
 	if (file) {
-		struct inode *inode = vma->vm_file->f_dentry->d_inode;
+		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
 	}
@@ -67,7 +67,7 @@ int nommu_vma_show(struct seq_file *m, s
 		if (len < 1)
 			len = 1;
 		seq_printf(m, "%*c", len, ' ');
-		seq_path(m, file->f_vfsmnt, file->f_dentry, "");
+		seq_path(m, file->f_path.mnt, file->f_path.dentry, "");
 	}
 
 	seq_putc(m, '\n');
diff -puN fs/proc/task_mmu.c~proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/proc/task_mmu.c
@@ -94,8 +94,8 @@ int proc_exe_link(struct inode *inode, s
 	}
 
 	if (vma) {
-		*mnt = mntget(vma->vm_file->f_vfsmnt);
-		*dentry = dget(vma->vm_file->f_dentry);
+		*mnt = mntget(vma->vm_file->f_path.mnt);
+		*dentry = dget(vma->vm_file->f_path.dentry);
 		result = 0;
 	}
 
@@ -135,7 +135,7 @@ static int show_map_internal(struct seq_
 	int len;
 
 	if (file) {
-		struct inode *inode = vma->vm_file->f_dentry->d_inode;
+		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
 	}
@@ -156,7 +156,7 @@ static int show_map_internal(struct seq_
 	 */
 	if (file) {
 		pad_len_spaces(m, len);
-		seq_path(m, file->f_vfsmnt, file->f_dentry, "\n");
+		seq_path(m, file->f_path.mnt, file->f_path.dentry, "\n");
 	} else {
 		const char *name = arch_vma_name(vma);
 		if (!name) {
diff -puN fs/proc/task_nommu.c~proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/proc/task_nommu.c
@@ -126,8 +126,8 @@ int proc_exe_link(struct inode *inode, s
 	}
 
 	if (vma) {
-		*mnt = mntget(vma->vm_file->f_vfsmnt);
-		*dentry = dget(vma->vm_file->f_dentry);
+		*mnt = mntget(vma->vm_file->f_path.mnt);
+		*dentry = dget(vma->vm_file->f_path.dentry);
 		result = 0;
 	}
 
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

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

