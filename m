From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 69/93] mmap locking API: rename mmap_sem to
 mmap_lock
Date: Mon, 08 Jun 2020 21:33:47 -0700
Message-ID: <20200609043347.O2aC6ZQoF%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgFIEdu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:33:50 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com

From: Michel Lespinasse <walken@google.com>
Subject: mmap locking API: rename mmap_sem to mmap_lock

Rename the mmap_sem field to mmap_lock.  Any new uses of this lock should
now go through the new mmap locking api.  The mmap_lock is still
implemented as a rwsem, though this could change in the future.

[akpm@linux-foundation.org: fix it for mm-gup-might_lock_readmmap_sem-in-get_user_pages_fast.patch]
Link: http://lkml.kernel.org/r/20200520052908.204642-11-walken@google.com
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
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
 mm/gup.c                              |    2 -
 mm/memory.c                           |    2 -
 mm/mmap.c                             |    4 +-
 mm/mmu_notifier.c                     |    2 -
 9 files changed, 29 insertions(+), 29 deletions(-)

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
@@ -1359,7 +1359,7 @@ dotraplinkage void
 do_page_fault(struct pt_regs *regs, unsigned long hw_error_code,
 		unsigned long address)
 {
-	prefetchw(&current->mm->mmap_sem);
+	prefetchw(&current->mm->mmap_lock);
 	/*
 	 * KVM has two types of events that are, logically, interrupts, but
 	 * are unfortunately delivered using the #PF vector.  These events are
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
@@ -440,7 +440,7 @@ struct mm_struct {
 		spinlock_t page_table_lock; /* Protects page tables and some
 					     * counters
 					     */
-		struct rw_semaphore mmap_sem;
+		struct rw_semaphore mmap_lock;
 
 		struct list_head mmlist; /* List of maybe swapped mm's.	These
 					  * are globally strung together off
--- a/mm/gup.c~mmap-locking-api-rename-mmap_sem-to-mmap_lock
+++ a/mm/gup.c
@@ -2750,7 +2750,7 @@ static int internal_get_user_pages_fast(
 		return -EINVAL;
 
 	if (!(gup_flags & FOLL_FAST_ONLY))
-		might_lock_read(&current->mm->mmap_sem);
+		might_lock_read(&current->mm->mmap_lock);
 
 	start = untagged_addr(start) & PAGE_MASK;
 	addr = start;
--- a/mm/memory.c~mmap-locking-api-rename-mmap_sem-to-mmap_lock
+++ a/mm/memory.c
@@ -4804,7 +4804,7 @@ void __might_fault(const char *file, int
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
@@ -3474,7 +3474,7 @@ static void vm_lock_anon_vma(struct mm_s
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_sem);
+		down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_lock);
 		/*
 		 * We can safely modify head.next after taking the
 		 * anon_vma->root->rwsem. If some other vma in this mm shares
@@ -3504,7 +3504,7 @@ static void vm_lock_mapping(struct mm_st
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
