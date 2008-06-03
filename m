From: akpm@linux-foundation.org
Subject: + signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch added to -mm tree
Date: Tue, 03 Jun 2008 12:50:50 -0700
Message-ID: <200806031950.m53JopG9016635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbYFCTvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: dequeue_signal: don't check SIGNAL_GROUP_EXIT when setting SIGNAL_STOP_DEQUEUED
has been added to the -mm tree.  Its filename is
     signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch

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
Subject: signals: dequeue_signal: don't check SIGNAL_GROUP_EXIT when setting SIGNAL_STOP_DEQUEUED
From: Oleg Nesterov <oleg@tv-sign.ru>

dequeue_signal() checks SIGNAL_GROUP_EXIT before setting
SIGNAL_STOP_DEQUEUED.  This was added by
788e05a67c343fa22f2ae1d3ca264e7f15c25eaf a long ago to avoid the
coredump/SIGSTOP race.

Since then the related code was changed, and now this subtle check is both
incomplete and unneeded at the same time.  It is incomplete because
nowadays exec() doesn't set SIGNAL_GROUP_EXIT, so in fact we should check
signal_group_exit() to avoid a similar race.  Fortunately, we doesn't need
the check at all.  The only function which relies on SIGNAL_STOP_DEQUEUED
is do_signal_stop(), and it ignores this flag if signal_group_exit() == T,
this covers the SIGNAL_GROUP_EXIT case.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/signal.c~signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued kernel/signal.c
--- a/kernel/signal.c~signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued
+++ a/kernel/signal.c
@@ -454,8 +454,7 @@ int dequeue_signal(struct task_struct *t
 		 * is to alert stop-signal processing code when another
 		 * processor has come along and cleared the flag.
 		 */
-		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
-			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
+		tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
 	if ((info->si_code & __SI_MASK) == __SI_TIMER && info->si_sys_private) {
 		/*
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

