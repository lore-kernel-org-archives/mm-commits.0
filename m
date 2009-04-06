From: akpm@linux-foundation.org
Subject: [merged] signals-protect-cinit-from-unblocked-sig_dfl-signals.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:25 -0700
Message-ID: <200904061935.n36JZP3p012040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886AbZDFTlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:41:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, daniel.lezcano@free.fr, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: protect cinit from unblocked SIG_DFL signals
has been removed from the -mm tree.  Its filename was
     signals-protect-cinit-from-unblocked-sig_dfl-signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: protect cinit from unblocked SIG_DFL signals
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Drop early any SIG_DFL or SIG_IGN signals to container-init from within
the same container.  But queue SIGSTOP and SIGKILL to the container-init
if they are from an ancestor container.

Blocked, fatal signals (i.e when SIG_DFL is to terminate) from within the
container can still terminate the container-init.  That will be addressed
in the next patch.

Note:	To be bisect-safe, SIGNAL_UNKILLABLE will be set for container-inits
   	in a follow-on patch. Until then, this patch is just a preparatory
	step.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~signals-protect-cinit-from-unblocked-sig_dfl-signals kernel/signal.c
--- a/kernel/signal.c~signals-protect-cinit-from-unblocked-sig_dfl-signals
+++ a/kernel/signal.c
@@ -55,20 +55,21 @@ static int sig_handler_ignored(void __us
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
-static int sig_task_ignored(struct task_struct *t, int sig)
+static int sig_task_ignored(struct task_struct *t, int sig,
+		int from_ancestor_ns)
 {
 	void __user *handler;
 
 	handler = sig_handler(t, sig);
 
 	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
-			handler == SIG_DFL)
+			handler == SIG_DFL && !from_ancestor_ns)
 		return 1;
 
 	return sig_handler_ignored(handler, sig);
 }
 
-static int sig_ignored(struct task_struct *t, int sig)
+static int sig_ignored(struct task_struct *t, int sig, int from_ancestor_ns)
 {
 	/*
 	 * Blocked signals are never ignored, since the
@@ -78,7 +79,7 @@ static int sig_ignored(struct task_struc
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	if (!sig_task_ignored(t, sig))
+	if (!sig_task_ignored(t, sig, from_ancestor_ns))
 		return 0;
 
 	/*
@@ -634,7 +635,7 @@ static int check_kill_permission(int sig
  * Returns true if the signal should be actually delivered, otherwise
  * it should be dropped.
  */
-static int prepare_signal(int sig, struct task_struct *p)
+static int prepare_signal(int sig, struct task_struct *p, int from_ancestor_ns)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
@@ -718,7 +719,7 @@ static int prepare_signal(int sig, struc
 		}
 	}
 
-	return !sig_ignored(p, sig);
+	return !sig_ignored(p, sig, from_ancestor_ns);
 }
 
 /*
@@ -832,7 +833,8 @@ static int __send_signal(int sig, struct
 	trace_sched_signal_send(sig, t);
 
 	assert_spin_locked(&t->sighand->siglock);
-	if (!prepare_signal(sig, t))
+
+	if (!prepare_signal(sig, t, from_ancestor_ns))
 		return 0;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
@@ -902,7 +904,15 @@ out_set:
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			int group)
 {
-	return __send_signal(sig, info, t, group, 0);
+	int from_ancestor_ns = 0;
+
+#ifdef CONFIG_PID_NS
+	if (!is_si_special(info) && SI_FROMUSER(info) &&
+			task_pid_nr_ns(current, task_active_pid_ns(t)) <= 0)
+		from_ancestor_ns = 1;
+#endif
+
+	return __send_signal(sig, info, t, group, from_ancestor_ns);
 }
 
 int print_fatal_signals;
@@ -1336,7 +1346,7 @@ int send_sigqueue(struct sigqueue *q, st
 		goto ret;
 
 	ret = 1; /* the signal is ignored */
-	if (!prepare_signal(sig, t))
+	if (!prepare_signal(sig, t, 0))
 		goto out;
 
 	ret = 0;
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

origin.patch
linux-next.patch

