Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792781039;
	b=G+subjERiIgYzAFitvipHLrkm+yxnfCGw4h+X7xdQC+b04OG3IwpAEnFNEsvW8oBCXC4
	 7fYoGhDdbVMVQzic4op9e77l+SSfD9rq23pnHgDhdZ4hbHxSjw2GHdedgnFI3GFav3278
	 QahtgqXETZX2zLr3wWu9pssPbCsh32Qee37D2lFcmSVsltgeTqhGb3GDS3HoHNJzITwW0
	 8l0/zbOIxW8+IjzYR4xubpfN3hwwzk4WJVDO9y+i+ORfm6qY3tBQOcjkhX8wipTAkwMF3
	 yr8lrK3Ju5GGquOWH4XaQHiFhoBfXzvXe7LKt8PJMcW1Dmia07v6MxogTQRJ5V1M4Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792781039;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=UjpIcNetcspxjIChCUAeJMNy+PhcQBrz1fVVaGT02NQ=;
	b=NZY+711tC/bKH+ngXQClUtyd/VOXOGKzW2rxBNTXtqT0rvhtQJro5Wop/O32NbCVdfdr
	 4eDT5PDdeVVKvu4ZQXFukx08wWNy/pDu4JCA0OrOxCVEre8GVy52mLERABAVsairWyu/U
	 0BJL6bwJeyVazWeddixvuGCYqSH5F/p6YkwOMydWcY7v0zZIsvKeuDvSka1V5v+6UwSaL
	 wVXCxKOAAtH86deWcDLaQijMI8Igt42XsQwmEn38F/rvyjlL8UsoRxA2AGfYy5QsI3xAa
	 Pkc1svo7uBUi80se0mr+if8fbPAgoaUpwI7RvMudEYEGNWcdfPqopwARrEPCDpwkOQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ft3DrrsI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9167C606A31A;
	Fri, 23 Oct 2026 18:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ft3DrrsI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F029B1F01825;
	Fri, 23 Oct 2026 18:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792781038;
	bh=UjpIcNetcspxjIChCUAeJMNy+PhcQBrz1fVVaGT02NQ=;
	h=Date:To:From:Subject;
	b=Ft3DrrsIsfyfgSBWNdZhMqrR+NKmD0DVLI2LTxOlO1oKOiM4uRicq49RYKKjRm/iU
	 W4JRNJqUJpUXfy7bTZWe5bGyQ6FvFpeVNNpVPhEhk4iVFBAUi3fEOgqsAYw/U1taQJ
	 SMzNamLiM9g2READURV6J9g+dae7vjXBCsl0suwk=
Date: Fri, 23 Oct 2026 11:43:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,kees@kernel.org,jannh@google.com,david@kernel.org,dave@stgolabs.net,ccross@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch added to mm-unstable branch
Message-Id: <20261023184357.F029B1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: do not unintentionally overwrite atomic VMA flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch

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
Subject: mm: do not unintentionally overwrite atomic VMA flags
Date: Fri, 23 Oct 2026 14:47:27 +0100

Patch series "mm: avoid losing atomic VMA flags", v1.

Since commit 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove
under VMA lock"), VMA_MAYBE_GUARD_BIT can be set atomically under the VMA
read lock.

However, a number of places wrongly assume the flags are stable under the
read lock, which can cause stale atomic VMA flags to overwrite existing
valid ones.

Additionally, one case in which VMA_SOFTDIRTY_BIT was overwritten is also
addressed.

This series addresses each of these, while keeping the logic inline with
existing conventions.

Each patch in this series is a hotfix.


This patch (of 4):

madvise, mlock and mprotect take a copy of a VMA's flags holding only the
VMA read lock, later writing it back under the write lock (in
madvise_update_vma(), mlock_fixup(), mlock_vma_pages_range() and
mprotect_fixup()).

This was done on the assumption that VMA flags cannot change with a read
lock held.

However this changed in commit 2ab7f1bbafc9 ("mm/madvise: allow guard page
install/remove under VMA lock"), which allowed VM_ATOMIC_SET_ALLOWED
flags (currently only VMA_MAYBE_GUARD_BIT) to be written concurrently under
a VMA read lock.

The actual write itself is safe as this is done under the VMA write lock
at which point no further concurrent writes can occur, however at this
point the stale flags mean that these callers can unintentionally overwrite
atomic flags incorrectly.

The consequences of this are significant - a missing VMA_MAYBE_GUARD_BIT
could result in page tables not being copied on fork (the vma_needs_copy()
check can return false) or being overwritten on file-backed THP
collapse (the file_backed_vma_is_retractable() can return true).

Resolve the issue by always taking care to retain existing atomic flags
when overwriting VMA flags, replacing the inconsistently named
vma_flags_reset_once() with vma_overwrite_flags() to do so, and always
invoking it when flags are overwritten like this.

Reads are a problem too - madvise, mlock and mprotect all compare VMA flags
without a VMA write lock held via vma_flags_same_pair().

This has more serious impact, as concurrent changes to atomic VMA flags can
cause two sets of VMA flags to be wrongly considered different.

For mprotect and madvise this causes a useless split, but mlock is impacted
more seriously as it can result in mm->locked_vm underflow.

Fix this by updating vma_flags_same_pair() to disregard
VM_ATOMIC_SET_ALLOWED VMAs - VMA equality is the same as VMA mergeability,
and atomic VMA flags are disregarded when comparing VMA flags for merge -
so this is justified semantically.

Additionally, remove the redundant vma_flags_same_mask() and the unused
vma_flags_same() as part of the change, and replace VM_ATOMIC_SET_ALLOWED
with VMA_ATOMIC_SET_ALLOWED, using the new VMA flag API.

Finally, update userland VMA tests to reflect the changes.

Link: https://lore.kernel.org/20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org
Link: https://lore.kernel.org/20261023-fix-vma-atomic-v1-1-8ff4fae1fc85@kernel.org
Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SJ Park <sj@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Colin Cross <ccross@google.com>
Cc: <stable@vger.kernel.org>
---

 include/linux/mm.h              |  166 +++++++++++++++---------------
 mm/madvise.c                    |    4 
 mm/mlock.c                      |    6 -
 mm/mprotect.c                   |    2 
 tools/testing/vma/include/dup.h |   76 ++++++++-----
 tools/testing/vma/shared.h      |   16 +-
 6 files changed, 146 insertions(+), 124 deletions(-)

--- a/include/linux/mm.h~mm-do-not-unintentionally-overwrite-atomic-vma-flags
+++ a/include/linux/mm.h
@@ -602,7 +602,7 @@ enum {
 #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
 
 /* These flags can be updated atomically via VMA/mmap read lock. */
-#define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
+#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
 
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
@@ -987,22 +987,6 @@ static inline void vm_flags_reset(struct
 	vm_flags_init(vma, flags);
 }
 
-static inline void vma_flags_reset_once(struct vm_area_struct *vma,
-					vma_flags_t *flags)
-{
-	const unsigned long word = flags->__vma_flags[0];
-
-	/* It is assumed only the first system word must be written once. */
-	vma_flags_overwrite_word_once(&vma->flags, word);
-	/* The remainder can be copied normally. */
-	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
-		unsigned long *dst = &vma->flags.__vma_flags[1];
-		const unsigned long *src = &flags->__vma_flags[1];
-
-		bitmap_copy(dst, src, NUM_VMA_FLAG_BITS - BITS_PER_LONG);
-	}
-}
-
 static inline void vm_flags_set(struct vm_area_struct *vma,
 				vm_flags_t flags)
 {
@@ -1039,48 +1023,6 @@ static inline void vm_flags_mod(struct v
 	__vm_flags_mod(vma, set, clear);
 }
 
-static __always_inline bool __vma_atomic_valid_flag(struct vm_area_struct *vma,
-		vma_flag_t bit)
-{
-	const vm_flags_t mask = BIT((__force int)bit);
-
-	/* Only specific flags are permitted */
-	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
-		return false;
-
-	return true;
-}
-
-/*
- * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
- * valid flags are allowed to do this.
- */
-static __always_inline void vma_set_atomic_flag(struct vm_area_struct *vma,
-		vma_flag_t bit)
-{
-	unsigned long *bitmap = vma->flags.__vma_flags;
-
-	vma_assert_stabilised(vma);
-	if (__vma_atomic_valid_flag(vma, bit))
-		set_bit((__force int)bit, bitmap);
-}
-
-/*
- * Test for VMA flag atomically. Requires no locks. Only specific valid flags
- * are allowed to do this.
- *
- * This is necessarily racey, so callers must ensure that serialisation is
- * achieved through some other means, or that races are permissible.
- */
-static __always_inline bool vma_test_atomic_flag(struct vm_area_struct *vma,
-		vma_flag_t bit)
-{
-	if (__vma_atomic_valid_flag(vma, bit))
-		return test_bit((__force int)bit, &vma->vm_flags);
-
-	return false;
-}
-
 /* Set an individual VMA flag in flags, non-atomically. */
 static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
 		vma_flag_t bit)
@@ -1302,35 +1244,25 @@ static __always_inline vma_flags_t vma_f
 	return dst;
 }
 
-/* Determine if flags and flags_other have precisely the same flags set. */
+/*
+ * Determine if flags and flags_other have precisely the same flags set,
+ * excluding atomic VMA flags.
+ */
 static __always_inline bool vma_flags_same_pair(const vma_flags_t *flags,
-						const vma_flags_t *flags_other)
+		const vma_flags_t *flags_other)
 {
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other->__vma_flags;
-
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
-}
+	vma_flags_t diff = vma_flags_diff_pair(flags, flags_other);
 
-/* Determine if flags and flags_other have precisely the same flags set.  */
-static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
-						vma_flags_t flags_other)
-{
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other.__vma_flags;
+	/*
+	 * Atomic VMA flags may be set concurrently under the VMA read lock, so
+	 * are disregarded for equality testing purposes.
+	 */
+	vma_flags_clear_mask(&diff, VMA_ATOMIC_SET_ALLOWED);
 
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+	return vma_flags_empty(&diff);
 }
 
 /*
- * Helper macro to determine if only the specific flags are set, e.g.:
- *
- * if (vma_flags_same(&flags, VMA_WRITE_BIT) { ... }
- */
-#define vma_flags_same(flags, ...) \
-	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
-
-/*
  * Test whether a specific flag in the VMA is set, e.g.:
  *
  * if (vma_test(vma, VMA_READ_BIT)) { ... }
@@ -1436,6 +1368,78 @@ static __always_inline void vma_clear_fl
 #define vma_clear_flags(vma, ...) \
 	vma_clear_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline bool __vma_atomic_valid_flag(struct vm_area_struct *vma,
+		vma_flag_t bit)
+{
+	const vma_flags_t mask = VMA_ATOMIC_SET_ALLOWED;
+
+	/* Is this flag allowed to be set atomically? */
+	if (WARN_ON_ONCE(!vma_flags_test(&mask, bit)))
+		return false;
+
+	return true;
+}
+
+/*
+ * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
+ * valid flags are allowed to do this.
+ */
+static __always_inline void vma_set_atomic_flag(struct vm_area_struct *vma,
+		vma_flag_t bit)
+{
+	unsigned long *bitmap = vma->flags.__vma_flags;
+
+	vma_assert_stabilised(vma);
+	if (__vma_atomic_valid_flag(vma, bit))
+		set_bit((__force int)bit, bitmap);
+}
+
+/*
+ * Test for VMA flag atomically. Requires no locks. Only specific valid flags
+ * are allowed to do this.
+ *
+ * This is necessarily racey, so callers must ensure that serialisation is
+ * achieved through some other means, or that races are permissible.
+ */
+static __always_inline bool vma_test_atomic_flag(struct vm_area_struct *vma,
+		vma_flag_t bit)
+{
+	if (__vma_atomic_valid_flag(vma, bit))
+		return test_bit((__force int)bit, &vma->vm_flags);
+
+	return false;
+}
+
+/*
+ * Overwrite the VMA's flags with new ones, preserving atomic VMA flags in the
+ * process. The write is done once and once only.
+ */
+static inline void vma_overwrite_flags(struct vm_area_struct *vma,
+		vma_flags_t new_flags)
+{
+	vma_flags_t atomic;
+
+	vma_assert_write_locked(vma);
+
+	/*
+	 * Preserve the VMA's atomic flags, which are kept stable by the VMA
+	 * write lock.
+	 */
+	atomic = vma_flags_and_mask(&vma->flags, VMA_ATOMIC_SET_ALLOWED);
+	vma_flags_clear_mask(&new_flags, VMA_ATOMIC_SET_ALLOWED);
+	vma_flags_set_mask(&new_flags, atomic);
+
+	/* It is assumed only the first system word must be written once. */
+	vma_flags_overwrite_word_once(&vma->flags, new_flags.__vma_flags[0]);
+	/* The remainder can be copied normally. */
+	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
+		unsigned long *dst = &vma->flags.__vma_flags[1];
+		const unsigned long *src = &new_flags.__vma_flags[1];
+
+		bitmap_copy(dst, src, NUM_VMA_FLAG_BITS - BITS_PER_LONG);
+	}
+}
+
 /*
  * Test whether a specific VMA flag is set in a VMA descriptor, e.g.:
  *
--- a/mm/madvise.c~mm-do-not-unintentionally-overwrite-atomic-vma-flags
+++ a/mm/madvise.c
@@ -158,7 +158,7 @@ static int madvise_update_vma(vm_flags_t
 	bool set_new_anon_name = madv_behavior->behavior == __MADV_SET_ANON_VMA_NAME;
 	VMA_ITERATOR(vmi, madv_behavior->mm, range->start);
 
-	if (vma_flags_same_mask(&vma->flags, new_vma_flags) &&
+	if (vma_flags_same_pair(&vma->flags, &new_vma_flags) &&
 	    (!set_new_anon_name ||
 	     anon_vma_name_eq(anon_vma_name(vma), anon_name)))
 		return 0;
@@ -177,7 +177,7 @@ static int madvise_update_vma(vm_flags_t
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
-	vma->flags = new_vma_flags;
+	vma_overwrite_flags(vma, new_vma_flags);
 	/*
 	 * If the vma become good for khugepaged to scan,
 	 * register it here without waiting a page fault that
--- a/mm/mlock.c~mm-do-not-unintentionally-overwrite-atomic-vma-flags
+++ a/mm/mlock.c
@@ -432,14 +432,14 @@ static void mlock_vma_pages_range(struct
 	}
 
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, &walk_flags);
+	vma_overwrite_flags(vma, walk_flags);
 
 	lru_add_drain();
 	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
 	if (lock)
-		vma_flags_reset_once(vma, new_vma_flags);
+		vma_overwrite_flags(vma, *new_vma_flags);
 }
 
 /*
@@ -494,7 +494,7 @@ static int mlock_fixup(struct vma_iterat
 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
 		/* No work to do, and mlocking twice would be wrong */
 		vma_start_write(vma);
-		vma->flags = *new_vma_flags;
+		vma_overwrite_flags(vma, *new_vma_flags);
 	} else {
 		mlock_vma_pages_range(vma, start, end, new_vma_flags);
 	}
--- a/mm/mprotect.c~mm-do-not-unintentionally-overwrite-atomic-vma-flags
+++ a/mm/mprotect.c
@@ -833,7 +833,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	 * held in write mode.
 	 */
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, &new_vma_flags);
+	vma_overwrite_flags(vma, new_vma_flags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	vma_set_page_prot(vma);
--- a/tools/testing/vma/include/dup.h~mm-do-not-unintentionally-overwrite-atomic-vma-flags
+++ a/tools/testing/vma/include/dup.h
@@ -366,6 +366,9 @@ enum {
 
 #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
 
+/* These flags can be updated atomically via VMA/mmap read lock. */
+#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+
 #define RLIMIT_STACK		3	/* max stack size */
 #define RLIMIT_MEMLOCK		8	/* max locked-in-memory address space */
 
@@ -895,22 +898,6 @@ static inline void vm_flags_reset(struct
 	vm_flags_init(vma, flags);
 }
 
-static inline void vma_flags_reset_once(struct vm_area_struct *vma,
-					vma_flags_t *flags)
-{
-	const unsigned long word = flags->__vma_flags[0];
-
-	/* It is assumed only the first system word must be written once. */
-	vma_flags_overwrite_word_once(&vma->flags, word);
-	/* The remainder can be copied normally. */
-	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
-		unsigned long *dst = &vma->flags.__vma_flags[1];
-		const unsigned long *src = &flags->__vma_flags[1];
-
-		bitmap_copy(dst, src, NUM_VMA_FLAG_BITS - BITS_PER_LONG);
-	}
-}
-
 static inline void vm_flags_set(struct vm_area_struct *vma,
 				vm_flags_t flags)
 {
@@ -1037,27 +1024,24 @@ static __always_inline vma_flags_t vma_f
 	return dst;
 }
 
+/*
+ * Determine if flags and flags_other have precisely the same flags set,
+ * excluding atomic VMA flags.
+ */
 static __always_inline bool vma_flags_same_pair(const vma_flags_t *flags,
-						const vma_flags_t *flags_other)
+		const vma_flags_t *flags_other)
 {
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other->__vma_flags;
-
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
-}
+	vma_flags_t diff = vma_flags_diff_pair(flags, flags_other);
 
-static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
-						vma_flags_t flags_other)
-{
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other.__vma_flags;
+	/*
+	 * Atomic VMA flags may be set concurrently under the VMA read lock, so
+	 * are disregarded for equality testing purposes.
+	 */
+	vma_flags_clear_mask(&diff, VMA_ATOMIC_SET_ALLOWED);
 
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+	return vma_flags_empty(&diff);
 }
 
-#define vma_flags_same(flags, ...) \
-	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
-
 static __always_inline bool vma_test(const struct vm_area_struct *vma,
 		vma_flag_t bit)
 {
@@ -1106,6 +1090,36 @@ static __always_inline void vma_clear_fl
 #define vma_clear_flags(vma, ...) \
 	vma_clear_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+/*
+ * Overwrite the VMA's flags with new ones, preserving atomic VMA flags in the
+ * process. The write is done once and once only.
+ */
+static inline void vma_overwrite_flags(struct vm_area_struct *vma,
+				       vma_flags_t new_flags)
+{
+	vma_flags_t atomic;
+
+	vma_assert_write_locked(vma);
+
+	/*
+	 * Preserve the VMA's atomic flags, which are kept stable by the VMA
+	 * write lock.
+	 */
+	atomic = vma_flags_and_mask(&vma->flags, VMA_ATOMIC_SET_ALLOWED);
+	vma_flags_clear_mask(&new_flags, VMA_ATOMIC_SET_ALLOWED);
+	vma_flags_set_mask(&new_flags, atomic);
+
+	/* It is assumed only the first system word must be written once. */
+	vma_flags_overwrite_word_once(&vma->flags, new_flags.__vma_flags[0]);
+	/* The remainder can be copied normally. */
+	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
+		unsigned long *dst = &vma->flags.__vma_flags[1];
+		const unsigned long *src = &new_flags.__vma_flags[1];
+
+		bitmap_copy(dst, src, NUM_VMA_FLAG_BITS - BITS_PER_LONG);
+	}
+}
+
 static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
 		vma_flag_t bit)
 {
--- a/tools/testing/vma/shared.h~mm-do-not-unintentionally-overwrite-atomic-vma-flags
+++ a/tools/testing/vma/shared.h
@@ -51,17 +51,21 @@
 		      __TO_SCALAR(__val1), __TO_SCALAR(__val2)); \
 	} while (0)
 
-#define ASSERT_FLAGS_SAME_MASK(_flags, _flags_other) \
-	ASSERT_TRUE(vma_flags_same_mask((_flags), (_flags_other)))
+#define ASSERT_FLAGS_SAME_MASK(_flags, _flags_other) do {		\
+	const vma_flags_t __flags_other = (_flags_other);		\
+	ASSERT_TRUE(vma_flags_same_pair((_flags), &__flags_other));	\
+	} while (0)
 
-#define ASSERT_FLAGS_NOT_SAME_MASK(_flags, _flags_other) \
-	ASSERT_FALSE(vma_flags_same_mask((_flags), (_flags_other)))
+#define ASSERT_FLAGS_NOT_SAME_MASK(_flags, _flags_other) do {		\
+	const vma_flags_t __flags_other = (_flags_other);		\
+	ASSERT_FALSE(vma_flags_same_pair((_flags), &__flags_other));	\
+	} while (0)
 
 #define ASSERT_FLAGS_SAME(_flags, ...) \
-	ASSERT_TRUE(vma_flags_same(_flags, __VA_ARGS__))
+	ASSERT_FLAGS_SAME_MASK(_flags, mk_vma_flags(__VA_ARGS__))
 
 #define ASSERT_FLAGS_NOT_SAME(_flags, ...) \
-	ASSERT_FALSE(vma_flags_same(_flags, __VA_ARGS__))
+	ASSERT_FLAGS_NOT_SAME_MASK(_flags, mk_vma_flags(__VA_ARGS__))
 
 #define ASSERT_FLAGS_EMPTY(_flags) \
 	ASSERT_TRUE(vma_flags_empty(_flags))
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
mm-mremap-populate-calculated-fields-in-vrm-state-correctly.patch
mm-mremap-correctly-uncharge-accountable-vmas-in-error-path.patch
mm-vma-avoid-broken-uffd-merge-on-mremap.patch
mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch

