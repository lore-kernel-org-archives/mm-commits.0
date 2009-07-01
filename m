From: akpm@linux-foundation.org
Subject: [to-be-updated] signals-change-__wake_up_parent-to-use-filtered-wakeup.patch removed from -mm tree
Date: Wed, 01 Jul 2009 13:39:05 -0700
Message-ID: <200907012039.n61Kd5MQ019513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbZGAUkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 16:40:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: change __wake_up_parent() to use filtered wakeup
has been removed from the -mm tree.  Its filename was
     signals-change-__wake_up_parent-to-use-filtered-wakeup.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: change __wake_up_parent() to use filtered wakeup
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
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c   |   22 +++++++++++++++++++---
 kernel/signal.c |    3 ++-
 2 files changed, 21 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~signals-change-__wake_up_parent-to-use-filtered-wakeup kernel/exit.c
--- a/kernel/exit.c~signals-change-__wake_up_parent-to-use-filtered-wakeup
+++ a/kernel/exit.c
@@ -1093,6 +1093,7 @@ struct wait_opts {
 	int __user		*wo_stat;
 	struct rusage __user	*wo_rusage;
 
+	wait_queue_t		child_wait;
 	int			notask_error;
 };
 
@@ -1566,15 +1567,29 @@ static int ptrace_do_wait(struct wait_op
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
@@ -1615,7 +1630,8 @@ notask:
 	}
 end:
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&current->signal->wait_chldexit,&wait);
+	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
+
 	if (wo->wo_info) {
 		struct siginfo __user *infop = wo->wo_info;
 
diff -puN kernel/signal.c~signals-change-__wake_up_parent-to-use-filtered-wakeup kernel/signal.c
--- a/kernel/signal.c~signals-change-__wake_up_parent-to-use-filtered-wakeup
+++ a/kernel/signal.c
@@ -1388,7 +1388,8 @@ ret:
 static inline void __wake_up_parent(struct task_struct *p,
 				    struct task_struct *parent)
 {
-	wake_up_interruptible_sync(&parent->signal->wait_chldexit);
+	__wake_up_sync_key(&parent->signal->wait_chldexit,
+				TASK_INTERRUPTIBLE, 1, p);
 }
 
 /*
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cred_guard_mutex-do-not-return-eintr-to-user-space.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-change-__wake_up_parent-to-use-filtered-wakeup.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

