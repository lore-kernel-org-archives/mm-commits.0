From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:08:57 -0800
Message-ID: <563d08d9.QpXMrdoXef9nKRHX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033727AbbKFUI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hillf.zj@alibaba-inc.com, kwalker@redhat.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, skozina@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: cleanup the "kill sharing same memory" loop
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm/oom_kill: cleanup the "kill sharing same memory" loop

Purely cosmetic, but the complex "if" condition looks annoying to me.
Especially because it is not consistent with OOM_SCORE_ADJ_MIN check
which adds another if/continue.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Kyle Walker <kwalker@redhat.com>
Cc: Stanislav Kozina <skozina@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop
+++ a/mm/oom_kill.c
@@ -574,14 +574,18 @@ void oom_kill_process(struct oom_control
 	 * pending fatal signal.
 	 */
 	rcu_read_lock();
-	for_each_process(p)
-		if (p->mm == mm && !same_thread_group(p, victim) &&
-		    !(p->flags & PF_KTHREAD)) {
-			if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-				continue;
+	for_each_process(p) {
+		if (p->mm != mm)
+			continue;
+		if (same_thread_group(p, victim))
+			continue;
+		if (unlikely(p->flags & PF_KTHREAD))
+			continue;
+		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
+			continue;
 
-			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
-		}
+		do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
+	}
 	rcu_read_unlock();
 
 	mmdrop(mm);
_

Patches currently in -mm which might be from oleg@redhat.com are

proc-actually-make-proc_fd_permission-thread-friendly.patch
change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix.patch
signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

