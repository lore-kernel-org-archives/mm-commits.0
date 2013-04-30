From: akpm@linux-foundation.org
Subject: [merged] kthread-introduce-to_live_kthread.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:09 -0700
Message-ID: <20130430184309.D7FEC31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:47981 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab3D3SnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:11 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so84403yen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, namhyung@kernel.org, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rusty@rustcorp.com.au, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: introduce to_live_kthread()
has been removed from the -mm tree.  Its filename was
     kthread-introduce-to_live_kthread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kthread: introduce to_live_kthread()

"k->vfork_done != NULL" with a barrier() after to_kthread(k) in
task_get_live_kthread(k) looks unclear, and sub-optimal because we load
->vfork_done twice.

All we need is to ensure that we do not return to_kthread(NULL).  Add a
new trivial helper which loads/checks ->vfork_done once, this also looks
more understandable.

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

 kernel/kthread.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN kernel/kthread.c~kthread-introduce-to_live_kthread kernel/kthread.c
--- a/kernel/kthread.c~kthread-introduce-to_live_kthread
+++ a/kernel/kthread.c
@@ -52,8 +52,21 @@ enum KTHREAD_BITS {
 	KTHREAD_IS_PARKED,
 };
 
-#define to_kthread(tsk)	\
-	container_of((tsk)->vfork_done, struct kthread, exited)
+#define __to_kthread(vfork)	\
+	container_of(vfork, struct kthread, exited)
+
+static inline struct kthread *to_kthread(struct task_struct *k)
+{
+	return __to_kthread(k->vfork_done);
+}
+
+static struct kthread *to_live_kthread(struct task_struct *k)
+{
+	struct completion *vfork = ACCESS_ONCE(k->vfork_done);
+	if (likely(vfork))
+		return __to_kthread(vfork);
+	return NULL;
+}
 
 /**
  * kthread_should_stop - should this kthread return now?
@@ -313,15 +326,8 @@ struct task_struct *kthread_create_on_cp
 
 static struct kthread *task_get_live_kthread(struct task_struct *k)
 {
-	struct kthread *kthread;
-
 	get_task_struct(k);
-	kthread = to_kthread(k);
-	/* It might have exited */
-	barrier();
-	if (k->vfork_done != NULL)
-		return kthread;
-	return NULL;
+	return to_live_kthread(k);
 }
 
 static void __kthread_unpark(struct task_struct *k, struct kthread *kthread)
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

