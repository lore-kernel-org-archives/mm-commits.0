From: akpm@linux-foundation.org
Subject: [folded-merged]
 signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 16:16:05 -0800
Message-ID: <563d42c5.ZQjt6TmUJ5qfznCs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804AbbKGAQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:16:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, balbi@ti.com, dwmw2@infradead.org, mpa@pengutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix
has been removed from the -mm tree.  Its filename was
     signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix.patch

This patch was dropped because it was folded into signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix

As Markus reports (thanks!)

	signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch

conflicts with the recent change in Linus' tree,

> I just realised that this patch will conflict with a fixup patch for nbd
> that will be included in rc7.
>
> dcc909d90ccd (nbd: Add locking for tasks)
>
> I think there is basically one new instance of dequeue_signal_lock() that
> needs to be replaced with kernel_dequeue_signal().

Unless I missed something, this new dequeue_signal_lock() should simply
die, but lets fix the conflict first.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/block/nbd.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix drivers/block/nbd.c
--- a/drivers/block/nbd.c~signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix
+++ a/drivers/block/nbd.c
@@ -587,10 +587,8 @@ static int nbd_thread_send(void *data)
 	spin_unlock_irqrestore(&nbd->tasks_lock, flags);
 
 	/* Clear maybe pending signals */
-	if (signal_pending(current)) {
-		siginfo_t info;
-		dequeue_signal_lock(current, &current->blocked, &info);
-	}
+	if (signal_pending(current))
+		kernel_dequeue_signal(NULL);
 
 	return 0;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

proc-actually-make-proc_fd_permission-thread-friendly.patch
change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

