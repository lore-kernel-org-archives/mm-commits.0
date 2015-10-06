From: akpm@linux-foundation.org
Subject: + mmoom-fix-potentially-killing-unrelated-process-fix.patch added to -mm tree
Date: Tue, 06 Oct 2015 12:25:02 -0700
Message-ID: <5614200e.MclyqqPq0nSXlalh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbbJFTZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2015 15:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmoom-fix-potentially-killing-unrelated-process-fix
has been added to the -mm tree.  Its filename is
     mmoom-fix-potentially-killing-unrelated-process-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmoom-fix-potentially-killing-unrelated-process-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmoom-fix-potentially-killing-unrelated-process-fix.patch

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
Subject: mmoom-fix-potentially-killing-unrelated-process-fix

oom_kill_process() does atomic_inc(&mm->mm_users) to ensure that this ->mm
can't go away and this is wrong, change it to rely on ->mm_count and
mmdrop().

Firstly, we do not want to delay exit_mmap/etc if the victim exits before
we do mmput(), but this is minor.

More importantly, we simply can not do mmput() in oom_kill_process(), this
can deadlock if (for example) the caller holds i_mmap_rwsem and mmput()
actually leads to exit_mmap(); the victim can have this file mmaped and in
this case unmap_vmas/free_pgtables paths will take the same lock for
writing.  And at least huge_pmd_share() does pmd_alloc() under
i_mmap_rwsem because VM_HUGETLB memory is not reclaimable.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mmoom-fix-potentially-killing-unrelated-process-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-fix-potentially-killing-unrelated-process-fix
+++ a/mm/oom_kill.c
@@ -563,7 +563,7 @@ void oom_kill_process(struct oom_control
 
 	/* Get a reference to safely compare mm after task_unlock(victim) */
 	mm = victim->mm;
-	atomic_inc(&mm->mm_users);
+	atomic_inc(&mm->mm_count);
 	/*
 	 * We should send SIGKILL before setting TIF_MEMDIE in order to prevent
 	 * the OOM victim from depleting the memory reserves from the user
@@ -601,7 +601,7 @@ void oom_kill_process(struct oom_control
 		}
 	rcu_read_unlock();
 
-	mmput(mm);
+	mmdrop(mm);
 	put_task_struct(victim);
 }
 #undef K
_

Patches currently in -mm which might be from oleg@redhat.com are

mmoom-fix-potentially-killing-unrelated-process-fix.patch
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

