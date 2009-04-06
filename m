From: akpm@linux-foundation.org
Subject: [merged] signals-add-from_ancestor_ns-parameter-to-send_signal.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:23 -0700
Message-ID: <200904061935.n36JZN1N011994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbZDFTlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:41:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, daniel.lezcano@free.fr, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: add from_ancestor_ns parameter to send_signal()
has been removed from the -mm tree.  Its filename was
     signals-add-from_ancestor_ns-parameter-to-send_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

