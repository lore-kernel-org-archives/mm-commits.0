From: akpm@linux-foundation.org
Subject: - do_task_stat-dont-take-rcu_read_lock.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:00 -0700
Message-ID: <200805010926.m419Q0EJ030261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbYEAJ2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com, paulmck@linux.vnet.ibm.com, roland@redhat.com, xemul@sw.ru, mm-commits@vger.kernel.org


The patch titled
     do_task_stat: don't take rcu_read_lock()
has been removed from the -mm tree.  Its filename was
     do_task_stat-dont-take-rcu_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_task_stat: don't take rcu_read_lock()
From: Oleg Nesterov <oleg@tv-sign.ru>

lock_task_sighand() was changed, and do_task_stat() doesn't need
rcu_read_lock any longer.  sighand->siglock protects all "interesting"
fields.

Except: it doesn't protect ->tty->pgrp, but neither does rcu_read_lock(), this
should be fixed.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Emelyanov <xemul@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/array.c~do_task_stat-dont-take-rcu_read_lock fs/proc/array.c
--- a/fs/proc/array.c~do_task_stat-dont-take-rcu_read_lock
+++ a/fs/proc/array.c
@@ -425,7 +425,6 @@ static int do_task_stat(struct seq_file 
 	cutime = cstime = utime = stime = cputime_zero;
 	cgtime = gtime = cputime_zero;
 
-	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
 		struct signal_struct *sig = task->signal;
 
@@ -469,7 +468,6 @@ static int do_task_stat(struct seq_file 
 
 		unlock_task_sighand(task, &flags);
 	}
-	rcu_read_unlock();
 
 	if (!whole || num_threads < 2)
 		wchan = get_wchan(task);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

