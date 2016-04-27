From: akpm@linux-foundation.org
Subject: + uprobes-wait-for-mmap_sem-for-write-killable.patch added to -mm tree
Date: Wed, 27 Apr 2016 13:51:07 -0700
Message-ID: <5721263b.nMNgZt8zmbSotbFi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbcD0UvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 16:51:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: uprobes: wait for mmap_sem for write killable
has been added to the -mm tree.  Its filename is
     uprobes-wait-for-mmap_sem-for-write-killable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uprobes-wait-for-mmap_sem-for-write-killable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uprobes-wait-for-mmap_sem-for-write-killable.patch

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
Subject: uprobes: wait for mmap_sem for write killable

xol_add_vma needs mmap_sem for write.  If the waiting task gets killed by
the oom killer it would block oom_reaper from asynchronous address space
reclaim and reduce the chances of timely OOM resolving.  Wait for the lock
in the killable mode and return with EINTR if the task got killed while
waiting.

Do not warn in dup_xol_work if __create_xol_area failed due to fatal
signal pending because this is usually considered a kernel issue.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/events/uprobes.c~uprobes-wait-for-mmap_sem-for-write-killable kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~uprobes-wait-for-mmap_sem-for-write-killable
+++ a/kernel/events/uprobes.c
@@ -1130,7 +1130,9 @@ static int xol_add_vma(struct mm_struct
 	struct vm_area_struct *vma;
 	int ret;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+
 	if (mm->uprobes_state.xol_area) {
 		ret = -EALREADY;
 		goto fail;
@@ -1469,7 +1471,8 @@ static void dup_xol_work(struct callback
 	if (current->flags & PF_EXITING)
 		return;
 
-	if (!__create_xol_area(current->utask->dup_xol_addr))
+	if (!__create_xol_area(current->utask->dup_xol_addr) &&
+			!fatal_signal_pending(current))
 		uprobe_warn(current, "dup xol area");
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
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
mm-use-compaction-feedback-for-thp-backoff-conditions.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch
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

