From: akpm@osdl.org
Subject: - pidhash-temporary-debug-checks.patch removed from -mm tree
Date: Mon, 18 Dec 2006 16:43:33 -0800
Message-ID: <200612190043.kBJ0hXMe018415@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36215 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518AbWLSAno (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:43:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     pidhash: temporary debug checks
has been removed from the -mm tree.  Its filename was
     pidhash-temporary-debug-checks.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: pidhash: temporary debug checks
From: Oleg Nesterov <oleg@tv-sign.ru>

This is for testing in -mm tree only.  Ensure that we really do not use pid ==
0.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/pid.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/pid.c~pidhash-temporary-debug-checks kernel/pid.c
--- a/kernel/pid.c~pidhash-temporary-debug-checks
+++ a/kernel/pid.c
@@ -240,6 +240,7 @@ struct pid * fastcall find_pid(int nr)
 
 	hlist_for_each_entry_rcu(pid, elem,
 			&pid_hash[pid_hashfn(nr)], pid_chain) {
+		WARN_ON(!pid->nr); /* to be removed soon */
 		if (pid->nr == nr)
 			return pid;
 	}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
vt-refactor-console-sak-processing.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
pidhash-temporary-debug-checks.patch

