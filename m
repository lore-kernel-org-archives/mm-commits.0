From: akpm@linux-foundation.org
Subject: - signals-do_signal_stop-use-signal_group_exit.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:52 -0700
Message-ID: <200805010925.m419PqFl030245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757890AbYEAJmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: do_signal_stop(): use signal_group_exit()
has been removed from the -mm tree.  Its filename was
     signals-do_signal_stop-use-signal_group_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: do_signal_stop(): use signal_group_exit()
From: Oleg Nesterov <oleg@tv-sign.ru>

do_signal_stop() needs signal_group_exit() but checks sig->group_exit_task.
 This (optimization) is correct, SIGNAL_STOP_DEQUEUED and SIGNAL_GROUP_EXIT
are mutually exclusive, but looks confusing.  Use signal_group_exit(), this
is not fastpath, the code clarity is more important.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~signals-do_signal_stop-use-signal_group_exit kernel/signal.c
--- a/kernel/signal.c~signals-do_signal_stop-use-signal_group_exit
+++ a/kernel/signal.c
@@ -1717,7 +1717,7 @@ static int do_signal_stop(int signr)
 		struct task_struct *t;
 
 		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
-		    unlikely(sig->group_exit_task))
+		    unlikely(signal_group_exit(sig)))
 			return 0;
 		/*
 		 * There is no group stop already in progress.
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

