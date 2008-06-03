From: akpm@linux-foundation.org
Subject: + signals-do_signal_stop-kill-the-signal_unkillable-check.patch added to -mm tree
Date: Tue, 03 Jun 2008 12:50:52 -0700
Message-ID: <200806031950.m53JoqMl016638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754454AbYFCTvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: do_signal_stop: kill the SIGNAL_UNKILLABLE check
has been added to the -mm tree.  Its filename is
     signals-do_signal_stop-kill-the-signal_unkillable-check.patch

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
Subject: signals: do_signal_stop: kill the SIGNAL_UNKILLABLE check
From: Oleg Nesterov <oleg@tv-sign.ru>

fae5fa44f1fd079ffbed8e0add929dd7bbd1347f changed do_signal_stop() to check
SIGNAL_UNKILLABLE, this wasn't needed.  If signal_group_exit() == F, the
signal sent to SIGNAL_UNKILLABLE task must be already filtered out by the
caller, get_signal_to_deliver().  And if signal_group_exit() == T we are
not going to stop.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/signal.c~signals-do_signal_stop-kill-the-signal_unkillable-check kernel/signal.c
--- a/kernel/signal.c~signals-do_signal_stop-kill-the-signal_unkillable-check
+++ a/kernel/signal.c
@@ -1649,8 +1649,7 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (unlikely((sig->flags & (SIGNAL_STOP_DEQUEUED | SIGNAL_UNKILLABLE))
-					 != SIGNAL_STOP_DEQUEUED) ||
+		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
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

