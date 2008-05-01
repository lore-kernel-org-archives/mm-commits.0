From: akpm@linux-foundation.org
Subject: - kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:17 -0700
Message-ID: <200805010926.m419QHX0030285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757338AbYEAJ1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, jkosina@suse.cz, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kill_pid_info: don't take now unneeded tasklist_lock
has been removed from the -mm tree.  Its filename was
     kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kill_pid_info: don't take now unneeded tasklist_lock
From: Oleg Nesterov <oleg@tv-sign.ru>

Previously handle_stop_signal(SIGCONT) could drop ->siglock.  That is why
kill_pid_info(SIGCONT) takes tasklist_lock to make sure the target task can't
go away after unlock.  Not needed now.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    2 --
 kernel/signal.c        |    7 +------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff -puN include/linux/signal.h~kill_pid_info-dont-take-now-unneeded-tasklist_lock include/linux/signal.h
--- a/include/linux/signal.h~kill_pid_info-dont-take-now-unneeded-tasklist_lock
+++ a/include/linux/signal.h
@@ -362,8 +362,6 @@ int unhandled_signal(struct task_struct 
 #define sig_kernel_stop(sig) \
 	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_STOP_MASK))
 
-#define sig_needs_tasklist(sig)	((sig) == SIGCONT)
-
 #define sig_user_defined(t, signr) \
 	(((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_DFL) &&	\
 	 ((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_IGN))
diff -puN kernel/signal.c~kill_pid_info-dont-take-now-unneeded-tasklist_lock kernel/signal.c
--- a/kernel/signal.c~kill_pid_info-dont-take-now-unneeded-tasklist_lock
+++ a/kernel/signal.c
@@ -1039,9 +1039,6 @@ int kill_pid_info(int sig, struct siginf
 	struct task_struct *p;
 
 	rcu_read_lock();
-	if (unlikely(sig_needs_tasklist(sig)))
-		read_lock(&tasklist_lock);
-
 retry:
 	p = pid_task(pid, PIDTYPE_PID);
 	if (p) {
@@ -1055,10 +1052,8 @@ retry:
 			 */
 			goto retry;
 	}
