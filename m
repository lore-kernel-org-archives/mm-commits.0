From: akpm@linux-foundation.org
Subject: - use-find_task_by_vpid-in-audit-code.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:52 -0700
Message-ID: <200804300550.m3U5oqBX030164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759172AbYD3Fuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Use find_task_by_vpid in audit code
has been removed from the -mm tree.  Its filename was
     use-find_task_by_vpid-in-audit-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use find_task_by_vpid in audit code
From: Pavel Emelyanov <xemul@openvz.org>

The pid to lookup a task by is passed inside audit code via netlink message.

Thanks to Denis Lunev, netlink packets are now (since 2.6.24) _always_
processed in the context of the sending task.  So this is correct to lookup
the task with find_task_by_vpid() here.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/audit.c~use-find_task_by_vpid-in-audit-code kernel/audit.c
--- a/kernel/audit.c~use-find_task_by_vpid-in-audit-code
+++ a/kernel/audit.c
@@ -392,7 +392,7 @@ static int audit_prepare_user_tty(pid_t 
 	int err;
 
 	read_lock(&tasklist_lock);
-	tsk = find_task_by_pid(pid);
+	tsk = find_task_by_vpid(pid);
 	err = -ESRCH;
 	if (!tsk)
 		goto out;
@@ -779,7 +779,7 @@ static int audit_receive_msg(struct sk_b
 		struct task_struct *tsk;
 
 		read_lock(&tasklist_lock);
-		tsk = find_task_by_pid(pid);
+		tsk = find_task_by_vpid(pid);
 		if (!tsk)
 			err = -ESRCH;
 		else {
@@ -802,7 +802,7 @@ static int audit_receive_msg(struct sk_b
 		if (s->enabled != 0 && s->enabled != 1)
 			return -EINVAL;
 		read_lock(&tasklist_lock);
-		tsk = find_task_by_pid(pid);
+		tsk = find_task_by_vpid(pid);
 		if (!tsk)
 			err = -ESRCH;
 		else {
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
ptrace-allow-to-ptrace-sbin-init.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

