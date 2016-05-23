From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:45:45 -0700
Message-ID: <57435de9.hE0qbedKWg1H3fAS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbcEWTpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: do not mmput synchronously from the oom reaper context
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: do not mmput synchronously from the oom reaper context

Tetsuo has properly noted that mmput slow path might get blocked waiting
for another party (e.g.  exit_aio waits for an IO).  If that happens the
oom_reaper would be put out of the way and will not be able to process
next oom victim.  We should strive for making this context as reliable and
independent on other subsystems as much as possible.

Introduce mmput_async which will perform the slow path from an async (WQ)
context.  This will delay the operation but that shouldn't be a problem
because the oom_reaper has reclaimed the victim's address space for most
cases as much as possible and the remaining context shouldn't bind too
much memory anymore.  The only exception is when mmap_sem trylock has
failed which shouldn't happen too often.

The issue is only theoretical but not impossible.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +
 include/linux/sched.h    |    5 +++
 kernel/fork.c            |   50 +++++++++++++++++++++++++------------
 mm/oom_kill.c            |    8 ++++-
 4 files changed, 48 insertions(+), 17 deletions(-)

diff -puN include/linux/mm_types.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context
+++ a/include/linux/mm_types.h
@@ -12,6 +12,7 @@
 #include <linux/cpumask.h>
 #include <linux/uprobes.h>
 #include <linux/page-flags-layout.h>
+#include <linux/workqueue.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
@@ -513,6 +514,7 @@ struct mm_struct {
 #ifdef CONFIG_HUGETLB_PAGE
 	atomic_long_t hugetlb_usage;
 #endif
+	struct work_struct async_put_work;
 };
 
 static inline void mm_init_cpumask(struct mm_struct *mm)
diff -puN include/linux/sched.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context include/linux/sched.h
--- a/include/linux/sched.h~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context
+++ a/include/linux/sched.h
@@ -2730,6 +2730,11 @@ static inline void mmdrop(struct mm_stru
 
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
+/* same as above but performs the slow path from the async kontext. Can
+ * be called from the atomic context as well
+ */
+extern void mmput_async(struct mm_struct *);
+
 /* Grab a reference to a task's mm, if it is not already going away */
 extern struct mm_struct *get_task_mm(struct task_struct *task);
 /*
diff -puN kernel/fork.c~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context kernel/fork.c
--- a/kernel/fork.c~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context
+++ a/kernel/fork.c
@@ -699,6 +699,26 @@ void __mmdrop(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(__mmdrop);
 
+static inline void __mmput(struct mm_struct *mm)
+{
+	VM_BUG_ON(atomic_read(&mm->mm_users));
+
+	uprobe_clear_state(mm);
+	exit_aio(mm);
+	ksm_exit(mm);
+	khugepaged_exit(mm); /* must run before exit_mmap */
+	exit_mmap(mm);
+	set_mm_exe_file(mm, NULL);
+	if (!list_empty(&mm->mmlist)) {
+		spin_lock(&mmlist_lock);
+		list_del(&mm->mmlist);
+		spin_unlock(&mmlist_lock);
+	}
+	if (mm->binfmt)
+		module_put(mm->binfmt->module);
+	mmdrop(mm);
+}
+
 /*
  * Decrement the use count and release all resources for an mm.
  */
@@ -706,24 +726,24 @@ void mmput(struct mm_struct *mm)
 {
 	might_sleep();
 
+	if (atomic_dec_and_test(&mm->mm_users))
+		__mmput(mm);
+}
+EXPORT_SYMBOL_GPL(mmput);
+
+static void mmput_async_fn(struct work_struct *work)
+{
+	struct mm_struct *mm = container_of(work, struct mm_struct, async_put_work);
+	__mmput(mm);
+}
+
+void mmput_async(struct mm_struct *mm)
+{
 	if (atomic_dec_and_test(&mm->mm_users)) {
-		uprobe_clear_state(mm);
-		exit_aio(mm);
-		ksm_exit(mm);
-		khugepaged_exit(mm); /* must run before exit_mmap */
-		exit_mmap(mm);
-		set_mm_exe_file(mm, NULL);
-		if (!list_empty(&mm->mmlist)) {
-			spin_lock(&mmlist_lock);
-			list_del(&mm->mmlist);
-			spin_unlock(&mmlist_lock);
-		}
-		if (mm->binfmt)
-			module_put(mm->binfmt->module);
-		mmdrop(mm);
+		INIT_WORK(&mm->async_put_work, mmput_async_fn);
+		schedule_work(&mm->async_put_work);
 	}
 }
-EXPORT_SYMBOL_GPL(mmput);
 
 /**
  * set_mm_exe_file - change a reference to the mm's executable file
diff -puN mm/oom_kill.c~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context
+++ a/mm/oom_kill.c
@@ -446,7 +446,6 @@ static DECLARE_WAIT_QUEUE_HEAD(oom_reape
 static struct task_struct *oom_reaper_list;
 static DEFINE_SPINLOCK(oom_reaper_lock);
 
-
 static bool __oom_reap_task(struct task_struct *tsk)
 {
 	struct mmu_gather tlb;
@@ -520,7 +519,12 @@ static bool __oom_reap_task(struct task_
 	 */
 	set_bit(MMF_OOM_REAPED, &mm->flags);
 out:
-	mmput(mm);
+	/*
+	 * Drop our reference but make sure the mmput slow path is called from a
+	 * different context because we shouldn't risk we get stuck there and
+	 * put the oom_reaper out of the way.
+	 */
+	mmput_async(mm);
 	return ret;
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

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

