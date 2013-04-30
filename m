From: akpm@linux-foundation.org
Subject: [merged] kthread-kill-task_get_live_kthread.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:12 -0700
Message-ID: <20130430184312.6CF605A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:47562 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab3D3SnO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:14 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so84130yha.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, namhyung@kernel.org, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rusty@rustcorp.com.au, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: kill task_get_live_kthread()
has been removed from the -mm tree.  Its filename was
     kthread-kill-task_get_live_kthread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kthread: kill task_get_live_kthread()

task_get_live_kthread() looks confusing and unneeded.  It does
get_task_struct() but only kthread_stop() needs this, it can be called
even if the calller doesn't have a reference when we know that this
kthread can't exit until we do kthread_stop().

kthread_park() and kthread_unpark() do not need get_task_struct(), the
callers already have the reference.  And it can not help if we can race
with the exiting kthread anyway, kthread_park() can hang forever in this
case.

Change kthread_park() and kthread_unpark() to use to_live_kthread(),
change kthread_stop() to do get_task_struct() by hand and remove
task_get_live_kthread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN kernel/kthread.c~kthread-kill-task_get_live_kthread kernel/kthread.c
--- a/kernel/kthread.c~kthread-kill-task_get_live_kthread
+++ a/kernel/kthread.c
@@ -324,12 +324,6 @@ struct task_struct *kthread_create_on_cp
 	return p;
 }
 
-static struct kthread *task_get_live_kthread(struct task_struct *k)
-{
-	get_task_struct(k);
-	return to_live_kthread(k);
-}
-
 static void __kthread_unpark(struct task_struct *k, struct kthread *kthread)
 {
 	clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
@@ -356,11 +350,10 @@ static void __kthread_unpark(struct task
  */
 void kthread_unpark(struct task_struct *k)
 {
-	struct kthread *kthread = task_get_live_kthread(k);
+	struct kthread *kthread = to_live_kthread(k);
 
 	if (kthread)
 		__kthread_unpark(k, kthread);
-	put_task_struct(k);
 }
 
 /**
@@ -377,7 +370,7 @@ void kthread_unpark(struct task_struct *
  */
 int kthread_park(struct task_struct *k)
 {
-	struct kthread *kthread = task_get_live_kthread(k);
+	struct kthread *kthread = to_live_kthread(k);
 	int ret = -ENOSYS;
 
 	if (kthread) {
@@ -390,7 +383,6 @@ int kthread_park(struct task_struct *k)
 		}
 		ret = 0;
 	}
-	put_task_struct(k);
 	return ret;
 }
 
@@ -411,10 +403,13 @@ int kthread_park(struct task_struct *k)
  */
 int kthread_stop(struct task_struct *k)
 {
-	struct kthread *kthread = task_get_live_kthread(k);
+	struct kthread *kthread;
 	int ret;
 
 	trace_sched_kthread_stop(k);
+
+	get_task_struct(k);
+	kthread = to_live_kthread(k);
 	if (kthread) {
 		set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
 		__kthread_unpark(k, kthread);
@@ -422,10 +417,9 @@ int kthread_stop(struct task_struct *k)
 		wait_for_completion(&kthread->exited);
 	}
 	ret = k->exit_code;
-
 	put_task_struct(k);
-	trace_sched_kthread_stop_ret(ret);
 
+	trace_sched_kthread_stop_ret(ret);
 	return ret;
 }
 EXPORT_SYMBOL(kthread_stop);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
kthread-implement-probe_kthread_data.patch
workqueue-include-workqueue-info-when-printing-debug-dump-of-a-worker-task.patch
writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps.patch
kernel-smpc-use-=-for-csd_lock.patch
kernel-smpc-remove-priv-of-call_single_data.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch
set_task_comm-kill-the-pointless-memset-wmb.patch
exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lock.patch

