From: akpm@linux-foundation.org
Subject: + proc-convert-proc-pid-wchan-to-seq_file-interface.patch added
 to -mm tree
Date: Thu, 17 Jul 2014 15:54:36 -0700
Message-ID: <53c8542c.yQz3UhYYS+5EIUVl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41235 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbaGQWyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:37 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so328462vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/wchan to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-pid-wchan-to-seq_file-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-convert-proc-pid-wchan-to-seq_file-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-proc-pid-wchan-to-seq_file-interface.patch

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
Subject: proc: convert /proc/$PID/wchan to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-wchan-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-wchan-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -235,7 +235,8 @@ static int proc_pid_auxv(struct seq_file
  * Provides a wchan file via kallsyms in a proper one-value-per-file format.
  * Returns the resolved symbol.  If that fails, simply return the address.
  */
-static int proc_pid_wchan(struct task_struct *task, char *buffer)
+static int proc_pid_wchan(struct seq_file *m, struct pid_namespace *ns,
+			  struct pid *pid, struct task_struct *task)
 {
 	unsigned long wchan;
 	char symname[KSYM_NAME_LEN];
@@ -246,9 +247,9 @@ static int proc_pid_wchan(struct task_st
 		if (!ptrace_may_access(task, PTRACE_MODE_READ))
 			return 0;
 		else
-			return sprintf(buffer, "%lu", wchan);
+			return seq_printf(m, "%lu", wchan);
 	else
-		return sprintf(buffer, "%s", symname);
+		return seq_printf(m, "%s", symname);
 }
 #endif /* CONFIG_KALLSYMS */
 
@@ -2598,7 +2599,7 @@ static const struct pid_entry tgid_base_
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
-	INF("wchan",      S_IRUGO, proc_pid_wchan),
+	ONE("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
 	ONE("stack",      S_IRUSR, proc_pid_stack),
@@ -2936,7 +2937,7 @@ static const struct pid_entry tid_base_s
 	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
 #endif
 #ifdef CONFIG_KALLSYMS
-	INF("wchan",     S_IRUGO, proc_pid_wchan),
+	ONE("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
 	ONE("stack",      S_IRUSR, proc_pid_stack),
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

