From: akpm@osdl.org
Subject: - session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:10 -0800
Message-ID: <200612082006.kB8K6ATv002367@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426334AbWLHUGV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     session_of_pgrp: kill unnecessary do_each_task_pid(PIDTYPE_PGID)
has been removed from the -mm tree.  Its filename was
     session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: session_of_pgrp: kill unnecessary do_each_task_pid(PIDTYPE_PGID)
From: Oleg Nesterov <oleg@tv-sign.ru>

All members of the process group have the same sid and it can't be == 0.

NOTE: this code (and a similar one in sys_setpgid) was needed because it
was possibe to have ->session == 0. It's not possible any longer since

	[PATCH] pidhash: don't use zero pids
	Commit: c7c6464117a02b0d54feb4ebeca4db70fa493678

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/exit.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN kernel/exit.c~session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid kernel/exit.c
--- a/kernel/exit.c~session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid
+++ a/kernel/exit.c
@@ -189,21 +189,18 @@ repeat:
 int session_of_pgrp(int pgrp)
 {
 	struct task_struct *p;
-	int sid = -1;
+	int sid = 0;
 
 	read_lock(&tasklist_lock);
-	do_each_task_pid(pgrp, PIDTYPE_PGID, p) {
-		if (process_session(p) > 0) {
-			sid = process_session(p);
-			goto out;
-		}
-	} while_each_task_pid(pgrp, PIDTYPE_PGID, p);
-	p = find_task_by_pid(pgrp);
-	if (p)
+
+	p = find_task_by_pid_type(PIDTYPE_PGID, pgrp);
+	if (p == NULL)
+		p = find_task_by_pid(pgrp);
+	if (p != NULL)
 		sid = process_session(p);
-out:
+
 	read_unlock(&tasklist_lock);
-	
+
 	return sid;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
pidhash-temporary-debug-checks.patch

