From: akpm@linux-foundation.org
Subject: + exec-make-exec-path-waiting-for-mmap_sem-killable.patch added
 to -mm tree
Date: Wed, 27 Apr 2016 13:51:03 -0700
Message-ID: <57212637.XbkOcdd6wUXdOspi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbcD0UvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 16:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: exec: make exec path waiting for mmap_sem killable
has been added to the -mm tree.  Its filename is
     exec-make-exec-path-waiting-for-mmap_sem-killable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-make-exec-path-waiting-for-mmap_sem-killable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-make-exec-path-waiting-for-mmap_sem-killable.patch

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
Subject: exec: make exec path waiting for mmap_sem killable

setup_arg_pages requires mmap_sem for write.  If the waiting task gets
killed by the oom killer it would block oom_reaper from asynchronous
address space reclaim and reduce the chances of timely OOM resolving. 
Wait for the lock in the killable mode and return with EINTR if the task
got killed while waiting.  All the callers are already handling error path
and the fatal signal doesn't need any additional treatment.

The same applies to __bprm_mm_init.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~exec-make-exec-path-waiting-for-mmap_sem-killable fs/exec.c
--- a/fs/exec.c~exec-make-exec-path-waiting-for-mmap_sem-killable
+++ a/fs/exec.c
@@ -267,7 +267,10 @@ static int __bprm_mm_init(struct linux_b
 	if (!vma)
 		return -ENOMEM;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem)) {
+		err = -EINTR;
+		goto err_free;
+	}
 	vma->vm_mm = mm;
 
 	/*
@@ -294,6 +297,7 @@ static int __bprm_mm_init(struct linux_b
 	return 0;
 err:
 	up_write(&mm->mmap_sem);
+err_free:
 	bprm->vma = NULL;
 	kmem_cache_free(vm_area_cachep, vma);
 	return err;
@@ -700,7 +704,9 @@ int setup_arg_pages(struct linux_binprm
 		bprm->loader -= stack_shift;
 	bprm->exec -= stack_shift;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+
 	vm_flags = VM_STACK_FLAGS;
 
 	/*
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

