From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-locking-api-convert-mmap_sem-api-comments.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:24:57 -0700
Message-ID: <20200521032457.ynpPkN-Ga%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbgEUDZA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:25:00 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap locking API: convert mmap_sem API comments
has been added to the -mm tree.  Its filename is
     mmap-locking-api-convert-mmap_sem-api-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap-locking-api-convert-mmap_sem-api-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap-locking-api-convert-mmap_sem-api-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mmap locking API: convert mmap_sem API comments

Convert comments that reference old mmap_sem APIs to reference
corresponding new mmap locking APIs instead.

Link: http://lkml.kernel.org/r/20200520052908.204642-12-walken@google.com
Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hmm.rst       |    6 +++---
 arch/alpha/mm/fault.c          |    2 +-
 arch/ia64/mm/fault.c           |    2 +-
 arch/m68k/mm/fault.c           |    2 +-
 arch/microblaze/mm/fault.c     |    2 +-
 arch/mips/mm/fault.c           |    2 +-
 arch/nds32/mm/fault.c          |    2 +-
 arch/nios2/mm/fault.c          |    2 +-
 arch/openrisc/mm/fault.c       |    2 +-
 arch/parisc/mm/fault.c         |    2 +-
 arch/riscv/mm/fault.c          |    2 +-
 arch/sh/mm/fault.c             |    2 +-
 arch/sparc/mm/fault_32.c       |    2 +-
 arch/sparc/mm/fault_64.c       |    2 +-
 arch/xtensa/mm/fault.c         |    2 +-
 drivers/android/binder_alloc.c |    4 ++--
 fs/hugetlbfs/inode.c           |    2 +-
 fs/userfaultfd.c               |    2 +-
 mm/filemap.c                   |    2 +-
 mm/gup.c                       |   12 ++++++------
 mm/huge_memory.c               |    4 ++--
 mm/khugepaged.c                |    2 +-
 mm/ksm.c                       |    2 +-
 mm/memory.c                    |    4 ++--
 mm/mempolicy.c                 |    2 +-
 mm/migrate.c                   |    4 ++--
 mm/mmap.c                      |    2 +-
 mm/oom_kill.c                  |    8 ++++----
 net/ipv4/tcp.c                 |    2 +-
 29 files changed, 43 insertions(+), 43 deletions(-)

--- a/arch/alpha/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/alpha/mm/fault.c
@@ -171,7 +171,7 @@ retry:
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
-			 /* No need to up_read(&mm->mmap_sem) as we would
+			 /* No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/ia64/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/ia64/mm/fault.c
@@ -173,7 +173,7 @@ retry:
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
-			 /* No need to up_read(&mm->mmap_sem) as we would
+			 /* No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/m68k/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/m68k/mm/fault.c
@@ -165,7 +165,7 @@ good_area:
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
-			 * No need to up_read(&mm->mmap_sem) as we would
+			 * No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/microblaze/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/microblaze/mm/fault.c
@@ -238,7 +238,7 @@ good_area:
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
-			 * No need to up_read(&mm->mmap_sem) as we would
+			 * No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/mips/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/mips/mm/fault.c
@@ -181,7 +181,7 @@ good_area:
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
-			 * No need to up_read(&mm->mmap_sem) as we would
+			 * No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/nds32/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/nds32/mm/fault.c
@@ -247,7 +247,7 @@ good_area:
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
-			/* No need to up_read(&mm->mmap_sem) as we would
+			/* No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/nios2/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/nios2/mm/fault.c
@@ -160,7 +160,7 @@ good_area:
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
-			 * No need to up_read(&mm->mmap_sem) as we would
+			 * No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/openrisc/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/openrisc/mm/fault.c
@@ -183,7 +183,7 @@ good_area:
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
-			 /* No need to up_read(&mm->mmap_sem) as we would
+			 /* No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/parisc/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/parisc/mm/fault.c
@@ -329,7 +329,7 @@ good_area:
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			/*
-			 * No need to up_read(&mm->mmap_sem) as we would
+			 * No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/riscv/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/riscv/mm/fault.c
@@ -147,7 +147,7 @@ good_area:
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
-			 * No need to up_read(&mm->mmap_sem) as we would
+			 * No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/sh/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/sh/mm/fault.c
@@ -502,7 +502,7 @@ good_area:
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
-			 * No need to up_read(&mm->mmap_sem) as we would
+			 * No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/sparc/mm/fault_32.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/sparc/mm/fault_32.c
@@ -262,7 +262,7 @@ good_area:
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
-			/* No need to up_read(&mm->mmap_sem) as we would
+			/* No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/sparc/mm/fault_64.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/sparc/mm/fault_64.c
@@ -450,7 +450,7 @@ good_area:
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
-			/* No need to up_read(&mm->mmap_sem) as we would
+			/* No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/arch/xtensa/mm/fault.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/arch/xtensa/mm/fault.c
@@ -130,7 +130,7 @@ good_area:
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
-			 /* No need to up_read(&mm->mmap_sem) as we would
+			 /* No need to mmap_read_unlock(mm) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
--- a/Documentation/vm/hmm.rst~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/Documentation/vm/hmm.rst
@@ -191,15 +191,15 @@ The usage pattern is::
 
  again:
       range.notifier_seq = mmu_interval_read_begin(&interval_sub);
-      down_read(&mm->mmap_sem);
+      mmap_read_lock(mm);
       ret = hmm_range_fault(&range);
       if (ret) {
-          up_read(&mm->mmap_sem);
+          mmap_read_unlock(mm);
           if (ret == -EBUSY)
                  goto again;
           return ret;
       }
-      up_read(&mm->mmap_sem);
+      mmap_read_unlock(mm);
 
       take_lock(driver->update);
       if (mmu_interval_read_retry(&ni, range.notifier_seq) {
--- a/drivers/android/binder_alloc.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/drivers/android/binder_alloc.c
@@ -933,7 +933,7 @@ enum lru_status binder_alloc_free_page(s
 	if (!mmget_not_zero(mm))
 		goto err_mmget;
 	if (!mmap_read_trylock(mm))
-		goto err_down_read_mmap_sem_failed;
+		goto err_mmap_read_lock_failed;
 	vma = binder_alloc_get_vma(alloc);
 
 	list_lru_isolate(lru, item);
@@ -960,7 +960,7 @@ enum lru_status binder_alloc_free_page(s
 	mutex_unlock(&alloc->mutex);
 	return LRU_REMOVED_RETRY;
 
-err_down_read_mmap_sem_failed:
+err_mmap_read_lock_failed:
 	mmput_async(mm);
 err_mmget:
 err_page_already_freed:
--- a/fs/hugetlbfs/inode.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/fs/hugetlbfs/inode.c
@@ -187,7 +187,7 @@ out:
 }
 
 /*
- * Called under down_write(mmap_sem).
+ * Called under mmap_write_lock(mm).
  */
 
 #ifndef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
--- a/fs/userfaultfd.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/fs/userfaultfd.c
@@ -1248,7 +1248,7 @@ static __always_inline void wake_userfau
 	/*
 	 * To be sure waitqueue_active() is not reordered by the CPU
 	 * before the pagetable update, use an explicit SMP memory
-	 * barrier here. PT lock release or up_read(mmap_sem) still
+	 * barrier here. PT lock release or mmap_read_unlock(mm) still
 	 * have release semantics that can allow the
 	 * waitqueue_active() to be reordered before the pte update.
 	 */
--- a/mm/filemap.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/mm/filemap.c
@@ -1373,7 +1373,7 @@ EXPORT_SYMBOL_GPL(__lock_page_killable);
  * Return values:
  * 1 - page is locked; mmap_sem is still held.
  * 0 - page is not locked.
- *     mmap_sem has been released (up_read()), unless flags had both
+ *     mmap_lock has been released (mmap_read_unlock(), unless flags had both
  *     FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_RETRY_NOWAIT set, in
  *     which case mmap_sem is still held.
  *
--- a/mm/gup.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/mm/gup.c
@@ -1978,19 +1978,19 @@ EXPORT_SYMBOL(get_user_pages);
 /**
  * get_user_pages_locked() is suitable to replace the form:
  *
- *      down_read(&mm->mmap_sem);
+ *      mmap_read_lock(mm);
  *      do_something()
  *      get_user_pages(tsk, mm, ..., pages, NULL);
- *      up_read(&mm->mmap_sem);
+ *      mmap_read_unlock(mm);
  *
  *  to:
  *
  *      int locked = 1;
- *      down_read(&mm->mmap_sem);
+ *      mmap_read_lock(mm);
  *      do_something()
  *      get_user_pages_locked(tsk, mm, ..., pages, &locked);
  *      if (locked)
- *          up_read(&mm->mmap_sem);
+ *          mmap_read_unlock(mm);
  *
  * @start:      starting user address
  * @nr_pages:   number of pages from start to pin
@@ -2029,9 +2029,9 @@ EXPORT_SYMBOL(get_user_pages_locked);
 /*
  * get_user_pages_unlocked() is suitable to replace the form:
  *
- *      down_read(&mm->mmap_sem);
+ *      mmap_read_lock(mm);
  *      get_user_pages(tsk, mm, ..., pages, NULL);
- *      up_read(&mm->mmap_sem);
+ *      mmap_read_unlock(mm);
  *
  *  with:
  *
--- a/mm/huge_memory.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/mm/huge_memory.c
@@ -1834,9 +1834,9 @@ int change_huge_pmd(struct vm_area_struc
 		goto unlock;
 
 	/*
-	 * In case prot_numa, we are under down_read(mmap_sem). It's critical
+	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
 	 * to not clear pmd intermittently to avoid race with MADV_DONTNEED
-	 * which is also under down_read(mmap_sem):
+	 * which is also under mmap_read_lock(mm):
 	 *
 	 *	CPU0:				CPU1:
 	 *				change_huge_pmd(prot_numa=1)
--- a/mm/khugepaged.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/mm/khugepaged.c
@@ -1544,7 +1544,7 @@ static void retract_page_tables(struct a
 		/*
 		 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
 		 * got written to. These VMAs are likely not worth investing
-		 * down_write(mmap_sem) as PMD-mapping is likely to be split
+		 * mmap_write_lock(mm) as PMD-mapping is likely to be split
 		 * later.
 		 *
 		 * Not that vma->anon_vma check is racy: it can be set up after
--- a/mm/ksm.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/mm/ksm.c
@@ -2362,7 +2362,7 @@ next_mm:
 	} else {
 		mmap_read_unlock(mm);
 		/*
-		 * up_read(&mm->mmap_sem) first because after
+		 * mmap_read_unlock(mm) first because after
 		 * spin_unlock(&ksm_mmlist_lock) run, the "mm" may
 		 * already have been freed under us by __ksm_exit()
 		 * because the "mm_slot" is still hashed and
--- a/mm/memory.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/mm/memory.c
@@ -3318,10 +3318,10 @@ static vm_fault_t do_anonymous_page(stru
 	 * pte_offset_map() on pmds where a huge pmd might be created
 	 * from a different thread.
 	 *
-	 * pte_alloc_map() is safe to use under down_write(mmap_sem) or when
+	 * pte_alloc_map() is safe to use under mmap_write_lock(mm) or when
 	 * parallel threads are excluded by other means.
 	 *
-	 * Here we only have down_read(mmap_sem).
+	 * Here we only have mmap_read_lock(mm).
 	 */
 	if (pte_alloc(vma->vm_mm, vmf->pmd))
 		return VM_FAULT_OOM;
--- a/mm/mempolicy.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/mm/mempolicy.c
@@ -2185,7 +2185,7 @@ static struct page *alloc_page_interleav
  *
  * 	This function allocates a page from the kernel page pool and applies
  *	a NUMA policy associated with the VMA or the current process.
- *	When VMA is not NULL caller must hold down_read on the mmap_sem of the
+ *	When VMA is not NULL caller must read-lock the mmap_lock of the
  *	mm_struct of the VMA to prevent it from going away. Should be used for
  *	all allocations for pages that will be mapped into user space. Returns
  *	NULL when no page can be allocated.
--- a/mm/migrate.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/mm/migrate.c
@@ -2790,10 +2790,10 @@ static void migrate_vma_insert_page(stru
 	 * pte_offset_map() on pmds where a huge pmd might be created
 	 * from a different thread.
 	 *
-	 * pte_alloc_map() is safe to use under down_write(mmap_sem) or when
+	 * pte_alloc_map() is safe to use under mmap_write_lock(mm) or when
 	 * parallel threads are excluded by other means.
 	 *
-	 * Here we only have down_read(mmap_sem).
+	 * Here we only have mmap_read_lock(mm).
 	 */
 	if (pte_alloc(mm, pmdp))
 		goto abort;
--- a/mm/mmap.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/mm/mmap.c
@@ -1369,7 +1369,7 @@ static inline bool file_mmap_ok(struct f
 }
 
 /*
- * The caller must hold down_write(&current->mm->mmap_sem).
+ * The caller must write-lock current->mm->mmap_lock.
  */
 unsigned long do_mmap(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
--- a/mm/oom_kill.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/mm/oom_kill.c
@@ -577,8 +577,8 @@ static bool oom_reap_task_mm(struct task
 	/*
 	 * MMF_OOM_SKIP is set by exit_mmap when the OOM reaper can't
 	 * work on the mm anymore. The check for MMF_OOM_SKIP must run
-	 * under mmap_sem for reading because it serializes against the
-	 * down_write();up_write() cycle in exit_mmap().
+	 * under mmap_lock for reading because it serializes against the
+	 * mmap_write_lock();mmap_write_unlock() cycle in exit_mmap().
 	 */
 	if (test_bit(MMF_OOM_SKIP, &mm->flags)) {
 		trace_skip_task_reaping(tsk->pid);
@@ -611,7 +611,7 @@ static void oom_reap_task(struct task_st
 	int attempts = 0;
 	struct mm_struct *mm = tsk->signal->oom_mm;
 
-	/* Retry the down_read_trylock(mmap_sem) a few times */
+	/* Retry the mmap_read_trylock(mm) a few times */
 	while (attempts++ < MAX_OOM_REAP_RETRIES && !oom_reap_task_mm(tsk, mm))
 		schedule_timeout_idle(HZ/10);
 
@@ -629,7 +629,7 @@ done:
 
 	/*
 	 * Hide this mm from OOM killer because it has been either reaped or
-	 * somebody can't call up_write(mmap_sem).
+	 * somebody can't call mmap_write_unlock(mm).
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 
--- a/net/ipv4/tcp.c~mmap-locking-api-convert-mmap_sem-api-comments
+++ a/net/ipv4/tcp.c
@@ -1734,7 +1734,7 @@ int tcp_mmap(struct file *file, struct s
 		return -EPERM;
 	vma->vm_flags &= ~(VM_MAYWRITE | VM_MAYEXEC);
 
-	/* Instruct vm_insert_page() to not down_read(mmap_sem) */
+	/* Instruct vm_insert_page() to not mmap_read_lock(mm) */
 	vma->vm_flags |= VM_MIXEDMAP;
 
 	vma->vm_ops = &tcp_vm_ops;
_

Patches currently in -mm which might be from walken@google.com are

mmap-locking-api-initial-implementation-as-rwsem-wrappers.patch
mmu-notifier-use-the-new-mmap-locking-api.patch
dma-reservations-use-the-new-mmap-locking-api.patch
mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch
mmap-locking-api-convert-nested-write-lock-sites.patch
mmap-locking-api-add-mmap_read_trylock_non_owner.patch
mmap-locking-api-add-mmap_lock_initializer.patch
mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock.patch
mmap-locking-api-convert-mmap_sem-api-comments.patch
mmap-locking-api-convert-mmap_sem-comments.patch
