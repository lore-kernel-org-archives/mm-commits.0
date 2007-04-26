From: akpm@linux-foundation.org
Subject: + return-eperm-not-echild-on-security_task_wait-failure.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:57:08 -0700
Message-ID: <200704260057.l3Q0v8G1017461@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020AbXDZA6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov


The patch titled
     Return EPERM not ECHILD on security_task_wait failure
has been added to the -mm tree.  Its filename is
     return-eperm-not-echild-on-security_task_wait-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~return-eperm-not-echild-on-security_task_wait-failure kernel/exit.c
--- a/kernel/exit.c~return-eperm-not-echild-on-security_task_wait-failure
+++ a/kernel/exit.c
@@ -1067,7 +1067,7 @@ static int eligible_child(pid_t pid, int
 		return 2;
 
 	if (security_task_wait(p))
-		return 0;
+		return -1;
 
 	return 1;
 }
@@ -1449,6 +1449,7 @@ static long do_wait(pid_t pid, int optio
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int flag, retval;
+	int allowed, denied;
 
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
@@ -1457,6 +1458,7 @@ repeat:
 	 * match our criteria, even if we are not able to reap it yet.
 	 */
 	flag = 0;
+	allowed = denied = 0;
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
@@ -1472,6 +1474,12 @@ repeat:
 			if (!ret)
 				continue;
 
+			if (unlikely(ret < 0)) {
+				denied = 1;
+				continue;
+			}
+			allowed = 1;
+
 			switch (p->state) {
 			case TASK_TRACED:
 				/*
@@ -1570,6 +1578,8 @@ check_continued:
 		goto repeat;
 	}
 	retval = -ECHILD;
+	if (unlikely(denied) && !allowed)
+		retval = -EPERM;
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
_

Patches currently in -mm which might be from roland@redhat.com are

return-eperm-not-echild-on-security_task_wait-failure.patch
return-eperm-not-echild-on-security_task_wait-failure-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
