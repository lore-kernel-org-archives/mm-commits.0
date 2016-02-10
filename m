From: akpm@linux-foundation.org
Subject: [merged] signals-work-around-random-wakeups-in-sigsuspend.patch
 removed from -mm tree
Date: Wed, 10 Feb 2016 11:35:20 -0800
Message-ID: <56bb90f8.LsoUsYQcka8f6kF0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbcBJTfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, dvyukov@google.com, oleg@redhat.com, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: signals: avoid random wakeups in sigsuspend()
has been removed from the -mm tree.  Its filename was
     signals-work-around-random-wakeups-in-sigsuspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: signals: avoid random wakeups in sigsuspend()

A random wakeup can get us out of sigsuspend() without TIF_SIGPENDING
being set.

Avoid that by making sure we were signaled, like sys_pause() does.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~signals-work-around-random-wakeups-in-sigsuspend kernel/signal.c
--- a/kernel/signal.c~signals-work-around-random-wakeups-in-sigsuspend
+++ a/kernel/signal.c
@@ -3508,8 +3508,10 @@ static int sigsuspend(sigset_t *set)
 	current->saved_sigmask = current->blocked;
 	set_current_blocked(set);
 
-	__set_current_state(TASK_INTERRUPTIBLE);
-	schedule();
+	while (!signal_pending(current)) {
+		__set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
 	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
_

Patches currently in -mm which might be from sasha.levin@oracle.com are


