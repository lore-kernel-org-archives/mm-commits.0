Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A0A4315F
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 22:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768860981; cv=none; b=XtvTSeOJ5g5qqMSNfMpRw189prdezLMSzsIlF1YOhL27RHf/j1NGEKbJLKwLcy7f+Y6RhAuh343YBZ75tZPZO6nFXZlRwp6RWco3vmf/YHD90Evv6bwmsvQMS/UTyTgUNgOM/hxIVoTKQFEWIi1sgYur4legDPaFxT44i1aeeuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768860981; c=relaxed/simple;
	bh=wIkx2Ytvf9TUiMkepNCWD7LOkTd7f7XmjsGS3Mn1U1w=;
	h=Date:To:From:Subject:Message-Id; b=lFcR3mFgIkbJm8C3+G3ba7wsv30nIpLGlLjt1xgnqSdNUe8IJOmbgPlteKJrVecQ5XE0dugoHpsNCg74cJzAcdO5AJQwLlJTame/neArLxGhBapXuP5bERdLN+QMXum8yxF35Gs99YJerMz226PP+etUupejtJNUfTzMLT+lul0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eN/dkVND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eN/dkVND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7E6C116C6;
	Mon, 19 Jan 2026 22:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768860981;
	bh=wIkx2Ytvf9TUiMkepNCWD7LOkTd7f7XmjsGS3Mn1U1w=;
	h=Date:To:From:Subject:From;
	b=eN/dkVNDJvMZnzqJKwJQumAE5U7yxQtTPfrQHZXi/o3JY9MDMexmCMubixnpSNA/z
	 aj3Y03ZVE8Eo5mtYzcSLwGAX+2FYdl7pdNuazbKpM16ZcVc0g7kQZU01p2+6fhnP7Z
	 jOmXW9poYEM3aZ60Gze+J9GXmuTSEL6MsitKb+OQ=
Date: Mon, 19 Jan 2026 14:16:20 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,boqun.feng@gmail.com,bigeasy@linutronix.de,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-vma_assert_stabilised.patch added to mm-new branch
Message-Id: <20260119221621.0B7E6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add vma_assert_stabilised()
has been added to the -mm mm-new branch.  Its filename is
     mm-add-vma_assert_stabilised.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-vma_assert_stabilised.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: add vma_assert_stabilised()
Date: Mon, 19 Jan 2026 20:59:40 +0000

Patch series "add and use vma_assert_stabilised() helper", v2.

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

We also add vma_is_read_locked() and update vma_assert_locked() to perform
lockdep tracking for VMA read locks.

We also add extensive comments to describe what we're doing.

There's some tricky stuff around mmap locking and stabilisation races that
we have to be careful of that I describe in the patch introducing
vma_assert_stabilised().

This change also lays the foundation for future series to add this assert
in further places where we wish to make it clear that we rely upon a
stabilised VMA.

The motivation for this change was precisely this.


This patch (of 2):

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us.  This will be the case if EITHER the VMA lock or
the mmap lock is held.

In order to do so, we introduce a new assert vma_assert_stablised() - this
will make a lockdep assert if lockdep is enabled AND the VMA is
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
risk a false positive.

We add vma_assert_read_locked() for this case.

There are a couple places in the kernel where we already do this
stabliisation check - the anon_vma_name() helper in mm/madvise.c and
vma_flag_set_atomic() in include/linux/mm.h, which we update to use
vma_assert_stabilised().

This change abstracts these into vma_assert_stabilised(), uses lockdep if
possible, and avoids a duplicate check of whether the mmap lock is held.

This is also self-documenting and lays the foundations for further VMA
stability checks in the code.

Link: https://lkml.kernel.org/r/cover.1768855783.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/45f8b4cd77be75b095b474570487650ae728be0f.1768855783.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h        |    4 --
 include/linux/mmap_lock.h |   56 ++++++++++++++++++++++++++++++++++++
 mm/madvise.c              |    4 --
 3 files changed, 58 insertions(+), 6 deletions(-)

--- a/include/linux/mmap_lock.h~mm-add-vma_assert_stabilised
+++ a/include/linux/mmap_lock.h
@@ -277,6 +277,56 @@ static inline void vma_assert_locked(str
 		vma_assert_write_locked(vma);
 }
 
+/**
+ * vma_assert_read_locked() - Asserts that @vma is specifically read locked.
+ * @vma: The VMA we assert.
+ */
+static inline void vma_assert_read_locked(struct vm_area_struct *vma)
+{
+	lockdep_assert(lock_is_held(&vma->vmlock_dep_map));
+	VM_BUG_ON_VMA(!vma_is_read_locked(vma), vma);
+}
+
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
+	 * We have to be careful about VMA read locks and concurrent mmap locks
+	 * by other threads. If we were to assert we own an mmap lock when in
+	 * fact it is another thread's, or if we were to race with it unlocking
+	 * when asserting an mmap lock, we will fail incorrectly.
+	 *
+	 * If we have lockdep, we can treat OUR owning the mmap lock as
+	 * sufficient stabilisation.
+	 *
+	 * If not, this is an approximation and we simply assume the same,
+	 * though sometimes we might be wrong due to races.
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
+	 * OK we must hold a VMA read lock, since a write lock requires mmap
+	 * lock.
+	 */
+	vma_assert_read_locked(vma);
+}
+
 static inline bool vma_is_attached(struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
@@ -353,6 +403,12 @@ static inline struct vm_area_struct *loc
 	return NULL;
 }
 
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/* If no VMA locks, then either mmap lock suffices to stabilise. */
+	mmap_assert_locked(vma->vm_mm);
+}
+
 static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
 	mmap_assert_locked(vma->vm_mm);
--- a/include/linux/mm.h~mm-add-vma_assert_stabilised
+++ a/include/linux/mm.h
@@ -1008,9 +1008,7 @@ static inline void vma_flag_set_atomic(s
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);
 
-	/* mmap read lock/VMA read lock must be held. */
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
+	vma_assert_stabilised(vma);
 
 	if (__vma_flag_atomic_valid(vma, bit))
 		set_bit((__force int)bit, bitmap);
--- a/mm/madvise.c~mm-add-vma_assert_stabilised
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

mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
selftests-mm-remove-virtual_address_range-test.patch
mm-vma-use-lockdep-where-we-can-reduce-duplication.patch
mm-add-vma_assert_stabilised.patch

