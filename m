From: akpm@linux-foundation.org
Subject: + proc-clean-up-proc-pid-environ-handling.patch added to -mm tree
Date: Tue, 31 Jan 2012 12:37:47 -0800
Message-ID: <20120131203747.C7781A0159@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:61770 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab2AaUhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 15:37:48 -0500
Received: by yhgm50 with SMTP id m50so55069yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2012 12:37:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, adobriyan@gmail.com


The patch titled
     Subject: proc: clean up /proc/<pid>/environ handling
has been added to the -mm tree.  Its filename is
     proc-clean-up-proc-pid-environ-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -835,28 +835,38 @@ static const struct file_operations proc
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
@@ -870,7 +880,7 @@ static ssize_t environ_read(struct file 
 		max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		this_len = (this_len > max_len) ? max_len : this_len;
 
-		retval = access_process_vm(task, (mm->env_start + src),
+		retval = access_remote_vm(mm, (mm->env_start + src),
 			page, this_len, 0);
 
 		if (retval <= 0) {
@@ -890,18 +900,23 @@ static ssize_t environ_read(struct file 
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
Subject: Subject: proc: clean up /proc/<pid>/environ handling

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held.patch
x86-mm-fix-the-size-calculation-of-mapping-tables.patch
kcore-make-get_sparsemem_vmemmap_info-static.patch
proc-clean-up-proc-pid-environ-handling.patch

