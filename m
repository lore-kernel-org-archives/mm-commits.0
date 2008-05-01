From: akpm@linux-foundation.org
Subject: - lock_task_sighand-add-rcu-lock-unlock.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:56 -0700
Message-ID: <200805010925.m419Pufi030252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756147AbYEAJ1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, paulmck@linux.vnet.ibm.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     lock_task_sighand: add rcu lock/unlock
has been removed from the -mm tree.  Its filename was
     lock_task_sighand-add-rcu-lock-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lock_task_sighand: add rcu lock/unlock
From: Oleg Nesterov <oleg@tv-sign.ru>

Most of the callers of lock_task_sighand() doesn't actually need rcu_lock(). 
lock_task_sighand() needs it only to safely play with tsk->sighand, it can
take the lock itself.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~lock_task_sighand-add-rcu-lock-unlock kernel/signal.c
--- a/kernel/signal.c~lock_task_sighand-add-rcu-lock-unlock
+++ a/kernel/signal.c
@@ -971,13 +971,11 @@ int __fatal_signal_pending(struct task_s
 }
 EXPORT_SYMBOL(__fatal_signal_pending);
 
-/*
- * Must be called under rcu_read_lock() or with tasklist_lock read-held.
- */
 struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
 {
 	struct sighand_struct *sighand;
 
+	rcu_read_lock();
 	for (;;) {
 		sighand = rcu_dereference(tsk->sighand);
 		if (unlikely(sighand == NULL))
@@ -988,6 +986,7 @@ struct sighand_struct *lock_task_sighand
 			break;
 		spin_unlock_irqrestore(&sighand->siglock, *flags);
 	}
+	rcu_read_unlock();
 
 	return sighand;
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

