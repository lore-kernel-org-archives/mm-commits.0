From: akpm@linux-foundation.org
Subject: [merged] signals-protect-init-from-unwanted-signals-more.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:20 -0700
Message-ID: <200904061935.n36JZKXN011991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbZDFTkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:40:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, daniel.lezcano@free.fr, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, sukadev@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     signals: protect init from unwanted signals more
has been removed from the -mm tree.  Its filename was
     signals-protect-init-from-unwanted-signals-more.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: protect init from unwanted signals more
From: Oleg Nesterov <oleg@redhat.com>

(This is a modified version of the patch submitted by Oleg Nesterov
http://lkml.org/lkml/2008/11/18/249 and tries to address comments that
came up in that discussion)

init ignores the SIG_DFL signals but we queue them anyway, including
SIGKILL.  This is mostly OK, the signal will be dropped silently when
dequeued, but the pending SIGKILL has 2 bad implications:

        - it implies fatal_signal_pending(), so we confuse things
          like wait_for_completion_killable/lock_page_killable.

        - for the sub-namespace inits, the pending SIGKILL can
          mask (legacy_queue) the subsequent SIGKILL from the
          parent namespace which must kill cinit reliably.
          (preparation, cinits don't have SIGNAL_UNKILLABLE yet)

The patch can't help when init is ptraced, but ptracing of init is not
"safe" anyway.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~signals-protect-init-from-unwanted-signals-more kernel/signal.c
--- a/kernel/signal.c~signals-protect-init-from-unwanted-signals-more
+++ a/kernel/signal.c
@@ -55,10 +55,21 @@ static int sig_handler_ignored(void __us
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
-static int sig_ignored(struct task_struct *t, int sig)
+static int sig_task_ignored(struct task_struct *t, int sig)
 {
 	void __user *handler;
 
+	handler = sig_handler(t, sig);
+
+	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
+			handler == SIG_DFL)
+		return 1;
+
+	return sig_handler_ignored(handler, sig);
+}
+
+static int sig_ignored(struct task_struct *t, int sig)
+{
 	/*
 	 * Blocked signals are never ignored, since the
 	 * signal handler may change by the time it is
@@ -67,8 +78,7 @@ static int sig_ignored(struct task_struc
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	handler = sig_handler(t, sig);
-	if (!sig_handler_ignored(handler, sig))
+	if (!sig_task_ignored(t, sig))
 		return 0;
 
 	/*
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

