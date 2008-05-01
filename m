From: akpm@linux-foundation.org
Subject: - pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:29 -0700
Message-ID: <200805010931.m419VTnq030878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758000AbYEAJbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pids: sys_getpgid: fix unsafe *pid usage, s/tasklist/rcu/
has been removed from the -mm tree.  Its filename was
     pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pids: sys_getpgid: fix unsafe *pid usage, s/tasklist/rcu/
From: Oleg Nesterov <oleg@tv-sign.ru>

1. sys_getpgid() needs rcu_read_lock() to derive the pgrp _nr, even if
   the task is current, otherwise we can race with another thread which
   does sys_setpgid().

2. Use rcu_read_lock() instead of tasklist_lock when pid != 0, make sure
   that we don't use the NULL pid if the task exits right after successful
   find_task_by_vpid().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff -puN kernel/sys.c~pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu kernel/sys.c
--- a/kernel/sys.c~pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu
+++ a/kernel/sys.c
@@ -991,31 +991,37 @@ out:
 
 asmlinkage long sys_getpgid(pid_t pid)
 {
+	struct task_struct *p;
+	struct pid *grp;
+	int retval;
+
+	rcu_read_lock();
 	if (!pid)
-		return task_pgrp_vnr(current);
+		grp = task_pgrp(current);
 	else {
-		int retval;
-		struct task_struct *p;
-
-		read_lock(&tasklist_lock);
-		p = find_task_by_vpid(pid);
 		retval = -ESRCH;
-		if (p) {
-			retval = security_task_getpgid(p);
-			if (!retval)
-				retval = task_pgrp_vnr(p);
-		}
-		read_unlock(&tasklist_lock);
-		return retval;
+		p = find_task_by_vpid(pid);
+		if (!p)
+			goto out;
+		grp = task_pgrp(p);
+		if (!grp)
+			goto out;
+
+		retval = security_task_getpgid(p);
+		if (retval)
+			goto out;
 	}
+	retval = pid_vnr(grp);
+out:
+	rcu_read_unlock();
+	return retval;
 }
 
 #ifdef __ARCH_WANT_SYS_GETPGRP
 
 asmlinkage long sys_getpgrp(void)
 {
-	/* SMP - assuming writes are word atomic this is fine */
-	return task_pgrp_vnr(current);
+	return sys_getpgid(0);
 }
 
 #endif
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

