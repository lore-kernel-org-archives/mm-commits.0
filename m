From: akpm@linux-foundation.org
Subject: +
 signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch added
 to -mm tree
Date: Mon, 05 Oct 2015 14:19:31 -0700
Message-ID: <5612e963.ge0JneVkvgycZoad%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbbJEVTc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:19:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, balbi@ti.com, dwmw2@infradead.org, mpa@pengutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: remove jffs2_garbage_collect_thread()->allow_signal(SIGCONT)
has been added to the -mm tree.  Its filename is
     signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch

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
Subject: signal: remove jffs2_garbage_collect_thread()->allow_signal(SIGCONT)

jffs2_garbage_collect_thread() does allow_signal(SIGCONT) for no reason,
SIGCONT will wake a stopped task up even if it is ignored.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/background.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/jffs2/background.c~signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont fs/jffs2/background.c
--- a/fs/jffs2/background.c~signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont
+++ a/fs/jffs2/background.c
@@ -80,7 +80,6 @@ static int jffs2_garbage_collect_thread(
 	siginitset(&hupmask, sigmask(SIGHUP));
 	allow_signal(SIGKILL);
 	allow_signal(SIGSTOP);
-	allow_signal(SIGCONT);
 	allow_signal(SIGHUP);
 
 	c->gc_task = current;
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch
mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

