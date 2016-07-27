From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch removed from -mm tree
Date: Wed, 27 Jul 2016 12:01:48 -0700
Message-ID: <5799051c.gnHeljjQmm9LrXUH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:01:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: make sure that mmput_async is called only when memory was reaped
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: make sure that mmput_async is called only when memory was reaped

Tetsuo is worried that mmput_async might still lead to a premature new oom
victim selection due to the following race:

__oom_reap_task				exit_mm
  find_lock_task_mm
  atomic_inc(mm->mm_users) # = 2
  task_unlock
  					  task_lock
					  task->mm = NULL
					  up_read(&mm->mmap_sem)
		< somebody write locks mmap_sem >
					  task_unlock
					  mmput
  					    atomic_dec_and_test # = 1
					  exit_oom_victim
  down_read_trylock # failed - no reclaim
  mmput_async # Takes unpredictable amount of time
  		< new OOM situation >

the final __mmput will be executed in the delayed context which might
happen far in the future.  Such a race is highly unlikely because the
write holder of mmap_sem would have to be an external task (all direct
holders are already killed or exiting) and it usually have to pin mm_users
in order to do anything reasonable.

We can, however, make sure that the mmput_async is only called when we do
not back off and reap some memory.  That would reduce the impact of the
delayed __mmput because the real content would be already freed.  Pin
mm_count to keep it alive after we drop task_lock and before we try to get
mmap_sem.  If the mmap_sem succeeds we can try to grab mm_users reference
and then go on with unmapping the address space.

It is not clear whether this race is possible at all but it is better to
be more robust and do not pin mm_users unless we are sure we are actually
doing some real work during __oom_reap_task.

Link: http://lkml.kernel.org/r/1465306987-30297-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped
+++ a/mm/oom_kill.c
@@ -452,7 +452,7 @@ static bool __oom_reap_task(struct task_
 	 * We have to make sure to not race with the victim exit path
 	 * and cause premature new oom victim selection:
 	 * __oom_reap_task		exit_mm
-	 *   atomic_inc_not_zero
+	 *   mmget_not_zero
 	 *				  mmput
 	 *				    atomic_dec_and_test
 	 *				  exit_oom_victim
@@ -474,12 +474,22 @@ static bool __oom_reap_task(struct task_
 	if (!p)
 		goto unlock_oom;
 	mm = p->mm;
-	atomic_inc(&mm->mm_users);
+	atomic_inc(&mm->mm_count);
 	task_unlock(p);
 
 	if (!down_read_trylock(&mm->mmap_sem)) {
 		ret = false;
-		goto unlock_oom;
+		goto mm_drop;
+	}
+
+	/*
+	 * increase mm_users only after we know we will reap something so
+	 * that the mmput_async is called only when we have reaped something
+	 * and delayed __mmput doesn't matter that much
+	 */
+	if (!mmget_not_zero(mm)) {
+		up_read(&mm->mmap_sem);
+		goto mm_drop;
 	}
 
 	tlb_gather_mmu(&tlb, mm, 0, -1);
@@ -521,15 +531,16 @@ static bool __oom_reap_task(struct task_
 	 * to release its memory.
 	 */
 	set_bit(MMF_OOM_REAPED, &mm->flags);
-unlock_oom:
-	mutex_unlock(&oom_lock);
 	/*
 	 * Drop our reference but make sure the mmput slow path is called from a
 	 * different context because we shouldn't risk we get stuck there and
 	 * put the oom_reaper out of the way.
 	 */
-	if (mm)
-		mmput_async(mm);
+	mmput_async(mm);
+mm_drop:
+	mmdrop(mm);
+unlock_oom:
+	mutex_unlock(&oom_lock);
 	return ret;
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

proc-oom-drop-bogus-task_lock-and-mm-check.patch
proc-oom-drop-bogus-sighand-lock.patch
proc-oom_adj-extract-oom_score_adj-setting-into-a-helper.patch
mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch
mm-oom-skip-vforked-tasks-from-being-selected.patch
mm-oom-kill-all-tasks-sharing-the-mm.patch
mm-oom-fortify-task_will_free_mem.patch
mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch
mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch
mm-oom-fortify-task_will_free_mem-fix.patch
freezer-oom-check-tif_memdie-on-the-correct-task.patch
cpuset-mm-fix-tif_memdie-check-in-cpuset_change_task_nodemask.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements.patch

