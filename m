From: akpm@linux-foundation.org
Subject: + kthread-introduce-to_live_kthread.patch added to -mm tree
Date: Mon, 11 Mar 2013 14:07:49 -0700
Message-ID: <20130311210749.BD6FA5A41D4@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:64760 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3CKVHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 17:07:51 -0400
Received: by mail-ye0-f202.google.com with SMTP id q5so429681yen.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 14:07:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, namhyung@kernel.org, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rusty@rustcorp.com.au, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de


The patch titled
     Subject: kthread: introduce to_live_kthread()
has been added to the -mm tree.  Its filename is
     kthread-introduce-to_live_kthread.patch

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
 
 /**
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

