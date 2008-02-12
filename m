From: akpm@linux-foundation.org
Subject: + consolidate-checking-for-ignored-legacy-signals.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:42:53 -0800
Message-ID: <200802122142.m1CLgrkp023736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbYBLVne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:43:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: consolidate checking for ignored/legacy signals
has been added to the -mm tree.  Its filename is
     consolidate-checking-for-ignored-legacy-signals.patch

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
Subject: signals: consolidate checking for ignored/legacy signals
From: Pavel Emelyanov <xemul@openvz.org>

Two callers for send_signal() - the specific_send_sig_info and the
__group_send_sig_info - both check for sig to be ignored or already queued.

Move these checks into send_signal() and make it return 1 to indicate that the
signal is dropped, but there's no error in this.

Besides, merge comments and spell-check them.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff -puN kernel/signal.c~consolidate-checking-for-ignored-legacy-signals kernel/signal.c
--- a/kernel/signal.c~consolidate-checking-for-ignored-legacy-signals
+++ a/kernel/signal.c
@@ -668,6 +668,14 @@ static int send_signal(int sig, struct s
 	struct sigqueue * q = NULL;
 
 	/*
+	 * Short-circuit ignored signals and support queuing
+	 * exactly one non-rt signal, so that we can get more
+	 * detailed information about the cause of the signal.
+	 */
+	if (sig_ignored(t, sig) || legacy_queue(signals, sig))
+		return 1;
+
+	/*
 	 * Deliver the signal to listening signalfds. This must be called
 	 * with the sighand lock held.
 	 */
@@ -766,21 +774,13 @@ specific_send_sig_info(int sig, struct s
 	BUG_ON(!irqs_disabled());
 	assert_spin_locked(&t->sighand->siglock);
 
-	/* Short-circuit ignored signals.  */
-	if (sig_ignored(t, sig))
-		goto out;
-
-	/* Support queueing exactly one non-rt signal, so that we
-	   can get more detailed information about the cause of
-	   the signal. */
-	if (legacy_queue(&t->pending, sig))
-		goto out;
-
 	ret = send_signal(sig, info, t, &t->pending);
+	if (ret < 0)
+		return ret;
+
 	if (!ret && !sigismember(&t->blocked, sig))
 		signal_wake_up(t, sig == SIGKILL);
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -930,24 +930,17 @@ __group_send_sig_info(int sig, struct si
 	assert_spin_locked(&p->sighand->siglock);
 	handle_stop_signal(sig, p);
 
-	/* Short-circuit ignored signals.  */
-	if (sig_ignored(p, sig))
-		return ret;
-
-	if (legacy_queue(&p->signal->shared_pending, sig))
-		/* This is a non-RT signal and we already have one queued.  */
-		return ret;
-
 	/*
 	 * Put this signal on the shared-pending queue, or fail with EAGAIN.
 	 * We always use the shared queue for process-wide signals,
 	 * to avoid several races.
 	 */
 	ret = send_signal(sig, info, p, &p->signal->shared_pending);
-	if (unlikely(ret))
+	if (unlikely(ret < 0))
 		return ret;
 
-	__group_complete_signal(sig, p);
+	if (!ret)
+		__group_complete_signal(sig, p);
 	return 0;
 }
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
usbatm-switch-to-kthread-api-stop-using-kill_proc.patch
deprecate-find_task_by_pid-kgdb.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
