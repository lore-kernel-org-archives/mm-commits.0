From: akpm@linux-foundation.org
Subject: + turn-legacy_queue-macro-into-static-inline-function.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:42:51 -0800
Message-ID: <200802122142.m1CLgp07023733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbYBLVne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:43:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: turn LEGACY_QUEUE macro into static inline function
has been added to the -mm tree.  Its filename is
     turn-legacy_queue-macro-into-static-inline-function.patch

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
Subject: signals: turn LEGACY_QUEUE macro into static inline function
From: Pavel Emelyanov <xemul@openvz.org>

This makes the code more readable, due to less brackets and small letters in
name.

I also move it above the send_signal() as a preparation for the 3rd patch.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/signal.c~turn-legacy_queue-macro-into-static-inline-function kernel/signal.c
--- a/kernel/signal.c~turn-legacy_queue-macro-into-static-inline-function
+++ a/kernel/signal.c
@@ -657,6 +657,11 @@ static void handle_stop_signal(int sig, 
 	}
 }
 
+static inline int legacy_queue(struct sigpending *signals, int sig)
+{
+	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
+}
+
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			struct sigpending *signals)
 {
@@ -721,9 +726,6 @@ out_set:
 	return 0;
 }
 
-#define LEGACY_QUEUE(sigptr, sig) \
-	(((sig) < SIGRTMIN) && sigismember(&(sigptr)->signal, (sig)))
-
 int print_fatal_signals;
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
@@ -771,7 +773,7 @@ specific_send_sig_info(int sig, struct s
 	/* Support queueing exactly one non-rt signal, so that we
 	   can get more detailed information about the cause of
 	   the signal. */
-	if (LEGACY_QUEUE(&t->pending, sig))
+	if (legacy_queue(&t->pending, sig))
 		goto out;
 
 	ret = send_signal(sig, info, t, &t->pending);
@@ -932,7 +934,7 @@ __group_send_sig_info(int sig, struct si
 	if (sig_ignored(p, sig))
 		return ret;
 
-	if (LEGACY_QUEUE(&p->signal->shared_pending, sig))
+	if (legacy_queue(&p->signal->shared_pending, sig))
 		/* This is a non-RT signal and we already have one queued.  */
 		return ret;
 
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
