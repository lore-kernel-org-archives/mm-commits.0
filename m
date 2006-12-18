From: akpm@osdl.org
Subject: + kill_pid_info-kill-acquired_tasklist_lock.patch added to -mm tree
Date: Mon, 18 Dec 2006 15:51:24 -0800
Message-ID: <200612182351.kBINpOPO016813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60070 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303AbWLRXvj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 18:51:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com


The patch titled
     kill_pid_info: kill acquired_tasklist_lock
has been added to the -mm tree.  Its filename is
     kill_pid_info-kill-acquired_tasklist_lock.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kill_pid_info: kill acquired_tasklist_lock
From: Oleg Nesterov <oleg@tv-sign.ru>

Kill acquired_tasklist_lock, sig_needs_tasklist() is very cheap nowadays.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/signal.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/signal.c~kill_pid_info-kill-acquired_tasklist_lock kernel/signal.c
--- a/kernel/signal.c~kill_pid_info-kill-acquired_tasklist_lock
+++ a/kernel/signal.c
@@ -1119,19 +1119,18 @@ kill_pg_info(int sig, struct siginfo *in
 int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 {
 	int error;
-	int acquired_tasklist_lock = 0;
 	struct task_struct *p;
 
 	rcu_read_lock();
-	if (unlikely(sig_needs_tasklist(sig))) {
+	if (unlikely(sig_needs_tasklist(sig)))
 		read_lock(&tasklist_lock);
-		acquired_tasklist_lock = 1;
-	}
+
 	p = pid_task(pid, PIDTYPE_PID);
 	error = -ESRCH;
 	if (p)
 		error = group_send_sig_info(sig, info, p);
-	if (unlikely(acquired_tasklist_lock))
+
+	if (unlikely(sig_needs_tasklist(sig)))
 		read_unlock(&tasklist_lock);
 	rcu_read_unlock();
 	return error;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
vt-refactor-console-sak-processing.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
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

