From: akpm@linux-foundation.org
Subject: + signals-use-have_set_restore_sigmask.patch added to -mm tree
Date: Mon, 07 Apr 2008 17:52:47 -0700
Message-ID: <200804080052.m380qlZl000864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364AbYDHAyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 20:54:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, heiko.carstens@de.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     signals: use HAVE_SET_RESTORE_SIGMASK
has been added to the -mm tree.  Its filename is
     signals-use-have_set_restore_sigmask.patch

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
Subject: signals: use HAVE_SET_RESTORE_SIGMASK
From: Roland McGrath <roland@redhat.com>

Change all the #ifdef TIF_RESTORE_SIGMASK conditionals in non-arch code to
#ifdef HAVE_SET_RESTORE_SIGMASK.  If arch code defines it first, the generic
set_restore_sigmask() using TIF_RESTORE_SIGMASK is not defined.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c                 |    8 ++++----
 fs/eventpoll.c              |    4 ++--
 fs/select.c                 |    8 ++++----
 include/linux/sched.h       |    2 +-
 include/linux/thread_info.h |   10 ++++++++--
 5 files changed, 19 insertions(+), 13 deletions(-)

diff -puN fs/compat.c~signals-use-have_set_restore_sigmask fs/compat.c
--- a/fs/compat.c~signals-use-have_set_restore_sigmask
+++ a/fs/compat.c
@@ -1634,7 +1634,7 @@ sticky:
 	return ret;
 }
 
-#ifdef TIF_RESTORE_SIGMASK
+#ifdef HAVE_SET_RESTORE_SIGMASK
 asmlinkage long compat_sys_pselect7(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
 	struct compat_timespec __user *tsp, compat_sigset_t __user *sigmask,
@@ -1825,7 +1825,7 @@ sticky:
 
 	return ret;
 }
-#endif /* TIF_RESTORE_SIGMASK */
+#endif /* HAVE_SET_RESTORE_SIGMASK */
 
 #if defined(CONFIG_NFSD) || defined(CONFIG_NFSD_MODULE)
 /* Stuff for NFS server syscalls... */
@@ -2080,7 +2080,7 @@ long asmlinkage compat_sys_nfsservctl(in
 
 #ifdef CONFIG_EPOLL
 
-#ifdef TIF_RESTORE_SIGMASK
+#ifdef HAVE_SET_RESTORE_SIGMASK
 asmlinkage long compat_sys_epoll_pwait(int epfd,
 			struct compat_epoll_event __user *events,
 			int maxevents, int timeout,
@@ -2124,7 +2124,7 @@ asmlinkage long compat_sys_epoll_pwait(i
 
 	return err;
 }
-#endif /* TIF_RESTORE_SIGMASK */
+#endif /* HAVE_SET_RESTORE_SIGMASK */
 
 #endif /* CONFIG_EPOLL */
 
diff -puN fs/eventpoll.c~signals-use-have_set_restore_sigmask fs/eventpoll.c
--- a/fs/eventpoll.c~signals-use-have_set_restore_sigmask
+++ a/fs/eventpoll.c
@@ -1238,7 +1238,7 @@ error_return:
 	return error;
 }
 
-#ifdef TIF_RESTORE_SIGMASK
+#ifdef HAVE_SET_RESTORE_SIGMASK
 
 /*
  * Implement the event wait interface for the eventpoll file. It is the kernel
@@ -1284,7 +1284,7 @@ asmlinkage long sys_epoll_pwait(int epfd
 	return error;
 }
 
-#endif /* #ifdef TIF_RESTORE_SIGMASK */
+#endif /* HAVE_SET_RESTORE_SIGMASK */
 
 static int __init eventpoll_init(void)
 {
diff -puN fs/select.c~signals-use-have_set_restore_sigmask fs/select.c
--- a/fs/select.c~signals-use-have_set_restore_sigmask
+++ a/fs/select.c
@@ -425,7 +425,7 @@ sticky:
 	return ret;
 }
 
-#ifdef TIF_RESTORE_SIGMASK
+#ifdef HAVE_SET_RESTORE_SIGMASK
 asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
 		fd_set __user *exp, struct timespec __user *tsp,
 		const sigset_t __user *sigmask, size_t sigsetsize)
@@ -528,7 +528,7 @@ asmlinkage long sys_pselect6(int n, fd_s
 
 	return sys_pselect7(n, inp, outp, exp, tsp, up, sigsetsize);
 }
-#endif /* TIF_RESTORE_SIGMASK */
+#endif /* HAVE_SET_RESTORE_SIGMASK */
 
 struct poll_list {
 	struct poll_list *next;
@@ -759,7 +759,7 @@ asmlinkage long sys_poll(struct pollfd _
 	return ret;
 }
 
-#ifdef TIF_RESTORE_SIGMASK
+#ifdef HAVE_SET_RESTORE_SIGMASK
 asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
 	struct timespec __user *tsp, const sigset_t __user *sigmask,
 	size_t sigsetsize)
@@ -839,4 +839,4 @@ asmlinkage long sys_ppoll(struct pollfd 
 
 	return ret;
 }
-#endif /* TIF_RESTORE_SIGMASK */
+#endif /* HAVE_SET_RESTORE_SIGMASK */
diff -puN include/linux/sched.h~signals-use-have_set_restore_sigmask include/linux/sched.h
--- a/include/linux/sched.h~signals-use-have_set_restore_sigmask
+++ a/include/linux/sched.h
@@ -1151,7 +1151,7 @@ struct task_struct {
 	struct sighand_struct *sighand;
 
 	sigset_t blocked, real_blocked;
-	sigset_t saved_sigmask;		/* To be restored with TIF_RESTORE_SIGMASK */
+	sigset_t saved_sigmask;	/* restored if set_restore_sigmask() was used */
 	struct sigpending pending;
 
 	unsigned long sas_ss_sp;
diff -puN include/linux/thread_info.h~signals-use-have_set_restore_sigmask include/linux/thread_info.h
--- a/include/linux/thread_info.h~signals-use-have_set_restore_sigmask
+++ a/include/linux/thread_info.h
@@ -92,7 +92,13 @@ static inline int test_ti_thread_flag(st
 #define set_need_resched()	set_thread_flag(TIF_NEED_RESCHED)
 #define clear_need_resched()	clear_thread_flag(TIF_NEED_RESCHED)
 
-#ifdef TIF_RESTORE_SIGMASK
+#if defined TIF_RESTORE_SIGMASK && !defined HAVE_SET_RESTORE_SIGMASK
+/*
+ * An arch can define its own version of set_restore_sigmask() to get the
+ * job done however works, with or without TIF_RESTORE_SIGMASK.
+ */
+#define HAVE_SET_RESTORE_SIGMASK	1
+
 /**
  * set_restore_sigmask() - make sure saved_sigmask processing gets done
  *
@@ -109,7 +115,7 @@ static inline void set_restore_sigmask(v
 	set_thread_flag(TIF_RESTORE_SIGMASK);
 	set_thread_flag(TIF_SIGPENDING);
 }
-#endif	/* TIF_RESTORE_SIGMASK */
+#endif	/* TIF_RESTORE_SIGMASK && !HAVE_SET_RESTORE_SIGMASK */
 
 #endif	/* __KERNEL__ */
 
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
git-x86.patch
x86-handle_vm86_trap-cleanup.patch
x86_64-ia32-ptrace-vs-enosys.patch
x86_64-ptrace-vs-enosys.patch
x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch
git-powerpc.patch
git-selinux.patch
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
signals-check_kill_permission-remove-tasklist_lock.patch
signals-fix-sbin-init-protection-from-unwanted-signals.patch
signals-de_thread-simplify-the-child_reaper-switching.patch
signals-allow-the-kernel-to-actually-kill-sbin-init.patch
signals-add-set_restore_sigmask.patch
signals-set_restore_sigmask-tif_sigpending.patch
signals-s390-renumber-tif_restore_sigmask.patch
signals-ia64-renumber-tif_restore_sigmask.patch
signals-use-have_set_restore_sigmask.patch
signals-x86-ts_restore_sigmask.patch
signals-powerpc-tlf_restore_sigmask.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
ptrace-allow-to-ptrace-sbin-init.patch
procfs-mem-permission-cleanup.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

