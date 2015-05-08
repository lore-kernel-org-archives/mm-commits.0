From: akpm@linux-foundation.org
Subject: + proc-fix-page_size-limit-of-proc-pid-cmdline.patch added to -mm tree
Date: Fri, 08 May 2015 14:32:50 -0700
Message-ID: <554d2b82.MDkE3rI1b/R73PO5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbbEHVcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2015 17:32:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, jarod@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix PAGE_SIZE limit of /proc/$PID/cmdline
has been added to the -mm tree.  Its filename is
     proc-fix-page_size-limit-of-proc-pid-cmdline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-fix-page_size-limit-of-proc-pid-cmdline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-page_size-limit-of-proc-pid-cmdline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fix PAGE_SIZE limit of /proc/$PID/cmdline

/proc/$PID/cmdline truncates output at PAGE_SIZE. It is easy to see with

	$ cat /proc/self/cmdline $(seq 1037) 2>/dev/null

However, command line size was never limited to PAGE_SIZE but to 128 KB and
relatively recently limitation was removed altogether.

People noticed and ask questions:
http://stackoverflow.com/questions/199130/how-do-i-increase-the-proc-pid-cmdline-4096-byte-limit

seq file interface is not OK, because it kmalloc's for whole output and
open + read(, 1) + sleep will pin arbitrary amounts of kernel memory.
To not do that, limit must be imposed which is incompatible with
arbitrary sized command lines.

I apologize for hairy code, but this it direct consequence of command line
layout in memory and hacks to support things like "init [3]".

The loops are "unrolled" otherwise it is either macros which hide
control flow or functions with 7-8 arguments with equal line count.

There should be real setproctitle(2) or something.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Jarod Wilson <jarod@redhat.com>
Acked-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |  203 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 194 insertions(+), 9 deletions(-)

diff -puN fs/proc/base.c~proc-fix-page_size-limit-of-proc-pid-cmdline fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-page_size-limit-of-proc-pid-cmdline
+++ a/fs/proc/base.c
@@ -196,18 +196,203 @@ static int proc_root_link(struct dentry
 	return result;
 }
 
-static int proc_pid_cmdline(struct seq_file *m, struct pid_namespace *ns,
-			    struct pid *pid, struct task_struct *task)
+static ssize_t proc_pid_cmdline_read(struct file *file, char __user *buf,
+				     size_t count, loff_t *pos)
 {
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	char *page;
+	unsigned long arg_start, arg_end, env_start, env_end;
+	unsigned long len1, len2, len;
+	unsigned long p;
+	char c;
+	ssize_t rv;
+
+	BUG_ON(*pos < 0);
+
+	tsk = get_proc_task(file_inode(file));
+	if (!tsk)
+		return -ESRCH;
+	mm = get_task_mm(tsk);
+	put_task_struct(tsk);
+	if (!mm)
+		return 0;
+	if (!mm->arg_end) {
+		rv = 0;
+		goto out_mmput;
+	}
+
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page) {
+		rv = -ENOMEM;
+		goto out_mmput;
+	}
+
+	down_read(&mm->mmap_sem);
+	arg_start = mm->arg_start;
+	arg_end = mm->arg_end;
+	env_start = mm->env_start;
+	env_end = mm->env_end;
+	up_read(&mm->mmap_sem);
+
+	BUG_ON(arg_start > arg_end);
+	BUG_ON(env_start > env_end);
+
+	len1 = arg_end - arg_start;
+	len2 = env_end - env_start;
+
 	/*
-	 * Rely on struct seq_operations::show() being called once
-	 * per internal buffer allocation. See single_open(), traverse().
+	 * Inherently racy -- command line shares address space
+	 * with code and data.
 	 */
-	BUG_ON(m->size < PAGE_SIZE);
-	m->count += get_cmdline(task, m->buf, PAGE_SIZE);
-	return 0;
+	rv = access_remote_vm(mm, arg_end - 1, &c, 1, 0);
+	if (rv <= 0)
+		goto out_free_page;
+
+	rv = 0;
+
+	if (c == '\0') {
+		/* Command line (set of strings) occupies whole ARGV. */
+		if (len1 <= *pos)
+			goto out_free_page;
+
+		p = arg_start + *pos;
+		len = len1 - *pos;
+		while (count > 0 && len > 0) {
+			unsigned int _count;
+			int nr_read;
+
+			_count = min3(count, len, PAGE_SIZE);
+			nr_read = access_remote_vm(mm, p, page, _count, 0);
+			if (nr_read < 0)
+				rv = nr_read;
+			if (nr_read <= 0)
+				goto out_free_page;
+
+			if (copy_to_user(buf, page, nr_read)) {
+				rv = -EFAULT;
+				goto out_free_page;
+			}
+
+			p	+= nr_read;
+			len	-= nr_read;
+			buf	+= nr_read;
+			count	-= nr_read;
+			rv	+= nr_read;
+		}
+	} else {
+		/*
+		 * Command line (1 string) occupies ARGV and maybe
+		 * extends into ENVP.
+		 */
+		if (len1 + len2 <= *pos)
+			goto skip_argv_envp;
+		if (len1 <= *pos)
+			goto skip_argv;
+
+		p = arg_start + *pos;
+		len = len1 - *pos;
+		while (count > 0 && len > 0) {
+			unsigned int _count, l;
+			int nr_read;
+			bool final;
+
+			_count = min3(count, len, PAGE_SIZE);
+			nr_read = access_remote_vm(mm, p, page, _count, 0);
+			if (nr_read < 0)
+				rv = nr_read;
+			if (nr_read <= 0)
+				goto out_free_page;
+
+			/*
+			 * Command line can be shorter than whole ARGV
+			 * even if last "marker" byte says it is not.
+			 */
+			final = false;
+			l = strnlen(page, nr_read);
+			if (l < nr_read) {
+				nr_read = l;
+				final = true;
+			}
+
+			if (copy_to_user(buf, page, nr_read)) {
+				rv = -EFAULT;
+				goto out_free_page;
+			}
+
+			p	+= nr_read;
+			len	-= nr_read;
+			buf	+= nr_read;
+			count	-= nr_read;
+			rv	+= nr_read;
+
+			if (final)
+				goto out_free_page;
+		}
+skip_argv:
+		/*
+		 * Command line (1 string) occupies ARGV and
+		 * extends into ENVP.
+		 */
+		if (len1 <= *pos) {
+			p = env_start + *pos - len1;
+			len = len1 + len2 - *pos;
+		} else {
+			p = env_start;
+			len = len2;
+		}
+		while (count > 0 && len > 0) {
+			unsigned int _count, l;
+			int nr_read;
+			bool final;
+
+			_count = min3(count, len, PAGE_SIZE);
+			nr_read = access_remote_vm(mm, p, page, _count, 0);
+			if (nr_read < 0)
+				rv = nr_read;
+			if (nr_read <= 0)
+				goto out_free_page;
+
+			/* Find EOS. */
+			final = false;
+			l = strnlen(page, nr_read);
+			if (l < nr_read) {
+				nr_read = l;
+				final = true;
+			}
+
+			if (copy_to_user(buf, page, nr_read)) {
+				rv = -EFAULT;
+				goto out_free_page;
+			}
+
+			p	+= nr_read;
+			len	-= nr_read;
+			buf	+= nr_read;
+			count	-= nr_read;
+			rv	+= nr_read;
+
+			if (final)
+				goto out_free_page;
+		}
+skip_argv_envp:
+		;
+	}
+
+out_free_page:
+	free_page((unsigned long)page);
+out_mmput:
+	mmput(mm);
+	if (rv > 0)
+		*pos += rv;
+	return rv;
 }
 
+static const struct file_operations proc_pid_cmdline_ops = {
+	.read	= proc_pid_cmdline_read,
+	.llseek	= generic_file_llseek,
+};
+
 static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
 			 struct pid *pid, struct task_struct *task)
 {
@@ -2572,7 +2757,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
-	ONE("cmdline",    S_IRUGO, proc_pid_cmdline),
+	REG("cmdline",    S_IRUGO, proc_pid_cmdline_ops),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
@@ -2918,7 +3103,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
-	ONE("cmdline",   S_IRUGO, proc_pid_cmdline),
+	REG("cmdline",   S_IRUGO, proc_pid_cmdline_ops),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
kstrto-accept-0-for-signed-conversion.patch
proc-fix-page_size-limit-of-proc-pid-cmdline.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch

