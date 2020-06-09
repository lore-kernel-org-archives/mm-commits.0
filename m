From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 68/93] mmap locking API: add mmap_assert_locked()
 and mmap_assert_write_locked()
Date: Mon, 08 Jun 2020 21:33:44 -0700
Message-ID: <20200609043344.m3SxCY1jL%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgFIEdr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:33:47 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com

From: Michel Lespinasse <walken@google.com>
Subject: mmap locking API: add mmap_assert_locked() and mmap_assert_write_locked()

Add new APIs to assert that mmap_sem is held.

Using this instead of rwsem_is_locked and lockdep_assert_held[_write]
makes the assertions more tolerant of future changes to the lock type.

Link: http://lkml.kernel.org/r/20200520052908.204642-10-walken@google.com
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
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

 arch/x86/events/core.c    |    2 +-
 fs/userfaultfd.c          |    6 +++---
 include/linux/mmap_lock.h |   14 ++++++++++++++
 mm/gup.c                  |    2 +-
 mm/hmm.c                  |    2 +-
 mm/memory.c               |    2 +-
 mm/mmu_notifier.c         |    6 +++---
 mm/pagewalk.c             |    6 +++---
 mm/util.c                 |    2 +-
 9 files changed, 28 insertions(+), 14 deletions(-)

--- a/arch/x86/events/core.c~mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked
+++ a/arch/x86/events/core.c
@@ -2181,7 +2181,7 @@ static void x86_pmu_event_mapped(struct
 	 * For now, this can't happen because all callers hold mmap_sem
 	 * for write.  If this changes, we'll need a different solution.
 	 */
-	lockdep_assert_held_write(&mm->mmap_sem);
+	mmap_assert_write_locked(mm);
 
 	if (atomic_inc_return(&mm->context.perf_rdpmc_allowed) == 1)
 		on_each_cpu_mask(mm_cpumask(mm), cr4_update_pce, NULL, 1);
--- a/fs/userfaultfd.c~mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked
+++ a/fs/userfaultfd.c
@@ -234,7 +234,7 @@ static inline bool userfaultfd_huge_must
 	pte_t *ptep, pte;
 	bool ret = true;
 
-	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+	mmap_assert_locked(mm);
 
 	ptep = huge_pte_offset(mm, address, vma_mmu_pagesize(vma));
 
@@ -286,7 +286,7 @@ static inline bool userfaultfd_must_wait
 	pte_t *pte;
 	bool ret = true;
 
-	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+	mmap_assert_locked(mm);
 
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
@@ -405,7 +405,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	 * Coredumping runs without mmap_sem so we can only check that
 	 * the mmap_sem is held, if PF_DUMPCORE was not set.
 	 */
-	WARN_ON_ONCE(!rwsem_is_locked(&mm->mmap_sem));
+	mmap_assert_locked(mm);
 
 	ctx = vmf->vma->vm_userfaultfd_ctx.ctx;
 	if (!ctx)
--- a/include/linux/mmap_lock.h~mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked
+++ a/include/linux/mmap_lock.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_MMAP_LOCK_H
 #define _LINUX_MMAP_LOCK_H
 
+#include <linux/mmdebug.h>
+
 #define MMAP_LOCK_INITIALIZER(name) \
 	.mmap_sem = __RWSEM_INITIALIZER((name).mmap_sem),
 
@@ -73,4 +75,16 @@ static inline void mmap_read_unlock_non_
 	up_read_non_owner(&mm->mmap_sem);
 }
 
+static inline void mmap_assert_locked(struct mm_struct *mm)
+{
+	lockdep_assert_held(&mm->mmap_sem);
+	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
+}
+
+static inline void mmap_assert_write_locked(struct mm_struct *mm)
+{
+	lockdep_assert_held_write(&mm->mmap_sem);
+	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
+}
+
 #endif /* _LINUX_MMAP_LOCK_H */
--- a/mm/gup.c~mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked
+++ a/mm/gup.c
@@ -1425,7 +1425,7 @@ long populate_vma_page_range(struct vm_a
 	VM_BUG_ON(end   & ~PAGE_MASK);
 	VM_BUG_ON_VMA(start < vma->vm_start, vma);
 	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
+	mmap_assert_locked(mm);
 
 	gup_flags = FOLL_TOUCH | FOLL_POPULATE | FOLL_MLOCK;
 	if (vma->vm_flags & VM_LOCKONFAULT)
--- a/mm/hmm.c~mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked
+++ a/mm/hmm.c
@@ -563,7 +563,7 @@ int hmm_range_fault(struct hmm_range *ra
 	struct mm_struct *mm = range->notifier->mm;
 	int ret;
 
-	lockdep_assert_held(&mm->mmap_sem);
+	mmap_assert_locked(mm);
 
 	do {
 		/* If range is no longer valid force retry. */
--- a/mm/memory.c~mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked
+++ a/mm/memory.c
@@ -1211,7 +1211,7 @@ static inline unsigned long zap_pud_rang
 		next = pud_addr_end(addr, end);
 		if (pud_trans_huge(*pud) || pud_devmap(*pud)) {
 			if (next - addr != HPAGE_PUD_SIZE) {
-				VM_BUG_ON_VMA(!rwsem_is_locked(&tlb->mm->mmap_sem), vma);
+				mmap_assert_locked(tlb->mm);
 				split_huge_pud(vma, pud, addr);
 			} else if (zap_huge_pud(tlb, vma, pud, addr))
 				goto next;
--- a/mm/mmu_notifier.c~mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked
+++ a/mm/mmu_notifier.c
@@ -609,7 +609,7 @@ int __mmu_notifier_register(struct mmu_n
 	struct mmu_notifier_subscriptions *subscriptions = NULL;
 	int ret;
 
-	lockdep_assert_held_write(&mm->mmap_sem);
+	mmap_assert_write_locked(mm);
 	BUG_ON(atomic_read(&mm->mm_users) <= 0);
 
 	if (IS_ENABLED(CONFIG_LOCKDEP)) {
@@ -761,7 +761,7 @@ struct mmu_notifier *mmu_notifier_get_lo
 	struct mmu_notifier *subscription;
 	int ret;
 
-	lockdep_assert_held_write(&mm->mmap_sem);
+	mmap_assert_write_locked(mm);
 
 	if (mm->notifier_subscriptions) {
 		subscription = find_get_mmu_notifier(mm, ops);
@@ -1006,7 +1006,7 @@ int mmu_interval_notifier_insert_locked(
 		mm->notifier_subscriptions;
 	int ret;
 
-	lockdep_assert_held_write(&mm->mmap_sem);
+	mmap_assert_write_locked(mm);
 
 	if (!subscriptions || !subscriptions->has_itree) {
 		ret = __mmu_notifier_register(NULL, mm);
--- a/mm/pagewalk.c~mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked
+++ a/mm/pagewalk.c
@@ -395,7 +395,7 @@ int walk_page_range(struct mm_struct *mm
 	if (!walk.mm)
 		return -EINVAL;
 
-	lockdep_assert_held(&walk.mm->mmap_sem);
+	mmap_assert_locked(walk.mm);
 
 	vma = find_vma(walk.mm, start);
 	do {
@@ -453,7 +453,7 @@ int walk_page_range_novma(struct mm_stru
 	if (start >= end || !walk.mm)
 		return -EINVAL;
 
-	lockdep_assert_held(&walk.mm->mmap_sem);
+	mmap_assert_locked(walk.mm);
 
 	return __walk_page_range(start, end, &walk);
 }
@@ -472,7 +472,7 @@ int walk_page_vma(struct vm_area_struct
 	if (!walk.mm)
 		return -EINVAL;
 
-	lockdep_assert_held(&walk.mm->mmap_sem);
+	mmap_assert_locked(walk.mm);
 
 	err = walk_page_test(vma->vm_start, vma->vm_end, &walk);
 	if (err > 0)
--- a/mm/util.c~mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked
+++ a/mm/util.c
@@ -437,7 +437,7 @@ int __account_locked_vm(struct mm_struct
 	unsigned long locked_vm, limit;
 	int ret = 0;
 
-	lockdep_assert_held_write(&mm->mmap_sem);
+	mmap_assert_write_locked(mm);
 
 	locked_vm = mm->locked_vm;
 	if (inc) {
_
