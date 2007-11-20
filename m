From: akpm@linux-foundation.org
Subject: + use-__set_task_state-for-traced-stopped-tasks.patch added to -mm tree
Date: Mon, 19 Nov 2007 21:31:04 -0800
Message-ID: <200711200531.lAK5V42k015800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755806AbXKTFbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 00:31:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     use __set_task_state() for TRACED/STOPPED tasks
has been added to the -mm tree.  Its filename is
     use-__set_task_state-for-traced-stopped-tasks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use __set_task_state() for TRACED/STOPPED tasks
From: Oleg Nesterov <oleg@tv-sign.ru>

1. It is much easier to grep for ->state change if __set_task_state() is used
   instead of the direct assignment.

2. ptrace_stop() and handle_group_stop() use set_task_state() which adds the
   unneeded mb() (btw even if we use mb() it is still possible that do_wait()
   sees the new ->state but not ->exit_code, but this is ok).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c   |    2 +-
 kernel/ptrace.c |   12 +++++-------
 kernel/signal.c |    4 ++--
 3 files changed, 8 insertions(+), 10 deletions(-)

diff -puN kernel/fork.c~use-__set_task_state-for-traced-stopped-tasks kernel/fork.c
--- a/kernel/fork.c~use-__set_task_state-for-traced-stopped-tasks
+++ a/kernel/fork.c
@@ -1479,7 +1479,7 @@ long do_fork(unsigned long clone_flags,
 		if (!(clone_flags & CLONE_STOPPED))
 			wake_up_new_task(p, clone_flags);
 		else
-			p->state = TASK_STOPPED;
+			__set_task_state(p, TASK_STOPPED);
 
 		if (unlikely (trace)) {
 			current->ptrace_message = nr;
diff -puN kernel/ptrace.c~use-__set_task_state-for-traced-stopped-tasks kernel/ptrace.c
--- a/kernel/ptrace.c~use-__set_task_state-for-traced-stopped-tasks
+++ a/kernel/ptrace.c
@@ -53,7 +53,7 @@ void ptrace_untrace(struct task_struct *
 	spin_lock(&child->sighand->siglock);
 	if (is_task_traced(child)) {
 		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
-			child->state = TASK_STOPPED;
+			__set_task_state(child, TASK_STOPPED);
 		} else {
 			signal_wake_up(child, 1);
 		}
@@ -103,18 +103,16 @@ int ptrace_check_attach(struct task_stru
 	    && child->signal != NULL) {
 		ret = 0;
 		spin_lock_irq(&child->sighand->siglock);
-		if (is_task_stopped(child)) {
-			child->state = TASK_TRACED;
-		} else if (!is_task_traced(child) && !kill) {
+		if (is_task_stopped(child))
+			__set_task_state(child, TASK_TRACED);
+		else if (!is_task_traced(child) && !kill)
 			ret = -ESRCH;
-		}
 		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
 
-	if (!ret && !kill) {
+	if (!ret && !kill)
 		wait_task_inactive(child);
-	}
 
 	/* All systems go.. */
 	return ret;
diff -puN kernel/signal.c~use-__set_task_state-for-traced-stopped-tasks kernel/signal.c
--- a/kernel/signal.c~use-__set_task_state-for-traced-stopped-tasks
+++ a/kernel/signal.c
@@ -1617,7 +1617,7 @@ static void ptrace_stop(int exit_code, i
 	current->exit_code = exit_code;
 
 	/* Let the debugger run.  */
-	set_current_state(TASK_TRACED);
+	__set_current_state(TASK_TRACED);
 	spin_unlock_irq(&current->sighand->siglock);
 	try_to_freeze();
 	read_lock(&tasklist_lock);
@@ -1781,7 +1781,7 @@ static int handle_group_stop(void)
 	if (stop_count == 0)
 		current->signal->flags = SIGNAL_STOP_STOPPED;
 	current->exit_code = current->signal->group_exit_code;
-	set_current_state(TASK_STOPPED);
+	__set_current_state(TASK_STOPPED);
 	spin_unlock_irq(&current->sighand->siglock);
 	finish_stop(stop_count);
 	return 1;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
proc-remove-races-from-proc_id_readdir.patch
use-__set_task_state-for-traced-stopped-tasks.patch
add-task_wakekill.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
