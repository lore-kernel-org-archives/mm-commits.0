From: akpm@linux-foundation.org
Subject: + do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch added to -mm tree
Date: Thu, 02 Jul 2009 14:26:49 -0700
Message-ID: <200907022126.n62LQoXX021457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683AbZGBV1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 17:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, vmayatsk@redhat.com


The patch titled
     do_wait() wakeup optimization: change __wake_up_parent() to use filtered wakeup
has been added to the -mm tree.  Its filename is
     do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait() wakeup optimization: change __wake_up_parent() to use filtered wakeup
From: Oleg Nesterov <oleg@redhat.com>

Ratan Nalumasu reported that in a process with many threads doing
unnecessary wakeups.  Every waiting thread in the process wakes up to loop
through the children and see that the only ones it cares about are still
not ready.

Now that we have struct wait_opts we can change do_wait/__wake_up_parent
to use filtered wakeups.

We can make child_wait_callback() more clever later, right now it only
checks eligible_child().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup kernel/exit.c
--- a/kernel/exit.c~do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup
+++ a/kernel/exit.c
@@ -1093,6 +1093,7 @@ struct wait_opts {
 	int __user		*wo_stat;
 	struct rusage __user	*wo_rusage;
 
+	wait_queue_t		child_wait;
 	int			notask_error;
 };
 
@@ -1566,20 +1567,35 @@ static int ptrace_do_wait(struct wait_op
 	return 0;
 }
 
+static int child_wait_callback(wait_queue_t *wait, unsigned mode,
+				int sync, void *key)
+{
+	struct wait_opts *wo = container_of(wait, struct wait_opts,
+						child_wait);
+	struct task_struct *p = key;
+
+	if (!eligible_child(wo, p))
+		return 0;
+
+	return default_wake_function(wait, mode, sync, key);
+}
+
 void __wake_up_parent(struct task_struct *p, struct task_struct *parent)
 {
-	wake_up_interruptible_sync(&parent->signal->wait_chldexit);
+	__wake_up_sync_key(&parent->signal->wait_chldexit,
+				TASK_INTERRUPTIBLE, 1, p);
 }
 
 static long do_wait(struct wait_opts *wo)
 {
-	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int retval;
 
 	trace_sched_process_wait(wo->wo_pid);
 
-	add_wait_queue(&current->signal->wait_chldexit,&wait);
+	init_waitqueue_func_entry(&wo->child_wait, child_wait_callback);
+	wo->child_wait.private = current;
+	add_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 repeat:
 	/*
 	 * If there is nothing that can match our critiera just get out.
@@ -1620,7 +1636,8 @@ notask:
 	}
 end:
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&current->signal->wait_chldexit,&wait);
+	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
+
 	if (wo->wo_info) {
 		struct siginfo __user *infop = wo->wo_info;
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cred_guard_mutex-do-not-return-eintr-to-user-space.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

