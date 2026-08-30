Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6763329B77E
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 01:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788055096; cv=none; b=WFeZR/M6fmMWh4izoPSJOauQkKJZFx1C+NJKG/hzn9mxMbo2Yl9oKZ34X+sPCCa/dpaiu8EArjfr2pIKsUPGexnWsB21tW4nif2BodKNS8Db3OmR5gw0hqf1ZCg6hdfzgM7hRKHrIIOK0jcJnn/tRgpsjOlca1+r/fGBlykur1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788055096; c=relaxed/simple;
	bh=Z0cC0Y199qsV8NkFYTVMlqB0m/hVyF6mAv80cjT2VhA=;
	h=Date:To:From:Subject:Message-Id; b=FjlSonZnnr0DK4M27Ywd/0t1W3yIA38ch5k46hjieS32cAYb1zoaVQ7mDM8YZVcnOBy5GMURF4ybjpl3OfgVft13BnaKf6O45sCFlxW87ZGu0Uq1ma0kH89Z3HWab+a5x9cW4tvHNGODiz+EqaTbLoFbrP4VGzugQs9TH31B5+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tMU1Klo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tMU1Klo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C331F000E9;
	Sun, 30 Aug 2026 01:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788055094;
	bh=XOW1p3RPJ+v+T8XtjZc9W+87wSk7FWTG/VjFQKbsPYA=;
	h=Date:To:From:Subject;
	b=tMU1Klo2mITuO+NMknDbqMrXwNfWdDacd/vEuXqfVAqAMXk0ujOgjGfeAH6xt6O0U
	 dmfsnFWDQtTzp1rJGYxs1x8eB6etMNlakIYR+RF+ZMDUFAsfuNTIPt2+B78T3P3V6J
	 4WzCxmeVUKMsy9ZZ6fWx/eXwx9F0w5Go/WyzPmcw=
Date: Sat, 29 Aug 2026 18:58:13 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,ljs@kernel.org,Liam.Howlett@oracle.com,gregkh@linuxfoundation.org,dsahern@kernel.org,davem@davemloft.net,cmllamas@google.com,christian@brauner.io,arve@android.com,aliceryhl@google.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers.patch added to mm-new branch
Message-Id: <20260830015813.F1C331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add RCU-based VMA lookup helper that waits for writers
has been added to the -mm mm-new branch.  Its filename is
     mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: add RCU-based VMA lookup helper that waits for writers
Date: Thu, 13 Aug 2026 12:34:31 -0700

There are basically two parallel ways to look up a VMA: the traditional
way, which is protected by mmap_read_lock, and the RCU-based per-VMA lock
way which is based on RCU and refcounts.  However, per-VMA locks will fail
if the lock is help by a writer and therefore never waits.  In a number of
places we need to wait for the lock and it's done by falling back to
mmap_read_lock, locking the VMA and releasing the mmap_lock once VMA is
locked.

Add vma_start_read_unlocked() - a variant of the RCU-based lookup that
waits for writers.  This is basically the same as the existing RCU-based
lookup, but on a failure to lock it temporarily takes mmap_lock for read
and waits for writers to finish before locking the VMA, dropping the
mmap_read_lock and returning the locked VMA.  This has some advantages:

 1. Callers do not need to have a fallback path for when they
    collide with writers.
 2. Its fast path does not require taking mmap_lock for read.

Basically, when applied correctly, this approach results in faster *and*
simpler code.

While at it, fix the comments for vma_start_read_locked(),
vma_start_read_locked_nested(), and uffd_lock_vma().

Link: https://lore.kernel.org/20260813193433.3318288-4-surenb@google.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   19 +++++++++++++++----
 mm/mmap_lock.c            |   35 +++++++++++++++++++++++++++++++++++
 mm/userfaultfd.c          |    6 ++++--
 3 files changed, 54 insertions(+), 6 deletions(-)

--- a/include/linux/mmap_lock.h~mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers
+++ a/include/linux/mmap_lock.h
@@ -228,10 +228,14 @@ static inline void vma_refcount_put(stru
 }
 
 /*
- * Use only while holding mmap read lock which guarantees that locking will not
- * fail (nobody can concurrently write-lock the vma). vma_start_read() should
+ * Use only while holding mmap read lock which guarantees that vma lock is not
+ * contended (nobody can concurrently write-lock the vma). vma_start_read() should
  * not be used in such cases because it might fail due to mm_lock_seq overflow.
  * This functionality is used to obtain vma read lock and drop the mmap read lock.
+ *
+ * VMA can't be detached while we are holding mmap lock, therefore in practice this
+ * function can fail only when there are so many readers that vm_refcnt overflows.
+ * The failure case is very unlikely and is already annotated as such internally.
  */
 static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int subclass)
 {
@@ -247,16 +251,23 @@ static inline bool vma_start_read_locked
 }
 
 /*
- * Use only while holding mmap read lock which guarantees that locking will not
- * fail (nobody can concurrently write-lock the vma). vma_start_read() should
+ * Use only while holding mmap read lock which guarantees that vma lock is not
+ * contended (nobody can concurrently write-lock the vma). vma_start_read() should
  * not be used in such cases because it might fail due to mm_lock_seq overflow.
  * This functionality is used to obtain vma read lock and drop the mmap read lock.
+ *
+ * VMA can't be detached while we are holding mmap lock, therefore in practice this
+ * function can fail only when there are so many readers that vm_refcnt overflows.
+ * The failure case is very unlikely and is already annotated as such internally.
  */
 static inline bool vma_start_read_locked(struct vm_area_struct *vma)
 {
 	return vma_start_read_locked_nested(vma, 0);
 }
 
+struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
+					       unsigned long address);
+
 static inline void vma_end_read(struct vm_area_struct *vma)
 {
 	vma_refcount_put(vma);
--- a/mm/mmap_lock.c~mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers
+++ a/mm/mmap_lock.c
@@ -340,6 +340,41 @@ inval:
 	return NULL;
 }
 
+/**
+ * vma_start_read_unlocked() - Find the VMA covering 'address' and read-lock it.
+ * @mm: the mm_struct of the address space to search
+ * @address: address that the vma should contain
+ *
+ * The fast path does not take mmap_lock. Waits for writers to finish if the
+ * VMA is being modified by taking mmap_lock.
+ * Use when mmap_lock is not held, otherwise use vma_start_read_locked().
+ * Nothing prevents VMAs being unmapped/mapped before or after the VMA is
+ * looked up, if a stronger guarantee is required, take an mmap_lock.
+ *
+ * Return: If a VMA exists which spans @address, return that VMA, read-locked.
+ * If no VMA is mapped there or, very unlikely, a reference count overflow
+ * occurred, return NULL.
+ */
+struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
+					       unsigned long address)
+{
+	struct vm_area_struct *vma;
+
+	/* Fast path: return stable VMA covering 'address': */
+	vma = lock_vma_under_rcu(mm, address);
+	if (vma)
+		return vma;
+
+	/* Slow path: preclude VMA writers by temporarily getting mmap read lock. */
+	mmap_read_lock(mm);
+	vma = vma_lookup(mm, address);
+	if (vma && !vma_start_read_locked(vma))
+		vma = NULL;
+	mmap_read_unlock(mm);
+
+	return vma;
+}
+
 static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm,
 							    struct vma_iterator *vmi,
 							    unsigned long from_addr)
--- a/mm/userfaultfd.c~mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers
+++ a/mm/userfaultfd.c
@@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prep
  *
  * Should be called without holding mmap_lock.
  *
- * Return: A locked vma containing @address, -ENOENT if no vma is found, or
- * -ENOMEM if anon_vma couldn't be allocated.
+ * Return: A locked vma containing @address, -ENOENT if no vma is found,
+ * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma refcount
+ * overflow happened due to high number of readers and the caller should
+ * retry later.
  */
 static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
 				       unsigned long address)
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-make-per-vma-locks-available-universally.patch
binder-make-shrinker-rely-solely-on-per-vma-lock.patch
mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers.patch
binder-remove-mmap_lock-fallback.patch
tcp-remove-mmap_lock-fallback-path.patch

