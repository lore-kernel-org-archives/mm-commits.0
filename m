From: akpm@linux-foundation.org
Subject: - uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:24 -0800
Message-ID: <200802082014.m18KE5SV010357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758732AbYBHVDg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, davidel@xmailserver.org, ebiederm@xmission.com, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     uglify kill_pid_info() to fix kill() vs exec() race
has been removed from the -mm tree.  Its filename was
     uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uglify kill_pid_info() to fix kill() vs exec() race
From: Oleg Nesterov <oleg@tv-sign.ru>

kill_pid_info()->pid_task() could be the old leader of the execing process.
In that case it is possible that the leader will be released before we take
siglock. This means that kill_pid_info() (and thus sys_kill()) can return a
false -ESRCH.

Change the code to retry when lock_task_sighand() fails. The endless loop is
not possible, __exit_signal() both clears ->sighand and does detach_pid().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~uglify-kill_pid_info-to-fix-kill-vs-exec-race kernel/signal.c
--- a/kernel/signal.c~uglify-kill_pid_info-to-fix-kill-vs-exec-race
+++ a/kernel/signal.c
@@ -1050,17 +1050,26 @@ int kill_pgrp_info(int sig, struct sigin
 
 int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 {
-	int error;
+	int error = -ESRCH;
 	struct task_struct *p;
 
 	rcu_read_lock();
 	if (unlikely(sig_needs_tasklist(sig)))
 		read_lock(&tasklist_lock);
 
+retry:
 	p = pid_task(pid, PIDTYPE_PID);
-	error = -ESRCH;
-	if (p)
+	if (p) {
 		error = group_send_sig_info(sig, info, p);
+		if (unlikely(error == -ESRCH))
+			/*
+			 * The task was unhashed in between, try again.
+			 * If it is dead, pid_task() will return NULL,
+			 * if we race with de_thread() it will find the
+			 * new leader.
+			 */
+			goto retry;
+	}
 
 	if (unlikely(sig_needs_tasklist(sig)))
 		read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
