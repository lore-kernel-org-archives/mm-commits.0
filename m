From: akpm@linux-foundation.org
Subject: - change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:37 -0700
Message-ID: <200705092152.l49Lqb79003017@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758957AbXEIVxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     change kernel threads to ignore signals instead of blocking them
has been removed from the -mm tree.  Its filename was
     change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: change kernel threads to ignore signals instead of blocking them
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently kernel threads use sigprocmask(SIG_BLOCK) to protect against
signals.  This doesn't prevent the signal delivery, this only blocks
signal_wake_up().  Every "killall -33 kthreadd" means a "struct siginfo"
leak.

Change kthreadd_setup() to set all handlers to SIG_IGN instead of blocking
them (make a new helper ignore_signals() for that).  If the kernel thread
needs some signal, it should use allow_signal() anyway, and in that case it
should not use CLONE_SIGHAND.

Note that we can't change daemonize() (should die!) in the same way,
because it can be used along with CLONE_SIGHAND.  This means that
allow_signal() still should unblock the signal to work correctly with
daemonize()ed threads.

However, disallow_signal() doesn't block the signal any longer but ignores
it.

NOTE: with or without this patch the kernel threads are not protected from
handle_stop_signal(), this seems harmless, but not good.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 kernel/exit.c         |    2 +-
 kernel/kthread.c      |   17 +++--------------
 kernel/signal.c       |   10 ++++++++++
 4 files changed, 15 insertions(+), 15 deletions(-)

diff -puN include/linux/sched.h~change-kernel-threads-to-ignore-signals-instead-of-blocking-them include/linux/sched.h
--- a/include/linux/sched.h~change-kernel-threads-to-ignore-signals-instead-of-blocking-them
+++ a/include/linux/sched.h
@@ -1318,6 +1318,7 @@ extern int in_egroup_p(gid_t);
 
 extern void proc_caches_init(void);
 extern void flush_signals(struct task_struct *);
+extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
 extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
 
diff -puN kernel/exit.c~change-kernel-threads-to-ignore-signals-instead-of-blocking-them kernel/exit.c
--- a/kernel/exit.c~change-kernel-threads-to-ignore-signals-instead-of-blocking-them
+++ a/kernel/exit.c
@@ -347,7 +347,7 @@ int disallow_signal(int sig)
 		return -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
-	sigaddset(&current->blocked, sig);
+	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
diff -puN kernel/kthread.c~change-kernel-threads-to-ignore-signals-instead-of-blocking-them kernel/kthread.c
--- a/kernel/kthread.c~change-kernel-threads-to-ignore-signals-instead-of-blocking-them
+++ a/kernel/kthread.c
@@ -215,24 +215,13 @@ EXPORT_SYMBOL(kthread_stop);
 static __init void kthreadd_setup(void)
 {
 	struct task_struct *tsk = current;
-	struct k_sigaction sa;
-	sigset_t blocked;
 
 	set_task_comm(tsk, "kthreadd");
 
-	/* Block and flush all signals */
-	sigfillset(&blocked);
-	sigprocmask(SIG_BLOCK, &blocked, NULL);
-	flush_signals(tsk);
-
-	/* SIG_IGN makes children autoreap: see do_notify_parent(). */
-	sa.sa.sa_handler = SIG_IGN;
-	sa.sa.sa_flags = 0;
-	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
-	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
+	ignore_signals(tsk);
 
-	set_user_nice(current, -5);
-	set_cpus_allowed(current, CPU_MASK_ALL);
+	set_user_nice(tsk, -5);
+	set_cpus_allowed(tsk, CPU_MASK_ALL);
 }
 
 int kthreadd(void *unused)
diff -puN kernel/signal.c~change-kernel-threads-to-ignore-signals-instead-of-blocking-them kernel/signal.c
--- a/kernel/signal.c~change-kernel-threads-to-ignore-signals-instead-of-blocking-them
+++ a/kernel/signal.c
@@ -209,6 +209,16 @@ void flush_signals(struct task_struct *t
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 }
 
+void ignore_signals(struct task_struct *t)
+{
+	int i;
+
+	for (i = 0; i < _NSIG; ++i)
+		t->sighand->action[i].sa.sa_handler = SIG_IGN;
+
+	flush_signals(t);
+}
+
 /*
  * Flush all handlers for a task.
  */
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
