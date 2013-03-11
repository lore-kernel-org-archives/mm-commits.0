From: akpm@linux-foundation.org
Subject: + kthread-kill-task_get_live_kthread.patch added to -mm tree
Date: Mon, 11 Mar 2013 14:07:51 -0700
Message-ID: <20130311210751.DA34031C1D8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62851 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3CKVHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 17:07:53 -0400
Received: by mail-vc0-f202.google.com with SMTP id m8so430050vcd.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 14:07:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, namhyung@kernel.org, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rusty@rustcorp.com.au, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de


The patch titled
     Subject: kthread: kill task_get_live_kthread()
has been added to the -mm tree.  Its filename is
     kthread-kill-task_get_live_kthread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 /**
  * kthread_unpark - unpark a thread created by kthread_create().
  * @k:		thread created by kthread_create().
@@ -340,7 +334,7 @@ static struct kthread *task_get_live_kth
  */
 void kthread_unpark(struct task_struct *k)
 {
-	struct kthread *kthread = task_get_live_kthread(k);
+	struct kthread *kthread = to_live_kthread(k);
 
 	if (kthread) {
 		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
@@ -356,7 +350,6 @@ void kthread_unpark(struct task_struct *
 			wake_up_process(k);
 		}
 	}
-	put_task_struct(k);
 }
 
 /**
@@ -373,7 +366,7 @@ void kthread_unpark(struct task_struct *
  */
 int kthread_park(struct task_struct *k)
 {
-	struct kthread *kthread = task_get_live_kthread(k);
+	struct kthread *kthread = to_live_kthread(k);
 	int ret = -ENOSYS;
 
 	if (kthread) {
@@ -386,7 +379,6 @@ int kthread_park(struct task_struct *k)
 		}
 		ret = 0;
 	}
-	put_task_struct(k);
 	return ret;
 }
 
@@ -407,10 +399,13 @@ int kthread_park(struct task_struct *k)
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
 		clear_bit(KTHREAD_SHOULD_PARK, &kthread->flags);
@@ -418,10 +413,9 @@ int kthread_stop(struct task_struct *k)
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

thinkpad-acpi-kill-hotkey_thread_mutex.patch
kthread-introduce-to_live_kthread.patch
kthread-kill-task_get_live_kthread.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
ptrace-add-ability-to-retrieve-signals-without-removing-from-a-queue-v4.patch
selftest-add-a-test-case-for-ptrace_peeksiginfo.patch
signal-always-clear-sa_restorer-on-execve.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch

