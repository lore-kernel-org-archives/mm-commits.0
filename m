From: akpm@linux-foundation.org
Subject: + powerpc32-asm-offsets-ptrace-cruft.patch added to -mm tree
Date: Fri, 21 Mar 2008 14:37:33 -0700
Message-ID: <200803212137.m2LLbX3O011617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845AbYCUVil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 17:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com


The patch titled
     powerpc32: asm-offsets ptrace cruft
has been added to the -mm tree.  Its filename is
     powerpc32-asm-offsets-ptrace-cruft.patch

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
Subject: powerpc32: asm-offsets ptrace cruft
From: Roland McGrath <roland@redhat.com>

These items in asm-offsets.c are not used anywhere.  Remove them.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/asm-offsets.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/powerpc/kernel/asm-offsets.c~powerpc32-asm-offsets-ptrace-cruft arch/powerpc/kernel/asm-offsets.c
--- a/arch/powerpc/kernel/asm-offsets.c~powerpc32-asm-offsets-ptrace-cruft
+++ a/arch/powerpc/kernel/asm-offsets.c
@@ -26,8 +26,6 @@
 #ifdef CONFIG_PPC64
 #include <linux/time.h>
 #include <linux/hardirq.h>
-#else
-#include <linux/ptrace.h>
 #endif
 
 #include <asm/io.h>
@@ -60,7 +58,6 @@ int main(void)
 	DEFINE(AUDITCONTEXT, offsetof(struct task_struct, audit_context));
 #else
 	DEFINE(THREAD_INFO, offsetof(struct task_struct, stack));
-	DEFINE(PTRACE, offsetof(struct task_struct, ptrace));
 #endif /* CONFIG_PPC64 */
 
 	DEFINE(KSP, offsetof(struct thread_struct, ksp));
@@ -80,7 +77,6 @@ int main(void)
 	DEFINE(PGDIR, offsetof(struct thread_struct, pgdir));
 #if defined(CONFIG_4xx) || defined(CONFIG_BOOKE)
 	DEFINE(THREAD_DBCR0, offsetof(struct thread_struct, dbcr0));
-	DEFINE(PT_PTRACED, PT_PTRACED);
 #endif
 #ifdef CONFIG_SPE
 	DEFINE(THREAD_EVR0, offsetof(struct thread_struct, evr[0]));
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
git-x86.patch
x86-handle_vm86_trap-cleanup.patch
x86_64-ia32-ptrace-vs-enosys.patch
x86_64-ptrace-vs-enosys.patch
x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch
powerpc-dont-use-pt_dtrace.patch
powerpc32-asm-offsets-ptrace-cruft.patch
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
signals-fold-sig_ignored-into-handle_stop_signal-comment.patch
signals-document-cld_continued-notification-mechanics.patch
signals-document-cld_continued-notification-mechanics-more.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

