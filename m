Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518EE7FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441711; cv=none; b=UoN7yJAQxWOByHlOfw5LecalZVMAst8lJquIqBe0Nk2ezl4SI+6YahjSnsVGol+HvBAzdCWFRKBlxd9yvoogBfg2BvlFuVSrVdyJLfmHVezfCQ5TL5qhJ9QHGgT70TP6eCSjF5BXdFWVLowYW5xxHP/Q2WMFXCnvZkpSPsmvWxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441711; c=relaxed/simple;
	bh=1/I4kgSxmoqYoum/cK0RkdQBB9ZQTXMCQD1/7QdzMRU=;
	h=Date:To:From:Subject:Message-Id; b=hbpDD3M/4kkxQdi4R9kHKNH76TB/BGPuHfNe5rwMV9MV0XidS8xaySbsDiVP6FNZdglfDueGejVaXthGrRHZPSPesVe7hBhKbI4iWIhDvBp4lmFBeIvKpq1WdwmXjO461OAp0CaJLco5NJ3F2tGXsawkH+1+yPB4RBwpDZ+Up3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F5PRSP5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F5PRSP5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D800EC113D0;
	Sat, 29 Nov 2025 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441711;
	bh=1/I4kgSxmoqYoum/cK0RkdQBB9ZQTXMCQD1/7QdzMRU=;
	h=Date:To:From:Subject:From;
	b=F5PRSP5sMRUcEE4US2/W1FAOByS97aQYaUuC/6Xjhb7+Z4hJtDbRoEtxJx1M+OKvp
	 PrXz+9+fiTooQry+FJHq5ZIrCjOakVR0r7zdP3reS3S0TrfL1jQRMNznavvIi0DbZ6
	 BcM7Ei1gzbX4q6GLFyoA/c4HAFdlO1RfMwtVtOaI=
Date: Sat, 29 Nov 2025 10:41:50 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,weixugc@google.com,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,riel@surriel.com,rakie.kim@sk.com,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,osalvador@suse.de,ojeda@kernel.org,nphamcs@gmail.com,npache@redhat.com,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,matthew.brost@intel.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kees@kernel.org,kasong@tencent.com,juri.lelli@redhat.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,hannes@cmpxchg.org,gourry@gourry.net,gary@garyguo.net,dietmar.eggemann@arm.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,bsegall@google.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-vma-flags-bitmap-type.patch removed from -mm tree
Message-Id: <20251129184150.D800EC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce VMA flags bitmap type
has been removed from the -mm tree.  Its filename was
     mm-introduce-vma-flags-bitmap-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: introduce VMA flags bitmap type
Date: Tue, 25 Nov 2025 10:01:02 +0000

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

We adapt vm_flags_reset_once() to only clear those bits above the first
system word providing write-once semantics to the first system word (which
it is presumed the caller requires - and in all current use cases this is
so).

As we currently only specify that the VMA flags bitmap size is equal to
BITS_PER_LONG number of bits, this is a noop, but is defensive in
preparation for a future change that increases this.

We additionally update the VMA userland test declarations to implement the
same changes there.

Finally, we update the rust code to reference vma->vm_flags on update
rather than vma->__vm_flags which has been removed.  This is safe for now,
albeit it is implicitly performing a const cast.

Once we introduce flag helpers we can improve this more.

No functional change intended.

Link: https://lkml.kernel.org/r/bab179d7b153ac12f221b7d65caac2759282cfe9.1764064557.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Alice Ryhl <aliceryhl@google.com>	[rust]
Cc: Alex Gaynor <alex.gaynor@gmail.com>
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
Cc: Wei Xu <weixugc@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |   24 +++-
 include/linux/mm_types.h         |   64 +++++++++++-
 rust/kernel/mm/virt.rs           |    2 
 tools/testing/vma/vma_internal.h |  150 +++++++++++++++++++++++------
 4 files changed, 202 insertions(+), 38 deletions(-)

--- a/include/linux/mm.h~mm-introduce-vma-flags-bitmap-type
+++ a/include/linux/mm.h
@@ -911,7 +911,8 @@ static inline void vm_flags_init(struct
 				 vm_flags_t flags)
 {
 	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
-	ACCESS_PRIVATE(vma, __vm_flags) = flags;
+	vma_flags_clear_all(&vma->flags);
+	vma_flags_overwrite_word(&vma->flags, flags);
 }
 
 /*
@@ -931,14 +932,25 @@ static inline void vm_flags_reset_once(s
 				       vm_flags_t flags)
 {
 	vma_assert_write_locked(vma);
-	WRITE_ONCE(ACCESS_PRIVATE(vma, __vm_flags), flags);
+	/*
+	 * If VMA flags exist beyond the first system word, also clear these. It
+	 * is assumed the write once behaviour is required only for the first
+	 * system word.
+	 */
+	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
+		unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);
+
+		bitmap_zero(&bitmap[1], NUM_VMA_FLAG_BITS - BITS_PER_LONG);
+	}
+
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
@@ -946,7 +958,7 @@ static inline void vm_flags_clear(struct
 {
 	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
 	vma_start_write(vma);
-	ACCESS_PRIVATE(vma, __vm_flags) &= ~flags;
+	vma_flags_clear_word(&vma->flags, flags);
 }
 
 /*
@@ -989,12 +1001,14 @@ static inline bool __vma_flag_atomic_val
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
@@ -849,6 +849,15 @@ struct mmap_action {
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
@@ -865,7 +874,10 @@ struct vm_area_desc {
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
@@ -910,10 +922,12 @@ struct vm_area_struct {
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
@@ -994,6 +1008,52 @@ struct vm_area_struct {
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
@@ -524,6 +524,15 @@ typedef struct {
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
@@ -608,7 +617,10 @@ struct vm_area_desc {
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
@@ -654,7 +666,7 @@ struct vm_area_struct {
 	 */
 	union {
 		const vm_flags_t vm_flags;
-		vm_flags_t __private __vm_flags;
+		vma_flags_t flags;
 	};
 
 #ifdef CONFIG_PER_VMA_LOCK
@@ -1368,26 +1380,6 @@ static inline bool may_expand_vm(struct
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
@@ -1544,13 +1536,118 @@ static inline void userfaultfd_unmap_com
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
@@ -1763,11 +1860,4 @@ static inline int do_munmap(struct mm_st
 	return 0;
 }
 
-static inline void vm_flags_reset(struct vm_area_struct *vma, vm_flags_t flags)
-{
-	vm_flags_t *dst = (vm_flags_t *)(&vma->vm_flags);
-
-	*dst = flags;
-}
-
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


