From: akpm@linux-foundation.org
Subject: - proc-implement-proc_single_file_operations.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:11:58 -0800
Message-ID: <200802082011.m18KBdAk010134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47757 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbYBHVA6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:00:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@gmail.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     proc: implement proc_single_file_operations
has been removed from the -mm tree.  Its filename was
     proc-implement-proc_single_file_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: implement proc_single_file_operations
From: Eric W. Biederman <ebiederm@xmission.com>

Currently many /proc/pid files use a crufty precursor to the current seq_file
api, and they don't have direct access to the pid_namespace or the pid of for
which they are displaying data.

So implement proc_single_file_operations to make the seq_file routines easy to
use, and to give access to the full state of the pid of we are displaying data
for.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   43 ++++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h |    3 ++
 2 files changed, 46 insertions(+)

diff -puN fs/proc/base.c~proc-implement-proc_single_file_operations fs/proc/base.c
--- a/fs/proc/base.c~proc-implement-proc_single_file_operations
+++ a/fs/proc/base.c
@@ -121,6 +121,10 @@ struct pid_entry {
 	NOD(NAME, (S_IFREG|(MODE)), 			\
 		NULL, &proc_info_file_operations,	\
 		{ .proc_read = &proc_##OTYPE } )
+#define ONE(NAME, MODE, OTYPE)				\
+	NOD(NAME, (S_IFREG|(MODE)), 			\
+		NULL, &proc_single_file_operations,	\
+		{ .proc_show = &proc_##OTYPE } )
 
 int maps_protect;
 EXPORT_SYMBOL(maps_protect);
@@ -658,6 +662,45 @@ static const struct file_operations proc
 	.read		= proc_info_read,
 };
 
+static int proc_single_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct pid_namespace *ns;
+	struct pid *pid;
+	struct task_struct *task;
+	int ret;
+
+	ns = inode->i_sb->s_fs_info;
+	pid = proc_pid(inode);
+	task = get_pid_task(pid, PIDTYPE_PID);
+	if (!task)
+		return -ESRCH;
+
+	ret = PROC_I(inode)->op.proc_show(m, ns, pid, task);
+
+	put_task_struct(task);
+	return ret;
+}
+
+static int proc_single_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+	ret = single_open(filp, proc_single_show, NULL);
+	if (!ret) {
+		struct seq_file *m = filp->private_data;
+
+		m->private = inode;
+	}
+	return ret;
+}
+
+static const struct file_operations proc_single_file_operations = {
+	.open		= proc_single_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int mem_open(struct inode* inode, struct file* file)
 {
 	file->private_data = (void*)((long)current->self_exec_id);
diff -puN include/linux/proc_fs.h~proc-implement-proc_single_file_operations include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-implement-proc_single_file_operations
+++ a/include/linux/proc_fs.h
@@ -262,6 +262,9 @@ extern void kclist_add(struct kcore_list
 union proc_op {
 	int (*proc_get_link)(struct inode *, struct dentry **, struct vfsmount **);
 	int (*proc_read)(struct task_struct *task, char *page);
+	int (*proc_show)(struct seq_file *m,
+		struct pid_namespace *ns, struct pid *pid,
+		struct task_struct *task);
 };
 
 struct proc_inode {
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-x86.patch
deprecate-find_task_by_pid-kgdb.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
