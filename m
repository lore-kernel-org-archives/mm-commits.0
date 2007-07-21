From: akpm@linux-foundation.org
Subject: + whitespace-fixes-task-exit-handling.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:19:08 -0700
Message-ID: <200707210019.l6L0J82w023923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbXGUA0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:26:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com


The patch titled
     whitespace fixes: task exit handling
has been added to the -mm tree.  Its filename is
     whitespace-fixes-task-exit-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: task exit handling
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/exit.c~whitespace-fixes-task-exit-handling kernel/exit.c
--- a/kernel/exit.c~whitespace-fixes-task-exit-handling
+++ a/kernel/exit.c
@@ -414,7 +414,7 @@ void daemonize(const char *name, ...)
 	current->nsproxy = init_task.nsproxy;
 	get_task_namespaces(current);
 
- 	exit_files(current);
+	exit_files(current);
 	current->files = init_task.files;
 	atomic_inc(&current->files->count);
 
@@ -801,9 +801,9 @@ static void exit_notify(struct task_stru
 	 * and we were the only connection outside, so our pgrp
 	 * is about to become orphaned.
 	 */
-	 
+
 	t = tsk->real_parent;
-	
+
 	pgrp = task_pgrp(tsk);
 	if ((task_pgrp(t) != pgrp) &&
 	    (task_session(t) == task_session(tsk)) &&
@@ -813,10 +813,10 @@ static void exit_notify(struct task_stru
 		__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
 	}
 
-	/* Let father know we died 
+	/* Let father know we died
 	 *
 	 * Thread signals are configurable, but you aren't going to use
-	 * that to send signals to arbitary processes. 
+	 * that to send signals to arbitary processes.
 	 * That stops right now.
 	 *
 	 * If the parent exec id doesn't match the exec id we saved
@@ -826,9 +826,9 @@ static void exit_notify(struct task_stru
 	 * If our self_exec id doesn't match our parent_exec_id then
 	 * we have changed execution domain as these two values started
 	 * the same after a fork.
-	 *	
+	 *
 	 */
-	
+
 	if (tsk->exit_signal != SIGCHLD && tsk->exit_signal != -1 &&
 	    ( tsk->parent_exec_id != t->self_exec_id  ||
 	      tsk->self_exec_id != tsk->parent_exec_id)
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
