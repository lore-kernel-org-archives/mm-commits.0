From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2.patch
 removed from -mm tree
Date: Wed, 06 Sep 2017 16:09:51 -0700
Message-ID: <59b0803f.atb5l++zELAd/NzE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752351AbdIFXJw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: remove unused mmput_async
has been removed from the -mm tree.  Its filename was
     mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2.patch

This patch was dropped because it was folded into mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: remove unused mmput_async

After "mm: oom: let oom_reap_task and exit_mmap to run concurrently",
mmput_async() is no longer used.  Remove it.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1708141733130.50317@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    6 ------
 kernel/fork.c            |   16 ----------------
 2 files changed, 22 deletions(-)

diff -puN include/linux/sched/mm.h~mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2 include/linux/sched/mm.h
--- a/include/linux/sched/mm.h~mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2
+++ a/include/linux/sched/mm.h
@@ -84,12 +84,6 @@ static inline bool mmget_not_zero(struct
 
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
-#ifdef CONFIG_MMU
-/* same as above but performs the slow path from the async context. Can
- * be called from the atomic context as well
- */
-extern void mmput_async(struct mm_struct *);
-#endif
 
 /* Grab a reference to a task's mm, if it is not already going away */
 extern struct mm_struct *get_task_mm(struct task_struct *task);
diff -puN kernel/fork.c~mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2 kernel/fork.c
--- a/kernel/fork.c~mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2
+++ a/kernel/fork.c
@@ -937,22 +937,6 @@ void mmput(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(mmput);
 
-#ifdef CONFIG_MMU
-static void mmput_async_fn(struct work_struct *work)
-{
-	struct mm_struct *mm = container_of(work, struct mm_struct, async_put_work);
-	__mmput(mm);
-}
-
-void mmput_async(struct mm_struct *mm)
-{
-	if (atomic_dec_and_test(&mm->mm_users)) {
-		INIT_WORK(&mm->async_put_work, mmput_async_fn);
-		schedule_work(&mm->async_put_work);
-	}
-}
-#endif
