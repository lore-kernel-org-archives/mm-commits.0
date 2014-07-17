From: akpm@linux-foundation.org
Subject: + proc-convert-proc-pid-syscall-to-seq_file-interface.patch added to -mm tree
Date: Thu, 17 Jul 2014 15:54:34 -0700
Message-ID: <53c8542a.udmqFWppEhGf6t1a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:58536 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbaGQWyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:35 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so363024oah.2
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/syscall to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-pid-syscall-to-seq_file-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-convert-proc-pid-syscall-to-seq_file-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-proc-pid-syscall-to-seq_file-interface.patch

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
Subject: proc: convert /proc/$PID/syscall to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-syscall-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-syscall-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -482,7 +482,8 @@ static int proc_pid_limits(struct seq_fi
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-static int proc_pid_syscall(struct task_struct *task, char *buffer)
+static int proc_pid_syscall(struct seq_file *m, struct pid_namespace *ns,
+			    struct pid *pid, struct task_struct *task)
 {
 	long nr;
 	unsigned long args[6], sp, pc;
@@ -491,11 +492,11 @@ static int proc_pid_syscall(struct task_
 		return res;
 
 	if (task_current_syscall(task, &nr, args, 6, &sp, &pc))
-		res = sprintf(buffer, "running\n");
+		seq_puts(m, "running\n");
 	else if (nr < 0)
-		res = sprintf(buffer, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
+		seq_printf(m, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
 	else
-		res = sprintf(buffer,
+		seq_printf(m,
 		       "%ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
 		       nr,
 		       args[0], args[1], args[2], args[3], args[4], args[5],
@@ -2564,7 +2565,7 @@ static const struct pid_entry tgid_base_
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",    S_IRUSR, proc_pid_syscall),
+	ONE("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
@@ -2900,7 +2901,7 @@ static const struct pid_entry tid_base_s
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",   S_IRUSR, proc_pid_syscall),
+	ONE("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
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

