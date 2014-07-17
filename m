From: akpm@linux-foundation.org
Subject: + proc-convert-proc-pid-hardwall-to-seq_file-interface.patch
 added to -mm tree
Date: Thu, 17 Jul 2014 15:54:40 -0700
Message-ID: <53c85430.U0yqB4LMjsL6vX9I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:51338 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbaGQWym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 18:54:42 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so830721pab.5
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 15:54:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/hardwall to seq_file interface
has been added to the -mm tree.  Its filename is
     proc-convert-proc-pid-hardwall-to-seq_file-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-convert-proc-pid-hardwall-to-seq_file-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-convert-proc-pid-hardwall-to-seq_file-interface.patch

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
Subject: proc: convert /proc/$PID/hardwall to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/hardwall.h |    2 +-
 arch/tile/kernel/hardwall.c      |    6 +++---
 fs/proc/base.c                   |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/tile/include/asm/hardwall.h~proc-convert-proc-pid-hardwall-to-seq_file-interface arch/tile/include/asm/hardwall.h
--- a/arch/tile/include/asm/hardwall.h~proc-convert-proc-pid-hardwall-to-seq_file-interface
+++ a/arch/tile/include/asm/hardwall.h
@@ -23,7 +23,7 @@
 struct proc_dir_entry;
 #ifdef CONFIG_HARDWALL
 void proc_tile_hardwall_init(struct proc_dir_entry *root);
-int proc_pid_hardwall(struct task_struct *task, char *buffer);
+int proc_pid_hardwall(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
 #else
 static inline void proc_tile_hardwall_init(struct proc_dir_entry *root) {}
 #endif
diff -puN arch/tile/kernel/hardwall.c~proc-convert-proc-pid-hardwall-to-seq_file-interface arch/tile/kernel/hardwall.c
--- a/arch/tile/kernel/hardwall.c~proc-convert-proc-pid-hardwall-to-seq_file-interface
+++ a/arch/tile/kernel/hardwall.c
@@ -947,15 +947,15 @@ static void hardwall_remove_proc(struct
 	remove_proc_entry(buf, info->type->proc_dir);
 }
 
-int proc_pid_hardwall(struct task_struct *task, char *buffer)
+int proc_pid_hardwall(struct seq_file *m, struct pid_namespace *ns,
+		      struct pid *pid, struct task_struct *task)
 {
 	int i;
 	int n = 0;
 	for (i = 0; i < HARDWALL_TYPES; ++i) {
 		struct hardwall_info *info = task->thread.hardwall[i].info;
 		if (info)
-			n += sprintf(&buffer[n], "%s: %d\n",
-				     info->type->name, info->id);
+			seq_printf(m, "%s: %d\n", info->type->name, info->id);
 	}
 	return n;
 }
diff -puN fs/proc/base.c~proc-convert-proc-pid-hardwall-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-hardwall-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -2637,7 +2637,7 @@ static const struct pid_entry tgid_base_
 	ONE("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
-	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
+	ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
 #endif
 #ifdef CONFIG_USER_NS
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
@@ -2972,7 +2972,7 @@ static const struct pid_entry tid_base_s
 	ONE("io",	S_IRUSR, proc_tid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
-	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
+	ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
 #endif
 #ifdef CONFIG_USER_NS
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
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

