Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D78A385ED3
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898380; cv=none; b=XOPn/QnUeAbm8VBhasdkBevZTxlj5P24Or607+pyFwRx59PnL8n2y1eEuoQBljmiB1Brv8tRHcuYdCzPMZhn7T6sXJETZzyjIu/uSuHprDjxGKMVeh3dFY+lIbc8UdCn6py2CoLCKfwKks3IuUwhH0Qvnd0qdLkDOqhLdi+CQ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898380; c=relaxed/simple;
	bh=YgFCwnrnJGTvR+A2JJmEmTjWWfReN1Dw+RvnI+JXYP4=;
	h=Date:To:From:Subject:Message-Id; b=iICSgrMA0RCnCwhIDrGJCmHk2rKlC9/UGnDTXAb4lx1gigtKvd+BLjFKz5mschejUDOGkak9eJebkaaBwOwVsHc5hiQy/LcLxAlGIWANaY3lyjwtqsj5o231VTdFQrqR7FIhvUkYJ61qkI5V/B2TMtiUXT/y4Z9EufKNYr7q1Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AesEG7hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AesEG7hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55908C4CEF1;
	Sat, 31 Jan 2026 22:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898380;
	bh=YgFCwnrnJGTvR+A2JJmEmTjWWfReN1Dw+RvnI+JXYP4=;
	h=Date:To:From:Subject:From;
	b=AesEG7hrTGqCSDdVuWSkvXXwBNcNQcy64auPZU+QMPGN9cOgf66/fPlLyIa07DJW1
	 rDgeATWaxhObvxQ4ZwtsjugmqLWLB7EEw1c7mwn/HxkBE2ideLEVgPi5SVRd5T++IO
	 XTGeAKFrMVidR+Rpv11UWllBaNYDRj/grX32sb9A=
Date: Sat, 31 Jan 2026 14:26:19 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-add-and-use-vma_assert_stabilised.patch removed from -mm tree
Message-Id: <20260131222620.55908C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: add and use vma_assert_stabilised()
has been removed from the -mm tree.  Its filename was
     mm-vma-add-and-use-vma_assert_stabilised.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: add and use vma_assert_stabilised()
Date: Fri, 23 Jan 2026 20:12:20 +0000

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us.  This will be the case if EITHER the VMA lock or
the mmap lock is held.

In order to do so, we introduce a new assert vma_assert_stabilised() -
this will make a lockdep assert if lockdep is enabled AND the VMA is
read-locked.

Currently lockdep tracking for VMA write locks is not implemented, so it
suffices to check in this case that we have either an mmap read or write
semaphore held.

Note that because the VMA lock uses the non-standard vmlock_dep_map naming
convention, we cannot use lockdep_assert_is_write_held() so have to open
code this ourselves via lockdep-asserting that
lock_is_held_type(&vma->vmlock_dep_map, 0).

We have to be careful here - for instance when merging a VMA, we use the
mmap write lock to stabilise the examination of adjacent VMAs which might
be simultaneously VMA read-locked whilst being faulted in.

If we were to assert VMA read lock using lockdep we would encounter an
incorrect lockdep assert.

Also, we have to be careful about asserting mmap locks are held - if we
try to address the above issue by first checking whether mmap lock is held
and if so asserting it via lockdep, we may find that we were raced by
another thread acquiring an mmap read lock simultaneously that either we
don't own (and thus can be released any time - so we are not stable) or
was indeed released since we last checked.

So to deal with these complexities we end up with either a precise (if
lockdep is enabled) or imprecise (if not) approach - in the first instance
we assert the lock is held using lockdep and thus whether we own it.

If we do own it, then the check is complete, otherwise we must check for
the VMA read lock being held (VMA write lock implies mmap write lock so
the mmap lock suffices for this).

If lockdep is not enabled we simply check if the mmap lock is held and
risk a false negative (i.e.  not asserting when we should do).

There are a couple places in the kernel where we already do this
stabliisation check - the anon_vma_name() helper in mm/madvise.c and
vma_flag_set_atomic() in include/linux/mm.h, which we update to use
vma_assert_stabilised().

This change abstracts these into vma_assert_stabilised(), uses lockdep if
possible, and avoids a duplicate check of whether the mmap lock is held.

This is also self-documenting and lays the foundations for further VMA
stability checks in the code.

The only functional change here is adding the lockdep check.

Link: https://lkml.kernel.org/r/6c9e64bb2b56ddb6f806fde9237f8a00cb3a776b.1769198904.git.lorenzo.stoakes@oracle.com
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

 include/linux/mm.h        |    5 ---
 include/linux/mmap_lock.h |   52 ++++++++++++++++++++++++++++++++++++
 mm/madvise.c              |    4 --
 3 files changed, 54 insertions(+), 7 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-add-and-use-vma_assert_stabilised
+++ a/include/linux/mmap_lock.h
@@ -374,6 +374,52 @@ static inline void vma_assert_locked(str
 	vma_assert_write_locked(vma);
 }
 
+/**
+ * vma_assert_stabilised() - assert that this VMA cannot be changed from
+ * underneath us either by having a VMA or mmap lock held.
+ * @vma: The VMA whose stability we wish to assess.
+ *
+ * If lockdep is enabled we can precisely ensure stability via either an mmap
+ * lock owned by us or a specific VMA lock.
+ *
+ * With lockdep disabled we may sometimes race with other threads acquiring the
+ * mmap read lock simultaneous with our VMA read lock.
+ */
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/*
+	 * If another thread owns an mmap lock, it may go away at any time, and
+	 * thus is no guarantee of stability.
+	 *
+	 * If lockdep is enabled we can accurately determine if an mmap lock is
+	 * held and owned by us. Otherwise we must approximate.
+	 *
+	 * It doesn't necessarily mean we are not stabilised however, as we may
+	 * hold a VMA read lock (not a write lock as this would require an owned
+	 * mmap lock).
+	 *
+	 * If (assuming lockdep is not enabled) we were to assert a VMA read
+	 * lock first we may also run into issues, as other threads can hold VMA
+	 * read locks simlutaneous to us.
+	 *
+	 * Therefore if lockdep is not enabled we risk a false negative (i.e. no
+	 * assert fired). If accurate checking is required, enable lockdep.
+	 */
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		if (lockdep_is_held(&vma->vm_mm->mmap_lock))
+			return;
+	} else {
+		if (rwsem_is_locked(&vma->vm_mm->mmap_lock))
+			return;
+	}
+
+	/*
+	 * We're not stabilised by the mmap lock, so assert that we're
+	 * stabilised by a VMA lock.
+	 */
+	vma_assert_locked(vma);
+}
+
 static inline bool vma_is_attached(struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
@@ -476,6 +522,12 @@ static inline void vma_assert_locked(str
 	mmap_assert_locked(vma->vm_mm);
 }
 
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/* If no VMA locks, then either mmap lock suffices to stabilise. */
+	mmap_assert_locked(vma->vm_mm);
+}
+
 #endif /* CONFIG_PER_VMA_LOCK */
 
 static inline void mmap_write_lock(struct mm_struct *mm)
--- a/include/linux/mm.h~mm-vma-add-and-use-vma_assert_stabilised
+++ a/include/linux/mm.h
@@ -1008,10 +1008,7 @@ static inline void vma_flag_set_atomic(s
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);
 
-	/* mmap read lock/VMA read lock must be held. */
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
-
+	vma_assert_stabilised(vma);
 	if (__vma_flag_atomic_valid(vma, bit))
 		set_bit((__force int)bit, bitmap);
 }
--- a/mm/madvise.c~mm-vma-add-and-use-vma_assert_stabilised
+++ a/mm/madvise.c
@@ -109,9 +109,7 @@ void anon_vma_name_free(struct kref *kre
 
 struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
 {
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
-
+	vma_assert_stabilised(vma);
 	return vma->anon_name;
 }
 
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

