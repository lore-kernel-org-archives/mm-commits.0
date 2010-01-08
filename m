From: akpm@linux-foundation.org
Subject: + sysctl-use-rcu-strings-for-core_pattern-sysctl.patch added to -mm tree
Date: Fri, 08 Jan 2010 15:54:08 -0800
Message-ID: <201001082354.o08Ns9nZ021871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754437Ab0AHXyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 18:54:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, ebiederm@xmission.com, paulmck@us.ibm.com, rmk+lkml@arm.linux.org.uk, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     sysctl: use RCU strings for core_pattern sysctl
has been added to the -mm tree.  Its filename is
     sysctl-use-rcu-strings-for-core_pattern-sysctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: use RCU strings for core_pattern sysctl
From: Andi Kleen <andi@firstfloor.org>

Also saves ~220 bytes in the data segment for default kernels.

As a bonus this removes one use of the BKL.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c       |   11 +++++------
 kernel/sysctl.c |    6 +++---
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN fs/exec.c~sysctl-use-rcu-strings-for-core_pattern-sysctl fs/exec.c
--- a/fs/exec.c~sysctl-use-rcu-strings-for-core_pattern-sysctl
+++ a/fs/exec.c
@@ -62,7 +62,7 @@
 #include "internal.h"
 
 int core_uses_pid;
-char core_pattern[CORENAME_MAX_SIZE] = "core";
+char *core_pattern = "core";
 unsigned int core_pipe_limit;
 int suid_dumpable = 0;
 
@@ -1422,7 +1422,7 @@ EXPORT_SYMBOL(set_binfmt);
 static int format_corename(char *corename, long signr)
 {
 	const struct cred *cred = current_cred();
-	const char *pat_ptr = core_pattern;
+	const char *pat_ptr = rcu_dereference(core_pattern);
 	int ispipe = (*pat_ptr == '|');
 	char *out_ptr = corename;
 	char *const out_end = corename + CORENAME_MAX_SIZE;
@@ -1838,12 +1838,11 @@ void do_coredump(long signr, int exit_co
 	clear_thread_flag(TIF_SIGPENDING);
 
 	/*
-	 * lock_kernel() because format_corename() is controlled by sysctl, which
-	 * uses lock_kernel()
+	 * Protect corename by RCU vs proc_rcu_string()
 	 */
- 	lock_kernel();
+	rcu_read_lock();
 	ispipe = format_corename(corename, signr);
-	unlock_kernel();
+	rcu_read_unlock();
 
 	if ((!ispipe) && (cprm.limit < binfmt->min_coredump))
 		goto fail_unlock;
diff -puN kernel/sysctl.c~sysctl-use-rcu-strings-for-core_pattern-sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-use-rcu-strings-for-core_pattern-sysctl
+++ a/kernel/sysctl.c
@@ -75,7 +75,7 @@ extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
-extern char core_pattern[];
+extern char *core_pattern;
 extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
@@ -399,10 +399,10 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.procname	= "core_pattern",
-		.data		= core_pattern,
+		.data		= &core_pattern,
 		.maxlen		= CORENAME_MAX_SIZE,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 	{
 		.procname	= "core_pipe_limit",
_

Patches currently in -mm which might be from andi@firstfloor.org are

kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1.patch
proc-revert-procfs-provide-stack-information-for-threads.patch
kfifo-use-void-pointers-for-user-buffers.patch
kfifo-sanitize-_user-error-handling.patch
kfifo-add-kfifo_out_peek.patch
kfifo-add-kfifo_initialized.patch
kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch
hardware-latency-detector-remove-default-m.patch
kbuild-move-fno-dwarf2-cfi-asm-to-powerpc-only.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
rcu-add-rcustring-adt-for-rcu-protected-strings.patch
add-a-kernel_address-that-works-for-data-too.patch
sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch
sysctl-use-rcu-strings-for-core_pattern-sysctl.patch
sysctl-add-call_usermodehelper_cleanup.patch
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch

