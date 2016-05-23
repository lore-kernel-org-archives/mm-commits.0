From: akpm@linux-foundation.org
Subject: +
 mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch added to -mm tree
Date: Mon, 23 May 2016 15:05:10 -0700
Message-ID: <57437e96.DpNzneY+rrOuZjsH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbcEWWFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 18:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, minchan@kernel.org, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom_reaper: remove some bloat
has been added to the -mm tree.  Its filename is
     mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch

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
Subject: mm: oom_reaper: remove some bloat

mmput_async is currently used only from the oom_reaper which is defined
only for CONFIG_MMU.  We can save work_struct in mm_struct for
!CONFIG_MMU.

Link: http://lkml.kernel.org/r/20160520061658.GB19172@dhcp22.suse.cz
Reported-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 ++
 include/linux/sched.h    |    2 ++
 kernel/fork.c            |    2 ++
 3 files changed, 6 insertions(+)

diff -puN include/linux/mm_types.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix
+++ a/include/linux/mm_types.h
@@ -514,7 +514,9 @@ struct mm_struct {
 #ifdef CONFIG_HUGETLB_PAGE
 	atomic_long_t hugetlb_usage;
 #endif
+#ifdef CONFIG_MMU
 	struct work_struct async_put_work;
+#endif
 };
 
 static inline void mm_init_cpumask(struct mm_struct *mm)
diff -puN include/linux/sched.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix include/linux/sched.h
--- a/include/linux/sched.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix
+++ a/include/linux/sched.h
@@ -2740,10 +2740,12 @@ static inline bool mmget_not_zero(struct
 
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
+#ifdef CONFIG_MMU
 /* same as above but performs the slow path from the async kontext. Can
  * be called from the atomic context as well
  */
 extern void mmput_async(struct mm_struct *);
+#endif
 
 /* Grab a reference to a task's mm, if it is not already going away */
 extern struct mm_struct *get_task_mm(struct task_struct *task);
diff -puN kernel/fork.c~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix kernel/fork.c
--- a/kernel/fork.c~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix
+++ a/kernel/fork.c
@@ -731,6 +731,7 @@ void mmput(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(mmput);
 
+#ifdef CONFIG_MMU
 static void mmput_async_fn(struct work_struct *work)
 {
 	struct mm_struct *mm = container_of(work, struct mm_struct, async_put_work);
@@ -744,6 +745,7 @@ void mmput_async(struct mm_struct *mm)
 		schedule_work(&mm->async_put_work);
 	}
 }
+#endif
 
 /**
  * set_mm_exe_file - change a reference to the mm's executable file
_

Patches currently in -mm which might be from mhocko@suse.com are

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

