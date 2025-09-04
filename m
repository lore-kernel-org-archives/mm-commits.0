Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5707C2C08D9
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 21:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757021916; cv=none; b=qWSQfLZOcBY+tQ6A/VgoYYDiWlLHv/cJBrhsu3bnZnFoSE1fUCM0FEotRzkeADf344o+nTpQa+KyeRIh/yO6cU+eFYuiDXjjUx4gcus+5zWNer5pKwTnsWliAN/XOUtcsNU0AWTigIfDAXIPhrVXF/uRYnODPC8zA+BVppjjZoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757021916; c=relaxed/simple;
	bh=KvRkOFCFYwx39t3vJYOrc76Loe3wERLuRkhOEKq7N58=;
	h=Date:To:From:Subject:Message-Id; b=sJJKmINGHBkQS57x2IqHGkNmc7tiFkuXefs85VF9JSAUhsG8CiCzb7AlppsmI6DZJxoAroF2vZixibAnPRdYHHC4zytk0ujKfwi9LFwhfc+MiyZAqHZqj0gO7c7pMmwYH9NaAfjTPACJyp2gVpbcOC8snysIehVzERmriUuLj58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DMCrKilV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DMCrKilV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91D6C4CEF0;
	Thu,  4 Sep 2025 21:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757021915;
	bh=KvRkOFCFYwx39t3vJYOrc76Loe3wERLuRkhOEKq7N58=;
	h=Date:To:From:Subject:From;
	b=DMCrKilVoJODdVwNkew9NtlZwWRVn7JDvYGjeymEoS1ZWk25HbbRljBCFsS1RuvaZ
	 UvWWMKi7NMnKehL7syGoAaE/yvu5sN198EWwjKKPAOWagpW3H9e7cZEKmqIdXOcoYx
	 pzJz124bgyuxoaPf4dTjXjxZRXxLqiMBM1O1ZelQ=
Date: Thu, 04 Sep 2025 14:38:35 -0700
To: mm-commits@vger.kernel.org,wangyuli@uniontech.com,vbabka@suse.cz,Liam.Howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-testing-vma-clean-up-stubs-in-vma_internalh.patch removed from -mm tree
Message-Id: <20250904213835.B91D6C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/testing/vma: clean up stubs in vma_internal.h
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-clean-up-stubs-in-vma_internalh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/vma: clean up stubs in vma_internal.h
Date: Tue, 26 Aug 2025 11:28:24 +0100

We do not need to references arguments just to avoid compiler warnings,
the warning in question does not arise here, so remove all of the
instances of '(void)xxx' introduced purely to avoid this warning.

As reported by WagYuli in the referenced mail, GCC 8.3 and before will
have issues compiling this file if parameter names are not provided, so
ensure these are always provided.

Finally, perform a trivial fix up of kmem_cache_alloc() which technically
has parameters in the incorrect order (as reported by Vlastimil Babka
off-list).

Link: https://lkml.kernel.org/r/20250826102824.22730-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: WangYuli <wangyuli@uniontech.com>
Closes: https://lore.kernel.org/linux-mm/EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com/
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |  167 +++++++++--------------------
 1 file changed, 57 insertions(+), 110 deletions(-)

--- a/tools/testing/vma/vma_internal.h~tools-testing-vma-clean-up-stubs-in-vma_internalh
+++ a/tools/testing/vma/vma_internal.h
@@ -692,9 +692,7 @@ static inline struct kmem_cache *__kmem_
 
 static inline void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	(void)gfpflags;
-
-	return calloc(s->object_size, 1);
+	return calloc(1, s->object_size);
 }
 
 static inline void kmem_cache_free(struct kmem_cache *s, void *x)
@@ -858,11 +856,11 @@ static inline unsigned long vma_pages(st
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
-static inline void fput(struct file *)
+static inline void fput(struct file *file)
 {
 }
 
-static inline void mpol_put(struct mempolicy *)
+static inline void mpol_put(struct mempolicy *pol)
 {
 }
 
@@ -870,15 +868,15 @@ static inline void lru_add_drain(void)
 {
 }
 
-static inline void tlb_gather_mmu(struct mmu_gather *, struct mm_struct *)
+static inline void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm)
 {
 }
 
-static inline void update_hiwater_rss(struct mm_struct *)
+static inline void update_hiwater_rss(struct mm_struct *mm)
 {
 }
 
-static inline void update_hiwater_vm(struct mm_struct *)
+static inline void update_hiwater_vm(struct mm_struct *mm)
 {
 }
 
@@ -887,36 +885,23 @@ static inline void unmap_vmas(struct mmu
 		      unsigned long end_addr, unsigned long tree_end,
 		      bool mm_wr_locked)
 {
-	(void)tlb;
-	(void)mas;
-	(void)vma;
-	(void)start_addr;
-	(void)end_addr;
-	(void)tree_end;
-	(void)mm_wr_locked;
 }
 
 static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *vma, unsigned long floor,
 		   unsigned long ceiling, bool mm_wr_locked)
 {
-	(void)tlb;
-	(void)mas;
-	(void)vma;
-	(void)floor;
-	(void)ceiling;
-	(void)mm_wr_locked;
 }
 
-static inline void mapping_unmap_writable(struct address_space *)
+static inline void mapping_unmap_writable(struct address_space *mapping)
 {
 }
 
-static inline void flush_dcache_mmap_lock(struct address_space *)
+static inline void flush_dcache_mmap_lock(struct address_space *mapping)
 {
 }
 
-static inline void tlb_finish_mmu(struct mmu_gather *)
+static inline void tlb_finish_mmu(struct mmu_gather *tlb)
 {
 }
 
@@ -925,7 +910,7 @@ static inline struct file *get_file(stru
 	return f;
 }
 
-static inline int vma_dup_policy(struct vm_area_struct *, struct vm_area_struct *)
+static inline int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
 {
 	return 0;
 }
@@ -952,10 +937,6 @@ static inline void vma_adjust_trans_huge
 					 unsigned long end,
 					 struct vm_area_struct *next)
 {
-	(void)vma;
-	(void)start;
-	(void)end;
-	(void)next;
 }
 
 static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
@@ -975,51 +956,48 @@ static inline void vm_acct_memory(long p
 {
 }
 
-static inline void vma_interval_tree_insert(struct vm_area_struct *,
-					    struct rb_root_cached *)
+static inline void vma_interval_tree_insert(struct vm_area_struct *vma,
+					    struct rb_root_cached *rb)
 {
 }
 
-static inline void vma_interval_tree_remove(struct vm_area_struct *,
-					    struct rb_root_cached *)
+static inline void vma_interval_tree_remove(struct vm_area_struct *vma,
+					    struct rb_root_cached *rb)
 {
 }
 
-static inline void flush_dcache_mmap_unlock(struct address_space *)
+static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 {
 }
 
-static inline void anon_vma_interval_tree_insert(struct anon_vma_chain*,
-						 struct rb_root_cached *)
+static inline void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
+						 struct rb_root_cached *rb)
 {
 }
 
-static inline void anon_vma_interval_tree_remove(struct anon_vma_chain*,
-						 struct rb_root_cached *)
+static inline void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
+						 struct rb_root_cached *rb)
 {
 }
 
-static inline void uprobe_mmap(struct vm_area_struct *)
+static inline void uprobe_mmap(struct vm_area_struct *vma)
 {
 }
 
 static inline void uprobe_munmap(struct vm_area_struct *vma,
 				 unsigned long start, unsigned long end)
 {
-	(void)vma;
-	(void)start;
-	(void)end;
 }
 
-static inline void i_mmap_lock_write(struct address_space *)
+static inline void i_mmap_lock_write(struct address_space *mapping)
 {
 }
 
-static inline void anon_vma_lock_write(struct anon_vma *)
+static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
 {
 }
 
-static inline void vma_assert_write_locked(struct vm_area_struct *)
+static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
 }
 
@@ -1029,16 +1007,16 @@ static inline void unlink_anon_vmas(stru
 	vma->anon_vma->was_unlinked = true;
 }
 
-static inline void anon_vma_unlock_write(struct anon_vma *)
+static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
 {
 }
 
-static inline void i_mmap_unlock_write(struct address_space *)
+static inline void i_mmap_unlock_write(struct address_space *mapping)
 {
 }
 
-static inline void anon_vma_merge(struct vm_area_struct *,
-				  struct vm_area_struct *)
+static inline void anon_vma_merge(struct vm_area_struct *vma,
+				  struct vm_area_struct *next)
 {
 }
 
@@ -1047,27 +1025,22 @@ static inline int userfaultfd_unmap_prep
 					 unsigned long end,
 					 struct list_head *unmaps)
 {
-	(void)vma;
-	(void)start;
-	(void)end;
-	(void)unmaps;
-
 	return 0;
 }
 
-static inline void mmap_write_downgrade(struct mm_struct *)
+static inline void mmap_write_downgrade(struct mm_struct *mm)
 {
 }
 
-static inline void mmap_read_unlock(struct mm_struct *)
+static inline void mmap_read_unlock(struct mm_struct *mm)
 {
 }
 
-static inline void mmap_write_unlock(struct mm_struct *)
+static inline void mmap_write_unlock(struct mm_struct *mm)
 {
 }
 
-static inline int mmap_write_lock_killable(struct mm_struct *)
+static inline int mmap_write_lock_killable(struct mm_struct *mm)
 {
 	return 0;
 }
@@ -1076,10 +1049,6 @@ static inline bool can_modify_mm(struct
 				 unsigned long start,
 				 unsigned long end)
 {
-	(void)mm;
-	(void)start;
-	(void)end;
-
 	return true;
 }
 
@@ -1087,16 +1056,13 @@ static inline void arch_unmap(struct mm_
 				 unsigned long start,
 				 unsigned long end)
 {
-	(void)mm;
-	(void)start;
-	(void)end;
 }
 
-static inline void mmap_assert_locked(struct mm_struct *)
+static inline void mmap_assert_locked(struct mm_struct *mm)
 {
 }
 
-static inline bool mpol_equal(struct mempolicy *, struct mempolicy *)
+static inline bool mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
 	return true;
 }
@@ -1104,63 +1070,62 @@ static inline bool mpol_equal(struct mem
 static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	(void)vma;
-	(void)vm_flags;
 }
 
-static inline bool mapping_can_writeback(struct address_space *)
+static inline bool mapping_can_writeback(struct address_space *mapping)
 {
 	return true;
 }
 
-static inline bool is_vm_hugetlb_page(struct vm_area_struct *)
+static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline bool vma_soft_dirty_enabled(struct vm_area_struct *)
+static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline bool userfaultfd_wp(struct vm_area_struct *)
+static inline bool userfaultfd_wp(struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline void mmap_assert_write_locked(struct mm_struct *)
+static inline void mmap_assert_write_locked(struct mm_struct *mm)
 {
 }
 
-static inline void mutex_lock(struct mutex *)
+static inline void mutex_lock(struct mutex *lock)
 {
 }
 
-static inline void mutex_unlock(struct mutex *)
+static inline void mutex_unlock(struct mutex *lock)
 {
 }
 
-static inline bool mutex_is_locked(struct mutex *)
+static inline bool mutex_is_locked(struct mutex *lock)
 {
 	return true;
 }
 
-static inline bool signal_pending(void *)
+static inline bool signal_pending(void *p)
 {
 	return false;
 }
 
-static inline bool is_file_hugepages(struct file *)
+static inline bool is_file_hugepages(struct file *file)
 {
 	return false;
 }
 
-static inline int security_vm_enough_memory_mm(struct mm_struct *, long)
+static inline int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
 	return 0;
 }
 
-static inline bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long)
+static inline bool may_expand_vm(struct mm_struct *mm, vm_flags_t flags,
+				 unsigned long npages)
 {
 	return true;
 }
@@ -1185,7 +1150,7 @@ static inline void vm_flags_clear(struct
 	vma->__vm_flags &= ~flags;
 }
 
-static inline int shmem_zero_setup(struct vm_area_struct *)
+static inline int shmem_zero_setup(struct vm_area_struct *vma)
 {
 	return 0;
 }
@@ -1195,20 +1160,20 @@ static inline void vma_set_anonymous(str
 	vma->vm_ops = NULL;
 }
 
-static inline void ksm_add_vma(struct vm_area_struct *)
+static inline void ksm_add_vma(struct vm_area_struct *vma)
 {
 }
 
-static inline void perf_event_mmap(struct vm_area_struct *)
+static inline void perf_event_mmap(struct vm_area_struct *vma)
 {
 }
 
-static inline bool vma_is_dax(struct vm_area_struct *)
+static inline bool vma_is_dax(struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline struct vm_area_struct *get_gate_vma(struct mm_struct *)
+static inline struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
 	return NULL;
 }
@@ -1233,16 +1198,16 @@ static inline void vma_set_page_prot(str
 	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
 }
 
-static inline bool arch_validate_flags(vm_flags_t)
+static inline bool arch_validate_flags(vm_flags_t flags)
 {
 	return true;
 }
 
-static inline void vma_close(struct vm_area_struct *)
+static inline void vma_close(struct vm_area_struct *vma)
 {
 }
 
-static inline int mmap_file(struct file *, struct vm_area_struct *)
+static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
 	return 0;
 }
@@ -1411,8 +1376,6 @@ static inline int mapping_map_writable(s
 
 static inline unsigned long move_page_tables(struct pagetable_move_control *pmc)
 {
-	(void)pmc;
-
 	return 0;
 }
 
@@ -1420,51 +1383,36 @@ static inline void free_pgd_range(struct
 			unsigned long addr, unsigned long end,
 			unsigned long floor, unsigned long ceiling)
 {
-	(void)tlb;
-	(void)addr;
-	(void)end;
-	(void)floor;
-	(void)ceiling;
 }
 
 static inline int ksm_execve(struct mm_struct *mm)
 {
-	(void)mm;
-
 	return 0;
 }
 
 static inline void ksm_exit(struct mm_struct *mm)
 {
-	(void)mm;
 }
 
 static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 {
-	(void)vma;
-	(void)reset_refcnt;
 }
 
 static inline void vma_numab_state_init(struct vm_area_struct *vma)
 {
-	(void)vma;
 }
 
 static inline void vma_numab_state_free(struct vm_area_struct *vma)
 {
-	(void)vma;
 }
 
 static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
 				     struct vm_area_struct *new_vma)
 {
-	(void)orig_vma;
-	(void)new_vma;
 }
 
 static inline void free_anon_vma_name(struct vm_area_struct *vma)
 {
-	(void)vma;
 }
 
 /* Declared in vma.h. */
@@ -1518,7 +1466,6 @@ static inline int vfs_mmap_prepare(struc
 
 static inline void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 {
-	(void)vma;
 }
 
 static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
@@ -1529,13 +1476,13 @@ static inline void vma_set_file(struct v
 	fput(file);
 }
 
-static inline bool shmem_file(struct file *)
+static inline bool shmem_file(struct file *file)
 {
 	return false;
 }
 
-static inline vm_flags_t ksm_vma_flags(const struct mm_struct *, const struct file *,
-			 vm_flags_t vm_flags)
+static inline vm_flags_t ksm_vma_flags(const struct mm_struct *mm,
+		const struct file *file, vm_flags_t vm_flags)
 {
 	return vm_flags;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch
mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch

