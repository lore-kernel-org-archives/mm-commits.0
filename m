From: akpm@linux-foundation.org
Subject: + consolidate-checking-for-ignored-legacy-signals-simplify.patch added to -mm tree
Date: Wed, 13 Feb 2008 10:47:38 -0800
Message-ID: <200802131847.m1DIlcWO007712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40154 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835AbYBMStE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 13:49:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org


The patch titled
     consolidate-checking-for-ignored-legacy-signals-simplify
has been added to the -mm tree.  Its filename is
     consolidate-checking-for-ignored-legacy-signals-simplify.patch

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
Subject: consolidate-checking-for-ignored-legacy-signals-simplify
From: Oleg Nesterov <oleg@tv-sign.ru>

Every user of send_signal() must check ret twice. Change the meaning of the
returned value, so that ret <= 0 means we can just return, and ret == 1 means
the signal was queued. Saves a couple of if's and imho makes the code more
logical.

Also, remove now unneeded "ret = 0" initializions.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~consolidate-checking-for-ignored-legacy-signals-simplify kernel/signal.c
--- a/kernel/signal.c~consolidate-checking-for-ignored-legacy-signals-simplify
+++ a/kernel/signal.c
@@ -673,7 +673,7 @@ static int send_signal(int sig, struct s
 	 * detailed information about the cause of the signal.
 	 */
 	if (sig_ignored(t, sig) || legacy_queue(signals, sig))
-		return 1;
+		return 0;
 
 	/*
 	 * Deliver the signal to listening signalfds. This must be called
@@ -731,7 +731,7 @@ static int send_signal(int sig, struct s
 
 out_set:
 	sigaddset(&signals->signal, sig);
-	return 0;
+	return 1;
 }
 
 int print_fatal_signals;
@@ -769,16 +769,16 @@ __setup("print-fatal-signals=", setup_pr
 static int
 specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
-	int ret = 0;
+	int ret;
 
 	BUG_ON(!irqs_disabled());
 	assert_spin_locked(&t->sighand->siglock);
 
 	ret = send_signal(sig, info, t, &t->pending);
-	if (ret < 0)
+	if (ret <= 0)
 		return ret;
 
-	if (!ret && !sigismember(&t->blocked, sig))
+	if (!sigismember(&t->blocked, sig))
 		signal_wake_up(t, sig == SIGKILL);
 	return 0;
 }
@@ -925,7 +925,7 @@ __group_complete_signal(int sig, struct 
 int
 __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	int ret = 0;
+	int ret;
 
 	assert_spin_locked(&p->sighand->siglock);
 	handle_stop_signal(sig, p);
@@ -936,11 +936,10 @@ __group_send_sig_info(int sig, struct si
 	 * to avoid several races.
 	 */
 	ret = send_signal(sig, info, p, &p->signal->shared_pending);
-	if (unlikely(ret < 0))
+	if (ret <= 0)
 		return ret;
 
-	if (!ret)
-		__group_complete_signal(sig, p);
+	__group_complete_signal(sig, p);
 	return 0;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
