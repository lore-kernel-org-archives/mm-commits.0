From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmap-locking-api-rename-mmap_sem-to-mmap_lock.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:24:51 -0700
Message-ID: <20200521032451.1KbJ3kVYc%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbgEUDYx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:24:53 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap locking API: rename mmap_sem to mmap_lock
has been added to the -mm tree.  Its filename is
     mmap-locking-api-rename-mmap_sem-to-mmap_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap-locking-api-rename-mmap_sem-to-mmap_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap-locking-api-rename-mmap_sem-to-mmap_lock.patch

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
Subject: mmap locking API: rename mmap_sem to mmap_lock

Rename the mmap_sem field to mmap_lock.  Any new uses of this lock should
now go through the new mmap locking api.  The mmap_lock is still
implemented as a rwsem, though this could change in the future.

Link: http://lkml.kernel.org/r/20200520052908.204642-11-walken@google.com
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
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
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/fault.c                  |    4 +-
 arch/x86/mm/fault.c                   |    2 -
 drivers/gpu/drm/etnaviv/etnaviv_gem.c |    2 -
 include/linux/mm_types.h              |    2 -
 include/linux/mmap_lock.h             |   38 ++++++++++++------------
 mm/memory.c                           |    2 -
 mm/mmap.c                             |    4 +-
 mm/mmu_notifier.c                     |    2 -
 8 files changed, 28 insertions(+), 28 deletions(-)

--- a/arch/ia64/mm/fault.c~mmap-locking-api-rename-mmap_sem-to-mmap_lock
+++ a/arch/ia64/mm/fault.c
@@ -74,8 +74,8 @@ ia64_do_page_fault (unsigned long addres
 	mask = ((((isr >> IA64_ISR_X_BIT) & 1UL) << VM_EXEC_BIT)
 		| (((isr >> IA64_ISR_W_BIT) & 1UL) << VM_WRITE_BIT));
 
-	/* mmap_sem is performance critical.... */
-	prefetchw(&mm->mmap_sem);
+	/* mmap_lock is performance critical.... */
+	prefetchw(&mm->mmap_lock);
 
 	/*
 	 * If we're in an interrupt or have no user context, we must not take the fault..
--- a/arch/x86/mm/fault.c~mmap-locking-api-rename-mmap_sem-to-mmap_lock
+++ a/arch/x86/mm/fault.c
@@ -1358,7 +1358,7 @@ dotraplinkage void
 do_page_fault(struct pt_regs *regs, unsigned long hw_error_code,
 		unsigned long address)
 {
-	prefetchw(&current->mm->mmap_sem);
+	prefetchw(&current->mm->mmap_lock);
 	trace_page_fault_entries(regs, hw_error_code, address);
 
 	if (unlikely(kmmio_fault(regs, address)))
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c~mmap-locking-api-rename-mmap_sem-to-mmap_lock
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -661,7 +661,7 @@ static int etnaviv_gem_userptr_get_pages
 	struct etnaviv_gem_userptr *userptr = &etnaviv_obj->userptr;
 	int ret, pinned = 0, npages = etnaviv_obj->base.size >> PAGE_SHIFT;
 
-	might_lock_read(&current->mm->mmap_sem);
+	might_lock_read(&current->mm->mmap_lock);
 
 	if (userptr->mm != current->mm)
 		return -EPERM;
--- a/include/linux/mmap_lock.h~mmap-locking-api-rename-mmap_sem-to-mmap_lock
+++ a/include/linux/mmap_lock.h
@@ -4,67 +4,67 @@
 #include <linux/mmdebug.h>
 
 #define MMAP_LOCK_INITIALIZER(name) \
-	.mmap_sem = __RWSEM_INITIALIZER((name).mmap_sem),
+	.mmap_lock = __RWSEM_INITIALIZER((name).mmap_lock),
 
 static inline void mmap_init_lock(struct mm_struct *mm)
 {
-	init_rwsem(&mm->mmap_sem);
+	init_rwsem(&mm->mmap_lock);
 }
 
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
-	down_write(&mm->mmap_sem);
+	down_write(&mm->mmap_lock);
 }
 
 static inline void mmap_write_lock_nested(struct mm_struct *mm, int subclass)
 {
-	down_write_nested(&mm->mmap_sem, subclass);
+	down_write_nested(&mm->mmap_lock, subclass);
 }
 
 static inline int mmap_write_lock_killable(struct mm_struct *mm)
 {
-	return down_write_killable(&mm->mmap_sem);
+	return down_write_killable(&mm->mmap_lock);
 }
 
 static inline bool mmap_write_trylock(struct mm_struct *mm)
 {
-	return down_write_trylock(&mm->mmap_sem) != 0;
+	return down_write_trylock(&mm->mmap_lock) != 0;
 }
 
 static inline void mmap_write_unlock(struct mm_struct *mm)
 {
-	up_write(&mm->mmap_sem);
+	up_write(&mm->mmap_lock);
 }
 
 static inline void mmap_write_downgrade(struct mm_struct *mm)
 {
-	downgrade_write(&mm->mmap_sem);
+	downgrade_write(&mm->mmap_lock);
 }
 
 static inline void mmap_read_lock(struct mm_struct *mm)
 {
-	down_read(&mm->mmap_sem);
+	down_read(&mm->mmap_lock);
 }
 
 static inline int mmap_read_lock_killable(struct mm_struct *mm)
 {
-	return down_read_killable(&mm->mmap_sem);
+	return down_read_killable(&mm->mmap_lock);
 }
 
 static inline bool mmap_read_trylock(struct mm_struct *mm)
 {
-	return down_read_trylock(&mm->mmap_sem) != 0;
+	return down_read_trylock(&mm->mmap_lock) != 0;
 }
 
 static inline void mmap_read_unlock(struct mm_struct *mm)
 {
-	up_read(&mm->mmap_sem);
+	up_read(&mm->mmap_lock);
 }
 
 static inline bool mmap_read_trylock_non_owner(struct mm_struct *mm)
 {
-	if (down_read_trylock(&mm->mmap_sem)) {
-		rwsem_release(&mm->mmap_sem.dep_map, _RET_IP_);
+	if (down_read_trylock(&mm->mmap_lock)) {
+		rwsem_release(&mm->mmap_lock.dep_map, _RET_IP_);
 		return true;
 	}
 	return false;
@@ -72,19 +72,19 @@ static inline bool mmap_read_trylock_non
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 {
-	up_read_non_owner(&mm->mmap_sem);
+	up_read_non_owner(&mm->mmap_lock);
 }
 
 static inline void mmap_assert_locked(struct mm_struct *mm)
 {
-	lockdep_assert_held(&mm->mmap_sem);
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
+	lockdep_assert_held(&mm->mmap_lock);
+	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
 }
 
 static inline void mmap_assert_write_locked(struct mm_struct *mm)
 {
-	lockdep_assert_held_write(&mm->mmap_sem);
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
+	lockdep_assert_held_write(&mm->mmap_lock);
+	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
 }
 
 #endif /* _LINUX_MMAP_LOCK_H */
--- a/include/linux/mm_types.h~mmap-locking-api-rename-mmap_sem-to-mmap_lock
+++ a/include/linux/mm_types.h
@@ -436,7 +436,7 @@ struct mm_struct {
 		spinlock_t page_table_lock; /* Protects page tables and some
 					     * counters
 					     */
-		struct rw_semaphore mmap_sem;
+		struct rw_semaphore mmap_lock;
 
 		struct list_head mmlist; /* List of maybe swapped mm's.	These
 					  * are globally strung together off
--- a/mm/memory.c~mmap-locking-api-rename-mmap_sem-to-mmap_lock
+++ a/mm/memory.c
@@ -4789,7 +4789,7 @@ void __might_fault(const char *file, int
 	__might_sleep(file, line, 0);
 #if defined(CONFIG_DEBUG_ATOMIC_SLEEP)
 	if (current->mm)
-		might_lock_read(&current->mm->mmap_sem);
+		might_lock_read(&current->mm->mmap_lock);
 #endif
 }
 EXPORT_SYMBOL(__might_fault);
--- a/mm/mmap.c~mmap-locking-api-rename-mmap_sem-to-mmap_lock
+++ a/mm/mmap.c
@@ -3496,7 +3496,7 @@ static void vm_lock_anon_vma(struct mm_s
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_sem);
+		down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_lock);
 		/*
 		 * We can safely modify head.next after taking the
 		 * anon_vma->root->rwsem. If some other vma in this mm shares
@@ -3526,7 +3526,7 @@ static void vm_lock_mapping(struct mm_st
 		 */
 		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
 			BUG();
-		down_write_nest_lock(&mapping->i_mmap_rwsem, &mm->mmap_sem);
+		down_write_nest_lock(&mapping->i_mmap_rwsem, &mm->mmap_lock);
 	}
 }
 
--- a/mm/mmu_notifier.c~mmap-locking-api-rename-mmap_sem-to-mmap_lock
+++ a/mm/mmu_notifier.c
@@ -983,7 +983,7 @@ int mmu_interval_notifier_insert(struct
 	struct mmu_notifier_subscriptions *subscriptions;
 	int ret;
 
-	might_lock(&mm->mmap_sem);
+	might_lock(&mm->mmap_lock);
 
 	subscriptions = smp_load_acquire(&mm->notifier_subscriptions);
 	if (!subscriptions || !subscriptions->has_itree) {
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
