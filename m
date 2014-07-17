From: akpm@linux-foundation.org
Subject: + proc-convert-proc-pid-oom_score-to-seq_file-interface.patch
 added to -mm tree
Date: Thu, 17 Jul 2014 15:54:38 -0700
Message-ID: <53c8542e.qWxSCfGq770Z85I+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:62519 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990AbaGQWyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:40 -0400
Received: by mail-vc0-f201.google.com with SMTP id hu12so444799vcb.0
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/oom_score to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-pid-oom_score-to-seq_file-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-convert-proc-pid-oom_score-to-seq_file-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-proc-pid-oom_score-to-seq_file-interface.patch

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
Subject: proc: convert /proc/$PID/oom_score to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-oom_score-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-oom_score-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -412,7 +412,8 @@ static const struct file_operations proc
 };
 #endif
 
-static int proc_oom_score(struct task_struct *task, char *buffer)
+static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
+			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long totalpages = totalram_pages + total_swap_pages;
 	unsigned long points = 0;
@@ -422,7 +423,7 @@ static int proc_oom_score(struct task_st
 		points = oom_badness(task, NULL, NULL, totalpages) *
 						1000 / totalpages;
 	read_unlock(&tasklist_lock);
-	return sprintf(buffer, "%lu\n", points);
+	return seq_printf(m, "%lu\n", points);
 }
 
 struct limit_names {
@@ -2617,7 +2618,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_CGROUPS
 	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
 #endif
-	INF("oom_score",  S_IRUGO, proc_oom_score),
+	ONE("oom_score",  S_IRUGO, proc_oom_score),
 	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adj_operations),
 	REG("oom_score_adj", S_IRUGO|S_IWUSR, proc_oom_score_adj_operations),
 #ifdef CONFIG_AUDITSYSCALL
@@ -2955,7 +2956,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_CGROUPS
 	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
 #endif
-	INF("oom_score", S_IRUGO, proc_oom_score),
+	ONE("oom_score", S_IRUGO, proc_oom_score),
 	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adj_operations),
 	REG("oom_score_adj", S_IRUGO|S_IWUSR, proc_oom_score_adj_operations),
 #ifdef CONFIG_AUDITSYSCALL
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

