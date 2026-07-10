Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634092F7F01
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723565; cv=none; b=Kx5qR1zkmtGCm90C6i2dBRKpZsNrTApwcGXX8DR9mdKtRhmyyqRirL/9/qlciccz3oBXTcfIawPkNTsoXt7CKQDjbG+x3JDHWLuedQbSdZAjrkQCqmq4sRRNCW+mqZnA/AaUhuVDJadcZS9+Ki1cfwFSLcGxpPZ+0z1zXEkyEGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723565; c=relaxed/simple;
	bh=q+dQKrCv7BtdYle2gaNwvI9vRSDCEtqIz/b+C1MnHOU=;
	h=Date:To:From:Subject:Message-Id; b=GrTGvKtuZlp7JG+Zj3BVV6CpLNLsmtQQjOElti7qGjYHcQRo7lJR8H5YpCKwADc+sfqrGD2IXZZk4jkbU1awyFgDpUP1GbfLk/sV6/Cn5HCDZM4gzP1gTNRs+hC8q45wVDhYHep36zRGlUd8/TRo6Roitp/HgZUZmNkGCdXIrMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PHgMCFLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PHgMCFLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B121F000E9;
	Fri, 10 Jul 2026 22:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723563;
	bh=CHZhCLbRkcn2X+fBKHMUPkF0tpDQmu/f899CWVJN1kk=;
	h=Date:To:From:Subject;
	b=PHgMCFLDf3kkWjNMVdY6Seide3Gp2NdTPK7OjUewNGg/3FhHrqpPfKdvHSqrABiEL
	 m04xLUZDQAicxFZX1Yd9wokjX1Q4ui4C/GOFn9jr9wcKxLxkSYm/GJat+7n7IZM8pZ
	 VeXKKwUUoYMmAfSFabiMXg6yoY/3vOi+aIowxXI8=
Date: Fri, 10 Jul 2026 15:46:02 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch added to mm-new branch
Message-Id: <20260710224602.E5B121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: rename vma_interval_tree_*() to mapping_rmap_tree_*()
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch

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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/rmap: rename vma_interval_tree_*() to mapping_rmap_tree_*()
Date: Fri, 10 Jul 2026 21:16:49 +0100

The family of vma_interval_tree_() functions manipulate the
address_space (which, of course, is generally referred to as 'mapping')
reverse mapping, but are named the 'VMA' interval tree.

VMAs may be mapped by an anon_vma, an address_space, or both. Therefore
calling the mapping interval tree a 'VMA' interval tree is rather
confusing.

This is also inconsistent with the anon_vma_interval_tree_*() functions
which explicitly reference the rmap object to which they pertain.

Rename the vma_interval_tree_*() functions to mapping_rmap_tree_*() to
correct this.

We will rename the anon rmap functions similarly in a subsequent patch.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-8-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault-armv.c          |    2 +-
 arch/arm/mm/flush.c               |    2 +-
 arch/nios2/mm/cacheflush.c        |    2 +-
 arch/parisc/kernel/cache.c        |    2 +-
 fs/dax.c                          |    2 +-
 fs/hugetlbfs/inode.c              |    4 ++--
 include/linux/mm.h                |   16 ++++++++--------
 kernel/events/uprobes.c           |    2 +-
 mm/hugetlb.c                      |    4 ++--
 mm/interval_tree.c                |   22 +++++++++++-----------
 mm/khugepaged.c                   |    4 ++--
 mm/memory-failure.c               |    6 +++---
 mm/memory.c                       |    2 +-
 mm/mmap.c                         |    2 +-
 mm/nommu.c                        |    8 ++++----
 mm/pagewalk.c                     |    2 +-
 mm/rmap.c                         |    2 +-
 mm/vma.c                          |   12 ++++++------
 tools/testing/vma/include/stubs.h |    4 ++--
 19 files changed, 50 insertions(+), 50 deletions(-)

--- a/arch/arm/mm/fault-armv.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/arch/arm/mm/fault-armv.c
@@ -140,7 +140,7 @@ make_coherent(struct address_space *mapp
 	 * cache coherency.
 	 */
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_foreach(mpnt, mapping, pgoff, pgoff) {
+	mapping_rmap_tree_foreach(mpnt, mapping, pgoff, pgoff) {
 		/*
 		 * If we are using split PTE locks, then we need to take the pte
 		 * lock. Otherwise we are using shared mm->page_table_lock which
--- a/arch/arm/mm/flush.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/arch/arm/mm/flush.c
@@ -251,7 +251,7 @@ static void __flush_dcache_aliases(struc
 	pgoff_end = pgoff + folio_nr_pages(folio) - 1;
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_foreach(vma, mapping, pgoff, pgoff_end) {
+	mapping_rmap_tree_foreach(vma, mapping, pgoff, pgoff_end) {
 		unsigned long start, offset, pfn;
 		unsigned int nr;
 
--- a/arch/nios2/mm/cacheflush.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/arch/nios2/mm/cacheflush.c
@@ -82,7 +82,7 @@ static void flush_aliases(struct address
 	pgoff = folio->index;
 
 	flush_dcache_mmap_lock_irqsave(mapping, flags);
-	vma_interval_tree_foreach(vma, mapping, pgoff, pgoff + nr - 1) {
+	mapping_rmap_tree_foreach(vma, mapping, pgoff, pgoff + nr - 1) {
 		unsigned long start;
 
 		if (vma->vm_mm != mm)
--- a/arch/parisc/kernel/cache.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/arch/parisc/kernel/cache.c
@@ -503,7 +503,7 @@ void flush_dcache_folio(struct folio *fo
 	 * on machines that support equivalent aliasing
 	 */
 	flush_dcache_mmap_lock_irqsave(mapping, flags);
-	vma_interval_tree_foreach(vma, mapping, pgoff, pgoff + nr - 1) {
+	mapping_rmap_tree_foreach(vma, mapping, pgoff, pgoff + nr - 1) {
 		unsigned long offset = pgoff - vma->vm_pgoff;
 		unsigned long pfn = folio_pfn(folio);
 
--- a/fs/dax.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/fs/dax.c
@@ -1201,7 +1201,7 @@ static int dax_writeback_one(struct xa_s
 
 	/* Walk all mappings of a given index of a file and writeprotect them */
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, mapping, index, end) {
+	mapping_rmap_tree_foreach(vma, mapping, index, end) {
 		pfn_mkclean_range(pfn, count, index, vma);
 		cond_resched();
 	}
--- a/fs/hugetlbfs/inode.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/fs/hugetlbfs/inode.c
@@ -393,7 +393,7 @@ static void hugetlb_unmap_file_folio(str
 	i_mmap_lock_write(mapping);
 retry:
 	vma_lock = NULL;
-	vma_interval_tree_foreach(vma, mapping, start, end - 1) {
+	mapping_rmap_tree_foreach(vma, mapping, start, end - 1) {
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
@@ -469,7 +469,7 @@ hugetlb_vmdelete_list(struct address_spa
 	 * unmapped.  Note, end is exclusive, whereas the interval tree takes
 	 * an inclusive "last".
 	 */
-	vma_interval_tree_foreach(vma, mapping, start,
+	mapping_rmap_tree_foreach(vma, mapping, start,
 				  end ? end - 1 : ULONG_MAX) {
 		unsigned long v_start;
 		unsigned long v_end;
--- a/include/linux/mm.h~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/include/linux/mm.h
@@ -4094,24 +4094,24 @@ extern atomic_long_t mmap_pages_allocate
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
 
 /* interval_tree.c */
-void vma_interval_tree_insert(struct vm_area_struct *vma,
+void mapping_rmap_tree_insert(struct vm_area_struct *vma,
 			      struct address_space *mapping);
-void vma_interval_tree_insert_after(struct vm_area_struct *vma,
+void mapping_rmap_tree_insert_after(struct vm_area_struct *vma,
 				    struct vm_area_struct *prev,
 				    struct address_space *mapping);
-void vma_interval_tree_remove(struct vm_area_struct *vma,
+void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 			      struct address_space *mapping);
 struct vm_area_struct *
-vma_interval_tree_iter_first(struct address_space *mapping,
+mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last);
 struct vm_area_struct *
-vma_interval_tree_iter_next(struct vm_area_struct *vma,
+mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 			    pgoff_t pgoff_start, pgoff_t pgoff_last);
 
-#define vma_interval_tree_foreach(vma, mapping, pgoff_start, pgoff_last) \
-	for (vma = vma_interval_tree_iter_first(mapping, pgoff_start,	 \
+#define mapping_rmap_tree_foreach(vma, mapping, pgoff_start, pgoff_last) \
+	for (vma = mapping_rmap_tree_iter_first(mapping, pgoff_start,	 \
 						pgoff_last);		 \
-	     vma; vma = vma_interval_tree_iter_next(vma, pgoff_start,	 \
+	     vma; vma = mapping_rmap_tree_iter_next(vma, pgoff_start,	 \
 						    pgoff_last))
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
--- a/kernel/events/uprobes.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/kernel/events/uprobes.c
@@ -1210,7 +1210,7 @@ build_map_info(struct address_space *map
 
  again:
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, mapping, pgoff, pgoff) {
+	mapping_rmap_tree_foreach(vma, mapping, pgoff, pgoff) {
 		if (!valid_vma(vma, is_register))
 			continue;
 
--- a/mm/hugetlb.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/mm/hugetlb.c
@@ -5455,7 +5455,7 @@ static void unmap_ref_private(struct mm_
 	 * __unmap_hugepage_range() is called as the lock is already held
 	 */
 	i_mmap_lock_write(mapping);
-	vma_interval_tree_foreach(iter_vma, mapping, pgoff, pgoff) {
+	mapping_rmap_tree_foreach(iter_vma, mapping, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
 			continue;
@@ -6998,7 +6998,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	pte_t *pte;
 
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(svma, mapping, idx, idx) {
+	mapping_rmap_tree_foreach(svma, mapping, idx, idx) {
 		if (svma == vma)
 			continue;
 
--- a/mm/interval_tree.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/mm/interval_tree.c
@@ -16,16 +16,16 @@
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     pgoff_t, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff, static,
-		     __vma_interval_tree)
+		     __mapping_rmap_tree)
 
-void vma_interval_tree_insert(struct vm_area_struct *vma,
+void mapping_rmap_tree_insert(struct vm_area_struct *vma,
 			      struct address_space *mapping)
 {
-	__vma_interval_tree_insert(vma, &mapping->i_mmap);
+	__mapping_rmap_tree_insert(vma, &mapping->i_mmap);
 }
 
 /* Insert vma immediately after prev in the interval tree */
-void vma_interval_tree_insert_after(struct vm_area_struct *vma,
+void mapping_rmap_tree_insert_after(struct vm_area_struct *vma,
 				    struct vm_area_struct *prev,
 				    struct address_space *mapping)
 {
@@ -55,28 +55,28 @@ void vma_interval_tree_insert_after(stru
 	vma->shared.rb_subtree_last = pgoff_last;
 	rb_link_node(&vma->shared.rb, &parent->shared.rb, link);
 	rb_insert_augmented(&vma->shared.rb, &mapping->i_mmap.rb_root,
-			    &__vma_interval_tree_augment);
+			    &__mapping_rmap_tree_augment);
 }
 
-void vma_interval_tree_remove(struct vm_area_struct *vma,
+void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 			      struct address_space *mapping)
 {
-	__vma_interval_tree_remove(vma, &mapping->i_mmap);
+	__mapping_rmap_tree_remove(vma, &mapping->i_mmap);
 }
 
 struct vm_area_struct *
-vma_interval_tree_iter_first(struct address_space *mapping,
+mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __vma_interval_tree_iter_first(&mapping->i_mmap,
+	return __mapping_rmap_tree_iter_first(&mapping->i_mmap,
 					      pgoff_start, pgoff_last);
 }
 
 struct vm_area_struct *
-vma_interval_tree_iter_next(struct vm_area_struct *vma,
+mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 			    pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __vma_interval_tree_iter_next(vma, pgoff_start, pgoff_last);
+	return __mapping_rmap_tree_iter_next(vma, pgoff_start, pgoff_last);
 }
 
 /* Anonymous interval tree (anon_vma->rb_root) */
--- a/mm/khugepaged.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/mm/khugepaged.c
@@ -2141,7 +2141,7 @@ static void retract_page_tables(struct a
 	struct vm_area_struct *vma;
 
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, mapping, pgoff, pgoff) {
+	mapping_rmap_tree_foreach(vma, mapping, pgoff, pgoff) {
 		struct mmu_notifier_range range;
 		struct mm_struct *mm;
 		unsigned long addr;
@@ -2573,7 +2573,7 @@ xa_unlocked:
 		 * not be able to observe any missing pages due to the
 		 * previously inserted retry entries.
 		 */
-		vma_interval_tree_foreach(vma, mapping, start, end) {
+		mapping_rmap_tree_foreach(vma, mapping, start, end) {
 			if (userfaultfd_missing(vma)) {
 				result = SCAN_EXCEED_NONE_PTE;
 				goto immap_locked;
--- a/mm/memory.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/mm/memory.c
@@ -4425,7 +4425,7 @@ static inline void unmap_mapping_range_t
 	unsigned long start, size;
 	struct mmu_gather tlb;
 
-	vma_interval_tree_foreach(vma, mapping, first_index, last_index) {
+	mapping_rmap_tree_foreach(vma, mapping, first_index, last_index) {
 		const pgoff_t start_idx = max(first_index, vma->vm_pgoff);
 		const pgoff_t end_idx = min(last_index, vma_last_pgoff(vma)) + 1;
 
--- a/mm/memory-failure.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/mm/memory-failure.c
@@ -598,7 +598,7 @@ static void collect_procs_file(const str
 
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, mapping, pgoff, pgoff) {
+		mapping_rmap_tree_foreach(vma, mapping, pgoff, pgoff) {
 			/*
 			 * Send early kill signal to tasks where a vma covers
 			 * the page but the corrupted page is not necessarily
@@ -649,7 +649,7 @@ static void collect_procs_fsdax(const st
 			t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, mapping, pgoff, pgoff) {
+		mapping_rmap_tree_foreach(vma, mapping, pgoff, pgoff) {
 			if (vma->vm_mm == t->mm)
 				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
 		}
@@ -2296,7 +2296,7 @@ static void collect_procs_pfn(struct pfn
 		t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, mapping, 0, ULONG_MAX) {
+		mapping_rmap_tree_foreach(vma, mapping, 0, ULONG_MAX) {
 			pgoff_t pgoff;
 
 			if (vma->vm_mm == t->mm &&
--- a/mm/mmap.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/mm/mmap.c
@@ -1830,7 +1830,7 @@ __latent_entropy int dup_mmap(struct mm_
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
-			vma_interval_tree_insert_after(tmp, mpnt, mapping);
+			mapping_rmap_tree_insert_after(tmp, mpnt, mapping);
 			flush_dcache_mmap_unlock(mapping);
 			i_mmap_unlock_write(mapping);
 		}
--- a/mm/nommu.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/mm/nommu.c
@@ -569,7 +569,7 @@ static void setup_vma_to_mm(struct vm_ar
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_insert(vma, mapping);
+		mapping_rmap_tree_insert(vma, mapping);
 		flush_dcache_mmap_unlock(mapping);
 		i_mmap_unlock_write(mapping);
 	}
@@ -585,7 +585,7 @@ static void cleanup_vma_from_mm(struct v
 
 		i_mmap_lock_write(mapping);
 		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_remove(vma, mapping);
+		mapping_rmap_tree_remove(vma, mapping);
 		flush_dcache_mmap_unlock(mapping);
 		i_mmap_unlock_write(mapping);
 	}
@@ -1843,7 +1843,7 @@ int nommu_shrink_inode_mappings(struct i
 	i_mmap_lock_read(inode->i_mapping);
 
 	/* search for VMAs that fall within the dead zone */
-	vma_interval_tree_foreach(vma, inode->i_mapping, low, high) {
+	mapping_rmap_tree_foreach(vma, inode->i_mapping, low, high) {
 		/* found one - only interested if it's shared out of the page
 		 * cache */
 		if (vma->vm_flags & VM_SHARED) {
@@ -1859,7 +1859,7 @@ int nommu_shrink_inode_mappings(struct i
 	 * we don't check for any regions that start beyond the EOF as there
 	 * shouldn't be any
 	 */
-	vma_interval_tree_foreach(vma, inode->i_mapping, 0, ULONG_MAX) {
+	mapping_rmap_tree_foreach(vma, inode->i_mapping, 0, ULONG_MAX) {
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
--- a/mm/pagewalk.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/mm/pagewalk.c
@@ -812,7 +812,7 @@ int walk_page_mapping(struct address_spa
 		return -EINVAL;
 
 	lockdep_assert_held(&mapping->i_mmap_rwsem);
-	vma_interval_tree_foreach(vma, mapping, first_index,
+	mapping_rmap_tree_foreach(vma, mapping, first_index,
 				  first_index + nr - 1) {
 		/* Clip to the vma */
 		vba = vma->vm_pgoff;
--- a/mm/rmap.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/mm/rmap.c
@@ -3053,7 +3053,7 @@ static void __rmap_walk_file(struct foli
 		i_mmap_lock_read(mapping);
 	}
 lookup:
-	vma_interval_tree_foreach(vma, mapping, pgoff_start, pgoff_end) {
+	mapping_rmap_tree_foreach(vma, mapping, pgoff_start, pgoff_end) {
 		unsigned long address = vma_address(vma, pgoff_start, nr_pages);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
--- a/mm/vma.c~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/mm/vma.c
@@ -234,7 +234,7 @@ static void __vma_link_file(struct vm_ar
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_insert(vma, mapping);
+	mapping_rmap_tree_insert(vma, mapping);
 	flush_dcache_mmap_unlock(mapping);
 }
 
@@ -248,7 +248,7 @@ static void __remove_shared_vm_struct(st
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_remove(vma, mapping);
+	mapping_rmap_tree_remove(vma, mapping);
 	flush_dcache_mmap_unlock(mapping);
 }
 
@@ -319,9 +319,9 @@ static void vma_prepare(struct vma_prepa
 
 	if (vp->file) {
 		flush_dcache_mmap_lock(vp->mapping);
-		vma_interval_tree_remove(vp->vma, vp->mapping);
+		mapping_rmap_tree_remove(vp->vma, vp->mapping);
 		if (vp->adj_next)
-			vma_interval_tree_remove(vp->adj_next, vp->mapping);
+			mapping_rmap_tree_remove(vp->adj_next, vp->mapping);
 	}
 
 }
@@ -339,8 +339,8 @@ static void vma_complete(struct vma_prep
 {
 	if (vp->file) {
 		if (vp->adj_next)
-			vma_interval_tree_insert(vp->adj_next, vp->mapping);
-		vma_interval_tree_insert(vp->vma, vp->mapping);
+			mapping_rmap_tree_insert(vp->adj_next, vp->mapping);
+		mapping_rmap_tree_insert(vp->vma, vp->mapping);
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
--- a/tools/testing/vma/include/stubs.h~mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_
+++ a/tools/testing/vma/include/stubs.h
@@ -257,12 +257,12 @@ static inline void vm_acct_memory(long p
 {
 }
 
-static inline void vma_interval_tree_insert(struct vm_area_struct *vma,
+static inline void mapping_rmap_tree_insert(struct vm_area_struct *vma,
 					    struct address_space *mapping)
 {
 }
 
-static inline void vma_interval_tree_remove(struct vm_area_struct *vma,
+static inline void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 					    struct address_space *mapping)
 {
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch

