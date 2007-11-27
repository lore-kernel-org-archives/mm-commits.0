From: akpm@linux-foundation.org
Subject: + do_wait-fix-security-checks.patch added to -mm tree
Date: Mon, 26 Nov 2007 23:15:20 -0800
Message-ID: <200711270715.lAR7FK1C032708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32805 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbXK0HQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 02:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, chrisw@sous-sol.org, eparis@redhat.com, jmorris@namei.org, roland@redhat.com, sds@tycho.nsa.gov


The patch titled
     do_wait: fix security checks
has been added to the -mm tree.  Its filename is
     do_wait-fix-security-checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do_wait: fix security checks
From: Oleg Nesterov <oleg@tv-sign.ru>

Imho, the current usage of security_task_wait() is not logical.

Suppose we have the single child p, and security_task_wait(p) return -EANY. 
In that case waitpid(-1) returns this error.  Why?  Isn't it better to return
ECHLD?  We don't really have the reapable childs.

Now suppose that child was stealed by gdb.  In that case we find this child on
->ptrace_children and set flag = 1, but we don't check that the child was
denied.  So, do_wait(..., WNOHANG) returns 0, this doesn't match the behaviour
above.  Without WNOHANG do_wait() blocks only to return the error later, when
the child will be untraced.  Inho, really strange.

I think eligible_child() should return the error only if the child's pid was
requested explicitly, otherwise we should silently ignore the tasks which were
nacked by security_task_wait().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff -puN kernel/exit.c~do_wait-fix-security-checks kernel/exit.c
--- a/kernel/exit.c~do_wait-fix-security-checks
+++ a/kernel/exit.c
@@ -1139,10 +1139,14 @@ static int eligible_child(pid_t pid, int
 		return 0;
 
 	err = security_task_wait(p);
-	if (err)
-		return err;
+	if (likely(!err))
+		return 1;
 
-	return 1;
+	if (pid <= 0)
+		return 0;
+	/* This child was explicitly requested, abort */
+	read_unlock(&tasklist_lock);
+	return err;
 }
 
 static int wait_noreap_copyout(struct task_struct *p, pid_t pid, uid_t uid,
@@ -1473,7 +1477,6 @@ static long do_wait(pid_t pid, int optio
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int flag, retval;
-	int allowed, denied;
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
@@ -1481,8 +1484,7 @@ repeat:
 	 * We will set this flag if we see any child that might later
 	 * match our criteria, even if we are not able to reap it yet.
 	 */
-	flag = 0;
-	allowed = denied = 0;
+	flag = retval = 0;
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
@@ -1495,13 +1497,8 @@ repeat:
 				continue;
 
 			if (unlikely(ret < 0)) {
-				denied = ret;
-				continue;
-			}
-			allowed = 1;
-
-			retval = 0;
-			if (is_task_stopped_or_traced(p)) {
+				retval = ret;
+			} else if (is_task_stopped_or_traced(p)) {
 				/*
 				 * It's stopped now, so it might later
 				 * continue, exit, or stop again.
@@ -1539,24 +1536,25 @@ repeat:
 			if (retval != 0) /* tasklist_lock released */
 				goto end;
 		}
-		if (!flag) {
-			list_for_each_entry(p, &tsk->ptrace_children,
-					    ptrace_list) {
-				if (!eligible_child(pid, options, p))
-					continue;
-				flag = 1;
+		if (flag)
+			continue;
+		list_for_each_entry(p, &tsk->ptrace_children, ptrace_list) {
+			flag = eligible_child(pid, options, p);
+			if (!flag)
+				continue;
+			if (likely(flag > 0))
 				break;
-			}
+			retval = flag;
+			goto end;
 		}
 		if (options & __WNOTHREAD)
 			break;
 		tsk = next_thread(tsk);
 		BUG_ON(tsk->signal != current->signal);
 	} while (tsk != current);
-
 	read_unlock(&tasklist_lock);
+
 	if (flag) {
-		retval = 0;
 		if (options & WNOHANG)
 			goto end;
 		retval = -ERESTARTSYS;
@@ -1566,8 +1564,6 @@ repeat:
 		goto repeat;
 	}
 	retval = -ECHILD;
-	if (unlikely(denied) && !allowed)
-		retval = denied;
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
proc-remove-races-from-proc_id_readdir.patch
wait_task_stopped-pass-correct-exit_code-to.patch
use-__set_task_state-for-traced-stopped-tasks.patch
add-task_wakekill.patch
do_wait-remove-one-else-if-branch.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
ptrace_stop-fix-the-race-with-ptrace-detachattach.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
do_wait-factor-out-retval-=-0-checks.patch
ptrace_stop-fix-racy-nonstop_code-setting.patch
wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
