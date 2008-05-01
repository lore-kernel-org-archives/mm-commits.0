From: akpm@linux-foundation.org
Subject: - signals-allow-the-kernel-to-actually-kill-sbin-init.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:11 -0700
Message-ID: <200805010927.m419RBv7030396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939AbYEAJ17 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: allow the kernel to actually kill /sbin/init
has been removed from the -mm tree.  Its filename was
     signals-allow-the-kernel-to-actually-kill-sbin-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: allow the kernel to actually kill /sbin/init
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently the buggy /sbin/init hangs if SIGSEGV/etc happens.  The kernel sends
the signal, init dequeues it and ignores, returns from the exception, repeats
the faulting instruction, and so on forever.

Imho, such a behaviour is not good.  I think that the explicit loud death of
the buggy /sbin/init is better than the silent hang.

Change force_sig_info() to clear SIGNAL_UNKILLABLE when the task should be
really killed.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~signals-allow-the-kernel-to-actually-kill-sbin-init kernel/signal.c
--- a/kernel/signal.c~signals-allow-the-kernel-to-actually-kill-sbin-init
+++ a/kernel/signal.c
@@ -892,7 +892,8 @@ specific_send_sig_info(int sig, struct s
  * since we do not want to have a signal handler that was blocked
  * be invoked when user space had explicitly blocked it.
  *
- * We don't want to have recursive SIGSEGV's etc, for example.
+ * We don't want to have recursive SIGSEGV's etc, for example,
+ * that is why we also clear SIGNAL_UNKILLABLE.
  */
 int
 force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
@@ -912,6 +913,8 @@ force_sig_info(int sig, struct siginfo *
 			recalc_sigpending_and_wake(t);
 		}
 	}
+	if (action->sa.sa_handler == SIG_DFL)
+		t->signal->flags &= ~SIGNAL_UNKILLABLE;
 	ret = specific_send_sig_info(sig, info, t);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

