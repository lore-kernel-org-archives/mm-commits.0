From: akpm@linux-foundation.org
Subject: - start-the-global-sbin-init-with-00-special-pids.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:59 -0800
Message-ID: <200802082013.m18KDeIc010310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323AbYBHU6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:58:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     start the global /sbin/init with 0,0 special pids
has been removed from the -mm tree.  Its filename was
     start-the-global-sbin-init-with-00-special-pids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: start the global /sbin/init with 0,0 special pids
From: Oleg Nesterov <oleg@tv-sign.ru>

As Eric pointed out, there is no problem with init starting with sid == pgid
== 0, and this was historical linux behavior changed in 2.6.18.

Remove kernel_init()->__set_special_pids(), this is unneeded and complicates
the rules for sys_setsid().

This change and the previous change in daemonize() mean that /sbin/init does
not need the special "session != 1" hack in sys_setsid() any longer. We can't
remove this check yet, we should cleanup copy_process(CLONE_NEWPID) first, so
update the comment only.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c  |    1 -
 kernel/sys.c |    9 ++++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -puN init/main.c~start-the-global-sbin-init-with-00-special-pids init/main.c
--- a/init/main.c~start-the-global-sbin-init-with-00-special-pids
+++ a/init/main.c
@@ -833,7 +833,6 @@ static int __init kernel_init(void * unu
 	 */
 	init_pid_ns.child_reaper = current;
 
-	__set_special_pids(task_pid(current));
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(setup_max_cpus);
diff -puN kernel/sys.c~start-the-global-sbin-init-with-00-special-pids kernel/sys.c
--- a/kernel/sys.c~start-the-global-sbin-init-with-00-special-pids
+++ a/kernel/sys.c
@@ -1054,12 +1054,11 @@ asmlinkage long sys_setsid(void)
 	if (group_leader->signal->leader)
 		goto out;
 
-	/* Fail if a process group id already exists that equals the proposed
-	 * session id.
+	/* Fail if a process group id already exists that equals the
+	 * proposed session id.
 	 *
-	 * Don't check if session == 1 because kernel threads and CLONE_NEWPID
-	 * tasks use this session id and so the check will always fail and make
-	 * it so init cannot successfully call setsid.
+	 * Don't check if session == 1, clone(CLONE_NEWPID) creates
+	 * this group/session beforehand.
 	 */
 	if (session != 1 && pid_task(sid, PIDTYPE_PGID))
 		goto out;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
