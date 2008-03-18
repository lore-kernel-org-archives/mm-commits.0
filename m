From: akpm@linux-foundation.org
Subject: + powerpc-dont-use-pt_dtrace.patch added to -mm tree
Date: Mon, 17 Mar 2008 20:58:53 -0700
Message-ID: <200803180358.m2I3wrWO013033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727AbYCRD7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 23:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     powerpc: don't use PT_DTRACE
has been added to the -mm tree.  Its filename is
     powerpc-dont-use-pt_dtrace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: don't use PT_DTRACE
From: Roland McGrath <roland@redhat.com>

The PT_DTRACE flag is meaningless and obsolete.  Don't touch it.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/process.c   |    5 -----
 arch/powerpc/kernel/sys_ppc32.c |    5 -----
 2 files changed, 10 deletions(-)

diff -puN arch/powerpc/kernel/process.c~powerpc-dont-use-pt_dtrace arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~powerpc-dont-use-pt_dtrace
+++ a/arch/powerpc/kernel/process.c
@@ -862,11 +862,6 @@ int sys_execve(unsigned long a0, unsigne
 	flush_spe_to_thread(current);
 	error = do_execve(filename, (char __user * __user *) a1,
 			  (char __user * __user *) a2, regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
diff -puN arch/powerpc/kernel/sys_ppc32.c~powerpc-dont-use-pt_dtrace arch/powerpc/kernel/sys_ppc32.c
--- a/arch/powerpc/kernel/sys_ppc32.c~powerpc-dont-use-pt_dtrace
+++ a/arch/powerpc/kernel/sys_ppc32.c
@@ -368,11 +368,6 @@ long compat_sys_execve(unsigned long a0,
 
 	error = compat_do_execve(filename, compat_ptr(a1), compat_ptr(a2), regs);
 
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 
 out:
_

Patches currently in -mm which might be from roland@redhat.com are

git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
powerpc-dont-use-pt_dtrace.patch
powerpc-user_regset-ptrace_setregs-regression-fix.patch
add-rusage_thread.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
signals-send_sigqueue-dont-take-rcu-lock.patch
signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
signals-__group_complete_signal-cache-the-value-of-p-signal.patch
signals-send_group_sigqueue-dont-take-tasklist_lock.patch
signals-move-handle_stop_signal-into-send_signal.patch
signals-do_tkill-dont-use-tasklist_lock.patch
signals-do_tkill-dont-use-tasklist_lock-comment.patch
signals-send_sig_info-dont-take-tasklist_lock.patch
signals-microoptimize-the-usage-of-curr_target.patch
signals-move-the-definition-of-__group_complete_signal-up.patch
signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
signals-join-send_sigqueue-with-send_group_sigqueue.patch
signals-handle_stop_signal-dont-worry-about-sigkill.patch
signals-cleanup-the-usage-of-print_fatal_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal.patch
signals-document-cld_continued-notification-mechanics.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

