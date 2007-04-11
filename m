From: akpm@linux-foundation.org
Subject: - make-kernel-threads-invisible-to-sbin-init.patch removed from -mm tree
Date: Tue, 10 Apr 2007 23:49:44 -0700
Message-ID: <200704110649.l3B6niCv030704@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33832 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbXDKGuT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:50:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, ebiederm@xmission.com, holt@sgi.com, jengelh@linux01.gwdg.de, mingo@elte.hu, roland@redhat.com, serge@hallyn.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     make kernel threads invisible to /sbin/init
has been removed from the -mm tree.  Its filename was
     make-kernel-threads-invisible-to-sbin-init.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: make kernel threads invisible to /sbin/init
From: Oleg Nesterov <oleg@tv-sign.ru>

1. rename reparent_to_init() to reparent_kthread() and export it

2. use init_pid_ns.child_reaper instead of child_reaper(current)

3. set ->exit_signal = -1, so init can't see us and we don't use
   it to reap the task.

4. add reparent_kthread() to kthread() and stopmachine()

See also

	http://marc.info/?t=117580282200003&r=1
	http://marc.info/?t=95299284800003&r=1

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 kernel/exit.c         |   16 ++++++++--------
 kernel/kthread.c      |    1 +
 kernel/stop_machine.c |    1 +
 4 files changed, 11 insertions(+), 8 deletions(-)

diff -puN include/linux/sched.h~make-kernel-threads-invisible-to-sbin-init include/linux/sched.h
--- a/include/linux/sched.h~make-kernel-threads-invisible-to-sbin-init
+++ a/include/linux/sched.h
@@ -1404,6 +1404,7 @@ extern void exit_itimers(struct signal_s
 
 extern NORET_TYPE void do_group_exit(int);
 
+extern void reparent_kthread(void);
 extern void daemonize(const char *, ...);
 extern int allow_signal(int);
 extern int disallow_signal(int);
diff -puN kernel/exit.c~make-kernel-threads-invisible-to-sbin-init kernel/exit.c
--- a/kernel/exit.c~make-kernel-threads-invisible-to-sbin-init
+++ a/kernel/exit.c
@@ -257,7 +257,7 @@ static int has_stopped_jobs(struct pid *
 }
 
 /**
- * reparent_to_init - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
+ * reparent_kthread - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
  *
  * If a kernel thread is launched as a result of a system call, or if
  * it ever exits, it should generally reparent itself to init so that
@@ -266,20 +266,20 @@ static int has_stopped_jobs(struct pid *
  * The various task state such as scheduling policy and priority may have
  * been inherited from a user process, so we reset them to sane values here.
  *
- * NOTE that reparent_to_init() gives the caller full capabilities.
+ * NOTE that reparent_kthread() gives the caller full capabilities.
  */
-static void reparent_to_init(void)
+void reparent_kthread(void)
 {
 	write_lock_irq(&tasklist_lock);
 
 	ptrace_unlink(current);
 	remove_parent(current);
-	current->parent = child_reaper(current);
-	current->real_parent = child_reaper(current);
+	current->parent = init_pid_ns.child_reaper;
+	current->real_parent = current->parent;
 	add_parent(current);
 
-	/* Set the exit signal to SIGCHLD so we signal init on exit */
-	current->exit_signal = SIGCHLD;
+	/* make the task auto-reap */
+	current->exit_signal = -1;
 
 	security_task_reparent_to_init(current);
 	write_unlock_irq(&tasklist_lock);
@@ -393,7 +393,7 @@ void daemonize(const char *name, ...)
 	current->files = init_task.files;
 	atomic_inc(&current->files->count);
 
-	reparent_to_init();
+	reparent_kthread();
 
 	if (!has_rt_policy(current) && (task_nice(current) < 0))
 		set_user_nice(current, 0);
diff -puN kernel/kthread.c~make-kernel-threads-invisible-to-sbin-init kernel/kthread.c
--- a/kernel/kthread.c~make-kernel-threads-invisible-to-sbin-init
+++ a/kernel/kthread.c
@@ -82,6 +82,7 @@ static int kthread(void *_create)
 	sigset_t blocked;
 	int ret = -EINTR;
 
+	reparent_kthread();
 	kthread_exit_files();
 
 	/* Copy data: it's on keventd's stack */
diff -puN kernel/stop_machine.c~make-kernel-threads-invisible-to-sbin-init kernel/stop_machine.c
--- a/kernel/stop_machine.c~make-kernel-threads-invisible-to-sbin-init
+++ a/kernel/stop_machine.c
@@ -34,6 +34,7 @@ static int stopmachine(void *cpu)
 	int irqs_disabled = 0;
 	int prepared = 0;
 
+	reparent_kthread();
 	set_cpus_allowed(current, cpumask_of_cpu((int)(long)cpu));
 
 	/* Ack: we are alive */
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

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
make-kernel-threads-invisible-to-sbin-init.patch
reparent-kernel-threads-to-swapper.patch
dont-init-pgrp-and-__session-in-init_signals.patch
