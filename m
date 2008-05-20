From: akpm@linux-foundation.org
Subject: + signals-collect_signal-simplify-the-still_pending-logic.patch added to -mm tree
Date: Mon, 19 May 2008 23:34:36 -0700
Message-ID: <200805200634.m4K6YatI009025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbYETGfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 02:35:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: collect_signal: simplify the "still_pending" logic
has been added to the -mm tree.  Its filename is
     signals-collect_signal-simplify-the-still_pending-logic.patch

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
Subject: signals: collect_signal: simplify the "still_pending" logic
From: Oleg Nesterov <oleg@tv-sign.ru>

Factor out sigdelset() calls and remove the "still_pending" variable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN kernel/signal.c~signals-collect_signal-simplify-the-still_pending-logic kernel/signal.c
--- a/kernel/signal.c~signals-collect_signal-simplify-the-still_pending-logic
+++ a/kernel/signal.c
@@ -307,7 +307,6 @@ unblock_all_signals(void)
 static int collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
 	struct sigqueue *q, *first = NULL;
-	int still_pending = 0;
 
 	/*
 	 * Collect the siginfo appropriate to this signal.  Check if
@@ -315,16 +314,16 @@ static int collect_signal(int sig, struc
 	*/
 	list_for_each_entry(q, &list->list, list) {
 		if (q->info.si_signo == sig) {
-			if (first) {
-				still_pending = 1;
-				break;
-			}
+			if (first)
+				goto still_pending;
 			first = q;
 		}
 	}
+
+	sigdelset(&list->signal, sig);
+
 	if (first) {
-		if (!still_pending)
-			sigdelset(&list->signal, sig);
+still_pending:
 		if (unlikely(first->flags & SIGQUEUE_CANCELLED))
 			sig = 0;
 		copy_siginfo(info, &first->info);
@@ -336,7 +335,6 @@ static int collect_signal(int sig, struc
 		   a fast-pathed signal or we must have been
 		   out of queue space.  So zero out the info.
 		 */
-		sigdelset(&list->signal, sig);
 		info->si_signo = sig;
 		info->si_errno = 0;
 		info->si_code = 0;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

signals-fix-sigqueue_free-vs-__exit_signal-race.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-sigqueue_free-dont-free-sigqueue-if-it-is-queued.patch
signals-introduce-sigqueue_cancelled.patch
posix-timers-use-sigqueue_cancelled-when-the-timer-is-destroyed.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

