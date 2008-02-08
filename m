From: akpm@linux-foundation.org
Subject: - sys_setsid-remove-now-unneeded-session-=-1-check.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:04 -0800
Message-ID: <200802082013.m18KDjrV010317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533AbYBHUzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:55:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sys_setsid: remove now unneeded session != 1 check
has been removed from the -mm tree.  Its filename was
     sys_setsid-remove-now-unneeded-session-=-1-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_setsid: remove now unneeded session != 1 check
From: Oleg Nesterov <oleg@tv-sign.ru>

Eric's "fix clone(CLONE_NEWPID)" eliminated the last reason for this hack.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/sys.c~sys_setsid-remove-now-unneeded-session-=-1-check kernel/sys.c
--- a/kernel/sys.c~sys_setsid-remove-now-unneeded-session-=-1-check
+++ a/kernel/sys.c
@@ -1056,11 +1056,8 @@ asmlinkage long sys_setsid(void)
 
 	/* Fail if a process group id already exists that equals the
 	 * proposed session id.
-	 *
-	 * Don't check if session == 1, clone(CLONE_NEWPID) creates
-	 * this group/session beforehand.
 	 */
-	if (session != 1 && pid_task(sid, PIDTYPE_PGID))
+	if (pid_task(sid, PIDTYPE_PGID))
 		goto out;
 
 	group_leader->signal->leader = 1;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
