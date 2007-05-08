From: akpm@linux-foundation.org
Subject: - return-eperm-not-echild-on-security_task_wait-failure.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:35 -0700
Message-ID: <200705080004.l4804ZkH009024@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbXEHAFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     Return EPERM not ECHILD on security_task_wait failure
has been removed from the -mm tree.  Its filename was
     return-eperm-not-echild-on-security_task_wait-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Return EPERM not ECHILD on security_task_wait failure
From: Roland McGrath <roland@redhat.com>

wait* syscalls return -ECHILD even when an individual PID of a live child
was requested explicitly, when security_task_wait denies the operation. 
This means that something like a broken SELinux policy can produce an
unexpected failure that looks just like a bug with wait or ptrace or
something.

This patch makes do_wait return -EACCES (or other appropriate error returned
from security_task_wait() instead of -ECHILD if some children were ruled out
solely because security_task_wait failed.

[jmorris@namei.org: switch error code to EACCES]
Signed-off-by: Roland McGrath <roland@redhat.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~return-eperm-not-echild-on-security_task_wait-failure kernel/exit.c
--- a/kernel/exit.c~return-eperm-not-echild-on-security_task_wait-failure
+++ a/kernel/exit.c
@@ -1033,6 +1033,8 @@ asmlinkage void sys_exit_group(int error
 
 static int eligible_child(pid_t pid, int options, struct task_struct *p)
 {
+	int err;
+
 	if (pid > 0) {
 		if (p->pid != pid)
 			return 0;
@@ -1066,8 +1068,9 @@ static int eligible_child(pid_t pid, int
 	if (delay_group_leader(p))
 		return 2;
 
-	if (security_task_wait(p))
-		return 0;
+	err = security_task_wait(p);
+	if (err)
+		return err;
 
 	return 1;
 }
@@ -1449,6 +1452,7 @@ static long do_wait(pid_t pid, int optio
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int flag, retval;
+	int allowed, denied;
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
@@ -1457,6 +1461,7 @@ repeat:
 	 * match our criteria, even if we are not able to reap it yet.
 	 */
 	flag = 0;
+	allowed = denied = 0;
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
@@ -1472,6 +1477,12 @@ repeat:
 			if (!ret)
 				continue;
 
+			if (unlikely(ret < 0)) {
+				denied = ret;
+				continue;
+			}
+			allowed = 1;
+
 			switch (p->state) {
 			case TASK_TRACED:
 				/*
@@ -1570,6 +1581,8 @@ check_continued:
 		goto repeat;
 	}
 	retval = -ECHILD;
+	if (unlikely(denied) && !allowed)
+		retval = denied;
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
futex-restartable-futex_wait.patch
move-sig_kernel_-et-al-macros-to-linux-signalh.patch
