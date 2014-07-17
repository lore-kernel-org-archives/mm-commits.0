From: akpm@linux-foundation.org
Subject: + proc-fix-page_size-limit-of-proc-pid-cmdline.patch added to -mm tree
Date: Thu, 17 Jul 2014 15:54:35 -0700
Message-ID: <53c8542b.TDbG9pAO+EbnLuIz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35528 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbaGQWyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:37 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so439453qaq.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


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

Convert /proc/$PID/cmdline to seq_file interface.

XXX

This one must be buggy.

seq_file buffer is adjustable, so userspace can execute itself
with huge command line (which can be arbitrarily long now), then read 1 byte.

Voila, whole command line now is in kmalloced/vmalloced memory.

Imposing limit is trivial but equally lame to current PAGE_SIZE limit.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-fix-page_size-limit-of-proc-pid-cmdline fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-page_size-limit-of-proc-pid-cmdline
+++ a/fs/proc/base.c
@@ -200,9 +200,17 @@ static int proc_root_link(struct dentry
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
+	 *
+	 * Rely on internal buffer autoexpansion if it was entirely filled.
+	 */
+	m->count += get_cmdline(task, m->buf, m->size);
+	return 0;
 }
 
 static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
@@ -2567,7 +2575,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	ONE("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
-	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
+	ONE("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
@@ -2903,7 +2911,7 @@ static const struct pid_entry tid_base_s
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
proc-fix-page_size-limit-of-proc-pid-cmdline.patch
proc-convert-proc-pid-wchan-to-seq_file-interface.patch
proc-convert-proc-pid-schedstat-to-seq_file-interface.patch
proc-convert-proc-pid-oom_score-to-seq_file-interface.patch
proc-convert-proc-pid-io-to-seq_file-interface.patch
proc-convert-proc-pid-hardwall-to-seq_file-interface.patch
proc-remove-inf-macro.patch

