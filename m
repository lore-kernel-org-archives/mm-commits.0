From: akpm@linux-foundation.org
Subject: - signals-use-have_set_restore_sigmask.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:24 -0700
Message-ID: <200805010927.m419ROwE030414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758779AbYEAJqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, heiko.carstens@de.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     signals: use HAVE_SET_RESTORE_SIGMASK
has been removed from the -mm tree.  Its filename was
     signals-use-have_set_restore_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1241,7 +1241,7 @@ error_return:
 	return error;
 }
 
-#ifdef TIF_RESTORE_SIGMASK
+#ifdef HAVE_SET_RESTORE_SIGMASK
 
 /*
  * Implement the event wait interface for the eventpoll file. It is the kernel
@@ -1287,7 +1287,7 @@ asmlinkage long sys_epoll_pwait(int epfd
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
@@ -1175,7 +1175,7 @@ struct task_struct {
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
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

