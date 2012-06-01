From: akpm@linux-foundation.org
Subject: [merged] proc-clean-up-proc-pid-environ-handling.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:48 -0700
Message-ID: <20120601193348.5E731A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:52311 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2FATdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:49 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so244305vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, hughd@google.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: clean up /proc/<pid>/environ handling
has been removed from the -mm tree.  Its filename was
     proc-clean-up-proc-pid-environ-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: proc: clean up /proc/<pid>/environ handling

Similar to e268337dfe2 ("proc: clean up and fix /proc/<pid>/mem
handling"), move the check of permission to open(), this will simplify
read() code.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff -puN fs/proc/base.c~proc-clean-up-proc-pid-environ-handling fs/proc/base.c
--- a/fs/proc/base.c~proc-clean-up-proc-pid-environ-handling
+++ a/fs/proc/base.c
@@ -679,7 +679,7 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
-static int mem_open(struct inode* inode, struct file* file)
+static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
 {
 	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 	struct mm_struct *mm;
@@ -687,7 +687,7 @@ static int mem_open(struct inode* inode,
 	if (!task)
 		return -ESRCH;
 
-	mm = mm_access(task, PTRACE_MODE_ATTACH);
+	mm = mm_access(task, mode);
 	put_task_struct(task);
 
 	if (IS_ERR(mm))
@@ -707,6 +707,11 @@ static int mem_open(struct inode* inode,
 	return 0;
 }
 
+static int mem_open(struct inode *inode, struct file *file)
+{
+	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
+}
+
 static ssize_t mem_rw(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos, int write)
 {
@@ -803,30 +808,29 @@ static const struct file_operations proc
 	.release	= mem_release,
 };
 
+static int environ_open(struct inode *inode, struct file *file)
+{
+	return __mem_open(inode, file, PTRACE_MODE_READ);
+}
+
 static ssize_t environ_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
 	char *page;
 	unsigned long src = *ppos;
-	int ret = -ESRCH;
-	struct mm_struct *mm;
+	int ret = 0;
+	struct mm_struct *mm = file->private_data;
 
-	if (!task)
-		goto out_no_task;
+	if (!mm)
+		return 0;
 
-	ret = -ENOMEM;
 	page = (char *)__get_free_page(GFP_TEMPORARY);
 	if (!page)
-		goto out;
-
-
-	mm = mm_for_maps(task);
-	ret = PTR_ERR(mm);
-	if (!mm || IS_ERR(mm))
-		goto out_free;
+		return -ENOMEM;
 
 	ret = 0;
+	if (!atomic_inc_not_zero(&mm->mm_users))
+		goto free;
 	while (count > 0) {
 		int this_len, retval, max_len;
 
@@ -838,7 +842,7 @@ static ssize_t environ_read(struct file 
 		max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		this_len = (this_len > max_len) ? max_len : this_len;
 
-		retval = access_process_vm(task, (mm->env_start + src),
+		retval = access_remote_vm(mm, (mm->env_start + src),
 			page, this_len, 0);
 
 		if (retval <= 0) {
@@ -857,19 +861,18 @@ static ssize_t environ_read(struct file 
 		count -= retval;
 	}
 	*ppos = src;
-
 	mmput(mm);
-out_free:
+
+free:
 	free_page((unsigned long) page);
-out:
-	put_task_struct(task);
-out_no_task:
 	return ret;
 }
 
 static const struct file_operations proc_environ_operations = {
+	.open		= environ_open,
 	.read		= environ_read,
 	.llseek		= generic_file_llseek,
+	.release	= mem_release,
 };
 
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
shmem-replace_page-must-flush_dcache-and-others.patch
fs-move-file_remove_suid-to-fs-inodec.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch

