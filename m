From: akpm@linux-foundation.org
Subject: + proc-convert-proc-pid-limits-to-seq_file-interface.patch added
 to -mm tree
Date: Thu, 17 Jul 2014 15:54:33 -0700
Message-ID: <53c85429.cWiuvJKrFLoJCNju%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:64309 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbaGQWye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:34 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so826941pab.4
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/limits to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-pid-limits-to-seq_file-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-convert-proc-pid-limits-to-seq_file-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-proc-pid-limits-to-seq_file-interface.patch

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
Subject: proc: convert /proc/$PID/limits to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-limits-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-limits-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -440,12 +440,11 @@ static const struct limit_names lnames[R
 };
 
 /* Display limits for a process */
-static int proc_pid_limits(struct task_struct *task, char *buffer)
+static int proc_pid_limits(struct seq_file *m, struct pid_namespace *ns,
+			   struct pid *pid, struct task_struct *task)
 {
 	unsigned int i;
-	int count = 0;
 	unsigned long flags;
-	char *bufptr = buffer;
 
 	struct rlimit rlim[RLIM_NLIMITS];
 
@@ -457,31 +456,29 @@ static int proc_pid_limits(struct task_s
 	/*
 	 * print the file header
 	 */
-	count += sprintf(&bufptr[count], "%-25s %-20s %-20s %-10s\n",
+       seq_printf(m, "%-25s %-20s %-20s %-10s\n",
 			"Limit", "Soft Limit", "Hard Limit", "Units");
 
 	for (i = 0; i < RLIM_NLIMITS; i++) {
 		if (rlim[i].rlim_cur == RLIM_INFINITY)
-			count += sprintf(&bufptr[count], "%-25s %-20s ",
+			seq_printf(m, "%-25s %-20s ",
 					 lnames[i].name, "unlimited");
 		else
-			count += sprintf(&bufptr[count], "%-25s %-20lu ",
+			seq_printf(m, "%-25s %-20lu ",
 					 lnames[i].name, rlim[i].rlim_cur);
 
 		if (rlim[i].rlim_max == RLIM_INFINITY)
-			count += sprintf(&bufptr[count], "%-20s ", "unlimited");
+			seq_printf(m, "%-20s ", "unlimited");
 		else
-			count += sprintf(&bufptr[count], "%-20lu ",
-					 rlim[i].rlim_max);
+			seq_printf(m, "%-20lu ", rlim[i].rlim_max);
 
 		if (lnames[i].unit)
-			count += sprintf(&bufptr[count], "%-10s\n",
-					 lnames[i].unit);
+			seq_printf(m, "%-10s\n", lnames[i].unit);
 		else
-			count += sprintf(&bufptr[count], "\n");
+			seq_putc(m, '\n');
 	}
 
-	return count;
+	return 0;
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
@@ -2558,7 +2555,7 @@ static const struct pid_entry tgid_base_
 	ONE("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	  S_IRUGO, proc_pid_limits),
+	ONE("limits",	  S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -2897,7 +2894,7 @@ static const struct pid_entry tid_base_s
 	ONE("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	 S_IRUGO, proc_pid_limits),
+	ONE("limits",	 S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
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

