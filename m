Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBB738A9C0
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898358; cv=none; b=HlUJ4Rd/lPK3zdhVSbSFk4XCRpxqZ8gx2aN/LzRtDgss/x6wpc0K5nVs9IvmIsuY/BoLskQB/3/+qyJlNDkw33m5er49pPXUtyr3HvCS9MkW4TxoFX2+m08A7dLjdctgsS7vKUBIHmNoFvrePbtoC7gDq9XsL5mwKvIArjSrZwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898358; c=relaxed/simple;
	bh=c5I/m5hpDdbLA9+6K2r74a+xwnkYXrOFnIKeQ3ZZCKA=;
	h=Date:To:From:Subject:Message-Id; b=MB92Zx4q6IT3UJnqXLGCa8giHsjEnfIUnl9I5DVCbP4lzAuylczy1tWZbzQDRPXclG8D1m8Y/GAxLZkuAvPgLacc8Hjuy2U7aLqYYjFAwcixdmbjXG32pX8YR94rAH+BIAK899fd+ZNRB6K/vpJM5tKbQJ2qR8mblWTuR0aAvxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NeYr1K1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NeYr1K1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E6BC4CEF1;
	Sat, 31 Jan 2026 22:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898358;
	bh=c5I/m5hpDdbLA9+6K2r74a+xwnkYXrOFnIKeQ3ZZCKA=;
	h=Date:To:From:Subject:From;
	b=NeYr1K1fuP07hRiJ+Le14+lXPO+OEIgd5HKZf6iOhvEMqD0h5g4XdprAQYX9TP1+a
	 dHG69u2DZJVkSYX9aRv0sAOMP5qnGA5nSN6H7cZJEWi4LWre0v/7TWqdQnLrDhHktd
	 5AB29T3ZzcjF+WZdwtUd7yUeKve5X+cNtcjvduOM=
Date: Sat, 31 Jan 2026 14:25:57 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch removed from -mm tree
Message-Id: <20260131222557.E8E6BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: document possible vma->vm_refcnt values and reference comment
has been removed from the -mm tree.  Its filename was
     mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: document possible vma->vm_refcnt values and reference comment
Date: Fri, 23 Jan 2026 20:12:12 +0000

The possible vma->vm_refcnt values are confusing and vague, explain in
detail what these can be in a comment describing the vma->vm_refcnt field
and reference this comment in various places that read/write this field.

No functional change intended.

[akpm@linux-foundation.org: fix typo, per Suren]
Link: https://lkml.kernel.org/r/d462e7678c6cc7461f94e5b26c776547d80a67e8.1769198904.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h  |   42 ++++++++++++++++++++++++++++++++++--
 include/linux/mmap_lock.h |    7 ++++++
 mm/mmap_lock.c            |    6 +++++
 3 files changed, 53 insertions(+), 2 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment
+++ a/include/linux/mmap_lock.h
@@ -130,6 +130,9 @@ static inline bool is_vma_writer_only(in
 	 * attached. Waiting on a detached vma happens only in
 	 * vma_mark_detached() and is a rare case, therefore most of the time
 	 * there will be no unnecessary wakeup.
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
 		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
@@ -249,6 +252,10 @@ static inline void vma_assert_locked(str
 {
 	unsigned int mm_lock_seq;
 
+	/*
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
+	 */
 	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
 		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
--- a/include/linux/mm_types.h~mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment
+++ a/include/linux/mm_types.h
@@ -758,7 +758,8 @@ static inline struct anon_vma_name *anon
  * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
  * vma_start_read() that the reference count should be left alone.
  *
- * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
+ * See the comment describing vm_refcnt in vm_area_struct for details as to
+ * which values the VMA reference count can be.
  */
 #define VM_REFCNT_EXCLUDE_READERS_BIT	(30)
 #define VM_REFCNT_EXCLUDE_READERS_FLAG	(1U << VM_REFCNT_EXCLUDE_READERS_BIT)
@@ -989,7 +990,44 @@ struct vm_area_struct {
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
 #ifdef CONFIG_PER_VMA_LOCK
-	/* Unstable RCU readers are allowed to read this. */
+	/*
+	 * Used to keep track of firstly, whether the VMA is attached, secondly,
+	 * if attached, how many read locks are taken, and thirdly, if the
+	 * VM_REFCNT_EXCLUDE_READERS_FLAG is set, whether any read locks held
+	 * are currently in the process of being excluded.
+	 *
+	 * This value can be equal to:
+	 *
+	 * 0 - Detached. IMPORTANT: when the refcnt is zero, readers cannot
+	 * increment it.
+	 *
+	 * 1 - Attached and either unlocked or write-locked. Write locks are
+	 * identified via __is_vma_write_locked() which checks for equality of
+	 * vma->vm_lock_seq and mm->mm_lock_seq.
+	 *
+	 * >1, < VM_REFCNT_EXCLUDE_READERS_FLAG - Read-locked or (unlikely)
+	 * write-locked with other threads having temporarily incremented the
+	 * reference count prior to determining it is write-locked and
+	 * decrementing it again.
+	 *
+	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
+	 * __vma_exit_locked() completion which will decrement the reference
+	 * count to zero. IMPORTANT - at this stage no further readers can
+	 * increment the reference count. It can only be reduced.
+	 *
+	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
+	 * an attached VMA and has yet to invoke __vma_exit_locked(), OR a
+	 * thread is detaching a VMA and is waiting on a single spurious reader
+	 * in order to decrement the reference count. IMPORTANT - as above, no
+	 * further readers can increment the reference count.
+	 *
+	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
+	 * write-locking or detaching a VMA is waiting on readers to
+	 * exit. IMPORTANT - as above, no further readers can increment the
+	 * reference count.
+	 *
+	 * NOTE: Unstable RCU readers are allowed to read this.
+	 */
 	refcount_t vm_refcnt ____cacheline_aligned_in_smp;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map vmlock_dep_map;
--- a/mm/mmap_lock.c~mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment
+++ a/mm/mmap_lock.c
@@ -65,6 +65,9 @@ static inline int __vma_enter_locked(str
 	/*
 	 * If vma is detached then only vma_mark_attached() can raise the
 	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
 		return 0;
@@ -137,6 +140,9 @@ void vma_mark_detached(struct vm_area_st
 	 * before they check vm_lock_seq, realize the vma is locked and drop
 	 * back the vm_refcnt. That is a narrow window for observing a raised
 	 * vm_refcnt.
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
 		/* Wait until vma is detached with no readers. */
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

