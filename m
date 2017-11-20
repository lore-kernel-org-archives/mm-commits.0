From: akpm@linux-foundation.org
Subject: [merged]
 protect-the-signal_unkillable-tasks-from-sig_kernel_only-signals.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:25:51 -0800
Message-ID: <20171120212551.yKf9QxsUE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40780 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdKTVZw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:25:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@kylehuey.com, mm-commits@vger.kernel.org, oleg@redhat.com


The patch titled
     Subject: kernel/signal.c: protect the SIGNAL_UNKILLABLE tasks from !sig_kernel_only() signals
has been removed from the -mm tree.  Its filename was
     protect-the-signal_unkillable-tasks-from-sig_kernel_only-signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


