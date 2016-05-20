From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:06:05 -0700
Message-ID: <573f7c3d.PYgOXPnsaSyHPF28%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbcETVGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, daniel.vetter@intel.com, mst@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rmaksudova@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: clear TIF_MEMDIE for all tasks queued for oom_reaper
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: clear TIF_MEMDIE for all tasks queued for oom_reaper

Right now the oom reaper will clear TIF_MEMDIE only for tasks which were
successfully reaped.  This is the safest option because we know that such
an oom victim would only block forward progress of the oom killer without
a good reason because it is highly unlikely it would release much more
memory.  Basically most of its memory has been already torn down.

We can relax this assumption to catch more corner cases though.

The first obvious one is when the oom victim clears its mm and gets stuck
later on.  oom_reaper would back of on find_lock_task_mm returning NULL. 
We can safely try to clear TIF_MEMDIE in this case because such a task
would be ignored by the oom killer anyway.  The flag would be cleared by
that time already most of the time anyway.

The less obvious one is when the oom reaper fails due to mmap_sem
contention.  Even if we clear TIF_MEMDIE for this task then it is not very
likely that we would select another task too easily because we haven't
reaped the last victim and so it would be still the #1 candidate.  There
is a rare race condition possible when the current victim terminates
before the next select_bad_process but considering that oom_reap_task had
retried several times before giving up then this sounds like a borderline
thing.

After this patch we should have a guarantee that the OOM killer will not
be block for unbounded amount of time for most cases.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Raushaniya Maksudova <rmaksudova@parallels.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper
+++ a/mm/oom_kill.c
@@ -510,14 +510,10 @@ static bool __oom_reap_task(struct task_
 	up_read(&mm->mmap_sem);
 
 	/*
-	 * Clear TIF_MEMDIE because the task shouldn't be sitting on a
-	 * reasonably reclaimable memory anymore. OOM killer can continue
-	 * by selecting other victim if unmapping hasn't led to any
-	 * improvements. This also means that selecting this task doesn't
-	 * make any sense.
+	 * This task can be safely ignored because we cannot do much more
+	 * to release its memory.
 	 */
 	tsk->signal->oom_score_adj = OOM_SCORE_ADJ_MIN;
-	exit_oom_victim(tsk);
 out:
 	mmput(mm);
 	return ret;
@@ -538,6 +534,15 @@ static void oom_reap_task(struct task_st
 		debug_show_all_locks();
 	}
 
+	/*
+	 * Clear TIF_MEMDIE because the task shouldn't be sitting on a
+	 * reasonably reclaimable memory anymore or it is not a good candidate
+	 * for the oom victim right now because it cannot release its memory
+	 * itself nor by the oom reaper.
+	 */
+	tsk->oom_reaper_list = NULL;
+	exit_oom_victim(tsk);
+
 	/* Drop a reference taken by wake_oom_reaper */
 	put_task_struct(tsk);
 }
_

Patches currently in -mm which might be from mhocko@suse.com are

vmscan-consider-classzone_idx-in-compaction_ready.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages-fix.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-oom-protect-costly-allocations-some-more-fix.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch
oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch
mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls.patch
mm-make-vm_mmap-killable.patch
mm-make-vm_munmap-killable.patch
mm-aout-handle-vm_brk-failures.patch
mm-elf-handle-vm_brk-error.patch
mm-make-vm_brk-killable.patch
mm-proc-make-clear_refs-killable.patch
mm-fork-make-dup_mmap-wait-for-mmap_sem-for-write-killable.patch
ipc-shm-make-shmem-attach-detach-wait-for-mmap_sem-killable.patch
vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable.patch
coredump-make-coredump_wait-wait-for-mmap_sem-for-write-killable.patch
aio-make-aio_setup_ring-killable.patch
exec-make-exec-path-waiting-for-mmap_sem-killable.patch
prctl-make-pr_set_thp_disable-wait-for-mmap_sem-killable.patch
uprobes-wait-for-mmap_sem-for-write-killable.patch
drm-i915-make-i915_gem_mmap_ioctl-wait-for-mmap_sem-killable.patch
drm-radeon-make-radeon_mn_get-wait-for-mmap_sem-killable.patch
drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable.patch

