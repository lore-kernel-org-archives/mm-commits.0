From: akpm@linux-foundation.org
Subject: +
 protect-the-signal_unkillable-tasks-from-sig_kernel_only-signals.patch
 added to -mm tree
Date: Tue, 14 Nov 2017 16:28:44 -0800
Message-ID: <5a0b8a3c.N7PfS3Y/JcTJ8+Ds%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751872AbdKOA2p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 19:28:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, me@kylehuey.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: protect the SIGNAL_UNKILLABLE tasks from !sig_kernel_only() signals
has been added to the -mm tree.  Its filename is
     protect-the-signal_unkillable-tasks-from-sig_kernel_only-signals.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/protect-the-signal_unkillable-tasks-from-sig_kernel_only-signals.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/protect-the-signal_unkillable-tasks-from-sig_kernel_only-signals.patch

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
Subject: kernel/signal.c: protect the SIGNAL_UNKILLABLE tasks from !sig_kernel_only() signals

Change sig_task_ignored() to drop the SIG_DFL && !sig_kernel_only()
signals even if force == T.  This simplifies the next change and this
matches the same check in get_signal() which will drop these signals
anyway.

Link: http://lkml.kernel.org/r/20171103184227.GC21036@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~protect-the-signal_unkillable-tasks-from-sig_kernel_only-signals kernel/signal.c
--- a/kernel/signal.c~protect-the-signal_unkillable-tasks-from-sig_kernel_only-signals
+++ a/kernel/signal.c
@@ -78,7 +78,7 @@ static int sig_task_ignored(struct task_
 	handler = sig_handler(t, sig);
 
 	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
-			handler == SIG_DFL && !force)
+	    handler == SIG_DFL && !(force && sig_kernel_only(sig)))
 		return 1;
 
 	return sig_handler_ignored(handler, sig);
_

Patches currently in -mm which might be from oleg@redhat.com are

protect-the-traced-signal_unkillable-tasks-from-sigkill.patch
protect-the-signal_unkillable-tasks-from-sig_kernel_only-signals.patch
remove-the-no-longer-needed-signal_unkillable-check-in-complete_signal.patch

