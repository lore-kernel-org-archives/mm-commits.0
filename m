From: akpm@linux-foundation.org
Subject: + signals-protect-cinit-from-blocked-fatal-signals.patch added to -mm tree
Date: Thu, 19 Feb 2009 14:26:30 -0800
Message-ID: <200902192226.n1JMQUg9027297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754582AbZBSW1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 17:27:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, daniel.lezcano@free.fr, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: protect cinit from blocked fatal signals
has been added to the -mm tree.  Its filename is
     signals-protect-cinit-from-blocked-fatal-signals.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -844,6 +844,8 @@ static int copy_signal(unsigned long clo
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
@@ -1862,9 +1862,16 @@ relock:
 
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

vfs-simple_set_mnt-should-return-void.patch
devpts-must-release-s_umount-on-error.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-protect-init-from-unwanted-signals-more.patch
signals-add-from_ancestor_ns-parameter-to-send_signal.patch
signals-protect-cinit-from-unblocked-sig_dfl-signals.patch
signals-zap_pid_ns_process-should-use-force_sig.patch
signals-protect-cinit-from-blocked-fatal-signals.patch
signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

