Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB0C38B7CC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898355; cv=none; b=QbFsNdqxvJ8gMBwZ5Y/I6xeIJzV9HbHp0Mkz2fjCcSclYnAVD0jYQqdM6hJ655UJqxzQiXqJv6eJfgwwX+EBQa4IKLvdyx1MFfQZVD8Mt2GRssF+qPmmkMiqhGwiWaNycbkPS0j7+QEf4OHgHj+W3sbUhrgAvhuCX3A0Jc689EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898355; c=relaxed/simple;
	bh=pff3DIoK/vuD/gfVM3E0wjHaAjXS/SW/FpMCGGDuZB4=;
	h=Date:To:From:Subject:Message-Id; b=eZyoAvG4/nA3jf4pYg74Ua5TSNFt0jNGSnJxcGFc0P/reN1EVqxSKHgGd6WST8o3TpguJjxQbteG2DYtOuuPdNr3BBHwP6OJ9Jg9hy/tTBKxJ3JqEEaxnp71Exz4TilGLM7A3AFeRDsuDUnZDevg7YVS5c+Ah7kAdlIT/Rwd2GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uFL6pTm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uFL6pTm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A563C4CEF1;
	Sat, 31 Jan 2026 22:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898355;
	bh=pff3DIoK/vuD/gfVM3E0wjHaAjXS/SW/FpMCGGDuZB4=;
	h=Date:To:From:Subject:From;
	b=uFL6pTm49fCsELVNThghfNBnhsYZEr3208Qu8emp88iV6nA5ToAACh4OSnAyqnmEa
	 G9NyiZ3gu0GsF6jcJBUrxlnM8vrg48+H6paRQ2O9HyFz42uDhV33bolkCqzOHidhFC
	 TZBk6h5KIRRLo3xazTPwdLtf/++rZFh1CBIGaapw=
Date: Sat, 31 Jan 2026 14:25:54 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,Liam.Howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag.patch removed from -mm tree
Message-Id: <20260131222555.4A563C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: rename VMA_LOCK_OFFSET to VM_REFCNT_EXCLUDE_READERS_FLAG
has been removed from the -mm tree.  Its filename was
     mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: rename VMA_LOCK_OFFSET to VM_REFCNT_EXCLUDE_READERS_FLAG
Date: Fri, 23 Jan 2026 20:12:11 +0000

Patch series "mm: add and use vma_assert_stabilised() helper", v4.

This series first introduces a series of refactorings, intended to
significantly improve readability and abstraction of the code.

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us.  This will be the case if EITHER the VMA lock or
the mmap lock is held.

We already open-code this in two places - anon_vma_name() in mm/madvise.c
and vma_flag_set_atomic() in include/linux/mm.h.

This series adds vma_assert_stablised() which abstract this can be used in
these callsites instead.

This implementation uses lockdep where possible - that is VMA read locks -
which correctly track read lock acquisition/release via:

vma_start_read() ->
rwsem_acquire_read()

vma_start_read_locked() ->
vma_start_read_locked_nested() ->
rwsem_acquire_read()

And:

vma_end_read() ->
vma_refcount_put() ->
rwsem_release()

We don't track the VMA locks using lockdep for VMA write locks, however
these are predicated upon mmap write locks whose lockdep state we do
track, and additionally vma_assert_stabillised() asserts this check if VMA
read lock is not held, so we get lockdep coverage in this case also.

We also add extensive comments to describe what we're doing.

There's some tricky stuff around mmap locking and stabilisation races that
we have to be careful of that I describe in the patch introducing
vma_assert_stabilised().

This change also lays the foundation for future series to add this assert
in further places where we wish to make it clear that we rely upon a
stabilised VMA.

The motivation for this change was precisely this.


This patch (of 10):

The VMA_LOCK_OFFSET value encodes a flag which vma->vm_refcnt is set to in
order to indicate that a VMA is in the process of having VMA read-locks
excluded in __vma_enter_locked() (that is, first checking if there are any
VMA read locks held, and if there are, waiting on them to be released).

This happens when a VMA write lock is being established, or a VMA is being
marked detached and discovers that the VMA reference count is elevated due
to read-locks temporarily elevating the reference count only to discover a
VMA write lock is in place.

The naming does not convey any of this, so rename VMA_LOCK_OFFSET to
VM_REFCNT_EXCLUDE_READERS_FLAG (with a sensible new prefix to
differentiate from the newly introduced VMA_*_BIT flags).

Also rename VMA_REF_LIMIT to VM_REFCNT_LIMIT to make this consistent also.

Update comments to reflect this.

No functional change intended.

Link: https://lkml.kernel.org/r/817bd763e5fe35f23e01347996f9007e6eb88460.1769198904.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h  |   17 +++++++++++++----
 include/linux/mmap_lock.h |   14 ++++++++------
 mm/mmap_lock.c            |   17 ++++++++++-------
 3 files changed, 31 insertions(+), 17 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag
+++ a/include/linux/mmap_lock.h
@@ -125,12 +125,14 @@ static inline void vma_lock_init(struct
 static inline bool is_vma_writer_only(int refcnt)
 {
 	/*
-	 * With a writer and no readers, refcnt is VMA_LOCK_OFFSET if the vma
-	 * is detached and (VMA_LOCK_OFFSET + 1) if it is attached. Waiting on
-	 * a detached vma happens only in vma_mark_detached() and is a rare
-	 * case, therefore most of the time there will be no unnecessary wakeup.
+	 * With a writer and no readers, refcnt is VM_REFCNT_EXCLUDE_READERS_FLAG
+	 * if the vma is detached and (VM_REFCNT_EXCLUDE_READERS_FLAG + 1) if it is
+	 * attached. Waiting on a detached vma happens only in
+	 * vma_mark_detached() and is a rare case, therefore most of the time
+	 * there will be no unnecessary wakeup.
 	 */
-	return (refcnt & VMA_LOCK_OFFSET) && refcnt <= VMA_LOCK_OFFSET + 1;
+	return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
+		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
 }
 
 static inline void vma_refcount_put(struct vm_area_struct *vma)
@@ -159,7 +161,7 @@ static inline bool vma_start_read_locked
 
 	mmap_assert_locked(vma->vm_mm);
 	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
-							      VMA_REF_LIMIT)))
+							      VM_REFCNT_LIMIT)))
 		return false;
 
 	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
--- a/include/linux/mm_types.h~mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag
+++ a/include/linux/mm_types.h
@@ -752,8 +752,17 @@ static inline struct anon_vma_name *anon
 }
 #endif
 
-#define VMA_LOCK_OFFSET	0x40000000
-#define VMA_REF_LIMIT	(VMA_LOCK_OFFSET - 1)
+/*
+ * While __vma_enter_locked() is working to ensure are no read-locks held on a
+ * VMA (either while acquiring a VMA write lock or marking a VMA detached) we
+ * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
+ * vma_start_read() that the reference count should be left alone.
+ *
+ * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
+ */
+#define VM_REFCNT_EXCLUDE_READERS_BIT	(30)
+#define VM_REFCNT_EXCLUDE_READERS_FLAG	(1U << VM_REFCNT_EXCLUDE_READERS_BIT)
+#define VM_REFCNT_LIMIT			(VM_REFCNT_EXCLUDE_READERS_FLAG - 1)
 
 struct vma_numab_state {
 	/*
@@ -935,10 +944,10 @@ struct vm_area_struct {
 	/*
 	 * Can only be written (using WRITE_ONCE()) while holding both:
 	 *  - mmap_lock (in write mode)
-	 *  - vm_refcnt bit at VMA_LOCK_OFFSET is set
+	 *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_FLAG is set
 	 * Can be read reliably while holding one of:
 	 *  - mmap_lock (in read or write mode)
-	 *  - vm_refcnt bit at VMA_LOCK_OFFSET is set or vm_refcnt > 1
+	 *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_BIT is set or vm_refcnt > 1
 	 * Can be read unreliably (using READ_ONCE()) for pessimistic bailout
 	 * while holding nothing (except RCU to keep the VMA struct allocated).
 	 *
--- a/mm/mmap_lock.c~mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag
+++ a/mm/mmap_lock.c
@@ -54,7 +54,7 @@ static inline int __vma_enter_locked(str
 		bool detaching, int state)
 {
 	int err;
-	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
+	unsigned int tgt_refcnt = VM_REFCNT_EXCLUDE_READERS_FLAG;
 
 	mmap_assert_write_locked(vma->vm_mm);
 
@@ -66,7 +66,7 @@ static inline int __vma_enter_locked(str
 	 * If vma is detached then only vma_mark_attached() can raise the
 	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
 	 */
-	if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
+	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
 		return 0;
 
 	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
@@ -74,7 +74,7 @@ static inline int __vma_enter_locked(str
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
-		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
+		if (refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
 			/*
 			 * The wait failed, but the last reader went away
 			 * as well.  Tell the caller the VMA is detached.
@@ -92,7 +92,8 @@ static inline int __vma_enter_locked(str
 
 static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
 {
-	*detached = refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt);
+	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					  &vma->vm_refcnt);
 	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
 }
 
@@ -180,13 +181,15 @@ static inline struct vm_area_struct *vma
 	}
 
 	/*
-	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
-	 * will fail because VMA_REF_LIMIT is less than VMA_LOCK_OFFSET.
+	 * If VM_REFCNT_EXCLUDE_READERS_FLAG is set,
+	 * __refcount_inc_not_zero_limited_acquire() will fail because
+	 * VM_REFCNT_LIMIT is less than VM_REFCNT_EXCLUDE_READERS_FLAG.
+	 *
 	 * Acquire fence is required here to avoid reordering against later
 	 * vm_lock_seq check and checks inside lock_vma_under_rcu().
 	 */
 	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
-							      VMA_REF_LIMIT))) {
+							      VM_REFCNT_LIMIT))) {
 		/* return EAGAIN if vma got detached from under us */
 		vma = oldcnt ? NULL : ERR_PTR(-EAGAIN);
 		goto err;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

