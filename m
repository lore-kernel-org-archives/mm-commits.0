Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCAE26ED30
	for <mm-commits@vger.kernel.org>; Fri, 21 Nov 2025 18:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751110; cv=none; b=S01MypIEFPOW2E0VA9uHFxPIBxlYTQLHcOTZGbrNKuBVGbu7kVZBO+rDB4HLFEEaP1ejRhcjPTtFvIzNS90/plbJs8vV4MEydZrCgNjvJY4+exAYzjd/ZODzlI9M57Wli756nQet8YYJwfn1P9DO0JtyHNdjGJ4McMYOQUfIFBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751110; c=relaxed/simple;
	bh=7+KfBqTBUArNkI2eiyCC6W09AW6kJEKlcWZFTuVkkCQ=;
	h=Date:To:From:Subject:Message-Id; b=jXi8tqGrXc/qSShwhYoKliS3dR/PHivuhNPN2yL54bYCmAGQaNOYxfL/+pkBGQWs5HSe1D564ENhkQnfKNZfZJ2XQkQq5HKtpqY4mq7W65MOtGPGvjmfwq3gfBjUd+WGf5ZGEe6TbnLyZAb1cGwYB/+EQf/aR9OK03iqDT8iEiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=umtsPA5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="umtsPA5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48402C4CEF1;
	Fri, 21 Nov 2025 18:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763751109;
	bh=7+KfBqTBUArNkI2eiyCC6W09AW6kJEKlcWZFTuVkkCQ=;
	h=Date:To:From:Subject:From;
	b=umtsPA5lsBYWoCrWDw2jc4VhC0zFj6dKcwaEtxI1GKLrSmJH/AuCItkyY7AS+fs67
	 dBG7+ri7Peq6pp8xuhnvKGVmNI9+qeHL4ZFD50Acn+Rn4mgdHQsJ/nUNd+V6c6Abhl
	 nf3m5mhYKJssYqCWjwauYGStJDaMqwEqVz+JVAUM=
Date: Fri, 21 Nov 2025 10:51:48 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,weixugc@google.com,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,riel@surriel.com,rakie.kim@sk.com,peterz@infradead.org,peterx@redhat.com,osalvador@suse.de,ojeda@kernel.org,nphamcs@gmail.com,npache@redhat.com,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,matthew.brost@intel.com,lkp@intel.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kees@kernel.org,kasong@tencent.com,juri.lelli@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,hannes@cmpxchg.org,gourry@gourry.net,gary@garyguo.net,dietmar.eggemann@arm.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,bsegall@google.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-vma-flags-bitmap-type.patch added to mm-unstable branch
Message-Id: <20251121185149.48402C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce VMA flags bitmap type
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-vma-flags-bitmap-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-vma-flags-bitmap-type.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: introduce VMA flags bitmap type
Date: Fri, 14 Nov 2025 13:26:11 +0000

It is useful to transition to using a bitmap for VMA flags so we can avoid
running out of flags, especially for 32-bit kernels which are constrained
to 32 flags, necessitating some features to be limited to 64-bit kernels
only.

By doing so, we remove any constraint on the number of VMA flags moving
forwards no matter the platform and can decide in future to extend beyond
64 if required.

We start by declaring an opaque types, vma_flags_t (which resembles
mm_struct flags of type mm_flags_t), setting it to precisely the same size
as vm_flags_t, and place it in union with vm_flags in the VMA declaration.

We additionally update struct vm_area_desc equivalently placing the new
opaque type in union with vm_flags.

This change therefore does not impact the size of struct vm_area_struct or
struct vm_area_desc.

In order for the change to be iterative and to avoid impacting
performance, we designate VM_xxx declared bitmap flag values as those
which must exist in the first system word of the VMA flags bitmap.

We therefore declare vma_flags_clear_all(), vma_flags_overwrite_word(),
vma_flags_overwrite_word(), vma_flags_overwrite_word_once(),
vma_flags_set_word() and vma_flags_clear_word() in order to allow us to
update the existing vm_flags_*() functions to utilise these helpers.

This is a stepping stone towards converting users to the VMA flags bitmap
and behaves precisely as before.

By doing this, we can eliminate the existing private vma->__vm_flags field
in the vma->vm_flags union and replace it with the newly introduced opaque
type vma_flags, which we call flags so we refer to the new bitmap field as
vma->flags.

We update vma_flag_[test, set]_atomic() to account for the change also.

We additionally update the VMA userland test declarations to implement the
same changes there.

Finally, we update the rust code to reference vma->vm_flags on update
rather than vma->__vm_flags which has been removed.  This is safe for now,
albeit it is implicitly performing a const cast.

Once we introduce flag helpers we can improve this more.

No functional change intended.

Link: https://lkml.kernel.org/r/195625e7d1a8ff9156cb9bb294eb128b6a4e9294.1763126447.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |   18 ++-
 include/linux/mm_types.h         |   64 ++++++++++++
 rust/kernel/mm/virt.rs           |    2 
 tools/testing/vma/vma_internal.h |  143 ++++++++++++++++++++++++-----
 4 files changed, 196 insertions(+), 31 deletions(-)

--- a/include/linux/mm.h~mm-introduce-vma-flags-bitmap-type
+++ a/include/linux/mm.h
@@ -910,7 +910,8 @@ static inline void vma_init(struct vm_ar
 static inline void vm_flags_init(struct vm_area_struct *vma,
 				 vm_flags_t flags)
 {
-	ACCESS_PRIVATE(vma, __vm_flags) = flags;
+	vma_flags_clear_all(&vma->flags);
+	vma_flags_overwrite_word(&vma->flags, flags);
 }
 
 /*
@@ -929,21 +930,26 @@ static inline void vm_flags_reset_once(s
 				       vm_flags_t flags)
 {
 	vma_assert_write_locked(vma);
-	WRITE_ONCE(ACCESS_PRIVATE(vma, __vm_flags), flags);
+	/*
+	 * The user should only be interested in avoiding reordering of
+	 * assignment to the first word.
+	 */
+	vma_flags_clear_all(&vma->flags);
+	vma_flags_overwrite_word_once(&vma->flags, flags);
 }
 
 static inline void vm_flags_set(struct vm_area_struct *vma,
 				vm_flags_t flags)
 {
 	vma_start_write(vma);
-	ACCESS_PRIVATE(vma, __vm_flags) |= flags;
+	vma_flags_set_word(&vma->flags, flags);
 }
 
 static inline void vm_flags_clear(struct vm_area_struct *vma,
 				  vm_flags_t flags)
 {
 	vma_start_write(vma);
-	ACCESS_PRIVATE(vma, __vm_flags) &= ~flags;
+	vma_flags_clear_word(&vma->flags, flags);
 }
 
 /*
@@ -986,12 +992,14 @@ static inline bool __vma_flag_atomic_val
 static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
 				       vma_flag_t bit)
 {
+	unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);
+
 	/* mmap read lock/VMA read lock must be held. */
 	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
 		vma_assert_locked(vma);
 
 	if (__vma_flag_atomic_valid(vma, bit))
-		set_bit((__force int)bit, &ACCESS_PRIVATE(vma, __vm_flags));
+		set_bit((__force int)bit, bitmap);
 }
 
 /*
--- a/include/linux/mm_types.h~mm-introduce-vma-flags-bitmap-type
+++ a/include/linux/mm_types.h
@@ -824,6 +824,15 @@ struct mmap_action {
 };
 
 /*
+ * Opaque type representing current VMA (vm_area_struct) flag state. Must be
+ * accessed via vma_flags_xxx() helper functions.
+ */
+#define NUM_VMA_FLAG_BITS BITS_PER_LONG
+typedef struct {
+	DECLARE_BITMAP(__vma_flags, NUM_VMA_FLAG_BITS);
+} __private vma_flags_t;
+
+/*
  * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
  * manipulate mutable fields which will cause those fields to be updated in the
  * resultant VMA.
@@ -840,7 +849,10 @@ struct vm_area_desc {
 	/* Mutable fields. Populated with initial state. */
 	pgoff_t pgoff;
 	struct file *vm_file;
-	vm_flags_t vm_flags;
+	union {
+		vm_flags_t vm_flags;
+		vma_flags_t vma_flags;
+	};
 	pgprot_t page_prot;
 
 	/* Write-only fields. */
@@ -885,10 +897,12 @@ struct vm_area_struct {
 	/*
 	 * Flags, see mm.h.
 	 * To modify use vm_flags_{init|reset|set|clear|mod} functions.
+	 * Preferably, use vma_flags_xxx() functions.
 	 */
 	union {
+		/* Temporary while VMA flags are being converted. */
 		const vm_flags_t vm_flags;
-		vm_flags_t __private __vm_flags;
+		vma_flags_t flags;
 	};
 
 #ifdef CONFIG_PER_VMA_LOCK
@@ -969,6 +983,52 @@ struct vm_area_struct {
 #endif
 } __randomize_layout;
 
+/* Clears all bits in the VMA flags bitmap, non-atomically. */
+static inline void vma_flags_clear_all(vma_flags_t *flags)
+{
+	bitmap_zero(ACCESS_PRIVATE(flags, __vma_flags), NUM_VMA_FLAG_BITS);
+}
+
+/*
+ * Copy value to the first system word of VMA flags, non-atomically.
+ *
+ * IMPORTANT: This does not overwrite bytes past the first system word. The
+ * caller must account for this.
+ */
+static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long value)
+{
+	*ACCESS_PRIVATE(flags, __vma_flags) = value;
+}
+
+/*
+ * Copy value to the first system word of VMA flags ONCE, non-atomically.
+ *
+ * IMPORTANT: This does not overwrite bytes past the first system word. The
+ * caller must account for this.
+ */
+static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned long value)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+
+	WRITE_ONCE(*bitmap, value);
+}
+
+/* Update the first system word of VMA flags setting bits, non-atomically. */
+static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+
+	*bitmap |= value;
+}
+
+/* Update the first system word of VMA flags clearing bits, non-atomically. */
+static inline void vma_flags_clear_word(vma_flags_t *flags, unsigned long value)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+
+	*bitmap &= ~value;
+}
+
 #ifdef CONFIG_NUMA
 #define vma_policy(vma) ((vma)->vm_policy)
 #else
--- a/rust/kernel/mm/virt.rs~mm-introduce-vma-flags-bitmap-type
+++ a/rust/kernel/mm/virt.rs
@@ -250,7 +250,7 @@ impl VmaNew {
         // SAFETY: This is not a data race: the vma is undergoing initial setup, so it's not yet
         // shared. Additionally, `VmaNew` is `!Sync`, so it cannot be used to write in parallel.
         // The caller promises that this does not set the flags to an invalid value.
-        unsafe { (*self.as_ptr()).__bindgen_anon_2.__vm_flags = flags };
+        unsafe { (*self.as_ptr()).__bindgen_anon_2.vm_flags = flags };
     }
 
     /// Set the `VM_MIXEDMAP` flag on this vma.
--- a/tools/testing/vma/vma_internal.h~mm-introduce-vma-flags-bitmap-type
+++ a/tools/testing/vma/vma_internal.h
@@ -521,6 +521,15 @@ typedef struct {
 	__private DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
 } mm_flags_t;
 
+/*
+ * Opaque type representing current VMA (vm_area_struct) flag state. Must be
+ * accessed via vma_flags_xxx() helper functions.
+ */
+#define NUM_VMA_FLAG_BITS BITS_PER_LONG
+typedef struct {
+	DECLARE_BITMAP(__vma_flags, NUM_VMA_FLAG_BITS);
+} __private vma_flags_t;
+
 struct mm_struct {
 	struct maple_tree mm_mt;
 	int map_count;			/* number of VMAs */
@@ -605,7 +614,10 @@ struct vm_area_desc {
 	/* Mutable fields. Populated with initial state. */
 	pgoff_t pgoff;
 	struct file *vm_file;
-	vm_flags_t vm_flags;
+	union {
+		vm_flags_t vm_flags;
+		vma_flags_t vma_flags;
+	};
 	pgprot_t page_prot;
 
 	/* Write-only fields. */
@@ -651,7 +663,7 @@ struct vm_area_struct {
 	 */
 	union {
 		const vm_flags_t vm_flags;
-		vm_flags_t __private __vm_flags;
+		vma_flags_t flags;
 	};
 
 #ifdef CONFIG_PER_VMA_LOCK
@@ -1365,26 +1377,6 @@ static inline bool may_expand_vm(struct
 	return true;
 }
 
-static inline void vm_flags_init(struct vm_area_struct *vma,
-				 vm_flags_t flags)
-{
-	vma->__vm_flags = flags;
-}
-
-static inline void vm_flags_set(struct vm_area_struct *vma,
-				vm_flags_t flags)
-{
-	vma_start_write(vma);
-	vma->__vm_flags |= flags;
-}
-
-static inline void vm_flags_clear(struct vm_area_struct *vma,
-				  vm_flags_t flags)
-{
-	vma_start_write(vma);
-	vma->__vm_flags &= ~flags;
-}
-
 static inline int shmem_zero_setup(struct vm_area_struct *vma)
 {
 	return 0;
@@ -1541,13 +1533,118 @@ static inline void userfaultfd_unmap_com
 {
 }
 
-# define ACCESS_PRIVATE(p, member) ((p)->member)
+#define ACCESS_PRIVATE(p, member) ((p)->member)
+
+#define bitmap_size(nbits)	(ALIGN(nbits, BITS_PER_LONG) / BITS_PER_BYTE)
+
+static __always_inline void bitmap_zero(unsigned long *dst, unsigned int nbits)
+{
+	unsigned int len = bitmap_size(nbits);
+
+	if (small_const_nbits(nbits))
+		*dst = 0;
+	else
+		memset(dst, 0, len);
+}
 
 static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
 {
 	return test_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
 }
 
+/* Clears all bits in the VMA flags bitmap, non-atomically. */
+static inline void vma_flags_clear_all(vma_flags_t *flags)
+{
+	bitmap_zero(ACCESS_PRIVATE(flags, __vma_flags), NUM_VMA_FLAG_BITS);
+}
+
+/*
+ * Copy value to the first system word of VMA flags, non-atomically.
+ *
+ * IMPORTANT: This does not overwrite bytes past the first system word. The
+ * caller must account for this.
+ */
+static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long value)
+{
+	*ACCESS_PRIVATE(flags, __vma_flags) = value;
+}
+
+/*
+ * Copy value to the first system word of VMA flags ONCE, non-atomically.
+ *
+ * IMPORTANT: This does not overwrite bytes past the first system word. The
+ * caller must account for this.
+ */
+static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned long value)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+
+	WRITE_ONCE(*bitmap, value);
+}
+
+/* Update the first system word of VMA flags setting bits, non-atomically. */
+static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+
+	*bitmap |= value;
+}
+
+/* Update the first system word of VMA flags clearing bits, non-atomically. */
+static inline void vma_flags_clear_word(vma_flags_t *flags, unsigned long value)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+
+	*bitmap &= ~value;
+}
+
+
+/* Use when VMA is not part of the VMA tree and needs no locking */
+static inline void vm_flags_init(struct vm_area_struct *vma,
+				 vm_flags_t flags)
+{
+	vma_flags_clear_all(&vma->flags);
+	vma_flags_overwrite_word(&vma->flags, flags);
+}
+
+/*
+ * Use when VMA is part of the VMA tree and modifications need coordination
+ * Note: vm_flags_reset and vm_flags_reset_once do not lock the vma and
+ * it should be locked explicitly beforehand.
+ */
+static inline void vm_flags_reset(struct vm_area_struct *vma,
+				  vm_flags_t flags)
+{
+	vma_assert_write_locked(vma);
+	vm_flags_init(vma, flags);
+}
+
+static inline void vm_flags_reset_once(struct vm_area_struct *vma,
+				       vm_flags_t flags)
+{
+	vma_assert_write_locked(vma);
+	/*
+	 * The user should only be interested in avoiding reordering of
+	 * assignment to the first word.
+	 */
+	vma_flags_clear_all(&vma->flags);
+	vma_flags_overwrite_word_once(&vma->flags, flags);
+}
+
+static inline void vm_flags_set(struct vm_area_struct *vma,
+				vm_flags_t flags)
+{
+	vma_start_write(vma);
+	vma_flags_set_word(&vma->flags, flags);
+}
+
+static inline void vm_flags_clear(struct vm_area_struct *vma,
+				  vm_flags_t flags)
+{
+	vma_start_write(vma);
+	vma_flags_clear_word(&vma->flags, flags);
+}
+
 /*
  * Denies creating a writable executable mapping or gaining executable permissions.
  *
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-introduce-vma-flags-bitmap-type.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch
mm-softdirty-add-pgtable_supports_soft_dirty-fix.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch

