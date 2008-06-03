From: akpm@linux-foundation.org
Subject: + __exit_signal-dont-take-rcu-lock.patch added to -mm tree
Date: Tue, 03 Jun 2008 12:50:48 -0700
Message-ID: <200806031950.m53JomaG016632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbYFCTv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     __exit_signal: don't take rcu lock
has been added to the -mm tree.  Its filename is
     __exit_signal-dont-take-rcu-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: __exit_signal: don't take rcu lock
From: Oleg Nesterov <oleg@tv-sign.ru>

There is no reason for rcu_read_lock() in __exit_signal().  tsk->sighand
can only be changed if tsk does exec, obviously this is not possible.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/exit.c~__exit_signal-dont-take-rcu-lock kernel/exit.c
--- a/kernel/exit.c~__exit_signal-dont-take-rcu-lock
+++ a/kernel/exit.c
@@ -84,7 +84,6 @@ static void __exit_signal(struct task_st
 	BUG_ON(!sig);
 	BUG_ON(!atomic_read(&sig->count));
 
-	rcu_read_lock();
 	sighand = rcu_dereference(tsk->sighand);
 	spin_lock(&sighand->siglock);
 
@@ -135,7 +134,6 @@ static void __exit_signal(struct task_st
 	tsk->signal = NULL;
 	tsk->sighand = NULL;
 	spin_unlock(&sighand->siglock);
-	rcu_read_unlock();
 
 	__cleanup_sighand(sighand);
 	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

vt-fix-vc_resize-locking.patch
uml-activate_mm-remove-the-dead-pf_borrowed_mm-check.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
distinct-tgid-tid-i-o-statistics.patch

