From: akpm@linux-foundation.org
Subject: [merged] proc-convert-proc-pid-io-to-seq_file-interface.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:12 -0700
Message-ID: <53ea6d9c.xjGLCiBleYQsfZQH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:45623 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbaHLTkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:13 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2673465pde.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/io to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-pid-io-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2398,7 +2398,7 @@ static const struct file_operations proc
 #endif
 
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
+static int do_io_accounting(struct task_struct *task, struct seq_file *m, int whole)
 {
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
@@ -2422,7 +2422,7 @@ static int do_io_accounting(struct task_
 
 		unlock_task_sighand(task, &flags);
 	}
-	result = sprintf(buffer,
+	result = seq_printf(m,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
@@ -2442,14 +2442,16 @@ out_unlock:
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
 
@@ -2631,7 +2633,7 @@ static const struct pid_entry tgid_base_
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUSR, proc_tgid_io_accounting),
+	ONE("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
 	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
@@ -2966,7 +2968,7 @@ static const struct pid_entry tid_base_s
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

origin.patch

