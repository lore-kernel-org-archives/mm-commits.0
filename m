From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmoom-fix-potentially-killing-unrelated-process-fix.patch removed from -mm
 tree
Date: Thu, 05 Nov 2015 18:24:10 -0800
Message-ID: <563c0f4a.OUZOlHHSbeMRH/Y9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031407AbbKFCYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:24:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hughd@google.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmoom-fix-potentially-killing-unrelated-process-fix
has been removed from the -mm tree.  Its filename was
     mmoom-fix-potentially-killing-unrelated-process-fix.patch

This patch was dropped because it was folded into mmoom-fix-potentially-killing-unrelated-process.patch

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
Acked-by: Hugh Dickins <hughd@google.com>
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

mmoom-fix-potentially-killing-unrelated-process.patch
mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch
mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch

