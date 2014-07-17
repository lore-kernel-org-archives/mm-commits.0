From: akpm@linux-foundation.org
Subject: + proc-convert-proc-pid-io-to-seq_file-interface.patch added to
 -mm tree
Date: Thu, 17 Jul 2014 15:54:39 -0700
Message-ID: <53c8542f.K2IRFFHC/UyOU7C/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:34501 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbaGQWyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:40 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so1211359iec.3
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/io to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-pid-io-to-seq_file-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-convert-proc-pid-io-to-seq_file-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-proc-pid-io-to-seq_file-interface.patch

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
Subject: proc: convert /proc/$PID/io to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-io-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-io-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -2399,7 +2399,7 @@ static const struct file_operations proc
 #endif
 
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
+static int do_io_accounting(struct task_struct *task, struct seq_file *m, int whole)
 {
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
@@ -2423,7 +2423,7 @@ static int do_io_accounting(struct task_
 
 		unlock_task_sighand(task, &flags);
 	}
-	result = sprintf(buffer,
+	result = seq_printf(m,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
@@ -2443,14 +2443,16 @@ out_unlock:
 	return result;
 }
 
-static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
+static int proc_tid_io_accounting(struct seq_file *m, struct pid_namespace *ns,
+				  struct pid *pid, struct task_struct *task)
 {
-	return do_io_accounting(task, buffer, 0);
+	return do_io_accounting(task, m, 0);
 }
 
-static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
+static int proc_tgid_io_accounting(struct seq_file *m, struct pid_namespace *ns,
+				   struct pid *pid, struct task_struct *task)
 {
-	return do_io_accounting(task, buffer, 1);
+	return do_io_accounting(task, m, 1);
 }
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
 
@@ -2632,7 +2634,7 @@ static const struct pid_entry tgid_base_
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUSR, proc_tgid_io_accounting),
+	ONE("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
 	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
@@ -2967,7 +2969,7 @@ static const struct pid_entry tid_base_s
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUSR, proc_tid_io_accounting),
+	ONE("io",	S_IRUSR, proc_tid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
 	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
_

Patches currently in -mm which might be from adobriyan@gmail.com are

lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
proc-add-and-remove-proc-entry-create-checks.patch
proc-faster-proc-pid-lookup.patch
proc-make-proc_subdir_lock-static.patch
proc-remove-proc_tty_ldisc-variable.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
proc-more-const-char-pointers.patch
proc-convert-proc-pid-auxv-to-seq_file-interface.patch
proc-convert-proc-pid-limits-to-seq_file-interface.patch
proc-convert-proc-pid-syscall-to-seq_file-interface.patch
proc-fix-page_size-limit-of-proc-pid-cmdline.patch
proc-convert-proc-pid-wchan-to-seq_file-interface.patch
proc-convert-proc-pid-schedstat-to-seq_file-interface.patch
proc-convert-proc-pid-oom_score-to-seq_file-interface.patch
proc-convert-proc-pid-io-to-seq_file-interface.patch
proc-convert-proc-pid-hardwall-to-seq_file-interface.patch
proc-remove-inf-macro.patch

