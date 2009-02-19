From: akpm@linux-foundation.org
Subject: + signals-add-from_ancestor_ns-parameter-to-send_signal.patch added to -mm tree
Date: Thu, 19 Feb 2009 14:26:20 -0800
Message-ID: <200902192226.n1JMQKW4027286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504AbZBSW1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 17:27:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, daniel.lezcano@free.fr, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: add from_ancestor_ns parameter to send_signal()
has been added to the -mm tree.  Its filename is
     signals-add-from_ancestor_ns-parameter-to-send_signal.patch

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
Subject: signals: add from_ancestor_ns parameter to send_signal()
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

send_signal() (or its helper) needs to determine the pid namespace of the
sender.  But a signal sent via kill_pid_info_as_uid() comes from within
the kernel and send_signal() does not need to determine the pid namespace
of the sender.  So define a helper for send_signal() which takes an
additional parameter, 'from_ancestor_ns' and have kill_pid_info_as_uid()
use that helper directly.

The 'from_ancestor_ns' parameter will be used in a follow-on patch.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~signals-add-from_ancestor_ns-parameter-to-send_signal kernel/signal.c
--- a/kernel/signal.c~signals-add-from_ancestor_ns-parameter-to-send_signal
+++ a/kernel/signal.c
@@ -823,8 +823,8 @@ static inline int legacy_queue(struct si
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
-static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
-			int group)
+static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
+			int group, int from_ancestor_ns)
 {
 	struct sigpending *pending;
 	struct sigqueue *q;
@@ -899,6 +899,12 @@ out_set:
 	return 0;
 }
 
+static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
+			int group)
+{
+	return __send_signal(sig, info, t, group, 0);
+}
+
 int print_fatal_signals;
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
@@ -1143,7 +1149,7 @@ int kill_pid_info_as_uid(int sig, struct
 	if (sig && p->sighand) {
 		unsigned long flags;
 		spin_lock_irqsave(&p->sighand->siglock, flags);
-		ret = __group_send_sig_info(sig, info, p);
+		ret = __send_signal(sig, info, p, 1, 0);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 out_unlock:
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

