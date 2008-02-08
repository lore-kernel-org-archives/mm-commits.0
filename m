From: akpm@linux-foundation.org
Subject: - wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:47 -0800
Message-ID: <200802082013.m18KDSWX010292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756043AbYBHUv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:51:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_task_continued/zombie: don't use task_pid_nr_ns() lockless
has been removed from the -mm tree.  Its filename was
     wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait_task_continued/zombie: don't use task_pid_nr_ns() lockless
From: Oleg Nesterov <oleg@tv-sign.ru>

Surprise, other 2 wait_task_() functions also abuse task_pid_nr_ns().  May
cause read-after-free or report nr == 0 in wait_task_continued(). 
wait_task_zombie() doesn't have this problem, but still it is better to cache
pid_t rather than call task_pid_nr_ns() 3 times on the saved pid_namespace.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN kernel/exit.c~wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless kernel/exit.c
--- a/kernel/exit.c~wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless
+++ a/kernel/exit.c
@@ -1189,12 +1189,9 @@ static int wait_task_zombie(struct task_
 {
 	unsigned long state;
 	int retval, status, traced;
-	struct pid_namespace *ns;
-
-	ns = current->nsproxy->pid_ns;
+	pid_t pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
 
 	if (unlikely(noreap)) {
-		pid_t pid = task_pid_nr_ns(p, ns);
 		uid_t uid = p->uid;
 		int exit_code = p->exit_code;
 		int why, status;
@@ -1313,11 +1310,11 @@ static int wait_task_zombie(struct task_
 			retval = put_user(status, &infop->si_status);
 	}
 	if (!retval && infop)
-		retval = put_user(task_pid_nr_ns(p, ns), &infop->si_pid);
+		retval = put_user(pid, &infop->si_pid);
 	if (!retval && infop)
 		retval = put_user(p->uid, &infop->si_uid);
 	if (!retval)
-		retval = task_pid_nr_ns(p, ns);
+		retval = pid;
 
 	if (traced) {
 		write_lock_irq(&tasklist_lock);
@@ -1436,7 +1433,6 @@ static int wait_task_continued(struct ta
 	int retval;
 	pid_t pid;
 	uid_t uid;
-	struct pid_namespace *ns;
 
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
 		return 0;
@@ -1451,8 +1447,7 @@ static int wait_task_continued(struct ta
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	spin_unlock_irq(&p->sighand->siglock);
 
-	ns = current->nsproxy->pid_ns;
-	pid = task_pid_nr_ns(p, ns);
+	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
 	uid = p->uid;
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
@@ -1463,7 +1458,7 @@ static int wait_task_continued(struct ta
 		if (!retval && stat_addr)
 			retval = put_user(0xffff, stat_addr);
 		if (!retval)
-			retval = task_pid_nr_ns(p, ns);
+			retval = pid;
 	} else {
 		retval = wait_noreap_copyout(p, pid, uid,
 					     CLD_CONTINUED, SIGCONT,
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
