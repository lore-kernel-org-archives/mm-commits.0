From: akpm@linux-foundation.org
Subject: + oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch
 added to -mm tree
Date: Tue, 17 May 2016 15:15:36 -0700
Message-ID: <573b9808.IUfdFK7Yxn9IEe/Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbcEQWPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2016 18:15:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, iamjoonsoo.kim@lge.com, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: consider multi-threaded tasks in task_will_free_mem
has been added to the -mm tree.  Its filename is
     oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-consider-multi-threaded-tasks-in-task_will_free_mem.patch

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
Subject: oom: consider multi-threaded tasks in task_will_free_mem

task_will_free_mem is a misnomer for a more complex PF_EXITING test for
early break out from the oom killer because it is believed that such a
task would release its memory shortly and so we do not have to select an
oom victim and perform a disruptive action.

Currently we make sure that the given task is not participating in the
core dumping because it might get blocked for a long time - see
d003f371b270 ("oom: don't assume that a coredumping thread will exit
soon").

The check can still do better though.  We shouldn't consider the task
unless the whole thread group is going down.  This is rather unlikely but
not impossible.  A single exiting thread would surely leave all the
address space behind.  If we are really unlucky it might get stuck on the
exit path and keep its TIF_MEMDIE and so block the oom killer.

Link: http://lkml.kernel.org/r/1460452756-15491-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN include/linux/oom.h~oom-consider-multi-threaded-tasks-in-task_will_free_mem include/linux/oom.h
--- a/include/linux/oom.h~oom-consider-multi-threaded-tasks-in-task_will_free_mem
+++ a/include/linux/oom.h
@@ -110,13 +110,24 @@ extern struct task_struct *find_lock_tas
 
 static inline bool task_will_free_mem(struct task_struct *task)
 {
+	struct signal_struct *sig = task->signal;
+
 	/*
 	 * A coredumping process may sleep for an extended period in exit_mm(),
 	 * so the oom killer cannot assume that the process will promptly exit
 	 * and release memory.
 	 */
-	return (task->flags & PF_EXITING) &&
-		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
+	if (sig->flags & SIGNAL_GROUP_COREDUMP)
+		return false;
+
+	if (!(task->flags & PF_EXITING))
+		return false;
+
+	/* Make sure that the whole thread group is going down */
+	if (!thread_group_empty(task) && !(sig->flags & SIGNAL_GROUP_EXIT))
+		return false;
+
+	return true;
 }
 
 /* sysctls */
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix-v2.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch
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

