From: akpm@osdl.org
Subject: - sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:08 -0800
Message-ID: <200612082006.kB8K68nR002363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57641 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426333AbWLHUGU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     sys_setpgid: eliminate unnecessary do_each_task_pid(PIDTYPE_PGID)
has been removed from the -mm tree.  Its filename was
     sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sys_setpgid: eliminate unnecessary do_each_task_pid(PIDTYPE_PGID)
From: Oleg Nesterov <oleg@tv-sign.ru>

All tasks in the process group have the same sid, we don't need to iterate
them all to check that the caller of sys_setpgid() doesn't change its
session.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sys.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/sys.c~sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid kernel/sys.c
--- a/kernel/sys.c~sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid
+++ a/kernel/sys.c
@@ -1397,16 +1397,13 @@ asmlinkage long sys_setpgid(pid_t pid, p
 		goto out;
 
 	if (pgid != pid) {
-		struct task_struct *p;
+		struct task_struct *g =
+			find_task_by_pid_type(PIDTYPE_PGID, pgid);
 
-		do_each_task_pid(pgid, PIDTYPE_PGID, p) {
-			if (process_session(p) == process_session(group_leader))
-				goto ok_pgid;
-		} while_each_task_pid(pgid, PIDTYPE_PGID, p);
-		goto out;
+		if (!g || process_session(g) != process_session(group_leader))
+			goto out;
 	}
 
-ok_pgid:
 	err = security_task_setpgid(p, pgid);
 	if (err)
 		goto out;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch
session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
pidhash-temporary-debug-checks.patch

