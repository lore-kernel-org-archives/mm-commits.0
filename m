From: akpm@linux-foundation.org
Subject: + coredump-zap_threads-must-skip-kernel-threads.patch added to -mm tree
Date: Wed, 04 Jun 2008 00:57:55 -0700
Message-ID: <200806040757.m547vtVY011133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755113AbYFDH7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 03:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     coredump: zap_threads() must skip kernel threads
has been added to the -mm tree.  Its filename is
     coredump-zap_threads-must-skip-kernel-threads.patch

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
Subject: coredump: zap_threads() must skip kernel threads
From: Oleg Nesterov <oleg@tv-sign.ru>

The main loop in zap_threads() must skip kthreads which may use the same
mm.  Otherwise we "kill" this thread erroneously (for example, it can not
fork or exec after that), and the coredumping task stucks in the
TASK_UNINTERRUPTIBLE state forever because of the wrong ->core_waiters
count.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~coredump-zap_threads-must-skip-kernel-threads fs/exec.c
--- a/fs/exec.c~coredump-zap_threads-must-skip-kernel-threads
+++ a/fs/exec.c
@@ -1543,11 +1543,12 @@ static inline int zap_threads(struct tas
 	for_each_process(g) {
 		if (g == tsk->group_leader)
 			continue;
-
+		if (g->flags & PF_KTHREAD)
+			continue;
 		p = g;
 		do {
 			if (p->mm) {
-				if (p->mm == mm) {
+				if (unlikely(p->mm == mm)) {
 					/*
 					 * p->sighand can't disappear, but
 					 * may be changed by de_thread()
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

vt-fix-vc_resize-locking.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
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

