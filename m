From: akpm@linux-foundation.org
Subject: [patch 14/19] oom_reaper: close race with exiting task
Date: Fri, 27 May 2016 14:27:35 -0700
Message-ID: <5748bbc7.xkGyr+tm1E2EQTdH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbcE0V1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 17:27:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp

From: Michal Hocko <mhocko@suse.com>
Subject: oom_reaper: close race with exiting task

Tetsuo has reported:
[   74.453958] Out of memory: Kill process 443 (oleg's-test) score 855 or sacrifice child
[   74.456234] Killed process 443 (oleg's-test) total-vm:493248kB, anon-rss:423880kB, file-rss:4kB, shmem-rss:0kB
[   74.459219] sh invoked oom-killer: gfp_mask=0x24201ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD), order=0, oom_score_adj=0
[   74.462813] sh cpuset=/ mems_allowed=0
[   74.465221] CPU: 2 PID: 1 Comm: sh Not tainted 4.6.0-rc7+ #51
[   74.467037] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[   74.470207]  0000000000000286 00000000a17a86b0 ffff88001e673a18 ffffffff812c7cbd
[   74.473422]  0000000000000000 ffff88001e673bd0 ffff88001e673ab8 ffffffff811b9e94
[   74.475704]  ffff88001e66cbe0 ffff88001e673ab8 0000000000000246 0000000000000000
[   74.477990] Call Trace:
[   74.479170]  [<ffffffff812c7cbd>] dump_stack+0x85/0xc8
[   74.480872]  [<ffffffff811b9e94>] dump_header+0x5b/0x394
[   74.481837] oom_reaper: reaped process 443 (oleg's-test), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB

In other words:
__oom_reap_task			exit_mm
  atomic_inc_not_zero
				  tsk->mm = NULL
				  mmput
				    atomic_dec_and_test # > 0
				  exit_oom_victim # New victim will be
						  # selected
				<OOM killer invoked>
				  # no TIF_MEMDIE task so we can select a new one
  unmap_page_range # to release the memory

The race exists even without the oom_reaper because anybody who pins the
address space and gets preempted might race with exit_mm but oom_reaper
made this race more probable.

We can address the oom_reaper part by using oom_lock for __oom_reap_task
because this would guarantee that a new oom victim will not be selected if
the oom reaper might race with the exit path.  This doesn't solve the
original issue, though, because somebody else still might be pinning
mm_users and so __mmput won't be called to release the memory but that is
not really realiably solvable because the task will get away from the oom
sight as soon as it is unhashed from the task_list and so we cannot
guarantee a new victim won't be selected.

[akpm@linux-foundation.org: fix use of unused `mm', Per Stephen]
[akpm@linux-foundation.org: coding-style fixes]
Fixes: aac453635549 ("mm, oom: introduce oom reaper")
Link: http://lkml.kernel.org/r/1464271493-20008-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~oom_reaper-close-race-with-exiting-task mm/oom_kill.c
--- a/mm/oom_kill.c~oom_reaper-close-race-with-exiting-task
+++ a/mm/oom_kill.c
@@ -443,13 +443,29 @@ static bool __oom_reap_task(struct task_
 {
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
-	struct mm_struct *mm;
+	struct mm_struct *mm = NULL;
 	struct task_struct *p;
 	struct zap_details details = {.check_swap_entries = true,
 				      .ignore_dirty = true};
 	bool ret = true;
 
 	/*
+	 * We have to make sure to not race with the victim exit path
+	 * and cause premature new oom victim selection:
+	 * __oom_reap_task		exit_mm
+	 *   atomic_inc_not_zero
+	 *				  mmput
+	 *				    atomic_dec_and_test
+	 *				  exit_oom_victim
+	 *				[...]
+	 *				out_of_memory
+	 *				  select_bad_process
+	 *				    # no TIF_MEMDIE task selects new victim
+	 *  unmap_page_range # frees some memory
+	 */
+	mutex_lock(&oom_lock);
+
+	/*
 	 * Make sure we find the associated mm_struct even when the particular
 	 * thread has already terminated and cleared its mm.
 	 * We might have race with exit path so consider our work done if there
@@ -457,19 +473,19 @@ static bool __oom_reap_task(struct task_
 	 */
 	p = find_lock_task_mm(tsk);
 	if (!p)
-		return true;
+		goto unlock_oom;
 
 	mm = p->mm;
 	if (!atomic_inc_not_zero(&mm->mm_users)) {
 		task_unlock(p);
-		return true;
+		goto unlock_oom;
 	}
 
 	task_unlock(p);
 
 	if (!down_read_trylock(&mm->mmap_sem)) {
 		ret = false;
-		goto out;
+		goto unlock_oom;
 	}
 
 	tlb_gather_mmu(&tlb, mm, 0, -1);
@@ -511,13 +527,15 @@ static bool __oom_reap_task(struct task_
 	 * to release its memory.
 	 */
 	set_bit(MMF_OOM_REAPED, &mm->flags);
-out:
+unlock_oom:
+	mutex_unlock(&oom_lock);
 	/*
 	 * Drop our reference but make sure the mmput slow path is called from a
 	 * different context because we shouldn't risk we get stuck there and
 	 * put the oom_reaper out of the way.
 	 */
-	mmput_async(mm);
+	if (mm)
+		mmput_async(mm);
 	return ret;
 }
 
_
