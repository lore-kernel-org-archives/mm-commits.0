From: akpm@linux-foundation.org
Subject: [merged] procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:33:13 -0800
Message-ID: <20120111213314.24B3F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43465 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960Ab2AKVdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:33:16 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44375eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:33:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, kirill@shutemov.name, segoon@openwall.com, tj@kernel.org, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: make proc_get_link to use dentry instead of inode
has been removed from the -mm tree.  Its filename was
     procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs: make proc_get_link to use dentry instead of inode

Prepare the ground for the next "map_files" patch which needs a name of a
link file to analyse.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   20 ++++++++++----------
 include/linux/proc_fs.h |    2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/proc/base.c~procfs-make-proc_get_link-to-use-dentry-instead-of-inode fs/proc/base.c
--- a/fs/proc/base.c~procfs-make-proc_get_link-to-use-dentry-instead-of-inode
+++ a/fs/proc/base.c
@@ -166,9 +166,9 @@ static int get_task_root(struct task_str
 	return result;
 }
 
-static int proc_cwd_link(struct inode *inode, struct path *path)
+static int proc_cwd_link(struct dentry *dentry, struct path *path)
 {
-	struct task_struct *task = get_proc_task(inode);
+	struct task_struct *task = get_proc_task(dentry->d_inode);
 	int result = -ENOENT;
 
 	if (task) {
@@ -183,9 +183,9 @@ static int proc_cwd_link(struct inode *i
 	return result;
 }
 
-static int proc_root_link(struct inode *inode, struct path *path)
+static int proc_root_link(struct dentry *dentry, struct path *path)
 {
-	struct task_struct *task = get_proc_task(inode);
+	struct task_struct *task = get_proc_task(dentry->d_inode);
 	int result = -ENOENT;
 
 	if (task) {
@@ -1456,13 +1456,13 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
-static int proc_exe_link(struct inode *inode, struct path *exe_path)
+static int proc_exe_link(struct dentry *dentry, struct path *exe_path)
 {
 	struct task_struct *task;
 	struct mm_struct *mm;
 	struct file *exe_file;
 
-	task = get_proc_task(inode);
+	task = get_proc_task(dentry->d_inode);
 	if (!task)
 		return -ENOENT;
 	mm = get_task_mm(task);
@@ -1492,7 +1492,7 @@ static void *proc_pid_follow_link(struct
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path);
+	error = PROC_I(inode)->op.proc_get_link(dentry, &nd->path);
 out:
 	return ERR_PTR(error);
 }
@@ -1531,7 +1531,7 @@ static int proc_pid_readlink(struct dent
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &path);
+	error = PROC_I(inode)->op.proc_get_link(dentry, &path);
 	if (error)
 		goto out;
 
@@ -1823,9 +1823,9 @@ static int proc_fd_info(struct inode *in
 	return -ENOENT;
 }
 
-static int proc_fd_link(struct inode *inode, struct path *path)
+static int proc_fd_link(struct dentry *dentry, struct path *path)
 {
-	return proc_fd_info(inode, path, NULL);
+	return proc_fd_info(dentry->d_inode, path, NULL);
 }
 
 static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
diff -puN include/linux/proc_fs.h~procfs-make-proc_get_link-to-use-dentry-instead-of-inode include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~procfs-make-proc_get_link-to-use-dentry-instead-of-inode
+++ a/include/linux/proc_fs.h
@@ -253,7 +253,7 @@ extern const struct proc_ns_operations u
 extern const struct proc_ns_operations ipcns_operations;
 
 union proc_op {
-	int (*proc_get_link)(struct inode *, struct path *);
+	int (*proc_get_link)(struct dentry *, struct path *);
 	int (*proc_read)(struct task_struct *task, char *page);
 	int (*proc_show)(struct seq_file *m,
 		struct pid_namespace *ns, struct pid *pid,
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch
sysctl-add-the-kernelns_last_pid-control.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

