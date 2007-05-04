From: akpm@linux-foundation.org
Subject: + move-sig_kernel_-et-al-macros-to-linux-signalh.patch added to -mm tree
Date: Fri, 04 May 2007 01:09:22 -0700
Message-ID: <200705040809.l4489Mih032077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031360AbXEDIJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 04:09:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com


The patch titled
     Move sig_kernel_* et al macros to linux/signal.h
has been added to the -mm tree.  Its filename is
     move-sig_kernel_-et-al-macros-to-linux-signalh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move sig_kernel_* et al macros to linux/signal.h
From: Roland McGrath <roland@redhat.com>

This patch moves the sig_kernel_* and related macros from kernel/signal.c
to linux/signal.h, and cleans them up slightly.  I need the sig_kernel_*
macros for default signal behavior in the utrace code, and want to avoid
duplication or overhead to share the knowledge.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |  125 +++++++++++++++++++++++++++++++++++++++
 kernel/signal.c        |  119 -------------------------------------
 2 files changed, 125 insertions(+), 119 deletions(-)

diff -puN include/linux/signal.h~move-sig_kernel_-et-al-macros-to-linux-signalh include/linux/signal.h
--- a/include/linux/signal.h~move-sig_kernel_-et-al-macros-to-linux-signalh
+++ a/include/linux/signal.h
@@ -243,6 +243,131 @@ extern int get_signal_to_deliver(siginfo
 
 extern struct kmem_cache *sighand_cachep;
 
+/*
+ * In POSIX a signal is sent either to a specific thread (Linux task)
+ * or to the process as a whole (Linux thread group).  How the signal
+ * is sent determines whether it's to one thread or the whole group,
+ * which determines which signal mask(s) are involved in blocking it
+ * from being delivered until later.  When the signal is delivered,
+ * either it's caught or ignored by a user handler or it has a default
+ * effect that applies to the whole thread group (POSIX process).
+ *
+ * The possible effects an unblocked signal set to SIG_DFL can have are:
+ *   ignore	- Nothing Happens
+ *   terminate	- kill the process, i.e. all threads in the group,
+ * 		  similar to exit_group.  The group leader (only) reports
+ *		  WIFSIGNALED status to its parent.
+ *   coredump	- write a core dump file describing all threads using
+ *		  the same mm and then kill all those threads
+ *   stop 	- stop all the threads in the group, i.e. TASK_STOPPED state
+ *
+ * SIGKILL and SIGSTOP cannot be caught, blocked, or ignored.
+ * Other signals when not blocked and set to SIG_DFL behaves as follows.
+ * The job control signals also have other special effects.
+ *
+ *	+--------------------+------------------+
+ *	|  POSIX signal      |  default action  |
+ *	+--------------------+------------------+
+ *	|  SIGHUP            |  terminate	|
+ *	|  SIGINT            |	terminate	|
+ *	|  SIGQUIT           |	coredump 	|
+ *	|  SIGILL            |	coredump 	|
+ *	|  SIGTRAP           |	coredump 	|
+ *	|  SIGABRT/SIGIOT    |	coredump 	|
+ *	|  SIGBUS            |	coredump 	|
+ *	|  SIGFPE            |	coredump 	|
+ *	|  SIGKILL           |	terminate(+)	|
+ *	|  SIGUSR1           |	terminate	|
+ *	|  SIGSEGV           |	coredump 	|
+ *	|  SIGUSR2           |	terminate	|
+ *	|  SIGPIPE           |	terminate	|
+ *	|  SIGALRM           |	terminate	|
+ *	|  SIGTERM           |	terminate	|
+ *	|  SIGCHLD           |	ignore   	|
+ *	|  SIGCONT           |	ignore(*)	|
+ *	|  SIGSTOP           |	stop(*)(+)  	|
+ *	|  SIGTSTP           |	stop(*)  	|
+ *	|  SIGTTIN           |	stop(*)  	|
+ *	|  SIGTTOU           |	stop(*)  	|
+ *	|  SIGURG            |	ignore   	|
+ *	|  SIGXCPU           |	coredump 	|
+ *	|  SIGXFSZ           |	coredump 	|
+ *	|  SIGVTALRM         |	terminate	|
+ *	|  SIGPROF           |	terminate	|
+ *	|  SIGPOLL/SIGIO     |	terminate	|
+ *	|  SIGSYS/SIGUNUSED  |	coredump 	|
+ *	|  SIGSTKFLT         |	terminate	|
+ *	|  SIGWINCH          |	ignore   	|
+ *	|  SIGPWR            |	terminate	|
+ *	|  SIGRTMIN-SIGRTMAX |	terminate       |
+ *	+--------------------+------------------+
+ *	|  non-POSIX signal  |  default action  |
+ *	+--------------------+------------------+
+ *	|  SIGEMT            |  coredump	|
+ *	+--------------------+------------------+
+ *
+ * (+) For SIGKILL and SIGSTOP the action is "always", not just "default".
+ * (*) Special job control effects:
+ * When SIGCONT is sent, it resumes the process (all threads in the group)
+ * from TASK_STOPPED state and also clears any pending/queued stop signals
+ * (any of those marked with "stop(*)").  This happens regardless of blocking,
+ * catching, or ignoring SIGCONT.  When any stop signal is sent, it clears
+ * any pending/queued SIGCONT signals; this happens regardless of blocking,
+ * catching, or ignored the stop signal, though (except for SIGSTOP) the
+ * default action of stopping the process may happen later or never.
+ */
+
+#ifdef SIGEMT
+#define SIGEMT_MASK	rt_sigmask(SIGEMT)
+#else
+#define SIGEMT_MASK	0
+#endif
+
+#if SIGRTMIN > BITS_PER_LONG
+#define rt_sigmask(sig)	(1ULL << ((sig)-1))
+#else
+#define rt_sigmask(sig)	sigmask(sig)
+#endif
+#define siginmask(sig, mask) (rt_sigmask(sig) & (mask))
+
+#define SIG_KERNEL_ONLY_MASK (\
+	rt_sigmask(SIGKILL)   |  rt_sigmask(SIGSTOP))
+
+#define SIG_KERNEL_STOP_MASK (\
+	rt_sigmask(SIGSTOP)   |  rt_sigmask(SIGTSTP)   | \
+	rt_sigmask(SIGTTIN)   |  rt_sigmask(SIGTTOU)   )
+
+#define SIG_KERNEL_COREDUMP_MASK (\
+        rt_sigmask(SIGQUIT)   |  rt_sigmask(SIGILL)    | \
+	rt_sigmask(SIGTRAP)   |  rt_sigmask(SIGABRT)   | \
+        rt_sigmask(SIGFPE)    |  rt_sigmask(SIGSEGV)   | \
+	rt_sigmask(SIGBUS)    |  rt_sigmask(SIGSYS)    | \
+        rt_sigmask(SIGXCPU)   |  rt_sigmask(SIGXFSZ)   | \
+	SIGEMT_MASK				       )
+
+#define SIG_KERNEL_IGNORE_MASK (\
+        rt_sigmask(SIGCONT)   |  rt_sigmask(SIGCHLD)   | \
+	rt_sigmask(SIGWINCH)  |  rt_sigmask(SIGURG)    )
+
+#define sig_kernel_only(sig) \
+	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_ONLY_MASK))
+#define sig_kernel_coredump(sig) \
+	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_COREDUMP_MASK))
+#define sig_kernel_ignore(sig) \
+	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_IGNORE_MASK))
+#define sig_kernel_stop(sig) \
+	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_STOP_MASK))
+
+#define sig_needs_tasklist(sig)	((sig) == SIGCONT)
+
+#define sig_user_defined(t, signr) \
+	(((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_DFL) &&	\
+	 ((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_IGN))
+
+#define sig_fatal(t, signr) \
+	(!siginmask(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
+	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_SIGNAL_H */
diff -puN kernel/signal.c~move-sig_kernel_-et-al-macros-to-linux-signalh kernel/signal.c
--- a/kernel/signal.c~move-sig_kernel_-et-al-macros-to-linux-signalh
+++ a/kernel/signal.c
@@ -38,125 +38,6 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
-/*
- * In POSIX a signal is sent either to a specific thread (Linux task)
- * or to the process as a whole (Linux thread group).  How the signal
- * is sent determines whether it's to one thread or the whole group,
- * which determines which signal mask(s) are involved in blocking it
- * from being delivered until later.  When the signal is delivered,
- * either it's caught or ignored by a user handler or it has a default
- * effect that applies to the whole thread group (POSIX process).
- *
- * The possible effects an unblocked signal set to SIG_DFL can have are:
- *   ignore	- Nothing Happens
- *   terminate	- kill the process, i.e. all threads in the group,
- * 		  similar to exit_group.  The group leader (only) reports
- *		  WIFSIGNALED status to its parent.
- *   coredump	- write a core dump file describing all threads using
- *		  the same mm and then kill all those threads
- *   stop 	- stop all the threads in the group, i.e. TASK_STOPPED state
- *
- * SIGKILL and SIGSTOP cannot be caught, blocked, or ignored.
- * Other signals when not blocked and set to SIG_DFL behaves as follows.
- * The job control signals also have other special effects.
- *
- *	+--------------------+------------------+
- *	|  POSIX signal      |  default action  |
- *	+--------------------+------------------+
- *	|  SIGHUP            |  terminate	|
- *	|  SIGINT            |	terminate	|
- *	|  SIGQUIT           |	coredump 	|
- *	|  SIGILL            |	coredump 	|
- *	|  SIGTRAP           |	coredump 	|
- *	|  SIGABRT/SIGIOT    |	coredump 	|
- *	|  SIGBUS            |	coredump 	|
- *	|  SIGFPE            |	coredump 	|
- *	|  SIGKILL           |	terminate(+)	|
- *	|  SIGUSR1           |	terminate	|
- *	|  SIGSEGV           |	coredump 	|
- *	|  SIGUSR2           |	terminate	|
- *	|  SIGPIPE           |	terminate	|
- *	|  SIGALRM           |	terminate	|
- *	|  SIGTERM           |	terminate	|
- *	|  SIGCHLD           |	ignore   	|
- *	|  SIGCONT           |	ignore(*)	|
- *	|  SIGSTOP           |	stop(*)(+)  	|
- *	|  SIGTSTP           |	stop(*)  	|
- *	|  SIGTTIN           |	stop(*)  	|
- *	|  SIGTTOU           |	stop(*)  	|
- *	|  SIGURG            |	ignore   	|
- *	|  SIGXCPU           |	coredump 	|
- *	|  SIGXFSZ           |	coredump 	|
- *	|  SIGVTALRM         |	terminate	|
- *	|  SIGPROF           |	terminate	|
- *	|  SIGPOLL/SIGIO     |	terminate	|
- *	|  SIGSYS/SIGUNUSED  |	coredump 	|
- *	|  SIGSTKFLT         |	terminate	|
- *	|  SIGWINCH          |	ignore   	|
- *	|  SIGPWR            |	terminate	|
- *	|  SIGRTMIN-SIGRTMAX |	terminate       |
- *	+--------------------+------------------+
- *	|  non-POSIX signal  |  default action  |
- *	+--------------------+------------------+
- *	|  SIGEMT            |  coredump	|
- *	+--------------------+------------------+
- *
- * (+) For SIGKILL and SIGSTOP the action is "always", not just "default".
- * (*) Special job control effects:
- * When SIGCONT is sent, it resumes the process (all threads in the group)
- * from TASK_STOPPED state and also clears any pending/queued stop signals
- * (any of those marked with "stop(*)").  This happens regardless of blocking,
- * catching, or ignoring SIGCONT.  When any stop signal is sent, it clears
- * any pending/queued SIGCONT signals; this happens regardless of blocking,
- * catching, or ignored the stop signal, though (except for SIGSTOP) the
- * default action of stopping the process may happen later or never.
- */
-
-#ifdef SIGEMT
-#define M_SIGEMT	M(SIGEMT)
-#else
-#define M_SIGEMT	0
-#endif
-
-#if SIGRTMIN > BITS_PER_LONG
-#define M(sig) (1ULL << ((sig)-1))
-#else
-#define M(sig) (1UL << ((sig)-1))
-#endif
-#define T(sig, mask) (M(sig) & (mask))
-
-#define SIG_KERNEL_ONLY_MASK (\
-	M(SIGKILL)   |  M(SIGSTOP)                                   )
-
-#define SIG_KERNEL_STOP_MASK (\
-	M(SIGSTOP)   |  M(SIGTSTP)   |  M(SIGTTIN)   |  M(SIGTTOU)   )
-
-#define SIG_KERNEL_COREDUMP_MASK (\
-        M(SIGQUIT)   |  M(SIGILL)    |  M(SIGTRAP)   |  M(SIGABRT)   | \
-        M(SIGFPE)    |  M(SIGSEGV)   |  M(SIGBUS)    |  M(SIGSYS)    | \
-        M(SIGXCPU)   |  M(SIGXFSZ)   |  M_SIGEMT                     )
-
-#define SIG_KERNEL_IGNORE_MASK (\
-        M(SIGCONT)   |  M(SIGCHLD)   |  M(SIGWINCH)  |  M(SIGURG)    )
-
-#define sig_kernel_only(sig) \
-		(((sig) < SIGRTMIN)  && T(sig, SIG_KERNEL_ONLY_MASK))
-#define sig_kernel_coredump(sig) \
-		(((sig) < SIGRTMIN)  && T(sig, SIG_KERNEL_COREDUMP_MASK))
-#define sig_kernel_ignore(sig) \
-		(((sig) < SIGRTMIN)  && T(sig, SIG_KERNEL_IGNORE_MASK))
-#define sig_kernel_stop(sig) \
-		(((sig) < SIGRTMIN)  && T(sig, SIG_KERNEL_STOP_MASK))
-
-#define sig_needs_tasklist(sig)	((sig) == SIGCONT)
-
-#define sig_user_defined(t, signr) \
-	(((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_DFL) &&	\
-	 ((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_IGN))
-
-#define sig_fatal(t, signr) \
-	(!T(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
-	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)
 
 static int sig_ignored(struct task_struct *t, int sig)
 {
_

Patches currently in -mm which might be from roland@redhat.com are

return-eperm-not-echild-on-security_task_wait-failure.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
futex-restartable-futex_wait.patch
move-sig_kernel_-et-al-macros-to-linux-signalh.patch
