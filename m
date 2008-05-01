From: akpm@linux-foundation.org
Subject: - signals-handle_stop_signal-dont-worry-about-sigkill.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:53 -0700
Message-ID: <200805010926.m419Qrux030343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbYEAJnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: handle_stop_signal: don't worry about SIGKILL
has been removed from the -mm tree.  Its filename was
     signals-handle_stop_signal-dont-worry-about-sigkill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: handle_stop_signal: don't worry about SIGKILL
From: Oleg Nesterov <oleg@tv-sign.ru>

handle_stop_signal() clears SIGNAL_STOP_DEQUEUED when sig == SIGKILL.  Remove
this nasty special case.  It was needed to prevent the race with group stop
and exit caused by thread-specific SIGKILL.  Now that we use complete_signal()
for private signals too this is not needed, complete_signal() will notice
SIGKILL and abort the soon-to-begin group stop.

Except: the target thread is dead (has PF_EXITING).  But in that case we
should not just clear SIGNAL_STOP_DEQUEUED and nothing more.  We should either
kill the whole thread group, or silently ignore the signal.

I suspect we are not right wrt zombie leaders, but this is another issue which
and should be fixed separately.  Note that this check can't abort the group
stop if it was already started/finished, this check only adds a subtle side
effect if we race with the thread which has already dequeued sig_kernel_stop()
signal and temporary released ->siglock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN kernel/signal.c~signals-handle_stop_signal-dont-worry-about-sigkill kernel/signal.c
--- a/kernel/signal.c~signals-handle_stop_signal-dont-worry-about-sigkill
+++ a/kernel/signal.c
@@ -643,12 +643,6 @@ static void handle_stop_signal(int sig, 
 			 */
 			signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 		}
-	} else if (sig == SIGKILL) {
-		/*
-		 * Make sure that any pending stop signal already dequeued
-		 * is undone by the wakeup for SIGKILL.
-		 */
-		signal->flags &= ~SIGNAL_STOP_DEQUEUED;
 	}
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

