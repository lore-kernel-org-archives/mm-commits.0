Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D023DDDDB;
	Thu, 15 Oct 2026 23:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792106470; cv=none; b=k9PJFXUEysYcCb7XiP8piH40yXf1nqrNotWHNSFamjRzAFkF4fciJaiZ94bapwQAZUOggVbMyBlTDGZZn43SMKUGzX1BX/k34UkLmGlwz06GpuD3D22JFtvI3NgLV4rr4bIloy8ne9bhr9DVTke6Yk3bUMQFO0vCXmF5a+YYOfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792106470; c=relaxed/simple;
	bh=VZyIGIyXm9YPpSZaNYKrMC1o2PwRt+RYYK9GXVlnvB0=;
	h=Date:To:From:Subject:Message-Id; b=nIhvttrCed0hH/0eVRZAIzgb/5moxqu72nPE8Lt40UXyhEIU4kSWSQqks4dVeJSPSbu9mIYDijXVyBv9L1vaHL1phkg/Wg8MX17k724TQSSK7XmE8CtNjxL2RKxPvOhPH9IccGtj3kpxfnZzQcDl/Xp6XzYrFlQ3HGialHbQeTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xSOcYF4s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xSOcYF4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CB01F000C4;
	Thu, 15 Oct 2026 23:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792106468;
	bh=ELkwaLopoWx3d918s5BZH2ydP8eJYB9AyGniLQYLIR0=;
	h=Date:To:From:Subject;
	b=xSOcYF4sLjbzW+t//Olx7KtIQ8pIPuxBJ3PaPpsRwlLigQXVeC/pcGf6cuGKn4Xop
	 yytJlNj1229ct5Y/p3Xy2D/WO1e5ZsVpMv5WY7thY6avhCwHA69+HP2md7/K3VScVw
	 nMvlNmDYVebgTEtVVfIN0XCv8mBNxQXpVGpBisTw=
Date: Thu, 15 Oct 2026 16:21:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rdunlap@infradead.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,david@kernel.org,corbet@lwn.net,4ncienth@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows.patch added to mm-unstable branch
Message-Id: <20261015232108.89CB01F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
Date: Thu, 15 Oct 2026 21:31:44 +0100

So far the assumption has been that mm->mm_lock_seq overflow is benign,
resulting only in readers spuriously falling back to the mmap lock, however
it turns out that this was an unsafe assumption.

If a VMA can be spuriously considered write locked that means read lock
exclusion does not take place, and thus a VMA can end up write-locked with
concurrent readers.

Since overflow only occurs every 2^31 write lock/unlock cycles, resolve the
issue by resetting every VMA's vma->vm_lock_seq each time such an overflow
occurs.

This is done in vma_end_write_all(), which is called when the mmap write
lock is released, i.e. in mmap_write_unlock() and mmap_write_downgrade().

Care must be taken, as resetting the sequence count at overflow means
changing the seqcount of VMAs which are already attached and observable.

The mm's seqcount is guaranteed to be odd when a write lock is held, and
thus any write locked VMA will have an odd seqcount assigned.

Therefore resetting to an even value prevents spurious write locks, since
these can only occur with the mmap write lock held, at which point the mmap
seqcount will be odd.

However, vma_start_read() also checks vma->vm_lock_seq == mm->mm_lock_seq,
bailing if so (indicating a write lock).

This would cause any even reset value chosen to prevent VMA read locks from
being taken - avoid this by also checking whether the VMA seqcount is odd
before bailing on the read lock.

So far, vma->vm_lock_seq has defaulted to UINT_MAX, but this has been
unnecessary since commit e5e7fb278e59 ("mm: convert mm_lock_seq to a proper
seqcount"), since this is assigned when the VMA is still detached, and
cannot be observed.

Therefore perform both reset and initialisation of vma->vm_lock_seq by
simply setting vma->vm_lock_seq to zero.

The reset, performed in reset_vma_seqcounts(), only needs to WRITE_ONCE()
the value. The stores follow the smp_wmb() in do_raw_write_seqcount_end(),
so a reader observing a reset value also observes the VMA modifications
made under the write lock.

Since all VMA write locks were just released and the mmap write lock is
still held, there are no concurrent VMA writers.

Concurrent VMA readers are unaffected. New VMA readers observe either zero,
never a write lock, or the prior seqcount, behaving as before the reset.

Since this only occurs every 2^31 write lock/unlock cycles, the time taken
to update all VMAs is considered to be acceptable.

Also update comments, documentation and VMA userland tests to reflect the
change.

Link: https://lore.kernel.org/20261015-fix-vma-lock-overflow-v1-1-01beb245d9da@kernel.org
Fixes: 5e31275cc997 ("mm: add per-VMA lock and helper functions to control it")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Daehyeon Ko <4ncienth@gmail.com>
Closes: https://lore.kernel.org/all/20261015143735.1630957-1-4ncienth@gmail.com/
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
---

 Documentation/mm/process_addrs.rst |   14 +++-
 include/linux/mm_types.h           |   12 ++--
 include/linux/mmap_lock.h          |   24 ++++++--
 mm/mmap_lock.c                     |   76 ++++++++++++++++++++++++---
 tools/testing/vma/include/dup.h    |    2 
 tools/testing/vma/shared.c         |    8 +-
 6 files changed, 111 insertions(+), 25 deletions(-)

--- a/Documentation/mm/process_addrs.rst~mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows
+++ a/Documentation/mm/process_addrs.rst
@@ -819,9 +819,17 @@ All this is achieved by the use of per-m
 used in order to reduce complexity, especially for operations which write-lock
 multiple VMAs at once.
 
-If the mm sequence count, :c:member:`!mm->mm_lock_seq` is equal to the VMA
-sequence count :c:member:`!vma->vm_lock_seq` then the VMA is write-locked. If
-they differ, then it is not.
+The mm sequence count :c:member:`!mm->mm_lock_seq` is incremented on both mmap
+write lock and unlock, so it is odd while the mmap write lock is held. If it is
+equal to the VMA sequence count :c:member:`!vma->vm_lock_seq`, and that value
+is odd, then the VMA is write-locked. If they differ, then it is not.
+
+A VMA's sequence count is not updated on unlock, so after 2^31 write lock/unlock
+cycles the mm sequence count would wrap and match stale VMA values again. To
+prevent this, when the mm sequence count wraps to zero,
+:c:func:`!vma_end_write_all` invokes :c:func:`!reset_vma_seqcounts` to reset
+every VMA's sequence count to zero, an even value which can never indicate a
+write lock.
 
 Each time the mmap write lock is released in :c:func:`!mmap_write_unlock` or
 :c:func:`!mmap_write_downgrade`, :c:func:`!vma_end_write_all` is invoked which
--- a/include/linux/mmap_lock.h~mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows
+++ a/include/linux/mmap_lock.h
@@ -154,7 +154,7 @@ static inline void vma_lock_init(struct
 #endif
 	if (reset_refcnt)
 		refcount_set(&vma->vm_refcnt, 0);
-	vma->vm_lock_seq = UINT_MAX;
+	vma->vm_lock_seq = 0;
 }
 
 /*
@@ -229,8 +229,9 @@ static inline void vma_refcount_put(stru
 
 /*
  * Use only while holding mmap read lock which guarantees that vma lock is not
- * contended (nobody can concurrently write-lock the vma). vma_start_read() should
- * not be used in such cases because it might fail due to mm_lock_seq overflow.
+ * contended (nobody can concurrently write-lock the vma). vma_start_read() need
+ * not be used in such cases, as the mmap lock already excludes VMA writers so
+ * its sequence number checks are redundant.
  * This functionality is used to obtain vma read lock and drop the mmap read lock.
  *
  * VMA can't be detached while we are holding mmap lock, therefore in practice this
@@ -252,8 +253,9 @@ static inline bool vma_start_read_locked
 
 /*
  * Use only while holding mmap read lock which guarantees that vma lock is not
- * contended (nobody can concurrently write-lock the vma). vma_start_read() should
- * not be used in such cases because it might fail due to mm_lock_seq overflow.
+ * contended (nobody can concurrently write-lock the vma). vma_start_read() need
+ * not be used in such cases, as the mmap lock already excludes VMA writers so
+ * its sequence number checks are redundant.
  * This functionality is used to obtain vma read lock and drop the mmap read lock.
  *
  * VMA can't be detached while we are holding mmap lock, therefore in practice this
@@ -552,6 +554,8 @@ static inline int __must_check mmap_writ
 	return ret;
 }
 
+void reset_vma_seqcounts(struct mm_struct *mm);
+
 /*
  * Drop all currently-held per-VMA locks.
  * This is called from the mmap_lock implementation directly before releasing
@@ -564,6 +568,16 @@ static inline void vma_end_write_all(str
 {
 	mmap_assert_write_locked(mm);
 	mm_lock_seqcount_end(mm);
+
+	/*
+	 * VMA seqcounts are not updated on unlock, so once the mm seqcount has
+	 * wrapped, any VMA still carrying a sequence number from before the
+	 * wrap would satisfy __is_vma_write_locked() when that number comes
+	 * round again, and readers would not be excluded. Reset every VMA's
+	 * seqcount so that no stale value survives the wrap.
+	 */
+	if (unlikely(!mm->mm_lock_seq.sequence))
+		reset_vma_seqcounts(mm);
 }
 
 static inline void mmap_write_unlock(struct mm_struct *mm)
--- a/include/linux/mm_types.h~mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows
+++ a/include/linux/mm_types.h
@@ -992,15 +992,19 @@ struct vm_area_struct {
 	 * Can only be written (using WRITE_ONCE()) while holding both:
 	 *  - mmap_lock (in write mode)
 	 *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_FLAG is set
+	 * The one exception is reset_vma_seqcounts(), which stores zero (an
+	 * even value, which can never indicate a write lock) under the mmap
+	 * write lock alone once the mm seqcount has wrapped, so a reader
+	 * holding only vm_refcnt may observe the value change from odd to zero.
 	 * Can be read reliably while holding one of:
 	 *  - mmap_lock (in read or write mode)
-	 *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_BIT is set or vm_refcnt > 1
+	 *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_BIT is set
 	 * Can be read unreliably (using READ_ONCE()) for pessimistic bailout
 	 * while holding nothing (except RCU to keep the VMA struct allocated).
 	 *
-	 * This sequence counter is explicitly allowed to overflow; sequence
-	 * counter reuse can only lead to occasional unnecessary use of the
-	 * slowpath.
+	 * Assigned the (odd) mm seqcount on write lock and not updated on
+	 * unlock, so a stale value would alias the mm seqcount again 2^31 write
+	 * lock/unlock cycles later. The reset described above prevents this.
 	 */
 	unsigned int vm_lock_seq;
 
--- a/mm/mmap_lock.c~mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows
+++ a/mm/mmap_lock.c
@@ -194,21 +194,37 @@ void __vma_exclude_readers_for_detach(st
 	WARN_ON_ONCE(!ves.detached);
 }
 
+/* Do the VMA, mm seqcounts indicate the VMA is write locked? */
+static bool vma_seqcount_is_write_locked(unsigned int vma_seq, unsigned int mm_seq)
+{
+	/* VMA and mm sequence numbers must match for a write lock. */
+	if (vma_seq != mm_seq)
+		return false;
+
+	/*
+	 * The VMA seqcount is always odd if locked. An even value can only be
+	 * the zero stored by reset_vma_seqcounts(), never a write lock.
+	 */
+	return vma_seq & 1;
+}
+
 /*
  * Try to read-lock a vma. The function is allowed to occasionally yield false
  * locked result to avoid performance overhead, in which case we fall back to
  * using mmap_lock. The function should never yield false unlocked result.
- * False locked result is possible if mm_lock_seq overflows or if vma gets
- * reused and attached to a different mm before we lock it.
+ * False locked result is possible if vma gets reused and attached to a
+ * different mm before we lock it.
  * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
  * detached.
  *
  * IMPORTANT: RCU lock must be held upon entering the function, but upon error
  *            IT IS RELEASED. The caller must handle this correctly.
  */
-static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
-						    struct vm_area_struct *vma)
+static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
+					     struct vm_area_struct *vma)
 {
+	unsigned int vma_seq;
+	unsigned int mm_seq;
 	struct mm_struct *other_mm;
 	int oldcnt;
 
@@ -220,7 +236,9 @@ static inline struct vm_area_struct *vma
 	 * we don't rely on for anything - the mm_lock_seq read against which we
 	 * need ordering is below.
 	 */
-	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence)) {
+	vma_seq = READ_ONCE(vma->vm_lock_seq);
+	mm_seq = READ_ONCE(mm->mm_lock_seq.sequence);
+	if (vma_seqcount_is_write_locked(vma_seq, mm_seq)) {
 		vma = NULL;
 		goto err;
 	}
@@ -246,17 +264,23 @@ static inline struct vm_area_struct *vma
 		goto err_unstable;
 
 	/*
-	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
-	 * False unlocked result is impossible because we modify and check
+	 * False unlocked result is impossible because a write lock sets
 	 * vma->vm_lock_seq under vma->vm_refcnt protection and mm->mm_lock_seq
 	 * modification invalidates all existing locks.
 	 *
+	 * The only other writer is reset_vma_seqcounts(), which stores zero
+	 * (even, so never a write lock) after the mmap write lock's seqcount
+	 * has been released and before any new write lock can be taken, hence
+	 * the READ_ONCE().
+	 *
 	 * We must use ACQUIRE semantics for the mm_lock_seq so that if we are
 	 * racing with vma_end_write_all(), we only start reading from the VMA
 	 * after it has been unlocked.
 	 * This pairs with RELEASE semantics in vma_end_write_all().
 	 */
-	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
+	vma_seq = READ_ONCE(vma->vm_lock_seq);
+	mm_seq = raw_read_seqcount(&mm->mm_lock_seq);
+	if (unlikely(vma_seqcount_is_write_locked(vma_seq, mm_seq))) {
 		vma_refcount_put(vma);
 		vma = NULL;
 		goto err;
@@ -466,6 +490,42 @@ fallback:
 	return vma;
 }
 
+/*
+ * Called with mmap write lock held after mm->mm_lock_seq just overflowed (and
+ * therefore zero), with all VMA write locks now released.
+ *
+ * The stores below follow the smp_wmb() in do_raw_write_seqcount_end(), so
+ * a reader that observes a reset value also observes this cycle's VMA
+ * modifications (ordered by the smp_rmb() in raw_read_seqcount()).
+ */
+void reset_vma_seqcounts(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, mm, 0);
+
+	mmap_assert_write_locked(mm);
+	VM_WARN_ON_ONCE(mm->mm_lock_seq.sequence);
+
+	/*
+	 * Failing to reset means stale vma->vm_lock_seq values could result in
+	 * those VMAs becoming spuriously write locked when mm->mm_lock_seq
+	 * happens to match their values.
+	 *
+	 * This is problematic, as it causes the VMA write lock to not exclude
+	 * readers, which can result in concurrent readers while a VMA write
+	 * lock is held.
+	 *
+	 * Avoid this by resetting to an even value (indicates no write lock
+	 * held).
+	 *
+	 * Readers will either observe zero (not write locked) or the previous
+	 * value, so this is safe.
+	 */
+	for_each_vma(vmi, vma)
+		WRITE_ONCE(vma->vm_lock_seq, 0);
+}
+EXPORT_SYMBOL(reset_vma_seqcounts);
+
 #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
 #include <linux/extable.h>
 
--- a/tools/testing/vma/include/dup.h~mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows
+++ a/tools/testing/vma/include/dup.h
@@ -1225,7 +1225,7 @@ static inline void vma_init(struct vm_ar
 	vma->vm_mm = mm;
 	vma->vm_ops = &vma_dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
-	vma->vm_lock_seq = UINT_MAX;
+	vma->vm_lock_seq = 0;
 }
 
 /*
--- a/tools/testing/vma/shared.c~mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows
+++ a/tools/testing/vma/shared.c
@@ -65,7 +65,7 @@ struct vm_area_struct *alloc_and_link_vm
 	 * begun. Linking to the tree will have caused this to be incremented,
 	 * which means we will get a false positive otherwise.
 	 */
-	vma->vm_lock_seq = UINT_MAX;
+	vma->vm_lock_seq = 0;
 
 	return vma;
 }
@@ -97,13 +97,13 @@ int cleanup_mm(struct mm_struct *mm, str
 
 bool vma_write_started(struct vm_area_struct *vma)
 {
-	int seq = vma->vm_lock_seq;
+	unsigned int seq = vma->vm_lock_seq;
 
 	/* We reset after each check. */
-	vma->vm_lock_seq = UINT_MAX;
+	vma->vm_lock_seq = 0;
 
 	/* The vma_start_write() stub simply increments this value. */
-	return seq > -1;
+	return seq > 0;
 }
 
 void __vma_set_dummy_anon_vma(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-assert-mmap-lock-held-use-new-flags-api-in-vm_insert_page.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_mm_managed-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-not-mm-managed.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-mm-managed-mappings-may-not-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_mm_managed.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-vma-introduce-vma_is_mm_backed.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_is_mm_backed.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch
mm-vma-avoid-spurious-write-locks-when-mm-mm_lock_seq-overflows.patch

