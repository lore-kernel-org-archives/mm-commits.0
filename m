From: akpm@linux-foundation.org
Subject: [merged]
 signal-dont-remove-signal_unkillable-for-traced-tasks.patch removed from
 -mm tree
Date: Mon, 21 Aug 2017 11:30:19 -0700
Message-ID: <20170821183019.WdsPLxpjO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50432 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753800AbdHUSaU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2017 14:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jamie.iles@oracle.com, mm-commits@vger.kernel.org, oleg@redhat.com


The patch titled
     Subject: signal: don't remove SIGNAL_UNKILLABLE for traced tasks.
has been removed from the -mm tree.  Its filename was
     signal-dont-remove-signal_unkillable-for-traced-tasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jamie Iles <jamie.iles@oracle.com>
Subject: signal: don't remove SIGNAL_UNKILLABLE for traced tasks.

When forcing a signal, SIGNAL_UNKILLABLE is removed to prevent recursive
faults, but this is undesirable when tracing.  For example, debugging an
init process (whether global or namespace), hitting a breakpoint and
SIGTRAP will force SIGTRAP and then remove SIGNAL_UNKILLABLE.  Everything
continues fine, but then once debugging has finished, the init process is
left killable which is unlikely what the user expects, resulting in either
an accidentally killed init or an init that stops reaping zombies.

Link: http://lkml.kernel.org/r/20170815112806.10728-1-jamie.iles@oracle.com
Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~signal-dont-remove-signal_unkillable-for-traced-tasks kernel/signal.c
--- a/kernel/signal.c~signal-dont-remove-signal_unkillable-for-traced-tasks
+++ a/kernel/signal.c
@@ -1194,7 +1194,11 @@ force_sig_info(int sig, struct siginfo *
 			recalc_sigpending_and_wake(t);
 		}
 	}
-	if (action->sa.sa_handler == SIG_DFL)
+	/*
+	 * Don't clear SIGNAL_UNKILLABLE for traced tasks, users won't expect
+	 * debugging to leave init killable.
+	 */
+	if (action->sa.sa_handler == SIG_DFL && !t->ptrace)
 		t->signal->flags &= ~SIGNAL_UNKILLABLE;
 	ret = specific_send_sig_info(sig, info, t);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
_

Patches currently in -mm which might be from jamie.iles@oracle.com are


