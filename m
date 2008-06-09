From: akpm@linux-foundation.org
Subject: + __mutex_lock_common-use-signal_pending_state.patch added to -mm tree
Date: Sun, 08 Jun 2008 17:34:41 -0700
Message-ID: <200806090034.m590YfXK027730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756312AbYFIAfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 20:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, dmitry.adamushko@gmail.com, matthew@wil.cx, mingo@elte.hu, roland@redhat.com


The patch titled
     __mutex_lock_common: use signal_pending_state()
has been added to the -mm tree.  Its filename is
     __mutex_lock_common-use-signal_pending_state.patch

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
Subject: __mutex_lock_common: use signal_pending_state()
From: Oleg Nesterov <oleg@tv-sign.ru>

Change __mutex_lock_common() to use signal_pending_state() for the sake of
the code re-use.

This adds 7 bytes to kernel/mutex.o, but afaics only because gcc isn't smart
enough.

(btw, uninlining of __mutex_lock_common() shrinks .text from 2722 to 1542,
 perhaps it is worth doing).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/mutex.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/mutex.c~__mutex_lock_common-use-signal_pending_state kernel/mutex.c
--- a/kernel/mutex.c~__mutex_lock_common-use-signal_pending_state
+++ a/kernel/mutex.c
@@ -165,10 +165,7 @@ __mutex_lock_common(struct mutex *lock, 
 		 * got a signal? (This code gets eliminated in the
 		 * TASK_UNINTERRUPTIBLE case.)
 		 */
-		if (unlikely((state == TASK_INTERRUPTIBLE &&
-					signal_pending(task)) ||
-			      (state == TASK_KILLABLE &&
-					fatal_signal_pending(task)))) {
+		if (unlikely(signal_pending_state(state, task))) {
 			mutex_remove_waiter(lock, &waiter,
 					    task_thread_info(task));
 			mutex_release(&lock->dep_map, 1, ip);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
sched-fix-task_wakekill-vs-sigkill-race.patch
__mutex_lock_common-use-signal_pending_state.patch
do_generic_file_read-s-eintr-eio-if-lock_page_killable-fails.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
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

