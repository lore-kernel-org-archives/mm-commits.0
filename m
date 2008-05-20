From: akpm@linux-foundation.org
Subject: + signals-fix-sigqueue_free-vs-__exit_signal-race.patch added to -mm tree
Date: Mon, 19 May 2008 23:30:46 -0700
Message-ID: <200805200630.m4K6UkWX008902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910AbYETGbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 02:31:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: fix sigqueue_free() vs __exit_signal() race
has been added to the -mm tree.  Its filename is
     signals-fix-sigqueue_free-vs-__exit_signal-race.patch

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
Subject: signals: fix sigqueue_free() vs __exit_signal() race
From: Oleg Nesterov <oleg@tv-sign.ru>

__exit_signal() does flush_sigqueue(tsk->pending) outside of ->siglock. 
This can race with another thread doing sigqueue_free(), we can free the
same SIGQUEUE_PREALLOC sigqueue twice or corrupt the pending->list.

Note that even sys_exit_group() can trigger this race, not only
sys_timer_delete().

Move the callsite of flush_sigqueue(tsk->pending) under ->siglock.

This patch doesn't touch flush_sigqueue(->shared_pending) below, it is
called when there are no other threads which can play with signals, and
sigqueue_free() can't be used outside of our thread group.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c   |    7 ++++++-
 kernel/signal.c |    3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~signals-fix-sigqueue_free-vs-__exit_signal-race kernel/exit.c
--- a/kernel/exit.c~signals-fix-sigqueue_free-vs-__exit_signal-race
+++ a/kernel/exit.c
@@ -126,6 +126,12 @@ static void __exit_signal(struct task_st
 
 	__unhash_process(tsk);
 
+	/*
+	 * Do this under ->siglock, we can race with another thread
+	 * doing sigqueue_free() if we have SIGQUEUE_PREALLOC signals.
+	 */
+	flush_sigqueue(&tsk->pending);
+
 	tsk->signal = NULL;
 	tsk->sighand = NULL;
 	spin_unlock(&sighand->siglock);
@@ -133,7 +139,6 @@ static void __exit_signal(struct task_st
 
 	__cleanup_sighand(sighand);
 	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
-	flush_sigqueue(&tsk->pending);
 	if (sig) {
 		flush_sigqueue(&sig->shared_pending);
 		taskstats_tgid_free(sig);
diff -puN kernel/signal.c~signals-fix-sigqueue_free-vs-__exit_signal-race kernel/signal.c
--- a/kernel/signal.c~signals-fix-sigqueue_free-vs-__exit_signal-race
+++ a/kernel/signal.c
@@ -1242,7 +1242,8 @@ void sigqueue_free(struct sigqueue *q)
 	/*
 	 * If the signal is still pending remove it from the
 	 * pending queue. We must hold ->siglock while testing
-	 * q->list to serialize with collect_signal().
+	 * q->list to serialize with collect_signal() or with
+	 * __exit_signal()->flush_sigqueue().
 	 */
 	spin_lock_irqsave(lock, flags);
 	if (!list_empty(&q->list))
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

signals-fix-sigqueue_free-vs-__exit_signal-race.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-sigqueue_free-dont-free-sigqueue-if-it-is-queued.patch
signals-introduce-sigqueue_cancelled.patch
posix-timers-use-sigqueue_cancelled-when-the-timer-is-destroyed.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

