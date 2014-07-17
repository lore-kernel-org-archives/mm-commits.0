From: akpm@linux-foundation.org
Subject: + proc-convert-proc-pid-auxv-to-seq_file-interface.patch added to -mm tree
Date: Thu, 17 Jul 2014 15:54:32 -0700
Message-ID: <53c85428.O8z9y2i96hkiX7io%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55473 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbaGQWyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:33 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so439323yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/auxv to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-pid-auxv-to-seq_file-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-convert-proc-pid-auxv-to-seq_file-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-proc-pid-auxv-to-seq_file-interface.patch

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
Subject: proc: convert /proc/$PID/auxv to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-auxv-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-auxv-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -205,22 +205,20 @@ static int proc_pid_cmdline(struct task_
 	return get_cmdline(task, buffer, PAGE_SIZE);
 }
 
-static int proc_pid_auxv(struct task_struct *task, char *buffer)
+static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
+			 struct pid *pid, struct task_struct *task)
 {
 	struct mm_struct *mm = mm_access(task, PTRACE_MODE_READ);
-	int res = PTR_ERR(mm);
 	if (mm && !IS_ERR(mm)) {
 		unsigned int nwords = 0;
 		do {
 			nwords += 2;
 		} while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
-		res = nwords * sizeof(mm->saved_auxv[0]);
-		if (res > PAGE_SIZE)
-			res = PAGE_SIZE;
-		memcpy(buffer, mm->saved_auxv, res);
+		seq_write(m, mm->saved_auxv, nwords * sizeof(mm->saved_auxv[0]));
 		mmput(mm);
-	}
-	return res;
+		return 0;
+	} else
+		return PTR_ERR(mm);
 }
 
 
@@ -2557,7 +2555,7 @@ static const struct pid_entry tgid_base_
 	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
 #endif
 	REG("environ",    S_IRUSR, proc_environ_operations),
-	INF("auxv",       S_IRUSR, proc_pid_auxv),
+	ONE("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
 	INF("limits",	  S_IRUGO, proc_pid_limits),
@@ -2896,7 +2894,7 @@ static const struct pid_entry tid_base_s
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	 S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
 	REG("environ",   S_IRUSR, proc_environ_operations),
-	INF("auxv",      S_IRUSR, proc_pid_auxv),
+	ONE("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
 	INF("limits",	 S_IRUGO, proc_pid_limits),
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

