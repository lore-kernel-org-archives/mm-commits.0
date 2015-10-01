From: akpm@linux-foundation.org
Subject: +
 mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch added to -mm tree
Date: Thu, 01 Oct 2015 15:25:31 -0700
Message-ID: <560db2db.PSJiZuN8Q0/STAMB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbbJAWZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 18:25:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, kwalker@redhat.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, skozina@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: remove the wrong fatal_signal_pending() check in oom_kill_process()
has been added to the -mm tree.  Its filename is
     mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch

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
@@ -588,11 +588,7 @@ void oom_kill_process(struct oom_control
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

mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch
mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

