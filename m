From: akpm@linux-foundation.org
Subject: - fix-setsid-for-sub-namespace-sbin-init.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:53 -0800
Message-ID: <200802082013.m18KDYAO010301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418AbYBHU7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:59:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     fix setsid() for sub-namespace /sbin/init
has been removed from the -mm tree.  Its filename was
     fix-setsid-for-sub-namespace-sbin-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix setsid() for sub-namespace /sbin/init
From: Oleg Nesterov <oleg@tv-sign.ru>

sys_setsid() still deals with pid_t's from the global namespace. This means
that the "session > 1" check can't help for sub-namespace init, setsid() can't
succeed because copy_process(CLONE_NEWPID) populates PIDTYPE_PGID/SID links.

Remove the usage of task_struct->pid and convert the code to use "struct pid".
This also simplifies and speedups the code, saves one find_pid().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN kernel/sys.c~fix-setsid-for-sub-namespace-sbin-init kernel/sys.c
--- a/kernel/sys.c~fix-setsid-for-sub-namespace-sbin-init
+++ a/kernel/sys.c
@@ -1045,35 +1045,33 @@ asmlinkage long sys_getsid(pid_t pid)
 asmlinkage long sys_setsid(void)
 {
 	struct task_struct *group_leader = current->group_leader;
-	pid_t session;
+	struct pid *sid = task_pid(group_leader);
+	pid_t session = pid_vnr(sid);
 	int err = -EPERM;
 
 	write_lock_irq(&tasklist_lock);
-
 	/* Fail if I am already a session leader */
 	if (group_leader->signal->leader)
 		goto out;
 
-	session = group_leader->pid;
-	/* Fail if a process group id already exists that equals the
-	 * proposed session id.
+	/* Fail if a process group id already exists that equals the proposed
+	 * session id.
 	 *
-	 * Don't check if session id == 1 because kernel threads use this
-	 * session id and so the check will always fail and make it so
-	 * init cannot successfully call setsid.
+	 * Don't check if session == 1 because kernel threads and CLONE_NEWPID
+	 * tasks use this session id and so the check will always fail and make
+	 * it so init cannot successfully call setsid.
 	 */
-	if (session > 1 && find_task_by_pid_type_ns(PIDTYPE_PGID,
-				session, &init_pid_ns))
+	if (session != 1 && pid_task(sid, PIDTYPE_PGID))
 		goto out;
 
 	group_leader->signal->leader = 1;
-	__set_special_pids(session, session);
+	__set_special_pids(pid_nr(sid), pid_nr(sid));
 
 	spin_lock(&group_leader->sighand->siglock);
 	group_leader->signal->tty = NULL;
 	spin_unlock(&group_leader->sighand->siglock);
 
-	err = task_pgrp_vnr(group_leader);
+	err = session;
 out:
 	write_unlock_irq(&tasklist_lock);
 	return err;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
