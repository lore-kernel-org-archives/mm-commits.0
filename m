From: akpm@linux-foundation.org
Subject: + sched-do_wait_for_common-use-signal_pending_state.patch added to -mm tree
Date: Tue, 29 Jul 2008 00:10:07 -0700
Message-ID: <200807290710.m6T7A7a0020312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbYG2HK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 03:10:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, matthew@wil.cx, mingo@elte.hu, roland@redhat.com


The patch titled
     sched: do_wait_for_common: use signal_pending_state()
has been added to the -mm tree.  Its filename is
     sched-do_wait_for_common-use-signal_pending_state.patch

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
Subject: sched: do_wait_for_common: use signal_pending_state()
From: Oleg Nesterov <oleg@tv-sign.ru>

Change do_wait_for_common() to use signal_pending_state() instead of open
coding.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/sched.c~sched-do_wait_for_common-use-signal_pending_state kernel/sched.c
--- a/kernel/sched.c~sched-do_wait_for_common-use-signal_pending_state
+++ a/kernel/sched.c
@@ -4593,10 +4593,7 @@ do_wait_for_common(struct completion *x,
 		wait.flags |= WQ_FLAG_EXCLUSIVE;
 		__add_wait_queue_tail(&x->wait, &wait);
 		do {
-			if ((state == TASK_INTERRUPTIBLE &&
-			     signal_pending(current)) ||
-			    (state == TASK_KILLABLE &&
-			     fatal_signal_pending(current))) {
+			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
 				break;
 			}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
sched-do_wait_for_common-use-signal_pending_state.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch

