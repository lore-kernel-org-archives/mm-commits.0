From: akpm@linux-foundation.org
Subject: + change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch added to -mm tree
Date: Fri, 13 Apr 2007 14:16:09 -0700
Message-ID: <200704132116.l3DLGuh0009615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52539 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030433AbXDMVRI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 17:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com


The patch titled
     change kernel threads to ignore signals instead of blocking them
has been added to the -mm tree.  Its filename is
     change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1302,6 +1302,7 @@ extern int in_egroup_p(gid_t);
 
 extern void proc_caches_init(void);
 extern void flush_signals(struct task_struct *);
+extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
 extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
 
diff -puN kernel/exit.c~change-kernel-threads-to-ignore-signals-instead-of-blocking-them kernel/exit.c
--- a/kernel/exit.c~change-kernel-threads-to-ignore-signals-instead-of-blocking-them
+++ a/kernel/exit.c
@@ -350,7 +350,7 @@ int disallow_signal(int sig)
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
@@ -328,6 +328,16 @@ void flush_signals(struct task_struct *t
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

kernel-doc-fix-plisth-comments.patch
git-dvb.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-refrigerator-vs-thaw_process-race.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
add-a-new-deferrable-delayed-work-init.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
workqueue-introduce-wq_per_cpu-helper.patch
make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
ipvs-flush-defense_work-before-module-unload.patch
workqueue-kill-noautorel-works.patch
worker_thread-dont-play-with-signals.patch
worker_thread-fix-racy-try_to_freeze-usage.patch
zap_other_threads-remove-unneeded-exit_signal-change.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
____call_usermodehelper-dont-flush_signals.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
kthread-dont-depend-on-work-queues-take-2.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
usbatm_heavy_init-dont-use-clone_sighand.patch
pnpbios_thread_init-dont-use-clone_sighand.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
dont-init-pgrp-and-__session-in-init_signals.patch
