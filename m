From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-gup-remove-task_struct-pointer-for-all-gup-code.patch added to -mm tree
Date: Wed, 08 Jul 2020 17:07:33 -0700
Message-ID: <20200709000733.R36-4HsTs%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgGIAHf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 20:07:35 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm/gup: remove task_struct pointer for all gup code
has been added to the -mm tree.  Its filename is
     mm-gup-remove-task_struct-pointer-for-all-gup-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-remove-task_struct-pointer-for-all-gup-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-remove-task_struct-pointer-for-all-gup-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: remove task_struct pointer for all gup code

After the cleanup of page fault accounting, gup does not need to pass
task_struct around any more.  Remove that parameter in the whole gup
stack.

Link: http://lkml.kernel.org/r/20200707225021.200906-26-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/process.c                   |    2 
 arch/s390/kvm/interrupt.c                   |    2 
 arch/s390/kvm/kvm-s390.c                    |    2 
 arch/s390/kvm/priv.c                        |    8 -
 arch/s390/mm/gmap.c                         |    4 
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |    2 
 drivers/infiniband/core/umem_odp.c          |    2 
 drivers/vfio/vfio_iommu_type1.c             |    4 
 fs/exec.c                                   |    2 
 include/linux/mm.h                          |    9 -
 kernel/events/uprobes.c                     |    6 -
 kernel/futex.c                              |    2 
 mm/gup.c                                    |  101 +++++++-----------
 mm/memory.c                                 |    2 
 mm/process_vm_access.c                      |    2 
 security/tomoyo/domain.c                    |    2 
 virt/kvm/async_pf.c                         |    2 
 virt/kvm/kvm_main.c                         |    2 
 18 files changed, 69 insertions(+), 87 deletions(-)

--- a/arch/arc/kernel/process.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/arch/arc/kernel/process.c
@@ -91,7 +91,7 @@ fault:
 		 goto fail;
 
 	mmap_read_lock(current->mm);
-	ret = fixup_user_fault(current, current->mm, (unsigned long) uaddr,
+	ret = fixup_user_fault(current->mm, (unsigned long) uaddr,
 			       FAULT_FLAG_WRITE, NULL);
 	mmap_read_unlock(current->mm);
 
--- a/arch/s390/kvm/interrupt.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/arch/s390/kvm/interrupt.c
@@ -2768,7 +2768,7 @@ static struct page *get_map_page(struct
 	struct page *page = NULL;
 
 	mmap_read_lock(kvm->mm);
-	get_user_pages_remote(NULL, kvm->mm, uaddr, 1, FOLL_WRITE,
+	get_user_pages_remote(kvm->mm, uaddr, 1, FOLL_WRITE,
 			      &page, NULL, NULL);
 	mmap_read_unlock(kvm->mm);
 	return page;
--- a/arch/s390/kvm/kvm-s390.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/arch/s390/kvm/kvm-s390.c
@@ -1891,7 +1891,7 @@ static long kvm_s390_set_skeys(struct kv
 
 		r = set_guest_storage_key(current->mm, hva, keys[i], 0);
 		if (r) {
-			r = fixup_user_fault(current, current->mm, hva,
+			r = fixup_user_fault(current->mm, hva,
 					     FAULT_FLAG_WRITE, &unlocked);
 			if (r)
 				break;
--- a/arch/s390/kvm/priv.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/arch/s390/kvm/priv.c
@@ -273,7 +273,7 @@ retry:
 	rc = get_guest_storage_key(current->mm, vmaddr, &key);
 
 	if (rc) {
-		rc = fixup_user_fault(current, current->mm, vmaddr,
+		rc = fixup_user_fault(current->mm, vmaddr,
 				      FAULT_FLAG_WRITE, &unlocked);
 		if (!rc) {
 			mmap_read_unlock(current->mm);
@@ -319,7 +319,7 @@ retry:
 	mmap_read_lock(current->mm);
 	rc = reset_guest_reference_bit(current->mm, vmaddr);
 	if (rc < 0) {
-		rc = fixup_user_fault(current, current->mm, vmaddr,
+		rc = fixup_user_fault(current->mm, vmaddr,
 				      FAULT_FLAG_WRITE, &unlocked);
 		if (!rc) {
 			mmap_read_unlock(current->mm);
@@ -390,7 +390,7 @@ static int handle_sske(struct kvm_vcpu *
 						m3 & SSKE_MC);
 
 		if (rc < 0) {
-			rc = fixup_user_fault(current, current->mm, vmaddr,
+			rc = fixup_user_fault(current->mm, vmaddr,
 					      FAULT_FLAG_WRITE, &unlocked);
 			rc = !rc ? -EAGAIN : rc;
 		}
@@ -1094,7 +1094,7 @@ static int handle_pfmf(struct kvm_vcpu *
 			rc = cond_set_guest_storage_key(current->mm, vmaddr,
 							key, NULL, nq, mr, mc);
 			if (rc < 0) {
-				rc = fixup_user_fault(current, current->mm, vmaddr,
+				rc = fixup_user_fault(current->mm, vmaddr,
 						      FAULT_FLAG_WRITE, &unlocked);
 				rc = !rc ? -EAGAIN : rc;
 			}
--- a/arch/s390/mm/gmap.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/arch/s390/mm/gmap.c
@@ -649,7 +649,7 @@ retry:
 		rc = vmaddr;
 		goto out_up;
 	}
-	if (fixup_user_fault(current, gmap->mm, vmaddr, fault_flags,
+	if (fixup_user_fault(gmap->mm, vmaddr, fault_flags,
 			     &unlocked)) {
 		rc = -EFAULT;
 		goto out_up;
@@ -879,7 +879,7 @@ static int gmap_pte_op_fixup(struct gmap
 
 	BUG_ON(gmap_is_shadow(gmap));
 	fault_flags = (prot == PROT_WRITE) ? FAULT_FLAG_WRITE : 0;
-	if (fixup_user_fault(current, mm, vmaddr, fault_flags, &unlocked))
+	if (fixup_user_fault(mm, vmaddr, fault_flags, &unlocked))
 		return -EFAULT;
 	if (unlocked)
 		/* lost mmap_lock, caller has to retry __gmap_translate */
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -472,7 +472,7 @@ __i915_gem_userptr_get_pages_worker(stru
 					locked = 1;
 				}
 				ret = pin_user_pages_remote
-					(work->task, mm,
+					(mm,
 					 obj->userptr.ptr + pinned * PAGE_SIZE,
 					 npages - pinned,
 					 flags,
--- a/drivers/infiniband/core/umem_odp.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/drivers/infiniband/core/umem_odp.c
@@ -437,7 +437,7 @@ int ib_umem_odp_map_dma_pages(struct ib_
 		 * complex (and doesn't gain us much performance in most use
 		 * cases).
 		 */
-		npages = get_user_pages_remote(owning_process, owning_mm,
+		npages = get_user_pages_remote(owning_mm,
 				user_virt, gup_num_pages,
 				flags, local_page_list, NULL, NULL);
 		mmap_read_unlock(owning_mm);
--- a/drivers/vfio/vfio_iommu_type1.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -425,7 +425,7 @@ static int follow_fault_pfn(struct vm_ar
 	if (ret) {
 		bool unlocked = false;
 
-		ret = fixup_user_fault(NULL, mm, vaddr,
+		ret = fixup_user_fault(mm, vaddr,
 				       FAULT_FLAG_REMOTE |
 				       (write_fault ?  FAULT_FLAG_WRITE : 0),
 				       &unlocked);
@@ -453,7 +453,7 @@ static int vaddr_get_pfn(struct mm_struc
 		flags |= FOLL_WRITE;
 
 	mmap_read_lock(mm);
-	ret = pin_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
+	ret = pin_user_pages_remote(mm, vaddr, 1, flags | FOLL_LONGTERM,
 				    page, NULL, NULL);
 	if (ret == 1) {
 		*pfn = page_to_pfn(page[0]);
--- a/fs/exec.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/fs/exec.c
@@ -215,7 +215,7 @@ static struct page *get_arg_page(struct
 	 * We are doing an exec().  'current' is the process
 	 * doing the exec and bprm->mm is the new process's mm.
 	 */
-	ret = get_user_pages_remote(current, bprm->mm, pos, 1, gup_flags,
+	ret = get_user_pages_remote(bprm->mm, pos, 1, gup_flags,
 			&page, NULL, NULL);
 	if (ret <= 0)
 		return NULL;
--- a/include/linux/mm.h~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/include/linux/mm.h
@@ -1653,7 +1653,7 @@ int invalidate_inode_page(struct page *p
 extern vm_fault_t handle_mm_fault(struct vm_area_struct *vma,
 				  unsigned long address, unsigned int flags,
 				  struct pt_regs *regs);
-extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+extern int fixup_user_fault(struct mm_struct *mm,
 			    unsigned long address, unsigned int fault_flags,
 			    bool *unlocked);
 void unmap_mapping_pages(struct address_space *mapping,
@@ -1669,8 +1669,7 @@ static inline vm_fault_t handle_mm_fault
 	BUG();
 	return VM_FAULT_SIGBUS;
 }
-static inline int fixup_user_fault(struct task_struct *tsk,
-		struct mm_struct *mm, unsigned long address,
+static inline int fixup_user_fault(struct mm_struct *mm, unsigned long address,
 		unsigned int fault_flags, bool *unlocked)
 {
 	/* should never happen if there's no MMU */
@@ -1696,11 +1695,11 @@ extern int access_remote_vm(struct mm_st
 extern int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long addr, void *buf, int len, unsigned int gup_flags);
 
-long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
+long get_user_pages_remote(struct mm_struct *mm,
 			    unsigned long start, unsigned long nr_pages,
 			    unsigned int gup_flags, struct page **pages,
 			    struct vm_area_struct **vmas, int *locked);
-long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
+long pin_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
 			   unsigned int gup_flags, struct page **pages,
 			   struct vm_area_struct **vmas, int *locked);
--- a/kernel/events/uprobes.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/kernel/events/uprobes.c
@@ -376,7 +376,7 @@ __update_ref_ctr(struct mm_struct *mm, u
 	if (!vaddr || !d)
 		return -EINVAL;
 
-	ret = get_user_pages_remote(NULL, mm, vaddr, 1,
+	ret = get_user_pages_remote(mm, vaddr, 1,
 			FOLL_WRITE, &page, &vma, NULL);
 	if (unlikely(ret <= 0)) {
 		/*
@@ -477,7 +477,7 @@ retry:
 	if (is_register)
 		gup_flags |= FOLL_SPLIT_PMD;
 	/* Read the page with vaddr into memory */
-	ret = get_user_pages_remote(NULL, mm, vaddr, 1, gup_flags,
+	ret = get_user_pages_remote(mm, vaddr, 1, gup_flags,
 				    &old_page, &vma, NULL);
 	if (ret <= 0)
 		return ret;
@@ -2029,7 +2029,7 @@ static int is_trap_at_addr(struct mm_str
 	 * but we treat this as a 'remote' access since it is
 	 * essentially a kernel access to the memory.
 	 */
-	result = get_user_pages_remote(NULL, mm, vaddr, 1, FOLL_FORCE, &page,
+	result = get_user_pages_remote(mm, vaddr, 1, FOLL_FORCE, &page,
 			NULL, NULL);
 	if (result < 0)
 		return result;
--- a/kernel/futex.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/kernel/futex.c
@@ -699,7 +699,7 @@ static int fault_in_user_writeable(u32 _
 	int ret;
 
 	mmap_read_lock(mm);
-	ret = fixup_user_fault(current, mm, (unsigned long)uaddr,
+	ret = fixup_user_fault(mm, (unsigned long)uaddr,
 			       FAULT_FLAG_WRITE, NULL);
 	mmap_read_unlock(mm);
 
--- a/mm/gup.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/mm/gup.c
@@ -859,7 +859,7 @@ unmap:
  * does not include FOLL_NOWAIT, the mmap_lock may be released.  If it
  * is, *@locked will be set to 0 and -EBUSY returned.
  */
-static int faultin_page(struct task_struct *tsk, struct vm_area_struct *vma,
+static int faultin_page(struct vm_area_struct *vma,
 		unsigned long address, unsigned int *flags, int *locked)
 {
 	unsigned int fault_flags = 0;
@@ -962,7 +962,6 @@ static int check_vma_flags(struct vm_are
 
 /**
  * __get_user_pages() - pin user pages in memory
- * @tsk:	task_struct of target task
  * @mm:		mm_struct of target mm
  * @start:	starting user address
  * @nr_pages:	number of pages from start to pin
@@ -1021,7 +1020,7 @@ static int check_vma_flags(struct vm_are
  * instead of __get_user_pages. __get_user_pages should be used only if
  * you need some special @gup_flags.
  */
-static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+static long __get_user_pages(struct mm_struct *mm,
 		unsigned long start, unsigned long nr_pages,
 		unsigned int gup_flags, struct page **pages,
 		struct vm_area_struct **vmas, int *locked)
@@ -1103,8 +1102,7 @@ retry:
 
 		page = follow_page_mask(vma, start, foll_flags, &ctx);
 		if (!page) {
-			ret = faultin_page(tsk, vma, start, &foll_flags,
-					   locked);
+			ret = faultin_page(vma, start, &foll_flags, locked);
 			switch (ret) {
 			case 0:
 				goto retry;
@@ -1178,8 +1176,6 @@ static bool vma_permits_fault(struct vm_
 
 /**
  * fixup_user_fault() - manually resolve a user page fault
- * @tsk:	the task_struct to use for page fault accounting, or
- *		NULL if faults are not to be recorded.
  * @mm:		mm_struct of target mm
  * @address:	user address
  * @fault_flags:flags to pass down to handle_mm_fault()
@@ -1207,7 +1203,7 @@ static bool vma_permits_fault(struct vm_
  * This function will not return with an unlocked mmap_lock. So it has not the
  * same semantics wrt the @mm->mmap_lock as does filemap_fault().
  */
-int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+int fixup_user_fault(struct mm_struct *mm,
 		     unsigned long address, unsigned int fault_flags,
 		     bool *unlocked)
 {
@@ -1256,8 +1252,7 @@ EXPORT_SYMBOL_GPL(fixup_user_fault);
  * Please note that this function, unlike __get_user_pages will not
  * return 0 for nr_pages > 0 without FOLL_NOWAIT
  */
-static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
-						struct mm_struct *mm,
+static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 						unsigned long start,
 						unsigned long nr_pages,
 						struct page **pages,
@@ -1290,7 +1285,7 @@ static __always_inline long __get_user_p
 	pages_done = 0;
 	lock_dropped = false;
 	for (;;) {
-		ret = __get_user_pages(tsk, mm, start, nr_pages, flags, pages,
+		ret = __get_user_pages(mm, start, nr_pages, flags, pages,
 				       vmas, locked);
 		if (!locked)
 			/* VM_FAULT_RETRY couldn't trigger, bypass */
@@ -1350,7 +1345,7 @@ retry:
 		}
 
 		*locked = 1;
-		ret = __get_user_pages(tsk, mm, start, 1, flags | FOLL_TRIED,
+		ret = __get_user_pages(mm, start, 1, flags | FOLL_TRIED,
 				       pages, NULL, locked);
 		if (!*locked) {
 			/* Continue to retry until we succeeded */
@@ -1436,7 +1431,7 @@ long populate_vma_page_range(struct vm_a
 	 * We made sure addr is within a VMA, so the following will
 	 * not result in a stack expansion that recurses back here.
 	 */
-	return __get_user_pages(current, mm, start, nr_pages, gup_flags,
+	return __get_user_pages(mm, start, nr_pages, gup_flags,
 				NULL, NULL, locked);
 }
 
@@ -1520,7 +1515,7 @@ struct page *get_dump_page(unsigned long
 	struct vm_area_struct *vma;
 	struct page *page;
 
-	if (__get_user_pages(current, current->mm, addr, 1,
+	if (__get_user_pages(current->mm, addr, 1,
 			     FOLL_FORCE | FOLL_DUMP | FOLL_GET, &page, &vma,
 			     NULL) < 1)
 		return NULL;
@@ -1529,8 +1524,7 @@ struct page *get_dump_page(unsigned long
 }
 #endif /* CONFIG_ELF_CORE */
 #else /* CONFIG_MMU */
-static long __get_user_pages_locked(struct task_struct *tsk,
-		struct mm_struct *mm, unsigned long start,
+static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		unsigned long nr_pages, struct page **pages,
 		struct vm_area_struct **vmas, int *locked,
 		unsigned int foll_flags)
@@ -1646,8 +1640,7 @@ static struct page *new_non_cma_page(str
 	return __alloc_pages_node(nid, gfp_mask, 0);
 }
 
-static long check_and_migrate_cma_pages(struct task_struct *tsk,
-					struct mm_struct *mm,
+static long check_and_migrate_cma_pages(struct mm_struct *mm,
 					unsigned long start,
 					unsigned long nr_pages,
 					struct page **pages,
@@ -1721,7 +1714,7 @@ check_again:
 		 * again migrating any new CMA pages which we failed to isolate
 		 * earlier.
 		 */
-		ret = __get_user_pages_locked(tsk, mm, start, nr_pages,
+		ret = __get_user_pages_locked(mm, start, nr_pages,
 						   pages, vmas, NULL,
 						   gup_flags);
 
@@ -1735,8 +1728,7 @@ check_again:
 	return ret;
 }
 #else
-static long check_and_migrate_cma_pages(struct task_struct *tsk,
-					struct mm_struct *mm,
+static long check_and_migrate_cma_pages(struct mm_struct *mm,
 					unsigned long start,
 					unsigned long nr_pages,
 					struct page **pages,
@@ -1751,8 +1743,7 @@ static long check_and_migrate_cma_pages(
  * __gup_longterm_locked() is a wrapper for __get_user_pages_locked which
  * allows us to process the FOLL_LONGTERM flag.
  */
-static long __gup_longterm_locked(struct task_struct *tsk,
-				  struct mm_struct *mm,
+static long __gup_longterm_locked(struct mm_struct *mm,
 				  unsigned long start,
 				  unsigned long nr_pages,
 				  struct page **pages,
@@ -1777,7 +1768,7 @@ static long __gup_longterm_locked(struct
 		flags = memalloc_nocma_save();
 	}
 
-	rc = __get_user_pages_locked(tsk, mm, start, nr_pages, pages,
+	rc = __get_user_pages_locked(mm, start, nr_pages, pages,
 				     vmas_tmp, NULL, gup_flags);
 
 	if (gup_flags & FOLL_LONGTERM) {
@@ -1792,7 +1783,7 @@ static long __gup_longterm_locked(struct
 			goto out;
 		}
 
-		rc = check_and_migrate_cma_pages(tsk, mm, start, rc, pages,
+		rc = check_and_migrate_cma_pages(mm, start, rc, pages,
 						 vmas_tmp, gup_flags);
 	}
 
@@ -1802,22 +1793,20 @@ out:
 	return rc;
 }
 #else /* !CONFIG_FS_DAX && !CONFIG_CMA */
-static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
-						  struct mm_struct *mm,
+static __always_inline long __gup_longterm_locked(struct mm_struct *mm,
 						  unsigned long start,
 						  unsigned long nr_pages,
 						  struct page **pages,
 						  struct vm_area_struct **vmas,
 						  unsigned int flags)
 {
-	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
+	return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
 				       NULL, flags);
 }
 #endif /* CONFIG_FS_DAX || CONFIG_CMA */
 
 #ifdef CONFIG_MMU
-static long __get_user_pages_remote(struct task_struct *tsk,
-				    struct mm_struct *mm,
+static long __get_user_pages_remote(struct mm_struct *mm,
 				    unsigned long start, unsigned long nr_pages,
 				    unsigned int gup_flags, struct page **pages,
 				    struct vm_area_struct **vmas, int *locked)
@@ -1836,20 +1825,18 @@ static long __get_user_pages_remote(stru
 		 * This will check the vmas (even if our vmas arg is NULL)
 		 * and return -ENOTSUPP if DAX isn't allowed in this case:
 		 */
-		return __gup_longterm_locked(tsk, mm, start, nr_pages, pages,
+		return __gup_longterm_locked(mm, start, nr_pages, pages,
 					     vmas, gup_flags | FOLL_TOUCH |
 					     FOLL_REMOTE);
 	}
 
-	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
+	return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
 				       locked,
 				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 }
 
 /**
  * get_user_pages_remote() - pin user pages in memory
- * @tsk:	the task_struct to use for page fault accounting, or
- *		NULL if faults are not to be recorded.
  * @mm:		mm_struct of target mm
  * @start:	starting user address
  * @nr_pages:	number of pages from start to pin
@@ -1908,7 +1895,7 @@ static long __get_user_pages_remote(stru
  * should use get_user_pages_remote because it cannot pass
  * FAULT_FLAG_ALLOW_RETRY to handle_mm_fault.
  */
-long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
+long get_user_pages_remote(struct mm_struct *mm,
 		unsigned long start, unsigned long nr_pages,
 		unsigned int gup_flags, struct page **pages,
 		struct vm_area_struct **vmas, int *locked)
@@ -1920,13 +1907,13 @@ long get_user_pages_remote(struct task_s
 	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
 		return -EINVAL;
 
-	return __get_user_pages_remote(tsk, mm, start, nr_pages, gup_flags,
+	return __get_user_pages_remote(mm, start, nr_pages, gup_flags,
 				       pages, vmas, locked);
 }
 EXPORT_SYMBOL(get_user_pages_remote);
 
 #else /* CONFIG_MMU */
-long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
+long get_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
 			   unsigned int gup_flags, struct page **pages,
 			   struct vm_area_struct **vmas, int *locked)
@@ -1934,8 +1921,7 @@ long get_user_pages_remote(struct task_s
 	return 0;
 }
 
-static long __get_user_pages_remote(struct task_struct *tsk,
-				    struct mm_struct *mm,
+static long __get_user_pages_remote(struct mm_struct *mm,
 				    unsigned long start, unsigned long nr_pages,
 				    unsigned int gup_flags, struct page **pages,
 				    struct vm_area_struct **vmas, int *locked)
@@ -1955,11 +1941,10 @@ static long __get_user_pages_remote(stru
  * @vmas:       array of pointers to vmas corresponding to each page.
  *              Or NULL if the caller does not require them.
  *
- * This is the same as get_user_pages_remote(), just with a
- * less-flexible calling convention where we assume that the task
- * and mm being operated on are the current task's and don't allow
- * passing of a locked parameter.  We also obviously don't pass
- * FOLL_REMOTE in here.
+ * This is the same as get_user_pages_remote(), just with a less-flexible
+ * calling convention where we assume that the mm being operated on belongs to
+ * the current task, and doesn't allow passing of a locked parameter.  We also
+ * obviously don't pass FOLL_REMOTE in here.
  */
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 		unsigned int gup_flags, struct page **pages,
@@ -1972,7 +1957,7 @@ long get_user_pages(unsigned long start,
 	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
 		return -EINVAL;
 
-	return __gup_longterm_locked(current, current->mm, start, nr_pages,
+	return __gup_longterm_locked(current->mm, start, nr_pages,
 				     pages, vmas, gup_flags | FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages);
@@ -1982,7 +1967,7 @@ EXPORT_SYMBOL(get_user_pages);
  *
  *      mmap_read_lock(mm);
  *      do_something()
- *      get_user_pages(tsk, mm, ..., pages, NULL);
+ *      get_user_pages(mm, ..., pages, NULL);
  *      mmap_read_unlock(mm);
  *
  *  to:
@@ -1990,7 +1975,7 @@ EXPORT_SYMBOL(get_user_pages);
  *      int locked = 1;
  *      mmap_read_lock(mm);
  *      do_something()
- *      get_user_pages_locked(tsk, mm, ..., pages, &locked);
+ *      get_user_pages_locked(mm, ..., pages, &locked);
  *      if (locked)
  *          mmap_read_unlock(mm);
  *
@@ -2028,7 +2013,7 @@ long get_user_pages_locked(unsigned long
 	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
 		return -EINVAL;
 
-	return __get_user_pages_locked(current, current->mm, start, nr_pages,
+	return __get_user_pages_locked(current->mm, start, nr_pages,
 				       pages, NULL, locked,
 				       gup_flags | FOLL_TOUCH);
 }
@@ -2038,12 +2023,12 @@ EXPORT_SYMBOL(get_user_pages_locked);
  * get_user_pages_unlocked() is suitable to replace the form:
  *
  *      mmap_read_lock(mm);
- *      get_user_pages(tsk, mm, ..., pages, NULL);
+ *      get_user_pages(mm, ..., pages, NULL);
  *      mmap_read_unlock(mm);
  *
  *  with:
  *
- *      get_user_pages_unlocked(tsk, mm, ..., pages);
+ *      get_user_pages_unlocked(mm, ..., pages);
  *
  * It is functionally equivalent to get_user_pages_fast so
  * get_user_pages_fast should be used instead if specific gup_flags
@@ -2066,7 +2051,7 @@ long get_user_pages_unlocked(unsigned lo
 		return -EINVAL;
 
 	mmap_read_lock(mm);
-	ret = __get_user_pages_locked(current, mm, start, nr_pages, pages, NULL,
+	ret = __get_user_pages_locked(mm, start, nr_pages, pages, NULL,
 				      &locked, gup_flags | FOLL_TOUCH);
 	if (locked)
 		mmap_read_unlock(mm);
@@ -2711,7 +2696,7 @@ static int __gup_longterm_unlocked(unsig
 	 */
 	if (gup_flags & FOLL_LONGTERM) {
 		mmap_read_lock(current->mm);
-		ret = __gup_longterm_locked(current, current->mm,
+		ret = __gup_longterm_locked(current->mm,
 					    start, nr_pages,
 					    pages, NULL, gup_flags);
 		mmap_read_unlock(current->mm);
@@ -2954,10 +2939,8 @@ int pin_user_pages_fast_only(unsigned lo
 EXPORT_SYMBOL_GPL(pin_user_pages_fast_only);
 
 /**
- * pin_user_pages_remote() - pin pages of a remote process (task != current)
+ * pin_user_pages_remote() - pin pages of a remote process
  *
- * @tsk:	the task_struct to use for page fault accounting, or
- *		NULL if faults are not to be recorded.
  * @mm:		mm_struct of target mm
  * @start:	starting user address
  * @nr_pages:	number of pages from start to pin
@@ -2978,7 +2961,7 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast_on
  * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
  * see Documentation/core-api/pin_user_pages.rst for details.
  */
-long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
+long pin_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
 			   unsigned int gup_flags, struct page **pages,
 			   struct vm_area_struct **vmas, int *locked)
@@ -2988,7 +2971,7 @@ long pin_user_pages_remote(struct task_s
 		return -EINVAL;
 
 	gup_flags |= FOLL_PIN;
-	return __get_user_pages_remote(tsk, mm, start, nr_pages, gup_flags,
+	return __get_user_pages_remote(mm, start, nr_pages, gup_flags,
 				       pages, vmas, locked);
 }
 EXPORT_SYMBOL(pin_user_pages_remote);
@@ -3020,7 +3003,7 @@ long pin_user_pages(unsigned long start,
 		return -EINVAL;
 
 	gup_flags |= FOLL_PIN;
-	return __gup_longterm_locked(current, current->mm, start, nr_pages,
+	return __gup_longterm_locked(current->mm, start, nr_pages,
 				     pages, vmas, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages);
@@ -3065,7 +3048,7 @@ long pin_user_pages_locked(unsigned long
 		return -EINVAL;
 
 	gup_flags |= FOLL_PIN;
-	return __get_user_pages_locked(current, current->mm, start, nr_pages,
+	return __get_user_pages_locked(current->mm, start, nr_pages,
 				       pages, NULL, locked,
 				       gup_flags | FOLL_TOUCH);
 }
--- a/mm/memory.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/mm/memory.c
@@ -4751,7 +4751,7 @@ int __access_remote_vm(struct task_struc
 		void *maddr;
 		struct page *page = NULL;
 
-		ret = get_user_pages_remote(tsk, mm, addr, 1,
+		ret = get_user_pages_remote(mm, addr, 1,
 				gup_flags, &page, &vma, NULL);
 		if (ret <= 0) {
 #ifndef CONFIG_HAVE_IOREMAP_PROT
--- a/mm/process_vm_access.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/mm/process_vm_access.c
@@ -105,7 +105,7 @@ static int process_vm_rw_single_vec(unsi
 		 * current/current->mm
 		 */
 		mmap_read_lock(mm);
-		pinned_pages = pin_user_pages_remote(task, mm, pa, pinned_pages,
+		pinned_pages = pin_user_pages_remote(mm, pa, pinned_pages,
 						     flags, process_pages,
 						     NULL, &locked);
 		if (locked)
--- a/security/tomoyo/domain.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/security/tomoyo/domain.c
@@ -914,7 +914,7 @@ bool tomoyo_dump_page(struct linux_binpr
 	 * (represented by bprm).  'current' is the process doing
 	 * the execve().
 	 */
-	if (get_user_pages_remote(current, bprm->mm, pos, 1,
+	if (get_user_pages_remote(bprm->mm, pos, 1,
 				FOLL_FORCE, &page, NULL, NULL) <= 0)
 		return false;
 #else
--- a/virt/kvm/async_pf.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/virt/kvm/async_pf.c
@@ -61,7 +61,7 @@ static void async_pf_execute(struct work
 	 * access remotely.
 	 */
 	mmap_read_lock(mm);
-	get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
+	get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, NULL,
 			&locked);
 	if (locked)
 		mmap_read_unlock(mm);
--- a/virt/kvm/kvm_main.c~mm-gup-remove-task_struct-pointer-for-all-gup-code
+++ a/virt/kvm/kvm_main.c
@@ -1830,7 +1830,7 @@ static int hva_to_pfn_remapped(struct vm
 		 * not call the fault handler, so do it here.
 		 */
 		bool unlocked = false;
-		r = fixup_user_fault(current, current->mm, addr,
+		r = fixup_user_fault(current->mm, addr,
 				     (write_fault ? FAULT_FLAG_WRITE : 0),
 				     &unlocked);
 		if (unlocked)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-do-page-fault-accounting-in-handle_mm_fault.patch
mm-alpha-use-general-page-fault-accounting.patch
mm-arc-use-general-page-fault-accounting.patch
mm-arm-use-general-page-fault-accounting.patch
mm-arm64-use-general-page-fault-accounting.patch
mm-csky-use-general-page-fault-accounting.patch
mm-hexagon-use-general-page-fault-accounting.patch
mm-ia64-use-general-page-fault-accounting.patch
mm-m68k-use-general-page-fault-accounting.patch
mm-microblaze-use-general-page-fault-accounting.patch
mm-mips-use-general-page-fault-accounting.patch
mm-nds32-use-general-page-fault-accounting.patch
mm-nios2-use-general-page-fault-accounting.patch
mm-openrisc-use-general-page-fault-accounting.patch
mm-parisc-use-general-page-fault-accounting.patch
mm-powerpc-use-general-page-fault-accounting.patch
mm-riscv-use-general-page-fault-accounting.patch
mm-s390-use-general-page-fault-accounting.patch
mm-sh-use-general-page-fault-accounting.patch
mm-sparc32-use-general-page-fault-accounting.patch
mm-sparc64-use-general-page-fault-accounting.patch
mm-x86-use-general-page-fault-accounting.patch
mm-xtensa-use-general-page-fault-accounting.patch
mm-clean-up-the-last-pieces-of-page-fault-accountings.patch
mm-gup-remove-task_struct-pointer-for-all-gup-code.patch
