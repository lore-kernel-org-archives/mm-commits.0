From: akpm@linux-foundation.org
Subject: + protect-the-traced-signal_unkillable-tasks-from-sigkill.patch
 added to -mm tree
Date: Tue, 14 Nov 2017 16:28:41 -0800
Message-ID: <5a0b8a39.SAyZpKi3KEItdxA4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdKOA2n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 19:28:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, me@kylehuey.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: protect the traced SIGNAL_UNKILLABLE tasks from SIGKILL
has been added to the -mm tree.  Its filename is
     protect-the-traced-signal_unkillable-tasks-from-sigkill.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/protect-the-traced-signal_unkillable-tasks-from-sigkill.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/protect-the-traced-signal_unkillable-tasks-from-sigkill.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
