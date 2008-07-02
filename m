From: akpm@linux-foundation.org
Subject: + mmu-notifiers-add-mm_take_all_locks-operation.patch added to -mm tree
Date: Wed, 02 Jul 2008 12:24:21 -0700
Message-ID: <200807021924.m62JOMqO032066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757378AbYGBTZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 15:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrea@qumranet.com, a.p.zijlstra@chello.nl, aliguori@us.ibm.com, avi@qumranet.com, chrisw@redhat.com, clameter@sgi.com, dada1@cosmosbay.com, holt@sgi.com, hugh@veritas.com, izike@qumranet.com, kanojsarcar@yahoo.com, marcelo@kvack.org, npiggin@suse.de, paulmck@us.ibm.com, rdreier@cisco.com, riel@redhat.com, rusty@rustcorp.com.au, steiner@sgi.com, swise@opengridcomputing.com, torvalds@linux-foundation.org


The patch titled
     mmu-notifiers: add mm_take_all_locks() operation
has been added to the -mm tree.  Its filename is
     mmu-notifiers-add-mm_take_all_locks-operation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmu-notifiers: add mm_take_all_locks() operation
From: Andrea Arcangeli <andrea@qumranet.com>

mm_take_all_locks holds off reclaim from an entire mm_struct.  This allows
mmu notifiers to register into the mm at any time with the guarantee that
no mmu operation is in progress on the mm.

This operation locks against the VM for all pte/vma/mm related operations
that could ever happen on a certain mm.  This includes vmtruncate,
try_to_unmap, and all page faults.

The caller must take the mmap_sem in write mode before calling
mm_take_all_locks().  The caller isn't allowed to release the mmap_sem
until mm_drop_all_locks() returns.

mmap_sem in write mode is required in order to block all operations that
could modify pagetables and free pages without need of altering the vma
layout (for example populate_range() with nonlinear vmas).  It's also
needed in write mode to avoid new anon_vmas to be associated with existing
vmas.

A single task can't take more than one mm_take_all_locks() in a row or it
would deadlock.

mm_take_all_locks() and mm_drop_all_locks are expensive operations that
may have to take thousand of locks.

mm_take_all_locks() can fail if it's interrupted by signals.

When mmu_notifier_register returns, we must be sure that the driver is
notified if some task is in the middle of a vmtruncate for the 'mm' where
the mmu notifier was registered (mmu_notifier_invalidate_range_start/end
is run around the vmtruncation but mmu_notifier_register can run after
mmu_notifier_invalidate_range_start and before
mmu_notifier_invalidate_range_end).  Same problem for rmap paths.  And
we've to remove page pinning to avoid replicating the tlb_gather logic
inside KVM (and GRU doesn't work well with page pinning regardless of
needing tlb_gather), so without mm_take_all_locks when vmtruncate frees
the page, kvm would have no way to notice that it mapped into sptes a page
that is going into the freelist without a chance of any further
mmu_notifier notification.

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kanoj Sarcar <kanojsarcar@yahoo.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <aliguori@us.ibm.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Marcelo Tosatti <marcelo@kvack.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Izik Eidus <izike@qumranet.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    3 
 include/linux/pagemap.h |    1 
 include/linux/rmap.h    |    8 +
 mm/mmap.c               |  158 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 170 insertions(+)

diff -puN include/linux/mm.h~mmu-notifiers-add-mm_take_all_locks-operation include/linux/mm.h
--- a/include/linux/mm.h~mmu-notifiers-add-mm_take_all_locks-operation
+++ a/include/linux/mm.h
@@ -1071,6 +1071,9 @@ extern struct vm_area_struct *copy_vma(s
 	unsigned long addr, unsigned long len, pgoff_t pgoff);
 extern void exit_mmap(struct mm_struct *);
 
+extern int mm_take_all_locks(struct mm_struct *mm);
+extern void mm_drop_all_locks(struct mm_struct *mm);
+
 #ifdef CONFIG_PROC_FS
 /* From fs/proc/base.c. callers must _not_ hold the mm's exe_file_lock */
 extern void added_exe_file_vma(struct mm_struct *mm);
diff -puN include/linux/pagemap.h~mmu-notifiers-add-mm_take_all_locks-operation include/linux/pagemap.h
--- a/include/linux/pagemap.h~mmu-notifiers-add-mm_take_all_locks-operation
+++ a/include/linux/pagemap.h
@@ -19,6 +19,7 @@
  */
 #define	AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
 #define AS_ENOSPC	(__GFP_BITS_SHIFT + 1)	/* ENOSPC on async write */
+#define AS_MM_ALL_LOCKS	(__GFP_BITS_SHIFT + 2)	/* under mm_take_all_locks() */
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
 {
diff -puN include/linux/rmap.h~mmu-notifiers-add-mm_take_all_locks-operation include/linux/rmap.h
--- a/include/linux/rmap.h~mmu-notifiers-add-mm_take_all_locks-operation
+++ a/include/linux/rmap.h
@@ -26,6 +26,14 @@
  */
 struct anon_vma {
 	spinlock_t lock;	/* Serialize access to vma list */
+	/*
+	 * NOTE: the LSB of the head.next is set by
+	 * mm_take_all_locks() _after_ taking the above lock. So the
+	 * head must only be read/written after taking the above lock
+	 * to be sure to see a valid next pointer. The LSB bit itself
+	 * is serialized by a system wide lock only visible to
+	 * mm_take_all_locks() (mm_all_locks_mutex).
+	 */
 	struct list_head head;	/* List of private "related" vmas */
 };
 
diff -puN mm/mmap.c~mmu-notifiers-add-mm_take_all_locks-operation mm/mmap.c
--- a/mm/mmap.c~mmu-notifiers-add-mm_take_all_locks-operation
+++ a/mm/mmap.c
@@ -2267,3 +2267,161 @@ int install_special_mapping(struct mm_st
 
 	return 0;
 }
+
+static DEFINE_MUTEX(mm_all_locks_mutex);
+
+static void vm_lock_anon_vma(struct anon_vma *anon_vma)
+{
+	if (!test_bit(0, (unsigned long *) &anon_vma->head.next)) {
+		/*
+		 * The LSB of head.next can't change from under us
+		 * because we hold the mm_all_locks_mutex.
+		 */
+		spin_lock(&anon_vma->lock);
+		/*
+		 * We can safely modify head.next after taking the
+		 * anon_vma->lock. If some other vma in this mm shares
+		 * the same anon_vma we won't take it again.
+		 *
+		 * No need of atomic instructions here, head.next
+		 * can't change from under us thanks to the
+		 * anon_vma->lock.
+		 */
+		if (__test_and_set_bit(0, (unsigned long *)
+				       &anon_vma->head.next))
+			BUG();
+	}
+}
+
+static void vm_lock_mapping(struct address_space *mapping)
+{
+	if (!test_bit(AS_MM_ALL_LOCKS, &mapping->flags)) {
+		/*
+		 * AS_MM_ALL_LOCKS can't change from under us because
+		 * we hold the mm_all_locks_mutex.
+		 *
+		 * Operations on ->flags have to be atomic because
+		 * even if AS_MM_ALL_LOCKS is stable thanks to the
+		 * mm_all_locks_mutex, there may be other cpus
+		 * changing other bitflags in parallel to us.
+		 */
+		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
+			BUG();
+		spin_lock(&mapping->i_mmap_lock);
+	}
+}
+
+/*
+ * This operation locks against the VM for all pte/vma/mm related
+ * operations that could ever happen on a certain mm. This includes
+ * vmtruncate, try_to_unmap, and all page faults.
+ *
+ * The caller must take the mmap_sem in write mode before calling
+ * mm_take_all_locks(). The caller isn't allowed to release the
+ * mmap_sem until mm_drop_all_locks() returns.
+ *
+ * mmap_sem in write mode is required in order to block all operations
+ * that could modify pagetables and free pages without need of
+ * altering the vma layout (for example populate_range() with
+ * nonlinear vmas). It's also needed in write mode to avoid new
+ * anon_vmas to be associated with existing vmas.
+ *
+ * A single task can't take more than one mm_take_all_locks() in a row
+ * or it would deadlock.
+ *
+ * The LSB in anon_vma->head.next and the AS_MM_ALL_LOCKS bitflag in
+ * mapping->flags avoid to take the same lock twice, if more than one
+ * vma in this mm is backed by the same anon_vma or address_space.
+ *
+ * We can take all the locks in random order because the VM code
+ * taking i_mmap_lock or anon_vma->lock outside the mmap_sem never
+ * takes more than one of them in a row. Secondly we're protected
+ * against a concurrent mm_take_all_locks() by the mm_all_locks_mutex.
+ *
+ * mm_take_all_locks() and mm_drop_all_locks are expensive operations
+ * that may have to take thousand of locks.
+ *
+ * mm_take_all_locks() can fail if it's interrupted by signals.
+ */
+int mm_take_all_locks(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+	int ret = -EINTR;
+
+	BUG_ON(down_read_trylock(&mm->mmap_sem));
+
+	mutex_lock(&mm_all_locks_mutex);
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (signal_pending(current))
+			goto out_unlock;
+                if (vma->anon_vma)
+                        vm_lock_anon_vma(vma->anon_vma);
+                if (vma->vm_file && vma->vm_file->f_mapping)
+                        vm_lock_mapping(vma->vm_file->f_mapping);
+	}
+	ret = 0;
+
+out_unlock:
+	if (ret)
+		mm_drop_all_locks(mm);
+
+	return ret;
+}
+
+static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
+{
+	if (test_bit(0, (unsigned long *) &anon_vma->head.next)) {
+		/*
+		 * The LSB of head.next can't change to 0 from under
+		 * us because we hold the mm_all_locks_mutex.
+		 *
+		 * We must however clear the bitflag before unlocking
+		 * the vma so the users using the anon_vma->head will
+		 * never see our bitflag.
+		 *
+		 * No need of atomic instructions here, head.next
+		 * can't change from under us until we release the
+		 * anon_vma->lock.
+		 */
+		if (!__test_and_clear_bit(0, (unsigned long *)
+					  &anon_vma->head.next))
+			BUG();
+		spin_unlock(&anon_vma->lock);
+	}
+}
+
+static void vm_unlock_mapping(struct address_space *mapping)
+{
+	if (test_bit(AS_MM_ALL_LOCKS, &mapping->flags)) {
+		/*
+		 * AS_MM_ALL_LOCKS can't change to 0 from under us
+		 * because we hold the mm_all_locks_mutex.
+		 */
+		spin_unlock(&mapping->i_mmap_lock);
+		if (!test_and_clear_bit(AS_MM_ALL_LOCKS,
+					&mapping->flags))
+			BUG();
+	}
+}
+
+/*
+ * The mmap_sem cannot be released by the caller until
+ * mm_drop_all_locks() returns.
+ */
+void mm_drop_all_locks(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+
+	BUG_ON(down_read_trylock(&mm->mmap_sem));
+	BUG_ON(!mutex_is_locked(&mm_all_locks_mutex));
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (vma->anon_vma)
+			vm_unlock_anon_vma(vma->anon_vma);
+		if (vma->vm_file && vma->vm_file->f_mapping)
+			vm_unlock_mapping(vma->vm_file->f_mapping);
+	}
+
+	mutex_unlock(&mm_all_locks_mutex);
+}
_

Patches currently in -mm which might be from andrea@qumranet.com are

linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch

