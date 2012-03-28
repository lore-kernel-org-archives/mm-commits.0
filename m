From: akpm@linux-foundation.org
Subject: [to-be-updated] proc-clean-up-proc-pid-environ-handling.patch removed from -mm tree
Date: Wed, 28 Mar 2012 15:39:50 -0700
Message-ID: <20120328223951.22070A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:56846 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758899Ab2C1Wjx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 18:39:53 -0400
Received: by wibhj13 with SMTP id hj13so83173wib.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 15:39:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: clean up /proc/<pid>/environ handling
has been removed from the -mm tree.  Its filename was
     proc-clean-up-proc-pid-environ-handling.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: proc: clean up /proc/<pid>/environ handling

Similar to e268337dfe2 ("proc: clean up and fix /proc/<pid>/mem
handling"), move the check of permission to open(), this will simplify
read() code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   55 +++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff -puN fs/proc/base.c~proc-clean-up-proc-pid-environ-handling fs/proc/base.c
--- a/fs/proc/base.c~proc-clean-up-proc-pid-environ-handling
+++ a/fs/proc/base.c
@@ -801,28 +801,38 @@ static const struct file_operations proc
 	.release	= mem_release,
 };
 
+static int environ_open(struct inode *inode, struct file *file)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	struct mm_struct *mm;
+
+	if (!task)
+		return -ESRCH;
+
+	mm = mm_for_maps(task);
+	put_task_struct(task);
+
+	if (!mm)
+		return -ENOENT;
+	if (IS_ERR(mm))
+		return PTR_ERR(mm);
+
+	file->private_data = mm;
+
+	return 0;
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
-
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
 	while (count > 0) {
@@ -836,7 +846,7 @@ static ssize_t environ_read(struct file 
 		max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		this_len = (this_len > max_len) ? max_len : this_len;
 
-		retval = access_process_vm(task, (mm->env_start + src),
+		retval = access_remote_vm(mm, (mm->env_start + src),
 			page, this_len, 0);
 
 		if (retval <= 0) {
@@ -856,18 +866,23 @@ static ssize_t environ_read(struct file 
 	}
 	*ppos = src;
 
-	mmput(mm);
-out_free:
 	free_page((unsigned long) page);
-out:
-	put_task_struct(task);
-out_no_task:
 	return ret;
 }
 
+static int environ_release(struct inode *inode, struct file *file)
+{
+	struct mm_struct *mm = file->private_data;
+
+	mmput(mm);
+	return 0;
+}
+
 static const struct file_operations proc_environ_operations = {
+	.open		= environ_open,
 	.read		= environ_read,
 	.llseek		= generic_file_llseek,
+	.release	= environ_release,
 };
 
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
kdump-x86-fix-total-mem-size-calculation-for-reservation.patch
linux-next.patch
cris-select-generic_atomic64.patch

