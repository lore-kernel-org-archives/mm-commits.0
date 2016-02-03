From: akpm@linux-foundation.org
Subject: +
 oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch added to -mm tree
Date: Wed, 03 Feb 2016 15:19:46 -0800
Message-ID: <56b28b12.xNdhMMjj5KKZz54R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006AbcBCXTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 18:19:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, andrea@kernel.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: clear TIF_MEMDIE after oom_reaper managed to unmap the address space
has been added to the -mm tree.  Its filename is
     oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: oom: clear TIF_MEMDIE after oom_reaper managed to unmap the address space

When oom_reaper manages to unmap all the eligible vmas there shouldn't be
much of the freable memory held by the oom victim left anymore so it makes
sense to clear the TIF_MEMDIE flag for the victim and allow the OOM killer
to select another task.

The lack of TIF_MEMDIE also means that the victim cannot access memory
reserves anymore but that shouldn't be a problem because it would get the
access again if it needs to allocate and hits the OOM killer again due to
the fatal_signal_pending resp.  PF_EXITING check.  We can safely hide the
task from the OOM killer because it is clearly not a good candidate
anymore as everyhing reclaimable has been torn down already.

This patch will allow to cap the time an OOM victim can keep TIF_MEMDIE
and thus hold off further global OOM killer actions granted the oom reaper
is able to take mmap_sem for the associated mm struct.  This is not
guaranteed now but further steps should make sure that mmap_sem for write
should be blocked killable which will help to reduce such a lock
contention.  This is not done by this patch.

Note that exit_oom_victim might be called on a remote task from
__oom_reap_task now so we have to check and clear the flag atomically
otherwise we might race and underflow oom_victims or wake up waiters too
early.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Andrea Argangeli <andrea@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    2 -
 kernel/exit.c       |    2 -
 mm/oom_kill.c       |   73 +++++++++++++++++++++++++++---------------
 3 files changed, 50 insertions(+), 27 deletions(-)

diff -puN include/linux/oom.h~oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space include/linux/oom.h
--- a/include/linux/oom.h~oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space
+++ a/include/linux/oom.h
@@ -91,7 +91,7 @@ extern enum oom_scan_t oom_scan_process_
 
 extern bool out_of_memory(struct oom_control *oc);
 
-extern void exit_oom_victim(void);
+extern void exit_oom_victim(struct task_struct *tsk);
 
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
diff -puN kernel/exit.c~oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space kernel/exit.c
--- a/kernel/exit.c~oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space
+++ a/kernel/exit.c
@@ -434,7 +434,7 @@ static void exit_mm(struct task_struct *
 	mm_update_next_owner(mm);
 	mmput(mm);
 	if (test_thread_flag(TIF_MEMDIE))
-		exit_oom_victim();
+		exit_oom_victim(tsk);
 }
 
 static struct task_struct *find_alive_thread(struct task_struct *p)
diff -puN mm/oom_kill.c~oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space mm/oom_kill.c
--- a/mm/oom_kill.c~oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space
+++ a/mm/oom_kill.c
@@ -420,21 +420,37 @@ bool oom_killer_disabled __read_mostly;
  * victim (if that is possible) to help the OOM killer to move on.
  */
 static struct task_struct *oom_reaper_th;
-static struct mm_struct *mm_to_reap;
+static struct task_struct *task_to_reap;
 static DECLARE_WAIT_QUEUE_HEAD(oom_reaper_wait);
 
-static bool __oom_reap_vmas(struct mm_struct *mm)
+static bool __oom_reap_task(struct task_struct *tsk)
 {
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+	struct task_struct *p;
 	struct zap_details details = {.check_swap_entries = true,
 				      .ignore_dirty = true};
 	bool ret = true;
 
-	/* We might have raced with exit path */
-	if (!atomic_inc_not_zero(&mm->mm_users))
+	/*
+	 * Make sure we find the associated mm_struct even when the particular
+	 * thread has already terminated and cleared its mm.
+	 * We might have race with exit path so consider our work done if there
+	 * is no mm.
+	 */
+	p = find_lock_task_mm(tsk);
+	if (!p)
 		return true;
 
+	mm = p->mm;
+	if (!atomic_inc_not_zero(&mm->mm_users)) {
+		task_unlock(p);
+		return true;
+	}
+
+	task_unlock(p);
+
 	if (!down_read_trylock(&mm->mmap_sem)) {
 		ret = false;
 		goto out;
@@ -464,60 +480,66 @@ static bool __oom_reap_vmas(struct mm_st
 	}
 	tlb_finish_mmu(&tlb, 0, -1);
 	up_read(&mm->mmap_sem);
+
+	/*
+	 * Clear TIF_MEMDIE because the task shouldn't be sitting on a
+	 * reasonably reclaimable memory anymore. OOM killer can continue
+	 * by selecting other victim if unmapping hasn't led to any
+	 * improvements. This also means that selecting this task doesn't
+	 * make any sense.
+	 */
+	tsk->signal->oom_score_adj = OOM_SCORE_ADJ_MIN;
+	exit_oom_victim(tsk);
 out:
 	mmput(mm);
 	return ret;
 }
 
-static void oom_reap_vmas(struct mm_struct *mm)
+static void oom_reap_task(struct task_struct *tsk)
 {
 	int attempts = 0;
 
 	/* Retry the down_read_trylock(mmap_sem) a few times */
-	while (attempts++ < 10 && !__oom_reap_vmas(mm))
+	while (attempts++ < 10 && !__oom_reap_task(tsk))
 		schedule_timeout_idle(HZ/10);
 
 	/* Drop a reference taken by wake_oom_reaper */
-	mmdrop(mm);
+	put_task_struct(tsk);
 }
 
 static int oom_reaper(void *unused)
 {
 	while (true) {
-		struct mm_struct *mm;
+		struct task_struct *tsk;
 
 		wait_event_freezable(oom_reaper_wait,
-				     (mm = READ_ONCE(mm_to_reap)));
-		oom_reap_vmas(mm);
-		WRITE_ONCE(mm_to_reap, NULL);
+				     (tsk = READ_ONCE(task_to_reap)));
+		oom_reap_task(tsk);
+		WRITE_ONCE(task_to_reap, NULL);
 	}
 
 	return 0;
 }
 
-static void wake_oom_reaper(struct mm_struct *mm)
+static void wake_oom_reaper(struct task_struct *tsk)
 {
-	struct mm_struct *old_mm;
+	struct task_struct *old_tsk;
 
 	if (!oom_reaper_th)
 		return;
 
-	/*
-	 * Pin the given mm. Use mm_count instead of mm_users because
-	 * we do not want to delay the address space tear down.
-	 */
-	atomic_inc(&mm->mm_count);
+	get_task_struct(tsk);
 
 	/*
 	 * Make sure that only a single mm is ever queued for the reaper
 	 * because multiple are not necessary and the operation might be
 	 * disruptive so better reduce it to the bare minimum.
 	 */
-	old_mm = cmpxchg(&mm_to_reap, NULL, mm);
-	if (!old_mm)
+	old_tsk = cmpxchg(&task_to_reap, NULL, tsk);
+	if (!old_tsk)
 		wake_up(&oom_reaper_wait);
 	else
-		mmdrop(mm);
+		put_task_struct(tsk);
 }
 
 static int __init oom_init(void)
@@ -532,7 +554,7 @@ static int __init oom_init(void)
 }
 subsys_initcall(oom_init)
 #else
-static void wake_oom_reaper(struct mm_struct *mm)
+static void wake_oom_reaper(struct task_struct *mm)
 {
 }
 #endif
@@ -563,9 +585,10 @@ void mark_oom_victim(struct task_struct
 /**
  * exit_oom_victim - note the exit of an OOM victim
  */
-void exit_oom_victim(void)
+void exit_oom_victim(struct task_struct *tsk)
 {
-	clear_thread_flag(TIF_MEMDIE);
+	if (!test_and_clear_tsk_thread_flag(tsk, TIF_MEMDIE))
+		return;
 
 	if (!atomic_dec_return(&oom_victims))
 		wake_up_all(&oom_victims_wait);
@@ -752,7 +775,7 @@ void oom_kill_process(struct oom_control
 	rcu_read_unlock();
 
 	if (can_oom_reap)
-		wake_oom_reaper(mm);
+		wake_oom_reaper(victim);
 
 	mmdrop(mm);
 	put_task_struct(victim);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmstat-make-quiet_vmstat-lighter.patch
vmstat-make-vmstat_update-deferrable.patch
mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

