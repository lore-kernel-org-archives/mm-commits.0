From: akpm@linux-foundation.org
Subject: - signals-do_tkill-dont-use-tasklist_lock.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:35 -0700
Message-ID: <200805010926.m419QZtc030312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757883AbYEAJnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:43:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: do_tkill: don't use tasklist_lock
has been removed from the -mm tree.  Its filename was
     signals-do_tkill-dont-use-tasklist_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: do_tkill: don't use tasklist_lock
From: Oleg Nesterov <oleg@tv-sign.ru>

Convert do_tkill() to use rcu_read_lock() + lock_task_sighand() to avoid
taking tasklist lock.

Note that we don't return an error if lock_task_sighand() fails, we pretend
the task dies after receiving the signal.  Otherwise, we should fight with the
nasty races with mt-exec without having any advantage.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN kernel/signal.c~signals-do_tkill-dont-use-tasklist_lock kernel/signal.c
--- a/kernel/signal.c~signals-do_tkill-dont-use-tasklist_lock
+++ a/kernel/signal.c
@@ -2219,6 +2219,7 @@ static int do_tkill(int tgid, int pid, i
 	int error;
 	struct siginfo info;
 	struct task_struct *p;
+	unsigned long flags;
 
 	error = -ESRCH;
 	info.si_signo = sig;
@@ -2227,21 +2228,24 @@ static int do_tkill(int tgid, int pid, i
 	info.si_pid = task_tgid_vnr(current);
 	info.si_uid = current->uid;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (p && (tgid <= 0 || task_tgid_vnr(p) == tgid)) {
 		error = check_kill_permission(sig, &info, p);
 		/*
 		 * The null signal is a permissions and process existence
 		 * probe.  No signal is actually delivered.
+		 *
+		 * If lock_task_sighand() fails we pretend the task dies
+		 * after receiving the signal. The window is tiny, and the
+		 * signal is private anyway.
 		 */
-		if (!error && sig && p->sighand) {
-			spin_lock_irq(&p->sighand->siglock);
+		if (!error && sig && lock_task_sighand(p, &flags)) {
 			error = specific_send_sig_info(sig, &info, p);
-			spin_unlock_irq(&p->sighand->siglock);
+			unlock_task_sighand(p, &flags);
 		}
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return error;
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

