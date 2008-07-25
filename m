From: akpm@linux-foundation.org
Subject: - signals-collect_signal-simplify-the-still_pending-logic.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:22 -0700
Message-ID: <200807252259.m6PMxMjR003380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbYGYXAS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: collect_signal: simplify the "still_pending" logic
has been removed from the -mm tree.  Its filename was
     signals-collect_signal-simplify-the-still_pending-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: collect_signal: simplify the "still_pending" logic
From: Oleg Nesterov <oleg@tv-sign.ru>

Factor out sigdelset() calls and remove the "still_pending" variable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~signals-collect_signal-simplify-the-still_pending-logic kernel/signal.c
--- a/kernel/signal.c~signals-collect_signal-simplify-the-still_pending-logic
+++ a/kernel/signal.c
@@ -341,7 +341,6 @@ unblock_all_signals(void)
 static int collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
 	struct sigqueue *q, *first = NULL;
-	int still_pending = 0;
 
 	/*
 	 * Collect the siginfo appropriate to this signal.  Check if
@@ -349,26 +348,24 @@ static int collect_signal(int sig, struc
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
+still_pending:
 		list_del_init(&first->list);
 		copy_siginfo(info, &first->info);
 		__sigqueue_free(first);
-		if (!still_pending)
-			sigdelset(&list->signal, sig);
 	} else {
-
 		/* Ok, it wasn't in the queue.  This must be
 		   a fast-pathed signal or we must have been
 		   out of queue space.  So zero out the info.
 		 */
-		sigdelset(&list->signal, sig);
 		info->si_signo = sig;
 		info->si_errno = 0;
 		info->si_code = 0;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

