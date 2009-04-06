From: akpm@linux-foundation.org
Subject: [merged] signals-protect-cinit-from-blocked-fatal-signals.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:29 -0700
Message-ID: <200904061935.n36JZTE5012058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757975AbZDFTkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, daniel.lezcano@free.fr, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: protect cinit from blocked fatal signals
has been removed from the -mm tree.  Its filename was
     signals-protect-cinit-from-blocked-fatal-signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: protect cinit from blocked fatal signals
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Normally SIG_DFL signals to global and container-init are dropped early. 
But if a signal is blocked when it is posted, we cannot drop the signal
since the receiver may install a handler before unblocking the signal. 
Once this signal is queued however, the receiver container-init has no way
of knowing if the signal was sent from an ancestor or descendant
namespace.  This patch ensures that contianer-init drops all SIG_DFL
signals in get_signal_to_deliver() except SIGKILL/SIGSTOP.

If SIGSTOP/SIGKILL originate from a descendant of container-init they are
never queued (i.e dropped in sig_ignored() in an earler patch).

If SIGSTOP/SIGKILL originate from parent namespace, the signal is queued
and container-init processes the signal.

IOW, if get_signal_to_deliver() sees a sig_kernel_only() signal for global
or container-init, the signal must have been generated internally or must
have come from an ancestor ns and we process the signal.

Further, the signal_group_exit() check was needed to cover the case of a
multi-threaded init sending SIGKILL to other threads when doing an exit()
or exec().  But since the new sig_kernel_only() check covers the SIGKILL,
the signal_group_exit() check is no longer needed and can be removed.

Finally, now that we have all pieces in place, set SIGNAL_UNKILLABLE for
container-inits.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c   |    2 ++
 kernel/signal.c |    9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN kernel/fork.c~signals-protect-cinit-from-blocked-fatal-signals kernel/fork.c
--- a/kernel/fork.c~signals-protect-cinit-from-blocked-fatal-signals
+++ a/kernel/fork.c
@@ -841,6 +841,8 @@ static int copy_signal(unsigned long clo
 	atomic_set(&sig->live, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
 	sig->flags = 0;
+	if (clone_flags & CLONE_NEWPID)
+		sig->flags |= SIGNAL_UNKILLABLE;
 	sig->group_exit_code = 0;
 	sig->group_exit_task = NULL;
 	sig->group_stop_count = 0;
diff -puN kernel/signal.c~signals-protect-cinit-from-blocked-fatal-signals kernel/signal.c
--- a/kernel/signal.c~signals-protect-cinit-from-blocked-fatal-signals
+++ a/kernel/signal.c
@@ -1870,9 +1870,16 @@ relock:
 
 		/*
 		 * Global init gets no signals it doesn't want.
+		 * Container-init gets no signals it doesn't want from same
+		 * container.
+		 *
+		 * Note that if global/container-init sees a sig_kernel_only()
+		 * signal here, the signal must have been generated internally
+		 * or must have come from an ancestor namespace. In either
+		 * case, the signal cannot be dropped.
 		 */
 		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
-		    !signal_group_exit(signal))
+				!sig_kernel_only(signr))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

origin.patch
linux-next.patch

