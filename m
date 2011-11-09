From: akpm@linux-foundation.org
Subject: + procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch added to -mm tree
Date: Wed, 09 Nov 2011 14:15:19 -0800
Message-ID: <201111092215.pA9MFK2P029276@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:42005 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1KIWPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 17:15:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, adobriyan@gmail.com, kirill@shutemov.name, segoon@openwall.com, tj@kernel.org, viro@ZenIV.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: procfs: make proc_get_link to use dentry instead of inode
has been added to the -mm tree.  Its filename is
     procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -165,9 +165,9 @@ static int get_task_root(struct task_str
 	return result;
 }
 
-static int proc_cwd_link(struct inode *inode, struct path *path)
+static int proc_cwd_link(struct dentry *dentry, struct path *path)
 {
-	struct task_struct *task = get_proc_task(inode);
+	struct task_struct *task = get_proc_task(dentry->d_inode);
 	int result = -ENOENT;
 
 	if (task) {
@@ -182,9 +182,9 @@ static int proc_cwd_link(struct inode *i
 	return result;
 }
 
-static int proc_root_link(struct inode *inode, struct path *path)
+static int proc_root_link(struct dentry *dentry, struct path *path)
 {
-	struct task_struct *task = get_proc_task(inode);
+	struct task_struct *task = get_proc_task(dentry->d_inode);
 	int result = -ENOENT;
 
 	if (task) {
@@ -1567,13 +1567,13 @@ static const struct file_operations proc
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
@@ -1603,7 +1603,7 @@ static void *proc_pid_follow_link(struct
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path);
+	error = PROC_I(inode)->op.proc_get_link(dentry, &nd->path);
 out:
 	return ERR_PTR(error);
 }
@@ -1642,7 +1642,7 @@ static int proc_pid_readlink(struct dent
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &path);
+	error = PROC_I(inode)->op.proc_get_link(dentry, &path);
 	if (error)
 		goto out;
 
@@ -1980,9 +1980,9 @@ out_task:
 	return rc;
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
Subject: Subject: procfs: make proc_get_link to use dentry instead of inode

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch

