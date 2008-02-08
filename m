From: akpm@linux-foundation.org
Subject: - do_wait-fix-security-checks.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:44 -0800
Message-ID: <200802082013.m18KDPvg010289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763238AbYBHVEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:04:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, chrisw@sous-sol.org, eparis@redhat.com, jmorris@namei.org, roland@redhat.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     do_wait: fix security checks
has been removed from the -mm tree.  Its filename was
     do_wait-fix-security-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

 kernel/exit.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff -puN kernel/exit.c~do_wait-fix-security-checks kernel/exit.c
--- a/kernel/exit.c~do_wait-fix-security-checks
+++ a/kernel/exit.c
@@ -1142,10 +1142,14 @@ static int eligible_child(pid_t pid, int
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
@@ -1476,7 +1480,6 @@ static long do_wait(pid_t pid, int optio
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int flag, retval;
-	int allowed, denied;
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
@@ -1484,8 +1487,7 @@ repeat:
 	 * We will set this flag if we see any child that might later
 	 * match our criteria, even if we are not able to reap it yet.
 	 */
-	flag = 0;
-	allowed = denied = 0;
+	flag = retval = 0;
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
@@ -1498,13 +1500,8 @@ repeat:
 				continue;
 
 			if (unlikely(ret < 0)) {
-				denied = ret;
-				continue;
-			}
-			allowed = 1;
-
-			retval = 0;
-			if (task_is_stopped_or_traced(p)) {
+				retval = ret;
+			} else if (task_is_stopped_or_traced(p)) {
 				/*
 				 * It's stopped now, so it might later
 				 * continue, exit, or stop again.
@@ -1544,11 +1541,14 @@ repeat:
 		}
 		if (!flag) {
 			list_for_each_entry(p, &tsk->ptrace_children,
-					    ptrace_list) {
-				if (!eligible_child(pid, options, p))
+								ptrace_list) {
+				flag = eligible_child(pid, options, p);
+				if (!flag)
 					continue;
-				flag = 1;
-				break;
+				if (likely(flag > 0))
+					break;
+				retval = flag;
+				goto end;
 			}
 		}
 		if (options & __WNOTHREAD)
@@ -1556,10 +1556,9 @@ repeat:
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
@@ -1569,8 +1568,6 @@ repeat:
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

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
