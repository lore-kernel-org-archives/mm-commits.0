From: akpm@osdl.org
Subject: - trivial-make-set_special_pids-static.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:10 -0800
Message-ID: <200612082000.kB8K0AVV001710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56555 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426193AbWLHUAW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:00:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     make set_special_pids() static
has been removed from the -mm tree.  Its filename was
     trivial-make-set_special_pids-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make set_special_pids() static
From: Oleg Nesterov <oleg@tv-sign.ru>

Make set_special_pids() static, the only caller is daemonize().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h |    1 -
 kernel/exit.c         |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/sched.h~trivial-make-set_special_pids-static include/linux/sched.h
--- a/include/linux/sched.h~trivial-make-set_special_pids-static
+++ a/include/linux/sched.h
@@ -1240,7 +1240,6 @@ extern struct   mm_struct init_mm;
 
 #define find_task_by_pid(nr)	find_task_by_pid_type(PIDTYPE_PID, nr)
 extern struct task_struct *find_task_by_pid_type(int type, int pid);
-extern void set_special_pids(pid_t session, pid_t pgrp);
 extern void __set_special_pids(pid_t session, pid_t pgrp);
 
 /* per-UID process charging. */
diff -puN kernel/exit.c~trivial-make-set_special_pids-static kernel/exit.c
--- a/kernel/exit.c~trivial-make-set_special_pids-static
+++ a/kernel/exit.c
@@ -314,7 +314,7 @@ void __set_special_pids(pid_t session, p
 	}
 }
 
-void set_special_pids(pid_t session, pid_t pgrp)
+static void set_special_pids(pid_t session, pid_t pgrp)
 {
 	write_lock_irq(&tasklist_lock);
 	__set_special_pids(session, pgrp);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
trivial-make-set_special_pids-static.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch
session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
pidhash-temporary-debug-checks.patch

