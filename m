From: akpm@linux-foundation.org
Subject: [merged]
 protect-the-traced-signal_unkillable-tasks-from-sigkill.patch removed from
 -mm tree
Date: Mon, 20 Nov 2017 13:25:48 -0800
Message-ID: <20171120212548.mCC03n7J-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752937AbdKTVZt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:25:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@kylehuey.com, mm-commits@vger.kernel.org, oleg@redhat.com


The patch titled
     Subject: kernel/signal.c: protect the traced SIGNAL_UNKILLABLE tasks from SIGKILL
has been removed from the -mm tree.  Its filename was
     protect-the-traced-signal_unkillable-tasks-from-sigkill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kernel/signal.c: protect the traced SIGNAL_UNKILLABLE tasks from SIGKILL

The comment in sig_ignored() says "Tracers may want to know about even
ignored signals" but SIGKILL can not be reported to debugger and it is
just wrong to return 0 in this case: SIGKILL should only kill the
SIGNAL_UNKILLABLE task if it comes from the parent ns.

Change sig_ignored() to ignore ->ptrace if sig == SIGKILL and rely on
sig_task_ignored().

SISGTOP coming from within the namespace is not really right too but at
least debugger can intercept it, and we can't drop it here because this
will break "gdb -p 1": ptrace_attach() won't work.  Perhaps we will add
another ->ptrace check later, we will see.

Link: http://lkml.kernel.org/r/20171103184206.GB21036@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/signal.c~protect-the-traced-signal_unkillable-tasks-from-sigkill kernel/signal.c
--- a/kernel/signal.c~protect-the-traced-signal_unkillable-tasks-from-sigkill
+++ a/kernel/signal.c
@@ -94,13 +94,15 @@ static int sig_ignored(struct task_struc
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	if (!sig_task_ignored(t, sig, force))
-		return 0;
