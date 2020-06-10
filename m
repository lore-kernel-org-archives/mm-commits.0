From: akpm@linux-foundation.org
Subject: [merged] mmap-locking-api-convert-mmap_sem-comments.patch
 removed from -mm tree
Date: Tue, 09 Jun 2020 17:39:47 -0700
Message-ID: <20200610003947.Ts78S_PLx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgFJAjy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap locking API: convert mmap_sem comments
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-convert-mmap_sem-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mmap locking API: convert mmap_sem comments

Convert comments that reference mmap_sem to reference mmap_lock instead.

[akpm@linux-foundation.org: fix up linux-next leftovers]
[akpm@linux-foundation.org: s/lockaphore/lock/, per Vlastimil]
[akpm@linux-foundation.org: more linux-next fixups, per Michel]
Link: http://lkml.kernel.org/r/20200520052908.204642-13-walken@google.com
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/numa_memory_policy.rst |   10 +-
 Documentation/admin-guide/mm/userfaultfd.rst        |    2 
 Documentation/filesystems/locking.rst               |    2 
 Documentation/vm/transhuge.rst                      |    4 -
 arch/arc/mm/fault.c                                 |    2 
 arch/arm/kernel/vdso.c                              |    2 
 arch/arm/mm/fault.c                                 |    2 
 arch/ia64/mm/fault.c                                |    2 
 arch/microblaze/mm/fault.c                          |    2 
 arch/nds32/mm/fault.c                               |    2 
 arch/powerpc/include/asm/pkeys.h                    |    2 
 arch/powerpc/kvm/book3s_hv_uvmem.c                  |    6 -
 arch/powerpc/mm/book3s32/tlb.c                      |    2 
 arch/powerpc/mm/book3s64/hash_pgtable.c             |    4 -
 arch/powerpc/mm/book3s64/subpage_prot.c             |    2 
 arch/powerpc/mm/fault.c                             |   10 +-
 arch/powerpc/mm/pgtable.c                           |    2 
 arch/powerpc/platforms/cell/spufs/file.c            |    6 -
 arch/riscv/mm/fault.c                               |    2 
 arch/s390/kvm/priv.c                                |    2 
 arch/s390/mm/fault.c                                |    2 
 arch/s390/mm/gmap.c                                 |   32 ++++----
 arch/s390/mm/pgalloc.c                              |    2 
 arch/sh/mm/cache-sh4.c                              |    2 
 arch/sh/mm/fault.c                                  |    2 
 arch/sparc/mm/fault_64.c                            |    2 
 arch/um/kernel/skas/mmu.c                           |    2 
 arch/um/kernel/tlb.c                                |    2 
 arch/unicore32/mm/fault.c                           |    2 
 arch/x86/events/core.c                              |    2 
 arch/x86/include/asm/mmu.h                          |    2 
 arch/x86/include/asm/pgtable-3level.h               |    8 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c           |    6 -
 arch/x86/kernel/cpu/resctrl/rdtgroup.c              |    6 -
 arch/x86/kernel/ldt.c                               |    2 
 arch/x86/mm/fault.c                                 |   12 +--
 drivers/char/mspec.c                                |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h          |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c   |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c   |    2 
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c         |    6 -
 drivers/gpu/drm/i915/i915_perf.c                    |    2 
 drivers/gpu/drm/ttm/ttm_bo_vm.c                     |    6 -
 drivers/infiniband/core/uverbs_main.c               |    2 
 drivers/infiniband/hw/hfi1/mmu_rb.c                 |    2 
 drivers/media/v4l2-core/videobuf-dma-sg.c           |    2 
 drivers/misc/cxl/cxllib.c                           |    5 -
 drivers/misc/sgi-gru/grufault.c                     |    8 +-
 drivers/oprofile/buffer_sync.c                      |    2 
 drivers/staging/android/ashmem.c                    |    4 -
 drivers/staging/comedi/comedi_fops.c                |    2 
 drivers/tty/vt/consolemap.c                         |    2 
 drivers/vfio/pci/vfio_pci.c                         |   14 +--
 drivers/xen/gntdev.c                                |    2 
 fs/coredump.c                                       |    4 -
 fs/exec.c                                           |    2 
 fs/ext2/file.c                                      |    2 
 fs/ext4/super.c                                     |    6 -
 fs/kernfs/file.c                                    |    4 -
 fs/proc/base.c                                      |    6 -
 fs/proc/task_mmu.c                                  |    6 -
 fs/userfaultfd.c                                    |   18 ++--
 fs/xfs/xfs_file.c                                   |    2 
 fs/xfs/xfs_inode.c                                  |   14 +--
 fs/xfs/xfs_iops.c                                   |    4 -
 include/linux/fs.h                                  |    4 -
 include/linux/huge_mm.h                             |    2 
 include/linux/mempolicy.h                           |    2 
 include/linux/mm.h                                  |   10 +-
 include/linux/mm_types.h                            |    2 
 include/linux/mmu_notifier.h                        |    8 +-
 include/linux/pagemap.h                             |    2 
 include/linux/pgtable.h                             |    6 -
 include/linux/rmap.h                                |    2 
 include/linux/sched/mm.h                            |   10 +-
 kernel/acct.c                                       |    2 
 kernel/cgroup/cpuset.c                              |    4 -
 kernel/events/core.c                                |    6 -
 kernel/events/uprobes.c                             |    4 -
 kernel/exit.c                                       |    2 
 kernel/relay.c                                      |    2 
 kernel/sys.c                                        |    4 -
 lib/test_lockup.c                                   |    8 +-
 mm/filemap.c                                        |   38 ++++-----
 mm/frame_vector.c                                   |    2 
 mm/gup.c                                            |   38 ++++-----
 mm/huge_memory.c                                    |    4 -
 mm/hugetlb.c                                        |    2 
 mm/internal.h                                       |    4 -
 mm/khugepaged.c                                     |   34 ++++----
 mm/ksm.c                                            |   12 +--
 mm/maccess.c                                        |    4 -
 mm/madvise.c                                        |   20 ++---
 mm/memcontrol.c                                     |    2 
 mm/memory.c                                         |   40 +++++-----
 mm/mempolicy.c                                      |   12 +--
 mm/migrate.c                                        |    4 -
 mm/mlock.c                                          |    6 -
 mm/mmap.c                                           |   36 ++++-----
 mm/mmu_gather.c                                     |    2 
 mm/mmu_notifier.c                                   |   10 +-
 mm/mprotect.c                                       |    8 +-
 mm/mremap.c                                         |    8 +-
 mm/nommu.c                                          |    6 -
 mm/oom_kill.c                                       |    2 
 mm/pagewalk.c                                       |    6 -
 mm/rmap.c                                           |   12 +--
 mm/shmem.c                                          |    4 -
 mm/swap_state.c                                     |    4 -
 mm/userfaultfd.c                                    |    8 +-
 mm/util.c                                           |    2 
 security/keys/keyctl.c                              |    2 
 sound/core/oss/pcm_oss.c                            |    2 
 113 files changed, 351 insertions(+), 352 deletions(-)

--- a/arch/arc/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/arc/mm/fault.c
@@ -141,7 +141,7 @@ retry:
 	}
 
 	/*
-	 * Fault retry nuances, mmap_sem already relinquished by core mm
+	 * Fault retry nuances, mmap_lock already relinquished by core mm
 	 */
 	if (unlikely((fault & VM_FAULT_RETRY) &&
 		     (flags & FAULT_FLAG_ALLOW_RETRY))) {
--- a/arch/arm/kernel/vdso.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/arm/kernel/vdso.c
@@ -240,7 +240,7 @@ static int install_vvar(struct mm_struct
 	return PTR_ERR_OR_ZERO(vma);
 }
 
-/* assumes mmap_sem is write-locked */
+/* assumes mmap_lock is write-locked */
 void arm_install_vdso(struct mm_struct *mm, unsigned long addr)
 {
 	struct vm_area_struct *vma;
--- a/arch/arm/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/arm/mm/fault.c
@@ -293,7 +293,7 @@ retry:
 	fault = __do_page_fault(mm, addr, fsr, flags, tsk);
 
 	/* If we need to retry but a fatal signal is pending, handle the
-	 * signal first. We do not need to release the mmap_sem because
+	 * signal first. We do not need to release the mmap_lock because
 	 * it would already be released in __lock_page_or_retry in
 	 * mm/filemap.c. */
 	if (fault_signal_pending(fault, regs)) {
--- a/arch/ia64/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/ia64/mm/fault.c
@@ -86,7 +86,7 @@ ia64_do_page_fault (unsigned long addres
 #ifdef CONFIG_VIRTUAL_MEM_MAP
 	/*
 	 * If fault is in region 5 and we are in the kernel, we may already
-	 * have the mmap_sem (pfn_valid macro is called during mmap). There
+	 * have the mmap_lock (pfn_valid macro is called during mmap). There
 	 * is no vma for region 5 addr's anyway, so skip getting the semaphore
 	 * and go directly to the exception handling code.
 	 */
--- a/arch/microblaze/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/microblaze/mm/fault.c
@@ -124,7 +124,7 @@ void do_page_fault(struct pt_regs *regs,
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
-	 * erroneous fault occurring in a code path which already holds mmap_sem
+	 * erroneous fault occurring in a code path which already holds mmap_lock
 	 * we will deadlock attempting to validate the fault against the
 	 * address space.  Luckily the kernel only validly references user
 	 * space from well defined areas of code, which are listed in the
--- a/arch/nds32/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/nds32/mm/fault.c
@@ -210,7 +210,7 @@ good_area:
 
 	/*
 	 * If we need to retry but a fatal signal is pending, handle the
-	 * signal first. We do not need to release the mmap_sem because it
+	 * signal first. We do not need to release the mmap_lock because it
 	 * would already be released in __lock_page_or_retry in mm/filemap.c.
 	 */
 	if (fault_signal_pending(fault, regs)) {
--- a/arch/powerpc/include/asm/pkeys.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/powerpc/include/asm/pkeys.h
@@ -101,7 +101,7 @@ static inline bool mm_pkey_is_allocated(
 
 /*
  * Returns a positive, 5-bit key on success, or -1 on failure.
- * Relies on the mmap_sem to protect against concurrency in mm_pkey_alloc() and
+ * Relies on the mmap_lock to protect against concurrency in mm_pkey_alloc() and
  * mm_pkey_free().
  */
 static inline int mm_pkey_alloc(struct mm_struct *mm)
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -47,7 +47,7 @@
  * Locking order
  *
  * 1. kvm->srcu - Protects KVM memslots
- * 2. kvm->mm->mmap_sem - find_vma, migrate_vma_pages and helpers, ksm_madvise
+ * 2. kvm->mm->mmap_lock - find_vma, migrate_vma_pages and helpers, ksm_madvise
  * 3. kvm->arch.uvmem_lock - protects read/writes to uvmem slots thus acting
  *			     as sync-points for page-in/out
  */
@@ -402,8 +402,8 @@ kvmppc_svm_page_in(struct vm_area_struct
 	mig.dst = &dst_pfn;
 
 	/*
-	 * We come here with mmap_sem write lock held just for
-	 * ksm_madvise(), otherwise we only need read mmap_sem.
+	 * We come here with mmap_lock write lock held just for
+	 * ksm_madvise(), otherwise we only need read mmap_lock.
 	 * Hence downgrade to read lock once ksm_madvise() is done.
 	 */
 	ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
--- a/arch/powerpc/mm/book3s32/tlb.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/powerpc/mm/book3s32/tlb.c
@@ -129,7 +129,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 
 	/*
 	 * It is safe to go down the mm's list of vmas when called
-	 * from dup_mmap, holding mmap_sem.  It would also be safe from
+	 * from dup_mmap, holding mmap_lock.  It would also be safe from
 	 * unmap_region or exit_mmap, but not from vmtruncate on SMP -
 	 * but it seems dup_mmap is the only SMP case which gets here.
 	 */
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -237,7 +237,7 @@ pmd_t hash__pmdp_collapse_flush(struct v
 	 * to hugepage, we first clear the pmd, then invalidate all
 	 * the PTE entries. The assumption here is that any low level
 	 * page fault will see a none pmd and take the slow path that
-	 * will wait on mmap_sem. But we could very well be in a
+	 * will wait on mmap_lock. But we could very well be in a
 	 * hash_page with local ptep pointer value. Such a hash page
 	 * can result in adding new HPTE entries for normal subpages.
 	 * That means we could be modifying the page content as we
@@ -251,7 +251,7 @@ pmd_t hash__pmdp_collapse_flush(struct v
 	 * Now invalidate the hpte entries in the range
 	 * covered by pmd. This make sure we take a
 	 * fault and will find the pmd as none, which will
-	 * result in a major fault which takes mmap_sem and
+	 * result in a major fault which takes mmap_lock and
 	 * hence wait for collapse to complete. Without this
 	 * the __collapse_huge_page_copy can result in copying
 	 * the old content.
--- a/arch/powerpc/mm/book3s64/subpage_prot.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/powerpc/mm/book3s64/subpage_prot.c
@@ -225,7 +225,7 @@ SYSCALL_DEFINE3(subpage_prot, unsigned l
 	if (!spt) {
 		/*
 		 * Allocate subpage prot table if not already done.
-		 * Do this with mmap_sem held
+		 * Do this with mmap_lock held
 		 */
 		spt = kzalloc(sizeof(struct subpage_prot_table), GFP_KERNEL);
 		if (!spt) {
--- a/arch/powerpc/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/powerpc/mm/fault.c
@@ -138,7 +138,7 @@ static noinline int bad_access_pkey(stru
 	 * 2. T1   : set AMR to deny access to pkey=4, touches, page
 	 * 3. T1   : faults...
 	 * 4.    T2: mprotect_key(foo, PAGE_SIZE, pkey=5);
-	 * 5. T1   : enters fault handler, takes mmap_sem, etc...
+	 * 5. T1   : enters fault handler, takes mmap_lock, etc...
 	 * 6. T1   : reaches here, sees vma_pkey(vma)=5, when we really
 	 *	     faulted on a pte with its pkey=4.
 	 */
@@ -525,9 +525,9 @@ static int __do_page_fault(struct pt_reg
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
 	/*
-	 * We want to do this outside mmap_sem, because reading code around nip
+	 * We want to do this outside mmap_lock, because reading code around nip
 	 * can result in fault, which will cause a deadlock when called with
-	 * mmap_sem held
+	 * mmap_lock held
 	 */
 	if (is_user)
 		flags |= FAULT_FLAG_USER;
@@ -539,7 +539,7 @@ static int __do_page_fault(struct pt_reg
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
-	 * erroneous fault occurring in a code path which already holds mmap_sem
+	 * erroneous fault occurring in a code path which already holds mmap_lock
 	 * we will deadlock attempting to validate the fault against the
 	 * address space.  Luckily the kernel only validly references user
 	 * space from well defined areas of code, which are listed in the
@@ -615,7 +615,7 @@ good_area:
 		return user_mode(regs) ? 0 : SIGBUS;
 
 	/*
-	 * Handle the retry right now, the mmap_sem has been released in that
+	 * Handle the retry right now, the mmap_lock has been released in that
 	 * case.
 	 */
 	if (unlikely(fault & VM_FAULT_RETRY)) {
--- a/arch/powerpc/mm/pgtable.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/powerpc/mm/pgtable.c
@@ -306,7 +306,7 @@ void assert_pte_locked(struct mm_struct
 	pmd = pmd_offset(pud, addr);
 	/*
 	 * khugepaged to collapse normal pages to hugepage, first set
-	 * pmd to none to force page fault/gup to take mmap_sem. After
+	 * pmd to none to force page fault/gup to take mmap_lock. After
 	 * pmd is set to none, we do a pte_clear which does this assertion
 	 * so if we find pmd none, return.
 	 */
--- a/arch/powerpc/platforms/cell/spufs/file.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -325,7 +325,7 @@ static vm_fault_t spufs_ps_fault(struct
 		return VM_FAULT_SIGBUS;
 
 	/*
-	 * Because we release the mmap_sem, the context may be destroyed while
+	 * Because we release the mmap_lock, the context may be destroyed while
 	 * we're in spu_wait. Grab an extra reference so it isn't destroyed
 	 * in the meantime.
 	 */
@@ -334,8 +334,8 @@ static vm_fault_t spufs_ps_fault(struct
 	/*
 	 * We have to wait for context to be loaded before we have
 	 * pages to hand out to the user, but we don't want to wait
-	 * with the mmap_sem held.
-	 * It is possible to drop the mmap_sem here, but then we need
+	 * with the mmap_lock held.
+	 * It is possible to drop the mmap_lock here, but then we need
 	 * to return VM_FAULT_NOPAGE because the mappings may have
 	 * hanged.
 	 */
--- a/arch/riscv/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/riscv/mm/fault.c
@@ -114,7 +114,7 @@ good_area:
 
 	/*
 	 * If we need to retry but a fatal signal is pending, handle the
-	 * signal first. We do not need to release the mmap_sem because it
+	 * signal first. We do not need to release the mmap_lock because it
 	 * would already be released in __lock_page_or_retry in mm/filemap.c.
 	 */
 	if (fault_signal_pending(fault, regs))
--- a/arch/s390/kvm/priv.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/s390/kvm/priv.c
@@ -1122,7 +1122,7 @@ static int handle_pfmf(struct kvm_vcpu *
 }
 
 /*
- * Must be called with relevant read locks held (kvm->mm->mmap_sem, kvm->srcu)
+ * Must be called with relevant read locks held (kvm->mm->mmap_lock, kvm->srcu)
  */
 static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 {
--- a/arch/s390/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/s390/mm/fault.c
@@ -507,7 +507,7 @@ retry:
 			if (IS_ENABLED(CONFIG_PGSTE) && gmap &&
 			    (flags & FAULT_FLAG_RETRY_NOWAIT)) {
 				/* FAULT_FLAG_RETRY_NOWAIT has been set,
-				 * mmap_sem has not been released */
+				 * mmap_lock has not been released */
 				current->thread.gmap_pfault = 1;
 				fault = VM_FAULT_PFAULT;
 				goto out_up;
--- a/arch/s390/mm/gmap.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/s390/mm/gmap.c
@@ -300,7 +300,7 @@ struct gmap *gmap_get_enabled(void)
 EXPORT_SYMBOL_GPL(gmap_get_enabled);
 
 /*
- * gmap_alloc_table is assumed to be called with mmap_sem held
+ * gmap_alloc_table is assumed to be called with mmap_lock held
  */
 static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
 			    unsigned long init, unsigned long gaddr)
@@ -466,7 +466,7 @@ EXPORT_SYMBOL_GPL(gmap_map_segment);
  * Returns user space address which corresponds to the guest address or
  * -EFAULT if no such mapping exists.
  * This function does not establish potentially missing page table entries.
- * The mmap_sem of the mm that belongs to the address space must be held
+ * The mmap_lock of the mm that belongs to the address space must be held
  * when this function gets called.
  *
  * Note: Can also be called for shadow gmaps.
@@ -534,7 +534,7 @@ static void gmap_pmdp_xchg(struct gmap *
  *
  * Returns 0 on success, -ENOMEM for out of memory conditions, and -EFAULT
  * if the vm address is already mapped to a different guest segment.
- * The mmap_sem of the mm that belongs to the address space must be held
+ * The mmap_lock of the mm that belongs to the address space must be held
  * when this function gets called.
  */
 int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
@@ -655,7 +655,7 @@ retry:
 		goto out_up;
 	}
 	/*
-	 * In the case that fixup_user_fault unlocked the mmap_sem during
+	 * In the case that fixup_user_fault unlocked the mmap_lock during
 	 * faultin redo __gmap_translate to not race with a map/unmap_segment.
 	 */
 	if (unlocked)
@@ -669,7 +669,7 @@ out_up:
 EXPORT_SYMBOL_GPL(gmap_fault);
 
 /*
- * this function is assumed to be called with mmap_sem held
+ * this function is assumed to be called with mmap_lock held
  */
 void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 {
@@ -882,7 +882,7 @@ static int gmap_pte_op_fixup(struct gmap
 	if (fixup_user_fault(current, mm, vmaddr, fault_flags, &unlocked))
 		return -EFAULT;
 	if (unlocked)
-		/* lost mmap_sem, caller has to retry __gmap_translate */
+		/* lost mmap_lock, caller has to retry __gmap_translate */
 		return 0;
 	/* Connect the page tables */
 	return __gmap_link(gmap, gaddr, vmaddr);
@@ -953,7 +953,7 @@ static inline void gmap_pmd_op_end(struc
  * -EAGAIN if a fixup is needed
  * -EINVAL if unsupported notifier bits have been specified
  *
- * Expected to be called with sg->mm->mmap_sem in read and
+ * Expected to be called with sg->mm->mmap_lock in read and
  * guest_table_lock held.
  */
 static int gmap_protect_pmd(struct gmap *gmap, unsigned long gaddr,
@@ -999,7 +999,7 @@ static int gmap_protect_pmd(struct gmap
  * Returns 0 if successfully protected, -ENOMEM if out of memory and
  * -EAGAIN if a fixup is needed.
  *
- * Expected to be called with sg->mm->mmap_sem in read
+ * Expected to be called with sg->mm->mmap_lock in read
  */
 static int gmap_protect_pte(struct gmap *gmap, unsigned long gaddr,
 			    pmd_t *pmdp, int prot, unsigned long bits)
@@ -1035,7 +1035,7 @@ static int gmap_protect_pte(struct gmap
  * Returns 0 if successfully protected, -ENOMEM if out of memory and
  * -EFAULT if gaddr is invalid (or mapping for shadows is missing).
  *
- * Called with sg->mm->mmap_sem in read.
+ * Called with sg->mm->mmap_lock in read.
  */
 static int gmap_protect_range(struct gmap *gmap, unsigned long gaddr,
 			      unsigned long len, int prot, unsigned long bits)
@@ -1124,7 +1124,7 @@ EXPORT_SYMBOL_GPL(gmap_mprotect_notify);
  * if reading using the virtual address failed. -EINVAL if called on a gmap
  * shadow.
  *
- * Called with gmap->mm->mmap_sem in read.
+ * Called with gmap->mm->mmap_lock in read.
  */
 int gmap_read_table(struct gmap *gmap, unsigned long gaddr, unsigned long *val)
 {
@@ -1729,7 +1729,7 @@ EXPORT_SYMBOL_GPL(gmap_shadow);
  * shadow table structure is incomplete, -ENOMEM if out of memory and
  * -EFAULT if an address in the parent gmap could not be resolved.
  *
- * Called with sg->mm->mmap_sem in read.
+ * Called with sg->mm->mmap_lock in read.
  */
 int gmap_shadow_r2t(struct gmap *sg, unsigned long saddr, unsigned long r2t,
 		    int fake)
@@ -1813,7 +1813,7 @@ EXPORT_SYMBOL_GPL(gmap_shadow_r2t);
  * shadow table structure is incomplete, -ENOMEM if out of memory and
  * -EFAULT if an address in the parent gmap could not be resolved.
  *
- * Called with sg->mm->mmap_sem in read.
+ * Called with sg->mm->mmap_lock in read.
  */
 int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 		    int fake)
@@ -1897,7 +1897,7 @@ EXPORT_SYMBOL_GPL(gmap_shadow_r3t);
  * shadow table structure is incomplete, -ENOMEM if out of memory and
  * -EFAULT if an address in the parent gmap could not be resolved.
  *
- * Called with sg->mm->mmap_sem in read.
+ * Called with sg->mm->mmap_lock in read.
  */
 int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 		    int fake)
@@ -1981,7 +1981,7 @@ EXPORT_SYMBOL_GPL(gmap_shadow_sgt);
  * Returns 0 if the shadow page table was found and -EAGAIN if the page
  * table was not found.
  *
- * Called with sg->mm->mmap_sem in read.
+ * Called with sg->mm->mmap_lock in read.
  */
 int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr,
 			   unsigned long *pgt, int *dat_protection,
@@ -2021,7 +2021,7 @@ EXPORT_SYMBOL_GPL(gmap_shadow_pgt_lookup
  * shadow table structure is incomplete, -ENOMEM if out of memory,
  * -EFAULT if an address in the parent gmap could not be resolved and
  *
- * Called with gmap->mm->mmap_sem in read
+ * Called with gmap->mm->mmap_lock in read
  */
 int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 		    int fake)
@@ -2100,7 +2100,7 @@ EXPORT_SYMBOL_GPL(gmap_shadow_pgt);
  * shadow table structure is incomplete, -ENOMEM if out of memory and
  * -EFAULT if an address in the parent gmap could not be resolved.
  *
- * Called with sg->mm->mmap_sem in read.
+ * Called with sg->mm->mmap_lock in read.
  */
 int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte)
 {
--- a/arch/s390/mm/pgalloc.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/s390/mm/pgalloc.c
@@ -114,7 +114,7 @@ int crst_table_upgrade(struct mm_struct
 	spin_lock_bh(&mm->page_table_lock);
 
 	/*
-	 * This routine gets called with mmap_sem lock held and there is
+	 * This routine gets called with mmap_lock lock held and there is
 	 * no reason to optimize for the case of otherwise. However, if
 	 * that would ever change, the below check will let us know.
 	 */
--- a/arch/sh/mm/cache-sh4.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/sh/mm/cache-sh4.c
@@ -182,7 +182,7 @@ static void sh4_flush_cache_all(void *un
  * accessed with (hence cache set) is in accord with the physical
  * address (i.e. tag).  It's no different here.
  *
- * Caller takes mm->mmap_sem.
+ * Caller takes mm->mmap_lock.
  */
 static void sh4_flush_cache_mm(void *arg)
 {
--- a/arch/sh/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/sh/mm/fault.c
@@ -326,7 +326,7 @@ mm_fault_error(struct pt_regs *regs, uns
 		return 1;
 	}
 
-	/* Release mmap_sem first if necessary */
+	/* Release mmap_lock first if necessary */
 	if (!(fault & VM_FAULT_RETRY))
 		mmap_read_unlock(current->mm);
 
--- a/arch/sparc/mm/fault_64.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/sparc/mm/fault_64.c
@@ -70,7 +70,7 @@ static void __kprobes bad_kernel_pc(stru
 }
 
 /*
- * We now make sure that mmap_sem is held in all paths that call 
+ * We now make sure that mmap_lock is held in all paths that call
  * this. Additionally, to prevent kswapd from ripping ptes from
  * under us, raise interrupts around the time that we look at the
  * pte, kswapd will have to wait to get his smp ipi response from
--- a/arch/um/kernel/skas/mmu.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/um/kernel/skas/mmu.c
@@ -114,7 +114,7 @@ void uml_setup_stubs(struct mm_struct *m
 	mm->context.stub_pages[0] = virt_to_page(__syscall_stub_start);
 	mm->context.stub_pages[1] = virt_to_page(mm->context.id.stack);
 
-	/* dup_mmap already holds mmap_sem */
+	/* dup_mmap already holds mmap_lock */
 	err = install_special_mapping(mm, STUB_START, STUB_END - STUB_START,
 				      VM_READ | VM_MAYREAD | VM_EXEC |
 				      VM_MAYEXEC | VM_DONTCOPY | VM_PFNMAP,
--- a/arch/um/kernel/tlb.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/um/kernel/tlb.c
@@ -348,7 +348,7 @@ void fix_range_common(struct mm_struct *
 	if (ret) {
 		printk(KERN_ERR "fix_range_common: failed, killing current "
 		       "process: %d\n", task_tgid_vnr(current));
-		/* We are under mmap_sem, release it such that current can terminate */
+		/* We are under mmap_lock, release it such that current can terminate */
 		mmap_write_unlock(current->mm);
 		force_sig(SIGKILL);
 		do_signal(&current->thread.regs);
--- a/arch/unicore32/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/unicore32/mm/fault.c
@@ -246,7 +246,7 @@ retry:
 	fault = __do_pf(mm, addr, fsr, flags, tsk);
 
 	/* If we need to retry but a fatal signal is pending, handle the
-	 * signal first. We do not need to release the mmap_sem because
+	 * signal first. We do not need to release the mmap_lock because
 	 * it would already be released in __lock_page_or_retry in
 	 * mm/filemap.c. */
 	if (fault_signal_pending(fault, regs))
--- a/arch/x86/events/core.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/x86/events/core.c
@@ -2178,7 +2178,7 @@ static void x86_pmu_event_mapped(struct
 	 * userspace with CR4.PCE clear while another task is still
 	 * doing on_each_cpu_mask() to propagate CR4.PCE.
 	 *
-	 * For now, this can't happen because all callers hold mmap_sem
+	 * For now, this can't happen because all callers hold mmap_lock
 	 * for write.  If this changes, we'll need a different solution.
 	 */
 	mmap_assert_write_locked(mm);
--- a/arch/x86/include/asm/mmu.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/x86/include/asm/mmu.h
@@ -45,7 +45,7 @@ typedef struct {
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
 	/*
 	 * One bit per protection key says whether userspace can
-	 * use it or not.  protected by mmap_sem.
+	 * use it or not.  protected by mmap_lock.
 	 */
 	u16 pkey_allocation_map;
 	s16 execute_only_pkey;
--- a/arch/x86/include/asm/pgtable-3level.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -39,23 +39,23 @@ static inline void native_set_pte(pte_t
  * pte_offset_map_lock() on 32-bit PAE kernels was reading the pmd_t with
  * a "*pmdp" dereference done by GCC. Problem is, in certain places
  * where pte_offset_map_lock() is called, concurrent page faults are
- * allowed, if the mmap_sem is hold for reading. An example is mincore
+ * allowed, if the mmap_lock is hold for reading. An example is mincore
  * vs page faults vs MADV_DONTNEED. On the page fault side
  * pmd_populate() rightfully does a set_64bit(), but if we're reading the
  * pmd_t with a "*pmdp" on the mincore side, a SMP race can happen
  * because GCC will not read the 64-bit value of the pmd atomically.
  *
  * To fix this all places running pte_offset_map_lock() while holding the
- * mmap_sem in read mode, shall read the pmdp pointer using this
+ * mmap_lock in read mode, shall read the pmdp pointer using this
  * function to know if the pmd is null or not, and in turn to know if
  * they can run pte_offset_map_lock() or pmd_trans_huge() or other pmd
  * operations.
  *
- * Without THP if the mmap_sem is held for reading, the pmd can only
+ * Without THP if the mmap_lock is held for reading, the pmd can only
  * transition from null to not null while pmd_read_atomic() runs. So
  * we can always return atomic pmd values with this function.
  *
- * With THP if the mmap_sem is held for reading, the pmd can become
+ * With THP if the mmap_lock is held for reading, the pmd can become
  * trans_huge or none or point to a pte (and in turn become "stable")
  * at any time under pmd_read_atomic(). We could read it truly
  * atomically here with an atomic64_read() for the THP enabled case (and
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -1326,9 +1326,9 @@ int rdtgroup_pseudo_lock_create(struct r
 	 * pseudo-locked region will still be here on return.
 	 *
 	 * The mutex has to be released temporarily to avoid a potential
-	 * deadlock with the mm->mmap_sem semaphore which is obtained in
-	 * the device_create() and debugfs_create_dir() callpath below
-	 * as well as before the mmap() callback is called.
+	 * deadlock with the mm->mmap_lock which is obtained in the
+	 * device_create() and debugfs_create_dir() callpath below as well as
+	 * before the mmap() callback is called.
 	 */
 	mutex_unlock(&rdtgroup_mutex);
 
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3199,10 +3199,10 @@ int __init rdtgroup_init(void)
 	 * during the debugfs directory creation also &sb->s_type->i_mutex_key
 	 * (the lockdep class of inode->i_rwsem). Other filesystem
 	 * interactions (eg. SyS_getdents) have the lock ordering:
-	 * &sb->s_type->i_mutex_key --> &mm->mmap_sem
-	 * During mmap(), called with &mm->mmap_sem, the rdtgroup_mutex
+	 * &sb->s_type->i_mutex_key --> &mm->mmap_lock
+	 * During mmap(), called with &mm->mmap_lock, the rdtgroup_mutex
 	 * is taken, thus creating dependency:
-	 * &mm->mmap_sem --> rdtgroup_mutex for the latter that can cause
+	 * &mm->mmap_lock --> rdtgroup_mutex for the latter that can cause
 	 * issues considering the other two lock dependencies.
 	 * By creating the debugfs directory here we avoid a dependency
 	 * that may cause deadlock (even though file operations cannot
--- a/arch/x86/kernel/ldt.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/x86/kernel/ldt.c
@@ -8,7 +8,7 @@
  *
  * Lock order:
  *	contex.ldt_usr_sem
- *	  mmap_sem
+ *	  mmap_lock
  *	    context.lock
  */
 
--- a/arch/x86/mm/fault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/arch/x86/mm/fault.c
@@ -865,7 +865,7 @@ bad_area_access_error(struct pt_regs *re
 		 * 2. T1   : set PKRU to deny access to pkey=4, touches page
 		 * 3. T1   : faults...
 		 * 4.    T2: mprotect_key(foo, PAGE_SIZE, pkey=5);
-		 * 5. T1   : enters fault handler, takes mmap_sem, etc...
+		 * 5. T1   : enters fault handler, takes mmap_lock, etc...
 		 * 6. T1   : reaches here, sees vma_pkey(vma)=5, when we really
 		 *	     faulted on a pte with its pkey=4.
 		 */
@@ -1231,12 +1231,12 @@ void do_user_addr_fault(struct pt_regs *
 	 * Kernel-mode access to the user address space should only occur
 	 * on well-defined single instructions listed in the exception
 	 * tables.  But, an erroneous kernel fault occurring outside one of
-	 * those areas which also holds mmap_sem might deadlock attempting
+	 * those areas which also holds mmap_lock might deadlock attempting
 	 * to validate the fault against the address space.
 	 *
 	 * Only do the expensive exception table search when we might be at
 	 * risk of a deadlock.  This happens if we
-	 * 1. Failed to acquire mmap_sem, and
+	 * 1. Failed to acquire mmap_lock, and
 	 * 2. The access did not originate in userspace.
 	 */
 	if (unlikely(!mmap_read_trylock(mm))) {
@@ -1289,9 +1289,9 @@ good_area:
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.  Since we never set FAULT_FLAG_RETRY_NOWAIT, if
-	 * we get VM_FAULT_RETRY back, the mmap_sem has been unlocked.
+	 * we get VM_FAULT_RETRY back, the mmap_lock has been unlocked.
 	 *
-	 * Note that handle_userfault() may also release and reacquire mmap_sem
+	 * Note that handle_userfault() may also release and reacquire mmap_lock
 	 * (and not return with VM_FAULT_RETRY), when returning to userland to
 	 * repeat the page fault later with a VM_FAULT_NOPAGE retval
 	 * (potentially after handling any pending signal during the return to
@@ -1310,7 +1310,7 @@ good_area:
 	}
 
 	/*
-	 * If we need to retry the mmap_sem has already been released,
+	 * If we need to retry the mmap_lock has already been released,
 	 * and if there is a fatal signal pending there is no guarantee
 	 * that we made any progress. Handle this case first.
 	 */
--- a/Documentation/admin-guide/mm/numa_memory_policy.rst~mmap-locking-api-convert-mmap_sem-comments
+++ a/Documentation/admin-guide/mm/numa_memory_policy.rst
@@ -364,19 +364,19 @@ follows:
 
 2) for querying the policy, we do not need to take an extra reference on the
    target task's task policy nor vma policies because we always acquire the
-   task's mm's mmap_sem for read during the query.  The set_mempolicy() and
-   mbind() APIs [see below] always acquire the mmap_sem for write when
+   task's mm's mmap_lock for read during the query.  The set_mempolicy() and
+   mbind() APIs [see below] always acquire the mmap_lock for write when
    installing or replacing task or vma policies.  Thus, there is no possibility
    of a task or thread freeing a policy while another task or thread is
    querying it.
 
 3) Page allocation usage of task or vma policy occurs in the fault path where
-   we hold them mmap_sem for read.  Again, because replacing the task or vma
-   policy requires that the mmap_sem be held for write, the policy can't be
+   we hold them mmap_lock for read.  Again, because replacing the task or vma
+   policy requires that the mmap_lock be held for write, the policy can't be
    freed out from under us while we're using it for page allocation.
 
 4) Shared policies require special consideration.  One task can replace a
-   shared memory policy while another task, with a distinct mmap_sem, is
+   shared memory policy while another task, with a distinct mmap_lock, is
    querying or allocating a page based on the policy.  To resolve this
    potential race, the shared policy infrastructure adds an extra reference
    to the shared policy during lookup while holding a spin lock on the shared
--- a/Documentation/admin-guide/mm/userfaultfd.rst~mmap-locking-api-convert-mmap_sem-comments
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -33,7 +33,7 @@ memory ranges) provides two primary func
 The real advantage of userfaults if compared to regular virtual memory
 management of mremap/mprotect is that the userfaults in all their
 operations never involve heavyweight structures like vmas (in fact the
-``userfaultfd`` runtime load never takes the mmap_sem for writing).
+``userfaultfd`` runtime load never takes the mmap_lock for writing).
 
 Vmas are not suitable for page- (or hugepage) granular fault tracking
 when dealing with virtual address spaces that could span
--- a/Documentation/filesystems/locking.rst~mmap-locking-api-convert-mmap_sem-comments
+++ a/Documentation/filesystems/locking.rst
@@ -615,7 +615,7 @@ prototypes::
 locking rules:
 
 =============	========	===========================
-ops		mmap_sem	PageLocked(page)
+ops		mmap_lock	PageLocked(page)
 =============	========	===========================
 open:		yes
 close:		yes
--- a/Documentation/vm/transhuge.rst~mmap-locking-api-convert-mmap_sem-comments
+++ a/Documentation/vm/transhuge.rst
@@ -98,9 +98,9 @@ split_huge_page() or split_huge_pmd() ha
 
 To make pagetable walks huge pmd aware, all you need to do is to call
 pmd_trans_huge() on the pmd returned by pmd_offset. You must hold the
-mmap_sem in read (or write) mode to be sure a huge pmd cannot be
+mmap_lock in read (or write) mode to be sure a huge pmd cannot be
 created from under you by khugepaged (khugepaged collapse_huge_page
-takes the mmap_sem in write mode in addition to the anon_vma lock). If
+takes the mmap_lock in write mode in addition to the anon_vma lock). If
 pmd_trans_huge returns false, you just fallback in the old code
 paths. If instead pmd_trans_huge returns true, you have to take the
 page table lock (pmd_lock()) and re-run pmd_trans_huge. Taking the
--- a/drivers/char/mspec.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/char/mspec.c
@@ -64,7 +64,7 @@ enum mspec_page_type {
  * This structure is shared by all vma's that are split off from the
  * original vma when split_vma()'s are done.
  *
- * The refcnt is incremented atomically because mm->mmap_sem does not
+ * The refcnt is incremented atomically because mm->mmap_lock does not
  * protect in fork case where multiple tasks share the vma_data.
  */
 struct vma_data {
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c
@@ -237,7 +237,7 @@ static int kgd_hqd_load(struct kgd_dev *
 			     CP_HQD_PQ_DOORBELL_CONTROL, DOORBELL_EN, 1);
 	WREG32(mmCP_HQD_PQ_DOORBELL_CONTROL, data);
 
-	/* read_user_ptr may take the mm->mmap_sem.
+	/* read_user_ptr may take the mm->mmap_lock.
 	 * release srbm_mutex to avoid circular dependency between
 	 * srbm_mutex->mm_sem->reservation_ww_class_mutex->srbm_mutex.
 	 */
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c
@@ -224,7 +224,7 @@ static int kgd_hqd_load(struct kgd_dev *
 			     CP_HQD_PQ_DOORBELL_CONTROL, DOORBELL_EN, 1);
 	WREG32(mmCP_HQD_PQ_DOORBELL_CONTROL, data);
 
-	/* read_user_ptr may take the mm->mmap_sem.
+	/* read_user_ptr may take the mm->mmap_lock.
 	 * release srbm_mutex to avoid circular dependency between
 	 * srbm_mutex->mm_sem->reservation_ww_class_mutex->srbm_mutex.
 	 */
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -186,7 +186,7 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_coun
  * disabled. The memory must be pinned and mapped to the hardware when
  * this is called in hqd_load functions, so it should never fault in
  * the first place. This resolves a circular lock dependency involving
- * four locks, including the DQM lock and mmap_sem.
+ * four locks, including the DQM lock and mmap_lock.
  */
 #define read_user_wptr(mmptr, wptr, dst)				\
 	({								\
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -203,7 +203,7 @@ i915_mmu_notifier_find(struct i915_mm_st
 	mmap_write_lock(mm->mm);
 	mutex_lock(&mm->i915->mm_lock);
 	if (mm->mn == NULL && !err) {
-		/* Protected by mmap_sem (write-lock) */
+		/* Protected by mmap_lock (write-lock) */
 		err = __mmu_notifier_register(&mn->mn, mm->mm);
 		if (!err) {
 			/* Protected by mm_lock */
@@ -522,8 +522,8 @@ __i915_gem_userptr_get_pages_schedule(st
 
 	/* Spawn a worker so that we can acquire the
 	 * user pages without holding our mutex. Access
-	 * to the user pages requires mmap_sem, and we have
-	 * a strict lock ordering of mmap_sem, struct_mutex -
+	 * to the user pages requires mmap_lock, and we have
+	 * a strict lock ordering of mmap_lock, struct_mutex -
 	 * we already hold struct_mutex here and so cannot
 	 * call gup without encountering a lock inversion.
 	 *
--- a/drivers/gpu/drm/i915/i915_perf.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/gpu/drm/i915/i915_perf.c
@@ -3676,7 +3676,7 @@ static int read_properties_unlocked(stru
  * buffered data written by the GPU besides periodic OA metrics.
  *
  * Note we copy the properties from userspace outside of the i915 perf
- * mutex to avoid an awkward lockdep with mmap_sem.
+ * mutex to avoid an awkward lockdep with mmap_lock.
  *
  * Most of the implementation details are handled by
  * i915_perf_open_ioctl_locked() after taking the &perf->lock
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -58,7 +58,7 @@ static vm_fault_t ttm_bo_vm_fault_idle(s
 		goto out_clear;
 
 	/*
-	 * If possible, avoid waiting for GPU with mmap_sem
+	 * If possible, avoid waiting for GPU with mmap_lock
 	 * held.  We only do this if the fault allows retry and this
 	 * is the first attempt.
 	 */
@@ -131,14 +131,14 @@ vm_fault_t ttm_bo_vm_reserve(struct ttm_
 {
 	/*
 	 * Work around locking order reversal in fault / nopfn
-	 * between mmap_sem and bo_reserve: Perform a trylock operation
+	 * between mmap_lock and bo_reserve: Perform a trylock operation
 	 * for reserve, and if it fails, retry the fault after waiting
 	 * for the buffer to become unreserved.
 	 */
 	if (unlikely(!dma_resv_trylock(bo->base.resv))) {
 		/*
 		 * If the fault allows retry and this is the first
-		 * fault attempt, we try to release the mmap_sem
+		 * fault attempt, we try to release the mmap_lock
 		 * before waiting
 		 */
 		if (fault_flag_allow_retry_first(vmf->flags)) {
--- a/drivers/infiniband/core/uverbs_main.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/infiniband/core/uverbs_main.c
@@ -835,7 +835,7 @@ void uverbs_user_mmap_disassociate(struc
 			return;
 
 		/*
-		 * The umap_lock is nested under mmap_sem since it used within
+		 * The umap_lock is nested under mmap_lock since it used within
 		 * the vma_ops callbacks, so we have to clean the list one mm
 		 * at a time to get the lock ordering right. Typically there
 		 * will only be one mm, so no big deal.
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -333,7 +333,7 @@ static void do_remove(struct mmu_rb_hand
 
 /*
  * Work queue function to remove all nodes that have been queued up to
- * be removed.  The key feature is that mm->mmap_sem is not being held
+ * be removed.  The key feature is that mm->mmap_lock is not being held
  * and the remove callback can sleep while taking it, if needed.
  */
 static void handle_remove(struct work_struct *work)
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -533,7 +533,7 @@ static int __videobuf_iolock(struct vide
 		} else {
 			/* NOTE: HACK: videobuf_iolock on V4L2_MEMORY_MMAP
 			buffers can only be called from videobuf_qbuf
-			we take current->mm->mmap_sem there, to prevent
+			we take current->mm->mmap_lock there, to prevent
 			locking inversion, so don't take it here */
 
 			err = videobuf_dma_init_user_locked(&mem->dma,
--- a/drivers/misc/cxl/cxllib.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/misc/cxl/cxllib.c
@@ -245,9 +245,8 @@ int cxllib_handle_fault(struct mm_struct
 	     dar += page_size) {
 		if (dar < vma_start || dar >= vma_end) {
 			/*
-			 * We don't hold the mm->mmap_sem semaphore
-			 * while iterating, since the semaphore is
-			 * required by one of the lower-level page
+			 * We don't hold mm->mmap_lock while iterating, since
+			 * the lock is required by one of the lower-level page
 			 * fault processing functions and it could
 			 * create a deadlock.
 			 *
--- a/drivers/misc/sgi-gru/grufault.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -42,7 +42,7 @@ static inline int is_gru_paddr(unsigned
 }
 
 /*
- * Find the vma of a GRU segment. Caller must hold mmap_sem.
+ * Find the vma of a GRU segment. Caller must hold mmap_lock.
  */
 struct vm_area_struct *gru_find_vma(unsigned long vaddr)
 {
@@ -58,7 +58,7 @@ struct vm_area_struct *gru_find_vma(unsi
  * Find and lock the gts that contains the specified user vaddr.
  *
  * Returns:
- * 	- *gts with the mmap_sem locked for read and the GTS locked.
+ * 	- *gts with the mmap_lock locked for read and the GTS locked.
  *	- NULL if vaddr invalid OR is not a valid GSEG vaddr.
  */
 
@@ -198,7 +198,7 @@ static int non_atomic_pte_lookup(struct
  * Only supports Intel large pages (2MB only) on x86_64.
  *	ZZZ - hugepage support is incomplete
  *
- * NOTE: mmap_sem is already held on entry to this function. This
+ * NOTE: mmap_lock is already held on entry to this function. This
  * guarantees existence of the page tables.
  */
 static int atomic_pte_lookup(struct vm_area_struct *vma, unsigned long vaddr,
@@ -569,7 +569,7 @@ static irqreturn_t gru_intr(int chiplet,
 		}
 
 		/*
-		 * This is running in interrupt context. Trylock the mmap_sem.
+		 * This is running in interrupt context. Trylock the mmap_lock.
 		 * If it fails, retry the fault in user context.
 		 */
 		gts->ustats.fmm_tlbmiss++;
--- a/drivers/oprofile/buffer_sync.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/oprofile/buffer_sync.c
@@ -486,7 +486,7 @@ typedef enum {
 
 /* Sync one of the CPU's buffers into the global event buffer.
  * Here we need to go through each batch of samples punctuated
- * by context switch notes, taking the task's mmap_sem and doing
+ * by context switch notes, taking the task's mmap_lock and doing
  * lookup in task->mm->mmap to convert EIP into dcookie/offset
  * value.
  */
--- a/drivers/staging/android/ashmem.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/staging/android/ashmem.c
@@ -555,7 +555,7 @@ static int set_name(struct ashmem_area *
 
 	/*
 	 * Holding the ashmem_mutex while doing a copy_from_user might cause
-	 * an data abort which would try to access mmap_sem. If another
+	 * an data abort which would try to access mmap_lock. If another
 	 * thread has invoked ashmem_mmap then it will be holding the
 	 * semaphore and will be waiting for ashmem_mutex, there by leading to
 	 * deadlock. We'll release the mutex and take the name to a local
@@ -586,7 +586,7 @@ static int get_name(struct ashmem_area *
 	 * Have a local variable to which we'll copy the content
 	 * from asma with the lock held. Later we can copy this to the user
 	 * space safely without holding any locks. So even if we proceed to
-	 * wait for mmap_sem, it won't lead to deadlock.
+	 * wait for mmap_lock, it won't lead to deadlock.
 	 */
 	char local_name[ASHMEM_NAME_LEN];
 
--- a/drivers/staging/comedi/comedi_fops.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/staging/comedi/comedi_fops.c
@@ -2325,7 +2325,7 @@ static int comedi_mmap(struct file *file
 	int retval = 0;
 
 	/*
-	 * 'trylock' avoids circular dependency with current->mm->mmap_sem
+	 * 'trylock' avoids circular dependency with current->mm->mmap_lock
 	 * and down-reading &dev->attach_lock should normally succeed without
 	 * contention unless the device is in the process of being attached
 	 * or detached.
--- a/drivers/tty/vt/consolemap.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/tty/vt/consolemap.c
@@ -12,7 +12,7 @@
  * Fix bug in inverse translation. Stanislav Voronyi <stas@cnti.uanet.kharkov.ua>, Dec 1998
  *
  * In order to prevent the following circular lock dependency:
- *   &mm->mmap_sem --> cpu_hotplug.lock --> console_lock --> &mm->mmap_sem
+ *   &mm->mmap_lock --> cpu_hotplug.lock --> console_lock --> &mm->mmap_lock
  *
  * We cannot allow page fault to happen while holding the console_lock.
  * Therefore, all the userspace copy operations have to be done outside
--- a/drivers/vfio/pci/vfio_pci.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/vfio/pci/vfio_pci.c
@@ -1185,7 +1185,7 @@ reset_info_exit:
 
 		/*
 		 * We need to get memory_lock for each device, but devices
-		 * can share mmap_sem, therefore we need to zap and hold
+		 * can share mmap_lock, therefore we need to zap and hold
 		 * the vma_lock for each device, and only then get each
 		 * memory_lock.
 		 */
@@ -1375,26 +1375,26 @@ static int vfio_pci_zap_and_vma_lock(str
 
 	/*
 	 * Lock ordering:
-	 * vma_lock is nested under mmap_sem for vm_ops callback paths.
+	 * vma_lock is nested under mmap_lock for vm_ops callback paths.
 	 * The memory_lock semaphore is used by both code paths calling
 	 * into this function to zap vmas and the vm_ops.fault callback
 	 * to protect the memory enable state of the device.
 	 *
-	 * When zapping vmas we need to maintain the mmap_sem => vma_lock
+	 * When zapping vmas we need to maintain the mmap_lock => vma_lock
 	 * ordering, which requires using vma_lock to walk vma_list to
-	 * acquire an mm, then dropping vma_lock to get the mmap_sem and
+	 * acquire an mm, then dropping vma_lock to get the mmap_lock and
 	 * reacquiring vma_lock.  This logic is derived from similar
 	 * requirements in uverbs_user_mmap_disassociate().
 	 *
-	 * mmap_sem must always be the top-level lock when it is taken.
+	 * mmap_lock must always be the top-level lock when it is taken.
 	 * Therefore we can only hold the memory_lock write lock when
-	 * vma_list is empty, as we'd need to take mmap_sem to clear
+	 * vma_list is empty, as we'd need to take mmap_lock to clear
 	 * entries.  vma_list can only be guaranteed empty when holding
 	 * vma_lock, thus memory_lock is nested under vma_lock.
 	 *
 	 * This enables the vm_ops.fault callback to acquire vma_lock,
 	 * followed by memory_lock read lock, while already holding
-	 * mmap_sem without risk of deadlock.
+	 * mmap_lock without risk of deadlock.
 	 */
 	while (1) {
 		struct mm_struct *mm = NULL;
--- a/drivers/xen/gntdev.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/drivers/xen/gntdev.c
@@ -1014,7 +1014,7 @@ static int gntdev_mmap(struct file *flip
 		 * to the PTE from going stale.
 		 *
 		 * Since this vma's mappings can't be touched without the
-		 * mmap_sem, and we are holding it now, there is no need for
+		 * mmap_lock, and we are holding it now, there is no need for
 		 * the notifier_range locking pattern.
 		 */
 		mmu_interval_read_begin(&map->notifier);
--- a/fs/coredump.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/coredump.c
@@ -393,7 +393,7 @@ static int zap_threads(struct task_struc
 	 *	of ->siglock provides a memory barrier.
 	 *
 	 * do_exit:
-	 *	The caller holds mm->mmap_sem. This means that the task which
+	 *	The caller holds mm->mmap_lock. This means that the task which
 	 *	uses this mm can't pass exit_mm(), so it can't exit or clear
 	 *	its ->mm.
 	 *
@@ -401,7 +401,7 @@ static int zap_threads(struct task_struc
 	 *	It does list_replace_rcu(&leader->tasks, &current->tasks),
 	 *	we must see either old or new leader, this does not matter.
 	 *	However, it can change p->sighand, so lock_task_sighand(p)
-	 *	must be used. Since p->mm != NULL and we hold ->mmap_sem
+	 *	must be used. Since p->mm != NULL and we hold ->mmap_lock
 	 *	it can't fail.
 	 *
 	 *	Note also that "g" can be the old leader with ->mm == NULL
--- a/fs/exec.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/exec.c
@@ -1091,7 +1091,7 @@ static int exec_mmap(struct mm_struct *m
 		/*
 		 * Make sure that if there is a core dump in progress
 		 * for the old mm, we get out and die instead of going
-		 * through with the exec.  We must hold mmap_sem around
+		 * through with the exec.  We must hold mmap_lock around
 		 * checking core_state and changing tsk->mm.
 		 */
 		mmap_read_lock(old_mm);
--- a/fs/ext2/file.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/ext2/file.c
@@ -79,7 +79,7 @@ out_unlock:
 /*
  * The lock ordering for ext2 DAX fault paths is:
  *
- * mmap_sem (MM)
+ * mmap_lock (MM)
  *   sb_start_pagefault (vfs, freeze)
  *     ext2_inode_info->dax_sem
  *       address_space->i_mmap_rwsem or page_lock (mutually exclusive in DAX)
--- a/fs/ext4/super.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/ext4/super.c
@@ -93,11 +93,11 @@ static struct inode *ext4_get_journal_in
  * i_mmap_rwsem (inode->i_mmap_rwsem)!
  *
  * page fault path:
- * mmap_sem -> sb_start_pagefault -> i_mmap_sem (r) -> transaction start ->
+ * mmap_lock -> sb_start_pagefault -> i_mmap_sem (r) -> transaction start ->
  *   page lock -> i_data_sem (rw)
  *
  * buffered write path:
- * sb_start_write -> i_mutex -> mmap_sem
+ * sb_start_write -> i_mutex -> mmap_lock
  * sb_start_write -> i_mutex -> transaction start -> page lock ->
  *   i_data_sem (rw)
  *
@@ -107,7 +107,7 @@ static struct inode *ext4_get_journal_in
  *   i_data_sem (rw)
  *
  * direct IO:
- * sb_start_write -> i_mutex -> mmap_sem
+ * sb_start_write -> i_mutex -> mmap_lock
  * sb_start_write -> i_mutex -> transaction start -> i_data_sem (rw)
  *
  * writepages:
--- a/fs/kernfs/file.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/kernfs/file.c
@@ -652,9 +652,9 @@ static int kernfs_fop_open(struct inode
 	 * The following is done to give a different lockdep key to
 	 * @of->mutex for files which implement mmap.  This is a rather
 	 * crude way to avoid false positive lockdep warning around
-	 * mm->mmap_sem - mmap nests @of->mutex under mm->mmap_sem and
+	 * mm->mmap_lock - mmap nests @of->mutex under mm->mmap_lock and
 	 * reading /sys/block/sda/trace/act_mask grabs sr_mutex, under
-	 * which mm->mmap_sem nests, while holding @of->mutex.  As each
+	 * which mm->mmap_lock nests, while holding @of->mutex.  As each
 	 * open file has a separate mutex, it's okay as long as those don't
 	 * happen on the same file.  At this point, we can't easily give
 	 * each file a separate locking class.  Let's differentiate on
--- a/fs/proc/base.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/proc/base.c
@@ -2333,11 +2333,11 @@ proc_map_files_readdir(struct file *file
 	/*
 	 * We need two passes here:
 	 *
-	 *  1) Collect vmas of mapped files with mmap_sem taken
-	 *  2) Release mmap_sem and instantiate entries
+	 *  1) Collect vmas of mapped files with mmap_lock taken
+	 *  2) Release mmap_lock and instantiate entries
 	 *
 	 * otherwise we get lockdep complained, since filldir()
-	 * routine might require mmap_sem taken in might_fault().
+	 * routine might require mmap_lock taken in might_fault().
 	 */
 
 	for (vma = mm->mmap, pos = 2; vma; vma = vma->vm_next) {
--- a/fs/proc/task_mmu.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/proc/task_mmu.c
@@ -593,7 +593,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 	if (pmd_trans_unstable(pmd))
 		goto out;
 	/*
-	 * The mmap_sem held all the way back in m_start() is what
+	 * The mmap_lock held all the way back in m_start() is what
 	 * keeps khugepaged out of here and from collapsing things
 	 * in here.
 	 */
@@ -752,7 +752,7 @@ static void smap_gather_stats(struct vm_
 		}
 	}
 #endif
-	/* mmap_sem is held in m_start */
+	/* mmap_lock is held in m_start */
 	walk_page_vma(vma, &smaps_walk_ops, mss);
 }
 
@@ -1827,7 +1827,7 @@ static int show_numa_map(struct seq_file
 	if (is_vm_hugetlb_page(vma))
 		seq_puts(m, " huge");
 
-	/* mmap_sem is held by m_start */
+	/* mmap_lock is held by m_start */
 	walk_page_vma(vma, &show_numa_ops, md);
 
 	if (!md->pages)
--- a/fs/userfaultfd.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/userfaultfd.c
@@ -369,13 +369,13 @@ static inline bool userfaultfd_signal_pe
  * FAULT_FLAG_KILLABLE are not straightforward. The "Caution"
  * recommendation in __lock_page_or_retry is not an understatement.
  *
- * If FAULT_FLAG_ALLOW_RETRY is set, the mmap_sem must be released
+ * If FAULT_FLAG_ALLOW_RETRY is set, the mmap_lock must be released
  * before returning VM_FAULT_RETRY only if FAULT_FLAG_RETRY_NOWAIT is
  * not set.
  *
  * If FAULT_FLAG_ALLOW_RETRY is set but FAULT_FLAG_KILLABLE is not
  * set, VM_FAULT_RETRY can still be returned if and only if there are
- * fatal_signal_pending()s, and the mmap_sem must be released before
+ * fatal_signal_pending()s, and the mmap_lock must be released before
  * returning it.
  */
 vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
@@ -396,14 +396,14 @@ vm_fault_t handle_userfault(struct vm_fa
 	 * FOLL_DUMP case, anon memory also checks for FOLL_DUMP with
 	 * the no_page_table() helper in follow_page_mask(), but the
 	 * shmem_vm_ops->fault method is invoked even during
-	 * coredumping without mmap_sem and it ends up here.
+	 * coredumping without mmap_lock and it ends up here.
 	 */
 	if (current->flags & (PF_EXITING|PF_DUMPCORE))
 		goto out;
 
 	/*
-	 * Coredumping runs without mmap_sem so we can only check that
-	 * the mmap_sem is held, if PF_DUMPCORE was not set.
+	 * Coredumping runs without mmap_lock so we can only check that
+	 * the mmap_lock is held, if PF_DUMPCORE was not set.
 	 */
 	mmap_assert_locked(mm);
 
@@ -422,7 +422,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	/*
 	 * If it's already released don't get it. This avoids to loop
 	 * in __get_user_pages if userfaultfd_release waits on the
-	 * caller of handle_userfault to release the mmap_sem.
+	 * caller of handle_userfault to release the mmap_lock.
 	 */
 	if (unlikely(READ_ONCE(ctx->released))) {
 		/*
@@ -481,7 +481,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
 		goto out;
 
-	/* take the reference before dropping the mmap_sem */
+	/* take the reference before dropping the mmap_lock */
 	userfaultfd_ctx_get(ctx);
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
@@ -890,9 +890,9 @@ static int userfaultfd_release(struct in
 	 * Flush page faults out of all CPUs. NOTE: all page faults
 	 * must be retried without returning VM_FAULT_SIGBUS if
 	 * userfaultfd_ctx_get() succeeds but vma->vma_userfault_ctx
-	 * changes while handle_userfault released the mmap_sem. So
+	 * changes while handle_userfault released the mmap_lock. So
 	 * it's critical that released is set to true (above), before
-	 * taking the mmap_sem for writing.
+	 * taking the mmap_lock for writing.
 	 */
 	mmap_write_lock(mm);
 	still_valid = mmget_still_valid(mm);
--- a/fs/xfs/xfs_file.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/xfs/xfs_file.c
@@ -1173,7 +1173,7 @@ xfs_file_llseek(
  * Locking for serialisation of IO during page faults. This results in a lock
  * ordering of:
  *
- * mmap_sem (MM)
+ * mmap_lock (MM)
  *   sb_start_pagefault(vfs, freeze)
  *     i_mmaplock (XFS - truncate serialisation)
  *       page_lock (MM)
--- a/fs/xfs/xfs_inode.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/xfs/xfs_inode.c
@@ -145,17 +145,17 @@ xfs_ilock_attr_map_shared(
  *
  * i_rwsem -> i_mmap_lock -> page_lock -> i_ilock
  *
- * mmap_sem locking order:
+ * mmap_lock locking order:
  *
- * i_rwsem -> page lock -> mmap_sem
- * mmap_sem -> i_mmap_lock -> page_lock
+ * i_rwsem -> page lock -> mmap_lock
+ * mmap_lock -> i_mmap_lock -> page_lock
  *
- * The difference in mmap_sem locking order mean that we cannot hold the
+ * The difference in mmap_lock locking order mean that we cannot hold the
  * i_mmap_lock over syscall based read(2)/write(2) based IO. These IO paths can
- * fault in pages during copy in/out (for buffered IO) or require the mmap_sem
+ * fault in pages during copy in/out (for buffered IO) or require the mmap_lock
  * in get_user_pages() to map the user pages into the kernel address space for
  * direct IO. Similarly the i_rwsem cannot be taken inside a page fault because
- * page faults already hold the mmap_sem.
+ * page faults already hold the mmap_lock.
  *
  * Hence to serialise fully against both syscall and mmap based IO, we need to
  * take both the i_rwsem and the i_mmap_lock. These locks should *only* be both
@@ -1630,7 +1630,7 @@ xfs_release(
 			return 0;
 		/*
 		 * If we can't get the iolock just skip truncating the blocks
-		 * past EOF because we could deadlock with the mmap_sem
+		 * past EOF because we could deadlock with the mmap_lock
 		 * otherwise. We'll get another chance to drop them once the
 		 * last reference to the inode is dropped, so we'll never leak
 		 * blocks permanently.
--- a/fs/xfs/xfs_iops.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/fs/xfs/xfs_iops.c
@@ -28,11 +28,11 @@
 #include <linux/fiemap.h>
 
 /*
- * Directories have different lock order w.r.t. mmap_sem compared to regular
+ * Directories have different lock order w.r.t. mmap_lock compared to regular
  * files. This is due to readdir potentially triggering page faults on a user
  * buffer inside filldir(), and this happens with the ilock on the directory
  * held. For regular files, the lock order is the other way around - the
- * mmap_sem is taken during the page fault, and then we lock the ilock to do
+ * mmap_lock is taken during the page fault, and then we lock the ilock to do
  * block mapping. Hence we need a different class for the directory ilock so
  * that lockdep can tell them apart.
  */
--- a/include/linux/fs.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/include/linux/fs.h
@@ -1679,10 +1679,10 @@ static inline int sb_start_write_trylock
  *
  * Since page fault freeze protection behaves as a lock, users have to preserve
  * ordering of freeze protection and other filesystem locks. It is advised to
- * put sb_start_pagefault() close to mmap_sem in lock ordering. Page fault
+ * put sb_start_pagefault() close to mmap_lock in lock ordering. Page fault
  * handling code implies lock dependency:
  *
- * mmap_sem
+ * mmap_lock
  *   -> sb_start_pagefault
  */
 static inline void sb_start_pagefault(struct super_block *sb)
--- a/include/linux/huge_mm.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/include/linux/huge_mm.h
@@ -248,7 +248,7 @@ static inline int is_swap_pmd(pmd_t pmd)
 	return !pmd_none(pmd) && !pmd_present(pmd);
 }
 
-/* mmap_sem must be held on entry */
+/* mmap_lock must be held on entry */
 static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma)
 {
--- a/include/linux/mempolicy.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/include/linux/mempolicy.h
@@ -31,7 +31,7 @@ struct mm_struct;
  * Locking policy for interlave:
  * In process context there is no locking because only the process accesses
  * its own state. All vma manipulation is somewhat protected by a down_read on
- * mmap_sem.
+ * mmap_lock.
  *
  * Freeing policy:
  * Mempolicy objects are reference counted.  A mempolicy will be freed when
--- a/include/linux/mm.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/include/linux/mm.h
@@ -402,7 +402,7 @@ extern pgprot_t protection_map[16];
  * @FAULT_FLAG_WRITE: Fault was a write fault.
  * @FAULT_FLAG_MKWRITE: Fault was mkwrite of existing PTE.
  * @FAULT_FLAG_ALLOW_RETRY: Allow to retry the fault if blocked.
- * @FAULT_FLAG_RETRY_NOWAIT: Don't drop mmap_sem and wait when retrying.
+ * @FAULT_FLAG_RETRY_NOWAIT: Don't drop mmap_lock and wait when retrying.
  * @FAULT_FLAG_KILLABLE: The fault task is in SIGKILL killable region.
  * @FAULT_FLAG_TRIED: The fault has been tried once.
  * @FAULT_FLAG_USER: The fault originated in userspace.
@@ -452,10 +452,10 @@ extern pgprot_t protection_map[16];
  * fault_flag_allow_retry_first - check ALLOW_RETRY the first time
  *
  * This is mostly used for places where we want to try to avoid taking
- * the mmap_sem for too long a time when waiting for another condition
+ * the mmap_lock for too long a time when waiting for another condition
  * to change, in which case we can try to be polite to release the
- * mmap_sem in the first round to avoid potential starvation of other
- * processes that would also want the mmap_sem.
+ * mmap_lock in the first round to avoid potential starvation of other
+ * processes that would also want the mmap_lock.
  *
  * Return: true if the page fault allows retry and this is the first
  * attempt of the fault handling; false otherwise.
@@ -582,7 +582,7 @@ struct vm_operations_struct {
 	 * (vma,addr) marked as MPOL_SHARED.  The shared policy infrastructure
 	 * in mm/mempolicy.c will do this automatically.
 	 * get_policy() must NOT add a ref if the policy at (vma,addr) is not
-	 * marked as MPOL_SHARED. vma policies are protected by the mmap_sem.
+	 * marked as MPOL_SHARED. vma policies are protected by the mmap_lock.
 	 * If no [shared/vma] mempolicy exists at the addr, get_policy() op
 	 * must return NULL--i.e., do not "fallback" to task or system default
 	 * policy.
--- a/include/linux/mm_types.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/include/linux/mm_types.h
@@ -344,7 +344,7 @@ struct vm_area_struct {
 	 * can only be in the i_mmap tree.  An anonymous MAP_PRIVATE, stack
 	 * or brk vma (with NULL file) can only be in an anon_vma list.
 	 */
-	struct list_head anon_vma_chain; /* Serialized by mmap_sem &
+	struct list_head anon_vma_chain; /* Serialized by mmap_lock &
 					  * page_table_lock */
 	struct anon_vma *anon_vma;	/* Serialized by page_table_lock */
 
--- a/include/linux/mmu_notifier.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/include/linux/mmu_notifier.h
@@ -122,7 +122,7 @@ struct mmu_notifier_ops {
 
 	/*
 	 * invalidate_range_start() and invalidate_range_end() must be
-	 * paired and are called only when the mmap_sem and/or the
+	 * paired and are called only when the mmap_lock and/or the
 	 * locks protecting the reverse maps are held. If the subsystem
 	 * can't guarantee that no additional references are taken to
 	 * the pages in the range, it has to implement the
@@ -213,13 +213,13 @@ struct mmu_notifier_ops {
 };
 
 /*
- * The notifier chains are protected by mmap_sem and/or the reverse map
+ * The notifier chains are protected by mmap_lock and/or the reverse map
  * semaphores. Notifier chains are only changed when all reverse maps and
- * the mmap_sem locks are taken.
+ * the mmap_lock locks are taken.
  *
  * Therefore notifier chains can only be traversed when either
  *
- * 1. mmap_sem is held.
+ * 1. mmap_lock is held.
  * 2. One of the reverse map locks is held (i_mmap_rwsem or anon_vma->rwsem).
  * 3. No other concurrent thread can access the list (release)
  */
--- a/include/linux/pagemap.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/include/linux/pagemap.h
@@ -538,7 +538,7 @@ static inline int lock_page_killable(str
  * lock_page_or_retry - Lock the page, unless this would block and the
  * caller indicated that it can handle a retry.
  *
- * Return value and mmap_sem implications depend on flags; see
+ * Return value and mmap_lock implications depend on flags; see
  * __lock_page_or_retry().
  */
 static inline int lock_page_or_retry(struct page *page, struct mm_struct *mm,
--- a/include/linux/pgtable.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/include/linux/pgtable.h
@@ -1134,11 +1134,11 @@ static inline pmd_t pmd_read_atomic(pmd_
 #endif
 /*
  * This function is meant to be used by sites walking pagetables with
- * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
+ * the mmap_lock held in read mode to protect against MADV_DONTNEED and
  * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
  * into a null pmd and the transhuge page fault can convert a null pmd
  * into an hugepmd or into a regular pmd (if the hugepage allocation
- * fails). While holding the mmap_sem in read mode the pmd becomes
+ * fails). While holding the mmap_lock in read mode the pmd becomes
  * stable and stops changing under us only if it's not null and not a
  * transhuge pmd. When those races occurs and this function makes a
  * difference vs the standard pmd_none_or_clear_bad, the result is
@@ -1148,7 +1148,7 @@ static inline pmd_t pmd_read_atomic(pmd_
  *
  * For 32bit kernels with a 64bit large pmd_t this automatically takes
  * care of reading the pmd atomically to avoid SMP race conditions
- * against pmd_populate() when the mmap_sem is hold for reading by the
+ * against pmd_populate() when the mmap_lock is hold for reading by the
  * caller (a special atomic read not done by "gcc" as in the generic
  * version above, is also needed when THP is disabled because the page
  * fault can populate the pmd from under us).
--- a/include/linux/rmap.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/include/linux/rmap.h
@@ -77,7 +77,7 @@ struct anon_vma {
 struct anon_vma_chain {
 	struct vm_area_struct *vma;
 	struct anon_vma *anon_vma;
-	struct list_head same_vma;   /* locked by mmap_sem & page_table_lock */
+	struct list_head same_vma;   /* locked by mmap_lock & page_table_lock */
 	struct rb_node rb;			/* locked by anon_vma->rwsem */
 	unsigned long rb_subtree_last;
 #ifdef CONFIG_DEBUG_VM_RB
--- a/include/linux/sched/mm.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/include/linux/sched/mm.h
@@ -53,7 +53,7 @@ void mmdrop(struct mm_struct *mm);
 
 /*
  * This has to be called after a get_task_mm()/mmget_not_zero()
- * followed by taking the mmap_sem for writing before modifying the
+ * followed by taking the mmap_lock for writing before modifying the
  * vmas or anything the coredump pretends not to change from under it.
  *
  * It also has to be called when mmgrab() is used in the context of
@@ -61,14 +61,14 @@ void mmdrop(struct mm_struct *mm);
  * the context of the process to run down_write() on that pinned mm.
  *
  * NOTE: find_extend_vma() called from GUP context is the only place
- * that can modify the "mm" (notably the vm_start/end) under mmap_sem
+ * that can modify the "mm" (notably the vm_start/end) under mmap_lock
  * for reading and outside the context of the process, so it is also
- * the only case that holds the mmap_sem for reading that must call
- * this function. Generally if the mmap_sem is hold for reading
+ * the only case that holds the mmap_lock for reading that must call
+ * this function. Generally if the mmap_lock is hold for reading
  * there's no need of this check after get_task_mm()/mmget_not_zero().
  *
  * This function can be obsoleted and the check can be removed, after
- * the coredump code will hold the mmap_sem for writing before
+ * the coredump code will hold the mmap_lock for writing before
  * invoking the ->core_dump methods.
  */
 static inline bool mmget_still_valid(struct mm_struct *mm)
--- a/kernel/acct.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/kernel/acct.c
@@ -40,7 +40,7 @@
  *  is one more bug... 10/11/98, AV.
  *
  *	Oh, fsck... Oopsable SMP race in do_process_acct() - we must hold
- * ->mmap_sem to walk the vma list of current->mm. Nasty, since it leaks
+ * ->mmap_lock to walk the vma list of current->mm. Nasty, since it leaks
  * a struct file opened for write. Fixed. 2/6/2000, AV.
  */
 
--- a/kernel/cgroup/cpuset.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/kernel/cgroup/cpuset.c
@@ -1655,7 +1655,7 @@ static void update_tasks_nodemask(struct
 	guarantee_online_mems(cs, &newmems);
 
 	/*
-	 * The mpol_rebind_mm() call takes mmap_sem, which we couldn't
+	 * The mpol_rebind_mm() call takes mmap_lock, which we couldn't
 	 * take while holding tasklist_lock.  Forks can happen - the
 	 * mpol_dup() cpuset_being_rebound check will catch such forks,
 	 * and rebind their vma mempolicies too.  Because we still hold
@@ -1760,7 +1760,7 @@ static void update_nodemasks_hier(struct
  *
  * Call with cpuset_mutex held. May take callback_lock during call.
  * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
- * lock each such tasks mm->mmap_sem, scan its vma's and rebind
+ * lock each such tasks mm->mmap_lock, scan its vma's and rebind
  * their mempolicies to the cpusets new mems_allowed.
  */
 static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
--- a/kernel/events/core.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/kernel/events/core.c
@@ -1316,7 +1316,7 @@ static void put_ctx(struct perf_event_co
  *	    perf_event::child_mutex;
  *	      perf_event_context::lock
  *	    perf_event::mmap_mutex
- *	    mmap_sem
+ *	    mmap_lock
  *	      perf_addr_filters_head::lock
  *
  *    cpu_hotplug_lock
@@ -3080,7 +3080,7 @@ static int perf_event_stop(struct perf_e
  *     pre-existing mappings, called once when new filters arrive via SET_FILTER
  *     ioctl;
  * (2) perf_addr_filters_adjust(): adjusting filters' offsets based on newly
- *     registered mapping, called for every new mmap(), with mm::mmap_sem down
+ *     registered mapping, called for every new mmap(), with mm::mmap_lock down
  *     for reading;
  * (3) perf_event_addr_filters_exec(): clearing filters' offsets in the process
  *     of exec.
@@ -9742,7 +9742,7 @@ static void perf_addr_filters_splice(str
 /*
  * Scan through mm's vmas and see if one of them matches the
  * @filter; if so, adjust filter's address range.
- * Called with mm::mmap_sem down for reading.
+ * Called with mm::mmap_lock down for reading.
  */
 static void perf_addr_filter_apply(struct perf_addr_filter *filter,
 				   struct mm_struct *mm,
--- a/kernel/events/uprobes.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/kernel/events/uprobes.c
@@ -457,7 +457,7 @@ static int update_ref_ctr(struct uprobe
  * @vaddr: the virtual address to store the opcode.
  * @opcode: opcode to be written at @vaddr.
  *
- * Called with mm->mmap_sem held for write.
+ * Called with mm->mmap_lock held for write.
  * Return 0 (success) or a negative errno.
  */
 int uprobe_write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
@@ -1349,7 +1349,7 @@ static int delayed_ref_ctr_inc(struct vm
 }
 
 /*
- * Called from mmap_region/vma_adjust with mm->mmap_sem acquired.
+ * Called from mmap_region/vma_adjust with mm->mmap_lock acquired.
  *
  * Currently we ignore all errors and always return 0, the callers
  * can't handle the failure anyway.
--- a/kernel/exit.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/kernel/exit.c
@@ -440,7 +440,7 @@ static void exit_mm(void)
 	sync_mm_rss(mm);
 	/*
 	 * Serialize with any possible pending coredump.
-	 * We must hold mmap_sem around checking core_state
+	 * We must hold mmap_lock around checking core_state
 	 * and clearing tsk->mm.  The core-inducing thread
 	 * will increment ->nr_threads for each thread in the
 	 * group with ->mm != NULL.
--- a/kernel/relay.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/kernel/relay.c
@@ -91,7 +91,7 @@ static void relay_free_page_array(struct
  *
  *	Returns 0 if ok, negative on error
  *
- *	Caller should already have grabbed mmap_sem.
+ *	Caller should already have grabbed mmap_lock.
  */
 static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
 {
--- a/kernel/sys.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/kernel/sys.c
@@ -2007,7 +2007,7 @@ static int prctl_set_mm_map(int opt, con
 	}
 
 	/*
-	 * arg_lock protects concurent updates but we still need mmap_sem for
+	 * arg_lock protects concurent updates but we still need mmap_lock for
 	 * read to exclude races with sys_brk.
 	 */
 	mmap_read_lock(mm);
@@ -2122,7 +2122,7 @@ static int prctl_set_mm(int opt, unsigne
 
 	/*
 	 * arg_lock protects concurent updates of arg boundaries, we need
-	 * mmap_sem for a) concurrent sys_brk, b) finding VMA for addr
+	 * mmap_lock for a) concurrent sys_brk, b) finding VMA for addr
 	 * validation.
 	 */
 	mmap_read_lock(mm);
--- a/lib/test_lockup.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/lib/test_lockup.c
@@ -103,7 +103,7 @@ MODULE_PARM_DESC(lock_rcu, "grab rcu_rea
 
 static bool lock_mmap_sem;
 module_param(lock_mmap_sem, bool, 0400);
-MODULE_PARM_DESC(lock_mmap_sem, "lock mm->mmap_sem: block procfs interfaces");
+MODULE_PARM_DESC(lock_mmap_sem, "lock mm->mmap_lock: block procfs interfaces");
 
 static unsigned long lock_rwsem_ptr;
 module_param_unsafe(lock_rwsem_ptr, ulong, 0400);
@@ -191,7 +191,7 @@ static void test_lock(bool master, bool
 
 	if (lock_mmap_sem && master) {
 		if (verbose)
-			pr_notice("lock mmap_sem pid=%d\n", main_task->pid);
+			pr_notice("lock mmap_lock pid=%d\n", main_task->pid);
 		if (lock_read)
 			mmap_read_lock(main_task->mm);
 		else
@@ -280,7 +280,7 @@ static void test_unlock(bool master, boo
 		else
 			mmap_write_unlock(main_task->mm);
 		if (verbose)
-			pr_notice("unlock mmap_sem pid=%d\n", main_task->pid);
+			pr_notice("unlock mmap_lock pid=%d\n", main_task->pid);
 	}
 
 	if (lock_rwsem_ptr && master) {
@@ -505,7 +505,7 @@ static int __init test_lockup_init(void)
 	}
 
 	if (lock_mmap_sem && !main_task->mm) {
-		pr_err("no mm to lock mmap_sem\n");
+		pr_err("no mm to lock mmap_lock\n");
 		return -EINVAL;
 	}
 
--- a/mm/filemap.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/filemap.c
@@ -76,16 +76,16 @@
  *  ->i_mutex
  *    ->i_mmap_rwsem		(truncate->unmap_mapping_range)
  *
- *  ->mmap_sem
+ *  ->mmap_lock
  *    ->i_mmap_rwsem
  *      ->page_table_lock or pte_lock	(various, mainly in memory.c)
  *        ->i_pages lock	(arch-dependent flush_dcache_mmap_lock)
  *
- *  ->mmap_sem
+ *  ->mmap_lock
  *    ->lock_page		(access_process_vm)
  *
  *  ->i_mutex			(generic_perform_write)
- *    ->mmap_sem		(fault_in_pages_readable->do_page_fault)
+ *    ->mmap_lock		(fault_in_pages_readable->do_page_fault)
  *
  *  bdi->wb.list_lock
  *    sb_lock			(fs/fs-writeback.c)
@@ -1371,21 +1371,21 @@ EXPORT_SYMBOL_GPL(__lock_page_killable);
 
 /*
  * Return values:
- * 1 - page is locked; mmap_sem is still held.
+ * 1 - page is locked; mmap_lock is still held.
  * 0 - page is not locked.
  *     mmap_lock has been released (mmap_read_unlock(), unless flags had both
  *     FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_RETRY_NOWAIT set, in
- *     which case mmap_sem is still held.
+ *     which case mmap_lock is still held.
  *
  * If neither ALLOW_RETRY nor KILLABLE are set, will always return 1
- * with the page locked and the mmap_sem unperturbed.
+ * with the page locked and the mmap_lock unperturbed.
  */
 int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 			 unsigned int flags)
 {
 	if (fault_flag_allow_retry_first(flags)) {
 		/*
-		 * CAUTION! In this case, mmap_sem is not released
+		 * CAUTION! In this case, mmap_lock is not released
 		 * even though return 0.
 		 */
 		if (flags & FAULT_FLAG_RETRY_NOWAIT)
@@ -2313,14 +2313,14 @@ EXPORT_SYMBOL(generic_file_read_iter);
 #ifdef CONFIG_MMU
 #define MMAP_LOTSAMISS  (100)
 /*
- * lock_page_maybe_drop_mmap - lock the page, possibly dropping the mmap_sem
+ * lock_page_maybe_drop_mmap - lock the page, possibly dropping the mmap_lock
  * @vmf - the vm_fault for this fault.
  * @page - the page to lock.
  * @fpin - the pointer to the file we may pin (or is already pinned).
  *
- * This works similar to lock_page_or_retry in that it can drop the mmap_sem.
+ * This works similar to lock_page_or_retry in that it can drop the mmap_lock.
  * It differs in that it actually returns the page locked if it returns 1 and 0
- * if it couldn't lock the page.  If we did have to drop the mmap_sem then fpin
+ * if it couldn't lock the page.  If we did have to drop the mmap_lock then fpin
  * will point to the pinned file and needs to be fput()'ed at a later point.
  */
 static int lock_page_maybe_drop_mmap(struct vm_fault *vmf, struct page *page,
@@ -2331,7 +2331,7 @@ static int lock_page_maybe_drop_mmap(str
 
 	/*
 	 * NOTE! This will make us return with VM_FAULT_RETRY, but with
-	 * the mmap_sem still held. That's how FAULT_FLAG_RETRY_NOWAIT
+	 * the mmap_lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
 	 * is supposed to work. We have way too many special cases..
 	 */
 	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
@@ -2341,10 +2341,10 @@ static int lock_page_maybe_drop_mmap(str
 	if (vmf->flags & FAULT_FLAG_KILLABLE) {
 		if (__lock_page_killable(page)) {
 			/*
-			 * We didn't have the right flags to drop the mmap_sem,
+			 * We didn't have the right flags to drop the mmap_lock,
 			 * but all fault_handlers only check for fatal signals
 			 * if we return VM_FAULT_RETRY, so we need to drop the
-			 * mmap_sem here and return 0 if we don't have a fpin.
+			 * mmap_lock here and return 0 if we don't have a fpin.
 			 */
 			if (*fpin == NULL)
 				mmap_read_unlock(vmf->vma->vm_mm);
@@ -2409,7 +2409,7 @@ static struct file *do_sync_mmap_readahe
 /*
  * Asynchronous readahead happens when we find the page and PG_readahead,
  * so we want to possibly extend the readahead further.  We return the file that
- * was pinned if we have to drop the mmap_sem in order to do IO.
+ * was pinned if we have to drop the mmap_lock in order to do IO.
  */
 static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 					    struct page *page)
@@ -2444,12 +2444,12 @@ static struct file *do_async_mmap_readah
  * it in the page cache, and handles the special cases reasonably without
  * having a lot of duplicated code.
  *
- * vma->vm_mm->mmap_sem must be held on entry.
+ * vma->vm_mm->mmap_lock must be held on entry.
  *
- * If our return value has VM_FAULT_RETRY set, it's because the mmap_sem
+ * If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
  * may be dropped before doing I/O or by lock_page_maybe_drop_mmap().
  *
- * If our return value does not have VM_FAULT_RETRY set, the mmap_sem
+ * If our return value does not have VM_FAULT_RETRY set, the mmap_lock
  * has not been released.
  *
  * We never return with VM_FAULT_RETRY and a bit from VM_FAULT_ERROR set.
@@ -2519,7 +2519,7 @@ retry_find:
 		goto page_not_uptodate;
 
 	/*
-	 * We've made it this far and we had to drop our mmap_sem, now is the
+	 * We've made it this far and we had to drop our mmap_lock, now is the
 	 * time to return to the upper layer and have it re-find the vma and
 	 * redo the fault.
 	 */
@@ -2569,7 +2569,7 @@ page_not_uptodate:
 
 out_retry:
 	/*
-	 * We dropped the mmap_sem, we need to return to the fault handler to
+	 * We dropped the mmap_lock, we need to return to the fault handler to
 	 * re-find the vma and come back and find our hopefully still populated
 	 * page.
 	 */
--- a/mm/frame_vector.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/frame_vector.c
@@ -29,7 +29,7 @@
  * different type underlying the specified range of virtual addresses.
  * When the function isn't able to map a single page, it returns error.
  *
- * This function takes care of grabbing mmap_sem as necessary.
+ * This function takes care of grabbing mmap_lock as necessary.
  */
 int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 		     unsigned int gup_flags, struct frame_vector *vec)
--- a/mm/gup.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/gup.c
@@ -592,7 +592,7 @@ retry:
 		pmdval = READ_ONCE(*pmd);
 		/*
 		 * MADV_DONTNEED may convert the pmd to null because
-		 * mmap_sem is held in read mode
+		 * mmap_lock is held in read mode
 		 */
 		if (pmd_none(pmdval))
 			return no_page_table(vma, flags);
@@ -855,8 +855,8 @@ unmap:
 }
 
 /*
- * mmap_sem must be held on entry.  If @locked != NULL and *@flags
- * does not include FOLL_NOWAIT, the mmap_sem may be released.  If it
+ * mmap_lock must be held on entry.  If @locked != NULL and *@flags
+ * does not include FOLL_NOWAIT, the mmap_lock may be released.  If it
  * is, *@locked will be set to 0 and -EBUSY returned.
  */
 static int faultin_page(struct task_struct *tsk, struct vm_area_struct *vma,
@@ -979,7 +979,7 @@ static int check_vma_flags(struct vm_are
  *		only intends to ensure the pages are faulted in.
  * @vmas:	array of pointers to vmas corresponding to each page.
  *		Or NULL if the caller does not require them.
- * @locked:     whether we're still with the mmap_sem held
+ * @locked:     whether we're still with the mmap_lock held
  *
  * Returns either number of pages pinned (which may be less than the
  * number requested), or an error. Details about the return value:
@@ -992,9 +992,9 @@ static int check_vma_flags(struct vm_are
  *
  * The caller is responsible for releasing returned @pages, via put_page().
  *
- * @vmas are valid only as long as mmap_sem is held.
+ * @vmas are valid only as long as mmap_lock is held.
  *
- * Must be called with mmap_sem held.  It may be released.  See below.
+ * Must be called with mmap_lock held.  It may be released.  See below.
  *
  * __get_user_pages walks a process's page tables and takes a reference to
  * each struct page that each user address corresponds to at a given
@@ -1015,12 +1015,12 @@ static int check_vma_flags(struct vm_are
  * appropriate) must be called after the page is finished with, and
  * before put_page is called.
  *
- * If @locked != NULL, *@locked will be set to 0 when mmap_sem is
+ * If @locked != NULL, *@locked will be set to 0 when mmap_lock is
  * released by an up_read().  That can happen if @gup_flags does not
  * have FOLL_NOWAIT.
  *
  * A caller using such a combination of @locked and @gup_flags
- * must therefore hold the mmap_sem for reading only, and recognize
+ * must therefore hold the mmap_lock for reading only, and recognize
  * when it's been released.  Otherwise, it must be held for either
  * reading or writing and will not be released.
  *
@@ -1083,7 +1083,7 @@ static long __get_user_pages(struct task
 				if (locked && *locked == 0) {
 					/*
 					 * We've got a VM_FAULT_RETRY
-					 * and we've lost mmap_sem.
+					 * and we've lost mmap_lock.
 					 * We must stop here.
 					 */
 					BUG_ON(gup_flags & FOLL_NOWAIT);
@@ -1190,7 +1190,7 @@ static bool vma_permits_fault(struct vm_
  * @mm:		mm_struct of target mm
  * @address:	user address
  * @fault_flags:flags to pass down to handle_mm_fault()
- * @unlocked:	did we unlock the mmap_sem while retrying, maybe NULL if caller
+ * @unlocked:	did we unlock the mmap_lock while retrying, maybe NULL if caller
  *		does not allow retry. If NULL, the caller must guarantee
  *		that fault_flags does not contain FAULT_FLAG_ALLOW_RETRY.
  *
@@ -1211,8 +1211,8 @@ static bool vma_permits_fault(struct vm_
  * such architectures, gup() will not be enough to make a subsequent access
  * succeed.
  *
- * This function will not return with an unlocked mmap_sem. So it has not the
- * same semantics wrt the @mm->mmap_sem as does filemap_fault().
+ * This function will not return with an unlocked mmap_lock. So it has not the
+ * same semantics wrt the @mm->mmap_lock as does filemap_fault().
  */
 int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 		     unsigned long address, unsigned int fault_flags,
@@ -1400,13 +1400,13 @@ retry:
  * @vma:   target vma
  * @start: start address
  * @end:   end address
- * @locked: whether the mmap_sem is still held
+ * @locked: whether the mmap_lock is still held
  *
  * This takes care of mlocking the pages too if VM_LOCKED is set.
  *
  * return 0 on success, negative error code on error.
  *
- * vma->vm_mm->mmap_sem must be held.
+ * vma->vm_mm->mmap_lock must be held.
  *
  * If @locked is NULL, it may be held for read or write and will
  * be unperturbed.
@@ -1458,7 +1458,7 @@ long populate_vma_page_range(struct vm_a
  *
  * This is used to implement mlock() and the MAP_POPULATE / MAP_LOCKED mmap
  * flags. VMAs must be already marked with the desired vm_flags, and
- * mmap_sem must not be held.
+ * mmap_lock must not be held.
  */
 int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 {
@@ -1525,7 +1525,7 @@ int __mm_populate(unsigned long start, u
  * NULL wherever the ZERO_PAGE, or an anonymous pte_none, has been found -
  * allowing a hole to be left in the corefile to save diskspace.
  *
- * Called without mmap_sem, but after all other threads have been killed.
+ * Called without mmap_lock, but after all other threads have been killed.
  */
 #ifdef CONFIG_ELF_CORE
 struct page *get_dump_page(unsigned long addr)
@@ -1886,9 +1886,9 @@ static long __get_user_pages_remote(stru
  *
  * The caller is responsible for releasing returned @pages, via put_page().
  *
- * @vmas are valid only as long as mmap_sem is held.
+ * @vmas are valid only as long as mmap_lock is held.
  *
- * Must be called with mmap_sem held for read or write.
+ * Must be called with mmap_lock held for read or write.
  *
  * get_user_pages_remote walks a process's page tables and takes a reference
  * to each struct page that each user address corresponds to at a given
@@ -2873,7 +2873,7 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast_on
  * @pages:      array that receives pointers to the pages pinned.
  *              Should be at least nr_pages long.
  *
- * Attempt to pin user pages in memory without taking mm->mmap_sem.
+ * Attempt to pin user pages in memory without taking mm->mmap_lock.
  * If not successful, it will fall back to taking the lock and
  * calling get_user_pages().
  *
--- a/mm/huge_memory.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/huge_memory.c
@@ -1746,7 +1746,7 @@ bool move_huge_pmd(struct vm_area_struct
 
 	/*
 	 * We don't have to worry about the ordering of src and dst
-	 * ptlocks because exclusive mmap_sem prevents deadlock.
+	 * ptlocks because exclusive mmap_lock prevents deadlock.
 	 */
 	old_ptl = __pmd_trans_huge_lock(old_pmd, vma);
 	if (old_ptl) {
@@ -2618,7 +2618,7 @@ int split_huge_page_to_list(struct page
 
 	if (PageAnon(head)) {
 		/*
-		 * The caller does not necessarily hold an mmap_sem that would
+		 * The caller does not necessarily hold an mmap_lock that would
 		 * prevent the anon_vma disappearing so we first we take a
 		 * reference to it and then lock the anon_vma for write. This
 		 * is similar to page_lock_anon_vma_read except the write lock
--- a/mm/hugetlb.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/hugetlb.c
@@ -4695,7 +4695,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 						(const void __user *) src_addr,
 						pages_per_huge_page(h), false);
 
-		/* fallback to copy_from_user outside mmap_sem */
+		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
 			ret = -ENOENT;
 			*pagep = page;
--- a/mm/internal.h~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/internal.h
@@ -344,7 +344,7 @@ static inline void munlock_vma_pages_all
 }
 
 /*
- * must be called with vma's mmap_sem held for read or write, and page locked.
+ * must be called with vma's mmap_lock held for read or write, and page locked.
  */
 extern void mlock_vma_page(struct page *page);
 extern unsigned int munlock_vma_page(struct page *page);
@@ -413,7 +413,7 @@ static inline struct file *maybe_unlock_
 
 	/*
 	 * FAULT_FLAG_RETRY_NOWAIT means we don't want to wait on page locks or
-	 * anything, so we only pin the file and drop the mmap_sem if only
+	 * anything, so we only pin the file and drop the mmap_lock if only
 	 * FAULT_FLAG_ALLOW_RETRY is set, while this is the first attempt.
 	 */
 	if (fault_flag_allow_retry_first(flags) &&
--- a/mm/khugepaged.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/khugepaged.c
@@ -534,7 +534,7 @@ void __khugepaged_exit(struct mm_struct
 		 * under mmap sem read mode). Stop here (after we
 		 * return all pagetables will be destroyed) until
 		 * khugepaged has finished working on the pagetables
-		 * under the mmap_sem.
+		 * under the mmap_lock.
 		 */
 		mmap_write_lock(mm);
 		mmap_write_unlock(mm);
@@ -933,8 +933,8 @@ khugepaged_alloc_page(struct page **hpag
 #endif
 
 /*
- * If mmap_sem temporarily dropped, revalidate vma
- * before taking mmap_sem.
+ * If mmap_lock temporarily dropped, revalidate vma
+ * before taking mmap_lock.
  * Return 0 if succeeds, otherwise return none-zero
  * value (scan code).
  */
@@ -966,7 +966,7 @@ static int hugepage_vma_revalidate(struc
  * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
  * Called and returns without pte mapped or spinlocks held,
- * but with mmap_sem held to protect against vma changes.
+ * but with mmap_lock held to protect against vma changes.
  */
 
 static bool __collapse_huge_page_swapin(struct mm_struct *mm,
@@ -993,7 +993,7 @@ static bool __collapse_huge_page_swapin(
 		swapped_in++;
 		ret = do_swap_page(&vmf);
 
-		/* do_swap_page returns VM_FAULT_RETRY with released mmap_sem */
+		/* do_swap_page returns VM_FAULT_RETRY with released mmap_lock */
 		if (ret & VM_FAULT_RETRY) {
 			mmap_read_lock(mm);
 			if (hugepage_vma_revalidate(mm, address, &vmf.vma)) {
@@ -1047,9 +1047,9 @@ static void collapse_huge_page(struct mm
 	gfp = alloc_hugepage_khugepaged_gfpmask() | __GFP_THISNODE;
 
 	/*
-	 * Before allocating the hugepage, release the mmap_sem read lock.
+	 * Before allocating the hugepage, release the mmap_lock read lock.
 	 * The allocation can take potentially a long time if it involves
-	 * sync compaction, and we do not need to hold the mmap_sem during
+	 * sync compaction, and we do not need to hold the mmap_lock during
 	 * that. We will recheck the vma after taking it again in write mode.
 	 */
 	mmap_read_unlock(mm);
@@ -1080,8 +1080,8 @@ static void collapse_huge_page(struct mm
 	}
 
 	/*
-	 * __collapse_huge_page_swapin always returns with mmap_sem locked.
-	 * If it fails, we release mmap_sem and jump out_nolock.
+	 * __collapse_huge_page_swapin always returns with mmap_lock locked.
+	 * If it fails, we release mmap_lock and jump out_nolock.
 	 * Continuing to collapse causes inconsistency.
 	 */
 	if (unmapped && !__collapse_huge_page_swapin(mm, vma, address,
@@ -1345,7 +1345,7 @@ out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (ret) {
 		node = khugepaged_find_target_node();
-		/* collapse_huge_page will return with the mmap_sem released */
+		/* collapse_huge_page will return with the mmap_lock released */
 		collapse_huge_page(mm, address, hpage, node,
 				referenced, unmapped);
 	}
@@ -1547,7 +1547,7 @@ static void retract_page_tables(struct a
 		 * later.
 		 *
 		 * Not that vma->anon_vma check is racy: it can be set up after
-		 * the check but before we took mmap_sem by the fault path.
+		 * the check but before we took mmap_lock by the fault path.
 		 * But page lock would prevent establishing any new ptes of the
 		 * page, so we are safe.
 		 *
@@ -1567,10 +1567,10 @@ static void retract_page_tables(struct a
 		if (!pmd)
 			continue;
 		/*
-		 * We need exclusive mmap_sem to retract page table.
+		 * We need exclusive mmap_lock to retract page table.
 		 *
 		 * We use trylock due to lock inversion: we need to acquire
-		 * mmap_sem while holding page lock. Fault path does it in
+		 * mmap_lock while holding page lock. Fault path does it in
 		 * reverse order. Trylock is a way to avoid deadlock.
 		 */
 		if (mmap_write_trylock(vma->vm_mm)) {
@@ -2058,7 +2058,7 @@ static unsigned int khugepaged_scan_mm_s
 	 */
 	vma = NULL;
 	if (unlikely(!mmap_read_trylock(mm)))
-		goto breakouterloop_mmap_sem;
+		goto breakouterloop_mmap_lock;
 	if (likely(!khugepaged_test_exit(mm)))
 		vma = find_vma(mm, khugepaged_scan.address);
 
@@ -2115,15 +2115,15 @@ skip:
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			progress += HPAGE_PMD_NR;
 			if (ret)
-				/* we released mmap_sem so break loop */
-				goto breakouterloop_mmap_sem;
+				/* we released mmap_lock so break loop */
+				goto breakouterloop_mmap_lock;
 			if (progress >= pages)
 				goto breakouterloop;
 		}
 	}
 breakouterloop:
 	mmap_read_unlock(mm); /* exit_mmap will destroy ptes after this */
-breakouterloop_mmap_sem:
+breakouterloop_mmap_lock:
 
 	spin_lock(&khugepaged_mm_lock);
 	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
--- a/mm/ksm.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/ksm.c
@@ -442,7 +442,7 @@ static void insert_to_mm_slots_hash(stru
 /*
  * ksmd, and unmerge_and_remove_all_rmap_items(), must not touch an mm's
  * page tables after it has passed through ksm_exit() - which, if necessary,
- * takes mmap_sem briefly to serialize against them.  ksm_exit() does not set
+ * takes mmap_lock briefly to serialize against them.  ksm_exit() does not set
  * a special flag: they can just back out as soon as mm_users goes to zero.
  * ksm_test_exit() is used throughout to make this test for exit: in some
  * places for correctness, in some places just to avoid unnecessary work.
@@ -831,7 +831,7 @@ static void remove_trailing_rmap_items(s
  * Though it's very tempting to unmerge rmap_items from stable tree rather
  * than check every pte of a given vma, the locking doesn't quite work for
  * that - an rmap_item is assigned to the stable tree after inserting ksm
- * page and upping mmap_sem.  Nor does it fit with the way we skip dup'ing
+ * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
  * rmap_items from parent to child at fork time (so as not to waste time
  * if exit comes before the next scan reaches it).
  *
@@ -1292,7 +1292,7 @@ static int try_to_merge_with_ksm_page(st
 	/* Unstable nid is in union with stable anon_vma: remove first */
 	remove_rmap_item_from_tree(rmap_item);
 
-	/* Must get reference to anon_vma while still holding mmap_sem */
+	/* Must get reference to anon_vma while still holding mmap_lock */
 	rmap_item->anon_vma = vma->anon_vma;
 	get_anon_vma(vma->anon_vma);
 out:
@@ -2343,13 +2343,13 @@ next_mm:
 						struct mm_slot, mm_list);
 	if (ksm_scan.address == 0) {
 		/*
-		 * We've completed a full scan of all vmas, holding mmap_sem
+		 * We've completed a full scan of all vmas, holding mmap_lock
 		 * throughout, and found no VM_MERGEABLE: so do the same as
 		 * __ksm_exit does to remove this mm from all our lists now.
 		 * This applies either when cleaning up after __ksm_exit
 		 * (but beware: we can reach here even before __ksm_exit),
 		 * or when all VM_MERGEABLE areas have been unmapped (and
-		 * mmap_sem then protects against race with MADV_MERGEABLE).
+		 * mmap_lock then protects against race with MADV_MERGEABLE).
 		 */
 		hash_del(&slot->link);
 		list_del(&slot->mm_list);
@@ -2536,7 +2536,7 @@ void __ksm_exit(struct mm_struct *mm)
 	 * This process is exiting: if it's straightforward (as is the
 	 * case when ksmd was never running), free mm_slot immediately.
 	 * But if it's at the cursor or has rmap_items linked to it, use
-	 * mmap_sem to synchronize with any break_cows before pagetables
+	 * mmap_lock to synchronize with any break_cows before pagetables
 	 * are freed, and leave the mm_slot on the list for ksmd to free.
 	 * Beware: ksm may already have noticed it exiting and freed the slot.
 	 */
--- a/mm/maccess.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/maccess.c
@@ -40,9 +40,9 @@ probe_write_common(void __user *dst, con
  * happens, handle that and return -EFAULT.
  *
  * We ensure that the copy_from_user is executed in atomic context so that
- * do_page_fault() doesn't attempt to take mmap_sem.  This makes
+ * do_page_fault() doesn't attempt to take mmap_lock.  This makes
  * probe_kernel_read() suitable for use within regions where the caller
- * already holds mmap_sem, or other locks which nest inside mmap_sem.
+ * already holds mmap_lock, or other locks which nest inside mmap_lock.
  *
  * probe_kernel_read_strict() is the same as probe_kernel_read() except for
  * the case where architectures have non-overlapping user and kernel address
--- a/mm/madvise.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/madvise.c
@@ -40,7 +40,7 @@ struct madvise_walk_private {
 
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
- * take mmap_sem for writing. Others, which simply traverse vmas, need
+ * take mmap_lock for writing. Others, which simply traverse vmas, need
  * to only take it for reading.
  */
 static int madvise_need_mmap_write(int behavior)
@@ -165,7 +165,7 @@ static long madvise_behavior(struct vm_a
 
 success:
 	/*
-	 * vm_flags is protected by the mmap_sem held in write mode.
+	 * vm_flags is protected by the mmap_lock held in write mode.
 	 */
 	vma->vm_flags = new_flags;
 
@@ -285,9 +285,9 @@ static long madvise_willneed(struct vm_a
 	 * Filesystem's fadvise may need to take various locks.  We need to
 	 * explicitly grab a reference because the vma (and hence the
 	 * vma's reference to the file) can go away as soon as we drop
-	 * mmap_sem.
+	 * mmap_lock.
 	 */
-	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
+	*prev = NULL;	/* tell sys_madvise we drop mmap_lock */
 	get_file(file);
 	mmap_read_unlock(current->mm);
 	offset = (loff_t)(start - vma->vm_start)
@@ -768,7 +768,7 @@ static long madvise_dontneed_free(struct
 		return -EINVAL;
 
 	if (!userfaultfd_remove(vma, start, end)) {
-		*prev = NULL; /* mmap_sem has been dropped, prev is stale */
+		*prev = NULL; /* mmap_lock has been dropped, prev is stale */
 
 		mmap_read_lock(current->mm);
 		vma = find_vma(current->mm, start);
@@ -791,7 +791,7 @@ static long madvise_dontneed_free(struct
 		if (end > vma->vm_end) {
 			/*
 			 * Don't fail if end > vma->vm_end. If the old
-			 * vma was splitted while the mmap_sem was
+			 * vma was splitted while the mmap_lock was
 			 * released the effect of the concurrent
 			 * operation may not cause madvise() to
 			 * have an undefined result. There may be an
@@ -826,7 +826,7 @@ static long madvise_remove(struct vm_are
 	int error;
 	struct file *f;
 
-	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
+	*prev = NULL;	/* tell sys_madvise we drop mmap_lock */
 
 	if (vma->vm_flags & VM_LOCKED)
 		return -EINVAL;
@@ -847,11 +847,11 @@ static long madvise_remove(struct vm_are
 	 * Filesystem's fallocate may need to take i_mutex.  We need to
 	 * explicitly grab a reference because the vma (and hence the
 	 * vma's reference to the file) can go away as soon as we drop
-	 * mmap_sem.
+	 * mmap_lock.
 	 */
 	get_file(f);
 	if (userfaultfd_remove(vma, start, end)) {
-		/* mmap_sem was not released by userfaultfd_remove() */
+		/* mmap_lock was not released by userfaultfd_remove() */
 		mmap_read_unlock(current->mm);
 	}
 	error = vfs_fallocate(f,
@@ -1153,7 +1153,7 @@ int do_madvise(unsigned long start, size
 			goto out;
 		if (prev)
 			vma = prev->vm_next;
-		else	/* madvise_remove dropped mmap_sem */
+		else	/* madvise_remove dropped mmap_lock */
 			vma = find_vma(current->mm, start);
 	}
 out:
--- a/mm/memcontrol.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/memcontrol.c
@@ -5901,7 +5901,7 @@ static void mem_cgroup_move_charge(void)
 retry:
 	if (unlikely(!mmap_read_trylock(mc.mm))) {
 		/*
-		 * Someone who are holding the mmap_sem might be waiting in
+		 * Someone who are holding the mmap_lock might be waiting in
 		 * waitq. So we cancel all extra charges, wake up all waiters,
 		 * and retry. Because we cancel precharges, we might not be able
 		 * to move enough charges, but moving charge is a best-effort
--- a/mm/memory.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/memory.c
@@ -1185,7 +1185,7 @@ static inline unsigned long zap_pmd_rang
 		 * Here there can be other concurrent MADV_DONTNEED or
 		 * trans huge page faults running, and if the pmd is
 		 * none or trans huge it can change under us. This is
-		 * because MADV_DONTNEED holds the mmap_sem in read
+		 * because MADV_DONTNEED holds the mmap_lock in read
 		 * mode.
 		 */
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
@@ -1636,7 +1636,7 @@ EXPORT_SYMBOL(vm_insert_pages);
  * The page does not need to be reserved.
  *
  * Usually this function is called from f_op->mmap() handler
- * under mm->mmap_sem write-lock, so it can change vma->vm_flags.
+ * under mm->mmap_lock write-lock, so it can change vma->vm_flags.
  * Caller must set VM_MIXEDMAP on vma if it wants to call this
  * function from other places, for example from page-fault handler.
  *
@@ -2573,7 +2573,7 @@ static vm_fault_t fault_dirty_shared_pag
 	 * mapping may be NULL here because some device drivers do not
 	 * set page.mapping but still dirty their pages
 	 *
-	 * Drop the mmap_sem before waiting on IO, if we can. The file
+	 * Drop the mmap_lock before waiting on IO, if we can. The file
 	 * is pinning the mapping, as per above.
 	 */
 	if ((dirtied || page_mkwrite) && mapping) {
@@ -2623,7 +2623,7 @@ static inline void wp_page_reuse(struct
 /*
  * Handle the case of a page which we actually need to copy to a new page.
  *
- * Called with mmap_sem locked and the old page referenced, but
+ * Called with mmap_lock locked and the old page referenced, but
  * without the ptl held.
  *
  * High level logic flow:
@@ -2887,9 +2887,9 @@ static vm_fault_t wp_page_shared(struct
  * change only once the write actually happens. This avoids a few races,
  * and potentially makes it more efficient.
  *
- * We enter with non-exclusive mmap_sem (to exclude vma changes,
+ * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), with pte both mapped and locked.
- * We return with mmap_sem still held, but pte unmapped and unlocked.
+ * We return with mmap_lock still held, but pte unmapped and unlocked.
  */
 static vm_fault_t do_wp_page(struct vm_fault *vmf)
 	__releases(vmf->ptl)
@@ -3078,11 +3078,11 @@ void unmap_mapping_range(struct address_
 EXPORT_SYMBOL(unmap_mapping_range);
 
 /*
- * We enter with non-exclusive mmap_sem (to exclude vma changes,
+ * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
  * We return with pte unmapped and unlocked.
  *
- * We return with the mmap_sem locked or unlocked in the same cases
+ * We return with the mmap_lock locked or unlocked in the same cases
  * as does filemap_fault().
  */
 vm_fault_t do_swap_page(struct vm_fault *vmf)
@@ -3303,9 +3303,9 @@ out_release:
 }
 
 /*
- * We enter with non-exclusive mmap_sem (to exclude vma changes,
+ * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
- * We return with mmap_sem still held, but pte unmapped and unlocked.
+ * We return with mmap_lock still held, but pte unmapped and unlocked.
  */
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
@@ -3419,7 +3419,7 @@ oom:
 }
 
 /*
- * The mmap_sem must have been held on entry, and may have been
+ * The mmap_lock must have been held on entry, and may have been
  * released depending on flags and vma->vm_ops->fault() return value.
  * See filemap_fault() and __lock_page_retry().
  */
@@ -3928,11 +3928,11 @@ static vm_fault_t do_shared_fault(struct
 }
 
 /*
- * We enter with non-exclusive mmap_sem (to exclude vma changes,
+ * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults).
- * The mmap_sem may have been released depending on flags and our
+ * The mmap_lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __lock_page_or_retry().
- * If mmap_sem is released, vma may become invalid (for example
+ * If mmap_lock is released, vma may become invalid (for example
  * by other thread calling munmap()).
  */
 static vm_fault_t do_fault(struct vm_fault *vmf)
@@ -4161,10 +4161,10 @@ static vm_fault_t wp_huge_pud(struct vm_
  * with external mmu caches can use to update those (ie the Sparc or
  * PowerPC hashed page tables that act as extended TLBs).
  *
- * We enter with non-exclusive mmap_sem (to exclude vma changes, but allow
+ * We enter with non-exclusive mmap_lock (to exclude vma changes, but allow
  * concurrent faults).
  *
- * The mmap_sem may have been released depending on flags and our return value.
+ * The mmap_lock may have been released depending on flags and our return value.
  * See filemap_fault() and __lock_page_or_retry().
  */
 static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
@@ -4186,7 +4186,7 @@ static vm_fault_t handle_pte_fault(struc
 		/*
 		 * A regular pmd is established and it can't morph into a huge
 		 * pmd from under us anymore at this point because we hold the
-		 * mmap_sem read mode and khugepaged takes it in write mode.
+		 * mmap_lock read mode and khugepaged takes it in write mode.
 		 * So now it's safe to run pte_offset_map().
 		 */
 		vmf->pte = pte_offset_map(vmf->pmd, vmf->address);
@@ -4254,7 +4254,7 @@ unlock:
 /*
  * By the time we get here, we already hold the mm semaphore
  *
- * The mmap_sem may have been released depending on flags and our
+ * The mmap_lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __lock_page_or_retry().
  */
 static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
@@ -4349,7 +4349,7 @@ retry_pud:
 /*
  * By the time we get here, we already hold the mm semaphore
  *
- * The mmap_sem may have been released depending on flags and our
+ * The mmap_lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __lock_page_or_retry().
  */
 vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
@@ -4793,7 +4793,7 @@ void __might_fault(const char *file, int
 {
 	/*
 	 * Some code (nfs/sunrpc) uses socket ops on kernel memory while
-	 * holding the mmap_sem, this is safe because kernel memory doesn't
+	 * holding the mmap_lock, this is safe because kernel memory doesn't
 	 * get paged out, therefore we'll never actually fault, and the
 	 * below annotations will generate false positives.
 	 */
--- a/mm/mempolicy.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/mempolicy.c
@@ -224,7 +224,7 @@ static int mpol_new_bind(struct mempolic
  * handle an empty nodemask with MPOL_PREFERRED here.
  *
  * Must be called holding task's alloc_lock to protect task's mems_allowed
- * and mempolicy.  May also be called holding the mmap_semaphore for write.
+ * and mempolicy.  May also be called holding the mmap_lock for write.
  */
 static int mpol_set_nodemask(struct mempolicy *pol,
 		     const nodemask_t *nodes, struct nodemask_scratch *nsc)
@@ -368,7 +368,7 @@ static void mpol_rebind_preferred(struct
 /*
  * mpol_rebind_policy - Migrate a policy to a different set of nodes
  *
- * Per-vma policies are protected by mmap_sem. Allocations using per-task
+ * Per-vma policies are protected by mmap_lock. Allocations using per-task
  * policies are protected by task->mems_allowed_seq to prevent a premature
  * OOM/allocation failure due to parallel nodemask modification.
  */
@@ -398,7 +398,7 @@ void mpol_rebind_task(struct task_struct
 /*
  * Rebind each vma in mm to new nodemask.
  *
- * Call holding a reference to mm.  Takes mm->mmap_sem during call.
+ * Call holding a reference to mm.  Takes mm->mmap_lock during call.
  */
 
 void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
@@ -764,7 +764,7 @@ queue_pages_range(struct mm_struct *mm,
 
 /*
  * Apply policy to a single VMA
- * This must be called with the mmap_sem held for writing.
+ * This must be called with the mmap_lock held for writing.
  */
 static int vma_replace_policy(struct vm_area_struct *vma,
 						struct mempolicy *pol)
@@ -789,7 +789,7 @@ static int vma_replace_policy(struct vm_
 	}
 
 	old = vma->vm_policy;
-	vma->vm_policy = new; /* protected by mmap_sem */
+	vma->vm_policy = new; /* protected by mmap_lock */
 	mpol_put(old);
 
 	return 0;
@@ -985,7 +985,7 @@ static long do_get_mempolicy(int *policy
 		if (flags & MPOL_F_ADDR) {
 			/*
 			 * Take a refcount on the mpol, lookup_node()
-			 * wil drop the mmap_sem, so after calling
+			 * wil drop the mmap_lock, so after calling
 			 * lookup_node() only "pol" remains valid, "vma"
 			 * is stale.
 			 */
--- a/mm/migrate.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/migrate.c
@@ -2120,7 +2120,7 @@ int migrate_misplaced_transhuge_page(str
 	 * pmd before doing set_pmd_at(), nor to flush the TLB after
 	 * set_pmd_at().  Clearing the pmd here would introduce a race
 	 * condition against MADV_DONTNEED, because MADV_DONTNEED only holds the
-	 * mmap_sem for reading.  If the pmd is set to NULL at any given time,
+	 * mmap_lock for reading.  If the pmd is set to NULL at any given time,
 	 * MADV_DONTNEED won't wait on the pmd lock and it'll skip clearing this
 	 * pmd.
 	 */
@@ -2675,7 +2675,7 @@ restore:
  * have the MIGRATE_PFN_MIGRATE flag set for their src array entry.
  *
  * It is safe to update device page table after migrate_vma_pages() because
- * both destination and source page are still locked, and the mmap_sem is held
+ * both destination and source page are still locked, and the mmap_lock is held
  * in read mode (hence no one can unmap the range being migrated).
  *
  * Once the caller is done cleaning up things and updating its page table (if it
--- a/mm/mlock.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/mlock.c
@@ -49,7 +49,7 @@ EXPORT_SYMBOL(can_do_mlock);
  * When lazy mlocking via vmscan, it is important to ensure that the
  * vma's VM_LOCKED status is not concurrently being modified, otherwise we
  * may have mlocked a page that is being munlocked. So lazy mlock must take
- * the mmap_sem for read, and verify that the vma really is locked
+ * the mmap_lock for read, and verify that the vma really is locked
  * (see mm/rmap.c).
  */
 
@@ -381,7 +381,7 @@ static unsigned long __munlock_pagevec_f
 	/*
 	 * Initialize pte walk starting at the already pinned page where we
 	 * are sure that there is a pte, as it was pinned under the same
-	 * mmap_sem write op.
+	 * mmap_lock write op.
 	 */
 	pte = get_locked_pte(vma->vm_mm, start,	&ptl);
 	/* Make sure we do not cross the page table boundary */
@@ -565,7 +565,7 @@ success:
 	mm->locked_vm += nr_pages;
 
 	/*
-	 * vm_flags is protected by the mmap_sem held in write mode.
+	 * vm_flags is protected by the mmap_lock held in write mode.
 	 * It's okay if try_to_unmap_one unmaps a page just after we
 	 * set VM_LOCKED, populate_vma_page_range will bring it back.
 	 */
--- a/mm/mmap.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/mmap.c
@@ -132,7 +132,7 @@ void vma_set_page_prot(struct vm_area_st
 		vm_flags &= ~VM_SHARED;
 		vm_page_prot = vm_pgprot_modify(vm_page_prot, vm_flags);
 	}
-	/* remove_protection_ptes reads vma->vm_page_prot without mmap_sem */
+	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
 	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
 }
 
@@ -238,14 +238,14 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 
 	/*
 	 * Always allow shrinking brk.
-	 * __do_munmap() may downgrade mmap_sem to read.
+	 * __do_munmap() may downgrade mmap_lock to read.
 	 */
 	if (brk <= mm->brk) {
 		int ret;
 
 		/*
-		 * mm->brk must to be protected by write mmap_sem so update it
-		 * before downgrading mmap_sem. When __do_munmap() fails,
+		 * mm->brk must to be protected by write mmap_lock so update it
+		 * before downgrading mmap_lock. When __do_munmap() fails,
 		 * mm->brk will be restored from origbrk.
 		 */
 		mm->brk = brk;
@@ -505,7 +505,7 @@ static __always_inline void vma_rb_erase
  * After the update, the vma will be reinserted using
  * anon_vma_interval_tree_post_update_vma().
  *
- * The entire update must be protected by exclusive mmap_sem and by
+ * The entire update must be protected by exclusive mmap_lock and by
  * the root anon_vma's mutex.
  */
 static inline void
@@ -2371,7 +2371,7 @@ int expand_upwards(struct vm_area_struct
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
-	 * is required to hold the mmap_sem in read mode.  We need the
+	 * is required to hold the mmap_lock in read mode.  We need the
 	 * anon_vma lock to serialize against concurrent expand_stacks.
 	 */
 	anon_vma_lock_write(vma->anon_vma);
@@ -2389,7 +2389,7 @@ int expand_upwards(struct vm_area_struct
 			if (!error) {
 				/*
 				 * vma_gap_update() doesn't support concurrent
-				 * updates, but we only hold a shared mmap_sem
+				 * updates, but we only hold a shared mmap_lock
 				 * lock here, so we need to protect against
 				 * concurrent vma expansions.
 				 * anon_vma_lock_write() doesn't help here, as
@@ -2451,7 +2451,7 @@ int expand_downwards(struct vm_area_stru
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
-	 * is required to hold the mmap_sem in read mode.  We need the
+	 * is required to hold the mmap_lock in read mode.  We need the
 	 * anon_vma lock to serialize against concurrent expand_stacks.
 	 */
 	anon_vma_lock_write(vma->anon_vma);
@@ -2469,7 +2469,7 @@ int expand_downwards(struct vm_area_stru
 			if (!error) {
 				/*
 				 * vma_gap_update() doesn't support concurrent
-				 * updates, but we only hold a shared mmap_sem
+				 * updates, but we only hold a shared mmap_lock
 				 * lock here, so we need to protect against
 				 * concurrent vma expansions.
 				 * anon_vma_lock_write() doesn't help here, as
@@ -2855,7 +2855,7 @@ static int __vm_munmap(unsigned long sta
 
 	ret = __do_munmap(mm, start, len, &uf, downgrade);
 	/*
-	 * Returning 1 indicates mmap_sem is downgraded.
+	 * Returning 1 indicates mmap_lock is downgraded.
 	 * But 1 is not legal return value of vm_munmap() and munmap(), reset
 	 * it to 0 before return.
 	 */
@@ -3107,12 +3107,12 @@ void exit_mmap(struct mm_struct *mm)
 		/*
 		 * Manually reap the mm to free as much memory as possible.
 		 * Then, as the oom reaper does, set MMF_OOM_SKIP to disregard
-		 * this mm from further consideration.  Taking mm->mmap_sem for
+		 * this mm from further consideration.  Taking mm->mmap_lock for
 		 * write after setting MMF_OOM_SKIP will guarantee that the oom
-		 * reaper will not run on this mm again after mmap_sem is
+		 * reaper will not run on this mm again after mmap_lock is
 		 * dropped.
 		 *
-		 * Nothing can be holding mm->mmap_sem here and the above call
+		 * Nothing can be holding mm->mmap_lock here and the above call
 		 * to mmu_notifier_release(mm) ensures mmu notifier callbacks in
 		 * __oom_reap_task_mm() will not block.
 		 *
@@ -3437,7 +3437,7 @@ bool vma_is_special_mapping(const struct
 }
 
 /*
- * Called with mm->mmap_sem held for writing.
+ * Called with mm->mmap_lock held for writing.
  * Insert a new vma covering the given region, with the given flags.
  * Its pages are supplied by the given array of struct page *.
  * The array can be shorter than len >> PAGE_SHIFT if it's null-terminated.
@@ -3513,11 +3513,11 @@ static void vm_lock_mapping(struct mm_st
  * operations that could ever happen on a certain mm. This includes
  * vmtruncate, try_to_unmap, and all page faults.
  *
- * The caller must take the mmap_sem in write mode before calling
+ * The caller must take the mmap_lock in write mode before calling
  * mm_take_all_locks(). The caller isn't allowed to release the
- * mmap_sem until mm_drop_all_locks() returns.
+ * mmap_lock until mm_drop_all_locks() returns.
  *
- * mmap_sem in write mode is required in order to block all operations
+ * mmap_lock in write mode is required in order to block all operations
  * that could modify pagetables and free pages without need of
  * altering the vma layout. It's also needed in write mode to avoid new
  * anon_vmas to be associated with existing vmas.
@@ -3622,7 +3622,7 @@ static void vm_unlock_mapping(struct add
 }
 
 /*
- * The mmap_sem cannot be released by the caller until
+ * The mmap_lock cannot be released by the caller until
  * mm_drop_all_locks() returns.
  */
 void mm_drop_all_locks(struct mm_struct *mm)
--- a/mm/mmu_gather.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/mmu_gather.c
@@ -301,7 +301,7 @@ void tlb_finish_mmu(struct mmu_gather *t
 {
 	/*
 	 * If there are parallel threads are doing PTE changes on same range
-	 * under non-exclusive lock (e.g., mmap_sem read-side) but defer TLB
+	 * under non-exclusive lock (e.g., mmap_lock read-side) but defer TLB
 	 * flush by batching, one thread may end up seeing inconsistent PTEs
 	 * and result in having stale TLB entries.  So flush TLB forcefully
 	 * if we detect parallel PTE batching threads.
--- a/mm/mmu_notifier.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/mmu_notifier.c
@@ -599,7 +599,7 @@ void __mmu_notifier_invalidate_range(str
 }
 
 /*
- * Same as mmu_notifier_register but here the caller must hold the mmap_sem in
+ * Same as mmu_notifier_register but here the caller must hold the mmap_lock in
  * write mode. A NULL mn signals the notifier is being registered for itree
  * mode.
  */
@@ -623,7 +623,7 @@ int __mmu_notifier_register(struct mmu_n
 		/*
 		 * kmalloc cannot be called under mm_take_all_locks(), but we
 		 * know that mm->notifier_subscriptions can't change while we
-		 * hold the write side of the mmap_sem.
+		 * hold the write side of the mmap_lock.
 		 */
 		subscriptions = kzalloc(
 			sizeof(struct mmu_notifier_subscriptions), GFP_KERNEL);
@@ -655,7 +655,7 @@ int __mmu_notifier_register(struct mmu_n
 	 * readers.  acquire can only be used while holding the mmgrab or
 	 * mmget, and is safe because once created the
 	 * mmu_notifier_subscriptions is not freed until the mm is destroyed.
-	 * As above, users holding the mmap_sem or one of the
+	 * As above, users holding the mmap_lock or one of the
 	 * mm_take_all_locks() do not need to use acquire semantics.
 	 */
 	if (subscriptions)
@@ -689,7 +689,7 @@ EXPORT_SYMBOL_GPL(__mmu_notifier_registe
  * @mn: The notifier to attach
  * @mm: The mm to attach the notifier to
  *
- * Must not hold mmap_sem nor any other VM related lock when calling
+ * Must not hold mmap_lock nor any other VM related lock when calling
  * this registration function. Must also ensure mm_users can't go down
  * to zero while this runs to avoid races with mmu_notifier_release,
  * so mm has to be current->mm or the mm should be pinned safely such
@@ -750,7 +750,7 @@ find_get_mmu_notifier(struct mm_struct *
  * are the same.
  *
  * Each call to mmu_notifier_get() must be paired with a call to
- * mmu_notifier_put(). The caller must hold the write side of mm->mmap_sem.
+ * mmu_notifier_put(). The caller must hold the write side of mm->mmap_lock.
  *
  * While the caller has a mmu_notifier get the mm pointer will remain valid,
  * and can be converted to an active mm pointer via mmget_not_zero().
--- a/mm/mprotect.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/mprotect.c
@@ -49,7 +49,7 @@ static unsigned long change_pte_range(st
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 
 	/*
-	 * Can be called with only the mmap_sem for reading by
+	 * Can be called with only the mmap_lock for reading by
 	 * prot_numa so we must check the pmd isn't constantly
 	 * changing from under us from pmd_none to pmd_trans_huge
 	 * and/or the other way around.
@@ -59,7 +59,7 @@ static unsigned long change_pte_range(st
 
 	/*
 	 * The pmd points to a regular pte so the pmd can't change
-	 * from under us even if the mmap_sem is only hold for
+	 * from under us even if the mmap_lock is only hold for
 	 * reading.
 	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
@@ -228,7 +228,7 @@ static inline unsigned long change_pmd_r
 		next = pmd_addr_end(addr, end);
 
 		/*
-		 * Automatic NUMA balancing walks the tables with mmap_sem
+		 * Automatic NUMA balancing walks the tables with mmap_lock
 		 * held for read. It's possible a parallel update to occur
 		 * between pmd_trans_huge() and a pmd_none_or_clear_bad()
 		 * check leading to a false positive and clearing.
@@ -477,7 +477,7 @@ mprotect_fixup(struct vm_area_struct *vm
 
 success:
 	/*
-	 * vm_flags and vm_page_prot are protected by the mmap_sem
+	 * vm_flags and vm_page_prot are protected by the mmap_lock
 	 * held in write mode.
 	 */
 	vma->vm_flags = newflags;
--- a/mm/mremap.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/mremap.c
@@ -146,7 +146,7 @@ static void move_ptes(struct vm_area_str
 
 	/*
 	 * We don't have to worry about the ordering of src and dst
-	 * pte locks because exclusive mmap_sem prevents deadlock.
+	 * pte locks because exclusive mmap_lock prevents deadlock.
 	 */
 	old_pte = pte_offset_map_lock(mm, old_pmd, old_addr, &old_ptl);
 	new_pte = pte_offset_map(new_pmd, new_addr);
@@ -213,7 +213,7 @@ static bool move_normal_pmd(struct vm_ar
 
 	/*
 	 * We don't have to worry about the ordering of src and dst
-	 * ptlocks because exclusive mmap_sem prevents deadlock.
+	 * ptlocks because exclusive mmap_lock prevents deadlock.
 	 */
 	old_ptl = pmd_lock(vma->vm_mm, old_pmd);
 	new_ptl = pmd_lockptr(mm, new_pmd);
@@ -710,7 +710,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	 * Always allow a shrinking remap: that just unmaps
 	 * the unnecessary pages..
 	 * __do_munmap does all the needed commit accounting, and
-	 * downgrades mmap_sem to read if so directed.
+	 * downgrades mmap_lock to read if so directed.
 	 */
 	if (old_len >= new_len) {
 		int retval;
@@ -720,7 +720,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		if (retval < 0 && old_len != new_len) {
 			ret = retval;
 			goto out;
-		/* Returning 1 indicates mmap_sem is downgraded to read. */
+		/* Returning 1 indicates mmap_lock is downgraded to read. */
 		} else if (retval == 1)
 			downgraded = true;
 		ret = addr;
--- a/mm/nommu.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/nommu.c
@@ -582,7 +582,7 @@ static void put_nommu_region(struct vm_r
  * add a VMA into a process's mm_struct in the appropriate place in the list
  * and tree and add to the address space's page tree also if not an anonymous
  * page
- * - should be called with mm->mmap_sem held writelocked
+ * - should be called with mm->mmap_lock held writelocked
  */
 static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
 {
@@ -696,7 +696,7 @@ static void delete_vma(struct mm_struct
 
 /*
  * look up the first VMA in which addr resides, NULL if none
- * - should be called with mm->mmap_sem at least held readlocked
+ * - should be called with mm->mmap_lock at least held readlocked
  */
 struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
@@ -742,7 +742,7 @@ int expand_stack(struct vm_area_struct *
 
 /*
  * look up the first VMA exactly that exactly matches addr
- * - should be called with mm->mmap_sem at least held readlocked
+ * - should be called with mm->mmap_lock at least held readlocked
  */
 static struct vm_area_struct *find_vma_exact(struct mm_struct *mm,
 					     unsigned long addr,
--- a/mm/oom_kill.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/oom_kill.c
@@ -898,7 +898,7 @@ static void __oom_kill_process(struct ta
 	/*
 	 * Kill all user processes sharing victim->mm in other thread groups, if
 	 * any.  They don't get access to memory reserves, though, to avoid
-	 * depletion of all memory.  This prevents mm->mmap_sem livelock when an
+	 * depletion of all memory.  This prevents mm->mmap_lock livelock when an
 	 * oom killed thread cannot exit because it requires the semaphore and
 	 * its contended by another thread trying to allocate memory itself.
 	 * That thread will now get access to memory reserves since it has a
--- a/mm/pagewalk.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/pagewalk.c
@@ -373,7 +373,7 @@ static int __walk_page_range(unsigned lo
  * caller-specific data to callbacks, @private should be helpful.
  *
  * Locking:
- *   Callers of walk_page_range() and walk_page_vma() should hold @mm->mmap_sem,
+ *   Callers of walk_page_range() and walk_page_vma() should hold @mm->mmap_lock,
  *   because these function traverse vma list and/or access to vma's data.
  */
 int walk_page_range(struct mm_struct *mm, unsigned long start,
@@ -498,11 +498,11 @@ int walk_page_vma(struct vm_area_struct
  * Also see walk_page_range() for additional information.
  *
  * Locking:
- *   This function can't require that the struct mm_struct::mmap_sem is held,
+ *   This function can't require that the struct mm_struct::mmap_lock is held,
  *   since @mapping may be mapped by multiple processes. Instead
  *   @mapping->i_mmap_rwsem must be held. This might have implications in the
  *   callbacks, and it's up tho the caller to ensure that the
- *   struct mm_struct::mmap_sem is not needed.
+ *   struct mm_struct::mmap_lock is not needed.
  *
  *   Also this means that a caller can't rely on the struct
  *   vm_area_struct::vm_flags to be constant across a call,
--- a/mm/rmap.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/rmap.c
@@ -21,7 +21,7 @@
  * Lock ordering in mm:
  *
  * inode->i_mutex	(while writing or truncating, not reading or faulting)
- *   mm->mmap_sem
+ *   mm->mmap_lock
  *     page->flags PG_locked (lock_page)   * (see huegtlbfs below)
  *       hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share)
  *         mapping->i_mmap_rwsem
@@ -177,7 +177,7 @@ static void anon_vma_chain_link(struct v
  * to do any locking for the common case of already having
  * an anon_vma.
  *
- * This must be called with the mmap_sem held for reading.
+ * This must be called with the mmap_lock held for reading.
  */
 int __anon_vma_prepare(struct vm_area_struct *vma)
 {
@@ -1444,7 +1444,7 @@ static bool try_to_unmap_one(struct page
 				if (!PageTransCompound(page)) {
 					/*
 					 * Holding pte lock, we do *not* need
-					 * mmap_sem here
+					 * mmap_lock here
 					 */
 					mlock_vma_page(page);
 				}
@@ -1817,7 +1817,7 @@ static struct anon_vma *rmap_walk_anon_l
 	/*
 	 * Note: remove_migration_ptes() cannot use page_lock_anon_vma_read()
 	 * because that depends on page_mapped(); but not all its usages
-	 * are holding mmap_sem. Users without mmap_sem are required to
+	 * are holding mmap_lock. Users without mmap_lock are required to
 	 * take a reference count to prevent the anon_vma disappearing
 	 */
 	anon_vma = page_anon_vma(page);
@@ -1837,7 +1837,7 @@ static struct anon_vma *rmap_walk_anon_l
  * Find all the mappings of a page using the mapping pointer and the vma chains
  * contained in the anon_vma struct it points to.
  *
- * When called from try_to_munlock(), the mmap_sem of the mm containing the vma
+ * When called from try_to_munlock(), the mmap_lock of the mm containing the vma
  * where the page was found will be held for write.  So, we won't recheck
  * vm_flags for that VMA.  That should be OK, because that vma shouldn't be
  * LOCKED.
@@ -1889,7 +1889,7 @@ static void rmap_walk_anon(struct page *
  * Find all the mappings of a page using the mapping pointer and the vma chains
  * contained in the address_space struct it points to.
  *
- * When called from try_to_munlock(), the mmap_sem of the mm containing the vma
+ * When called from try_to_munlock(), the mmap_lock of the mm containing the vma
  * where the page was found will be held for write.  So, we won't recheck
  * vm_flags for that VMA.  That should be OK, because that vma shouldn't be
  * LOCKED.
--- a/mm/shmem.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/shmem.c
@@ -2319,7 +2319,7 @@ static int shmem_mfill_atomic_pte(struct
 					     PAGE_SIZE);
 			kunmap_atomic(page_kaddr);
 
-			/* fallback to copy_from_user outside mmap_sem */
+			/* fallback to copy_from_user outside mmap_lock */
 			if (unlikely(ret)) {
 				*pagep = page;
 				shmem_inode_unacct_blocks(inode, 1);
@@ -4136,7 +4136,7 @@ int shmem_zero_setup(struct vm_area_stru
 	loff_t size = vma->vm_end - vma->vm_start;
 
 	/*
-	 * Cloning a new file under mmap_sem leads to a lock ordering conflict
+	 * Cloning a new file under mmap_lock leads to a lock ordering conflict
 	 * between XFS directory reading and selinux: since this file is only
 	 * accessible to the user through its mapping, use S_PRIVATE flag to
 	 * bypass file security, in the same way as shmem_kernel_file_setup().
--- a/mm/swap_state.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/swap_state.c
@@ -552,7 +552,7 @@ static unsigned long swapin_nr_pages(uns
  * This has been extended to use the NUMA policies from the mm triggering
  * the readahead.
  *
- * Caller must hold read mmap_sem if vmf->vma is not NULL.
+ * Caller must hold read mmap_lock if vmf->vma is not NULL.
  */
 struct page *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 				struct vm_fault *vmf)
@@ -734,7 +734,7 @@ static void swap_ra_info(struct vm_fault
  * Primitive swap readahead code. We simply read in a few pages whoes
  * virtual addresses are around the fault address in the same vma.
  *
- * Caller must hold read mmap_sem if vmf->vma is not NULL.
+ * Caller must hold read mmap_lock if vmf->vma is not NULL.
  *
  */
 static struct page *swap_vma_readahead(swp_entry_t fentry, gfp_t gfp_mask,
--- a/mm/userfaultfd.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/userfaultfd.c
@@ -76,7 +76,7 @@ static int mcopy_atomic_pte(struct mm_st
 				     PAGE_SIZE);
 		kunmap_atomic(page_kaddr);
 
-		/* fallback to copy_from_user outside mmap_sem */
+		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
 			ret = -ENOENT;
 			*pagep = page;
@@ -200,7 +200,7 @@ static pmd_t *mm_alloc_pmd(struct mm_str
 #ifdef CONFIG_HUGETLB_PAGE
 /*
  * __mcopy_atomic processing for HUGETLB vmas.  Note that this routine is
- * called with mmap_sem held, it will release mmap_sem before returning.
+ * called with mmap_lock held, it will release mmap_lock before returning.
  */
 static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 					      struct vm_area_struct *dst_vma,
@@ -247,7 +247,7 @@ static __always_inline ssize_t __mcopy_a
 
 retry:
 	/*
-	 * On routine entry dst_vma is set.  If we had to drop mmap_sem and
+	 * On routine entry dst_vma is set.  If we had to drop mmap_lock and
 	 * retry, dst_vma will be set to NULL and we must lookup again.
 	 */
 	if (!dst_vma) {
@@ -357,7 +357,7 @@ out:
 		 * private and shared mappings.  See the routine
 		 * restore_reserve_on_error for details.  Unfortunately, we
 		 * can not call restore_reserve_on_error now as it would
-		 * require holding mmap_sem.
+		 * require holding mmap_lock.
 		 *
 		 * If a reservation for the page existed in the reservation
 		 * map of a private mapping, the map was modified to indicate
--- a/mm/util.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/mm/util.c
@@ -425,7 +425,7 @@ void arch_pick_mmap_layout(struct mm_str
  * @bypass_rlim: %true if checking RLIMIT_MEMLOCK should be skipped
  *
  * Assumes @task and @mm are valid (i.e. at least one reference on each), and
- * that mmap_sem is held as writer.
+ * that mmap_lock is held as writer.
  *
  * Return:
  * * 0       on success
--- a/security/keys/keyctl.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/security/keys/keyctl.c
@@ -875,7 +875,7 @@ can_read_key:
 	 *
 	 * Allocating a temporary buffer to hold the keys before
 	 * transferring them to user buffer to avoid potential
-	 * deadlock involving page fault and mmap_sem.
+	 * deadlock involving page fault and mmap_lock.
 	 *
 	 * key_data_len = (buflen <= PAGE_SIZE)
 	 *		? buflen : actual length of key data
--- a/sound/core/oss/pcm_oss.c~mmap-locking-api-convert-mmap_sem-comments
+++ a/sound/core/oss/pcm_oss.c
@@ -2876,7 +2876,7 @@ static int snd_pcm_oss_mmap(struct file
 	
 	if (runtime->oss.params) {
 		/* use mutex_trylock() for params_lock for avoiding a deadlock
-		 * between mmap_sem and params_lock taken by
+		 * between mmap_lock and params_lock taken by
 		 * copy_from/to_user() in snd_pcm_oss_write/read()
 		 */
 		err = snd_pcm_oss_change_params(substream, true);
_

Patches currently in -mm which might be from walken@google.com are
