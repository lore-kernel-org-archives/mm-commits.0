From: akpm@linux-foundation.org
Subject: + proc-convert-proc-pid-schedstat-to-seq_file-interface.patch
 added to -mm tree
Date: Thu, 17 Jul 2014 15:54:37 -0700
Message-ID: <53c8542d.F/VVNQUojQACy4eV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:63226 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983AbaGQWyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:38 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so833950pab.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/schedstat to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-pid-schedstat-to-seq_file-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-convert-proc-pid-schedstat-to-seq_file-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-proc-pid-schedstat-to-seq_file-interface.patch

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
Subject: proc: convert /proc/$PID/schedstat to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-schedstat-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-schedstat-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -311,9 +311,10 @@ static int proc_pid_stack(struct seq_fil
 /*
  * Provides /proc/PID/schedstat
  */
-static int proc_pid_schedstat(struct task_struct *task, char *buffer)
+static int proc_pid_schedstat(struct seq_file *m, struct pid_namespace *ns,
+			      struct pid *pid, struct task_struct *task)
 {
-	return sprintf(buffer, "%llu %llu %lu\n",
+	return seq_printf(m, "%llu %llu %lu\n",
 			(unsigned long long)task->se.sum_exec_runtime,
 			(unsigned long long)task->sched_info.run_delay,
 			task->sched_info.pcount);
@@ -2605,7 +2606,7 @@ static const struct pid_entry tgid_base_
 	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
-	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
+	ONE("schedstat",  S_IRUGO, proc_pid_schedstat),
 #endif
 #ifdef CONFIG_LATENCYTOP
 	REG("latency",  S_IRUGO, proc_lstats_operations),
@@ -2943,7 +2944,7 @@ static const struct pid_entry tid_base_s
 	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
-	INF("schedstat", S_IRUGO, proc_pid_schedstat),
+	ONE("schedstat", S_IRUGO, proc_pid_schedstat),
 #endif
 #ifdef CONFIG_LATENCYTOP
 	REG("latency",  S_IRUGO, proc_lstats_operations),
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

