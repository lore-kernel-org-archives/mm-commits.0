From: akpm@linux-foundation.org
Subject: +
 mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2.patch
 added to -mm tree
Date: Tue, 15 Aug 2017 14:31:20 -0700
Message-ID: <59936828.xA9kIx9UzInRxWdO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdHOVbV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2017 17:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, aarcange@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: remove unused mmput_async
has been added to the -mm tree.  Its filename is
     mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -925,22 +925,6 @@ void mmput(struct mm_struct *mm)
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
