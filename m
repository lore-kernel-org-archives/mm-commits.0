From: akpm@linux-foundation.org
Subject: + proc-convert-proc-pid-cmdline-to-seq_file-interface.patch added to -mm tree
Date: Mon, 21 Jul 2014 13:00:45 -0700
Message-ID: <53cd716d.RFmi/Ah5zeaJzmuP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:55987 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbaGUUAs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 16:00:48 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1591161oah.0
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 13:00:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/cmdline to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-pid-cmdline-to-seq_file-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-convert-proc-pid-cmdline-to-seq_file-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-proc-pid-cmdline-to-seq_file-interface.patch

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
Subject: proc: convert /proc/$PID/cmdline to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-cmdline-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-cmdline-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -200,9 +200,16 @@ static int proc_root_link(struct dentry
 	return result;
 }
 
-static int proc_pid_cmdline(struct task_struct *task, char *buffer)
+static int proc_pid_cmdline(struct seq_file *m, struct pid_namespace *ns,
+			    struct pid *pid, struct task_struct *task)
 {
-	return get_cmdline(task, buffer, PAGE_SIZE);
+	/*
+	 * Rely on struct seq_operations::show() being called once
+	 * per internal buffer allocation. See single_open(), traverse().
+	 */
+	BUG_ON(m->size < PAGE_SIZE);
+	m->count += get_cmdline(task, m->buf, PAGE_SIZE);
+	return 0;
 }
 
 static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
@@ -2567,7 +2574,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
+	ONE("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
@@ -2903,7 +2910,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
+	ONE("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
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
proc-convert-proc-pid-cmdline-to-seq_file-interface.patch
proc-convert-proc-pid-wchan-to-seq_file-interface.patch
proc-convert-proc-pid-schedstat-to-seq_file-interface.patch
proc-convert-proc-pid-oom_score-to-seq_file-interface.patch
proc-convert-proc-pid-io-to-seq_file-interface.patch
proc-convert-proc-pid-hardwall-to-seq_file-interface.patch
proc-remove-inf-macro.patch

