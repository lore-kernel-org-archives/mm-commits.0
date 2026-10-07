Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2382230566D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334269; cv=none; b=AQPACIDfBdstGp4b4cC3nYn2wYPl0lOBe07E+QHg342UOCKXTcts1T+auyBYK9P4K8lGAjuNLCIxwrkc1uyrNpjNgpDUd/xUVcx6vPkGl/Ct7tquojH0rpj0LJLEO1V1nadlzxLzE2cMMjuk2Hc9eD1OIQsYexA5jUSgLRhzcgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334269; c=relaxed/simple;
	bh=oCH2U64DEa5bC9WPe4OOOdhpl4DTChVJ53nKZbNbsuA=;
	h=Date:To:From:Subject:Message-Id; b=YuFnFj3FAb+pt06G1woc35XGPTQk3zO8C9iUFRRU6w0CrKmG3sg0dBeOpwZxBK9Lk0/kvxonQeBDNPohTV/DNvXCxP5XF902QS5OFeGJZPHP+hFY6eyhu88/xAKLtD+llfu0nwQen5gz/7ulhhucf92+VZTfPtwrD7Wb8PiAm1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tHDLK69D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tHDLK69D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2801F0089C;
	Wed,  7 Oct 2026 00:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334268;
	bh=Neiva1O3p1vUf4/Id0PXiLI8SaRLs9pcvZRCho0h9S0=;
	h=Date:To:From:Subject;
	b=tHDLK69DLasQ7Mp/EKAsfrCDjWo8T8zl34Cj7XKndT7Av9ZYQ8/4TS9vHYhd2L8v+
	 xWazslTQvTltrQtIxNtGaV5ovFN6vEWWaRtWsZoWwcFIbvY36nGotb7akDkvqAqC5w
	 aujFO7XAHpnVtlamSZGo0gVzolBf37ENl8V0z6qc=
Date: Tue, 06 Oct 2026 17:51:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,ljs@kernel.org,liam@infradead.org,gregkh@linuxfoundation.org,dsahern@kernel.org,david@kernel.org,davem@davemloft.net,cmllamas@google.com,christian@brauner.io,arve@android.com,aliceryhl@google.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers.patch removed from -mm tree
Message-Id: <20261007005107.EB2801F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add RCU-based VMA lookup helper that waits for writers
has been removed from the -mm tree.  Its filename was
     mm-add-rcu-based-vma-lookup-helper-that-waits-for-writers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: add RCU-based VMA lookup helper that waits for writers
Date: Mon, 31 Aug 2026 13:30:54 -0700

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

1. Callers do not need to have a fallback path for when they collide
with writers.

2. Its fast path does not require taking mmap_lock for read.

Basically, when applied correctly, this approach results in faster *and*
simpler code.

While at it, fix the comments for vma_start_read_locked(),
vma_start_read_locked_nested(), and uffd_lock_vma().

Link: https://lore.kernel.org/20260831203056.838265-4-surenb@google.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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


