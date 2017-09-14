From: akpm@linux-foundation.org
Subject: + android-binder-drop-lru-lock-in-isolate-callback.patch added to -mm tree
Date: Thu, 14 Sep 2017 13:15:03 -0700
Message-ID: <59bae347.ffRJtCFkZdR02Tpj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43130 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdINUPF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2017 16:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sherryy@android.com, aarcange@redhat.com, arve@android.com, cl@linux.com, fweisbec@gmail.com, gregkh@linuxfoundation.org, hillf.zj@alibaba-inc.com, hoeun.ryu@gmail.com, kyan@codeaurora.org, luto@kernel.org, maco@google.com, mhocko@suse.com, mingo@kernel.org, oleg@redhat.com, peterz@infradead.org, riandrews@android.com, tglx@linutronix.de, tkjos@google.com, vbabka@suse.cz, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: android: binder: drop lru lock in isolate callback
has been added to the -mm tree.  Its filename is
     android-binder-drop-lru-lock-in-isolate-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/android-binder-drop-lru-lock-in-isolate-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/android-binder-drop-lru-lock-in-isolate-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sherry Yang <sherryy@android.com>
Subject: android: binder: drop lru lock in isolate callback

Drop the global lru lock in isolate callback before calling zap_page_range
which calls cond_resched, and re-acquire the global lru lock before
returning.  Also change return code to LRU_REMOVED_RETRY.

Use mmput_async when fail to acquire mmap sem in an atomic context.

Fix "BUG: sleeping function called from invalid context"
errors when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.

Also restore mmput_async, which was initially introduced in ec8d7c14e
("mm, oom_reaper: do not mmput synchronously from the oom reaper
context"), and was removed in 212925802 ("mm: oom: let oom_reap_task and
exit_mmap run concurrently").

Link: http://lkml.kernel.org/r/20170914182231.90908-1-sherryy@android.com
Fixes: f2517eb76f1f2 ("android: binder: Add global lru shrinker to binder")
Signed-off-by: Sherry Yang <sherryy@android.com>
Reported-by: Kyle Yan <kyan@codeaurora.org>
Acked-by: Arve Hjønnevåg <arve@android.com>
Cc: Martijn Coenen <maco@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Riley Andrews <riandrews@android.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder_alloc.c |   18 ++++++++++++------
 include/linux/sched/mm.h       |    6 ++++++
 kernel/fork.c                  |   18 ++++++++++++++++++
 3 files changed, 36 insertions(+), 6 deletions(-)

diff -puN drivers/android/binder_alloc.c~android-binder-drop-lru-lock-in-isolate-callback drivers/android/binder_alloc.c
--- a/drivers/android/binder_alloc.c~android-binder-drop-lru-lock-in-isolate-callback
+++ a/drivers/android/binder_alloc.c
@@ -913,6 +913,7 @@ enum lru_status binder_alloc_free_page(s
 	struct binder_alloc *alloc;
 	uintptr_t page_addr;
 	size_t index;
+	struct vm_area_struct *vma;
 
 	alloc = page->alloc;
 	if (!mutex_trylock(&alloc->mutex))
@@ -923,16 +924,22 @@ enum lru_status binder_alloc_free_page(s
 
 	index = page - alloc->pages;
 	page_addr = (uintptr_t)alloc->buffer + index * PAGE_SIZE;
-	if (alloc->vma) {
+	vma = alloc->vma;
+	if (vma) {
 		mm = get_task_mm(alloc->tsk);
 		if (!mm)
 			goto err_get_task_mm_failed;
 		if (!down_write_trylock(&mm->mmap_sem))
 			goto err_down_write_mmap_sem_failed;
+	}
+
+	list_lru_isolate(lru, item);
+	spin_unlock(lock);
 
+	if (vma) {
 		trace_binder_unmap_user_start(alloc, index);
 
-		zap_page_range(alloc->vma,
+		zap_page_range(vma,
 			       page_addr + alloc->user_buffer_offset,
 			       PAGE_SIZE);
 
@@ -950,13 +957,12 @@ enum lru_status binder_alloc_free_page(s
 
 	trace_binder_unmap_kernel_end(alloc, index);
 
-	list_lru_isolate(lru, item);
-
+	spin_lock(lock);
 	mutex_unlock(&alloc->mutex);
-	return LRU_REMOVED;
+	return LRU_REMOVED_RETRY;
 
 err_down_write_mmap_sem_failed:
-	mmput(mm);
+	mmput_async(mm);
 err_get_task_mm_failed:
 err_page_already_freed:
 	mutex_unlock(&alloc->mutex);
diff -puN include/linux/sched/mm.h~android-binder-drop-lru-lock-in-isolate-callback include/linux/sched/mm.h
--- a/include/linux/sched/mm.h~android-binder-drop-lru-lock-in-isolate-callback
+++ a/include/linux/sched/mm.h
@@ -84,6 +84,12 @@ static inline bool mmget_not_zero(struct
 
 /* mmput gets rid of the mappings and all user-space */
 extern void mmput(struct mm_struct *);
+#ifdef CONFIG_MMU
+/* same as above but performs the slow path from the async context. Can
+ * be called from the atomic context as well
+ */
+void mmput_async(struct mm_struct *);
+#endif
 
 /* Grab a reference to a task's mm, if it is not already going away */
 extern struct mm_struct *get_task_mm(struct task_struct *task);
diff -puN kernel/fork.c~android-binder-drop-lru-lock-in-isolate-callback kernel/fork.c
--- a/kernel/fork.c~android-binder-drop-lru-lock-in-isolate-callback
+++ a/kernel/fork.c
@@ -946,6 +946,24 @@ void mmput(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(mmput);
 
+#ifdef CONFIG_MMU
+static void mmput_async_fn(struct work_struct *work)
+{
+	struct mm_struct *mm = container_of(work, struct mm_struct,
+					    async_put_work);
+
+	__mmput(mm);
+}
+
+void mmput_async(struct mm_struct *mm)
+{
+	if (atomic_dec_and_test(&mm->mm_users)) {
+		INIT_WORK(&mm->async_put_work, mmput_async_fn);
+		schedule_work(&mm->async_put_work);
+	}
+}
+#endif
+
 /**
  * set_mm_exe_file - change a reference to the mm's executable file
  *
_

Patches currently in -mm which might be from sherryy@android.com are

android-binder-drop-lru-lock-in-isolate-callback.patch

