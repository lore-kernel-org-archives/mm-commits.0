From: akpm@linux-foundation.org
Subject: - sys_getsid-dont-use-nsproxy-directly.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:15 -0800
Message-ID: <200802082013.m18KDu9x010337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbYBHUys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:54:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     sys_getsid: don't use ->nsproxy directly
has been removed from the -mm tree.  Its filename was
     sys_getsid-dont-use-nsproxy-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_getsid: don't use ->nsproxy directly
From: Oleg Nesterov <oleg@tv-sign.ru>

With the new semantics of find_vpid() we don't need to play with ->nsproxy
explicitely, _vxx() do the right things.

Also s/tasklist/rcu/.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/sys.c~sys_getsid-dont-use-nsproxy-directly kernel/sys.c
--- a/kernel/sys.c~sys_getsid-dont-use-nsproxy-directly
+++ a/kernel/sys.c
@@ -1025,19 +1025,16 @@ asmlinkage long sys_getsid(pid_t pid)
 	else {
 		int retval;
 		struct task_struct *p;
-		struct pid_namespace *ns;
 
-		ns = current->nsproxy->pid_ns;
-
-		read_lock(&tasklist_lock);
-		p = find_task_by_pid_ns(pid, ns);
+		rcu_read_lock();
+		p = find_task_by_vpid(pid);
 		retval = -ESRCH;
 		if (p) {
 			retval = security_task_getsid(p);
 			if (!retval)
-				retval = task_session_nr_ns(p, ns);
+				retval = task_session_vnr(p);
 		}
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		return retval;
 	}
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
