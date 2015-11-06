From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:08:54 -0800
Message-ID: <563d08d6.Mvp/oJGR+EXT9Zy0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033719AbbKFUIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, kwalker@redhat.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, skozina@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: remove the wrong fatal_signal_pending() check in oom_kill_process()
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm/oom_kill: remove the wrong fatal_signal_pending() check in oom_kill_process()

The fatal_signal_pending() was added to suppress unnecessary "sharing same
memory" message, but it can't 100% help anyway because it can be
false-negative; SIGKILL can be already dequeued.

And worse, it can be false-positive due to exec or coredump.  exec is
mostly fine, but coredump is not.  It is possible that the group leader
has the pending SIGKILL because its sub-thread originated the coredump, in
this case we must not skip this process.

We could probably add the additional ->group_exit_task check but this
patch just removes the wrong check along with pr_info().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Kyle Walker <kwalker@redhat.com>
Cc: Stanislav Kozina <skozina@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process
+++ a/mm/oom_kill.c
@@ -579,11 +579,7 @@ void oom_kill_process(struct oom_control
 		    !(p->flags & PF_KTHREAD)) {
 			if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 				continue;
-			if (fatal_signal_pending(p))
-				continue;
 
-			pr_info("Kill process %d (%s) sharing same memory\n",
-				task_pid_nr(p), p->comm);
 			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 		}
 	rcu_read_unlock();
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

