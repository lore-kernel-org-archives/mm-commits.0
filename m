From: akpm@linux-foundation.org
Subject: + dont-truncate-proc-pid-environ-at-4096-characters.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:28:42 -0700
Message-ID: <200709262228.l8QMSgdS007155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbXIZW3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james-p@moving-picture.com, aarapov@redhat.com, adobriyan@gmail.com, hpa@zytor.com, jengelh@computergmbh.de, randy.dunlap@oracle.com


The patch titled
     Don't truncate /proc/PID/environ at 4096 characters
has been added to the -mm tree.  Its filename is
     dont-truncate-proc-pid-environ-at-4096-characters.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Don't truncate /proc/PID/environ at 4096 characters
From: "James Pearson" <james-p@moving-picture.com>

/proc/PID/environ currently truncates at 4096 characters, patch based on
the /proc/PID/mem code.

Signed-off-by: James Pearson <james-p@moving-picture.com>
Cc: Anton Arapov <aarapov@redhat.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/proc/base.c~dont-truncate-proc-pid-environ-at-4096-characters fs/proc/base.c
--- a/fs/proc/base.c~dont-truncate-proc-pid-environ-at-4096-characters
+++ a/fs/proc/base.c
@@ -199,27 +199,6 @@ static int proc_root_link(struct inode *
 	 (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
 	 security_ptrace(current,task) == 0))
 
-static int proc_pid_environ(struct task_struct *task, char * buffer)
-{
-	int res = 0;
-	struct mm_struct *mm = get_task_mm(task);
-	if (mm) {
-		unsigned int len;
-
-		res = -ESRCH;
-		if (!ptrace_may_attach(task))
-			goto out;
-
-		len  = mm->env_end - mm->env_start;
-		if (len > PAGE_SIZE)
-			len = PAGE_SIZE;
-		res = access_process_vm(task, mm->env_start, buffer, len, 0);
-out:
-		mmput(mm);
-	}
-	return res;
-}
-
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
 {
 	int res = 0;
@@ -658,6 +637,76 @@ static const struct file_operations proc
 	.open		= mem_open,
 };
 
+static ssize_t environ_read(struct file *file, char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	char *page;
+	unsigned long src = *ppos;
+	int ret = -ESRCH;
+	struct mm_struct *mm;
+
+	if (!task)
+		goto out_no_task;
+
+	if (!ptrace_may_attach(task))
+		goto out;
+
+	ret = -ENOMEM;
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page)
+		goto out;
+
+	ret = 0;
+
+	mm = get_task_mm(task);
+	if (!mm)
+		goto out_free;
+
+	while (count > 0) {
+		int this_len, retval, max_len;
+
+		this_len = mm->env_end - (mm->env_start + src);
+
+		if (this_len <= 0)
+			break;
+
+		max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
+		this_len = (this_len > max_len) ? max_len : this_len;
+
+		retval = access_process_vm(task, (mm->env_start + src),
+			page, this_len, 0);
+
+		if (retval <= 0) {
+			ret = retval;
+			break;
+		}
+
+		if (copy_to_user(buf, page, retval)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		ret += retval;
+		src += retval;
+		buf += retval;
+		count -= retval;
+	}
+	*ppos = src;
+
+	mmput(mm);
+out_free:
+	free_page((unsigned long) page);
+out:
+	put_task_struct(task);
+out_no_task:
+	return ret;
+}
+
+static const struct file_operations proc_environ_operations = {
+	.read		= environ_read,
+};
+
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -2013,7 +2062,7 @@ static const struct pid_entry tgid_base_
 	DIR("task",       S_IRUGO|S_IXUGO, task),
 	DIR("fd",         S_IRUSR|S_IXUSR, fd),
 	DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
-	INF("environ",    S_IRUSR, pid_environ),
+	REG("environ",    S_IRUSR, environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	INF("status",     S_IRUGO, pid_status),
 #ifdef CONFIG_SCHED_DEBUG
@@ -2303,7 +2352,7 @@ out_no_task:
 static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, fd),
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, fdinfo),
-	INF("environ",   S_IRUSR, pid_environ),
+	REG("environ",   S_IRUSR, environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	INF("status",    S_IRUGO, pid_status),
 #ifdef CONFIG_SCHED_DEBUG
_

Patches currently in -mm which might be from james-p@moving-picture.com are

dont-truncate-proc-pid-environ-at-4096-characters.patch
