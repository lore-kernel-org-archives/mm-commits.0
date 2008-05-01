From: akpm@linux-foundation.org
Subject: - pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:27 -0700
Message-ID: <200805010931.m419VRvv030875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757651AbYEAJbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pids: sys_getsid: fix unsafe *pid usage, fix possible 0 instead of -ESRCH
has been removed from the -mm tree.  Its filename was
     pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pids: sys_getsid: fix unsafe *pid usage, fix possible 0 instead of -ESRCH
From: Oleg Nesterov <oleg@tv-sign.ru>

1. sys_getsid() needs rcu_read_lock() to derive the session _nr, even if
   the task is current, otherwise we can race with another thread which
   does sys_setsid().

2. The task can exit between find_task_by_vpid() and task_session_vnr(),
   in that unlikely case sys_getsid() returns 0 instead of -ESRCH.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff -puN kernel/sys.c~pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch kernel/sys.c
--- a/kernel/sys.c~pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch
+++ a/kernel/sys.c
@@ -1022,23 +1022,30 @@ asmlinkage long sys_getpgrp(void)
 
 asmlinkage long sys_getsid(pid_t pid)
 {
+	struct task_struct *p;
+	struct pid *sid;
+	int retval;
+
+	rcu_read_lock();
 	if (!pid)
-		return task_session_vnr(current);
+		sid = task_session(current);
 	else {
-		int retval;
-		struct task_struct *p;
-
-		rcu_read_lock();
-		p = find_task_by_vpid(pid);
 		retval = -ESRCH;
-		if (p) {
-			retval = security_task_getsid(p);
-			if (!retval)
-				retval = task_session_vnr(p);
-		}
-		rcu_read_unlock();
-		return retval;
+		p = find_task_by_vpid(pid);
+		if (!p)
+			goto out;
+		sid = task_session(p);
+		if (!sid)
+			goto out;
+
+		retval = security_task_getsid(p);
+		if (retval)
+			goto out;
 	}
+	retval = pid_vnr(sid);
+out:
+	rcu_read_unlock();
+	return retval;
 }
 
 asmlinkage long sys_setsid(void)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

