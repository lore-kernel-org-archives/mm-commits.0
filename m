From: akpm@linux-foundation.org
Subject: [merged] do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:08 -0700
Message-ID: <200909241935.n8OJZ8Jo032286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613AbZIXTfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:35:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, jmorris@namei.org, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, valdis.kletnieks@vt.edu, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait() wakeup optimization: change __wake_up_parent() to use filtered wakeup
has been removed from the -mm tree.  Its filename was
     do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: James Morris <jmorris@namei.org>
Tested-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c            |   25 +++++++++++++++++++++----
 security/selinux/hooks.c |    2 +-
 2 files changed, 22 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup kernel/exit.c
--- a/kernel/exit.c~do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup
+++ a/kernel/exit.c
@@ -1097,6 +1097,7 @@ struct wait_opts {
 	int __user		*wo_stat;
 	struct rusage __user	*wo_rusage;
 
+	wait_queue_t		child_wait;
 	int			notask_error;
 };
 
@@ -1570,20 +1571,35 @@ static int ptrace_do_wait(struct wait_op
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
@@ -1624,7 +1640,8 @@ notask:
 	}
 end:
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&current->signal->wait_chldexit,&wait);
+	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
+
 	if (wo->wo_info) {
 		struct siginfo __user *infop = wo->wo_info;
 
diff -puN security/selinux/hooks.c~do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup security/selinux/hooks.c
--- a/security/selinux/hooks.c~do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup
+++ a/security/selinux/hooks.c
@@ -2411,7 +2411,7 @@ static void selinux_bprm_committed_creds
 	/* Wake up the parent if it is waiting so that it can recheck
 	 * wait permission to the new task SID. */
 	read_lock(&tasklist_lock);
-	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);
+	__wake_up_parent(current, current->real_parent);
 	read_unlock(&tasklist_lock);
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
utrace-core.patch

