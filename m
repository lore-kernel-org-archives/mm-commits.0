From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:23:58 -0700
Message-ID: <20200521032358.lwgGsVnIs%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727825AbgEUDYH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:24:07 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap locking API: use coccinelle to convert mmap_sem rwsem call sites
has been added to the -mm tree.  Its filename is
     mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mmap locking API: use coccinelle to convert mmap_sem rwsem call sites

This change converts the existing mmap_sem rwsem calls to use the new mmap
locking API instead.

The change is generated using coccinelle with the following rule:

// spatch --sp-file mmap_lock_api.cocci --in-place --include-headers --dir .

@@
expression mm;
@@
(
-init_rwsem
+mmap_init_lock
|
-down_write
+mmap_write_lock
|
-down_write_killable
+mmap_write_lock_killable
|
-down_write_trylock
+mmap_write_trylock
|
-up_write
+mmap_write_unlock
|
-downgrade_write
+mmap_write_downgrade
|
-down_read
+mmap_read_lock
|
-down_read_killable
+mmap_read_lock_killable
|
-down_read_trylock
+mmap_read_trylock
|
-up_read
+mmap_read_unlock
)
-(&mm->mmap_sem)
+(mm)

Link: http://lkml.kernel.org/r/20200520052908.204642-5-walken@google.com
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/traps.c                        |    4 -
 arch/alpha/mm/fault.c                            |   10 +-
 arch/arc/kernel/process.c                        |    4 -
 arch/arc/kernel/troubleshoot.c                   |    4 -
 arch/arc/mm/fault.c                              |    4 -
 arch/arm/kernel/process.c                        |    4 -
 arch/arm/kernel/swp_emulate.c                    |    4 -
 arch/arm/lib/uaccess_with_memcpy.c               |   16 ++--
 arch/arm/mm/fault.c                              |    6 -
 arch/arm64/kernel/traps.c                        |    4 -
 arch/arm64/kernel/vdso.c                         |    8 +-
 arch/arm64/mm/fault.c                            |    8 +-
 arch/csky/kernel/vdso.c                          |    4 -
 arch/csky/mm/fault.c                             |    8 +-
 arch/hexagon/kernel/vdso.c                       |    4 -
 arch/hexagon/mm/vm_fault.c                       |    8 +-
 arch/ia64/kernel/perfmon.c                       |    8 +-
 arch/ia64/mm/fault.c                             |    8 +-
 arch/ia64/mm/init.c                              |   12 +--
 arch/m68k/kernel/sys_m68k.c                      |   14 ++--
 arch/m68k/mm/fault.c                             |    8 +-
 arch/microblaze/mm/fault.c                       |   12 +--
 arch/mips/kernel/traps.c                         |    4 -
 arch/mips/kernel/vdso.c                          |    4 -
 arch/nds32/kernel/vdso.c                         |    6 -
 arch/nds32/mm/fault.c                            |   12 +--
 arch/nios2/mm/fault.c                            |   12 +--
 arch/nios2/mm/init.c                             |    4 -
 arch/openrisc/mm/fault.c                         |   10 +-
 arch/parisc/kernel/traps.c                       |    6 -
 arch/parisc/mm/fault.c                           |    8 +-
 arch/powerpc/kernel/vdso.c                       |    6 -
 arch/powerpc/kvm/book3s_hv.c                     |    6 -
 arch/powerpc/kvm/book3s_hv_uvmem.c               |   12 +--
 arch/powerpc/kvm/e500_mmu_host.c                 |    4 -
 arch/powerpc/mm/book3s64/iommu_api.c             |    4 -
 arch/powerpc/mm/book3s64/subpage_prot.c          |   12 +--
 arch/powerpc/mm/copro_fault.c                    |    4 -
 arch/powerpc/mm/fault.c                          |   12 +--
 arch/powerpc/oprofile/cell/spu_task_sync.c       |    6 -
 arch/powerpc/platforms/cell/spufs/file.c         |    4 -
 arch/riscv/kernel/vdso.c                         |    4 -
 arch/riscv/mm/fault.c                            |   10 +-
 arch/s390/kernel/uv.c                            |    4 -
 arch/s390/kernel/vdso.c                          |    4 -
 arch/s390/kvm/gaccess.c                          |    4 -
 arch/s390/kvm/interrupt.c                        |    4 -
 arch/s390/kvm/kvm-s390.c                         |   28 ++++----
 arch/s390/kvm/priv.c                             |   32 ++++-----
 arch/s390/mm/fault.c                             |   14 ++--
 arch/s390/mm/gmap.c                              |   44 ++++++-------
 arch/s390/pci/pci_mmio.c                         |    4 -
 arch/sh/kernel/sys_sh.c                          |    6 -
 arch/sh/kernel/vsyscall/vsyscall.c               |    4 -
 arch/sh/mm/fault.c                               |   10 +-
 arch/sparc/mm/fault_32.c                         |   18 ++---
 arch/sparc/mm/fault_64.c                         |   12 +--
 arch/sparc/vdso/vma.c                            |    4 -
 arch/um/include/asm/mmu_context.h                |    2 
 arch/um/kernel/tlb.c                             |    2 
 arch/um/kernel/trap.c                            |    6 -
 arch/unicore32/mm/fault.c                        |    6 -
 arch/x86/entry/vdso/vma.c                        |   14 ++--
 arch/x86/kernel/vm86_32.c                        |    4 -
 arch/x86/mm/fault.c                              |    8 +-
 arch/x86/um/vdso/vma.c                           |    4 -
 arch/xtensa/mm/fault.c                           |   10 +-
 drivers/android/binder_alloc.c                   |   10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    4 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c          |   10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c          |    4 -
 drivers/gpu/drm/i915/gem/i915_gem_mman.c         |    4 -
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c      |    8 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c            |   22 +++---
 drivers/gpu/drm/radeon/radeon_cs.c               |    4 -
 drivers/gpu/drm/radeon/radeon_gem.c              |    6 -
 drivers/gpu/drm/ttm/ttm_bo_vm.c                  |    4 -
 drivers/infiniband/core/umem_odp.c               |    4 -
 drivers/infiniband/core/uverbs_main.c            |    4 -
 drivers/infiniband/hw/mlx4/mr.c                  |    4 -
 drivers/infiniband/hw/qib/qib_user_pages.c       |    6 -
 drivers/infiniband/hw/usnic/usnic_uiom.c         |    4 -
 drivers/infiniband/sw/siw/siw_mem.c              |    4 -
 drivers/iommu/amd_iommu_v2.c                     |    4 -
 drivers/iommu/intel-svm.c                        |    4 -
 drivers/media/v4l2-core/videobuf-core.c          |    4 -
 drivers/media/v4l2-core/videobuf-dma-contig.c    |    4 -
 drivers/media/v4l2-core/videobuf-dma-sg.c        |    4 -
 drivers/misc/cxl/cxllib.c                        |    4 -
 drivers/misc/cxl/fault.c                         |    4 -
 drivers/misc/sgi-gru/grufault.c                  |   16 ++--
 drivers/misc/sgi-gru/grufile.c                   |    4 -
 drivers/oprofile/buffer_sync.c                   |   10 +-
 drivers/staging/kpc2000/kpc_dma/fileops.c        |    4 -
 drivers/tee/optee/call.c                         |    4 -
 drivers/vfio/vfio_iommu_type1.c                  |    8 +-
 drivers/vhost/vdpa.c                             |    4 -
 drivers/xen/gntdev.c                             |    4 -
 drivers/xen/privcmd.c                            |   14 ++--
 fs/aio.c                                         |    4 -
 fs/coredump.c                                    |    4 -
 fs/exec.c                                        |   16 ++--
 fs/io_uring.c                                    |    4 -
 fs/proc/base.c                                   |   12 +--
 fs/proc/task_mmu.c                               |   28 ++++----
 fs/proc/task_nommu.c                             |   18 ++---
 fs/userfaultfd.c                                 |   20 ++---
 ipc/shm.c                                        |    8 +-
 kernel/acct.c                                    |    4 -
 kernel/bpf/stackmap.c                            |    4 -
 kernel/events/core.c                             |    4 -
 kernel/events/uprobes.c                          |   16 ++--
 kernel/exit.c                                    |    8 +-
 kernel/fork.c                                    |   12 +--
 kernel/futex.c                                   |    4 -
 kernel/sched/fair.c                              |    4 -
 kernel/sys.c                                     |   18 ++---
 kernel/trace/trace_output.c                      |    4 -
 lib/test_lockup.c                                |    8 +-
 mm/filemap.c                                     |    6 -
 mm/frame_vector.c                                |    4 -
 mm/gup.c                                         |   18 ++---
 mm/internal.h                                    |    2 
 mm/khugepaged.c                                  |   36 +++++-----
 mm/ksm.c                                         |   34 +++++-----
 mm/madvise.c                                     |   20 ++---
 mm/memcontrol.c                                  |    8 +-
 mm/memory.c                                      |   12 +--
 mm/mempolicy.c                                   |   22 +++---
 mm/migrate.c                                     |    8 +-
 mm/mincore.c                                     |    4 -
 mm/mlock.c                                       |   16 ++--
 mm/mmap.c                                        |   32 ++++-----
 mm/mmu_notifier.c                                |    4 -
 mm/mprotect.c                                    |   12 +--
 mm/mremap.c                                      |    6 -
 mm/msync.c                                       |    8 +-
 mm/nommu.c                                       |   16 ++--
 mm/oom_kill.c                                    |    4 -
 mm/process_vm_access.c                           |    4 -
 mm/ptdump.c                                      |    4 -
 mm/swapfile.c                                    |    4 -
 mm/userfaultfd.c                                 |   18 ++---
 mm/util.c                                        |    8 +-
 net/ipv4/tcp.c                                   |    6 -
 net/xdp/xdp_umem.c                               |    4 -
 virt/kvm/async_pf.c                              |    4 -
 virt/kvm/kvm_main.c                              |    8 +-
 148 files changed, 645 insertions(+), 645 deletions(-)

--- a/arch/alpha/kernel/traps.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/alpha/kernel/traps.c
@@ -957,12 +957,12 @@ give_sigsegv:
 		si_code = SEGV_ACCERR;
 	else {
 		struct mm_struct *mm = current->mm;
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		if (find_vma(mm, (unsigned long)va))
 			si_code = SEGV_ACCERR;
 		else
 			si_code = SEGV_MAPERR;
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 	}
 	send_sig_fault(SIGSEGV, si_code, va, 0, current);
 	return;
--- a/arch/alpha/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/alpha/mm/fault.c
@@ -117,7 +117,7 @@ do_page_fault(unsigned long address, uns
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
@@ -180,14 +180,14 @@ retry:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	return;
 
 	/* Something tried to access memory that isn't in our memory map.
 	   Fix it, but check if it's kernel or user first.  */
  bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	if (user_mode(regs))
 		goto do_sigsegv;
@@ -211,14 +211,14 @@ retry:
 	/* We ran out of memory, or some other thing happened to us that
 	   made us unable to handle the page fault gracefully.  */
  out_of_memory:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
 	return;
 
  do_sigbus:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	/* Send a sigbus, regardless of whether we were in kernel
 	   or user mode.  */
 	force_sig_fault(SIGBUS, BUS_ADRERR, (void __user *) address, 0);
--- a/arch/arc/kernel/process.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/arc/kernel/process.c
@@ -90,10 +90,10 @@ fault:
 	if (unlikely(ret != -EFAULT))
 		 goto fail;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	ret = fixup_user_fault(current, current->mm, (unsigned long) uaddr,
 			       FAULT_FLAG_WRITE, NULL);
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	if (likely(!ret))
 		 goto again;
--- a/arch/arc/kernel/troubleshoot.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/arc/kernel/troubleshoot.c
@@ -89,7 +89,7 @@ static void show_faulting_vma(unsigned l
 	/* can't use print_vma_addr() yet as it doesn't check for
 	 * non-inclusive vma
 	 */
-	down_read(&active_mm->mmap_sem);
+	mmap_read_lock(active_mm);
 	vma = find_vma(active_mm, address);
 
 	/* check against the find_vma( ) behaviour which returns the next VMA
@@ -111,7 +111,7 @@ static void show_faulting_vma(unsigned l
 	} else
 		pr_info("    @No matching VMA found\n");
 
-	up_read(&active_mm->mmap_sem);
+	mmap_read_unlock(active_mm);
 }
 
 static void show_ecr_verbose(struct pt_regs *regs)
--- a/arch/arc/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/arc/mm/fault.c
@@ -107,7 +107,7 @@ void do_page_fault(unsigned long address
 		flags |= FAULT_FLAG_WRITE;
 
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	vma = find_vma(mm, address);
 	if (!vma)
@@ -150,7 +150,7 @@ retry:
 	}
 
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/*
 	 * Major/minor page fault accounting
--- a/arch/arm64/kernel/traps.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/arm64/kernel/traps.c
@@ -448,12 +448,12 @@ void arm64_notify_segfault(unsigned long
 {
 	int code;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	if (find_vma(current->mm, addr) == NULL)
 		code = SEGV_MAPERR;
 	else
 		code = SEGV_ACCERR;
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	force_signal_inject(SIGSEGV, code, addr);
 }
--- a/arch/arm64/kernel/vdso.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/arm64/kernel/vdso.c
@@ -340,7 +340,7 @@ int aarch32_setup_additional_pages(struc
 	struct mm_struct *mm = current->mm;
 	int ret;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	ret = aarch32_kuser_helpers_setup(mm);
@@ -357,7 +357,7 @@ int aarch32_setup_additional_pages(struc
 #endif /* CONFIG_COMPAT_VDSO */
 
 out:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 #endif /* CONFIG_COMPAT */
@@ -398,7 +398,7 @@ int arch_setup_additional_pages(struct l
 	struct mm_struct *mm = current->mm;
 	int ret;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	ret = __setup_additional_pages(VDSO_ABI_AA64,
@@ -406,7 +406,7 @@ int arch_setup_additional_pages(struct l
 				       bprm,
 				       uses_interp);
 
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 
 	return ret;
 }
--- a/arch/arm64/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/arm64/mm/fault.c
@@ -497,11 +497,11 @@ static int __kprobes do_page_fault(unsig
 	 * validly references user space from well defined areas of the code,
 	 * we can bug out early if this is from code which shouldn't.
 	 */
-	if (!down_read_trylock(&mm->mmap_sem)) {
+	if (!mmap_read_trylock(mm)) {
 		if (!user_mode(regs) && !search_exception_tables(regs->pc))
 			goto no_context;
 retry:
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	} else {
 		/*
 		 * The above down_read_trylock() might have succeeded in which
@@ -510,7 +510,7 @@ retry:
 		might_sleep();
 #ifdef CONFIG_DEBUG_VM
 		if (!user_mode(regs) && !search_exception_tables(regs->pc)) {
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 			goto no_context;
 		}
 #endif
@@ -532,7 +532,7 @@ retry:
 			goto retry;
 		}
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/*
 	 * Handle the "normal" (no error) case first.
--- a/arch/arm/kernel/process.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/arm/kernel/process.c
@@ -431,7 +431,7 @@ int arch_setup_additional_pages(struct l
 	npages = 1; /* for sigpage */
 	npages += vdso_total_pages;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 	hint = sigpage_addr(mm, npages);
 	addr = get_unmapped_area(NULL, hint, npages << PAGE_SHIFT, 0, 0);
@@ -458,7 +458,7 @@ int arch_setup_additional_pages(struct l
 	arm_install_vdso(mm, addr + PAGE_SIZE);
 
  up_fail:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 #endif
--- a/arch/arm/kernel/swp_emulate.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/arm/kernel/swp_emulate.c
@@ -97,12 +97,12 @@ static void set_segfault(struct pt_regs
 {
 	int si_code;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	if (find_vma(current->mm, addr) == NULL)
 		si_code = SEGV_MAPERR;
 	else
 		si_code = SEGV_ACCERR;
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	pr_debug("SWP{B} emulation: access caused memory abort!\n");
 	arm_notify_die("Illegal memory access", regs,
--- a/arch/arm/lib/uaccess_with_memcpy.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/arm/lib/uaccess_with_memcpy.c
@@ -101,7 +101,7 @@ __copy_to_user_memcpy(void __user *to, c
 	atomic = faulthandler_disabled();
 
 	if (!atomic)
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 	while (n) {
 		pte_t *pte;
 		spinlock_t *ptl;
@@ -109,11 +109,11 @@ __copy_to_user_memcpy(void __user *to, c
 
 		while (!pin_page_for_write(to, &pte, &ptl)) {
 			if (!atomic)
-				up_read(&current->mm->mmap_sem);
+				mmap_read_unlock(current->mm);
 			if (__put_user(0, (char __user *)to))
 				goto out;
 			if (!atomic)
-				down_read(&current->mm->mmap_sem);
+				mmap_read_lock(current->mm);
 		}
 
 		tocopy = (~(unsigned long)to & ~PAGE_MASK) + 1;
@@ -133,7 +133,7 @@ __copy_to_user_memcpy(void __user *to, c
 			spin_unlock(ptl);
 	}
 	if (!atomic)
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 
 out:
 	return n;
@@ -170,17 +170,17 @@ __clear_user_memset(void __user *addr, u
 		return 0;
 	}
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	while (n) {
 		pte_t *pte;
 		spinlock_t *ptl;
 		int tocopy;
 
 		while (!pin_page_for_write(addr, &pte, &ptl)) {
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 			if (__put_user(0, (char __user *)addr))
 				goto out;
-			down_read(&current->mm->mmap_sem);
+			mmap_read_lock(current->mm);
 		}
 
 		tocopy = (~(unsigned long)addr & ~PAGE_MASK) + 1;
@@ -198,7 +198,7 @@ __clear_user_memset(void __user *addr, u
 		else
 			spin_unlock(ptl);
 	}
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 out:
 	return n;
--- a/arch/arm/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/arm/mm/fault.c
@@ -271,11 +271,11 @@ do_page_fault(unsigned long addr, unsign
 	 * validly references user space from well defined areas of the code,
 	 * we can bug out early if this is from code which shouldn't.
 	 */
-	if (!down_read_trylock(&mm->mmap_sem)) {
+	if (!mmap_read_trylock(mm)) {
 		if (!user_mode(regs) && !search_exception_tables(regs->ARM_pc))
 			goto no_context;
 retry:
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	} else {
 		/*
 		 * The above down_read_trylock() might have succeeded in
@@ -325,7 +325,7 @@ retry:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/*
 	 * Handle the "normal" case first - VM_FAULT_MAJOR
--- a/arch/csky/kernel/vdso.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/csky/kernel/vdso.c
@@ -50,7 +50,7 @@ int arch_setup_additional_pages(struct l
 	unsigned long addr;
 	struct mm_struct *mm = current->mm;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 
 	addr = get_unmapped_area(NULL, STACK_TOP, PAGE_SIZE, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
@@ -70,7 +70,7 @@ int arch_setup_additional_pages(struct l
 	mm->context.vdso = (void *)addr;
 
 up_fail:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 
--- a/arch/csky/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/csky/mm/fault.c
@@ -120,7 +120,7 @@ asmlinkage void do_page_fault(struct pt_
 	if (in_atomic() || !mm)
 		goto bad_area_nosemaphore;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
@@ -170,7 +170,7 @@ good_area:
 			      address);
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 
 	/*
@@ -178,7 +178,7 @@ good_area:
 	 * Fix it, but check if it's kernel or user first..
 	 */
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
@@ -217,7 +217,7 @@ out_of_memory:
 do_sigbus:
 	tsk->thread.trap_no = (regs->sr >> 16) & 0xff;
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/* Kernel mode? Handle exceptions or die */
 	if (!user_mode(regs))
--- a/arch/hexagon/kernel/vdso.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/hexagon/kernel/vdso.c
@@ -52,7 +52,7 @@ int arch_setup_additional_pages(struct l
 	unsigned long vdso_base;
 	struct mm_struct *mm = current->mm;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	/* Try to get it loaded right near ld.so/glibc. */
@@ -76,7 +76,7 @@ int arch_setup_additional_pages(struct l
 	mm->context.vdso = (void *)vdso_base;
 
 up_fail:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 
--- a/arch/hexagon/mm/vm_fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/hexagon/mm/vm_fault.c
@@ -54,7 +54,7 @@ void do_page_fault(unsigned long address
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
@@ -106,11 +106,11 @@ good_area:
 			}
 		}
 
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		return;
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/* Handle copyin/out exception cases */
 	if (!user_mode(regs))
@@ -137,7 +137,7 @@ good_area:
 	return;
 
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	if (user_mode(regs)) {
 		force_sig_fault(SIGSEGV, si_code, (void __user *)address);
--- a/arch/ia64/kernel/perfmon.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/ia64/kernel/perfmon.c
@@ -2260,13 +2260,13 @@ pfm_smpl_buffer_alloc(struct task_struct
 	 * now we atomically find some area in the address space and
 	 * remap the buffer in it.
 	 */
-	down_write(&task->mm->mmap_sem);
+	mmap_write_lock(task->mm);
 
 	/* find some free area in address space, must have mmap sem held */
 	vma->vm_start = get_unmapped_area(NULL, 0, size, 0, MAP_PRIVATE|MAP_ANONYMOUS);
 	if (IS_ERR_VALUE(vma->vm_start)) {
 		DPRINT(("Cannot find unmapped area for size %ld\n", size));
-		up_write(&task->mm->mmap_sem);
+		mmap_write_unlock(task->mm);
 		goto error;
 	}
 	vma->vm_end = vma->vm_start + size;
@@ -2277,7 +2277,7 @@ pfm_smpl_buffer_alloc(struct task_struct
 	/* can only be applied to current task, need to have the mm semaphore held when called */
 	if (pfm_remap_buffer(vma, (unsigned long)smpl_buf, vma->vm_start, size)) {
 		DPRINT(("Can't remap buffer\n"));
-		up_write(&task->mm->mmap_sem);
+		mmap_write_unlock(task->mm);
 		goto error;
 	}
 
@@ -2288,7 +2288,7 @@ pfm_smpl_buffer_alloc(struct task_struct
 	insert_vm_struct(mm, vma);
 
 	vm_stat_account(vma->vm_mm, vma->vm_flags, vma_pages(vma));
-	up_write(&task->mm->mmap_sem);
+	mmap_write_unlock(task->mm);
 
 	/*
 	 * keep track of user level virtual address
--- a/arch/ia64/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/ia64/mm/fault.c
@@ -106,7 +106,7 @@ ia64_do_page_fault (unsigned long addres
 	if (mask & VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	vma = find_vma_prev(mm, address, &prev_vma);
 	if (!vma && !prev_vma )
@@ -182,7 +182,7 @@ retry:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 
   check_expansion:
@@ -213,7 +213,7 @@ retry:
 	goto good_area;
 
   bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 #ifdef CONFIG_VIRTUAL_MEM_MAP
   bad_area_no_up:
 #endif
@@ -279,7 +279,7 @@ retry:
 	return;
 
   out_of_memory:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
--- a/arch/ia64/mm/init.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/ia64/mm/init.c
@@ -118,13 +118,13 @@ ia64_init_addr_space (void)
 		vma->vm_end = vma->vm_start + PAGE_SIZE;
 		vma->vm_flags = VM_DATA_DEFAULT_FLAGS|VM_GROWSUP|VM_ACCOUNT;
 		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
-		down_write(&current->mm->mmap_sem);
+		mmap_write_lock(current->mm);
 		if (insert_vm_struct(current->mm, vma)) {
-			up_write(&current->mm->mmap_sem);
+			mmap_write_unlock(current->mm);
 			vm_area_free(vma);
 			return;
 		}
-		up_write(&current->mm->mmap_sem);
+		mmap_write_unlock(current->mm);
 	}
 
 	/* map NaT-page at address zero to speed up speculative dereferencing of NULL: */
@@ -136,13 +136,13 @@ ia64_init_addr_space (void)
 			vma->vm_page_prot = __pgprot(pgprot_val(PAGE_READONLY) | _PAGE_MA_NAT);
 			vma->vm_flags = VM_READ | VM_MAYREAD | VM_IO |
 					VM_DONTEXPAND | VM_DONTDUMP;
-			down_write(&current->mm->mmap_sem);
+			mmap_write_lock(current->mm);
 			if (insert_vm_struct(current->mm, vma)) {
-				up_write(&current->mm->mmap_sem);
+				mmap_write_unlock(current->mm);
 				vm_area_free(vma);
 				return;
 			}
-			up_write(&current->mm->mmap_sem);
+			mmap_write_unlock(current->mm);
 		}
 	}
 }
--- a/arch/m68k/kernel/sys_m68k.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/m68k/kernel/sys_m68k.c
@@ -399,7 +399,7 @@ sys_cacheflush (unsigned long addr, int
 		 * Verify that the specified address region actually belongs
 		 * to this process.
 		 */
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		vma = find_vma(current->mm, addr);
 		if (!vma || addr < vma->vm_start || addr + len > vma->vm_end)
 			goto out_unlock;
@@ -450,7 +450,7 @@ sys_cacheflush (unsigned long addr, int
 	    }
 	}
 out_unlock:
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 out:
 	return ret;
 }
@@ -472,7 +472,7 @@ sys_atomic_cmpxchg_32(unsigned long newv
 		spinlock_t *ptl;
 		unsigned long mem_value;
 
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		pgd = pgd_offset(mm, (unsigned long)mem);
 		if (!pgd_present(*pgd))
 			goto bad_access;
@@ -501,11 +501,11 @@ sys_atomic_cmpxchg_32(unsigned long newv
 			__put_user(newval, mem);
 
 		pte_unmap_unlock(pte, ptl);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		return mem_value;
 
 	      bad_access:
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		/* This is not necessarily a bad access, we can get here if
 		   a memory we're trying to write to should be copied-on-write.
 		   Make the kernel do the necessary page stuff, then re-iterate.
@@ -545,13 +545,13 @@ sys_atomic_cmpxchg_32(unsigned long newv
 	struct mm_struct *mm = current->mm;
 	unsigned long mem_value;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	mem_value = *mem;
 	if (mem_value == oldval)
 		*mem = newval;
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return mem_value;
 }
 
--- a/arch/m68k/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/m68k/mm/fault.c
@@ -86,7 +86,7 @@ int do_page_fault(struct pt_regs *regs,
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	vma = find_vma(mm, address);
 	if (!vma)
@@ -174,7 +174,7 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return 0;
 
 /*
@@ -182,7 +182,7 @@ good_area:
  * us unable to handle the page fault gracefully.
  */
 out_of_memory:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
@@ -211,6 +211,6 @@ acc_err:
 	current->thread.faddr = address;
 
 send_sig:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return send_fault_sig(regs);
 }
--- a/arch/microblaze/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/microblaze/mm/fault.c
@@ -136,12 +136,12 @@ void do_page_fault(struct pt_regs *regs,
 	 * source.  If this is invalid we can skip the address space check,
 	 * thus avoiding the deadlock.
 	 */
-	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
+	if (unlikely(!mmap_read_trylock(mm))) {
 		if (kernel_mode(regs) && !search_exception_tables(regs->pc))
 			goto bad_area_nosemaphore;
 
 retry:
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	}
 
 	vma = find_vma(mm, address);
@@ -247,7 +247,7 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/*
 	 * keep track of tlb+htab misses that are good addrs but
@@ -258,7 +258,7 @@ good_area:
 	return;
 
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 bad_area_nosemaphore:
 	pte_errors++;
@@ -277,7 +277,7 @@ bad_area_nosemaphore:
  * us unable to handle the page fault gracefully.
  */
 out_of_memory:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		bad_page_fault(regs, address, SIGKILL);
 	else
@@ -285,7 +285,7 @@ out_of_memory:
 	return;
 
 do_sigbus:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (user_mode(regs)) {
 		force_sig_fault(SIGBUS, BUS_ADRERR, (void __user *)address);
 		return;
--- a/arch/mips/kernel/traps.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/mips/kernel/traps.c
@@ -749,13 +749,13 @@ int process_fpemu_return(int sig, void _
 		return 1;
 
 	case SIGSEGV:
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		vma = find_vma(current->mm, (unsigned long)fault_addr);
 		if (vma && (vma->vm_start <= (unsigned long)fault_addr))
 			si_code = SEGV_ACCERR;
 		else
 			si_code = SEGV_MAPERR;
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 		force_sig_fault(SIGSEGV, si_code, fault_addr);
 		return 1;
 
--- a/arch/mips/kernel/vdso.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/mips/kernel/vdso.c
@@ -94,7 +94,7 @@ int arch_setup_additional_pages(struct l
 	struct vm_area_struct *vma;
 	int ret;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	if (IS_ENABLED(CONFIG_MIPS_FP_SUPPORT)) {
@@ -187,6 +187,6 @@ int arch_setup_additional_pages(struct l
 	ret = 0;
 
 out:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
--- a/arch/nds32/kernel/vdso.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/nds32/kernel/vdso.c
@@ -130,7 +130,7 @@ int arch_setup_additional_pages(struct l
 	vdso_mapping_len += L1_cache_info[DCACHE].aliasing_num - 1;
 #endif
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	addr = vdso_random_addr(vdso_mapping_len);
@@ -185,12 +185,12 @@ int arch_setup_additional_pages(struct l
 		goto up_fail;
 	}
 
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return 0;
 
 up_fail:
 	mm->context.vdso = NULL;
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 
--- a/arch/nds32/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/nds32/mm/fault.c
@@ -126,12 +126,12 @@ void do_page_fault(unsigned long entry,
 	 * validly references user space from well defined areas of the code,
 	 * we can bug out early if this is from code which shouldn't.
 	 */
-	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
+	if (unlikely(!mmap_read_trylock(mm))) {
 		if (!user_mode(regs) &&
 		    !search_exception_tables(instruction_pointer(regs)))
 			goto no_context;
 retry:
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	} else {
 		/*
 		 * The above down_read_trylock() might have succeeded in which
@@ -255,7 +255,7 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 
 	/*
@@ -263,7 +263,7 @@ good_area:
 	 * Fix it, but check if it's kernel or user first..
 	 */
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 bad_area_nosemaphore:
 
@@ -323,14 +323,14 @@ no_context:
 	 */
 
 out_of_memory:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
 	return;
 
 do_sigbus:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/* Kernel mode? Handle exceptions or die */
 	if (!user_mode(regs))
--- a/arch/nios2/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/nios2/mm/fault.c
@@ -83,11 +83,11 @@ asmlinkage void do_page_fault(struct pt_
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 
-	if (!down_read_trylock(&mm->mmap_sem)) {
+	if (!mmap_read_trylock(mm)) {
 		if (!user_mode(regs) && !search_exception_tables(regs->ea))
 			goto bad_area_nosemaphore;
 retry:
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	}
 
 	vma = find_vma(mm, address);
@@ -169,7 +169,7 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 
 /*
@@ -177,7 +177,7 @@ good_area:
  * Fix it, but check if it's kernel or user first..
  */
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
@@ -215,14 +215,14 @@ no_context:
  * us unable to handle the page fault gracefully.
  */
 out_of_memory:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
 	return;
 
 do_sigbus:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/* Kernel mode? Handle exceptions or die */
 	if (!user_mode(regs))
--- a/arch/nios2/mm/init.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/nios2/mm/init.c
@@ -109,14 +109,14 @@ int arch_setup_additional_pages(struct l
 	struct mm_struct *mm = current->mm;
 	int ret;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 
 	/* Map kuser helpers to user space address */
 	ret = install_special_mapping(mm, KUSER_BASE, KUSER_SIZE,
 				      VM_READ | VM_EXEC | VM_MAYREAD |
 				      VM_MAYEXEC, kuser_page);
 
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 
 	return ret;
 }
--- a/arch/openrisc/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/openrisc/mm/fault.c
@@ -104,7 +104,7 @@ asmlinkage void do_page_fault(struct pt_
 		goto no_context;
 
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
 
 	if (!vma)
@@ -192,7 +192,7 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 
 	/*
@@ -201,7 +201,7 @@ good_area:
 	 */
 
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 bad_area_nosemaphore:
 
@@ -260,14 +260,14 @@ out_of_memory:
 	__asm__ __volatile__("l.nop 42");
 	__asm__ __volatile__("l.nop 1");
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
 	return;
 
 do_sigbus:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/*
 	 * Send a sigbus, regardless of whether we were in kernel
--- a/arch/parisc/kernel/traps.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/parisc/kernel/traps.c
@@ -717,7 +717,7 @@ void notrace handle_interruption(int cod
 		if (user_mode(regs)) {
 			struct vm_area_struct *vma;
 
-			down_read(&current->mm->mmap_sem);
+			mmap_read_lock(current->mm);
 			vma = find_vma(current->mm,regs->iaoq[0]);
 			if (vma && (regs->iaoq[0] >= vma->vm_start)
 				&& (vma->vm_flags & VM_EXEC)) {
@@ -725,10 +725,10 @@ void notrace handle_interruption(int cod
 				fault_address = regs->iaoq[0];
 				fault_space = regs->iasq[0];
 
-				up_read(&current->mm->mmap_sem);
+				mmap_read_unlock(current->mm);
 				break; /* call do_page_fault() */
 			}
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 		}
 		/* Fall Through */
 	case 27: 
--- a/arch/parisc/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/parisc/mm/fault.c
@@ -282,7 +282,7 @@ void do_page_fault(struct pt_regs *regs,
 	if (acc_type & VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma_prev(mm, address, &prev_vma);
 	if (!vma || address < vma->vm_start)
 		goto check_expansion;
@@ -337,7 +337,7 @@ good_area:
 			goto retry;
 		}
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 
 check_expansion:
@@ -349,7 +349,7 @@ check_expansion:
  * Something tried to access memory that isn't in our memory map..
  */
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	if (user_mode(regs)) {
 		int signo, si_code;
@@ -421,7 +421,7 @@ no_context:
 	parisc_terminate("Bad Address (null pointer deref?)", regs, code, address);
 
   out_of_memory:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
--- a/arch/powerpc/kernel/vdso.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/powerpc/kernel/vdso.c
@@ -170,7 +170,7 @@ int arch_setup_additional_pages(struct l
 	 * and end up putting it elsewhere.
 	 * Add enough to the size so that the result can be aligned.
 	 */
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 	vdso_base = get_unmapped_area(NULL, vdso_base,
 				      (vdso_pages << PAGE_SHIFT) +
@@ -210,11 +210,11 @@ int arch_setup_additional_pages(struct l
 		goto fail_mmapsem;
 	}
 
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return 0;
 
  fail_mmapsem:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return rc;
 }
 
--- a/arch/powerpc/kvm/book3s_hv.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/powerpc/kvm/book3s_hv.c
@@ -4624,14 +4624,14 @@ static int kvmppc_hv_setup_htab_rma(stru
 
 	/* Look up the VMA for the start of this memory slot */
 	hva = memslot->userspace_addr;
-	down_read(&kvm->mm->mmap_sem);
+	mmap_read_lock(kvm->mm);
 	vma = find_vma(kvm->mm, hva);
 	if (!vma || vma->vm_start > hva || (vma->vm_flags & VM_IO))
 		goto up_out;
 
 	psize = vma_kernel_pagesize(vma);
 
-	up_read(&kvm->mm->mmap_sem);
+	mmap_read_unlock(kvm->mm);
 
 	/* We can handle 4k, 64k or 16M pages in the VRMA */
 	if (psize >= 0x1000000)
@@ -4664,7 +4664,7 @@ static int kvmppc_hv_setup_htab_rma(stru
 	return err;
 
  up_out:
-	up_read(&kvm->mm->mmap_sem);
+	mmap_read_unlock(kvm->mm);
 	goto out_srcu;
 }
 
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -408,7 +408,7 @@ kvmppc_svm_page_in(struct vm_area_struct
 	 */
 	ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
 			  MADV_UNMERGEABLE, &vma->vm_flags);
-	downgrade_write(&kvm->mm->mmap_sem);
+	mmap_write_downgrade(kvm->mm);
 	*downgrade = true;
 	if (ret)
 		return ret;
@@ -525,7 +525,7 @@ kvmppc_h_svm_page_in(struct kvm *kvm, un
 
 	ret = H_PARAMETER;
 	srcu_idx = srcu_read_lock(&kvm->srcu);
-	down_write(&kvm->mm->mmap_sem);
+	mmap_write_lock(kvm->mm);
 
 	start = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(start))
@@ -548,9 +548,9 @@ out_unlock:
 	mutex_unlock(&kvm->arch.uvmem_lock);
 out:
 	if (downgrade)
-		up_read(&kvm->mm->mmap_sem);
+		mmap_read_unlock(kvm->mm);
 	else
-		up_write(&kvm->mm->mmap_sem);
+		mmap_write_unlock(kvm->mm);
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return ret;
 }
@@ -703,7 +703,7 @@ kvmppc_h_svm_page_out(struct kvm *kvm, u
 
 	ret = H_PARAMETER;
 	srcu_idx = srcu_read_lock(&kvm->srcu);
-	down_read(&kvm->mm->mmap_sem);
+	mmap_read_lock(kvm->mm);
 	start = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(start))
 		goto out;
@@ -716,7 +716,7 @@ kvmppc_h_svm_page_out(struct kvm *kvm, u
 	if (!kvmppc_svm_page_out(vma, start, end, page_shift, kvm, gpa))
 		ret = H_SUCCESS;
 out:
-	up_read(&kvm->mm->mmap_sem);
+	mmap_read_unlock(kvm->mm);
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return ret;
 }
--- a/arch/powerpc/kvm/e500_mmu_host.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/powerpc/kvm/e500_mmu_host.c
@@ -355,7 +355,7 @@ static inline int kvmppc_e500_shadow_map
 
 	if (tlbsel == 1) {
 		struct vm_area_struct *vma;
-		down_read(&kvm->mm->mmap_sem);
+		mmap_read_lock(kvm->mm);
 
 		vma = find_vma(kvm->mm, hva);
 		if (vma && hva >= vma->vm_start &&
@@ -441,7 +441,7 @@ static inline int kvmppc_e500_shadow_map
 			tsize = max(BOOK3E_PAGESZ_4K, tsize & ~1);
 		}
 
-		up_read(&kvm->mm->mmap_sem);
+		mmap_read_unlock(kvm->mm);
 	}
 
 	if (likely(!pfnmap)) {
--- a/arch/powerpc/mm/book3s64/iommu_api.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/powerpc/mm/book3s64/iommu_api.c
@@ -96,7 +96,7 @@ static long mm_iommu_do_alloc(struct mm_
 		goto unlock_exit;
 	}
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	chunk = (1UL << (PAGE_SHIFT + MAX_ORDER - 1)) /
 			sizeof(struct vm_area_struct *);
 	chunk = min(chunk, entries);
@@ -114,7 +114,7 @@ static long mm_iommu_do_alloc(struct mm_
 			pinned += ret;
 		break;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (pinned != entries) {
 		if (!ret)
 			ret = -EFAULT;
--- a/arch/powerpc/mm/book3s64/subpage_prot.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/powerpc/mm/book3s64/subpage_prot.c
@@ -94,7 +94,7 @@ static void subpage_prot_clear(unsigned
 	size_t nw;
 	unsigned long next, limit;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 
 	spt = mm_ctx_subpage_prot(&mm->context);
 	if (!spt)
@@ -129,7 +129,7 @@ static void subpage_prot_clear(unsigned
 	}
 
 err_out:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -219,7 +219,7 @@ SYSCALL_DEFINE3(subpage_prot, unsigned l
 	if (!access_ok(map, (len >> PAGE_SHIFT) * sizeof(u32)))
 		return -EFAULT;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 
 	spt = mm_ctx_subpage_prot(&mm->context);
 	if (!spt) {
@@ -269,11 +269,11 @@ SYSCALL_DEFINE3(subpage_prot, unsigned l
 		if (addr + (nw << PAGE_SHIFT) > next)
 			nw = (next - addr) >> PAGE_SHIFT;
 
-		up_write(&mm->mmap_sem);
+		mmap_write_unlock(mm);
 		if (__copy_from_user(spp, map, nw * sizeof(u32)))
 			return -EFAULT;
 		map += nw;
-		down_write(&mm->mmap_sem);
+		mmap_write_lock(mm);
 
 		/* now flush any existing HPTEs for the range */
 		hpte_flush_range(mm, addr, nw);
@@ -282,6 +282,6 @@ SYSCALL_DEFINE3(subpage_prot, unsigned l
 		spt->maxaddr = limit;
 	err = 0;
  out:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return err;
 }
--- a/arch/powerpc/mm/copro_fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/powerpc/mm/copro_fault.c
@@ -33,7 +33,7 @@ int copro_handle_mm_fault(struct mm_stru
 	if (mm->pgd == NULL)
 		return -EFAULT;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	ret = -EFAULT;
 	vma = find_vma(mm, ea);
 	if (!vma)
@@ -82,7 +82,7 @@ int copro_handle_mm_fault(struct mm_stru
 		current->min_flt++;
 
 out_unlock:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(copro_handle_mm_fault);
--- a/arch/powerpc/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/powerpc/mm/fault.c
@@ -108,7 +108,7 @@ static int __bad_area(struct pt_regs *re
 	 * Something tried to access memory that isn't in our memory map..
 	 * Fix it, but check if it's kernel or user first..
 	 */
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	return __bad_area_nosemaphore(regs, address, si_code);
 }
@@ -144,7 +144,7 @@ static noinline int bad_access_pkey(stru
 	 */
 	pkey = vma_pkey(vma);
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/*
 	 * If we are in kernel mode, bail out with a SEGV, this will
@@ -551,12 +551,12 @@ static int __do_page_fault(struct pt_reg
 	 * source.  If this is invalid we can skip the address space check,
 	 * thus avoiding the deadlock.
 	 */
-	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
+	if (unlikely(!mmap_read_trylock(mm))) {
 		if (!is_user && !search_exception_tables(regs->nip))
 			return bad_area_nosemaphore(regs, address);
 
 retry:
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	} else {
 		/*
 		 * The above down_read_trylock() might have succeeded in
@@ -580,7 +580,7 @@ retry:
 		if (!must_retry)
 			return bad_area(regs, address);
 
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		if (fault_in_pages_readable((const char __user *)regs->nip,
 					    sizeof(unsigned int)))
 			return bad_area_nosemaphore(regs, address);
@@ -625,7 +625,7 @@ good_area:
 		}
 	}
 
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	if (unlikely(fault & VM_FAULT_ERROR))
 		return mm_fault_error(regs, address, fault);
--- a/arch/powerpc/oprofile/cell/spu_task_sync.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -332,7 +332,7 @@ get_exec_dcookie_and_offset(struct spu *
 		fput(exe_file);
 	}
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->vm_start > spu_ref || vma->vm_end <= spu_ref)
 			continue;
@@ -349,13 +349,13 @@ get_exec_dcookie_and_offset(struct spu *
 	*spu_bin_dcookie = fast_get_dcookie(&vma->vm_file->f_path);
 	pr_debug("got dcookie for %pD\n", vma->vm_file);
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 out:
 	return app_cookie;
 
 fail_no_image_cookie:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	printk(KERN_ERR "SPU_PROF: "
 		"%s, line %d: Cannot find dcookie for SPU binary\n",
--- a/arch/powerpc/platforms/cell/spufs/file.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -343,11 +343,11 @@ static vm_fault_t spufs_ps_fault(struct
 		goto refault;
 
 	if (ctx->state == SPU_STATE_SAVED) {
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 		spu_context_nospu_trace(spufs_ps_fault__sleep, ctx);
 		err = spufs_wait(ctx->run_wq, ctx->state == SPU_STATE_RUNNABLE);
 		spu_context_trace(spufs_ps_fault__wake, ctx, ctx->spu);
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 	} else {
 		area = ctx->spu->problem_phys + ps_offs;
 		ret = vmf_insert_pfn(vmf->vma, vmf->address,
--- a/arch/riscv/kernel/vdso.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/riscv/kernel/vdso.c
@@ -61,7 +61,7 @@ int arch_setup_additional_pages(struct l
 
 	vdso_len = (vdso_pages + 1) << PAGE_SHIFT;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	vdso_base = get_unmapped_area(NULL, 0, vdso_len, 0, 0);
 	if (IS_ERR_VALUE(vdso_base)) {
 		ret = vdso_base;
@@ -83,7 +83,7 @@ int arch_setup_additional_pages(struct l
 		mm->context.vdso = NULL;
 
 end:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 
--- a/arch/riscv/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/riscv/mm/fault.c
@@ -69,7 +69,7 @@ asmlinkage void do_page_fault(struct pt_
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, addr);
 	if (unlikely(!vma))
 		goto bad_area;
@@ -155,7 +155,7 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 
 	/*
@@ -163,7 +163,7 @@ good_area:
 	 * Fix it, but check if it's kernel or user first.
 	 */
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	/* User mode accesses just cause a SIGSEGV */
 	if (user_mode(regs)) {
 		do_trap(regs, SIGSEGV, code, addr);
@@ -191,14 +191,14 @@ no_context:
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
 out_of_memory:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		goto no_context;
 	pagefault_out_of_memory();
 	return;
 
 do_sigbus:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	/* Kernel mode? Handle exceptions or die */
 	if (!user_mode(regs))
 		goto no_context;
--- a/arch/s390/kernel/uv.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/s390/kernel/uv.c
@@ -205,7 +205,7 @@ int gmap_make_secure(struct gmap *gmap,
 
 again:
 	rc = -EFAULT;
-	down_read(&gmap->mm->mmap_sem);
+	mmap_read_lock(gmap->mm);
 
 	uaddr = __gmap_translate(gmap, gaddr);
 	if (IS_ERR_VALUE(uaddr))
@@ -234,7 +234,7 @@ again:
 	pte_unmap_unlock(ptep, ptelock);
 	unlock_page(page);
 out:
-	up_read(&gmap->mm->mmap_sem);
+	mmap_read_unlock(gmap->mm);
 
 	if (rc == -EAGAIN) {
 		wait_on_page_writeback(page);
--- a/arch/s390/kernel/vdso.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/s390/kernel/vdso.c
@@ -207,7 +207,7 @@ int arch_setup_additional_pages(struct l
 	 * it at vdso_base which is the "natural" base for it, but we might
 	 * fail and end up putting it elsewhere.
 	 */
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 	vdso_base = get_unmapped_area(NULL, 0, vdso_pages << PAGE_SHIFT, 0, 0);
 	if (IS_ERR_VALUE(vdso_base)) {
@@ -238,7 +238,7 @@ int arch_setup_additional_pages(struct l
 	rc = 0;
 
 out_up:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return rc;
 }
 
--- a/arch/s390/kvm/gaccess.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/s390/kvm/gaccess.c
@@ -1173,7 +1173,7 @@ int kvm_s390_shadow_fault(struct kvm_vcp
 	int dat_protection, fake;
 	int rc;
 
-	down_read(&sg->mm->mmap_sem);
+	mmap_read_lock(sg->mm);
 	/*
 	 * We don't want any guest-2 tables to change - so the parent
 	 * tables/pointers we read stay valid - unshadowing is however
@@ -1202,6 +1202,6 @@ shadow_page:
 	if (!rc)
 		rc = gmap_shadow_page(sg, saddr, __pte(pte.val));
 	ipte_unlock(vcpu);
-	up_read(&sg->mm->mmap_sem);
+	mmap_read_unlock(sg->mm);
 	return rc;
 }
--- a/arch/s390/kvm/interrupt.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/s390/kvm/interrupt.c
@@ -2767,10 +2767,10 @@ static struct page *get_map_page(struct
 {
 	struct page *page = NULL;
 
-	down_read(&kvm->mm->mmap_sem);
+	mmap_read_lock(kvm->mm);
 	get_user_pages_remote(NULL, kvm->mm, uaddr, 1, FOLL_WRITE,
 			      &page, NULL, NULL);
-	up_read(&kvm->mm->mmap_sem);
+	mmap_read_unlock(kvm->mm);
 	return page;
 }
 
--- a/arch/s390/kvm/kvm-s390.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/s390/kvm/kvm-s390.c
@@ -763,9 +763,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 			r = -EINVAL;
 		else {
 			r = 0;
-			down_write(&kvm->mm->mmap_sem);
+			mmap_write_lock(kvm->mm);
 			kvm->mm->context.allow_gmap_hpage_1m = 1;
-			up_write(&kvm->mm->mmap_sem);
+			mmap_write_unlock(kvm->mm);
 			/*
 			 * We might have to create fake 4k page
 			 * tables. To avoid that the hardware works on
@@ -1815,7 +1815,7 @@ static long kvm_s390_get_skeys(struct kv
 	if (!keys)
 		return -ENOMEM;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	for (i = 0; i < args->count; i++) {
 		hva = gfn_to_hva(kvm, args->start_gfn + i);
@@ -1829,7 +1829,7 @@ static long kvm_s390_get_skeys(struct kv
 			break;
 	}
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	if (!r) {
 		r = copy_to_user((uint8_t __user *)args->skeydata_addr, keys,
@@ -1873,7 +1873,7 @@ static long kvm_s390_set_skeys(struct kv
 		goto out;
 
 	i = 0;
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	srcu_idx = srcu_read_lock(&kvm->srcu);
         while (i < args->count) {
 		unlocked = false;
@@ -1900,7 +1900,7 @@ static long kvm_s390_set_skeys(struct kv
 			i++;
 	}
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 out:
 	kvfree(keys);
 	return r;
@@ -2089,14 +2089,14 @@ static int kvm_s390_get_cmma_bits(struct
 	if (!values)
 		return -ENOMEM;
 
-	down_read(&kvm->mm->mmap_sem);
+	mmap_read_lock(kvm->mm);
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	if (peek)
 		ret = kvm_s390_peek_cmma(kvm, args, values, bufsize);
 	else
 		ret = kvm_s390_get_cmma(kvm, args, values, bufsize);
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	up_read(&kvm->mm->mmap_sem);
+	mmap_read_unlock(kvm->mm);
 
 	if (kvm->arch.migration_mode)
 		args->remaining = atomic64_read(&kvm->arch.cmma_dirty_pages);
@@ -2146,7 +2146,7 @@ static int kvm_s390_set_cmma_bits(struct
 		goto out;
 	}
 
-	down_read(&kvm->mm->mmap_sem);
+	mmap_read_lock(kvm->mm);
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	for (i = 0; i < args->count; i++) {
 		hva = gfn_to_hva(kvm, args->start_gfn + i);
@@ -2161,12 +2161,12 @@ static int kvm_s390_set_cmma_bits(struct
 		set_pgste_bits(kvm->mm, hva, mask, pgstev);
 	}
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	up_read(&kvm->mm->mmap_sem);
+	mmap_read_unlock(kvm->mm);
 
 	if (!kvm->mm->context.uses_cmm) {
-		down_write(&kvm->mm->mmap_sem);
+		mmap_write_lock(kvm->mm);
 		kvm->mm->context.uses_cmm = 1;
-		up_write(&kvm->mm->mmap_sem);
+		mmap_write_unlock(kvm->mm);
 	}
 out:
 	vfree(bits);
@@ -2239,9 +2239,9 @@ static int kvm_s390_handle_pv(struct kvm
 		if (r)
 			break;
 
-		down_write(&current->mm->mmap_sem);
+		mmap_write_lock(current->mm);
 		r = gmap_mark_unmergeable();
-		up_write(&current->mm->mmap_sem);
+		mmap_write_unlock(current->mm);
 		if (r)
 			break;
 
--- a/arch/s390/kvm/priv.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/s390/kvm/priv.c
@@ -270,18 +270,18 @@ static int handle_iske(struct kvm_vcpu *
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 retry:
 	unlocked = false;
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	rc = get_guest_storage_key(current->mm, vmaddr, &key);
 
 	if (rc) {
 		rc = fixup_user_fault(current, current->mm, vmaddr,
 				      FAULT_FLAG_WRITE, &unlocked);
 		if (!rc) {
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 			goto retry;
 		}
 	}
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	if (rc == -EFAULT)
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 	if (rc < 0)
@@ -317,17 +317,17 @@ static int handle_rrbe(struct kvm_vcpu *
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 retry:
 	unlocked = false;
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	rc = reset_guest_reference_bit(current->mm, vmaddr);
 	if (rc < 0) {
 		rc = fixup_user_fault(current, current->mm, vmaddr,
 				      FAULT_FLAG_WRITE, &unlocked);
 		if (!rc) {
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 			goto retry;
 		}
 	}
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	if (rc == -EFAULT)
 		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 	if (rc < 0)
@@ -385,7 +385,7 @@ static int handle_sske(struct kvm_vcpu *
 		if (kvm_is_error_hva(vmaddr))
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		rc = cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey,
 						m3 & SSKE_NQ, m3 & SSKE_MR,
 						m3 & SSKE_MC);
@@ -395,7 +395,7 @@ static int handle_sske(struct kvm_vcpu *
 					      FAULT_FLAG_WRITE, &unlocked);
 			rc = !rc ? -EAGAIN : rc;
 		}
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 		if (rc == -EFAULT)
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 		if (rc < 0)
@@ -1091,7 +1091,7 @@ static int handle_pfmf(struct kvm_vcpu *
 
 			if (rc)
 				return rc;
-			down_read(&current->mm->mmap_sem);
+			mmap_read_lock(current->mm);
 			rc = cond_set_guest_storage_key(current->mm, vmaddr,
 							key, NULL, nq, mr, mc);
 			if (rc < 0) {
@@ -1099,7 +1099,7 @@ static int handle_pfmf(struct kvm_vcpu *
 						      FAULT_FLAG_WRITE, &unlocked);
 				rc = !rc ? -EAGAIN : rc;
 			}
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 			if (rc == -EFAULT)
 				return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
 			if (rc == -EAGAIN)
@@ -1220,9 +1220,9 @@ static int handle_essa(struct kvm_vcpu *
 		 * already correct, we do nothing and avoid the lock.
 		 */
 		if (vcpu->kvm->mm->context.uses_cmm == 0) {
-			down_write(&vcpu->kvm->mm->mmap_sem);
+			mmap_write_lock(vcpu->kvm->mm);
 			vcpu->kvm->mm->context.uses_cmm = 1;
-			up_write(&vcpu->kvm->mm->mmap_sem);
+			mmap_write_unlock(vcpu->kvm->mm);
 		}
 		/*
 		 * If we are here, we are supposed to have CMMA enabled in
@@ -1239,11 +1239,11 @@ static int handle_essa(struct kvm_vcpu *
 	} else {
 		int srcu_idx;
 
-		down_read(&vcpu->kvm->mm->mmap_sem);
+		mmap_read_lock(vcpu->kvm->mm);
 		srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 		i = __do_essa(vcpu, orc);
 		srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
-		up_read(&vcpu->kvm->mm->mmap_sem);
+		mmap_read_unlock(vcpu->kvm->mm);
 		if (i < 0)
 			return i;
 		/* Account for the possible extra cbrl entry */
@@ -1251,10 +1251,10 @@ static int handle_essa(struct kvm_vcpu *
 	}
 	vcpu->arch.sie_block->cbrlo &= PAGE_MASK;	/* reset nceo */
 	cbrlo = phys_to_virt(vcpu->arch.sie_block->cbrlo);
-	down_read(&gmap->mm->mmap_sem);
+	mmap_read_lock(gmap->mm);
 	for (i = 0; i < entries; ++i)
 		__gmap_zap(gmap, cbrlo[i]);
-	up_read(&gmap->mm->mmap_sem);
+	mmap_read_unlock(gmap->mm);
 	return 0;
 }
 
--- a/arch/s390/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/s390/mm/fault.c
@@ -433,7 +433,7 @@ static inline vm_fault_t do_exception(st
 		flags |= FAULT_FLAG_USER;
 	if (access == VM_WRITE || (trans_exc_code & store_indication) == 0x400)
 		flags |= FAULT_FLAG_WRITE;
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	gmap = NULL;
 	if (IS_ENABLED(CONFIG_PGSTE) && type == GMAP_FAULT) {
@@ -514,7 +514,7 @@ retry:
 			}
 			flags &= ~FAULT_FLAG_RETRY_NOWAIT;
 			flags |= FAULT_FLAG_TRIED;
-			down_read(&mm->mmap_sem);
+			mmap_read_lock(mm);
 			goto retry;
 		}
 	}
@@ -532,7 +532,7 @@ retry:
 	}
 	fault = 0;
 out_up:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 out:
 	return fault;
 }
@@ -824,22 +824,22 @@ void do_secure_storage_access(struct pt_
 	switch (get_fault_type(regs)) {
 	case USER_FAULT:
 		mm = current->mm;
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		vma = find_vma(mm, addr);
 		if (!vma) {
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 			do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
 			break;
 		}
 		page = follow_page(vma, addr, FOLL_WRITE | FOLL_GET);
 		if (IS_ERR_OR_NULL(page)) {
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 			break;
 		}
 		if (arch_make_page_accessible(page))
 			send_sig(SIGSEGV, current, 0);
 		put_page(page);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		break;
 	case KERNEL_FAULT:
 		page = phys_to_page(addr);
--- a/arch/s390/mm/gmap.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/s390/mm/gmap.c
@@ -405,10 +405,10 @@ int gmap_unmap_segment(struct gmap *gmap
 		return -EINVAL;
 
 	flush = 0;
-	down_write(&gmap->mm->mmap_sem);
+	mmap_write_lock(gmap->mm);
 	for (off = 0; off < len; off += PMD_SIZE)
 		flush |= __gmap_unmap_by_gaddr(gmap, to + off);
-	up_write(&gmap->mm->mmap_sem);
+	mmap_write_unlock(gmap->mm);
 	if (flush)
 		gmap_flush_tlb(gmap);
 	return 0;
@@ -438,7 +438,7 @@ int gmap_map_segment(struct gmap *gmap,
 		return -EINVAL;
 
 	flush = 0;
-	down_write(&gmap->mm->mmap_sem);
+	mmap_write_lock(gmap->mm);
 	for (off = 0; off < len; off += PMD_SIZE) {
 		/* Remove old translation */
 		flush |= __gmap_unmap_by_gaddr(gmap, to + off);
@@ -448,7 +448,7 @@ int gmap_map_segment(struct gmap *gmap,
 				      (void *) from + off))
 			break;
 	}
-	up_write(&gmap->mm->mmap_sem);
+	mmap_write_unlock(gmap->mm);
 	if (flush)
 		gmap_flush_tlb(gmap);
 	if (off >= len)
@@ -495,9 +495,9 @@ unsigned long gmap_translate(struct gmap
 {
 	unsigned long rc;
 
-	down_read(&gmap->mm->mmap_sem);
+	mmap_read_lock(gmap->mm);
 	rc = __gmap_translate(gmap, gaddr);
-	up_read(&gmap->mm->mmap_sem);
+	mmap_read_unlock(gmap->mm);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(gmap_translate);
@@ -640,7 +640,7 @@ int gmap_fault(struct gmap *gmap, unsign
 	int rc;
 	bool unlocked;
 
-	down_read(&gmap->mm->mmap_sem);
+	mmap_read_lock(gmap->mm);
 
 retry:
 	unlocked = false;
@@ -663,7 +663,7 @@ retry:
 
 	rc = __gmap_link(gmap, gaddr, vmaddr);
 out_up:
-	up_read(&gmap->mm->mmap_sem);
+	mmap_read_unlock(gmap->mm);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(gmap_fault);
@@ -696,7 +696,7 @@ void gmap_discard(struct gmap *gmap, uns
 	unsigned long gaddr, vmaddr, size;
 	struct vm_area_struct *vma;
 
-	down_read(&gmap->mm->mmap_sem);
+	mmap_read_lock(gmap->mm);
 	for (gaddr = from; gaddr < to;
 	     gaddr = (gaddr + PMD_SIZE) & PMD_MASK) {
 		/* Find the vm address for the guest address */
@@ -719,7 +719,7 @@ void gmap_discard(struct gmap *gmap, uns
 		size = min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
 		zap_page_range(vma, vmaddr, size);
 	}
-	up_read(&gmap->mm->mmap_sem);
+	mmap_read_unlock(gmap->mm);
 }
 EXPORT_SYMBOL_GPL(gmap_discard);
 
@@ -1106,9 +1106,9 @@ int gmap_mprotect_notify(struct gmap *gm
 		return -EINVAL;
 	if (!MACHINE_HAS_ESOP && prot == PROT_READ)
 		return -EINVAL;
-	down_read(&gmap->mm->mmap_sem);
+	mmap_read_lock(gmap->mm);
 	rc = gmap_protect_range(gmap, gaddr, len, prot, GMAP_NOTIFY_MPROT);
-	up_read(&gmap->mm->mmap_sem);
+	mmap_read_unlock(gmap->mm);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(gmap_mprotect_notify);
@@ -1696,11 +1696,11 @@ struct gmap *gmap_shadow(struct gmap *pa
 	}
 	spin_unlock(&parent->shadow_lock);
 	/* protect after insertion, so it will get properly invalidated */
-	down_read(&parent->mm->mmap_sem);
+	mmap_read_lock(parent->mm);
 	rc = gmap_protect_range(parent, asce & _ASCE_ORIGIN,
 				((asce & _ASCE_TABLE_LENGTH) + 1) * PAGE_SIZE,
 				PROT_READ, GMAP_NOTIFY_SHADOW);
-	up_read(&parent->mm->mmap_sem);
+	mmap_read_unlock(parent->mm);
 	spin_lock(&parent->shadow_lock);
 	new->initialized = true;
 	if (rc) {
@@ -2543,12 +2543,12 @@ int s390_enable_sie(void)
 	/* Fail if the page tables are 2K */
 	if (!mm_alloc_pgste(mm))
 		return -EINVAL;
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	mm->context.has_pgste = 1;
 	/* split thp mappings and disable thp for future mappings */
 	thp_split_mm(mm);
 	walk_page_range(mm, 0, TASK_SIZE, &zap_zero_walk_ops, NULL);
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(s390_enable_sie);
@@ -2617,7 +2617,7 @@ int s390_enable_skey(void)
 	struct mm_struct *mm = current->mm;
 	int rc = 0;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	if (mm_uses_skeys(mm))
 		goto out_up;
 
@@ -2630,7 +2630,7 @@ int s390_enable_skey(void)
 	walk_page_range(mm, 0, TASK_SIZE, &enable_skey_walk_ops, NULL);
 
 out_up:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(s390_enable_skey);
@@ -2651,9 +2651,9 @@ static const struct mm_walk_ops reset_cm
 
 void s390_reset_cmma(struct mm_struct *mm)
 {
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	walk_page_range(mm, 0, TASK_SIZE, &reset_cmma_walk_ops, NULL);
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 }
 EXPORT_SYMBOL_GPL(s390_reset_cmma);
 
@@ -2685,9 +2685,9 @@ void s390_reset_acc(struct mm_struct *mm
 	 */
 	if (!mmget_not_zero(mm))
 		return;
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	walk_page_range(mm, 0, TASK_SIZE, &reset_acc_walk_ops, NULL);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 }
 EXPORT_SYMBOL_GPL(s390_reset_acc);
--- a/arch/s390/pci/pci_mmio.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/s390/pci/pci_mmio.c
@@ -125,7 +125,7 @@ static long get_pfn(unsigned long user_a
 	struct vm_area_struct *vma;
 	long ret;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	ret = -EINVAL;
 	vma = find_vma(current->mm, user_addr);
 	if (!vma)
@@ -135,7 +135,7 @@ static long get_pfn(unsigned long user_a
 		goto out;
 	ret = follow_pfn(vma, user_addr, pfn);
 out:
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	return ret;
 }
 
--- a/arch/sh/kernel/sys_sh.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/sh/kernel/sys_sh.c
@@ -69,10 +69,10 @@ asmlinkage int sys_cacheflush(unsigned l
 	if (addr + len < addr)
 		return -EFAULT;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	vma = find_vma (current->mm, addr);
 	if (vma == NULL || addr < vma->vm_start || addr + len > vma->vm_end) {
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 		return -EFAULT;
 	}
 
@@ -91,6 +91,6 @@ asmlinkage int sys_cacheflush(unsigned l
 	if (op & CACHEFLUSH_I)
 		flush_icache_range(addr, addr+len);
 
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	return 0;
 }
--- a/arch/sh/kernel/vsyscall/vsyscall.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/sh/kernel/vsyscall/vsyscall.c
@@ -61,7 +61,7 @@ int arch_setup_additional_pages(struct l
 	unsigned long addr;
 	int ret;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
@@ -80,7 +80,7 @@ int arch_setup_additional_pages(struct l
 	current->mm->context.vdso = (void *)addr;
 
 up_fail:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 
--- a/arch/sh/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/sh/mm/fault.c
@@ -279,7 +279,7 @@ __bad_area(struct pt_regs *regs, unsigne
 	 * Something tried to access memory that isn't in our memory map..
 	 * Fix it, but check if it's kernel or user first..
 	 */
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	__bad_area_nosemaphore(regs, error_code, address, si_code);
 }
@@ -303,7 +303,7 @@ do_sigbus(struct pt_regs *regs, unsigned
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/* Kernel mode? Handle exceptions or die: */
 	if (!user_mode(regs))
@@ -328,7 +328,7 @@ mm_fault_error(struct pt_regs *regs, uns
 
 	/* Release mmap_sem first if necessary */
 	if (!(fault & VM_FAULT_RETRY))
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 
 	if (!(fault & VM_FAULT_ERROR))
 		return 0;
@@ -442,7 +442,7 @@ asmlinkage void __kprobes do_page_fault(
 	}
 
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	vma = find_vma(mm, address);
 	if (unlikely(!vma)) {
@@ -510,5 +510,5 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 }
--- a/arch/sparc/mm/fault_32.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/sparc/mm/fault_32.c
@@ -195,7 +195,7 @@ asmlinkage void do_sparc_fault(struct pt
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	if (!from_user && address >= PAGE_OFFSET)
 		goto bad_area;
@@ -271,7 +271,7 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 
 	/*
@@ -279,7 +279,7 @@ good_area:
 	 * Fix it, but check if it's kernel or user first..
 	 */
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
@@ -328,7 +328,7 @@ no_context:
  * us unable to handle the page fault gracefully.
  */
 out_of_memory:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (from_user) {
 		pagefault_out_of_memory();
 		return;
@@ -336,7 +336,7 @@ out_of_memory:
 	goto no_context;
 
 do_sigbus:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	do_fault_siginfo(BUS_ADRERR, SIGBUS, regs, text_fault);
 	if (!from_user)
 		goto no_context;
@@ -390,7 +390,7 @@ static void force_user_fault(unsigned lo
 
 	code = SEGV_MAPERR;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
@@ -415,15 +415,15 @@ good_area:
 	case VM_FAULT_OOM:
 		goto do_sigbus;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	__do_fault_siginfo(code, SIGSEGV, tsk->thread.kregs, address);
 	return;
 
 do_sigbus:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	__do_fault_siginfo(BUS_ADRERR, SIGBUS, tsk->thread.kregs, address);
 }
 
--- a/arch/sparc/mm/fault_64.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/sparc/mm/fault_64.c
@@ -318,7 +318,7 @@ asmlinkage void __kprobes do_sparc64_fau
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
-	if (!down_read_trylock(&mm->mmap_sem)) {
+	if (!mmap_read_trylock(mm)) {
 		if ((regs->tstate & TSTATE_PRIV) &&
 		    !search_exception_tables(regs->tpc)) {
 			insn = get_fault_insn(regs, insn);
@@ -326,7 +326,7 @@ asmlinkage void __kprobes do_sparc64_fau
 		}
 
 retry:
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	}
 
 	if (fault_code & FAULT_CODE_BAD_RA)
@@ -458,7 +458,7 @@ good_area:
 			goto retry;
 		}
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	mm_rss = get_mm_rss(mm);
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
@@ -489,7 +489,7 @@ exit_exception:
 	 */
 bad_area:
 	insn = get_fault_insn(regs, insn);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 handle_kernel_fault:
 	do_kernel_fault(regs, si_code, fault_code, insn, address);
@@ -501,7 +501,7 @@ handle_kernel_fault:
  */
 out_of_memory:
 	insn = get_fault_insn(regs, insn);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!(regs->tstate & TSTATE_PRIV)) {
 		pagefault_out_of_memory();
 		goto exit_exception;
@@ -514,7 +514,7 @@ intr_or_no_mm:
 
 do_sigbus:
 	insn = get_fault_insn(regs, insn);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/*
 	 * Send a sigbus, regardless of whether we were in kernel
--- a/arch/sparc/vdso/vma.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/sparc/vdso/vma.c
@@ -366,7 +366,7 @@ static int map_vdso(const struct vdso_im
 	unsigned long text_start, addr = 0;
 	int ret = 0;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 
 	/*
 	 * First, get an unmapped region: then randomize it, and make sure that
@@ -422,7 +422,7 @@ up_fail:
 	if (ret)
 		current->mm->context.vdso = NULL;
 
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 
--- a/arch/um/include/asm/mmu_context.h~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/um/include/asm/mmu_context.h
@@ -49,7 +49,7 @@ static inline void activate_mm(struct mm
 	__switch_mm(&new->context.id);
 	down_write_nested(&new->mmap_sem, 1);
 	uml_setup_stubs(new);
-	up_write(&new->mmap_sem);
+	mmap_write_unlock(new);
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
--- a/arch/um/kernel/tlb.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/um/kernel/tlb.c
@@ -349,7 +349,7 @@ void fix_range_common(struct mm_struct *
 		printk(KERN_ERR "fix_range_common: failed, killing current "
 		       "process: %d\n", task_tgid_vnr(current));
 		/* We are under mmap_sem, release it such that current can terminate */
-		up_write(&current->mm->mmap_sem);
+		mmap_write_unlock(current->mm);
 		force_sig(SIGKILL);
 		do_signal(&current->thread.regs);
 	}
--- a/arch/um/kernel/trap.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/um/kernel/trap.c
@@ -43,7 +43,7 @@ int handle_page_fault(unsigned long addr
 	if (is_user)
 		flags |= FAULT_FLAG_USER;
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto out;
@@ -116,7 +116,7 @@ good_area:
 #endif
 	flush_tlb_page(vma, address);
 out:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 out_nosemaphore:
 	return err;
 
@@ -125,7 +125,7 @@ out_of_memory:
 	 * We ran out of memory, call the OOM killer, and return the userspace
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!is_user)
 		goto out_nosemaphore;
 	pagefault_out_of_memory();
--- a/arch/unicore32/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/unicore32/mm/fault.c
@@ -223,12 +223,12 @@ static int do_pf(unsigned long addr, uns
 	 * validly references user space from well defined areas of the code,
 	 * we can bug out early if this is from code which shouldn't.
 	 */
-	if (!down_read_trylock(&mm->mmap_sem)) {
+	if (!mmap_read_trylock(mm)) {
 		if (!user_mode(regs)
 		    && !search_exception_tables(regs->UCreg_pc))
 			goto no_context;
 retry:
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	} else {
 		/*
 		 * The above down_read_trylock() might have succeeded in
@@ -263,7 +263,7 @@ retry:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/*
 	 * Handle the "normal" case first - VM_FAULT_MAJOR
--- a/arch/x86/entry/vdso/vma.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/x86/entry/vdso/vma.c
@@ -144,7 +144,7 @@ int vdso_join_timens(struct task_struct
 	struct mm_struct *mm = task->mm;
 	struct vm_area_struct *vma;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
@@ -154,7 +154,7 @@ int vdso_join_timens(struct task_struct
 			zap_page_range(vma, vma->vm_start, size);
 	}
 
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return 0;
 }
 #else
@@ -268,7 +268,7 @@ static int map_vdso(const struct vdso_im
 	unsigned long text_start;
 	int ret = 0;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	addr = get_unmapped_area(NULL, addr,
@@ -311,7 +311,7 @@ static int map_vdso(const struct vdso_im
 	}
 
 up_fail:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 
@@ -373,7 +373,7 @@ int map_vdso_once(const struct vdso_imag
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	/*
 	 * Check if we have already mapped vdso blob - fail to prevent
 	 * abusing from userspace install_speciall_mapping, which may
@@ -384,11 +384,11 @@ int map_vdso_once(const struct vdso_imag
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma_is_special_mapping(vma, &vdso_mapping) ||
 				vma_is_special_mapping(vma, &vvar_mapping)) {
-			up_write(&mm->mmap_sem);
+			mmap_write_unlock(mm);
 			return -EEXIST;
 		}
 	}
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 
 	return map_vdso(image, addr);
 }
--- a/arch/x86/kernel/vm86_32.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/x86/kernel/vm86_32.c
@@ -171,7 +171,7 @@ static void mark_screen_rdonly(struct mm
 	pte_t *pte;
 	int i;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	pgd = pgd_offset(mm, 0xA0000);
 	if (pgd_none_or_clear_bad(pgd))
 		goto out;
@@ -197,7 +197,7 @@ static void mark_screen_rdonly(struct mm
 	}
 	pte_unmap_unlock(pte, ptl);
 out:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	flush_tlb_mm_range(mm, 0xA0000, 0xA0000 + 32*PAGE_SIZE, PAGE_SHIFT, false);
 }
 
--- a/arch/x86/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/x86/mm/fault.c
@@ -810,7 +810,7 @@ __bad_area(struct pt_regs *regs, unsigne
 	 * Something tried to access memory that isn't in our memory map..
 	 * Fix it, but check if it's kernel or user first..
 	 */
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	__bad_area_nosemaphore(regs, error_code, address, pkey, si_code);
 }
@@ -1238,7 +1238,7 @@ void do_user_addr_fault(struct pt_regs *
 	 * 1. Failed to acquire mmap_sem, and
 	 * 2. The access did not originate in userspace.
 	 */
-	if (unlikely(!down_read_trylock(&mm->mmap_sem))) {
+	if (unlikely(!mmap_read_trylock(mm))) {
 		if (!user_mode(regs) && !search_exception_tables(regs->ip)) {
 			/*
 			 * Fault from code in kernel from
@@ -1248,7 +1248,7 @@ void do_user_addr_fault(struct pt_regs *
 			return;
 		}
 retry:
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	} else {
 		/*
 		 * The above down_read_trylock() might have succeeded in
@@ -1319,7 +1319,7 @@ good_area:
 		goto retry;
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		mm_fault_error(regs, hw_error_code, address, fault);
 		return;
--- a/arch/x86/um/vdso/vma.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/x86/um/vdso/vma.c
@@ -58,7 +58,7 @@ int arch_setup_additional_pages(struct l
 	if (!vdso_enabled)
 		return 0;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	err = install_special_mapping(mm, um_vdso_addr, PAGE_SIZE,
@@ -66,7 +66,7 @@ int arch_setup_additional_pages(struct l
 		VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 		vdsop);
 
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 
 	return err;
 }
--- a/arch/xtensa/mm/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/arch/xtensa/mm/fault.c
@@ -74,7 +74,7 @@ void do_page_fault(struct pt_regs *regs)
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
 
 	if (!vma)
@@ -139,7 +139,7 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 	if (flags & VM_FAULT_MAJOR)
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
@@ -152,7 +152,7 @@ good_area:
 	 * Fix it, but check if it's kernel or user first..
 	 */
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (user_mode(regs)) {
 		current->thread.bad_vaddr = address;
 		current->thread.error_code = is_write;
@@ -167,7 +167,7 @@ bad_area:
 	 * us unable to handle the page fault gracefully.
 	 */
 out_of_memory:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (!user_mode(regs))
 		bad_page_fault(regs, address, SIGKILL);
 	else
@@ -175,7 +175,7 @@ out_of_memory:
 	return;
 
 do_sigbus:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/* Send a sigbus, regardless of whether we were in kernel
 	 * or user mode.
--- a/drivers/android/binder_alloc.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/android/binder_alloc.c
@@ -212,7 +212,7 @@ static int binder_update_page_range(stru
 		mm = alloc->vma_vm_mm;
 
 	if (mm) {
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		vma = alloc->vma;
 	}
 
@@ -270,7 +270,7 @@ static int binder_update_page_range(stru
 		trace_binder_alloc_page_end(alloc, index);
 	}
 	if (mm) {
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		mmput(mm);
 	}
 	return 0;
@@ -303,7 +303,7 @@ err_page_ptr_cleared:
 	}
 err_no_vma:
 	if (mm) {
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		mmput(mm);
 	}
 	return vma ? -ENOMEM : -ESRCH;
@@ -932,7 +932,7 @@ enum lru_status binder_alloc_free_page(s
 	mm = alloc->vma_vm_mm;
 	if (!mmget_not_zero(mm))
 		goto err_mmget;
-	if (!down_read_trylock(&mm->mmap_sem))
+	if (!mmap_read_trylock(mm))
 		goto err_down_read_mmap_sem_failed;
 	vma = binder_alloc_get_vma(alloc);
 
@@ -946,7 +946,7 @@ enum lru_status binder_alloc_free_page(s
 
 		trace_binder_unmap_user_end(alloc, index);
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 
 	trace_binder_unmap_kernel_start(alloc, index);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1393,9 +1393,9 @@ int amdgpu_amdkfd_gpuvm_map_memory_to_gp
 	 * concurrently and the queues are actually stopped
 	 */
 	if (amdgpu_ttm_tt_get_usermm(bo->tbo.ttm)) {
-		down_write(&current->mm->mmap_sem);
+		mmap_write_lock(current->mm);
 		is_invalid_userptr = atomic_read(&mem->invalid);
-		up_write(&current->mm->mmap_sem);
+		mmap_write_unlock(current->mm);
 	}
 
 	mutex_lock(&mem->lock);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -910,7 +910,7 @@ int amdgpu_ttm_tt_get_user_pages(struct
 		goto out_free_ranges;
 	}
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, start);
 	if (unlikely(!vma || start < vma->vm_start)) {
 		r = -EFAULT;
@@ -921,15 +921,15 @@ int amdgpu_ttm_tt_get_user_pages(struct
 		r = -EPERM;
 		goto out_unlock;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 
 retry:
 	range->notifier_seq = mmu_interval_read_begin(&bo->notifier);
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	r = hmm_range_fault(range);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (unlikely(r)) {
 		/*
 		 * FIXME: This timeout should encompass the retry from
@@ -954,7 +954,7 @@ retry:
 	return 0;
 
 out_unlock:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 out_free_pfns:
 	kvfree(range->hmm_pfns);
 out_free_ranges:
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -901,7 +901,7 @@ void kfd_signal_iommu_event(struct kfd_d
 
 	memset(&memory_exception_data, 0, sizeof(memory_exception_data));
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
 
 	memory_exception_data.gpu_id = dev->id;
@@ -924,7 +924,7 @@ void kfd_signal_iommu_event(struct kfd_d
 			memory_exception_data.failure.NoExecute = 0;
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 
 	pr_debug("notpresent %d, noexecute %d, readonly %d\n",
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -93,7 +93,7 @@ i915_gem_mmap_ioctl(struct drm_device *d
 		struct mm_struct *mm = current->mm;
 		struct vm_area_struct *vma;
 
-		if (down_write_killable(&mm->mmap_sem)) {
+		if (mmap_write_lock_killable(mm)) {
 			addr = -EINTR;
 			goto err;
 		}
@@ -103,7 +103,7 @@ i915_gem_mmap_ioctl(struct drm_device *d
 				pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
 		else
 			addr = -ENOMEM;
-		up_write(&mm->mmap_sem);
+		mmap_write_unlock(mm);
 		if (IS_ERR_VALUE(addr))
 			goto err;
 	}
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -200,7 +200,7 @@ i915_mmu_notifier_find(struct i915_mm_st
 	if (IS_ERR(mn))
 		err = PTR_ERR(mn);
 
-	down_write(&mm->mm->mmap_sem);
+	mmap_write_lock(mm->mm);
 	mutex_lock(&mm->i915->mm_lock);
 	if (mm->mn == NULL && !err) {
 		/* Protected by mmap_sem (write-lock) */
@@ -217,7 +217,7 @@ i915_mmu_notifier_find(struct i915_mm_st
 		err = 0;
 	}
 	mutex_unlock(&mm->i915->mm_lock);
-	up_write(&mm->mm->mmap_sem);
+	mmap_write_unlock(mm->mm);
 
 	if (mn && !IS_ERR(mn))
 		kfree(mn);
@@ -468,7 +468,7 @@ __i915_gem_userptr_get_pages_worker(stru
 		if (mmget_not_zero(mm)) {
 			while (pinned < npages) {
 				if (!locked) {
-					down_read(&mm->mmap_sem);
+					mmap_read_lock(mm);
 					locked = 1;
 				}
 				ret = pin_user_pages_remote
@@ -483,7 +483,7 @@ __i915_gem_userptr_get_pages_worker(stru
 				pinned += ret;
 			}
 			if (locked)
-				up_read(&mm->mmap_sem);
+				mmap_read_unlock(mm);
 			mmput(mm);
 		}
 	}
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -169,10 +169,10 @@ nouveau_svmm_bind(struct drm_device *dev
 	 */
 
 	mm = get_task_mm(current);
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	if (!cli->svm.svmm) {
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		return -EINVAL;
 	}
 
@@ -198,7 +198,7 @@ nouveau_svmm_bind(struct drm_device *dev
 	 */
 	args->result = 0;
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 
 	return 0;
@@ -348,7 +348,7 @@ nouveau_svmm_init(struct drm_device *dev
 	if (ret)
 		goto out_free;
 
-	down_write(&current->mm->mmap_sem);
+	mmap_write_lock(current->mm);
 	svmm->notifier.ops = &nouveau_mn_ops;
 	ret = __mmu_notifier_register(&svmm->notifier, current->mm);
 	if (ret)
@@ -357,12 +357,12 @@ nouveau_svmm_init(struct drm_device *dev
 
 	cli->svm.svmm = svmm;
 	cli->svm.cli = cli;
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 	mutex_unlock(&cli->mutex);
 	return 0;
 
 out_mm_unlock:
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 out_free:
 	mutex_unlock(&cli->mutex);
 	kfree(svmm);
@@ -564,9 +564,9 @@ static int nouveau_range_fault(struct no
 			return -EBUSY;
 
 		range.notifier_seq = mmu_interval_read_begin(range.notifier);
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		ret = hmm_range_fault(&range);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		if (ret) {
 			/*
 			 * FIXME: the input PFN_REQ flags are destroyed on
@@ -698,18 +698,18 @@ nouveau_svm_fault(struct nvif_notify *no
 		/* Intersect fault window with the CPU VMA, cancelling
 		 * the fault if the address is invalid.
 		 */
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		vma = find_vma_intersection(mm, start, limit);
 		if (!vma) {
 			SVMM_ERR(svmm, "wndw %016llx-%016llx", start, limit);
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 			mmput(mm);
 			nouveau_svm_fault_cancel_fault(svm, buffer->fault[fi]);
 			continue;
 		}
 		start = max_t(u64, start, vma->vm_start);
 		limit = min_t(u64, limit, vma->vm_end);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		SVMM_DBG(svmm, "wndw %016llx-%016llx", start, limit);
 
 		if (buffer->fault[fi]->addr != start) {
--- a/drivers/gpu/drm/radeon/radeon_cs.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/gpu/drm/radeon/radeon_cs.c
@@ -196,12 +196,12 @@ static int radeon_cs_parser_relocs(struc
 		p->vm_bos = radeon_vm_get_bos(p->rdev, p->ib.vm,
 					      &p->validated);
 	if (need_mmap_lock)
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 
 	r = radeon_bo_list_validate(p->rdev, &p->ticket, &p->validated, p->ring);
 
 	if (need_mmap_lock)
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 
 	return r;
 }
--- a/drivers/gpu/drm/radeon/radeon_gem.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/gpu/drm/radeon/radeon_gem.c
@@ -342,17 +342,17 @@ int radeon_gem_userptr_ioctl(struct drm_
 	}
 
 	if (args->flags & RADEON_GEM_USERPTR_VALIDATE) {
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		r = radeon_bo_reserve(bo, true);
 		if (r) {
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 			goto release_object;
 		}
 
 		radeon_ttm_placement_from_domain(bo, RADEON_GEM_DOMAIN_GTT);
 		r = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
 		radeon_bo_unreserve(bo);
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 		if (r)
 			goto release_object;
 	}
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -68,7 +68,7 @@ static vm_fault_t ttm_bo_vm_fault_idle(s
 			goto out_unlock;
 
 		ttm_bo_get(bo);
-		up_read(&vmf->vma->vm_mm->mmap_sem);
+		mmap_read_unlock(vmf->vma->vm_mm);
 		(void) dma_fence_wait(bo->moving, true);
 		dma_resv_unlock(bo->base.resv);
 		ttm_bo_put(bo);
@@ -144,7 +144,7 @@ vm_fault_t ttm_bo_vm_reserve(struct ttm_
 		if (fault_flag_allow_retry_first(vmf->flags)) {
 			if (!(vmf->flags & FAULT_FLAG_RETRY_NOWAIT)) {
 				ttm_bo_get(bo);
-				up_read(&vmf->vma->vm_mm->mmap_sem);
+				mmap_read_unlock(vmf->vma->vm_mm);
 				if (!dma_resv_lock_interruptible(bo->base.resv,
 								 NULL))
 					dma_resv_unlock(bo->base.resv);
--- a/drivers/infiniband/core/umem_odp.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/infiniband/core/umem_odp.c
@@ -429,7 +429,7 @@ int ib_umem_odp_map_dma_pages(struct ib_
 				ALIGN(bcnt, PAGE_SIZE) / PAGE_SIZE,
 				PAGE_SIZE / sizeof(struct page *));
 
-		down_read(&owning_mm->mmap_sem);
+		mmap_read_lock(owning_mm);
 		/*
 		 * Note: this might result in redundent page getting. We can
 		 * avoid this by checking dma_list to be 0 before calling
@@ -440,7 +440,7 @@ int ib_umem_odp_map_dma_pages(struct ib_
 		npages = get_user_pages_remote(owning_process, owning_mm,
 				user_virt, gup_num_pages,
 				flags, local_page_list, NULL, NULL);
-		up_read(&owning_mm->mmap_sem);
+		mmap_read_unlock(owning_mm);
 
 		if (npages < 0) {
 			if (npages != -EAGAIN)
--- a/drivers/infiniband/core/uverbs_main.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/infiniband/core/uverbs_main.c
@@ -840,7 +840,7 @@ void uverbs_user_mmap_disassociate(struc
 		 * at a time to get the lock ordering right. Typically there
 		 * will only be one mm, so no big deal.
 		 */
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		if (!mmget_still_valid(mm))
 			goto skip_mm;
 		mutex_lock(&ufile->umap_lock);
@@ -862,7 +862,7 @@ void uverbs_user_mmap_disassociate(struc
 		}
 		mutex_unlock(&ufile->umap_lock);
 	skip_mm:
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		mmput(mm);
 	}
 }
--- a/drivers/infiniband/hw/mlx4/mr.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/infiniband/hw/mlx4/mr.c
@@ -380,7 +380,7 @@ static struct ib_umem *mlx4_get_umem_mr(
 		unsigned long untagged_start = untagged_addr(start);
 		struct vm_area_struct *vma;
 
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		/*
 		 * FIXME: Ideally this would iterate over all the vmas that
 		 * cover the memory, but for now it requires a single vma to
@@ -395,7 +395,7 @@ static struct ib_umem *mlx4_get_umem_mr(
 			access_flags |= IB_ACCESS_LOCAL_WRITE;
 		}
 
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 	}
 
 	return ib_umem_get(device, start, length, access_flags);
--- a/drivers/infiniband/hw/qib/qib_user_pages.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -106,18 +106,18 @@ int qib_get_user_pages(unsigned long sta
 		goto bail;
 	}
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	for (got = 0; got < num_pages; got += ret) {
 		ret = pin_user_pages(start_page + got * PAGE_SIZE,
 				     num_pages - got,
 				     FOLL_LONGTERM | FOLL_WRITE | FOLL_FORCE,
 				     p + got, NULL);
 		if (ret < 0) {
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 			goto bail_release;
 		}
 	}
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	return 0;
 bail_release:
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -123,7 +123,7 @@ static int usnic_uiom_get_pages(unsigned
 	npages = PAGE_ALIGN(size + (addr & ~PAGE_MASK)) >> PAGE_SHIFT;
 
 	uiomr->owning_mm = mm = current->mm;
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	locked = atomic64_add_return(npages, &current->mm->pinned_vm);
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -187,7 +187,7 @@ out:
 	} else
 		mmgrab(uiomr->owning_mm);
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	free_page((unsigned long) page_list);
 	return ret;
 }
--- a/drivers/infiniband/sw/siw/siw_mem.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/infiniband/sw/siw/siw_mem.c
@@ -397,7 +397,7 @@ struct siw_umem *siw_umem_get(u64 start,
 	if (!writable)
 		foll_flags |= FOLL_FORCE;
 
-	down_read(&mm_s->mmap_sem);
+	mmap_read_lock(mm_s);
 
 	mlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
@@ -441,7 +441,7 @@ struct siw_umem *siw_umem_get(u64 start,
 		num_pages -= got;
 	}
 out_sem_up:
-	up_read(&mm_s->mmap_sem);
+	mmap_read_unlock(mm_s);
 
 	if (rv > 0)
 		return umem;
--- a/drivers/iommu/amd_iommu_v2.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/iommu/amd_iommu_v2.c
@@ -487,7 +487,7 @@ static void do_fault(struct work_struct
 		flags |= FAULT_FLAG_WRITE;
 	flags |= FAULT_FLAG_REMOTE;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_extend_vma(mm, address);
 	if (!vma || address < vma->vm_start)
 		/* failed to get a vma in the right range */
@@ -499,7 +499,7 @@ static void do_fault(struct work_struct
 
 	ret = handle_mm_fault(vma, address, flags);
 out:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	if (ret & VM_FAULT_ERROR)
 		/* failed to service fault */
--- a/drivers/iommu/intel-svm.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/iommu/intel-svm.c
@@ -620,7 +620,7 @@ static irqreturn_t prq_event_thread(int
 		if (!mmget_not_zero(svm->mm))
 			goto bad_req;
 
-		down_read(&svm->mm->mmap_sem);
+		mmap_read_lock(svm->mm);
 		vma = find_extend_vma(svm->mm, address);
 		if (!vma || address < vma->vm_start)
 			goto invalid;
@@ -635,7 +635,7 @@ static irqreturn_t prq_event_thread(int
 
 		result = QI_RESP_SUCCESS;
 	invalid:
-		up_read(&svm->mm->mmap_sem);
+		mmap_read_unlock(svm->mm);
 		mmput(svm->mm);
 	bad_req:
 		/* Accounting for major/minor faults? */
--- a/drivers/media/v4l2-core/videobuf-core.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/media/v4l2-core/videobuf-core.c
@@ -535,7 +535,7 @@ int videobuf_qbuf(struct videobuf_queue
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
 	if (b->memory == V4L2_MEMORY_MMAP)
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 
 	videobuf_queue_lock(q);
 	retval = -EBUSY;
@@ -622,7 +622,7 @@ done:
 	videobuf_queue_unlock(q);
 
 	if (b->memory == V4L2_MEMORY_MMAP)
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 
 	return retval;
 }
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -169,7 +169,7 @@ static int videobuf_dma_contig_user_get(
 	mem->size = PAGE_ALIGN(vb->size + offset);
 	ret = -EINVAL;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	vma = find_vma(mm, untagged_baddr);
 	if (!vma)
@@ -201,7 +201,7 @@ static int videobuf_dma_contig_user_get(
 	}
 
 out_up:
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	return ret;
 }
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -200,9 +200,9 @@ static int videobuf_dma_init_user(struct
 {
 	int ret;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	ret = videobuf_dma_init_user_locked(dma, direction, data, size);
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	return ret;
 }
--- a/drivers/misc/cxl/cxllib.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/misc/cxl/cxllib.c
@@ -207,7 +207,7 @@ static int get_vma_info(struct mm_struct
 	struct vm_area_struct *vma = NULL;
 	int rc = 0;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	vma = find_vma(mm, addr);
 	if (!vma) {
@@ -218,7 +218,7 @@ static int get_vma_info(struct mm_struct
 	*vma_start = vma->vm_start;
 	*vma_end = vma->vm_end;
 out:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return rc;
 }
 
--- a/drivers/misc/cxl/fault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/misc/cxl/fault.c
@@ -321,7 +321,7 @@ static void cxl_prefault_vma(struct cxl_
 		return;
 	}
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		for (ea = vma->vm_start; ea < vma->vm_end;
 				ea = next_segment(ea, slb.vsid)) {
@@ -336,7 +336,7 @@ static void cxl_prefault_vma(struct cxl_
 			last_esid = slb.esid;
 		}
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	mmput(mm);
 }
--- a/drivers/misc/sgi-gru/grufault.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -68,14 +68,14 @@ static struct gru_thread_state *gru_find
 	struct vm_area_struct *vma;
 	struct gru_thread_state *gts = NULL;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = gru_find_vma(vaddr);
 	if (vma)
 		gts = gru_find_thread_state(vma, TSID(vaddr, vma));
 	if (gts)
 		mutex_lock(&gts->ts_ctxlock);
 	else
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 	return gts;
 }
 
@@ -85,7 +85,7 @@ static struct gru_thread_state *gru_allo
 	struct vm_area_struct *vma;
 	struct gru_thread_state *gts = ERR_PTR(-EINVAL);
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	vma = gru_find_vma(vaddr);
 	if (!vma)
 		goto err;
@@ -94,11 +94,11 @@ static struct gru_thread_state *gru_allo
 	if (IS_ERR(gts))
 		goto err;
 	mutex_lock(&gts->ts_ctxlock);
-	downgrade_write(&mm->mmap_sem);
+	mmap_write_downgrade(mm);
 	return gts;
 
 err:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return gts;
 }
 
@@ -108,7 +108,7 @@ err:
 static void gru_unlock_gts(struct gru_thread_state *gts)
 {
 	mutex_unlock(&gts->ts_ctxlock);
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 }
 
 /*
@@ -574,9 +574,9 @@ static irqreturn_t gru_intr(int chiplet,
 		 */
 		gts->ustats.fmm_tlbmiss++;
 		if (!gts->ts_force_cch_reload &&
-					down_read_trylock(&gts->ts_mm->mmap_sem)) {
+					mmap_read_trylock(gts->ts_mm)) {
 			gru_try_dropin(gru, gts, tfh, NULL);
-			up_read(&gts->ts_mm->mmap_sem);
+			mmap_read_unlock(gts->ts_mm);
 		} else {
 			tfh_user_polling_mode(tfh);
 			STAT(intr_mm_lock_failed);
--- a/drivers/misc/sgi-gru/grufile.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -135,7 +135,7 @@ static int gru_create_new_context(unsign
 	if (!(req.options & GRU_OPT_MISS_MASK))
 		req.options |= GRU_OPT_MISS_FMM_INTR;
 
-	down_write(&current->mm->mmap_sem);
+	mmap_write_lock(current->mm);
 	vma = gru_find_vma(req.gseg);
 	if (vma) {
 		vdata = vma->vm_private_data;
@@ -146,7 +146,7 @@ static int gru_create_new_context(unsign
 		vdata->vd_tlb_preload_count = req.tlb_preload_count;
 		ret = 0;
 	}
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 
 	return ret;
 }
--- a/drivers/oprofile/buffer_sync.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/oprofile/buffer_sync.c
@@ -91,11 +91,11 @@ munmap_notify(struct notifier_block *sel
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *mpnt;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	mpnt = find_vma(mm, addr);
 	if (mpnt && mpnt->vm_file && (mpnt->vm_flags & VM_EXEC)) {
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		/* To avoid latency problems, we only process the current CPU,
 		 * hoping that most samples for the task are on this CPU
 		 */
@@ -103,7 +103,7 @@ munmap_notify(struct notifier_block *sel
 		return 0;
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return 0;
 }
 
@@ -256,7 +256,7 @@ lookup_dcookie(struct mm_struct *mm, uns
 	unsigned long cookie = NO_COOKIE;
 	struct vm_area_struct *vma;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	for (vma = find_vma(mm, addr); vma; vma = vma->vm_next) {
 
 		if (addr < vma->vm_start || addr >= vma->vm_end)
@@ -276,7 +276,7 @@ lookup_dcookie(struct mm_struct *mm, uns
 
 	if (!vma)
 		cookie = INVALID_COOKIE;
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	return cookie;
 }
--- a/drivers/staging/kpc2000/kpc_dma/fileops.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/staging/kpc2000/kpc_dma/fileops.c
@@ -75,9 +75,9 @@ static int kpc_dma_transfer(struct dev_p
 	}
 
 	// Lock the user buffer pages in memory, and hold on to the page pointers (for the sglist)
-	down_read(&current->mm->mmap_sem);      /*  get memory map semaphore */
+	mmap_read_lock(current->mm);      /*  get memory map semaphore */
 	rv = get_user_pages(iov_base, acd->page_count, FOLL_TOUCH | FOLL_WRITE | FOLL_GET, acd->user_pages, NULL);
-	up_read(&current->mm->mmap_sem);        /*  release the semaphore */
+	mmap_read_unlock(current->mm);        /*  release the semaphore */
 	if (rv != acd->page_count) {
 		dev_err(&priv->ldev->pldev->dev, "Couldn't get_user_pages (%ld)\n", rv);
 		goto err_get_user_pages;
--- a/drivers/tee/optee/call.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/tee/optee/call.c
@@ -561,10 +561,10 @@ static int check_mem_type(unsigned long
 	if (virt_addr_valid(start))
 		return 0;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	rc = __check_mem_type(find_vma(mm, start),
 			      start + num_pages * PAGE_SIZE);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	return rc;
 }
--- a/drivers/vfio/vfio_iommu_type1.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -278,11 +278,11 @@ static int vfio_lock_acct(struct vfio_dm
 	if (!mm)
 		return -ESRCH; /* process exited */
 
-	ret = down_write_killable(&mm->mmap_sem);
+	ret = mmap_write_lock_killable(mm);
 	if (!ret) {
 		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
 					  dma->lock_cap);
-		up_write(&mm->mmap_sem);
+		mmap_write_unlock(mm);
 	}
 
 	if (async)
@@ -328,7 +328,7 @@ static int vaddr_get_pfn(struct mm_struc
 	if (prot & IOMMU_WRITE)
 		flags |= FOLL_WRITE;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	ret = pin_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
 				    page, NULL, NULL);
 	if (ret == 1) {
@@ -347,7 +347,7 @@ static int vaddr_get_pfn(struct mm_struc
 			ret = 0;
 	}
 done:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return ret;
 }
 
--- a/drivers/vhost/vdpa.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/vhost/vdpa.c
@@ -527,7 +527,7 @@ static int vhost_vdpa_process_iotlb_upda
 	if (!npages)
 		return -EINVAL;
 
-	down_read(&dev->mm->mmap_sem);
+	mmap_read_lock(dev->mm);
 
 	locked = atomic64_add_return(npages, &dev->mm->pinned_vm);
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -580,7 +580,7 @@ out:
 		vhost_vdpa_unmap(v, msg->iova, msg->size);
 		atomic64_sub(npages, &dev->mm->pinned_vm);
 	}
-	up_read(&dev->mm->mmap_sem);
+	mmap_read_unlock(dev->mm);
 	free_page((unsigned long)page_list);
 	return ret;
 }
--- a/drivers/xen/gntdev.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/xen/gntdev.c
@@ -625,7 +625,7 @@ static long gntdev_ioctl_get_offset_for_
 		return -EFAULT;
 	pr_debug("priv %p, offset for vaddr %lx\n", priv, (unsigned long)op.vaddr);
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	vma = find_vma(current->mm, op.vaddr);
 	if (!vma || vma->vm_ops != &gntdev_vmops)
 		goto out_unlock;
@@ -639,7 +639,7 @@ static long gntdev_ioctl_get_offset_for_
 	rv = 0;
 
  out_unlock:
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	if (rv == 0 && copy_to_user(u, &op, sizeof(op)) != 0)
 		return -EFAULT;
--- a/drivers/xen/privcmd.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/drivers/xen/privcmd.c
@@ -276,7 +276,7 @@ static long privcmd_ioctl_mmap(struct fi
 	if (rc || list_empty(&pagelist))
 		goto out;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 
 	{
 		struct page *page = list_first_entry(&pagelist,
@@ -301,7 +301,7 @@ static long privcmd_ioctl_mmap(struct fi
 
 
 out_up:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 
 out:
 	free_page_list(&pagelist);
@@ -497,7 +497,7 @@ static long privcmd_ioctl_mmap_batch(
 		}
 	}
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 
 	vma = find_vma(mm, m.addr);
 	if (!vma ||
@@ -553,7 +553,7 @@ static long privcmd_ioctl_mmap_batch(
 	BUG_ON(traverse_pages_block(m.num, sizeof(xen_pfn_t),
 				    &pagelist, mmap_batch_fn, &state));
 
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 
 	if (state.global_error) {
 		/* Write back errors in second pass. */
@@ -574,7 +574,7 @@ out:
 	return ret;
 
 out_unlock:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	goto out;
 }
 
@@ -739,7 +739,7 @@ static long privcmd_ioctl_mmap_resource(
 	if (data->domid != DOMID_INVALID && data->domid != kdata.dom)
 		return -EPERM;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 
 	vma = find_vma(mm, kdata.addr);
 	if (!vma || vma->vm_ops != &privcmd_vm_ops) {
@@ -818,7 +818,7 @@ static long privcmd_ioctl_mmap_resource(
 	}
 
 out:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	kfree(pfns);
 
 	return rc;
--- a/fs/aio.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/fs/aio.c
@@ -519,7 +519,7 @@ static int aio_setup_ring(struct kioctx
 	ctx->mmap_size = nr_pages * PAGE_SIZE;
 	pr_debug("attempting mmap of %lu bytes\n", ctx->mmap_size);
 
-	if (down_write_killable(&mm->mmap_sem)) {
+	if (mmap_write_lock_killable(mm)) {
 		ctx->mmap_size = 0;
 		aio_free_ring(ctx);
 		return -EINTR;
@@ -528,7 +528,7 @@ static int aio_setup_ring(struct kioctx
 	ctx->mmap_base = do_mmap_pgoff(ctx->aio_ring_file, 0, ctx->mmap_size,
 				       PROT_READ | PROT_WRITE,
 				       MAP_SHARED, 0, &unused, NULL);
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	if (IS_ERR((void *)ctx->mmap_base)) {
 		ctx->mmap_size = 0;
 		aio_free_ring(ctx);
--- a/fs/coredump.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/fs/coredump.c
@@ -445,12 +445,12 @@ static int coredump_wait(int exit_code,
 	core_state->dumper.task = tsk;
 	core_state->dumper.next = NULL;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	if (!mm->core_state)
 		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 
 	if (core_waiters > 0) {
 		struct core_thread *ptr;
--- a/fs/exec.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/fs/exec.c
@@ -252,7 +252,7 @@ static int __bprm_mm_init(struct linux_b
 		return -ENOMEM;
 	vma_set_anonymous(vma);
 
-	if (down_write_killable(&mm->mmap_sem)) {
+	if (mmap_write_lock_killable(mm)) {
 		err = -EINTR;
 		goto err_free;
 	}
@@ -274,11 +274,11 @@ static int __bprm_mm_init(struct linux_b
 		goto err;
 
 	mm->stack_vm = mm->total_vm = 1;
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	bprm->p = vma->vm_end - sizeof(void *);
 	return 0;
 err:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 err_free:
 	bprm->vma = NULL;
 	vm_area_free(vma);
@@ -763,7 +763,7 @@ int setup_arg_pages(struct linux_binprm
 		bprm->loader -= stack_shift;
 	bprm->exec -= stack_shift;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	vm_flags = VM_STACK_FLAGS;
@@ -825,7 +825,7 @@ int setup_arg_pages(struct linux_binprm
 		ret = -EFAULT;
 
 out_unlock:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 EXPORT_SYMBOL(setup_arg_pages);
@@ -1097,9 +1097,9 @@ static int exec_mmap(struct mm_struct *m
 		 * through with the exec.  We must hold mmap_sem around
 		 * checking core_state and changing tsk->mm.
 		 */
-		down_read(&old_mm->mmap_sem);
+		mmap_read_lock(old_mm);
 		if (unlikely(old_mm->core_state)) {
-			up_read(&old_mm->mmap_sem);
+			mmap_read_unlock(old_mm);
 			mutex_unlock(&tsk->signal->exec_update_mutex);
 			return -EINTR;
 		}
@@ -1115,7 +1115,7 @@ static int exec_mmap(struct mm_struct *m
 	vmacache_flush(tsk);
 	task_unlock(tsk);
 	if (old_mm) {
-		up_read(&old_mm->mmap_sem);
+		mmap_read_unlock(old_mm);
 		BUG_ON(active_mm != old_mm);
 		setmax_mm_hiwater_rss(&tsk->signal->maxrss, old_mm);
 		mm_update_next_owner(old_mm);
--- a/fs/io_uring.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/fs/io_uring.c
@@ -7261,7 +7261,7 @@ static int io_sqe_buffer_register(struct
 		}
 
 		ret = 0;
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		pret = pin_user_pages(ubuf, nr_pages,
 				      FOLL_WRITE | FOLL_LONGTERM,
 				      pages, vmas);
@@ -7279,7 +7279,7 @@ static int io_sqe_buffer_register(struct
 		} else {
 			ret = pret < 0 ? pret : -EFAULT;
 		}
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 		if (ret) {
 			/*
 			 * if we did partial map, or found file backed vmas,
--- a/fs/proc/base.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/fs/proc/base.c
@@ -2112,11 +2112,11 @@ static int map_files_d_revalidate(struct
 		goto out;
 
 	if (!dname_to_vma_addr(dentry, &vm_start, &vm_end)) {
-		status = down_read_killable(&mm->mmap_sem);
+		status = mmap_read_lock_killable(mm);
 		if (!status) {
 			exact_vma_exists = !!find_exact_vma(mm, vm_start,
 							    vm_end);
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 		}
 	}
 
@@ -2163,7 +2163,7 @@ static int map_files_get_link(struct den
 	if (rc)
 		goto out_mmput;
 
-	rc = down_read_killable(&mm->mmap_sem);
+	rc = mmap_read_lock_killable(mm);
 	if (rc)
 		goto out_mmput;
 
@@ -2174,7 +2174,7 @@ static int map_files_get_link(struct den
 		path_get(path);
 		rc = 0;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 out_mmput:
 	mmput(mm);
@@ -2264,7 +2264,7 @@ static struct dentry *proc_map_files_loo
 		goto out_put_task;
 
 	result = ERR_PTR(-EINTR);
-	if (down_read_killable(&mm->mmap_sem))
+	if (mmap_read_lock_killable(mm))
 		goto out_put_mm;
 
 	result = ERR_PTR(-ENOENT);
@@ -2277,7 +2277,7 @@ static struct dentry *proc_map_files_loo
 				(void *)(unsigned long)vma->vm_file->f_mode);
 
 out_no_vma:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 out_put_mm:
 	mmput(mm);
 out_put_task:
--- a/fs/proc/task_mmu.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/fs/proc/task_mmu.c
@@ -145,7 +145,7 @@ static void *m_start(struct seq_file *m,
 		return NULL;
 	}
 
-	if (down_read_killable(&mm->mmap_sem)) {
+	if (mmap_read_lock_killable(mm)) {
 		mmput(mm);
 		put_task_struct(priv->task);
 		priv->task = NULL;
@@ -188,7 +188,7 @@ static void m_stop(struct seq_file *m, v
 		return;
 
 	release_task_mempolicy(priv);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 	put_task_struct(priv->task);
 	priv->task = NULL;
@@ -847,7 +847,7 @@ static int show_smaps_rollup(struct seq_
 
 	memset(&mss, 0, sizeof(mss));
 
-	ret = down_read_killable(&mm->mmap_sem);
+	ret = mmap_read_lock_killable(mm);
 	if (ret)
 		goto out_put_mm;
 
@@ -866,7 +866,7 @@ static int show_smaps_rollup(struct seq_
 	__show_smap(m, &mss, true);
 
 	release_task_mempolicy(priv);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 out_put_mm:
 	mmput(mm);
@@ -1140,7 +1140,7 @@ static ssize_t clear_refs_write(struct f
 		};
 
 		if (type == CLEAR_REFS_MM_HIWATER_RSS) {
-			if (down_write_killable(&mm->mmap_sem)) {
+			if (mmap_write_lock_killable(mm)) {
 				count = -EINTR;
 				goto out_mm;
 			}
@@ -1150,11 +1150,11 @@ static ssize_t clear_refs_write(struct f
 			 * resident set size to this mm's current rss value.
 			 */
 			reset_mm_hiwater_rss(mm);
-			up_write(&mm->mmap_sem);
+			mmap_write_unlock(mm);
 			goto out_mm;
 		}
 
-		if (down_read_killable(&mm->mmap_sem)) {
+		if (mmap_read_lock_killable(mm)) {
 			count = -EINTR;
 			goto out_mm;
 		}
@@ -1163,8 +1163,8 @@ static ssize_t clear_refs_write(struct f
 			for (vma = mm->mmap; vma; vma = vma->vm_next) {
 				if (!(vma->vm_flags & VM_SOFTDIRTY))
 					continue;
-				up_read(&mm->mmap_sem);
-				if (down_write_killable(&mm->mmap_sem)) {
+				mmap_read_unlock(mm);
+				if (mmap_write_lock_killable(mm)) {
 					count = -EINTR;
 					goto out_mm;
 				}
@@ -1183,14 +1183,14 @@ static ssize_t clear_refs_write(struct f
 					 * failed like if
 					 * get_proc_task() fails?
 					 */
-					up_write(&mm->mmap_sem);
+					mmap_write_unlock(mm);
 					goto out_mm;
 				}
 				for (vma = mm->mmap; vma; vma = vma->vm_next) {
 					vma->vm_flags &= ~VM_SOFTDIRTY;
 					vma_set_page_prot(vma);
 				}
-				downgrade_write(&mm->mmap_sem);
+				mmap_write_downgrade(mm);
 				break;
 			}
 
@@ -1203,7 +1203,7 @@ static ssize_t clear_refs_write(struct f
 		if (type == CLEAR_REFS_SOFT_DIRTY)
 			mmu_notifier_invalidate_range_end(&range);
 		tlb_finish_mmu(&tlb, 0, -1);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 out_mm:
 		mmput(mm);
 	}
@@ -1564,11 +1564,11 @@ static ssize_t pagemap_read(struct file
 		/* overflow ? */
 		if (end < start_vaddr || end > end_vaddr)
 			end = end_vaddr;
-		ret = down_read_killable(&mm->mmap_sem);
+		ret = mmap_read_lock_killable(mm);
 		if (ret)
 			goto out_free;
 		ret = walk_page_range(mm, start_vaddr, end, &pagemap_ops, &pm);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		start_vaddr = end;
 
 		len = min(count, PM_ENTRY_BYTES * pm.pos);
--- a/fs/proc/task_nommu.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/fs/proc/task_nommu.c
@@ -25,7 +25,7 @@ void task_mem(struct seq_file *m, struct
 	struct rb_node *p;
 	unsigned long bytes = 0, sbytes = 0, slack = 0, size;
         
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
 		vma = rb_entry(p, struct vm_area_struct, vm_rb);
 
@@ -77,7 +77,7 @@ void task_mem(struct seq_file *m, struct
 		"Shared:\t%8lu bytes\n",
 		bytes, slack, sbytes);
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 }
 
 unsigned long task_vsize(struct mm_struct *mm)
@@ -86,12 +86,12 @@ unsigned long task_vsize(struct mm_struc
 	struct rb_node *p;
 	unsigned long vsize = 0;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
 		vma = rb_entry(p, struct vm_area_struct, vm_rb);
 		vsize += vma->vm_end - vma->vm_start;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return vsize;
 }
 
@@ -104,7 +104,7 @@ unsigned long task_statm(struct mm_struc
 	struct rb_node *p;
 	unsigned long size = kobjsize(mm);
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
 		vma = rb_entry(p, struct vm_area_struct, vm_rb);
 		size += kobjsize(vma);
@@ -119,7 +119,7 @@ unsigned long task_statm(struct mm_struc
 		>> PAGE_SHIFT;
 	*data = (PAGE_ALIGN(mm->start_stack) - (mm->start_data & PAGE_MASK))
 		>> PAGE_SHIFT;
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	size >>= PAGE_SHIFT;
 	size += *text + *data;
 	*resident = size;
@@ -211,7 +211,7 @@ static void *m_start(struct seq_file *m,
 	if (!mm || !mmget_not_zero(mm))
 		return NULL;
 
-	if (down_read_killable(&mm->mmap_sem)) {
+	if (mmap_read_lock_killable(mm)) {
 		mmput(mm);
 		return ERR_PTR(-EINTR);
 	}
@@ -221,7 +221,7 @@ static void *m_start(struct seq_file *m,
 		if (n-- == 0)
 			return p;
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 	return NULL;
 }
@@ -231,7 +231,7 @@ static void m_stop(struct seq_file *m, v
 	struct proc_maps_private *priv = m->private;
 
 	if (!IS_ERR_OR_NULL(_vml)) {
-		up_read(&priv->mm->mmap_sem);
+		mmap_read_unlock(priv->mm);
 		mmput(priv->mm);
 	}
 	if (priv->task) {
--- a/fs/userfaultfd.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/fs/userfaultfd.c
@@ -514,7 +514,7 @@ vm_fault_t handle_userfault(struct vm_fa
 		must_wait = userfaultfd_huge_must_wait(ctx, vmf->vma,
 						       vmf->address,
 						       vmf->flags, reason);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	if (likely(must_wait && !READ_ONCE(ctx->released) &&
 		   !userfaultfd_signal_pending(vmf->flags))) {
@@ -637,7 +637,7 @@ static void userfaultfd_event_wait_compl
 		struct mm_struct *mm = release_new_ctx->mm;
 
 		/* the various vma->vm_userfaultfd_ctx still points to it */
-		down_write(&mm->mmap_sem);
+		mmap_write_lock(mm);
 		/* no task can run (and in turn coredump) yet */
 		VM_WARN_ON(!mmget_still_valid(mm));
 		for (vma = mm->mmap; vma; vma = vma->vm_next)
@@ -645,7 +645,7 @@ static void userfaultfd_event_wait_compl
 				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 				vma->vm_flags &= ~(VM_UFFD_WP | VM_UFFD_MISSING);
 			}
-		up_write(&mm->mmap_sem);
+		mmap_write_unlock(mm);
 
 		userfaultfd_ctx_put(release_new_ctx);
 	}
@@ -799,7 +799,7 @@ bool userfaultfd_remove(struct vm_area_s
 
 	userfaultfd_ctx_get(ctx);
 	WRITE_ONCE(ctx->mmap_changing, true);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	msg_init(&ewq.msg);
 
@@ -894,7 +894,7 @@ static int userfaultfd_release(struct in
 	 * it's critical that released is set to true (above), before
 	 * taking the mmap_sem for writing.
 	 */
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	still_valid = mmget_still_valid(mm);
 	prev = NULL;
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
@@ -920,7 +920,7 @@ static int userfaultfd_release(struct in
 		vma->vm_flags = new_flags;
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 	}
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	mmput(mm);
 wakeup:
 	/*
@@ -1345,7 +1345,7 @@ static int userfaultfd_register(struct u
 	if (!mmget_not_zero(mm))
 		goto out;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	if (!mmget_still_valid(mm))
 		goto out_unlock;
 	vma = find_vma_prev(mm, start, &prev);
@@ -1492,7 +1492,7 @@ static int userfaultfd_register(struct u
 		vma = vma->vm_next;
 	} while (vma && vma->vm_start < end);
 out_unlock:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	mmput(mm);
 	if (!ret) {
 		__u64 ioctls_out;
@@ -1547,7 +1547,7 @@ static int userfaultfd_unregister(struct
 	if (!mmget_not_zero(mm))
 		goto out;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	if (!mmget_still_valid(mm))
 		goto out_unlock;
 	vma = find_vma_prev(mm, start, &prev);
@@ -1664,7 +1664,7 @@ static int userfaultfd_unregister(struct
 		vma = vma->vm_next;
 	} while (vma && vma->vm_start < end);
 out_unlock:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	mmput(mm);
 out:
 	return ret;
--- a/ipc/shm.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/ipc/shm.c
@@ -1530,7 +1530,7 @@ long do_shmat(int shmid, char __user *sh
 	if (err)
 		goto out_fput;
 
-	if (down_write_killable(&current->mm->mmap_sem)) {
+	if (mmap_write_lock_killable(current->mm)) {
 		err = -EINTR;
 		goto out_fput;
 	}
@@ -1550,7 +1550,7 @@ long do_shmat(int shmid, char __user *sh
 	if (IS_ERR_VALUE(addr))
 		err = (long)addr;
 invalid:
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 	if (populate)
 		mm_populate(addr, populate);
 
@@ -1624,7 +1624,7 @@ long ksys_shmdt(char __user *shmaddr)
 	if (addr & ~PAGE_MASK)
 		return retval;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	/*
@@ -1712,7 +1712,7 @@ long ksys_shmdt(char __user *shmaddr)
 
 #endif
 
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return retval;
 }
 
--- a/kernel/acct.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/kernel/acct.c
@@ -541,13 +541,13 @@ void acct_collect(long exitcode, int gro
 	if (group_dead && current->mm) {
 		struct vm_area_struct *vma;
 
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		vma = current->mm->mmap;
 		while (vma) {
 			vsize += vma->vm_end - vma->vm_start;
 			vma = vma->vm_next;
 		}
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 	}
 
 	spin_lock_irq(&current->sighand->siglock);
--- a/kernel/bpf/stackmap.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/kernel/bpf/stackmap.c
@@ -317,7 +317,7 @@ static void stack_map_get_build_id_offse
 	 * with build_id.
 	 */
 	if (!user || !current || !current->mm || irq_work_busy ||
-	    down_read_trylock(&current->mm->mmap_sem) == 0) {
+	    mmap_read_trylock(current->mm) == 0) {
 		/* cannot access current->mm, fall back to ips */
 		for (i = 0; i < trace_nr; i++) {
 			id_offs[i].status = BPF_STACK_BUILD_ID_IP;
@@ -342,7 +342,7 @@ static void stack_map_get_build_id_offse
 	}
 
 	if (!work) {
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 	} else {
 		work->sem = &current->mm->mmap_sem;
 		irq_work_queue(&work->irq_work);
--- a/kernel/events/core.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/kernel/events/core.c
@@ -9784,7 +9784,7 @@ static void perf_event_addr_filters_appl
 		if (!mm)
 			goto restart;
 
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	}
 
 	raw_spin_lock_irqsave(&ifh->lock, flags);
@@ -9810,7 +9810,7 @@ static void perf_event_addr_filters_appl
 	raw_spin_unlock_irqrestore(&ifh->lock, flags);
 
 	if (ifh->nr_file_filters) {
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 
 		mmput(mm);
 	}
--- a/kernel/events/uprobes.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/kernel/events/uprobes.c
@@ -1058,7 +1058,7 @@ register_for_each_vma(struct uprobe *upr
 		if (err && is_register)
 			goto free;
 
-		down_write(&mm->mmap_sem);
+		mmap_write_lock(mm);
 		vma = find_vma(mm, info->vaddr);
 		if (!vma || !valid_vma(vma, is_register) ||
 		    file_inode(vma->vm_file) != uprobe->inode)
@@ -1080,7 +1080,7 @@ register_for_each_vma(struct uprobe *upr
 		}
 
  unlock:
-		up_write(&mm->mmap_sem);
+		mmap_write_unlock(mm);
  free:
 		mmput(mm);
 		info = free_map_info(info);
@@ -1235,7 +1235,7 @@ static int unapply_uprobe(struct uprobe
 	struct vm_area_struct *vma;
 	int err = 0;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		unsigned long vaddr;
 		loff_t offset;
@@ -1252,7 +1252,7 @@ static int unapply_uprobe(struct uprobe
 		vaddr = offset_to_vaddr(vma, uprobe->offset);
 		err |= remove_breakpoint(uprobe, mm, vaddr);
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	return err;
 }
@@ -1439,7 +1439,7 @@ static int xol_add_vma(struct mm_struct
 	struct vm_area_struct *vma;
 	int ret;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	if (mm->uprobes_state.xol_area) {
@@ -1469,7 +1469,7 @@ static int xol_add_vma(struct mm_struct
 	/* pairs with get_xol_area() */
 	smp_store_release(&mm->uprobes_state.xol_area, area); /* ^^^ */
  fail:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 
 	return ret;
 }
@@ -2039,7 +2039,7 @@ static struct uprobe *find_active_uprobe
 	struct uprobe *uprobe = NULL;
 	struct vm_area_struct *vma;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, bp_vaddr);
 	if (vma && vma->vm_start <= bp_vaddr) {
 		if (valid_vma(vma, false)) {
@@ -2057,7 +2057,7 @@ static struct uprobe *find_active_uprobe
 
 	if (!uprobe && test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags))
 		mmf_recalc_uprobes(mm);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	return uprobe;
 }
--- a/kernel/exit.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/kernel/exit.c
@@ -445,12 +445,12 @@ static void exit_mm(void)
 	 * will increment ->nr_threads for each thread in the
 	 * group with ->mm != NULL.
 	 */
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	core_state = mm->core_state;
 	if (core_state) {
 		struct core_thread self;
 
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 
 		self.task = current;
 		self.next = xchg(&core_state->dumper.next, &self);
@@ -468,14 +468,14 @@ static void exit_mm(void)
 			freezable_schedule();
 		}
 		__set_current_state(TASK_RUNNING);
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 	}
 	mmgrab(mm);
 	BUG_ON(mm != current->active_mm);
 	/* more a memory barrier than a real lock */
 	task_lock(current);
 	current->mm = NULL;
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	enter_lazy_tlb(mm, current);
 	task_unlock(current);
 	mm_update_next_owner(mm);
--- a/kernel/fork.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/kernel/fork.c
@@ -495,7 +495,7 @@ static __latent_entropy int dup_mmap(str
 	LIST_HEAD(uf);
 
 	uprobe_start_dup_mmap();
-	if (down_write_killable(&oldmm->mmap_sem)) {
+	if (mmap_write_lock_killable(oldmm)) {
 		retval = -EINTR;
 		goto fail_uprobe_end;
 	}
@@ -620,9 +620,9 @@ static __latent_entropy int dup_mmap(str
 	/* a new mm has just been created */
 	retval = arch_dup_mmap(oldmm, mm);
 out:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
-	up_write(&oldmm->mmap_sem);
+	mmap_write_unlock(oldmm);
 	dup_userfaultfd_complete(&uf);
 fail_uprobe_end:
 	uprobe_end_dup_mmap();
@@ -652,9 +652,9 @@ static inline void mm_free_pgd(struct mm
 #else
 static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	down_write(&oldmm->mmap_sem);
+	mmap_write_lock(oldmm);
 	RCU_INIT_POINTER(mm->exe_file, get_mm_exe_file(oldmm));
-	up_write(&oldmm->mmap_sem);
+	mmap_write_unlock(oldmm);
 	return 0;
 }
 #define mm_alloc_pgd(mm)	(0)
@@ -1019,7 +1019,7 @@ static struct mm_struct *mm_init(struct
 	mm->vmacache_seqnum = 0;
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
-	init_rwsem(&mm->mmap_sem);
+	mmap_init_lock(mm);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->core_state = NULL;
 	mm_pgtables_bytes_init(mm);
--- a/kernel/futex.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/kernel/futex.c
@@ -698,10 +698,10 @@ static int fault_in_user_writeable(u32 _
 	struct mm_struct *mm = current->mm;
 	int ret;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	ret = fixup_user_fault(current, mm, (unsigned long)uaddr,
 			       FAULT_FLAG_WRITE, NULL);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	return ret < 0 ? ret : 0;
 }
--- a/kernel/sched/fair.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/kernel/sched/fair.c
@@ -2770,7 +2770,7 @@ static void task_numa_work(struct callba
 		return;
 
 
-	if (!down_read_trylock(&mm->mmap_sem))
+	if (!mmap_read_trylock(mm))
 		return;
 	vma = find_vma(mm, start);
 	if (!vma) {
@@ -2838,7 +2838,7 @@ out:
 		mm->numa_scan_offset = start;
 	else
 		reset_ptenuma_scan(p);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/*
 	 * Make sure tasks use at least 32x as much time to run other code
--- a/kernel/sys.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/kernel/sys.c
@@ -1846,7 +1846,7 @@ static int prctl_set_mm_exe_file(struct
 	if (exe_file) {
 		struct vm_area_struct *vma;
 
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		for (vma = mm->mmap; vma; vma = vma->vm_next) {
 			if (!vma->vm_file)
 				continue;
@@ -1855,7 +1855,7 @@ static int prctl_set_mm_exe_file(struct
 				goto exit_err;
 		}
 
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		fput(exe_file);
 	}
 
@@ -1869,7 +1869,7 @@ exit:
 	fdput(exe);
 	return err;
 exit_err:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	fput(exe_file);
 	goto exit;
 }
@@ -2010,7 +2010,7 @@ static int prctl_set_mm_map(int opt, con
 	 * arg_lock protects concurent updates but we still need mmap_sem for
 	 * read to exclude races with sys_brk.
 	 */
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	/*
 	 * We don't validate if these members are pointing to
@@ -2049,7 +2049,7 @@ static int prctl_set_mm_map(int opt, con
 	if (prctl_map.auxv_size)
 		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return 0;
 }
 #endif /* CONFIG_CHECKPOINT_RESTORE */
@@ -2125,7 +2125,7 @@ static int prctl_set_mm(int opt, unsigne
 	 * mmap_sem for a) concurrent sys_brk, b) finding VMA for addr
 	 * validation.
 	 */
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, addr);
 
 	spin_lock(&mm->arg_lock);
@@ -2217,7 +2217,7 @@ static int prctl_set_mm(int opt, unsigne
 	error = 0;
 out:
 	spin_unlock(&mm->arg_lock);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return error;
 }
 
@@ -2442,13 +2442,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 	case PR_SET_THP_DISABLE:
 		if (arg3 || arg4 || arg5)
 			return -EINVAL;
-		if (down_write_killable(&me->mm->mmap_sem))
+		if (mmap_write_lock_killable(me->mm))
 			return -EINTR;
 		if (arg2)
 			set_bit(MMF_DISABLE_THP, &me->mm->flags);
 		else
 			clear_bit(MMF_DISABLE_THP, &me->mm->flags);
-		up_write(&me->mm->mmap_sem);
+		mmap_write_unlock(me->mm);
 		break;
 	case PR_MPX_ENABLE_MANAGEMENT:
 	case PR_MPX_DISABLE_MANAGEMENT:
--- a/kernel/trace/trace_output.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/kernel/trace/trace_output.c
@@ -393,7 +393,7 @@ static int seq_print_user_ip(struct trac
 	if (mm) {
 		const struct vm_area_struct *vma;
 
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		vma = find_vma(mm, ip);
 		if (vma) {
 			file = vma->vm_file;
@@ -405,7 +405,7 @@ static int seq_print_user_ip(struct trac
 				trace_seq_printf(s, "[+0x%lx]",
 						 ip - vmstart);
 		}
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 	}
 	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
 		trace_seq_printf(s, " <" IP_FMT ">", ip);
--- a/lib/test_lockup.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/lib/test_lockup.c
@@ -193,9 +193,9 @@ static void test_lock(bool master, bool
 		if (verbose)
 			pr_notice("lock mmap_sem pid=%d\n", main_task->pid);
 		if (lock_read)
-			down_read(&main_task->mm->mmap_sem);
+			mmap_read_lock(main_task->mm);
 		else
-			down_write(&main_task->mm->mmap_sem);
+			mmap_write_lock(main_task->mm);
 	}
 
 	if (test_disable_irq)
@@ -276,9 +276,9 @@ static void test_unlock(bool master, boo
 
 	if (lock_mmap_sem && master) {
 		if (lock_read)
-			up_read(&main_task->mm->mmap_sem);
+			mmap_read_unlock(main_task->mm);
 		else
-			up_write(&main_task->mm->mmap_sem);
+			mmap_write_unlock(main_task->mm);
 		if (verbose)
 			pr_notice("unlock mmap_sem pid=%d\n", main_task->pid);
 	}
--- a/mm/filemap.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/filemap.c
@@ -1391,7 +1391,7 @@ int __lock_page_or_retry(struct page *pa
 		if (flags & FAULT_FLAG_RETRY_NOWAIT)
 			return 0;
 
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		if (flags & FAULT_FLAG_KILLABLE)
 			wait_on_page_locked_killable(page);
 		else
@@ -1403,7 +1403,7 @@ int __lock_page_or_retry(struct page *pa
 
 			ret = __lock_page_killable(page);
 			if (ret) {
-				up_read(&mm->mmap_sem);
+				mmap_read_unlock(mm);
 				return 0;
 			}
 		} else
@@ -2346,7 +2346,7 @@ static int lock_page_maybe_drop_mmap(str
 			 * mmap_sem here and return 0 if we don't have a fpin.
 			 */
 			if (*fpin == NULL)
-				up_read(&vmf->vma->vm_mm->mmap_sem);
+				mmap_read_unlock(vmf->vma->vm_mm);
 			return 0;
 		}
 	} else
--- a/mm/frame_vector.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/frame_vector.c
@@ -48,7 +48,7 @@ int get_vaddr_frames(unsigned long start
 
 	start = untagged_addr(start);
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	locked = 1;
 	vma = find_vma_intersection(mm, start, start + 1);
 	if (!vma) {
@@ -102,7 +102,7 @@ int get_vaddr_frames(unsigned long start
 	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
 out:
 	if (locked)
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 	if (!ret)
 		ret = -EFAULT;
 	if (ret > 0)
--- a/mm/gup.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/gup.c
@@ -1234,7 +1234,7 @@ retry:
 	}
 
 	if (ret & VM_FAULT_RETRY) {
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		*unlocked = true;
 		fault_flags |= FAULT_FLAG_TRIED;
 		goto retry;
@@ -1339,7 +1339,7 @@ retry:
 			break;
 		}
 
-		ret = down_read_killable(&mm->mmap_sem);
+		ret = mmap_read_lock_killable(mm);
 		if (ret) {
 			BUG_ON(ret > 0);
 			if (!pages_done)
@@ -1374,7 +1374,7 @@ retry:
 		 * We must let the caller know we temporarily dropped the lock
 		 * and so the critical section protected by it was lost.
 		 */
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		*locked = 0;
 	}
 	return pages_done;
@@ -1462,7 +1462,7 @@ int __mm_populate(unsigned long start, u
 		 */
 		if (!locked) {
 			locked = 1;
-			down_read(&mm->mmap_sem);
+			mmap_read_lock(mm);
 			vma = find_vma(mm, nstart);
 		} else if (nstart >= vma->vm_end)
 			vma = vma->vm_next;
@@ -1494,7 +1494,7 @@ int __mm_populate(unsigned long start, u
 		ret = 0;
 	}
 	if (locked)
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 	return ret;	/* 0 or negative error code */
 }
 
@@ -2057,11 +2057,11 @@ long get_user_pages_unlocked(unsigned lo
 	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
 		return -EINVAL;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	ret = __get_user_pages_locked(current, mm, start, nr_pages, pages, NULL,
 				      &locked, gup_flags | FOLL_TOUCH);
 	if (locked)
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 	return ret;
 }
 EXPORT_SYMBOL(get_user_pages_unlocked);
@@ -2702,11 +2702,11 @@ static int __gup_longterm_unlocked(unsig
 	 * get_user_pages_unlocked() (see comments in that function)
 	 */
 	if (gup_flags & FOLL_LONGTERM) {
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		ret = __gup_longterm_locked(current, current->mm,
 					    start, nr_pages,
 					    pages, NULL, gup_flags);
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 	} else {
 		ret = get_user_pages_unlocked(start, nr_pages,
 					      pages, gup_flags);
--- a/mm/internal.h~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/internal.h
@@ -419,7 +419,7 @@ static inline struct file *maybe_unlock_
 	if (fault_flag_allow_retry_first(flags) &&
 	    !(flags & FAULT_FLAG_RETRY_NOWAIT)) {
 		fpin = get_file(vmf->vma->vm_file);
-		up_read(&vmf->vma->vm_mm->mmap_sem);
+		mmap_read_unlock(vmf->vma->vm_mm);
 	}
 	return fpin;
 }
--- a/mm/khugepaged.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/khugepaged.c
@@ -536,8 +536,8 @@ void __khugepaged_exit(struct mm_struct
 		 * khugepaged has finished working on the pagetables
 		 * under the mmap_sem.
 		 */
-		down_write(&mm->mmap_sem);
-		up_write(&mm->mmap_sem);
+		mmap_write_lock(mm);
+		mmap_write_unlock(mm);
 	}
 }
 
@@ -996,7 +996,7 @@ static bool __collapse_huge_page_swapin(
 
 		/* do_swap_page returns VM_FAULT_RETRY with released mmap_sem */
 		if (ret & VM_FAULT_RETRY) {
-			down_read(&mm->mmap_sem);
+			mmap_read_lock(mm);
 			if (hugepage_vma_revalidate(mm, address, &vmf.vma)) {
 				/* vma is no longer available, don't continue to swapin */
 				trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
@@ -1053,7 +1053,7 @@ static void collapse_huge_page(struct mm
 	 * sync compaction, and we do not need to hold the mmap_sem during
 	 * that. We will recheck the vma after taking it again in write mode.
 	 */
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	new_page = khugepaged_alloc_page(hpage, gfp, node);
 	if (!new_page) {
 		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
@@ -1066,17 +1066,17 @@ static void collapse_huge_page(struct mm
 	}
 	count_memcg_page_event(new_page, THP_COLLAPSE_ALLOC);
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result) {
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		goto out_nolock;
 	}
 
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd) {
 		result = SCAN_PMD_NULL;
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		goto out_nolock;
 	}
 
@@ -1087,17 +1087,17 @@ static void collapse_huge_page(struct mm
 	 */
 	if (unmapped && !__collapse_huge_page_swapin(mm, vma, address,
 						     pmd, referenced)) {
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		goto out_nolock;
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	/*
 	 * Prevent all access to pagetables with the exception of
 	 * gup_fast later handled by the ptep_clear_flush and the VM
 	 * handled by the anon_vma lock + PG_lock.
 	 */
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	result = SCAN_ANY_PROCESS;
 	if (!mmget_still_valid(mm))
 		goto out;
@@ -1185,7 +1185,7 @@ static void collapse_huge_page(struct mm
 	khugepaged_pages_collapsed++;
 	result = SCAN_SUCCEED;
 out_up_write:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 out_nolock:
 	if (!IS_ERR_OR_NULL(*hpage))
 		mem_cgroup_uncharge(*hpage);
@@ -1518,7 +1518,7 @@ static int khugepaged_collapse_pte_mappe
 	if (likely(mm_slot->nr_pte_mapped_thp == 0))
 		return 0;
 
-	if (!down_write_trylock(&mm->mmap_sem))
+	if (!mmap_write_trylock(mm))
 		return -EBUSY;
 
 	if (unlikely(khugepaged_test_exit(mm)))
@@ -1529,7 +1529,7 @@ static int khugepaged_collapse_pte_mappe
 
 out:
 	mm_slot->nr_pte_mapped_thp = 0;
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return 0;
 }
 
@@ -1574,12 +1574,12 @@ static void retract_page_tables(struct a
 		 * mmap_sem while holding page lock. Fault path does it in
 		 * reverse order. Trylock is a way to avoid deadlock.
 		 */
-		if (down_write_trylock(&vma->vm_mm->mmap_sem)) {
+		if (mmap_write_trylock(vma->vm_mm)) {
 			spinlock_t *ptl = pmd_lock(vma->vm_mm, pmd);
 			/* assume page table is clear */
 			_pmd = pmdp_collapse_flush(vma, addr, pmd);
 			spin_unlock(ptl);
-			up_write(&vma->vm_mm->mmap_sem);
+			mmap_write_unlock(vma->vm_mm);
 			mm_dec_nr_ptes(vma->vm_mm);
 			pte_free(vma->vm_mm, pmd_pgtable(_pmd));
 		} else {
@@ -2061,7 +2061,7 @@ static unsigned int khugepaged_scan_mm_s
 	 * the next mm on the list.
 	 */
 	vma = NULL;
-	if (unlikely(!down_read_trylock(&mm->mmap_sem)))
+	if (unlikely(!mmap_read_trylock(mm)))
 		goto breakouterloop_mmap_sem;
 	if (likely(!khugepaged_test_exit(mm)))
 		vma = find_vma(mm, khugepaged_scan.address);
@@ -2106,7 +2106,7 @@ skip:
 				pgoff_t pgoff = linear_page_index(vma,
 						khugepaged_scan.address);
 
-				up_read(&mm->mmap_sem);
+				mmap_read_unlock(mm);
 				ret = 1;
 				khugepaged_scan_file(mm, file, pgoff, hpage);
 				fput(file);
@@ -2126,7 +2126,7 @@ skip:
 		}
 	}
 breakouterloop:
-	up_read(&mm->mmap_sem); /* exit_mmap will destroy ptes after this */
+	mmap_read_unlock(mm); /* exit_mmap will destroy ptes after this */
 breakouterloop_mmap_sem:
 
 	spin_lock(&khugepaged_mm_lock);
--- a/mm/ksm.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/ksm.c
@@ -542,11 +542,11 @@ static void break_cow(struct rmap_item *
 	 */
 	put_anon_vma(rmap_item->anon_vma);
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (vma)
 		break_ksm(vma, addr);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 }
 
 static struct page *get_mergeable_page(struct rmap_item *rmap_item)
@@ -556,7 +556,7 @@ static struct page *get_mergeable_page(s
 	struct vm_area_struct *vma;
 	struct page *page;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (!vma)
 		goto out;
@@ -572,7 +572,7 @@ static struct page *get_mergeable_page(s
 out:
 		page = NULL;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return page;
 }
 
@@ -976,7 +976,7 @@ static int unmerge_and_remove_all_rmap_i
 	for (mm_slot = ksm_scan.mm_slot;
 			mm_slot != &ksm_mm_head; mm_slot = ksm_scan.mm_slot) {
 		mm = mm_slot->mm;
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		for (vma = mm->mmap; vma; vma = vma->vm_next) {
 			if (ksm_test_exit(mm))
 				break;
@@ -989,7 +989,7 @@ static int unmerge_and_remove_all_rmap_i
 		}
 
 		remove_trailing_rmap_items(mm_slot, &mm_slot->rmap_list);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 
 		spin_lock(&ksm_mmlist_lock);
 		ksm_scan.mm_slot = list_entry(mm_slot->mm_list.next,
@@ -1012,7 +1012,7 @@ static int unmerge_and_remove_all_rmap_i
 	return 0;
 
 error:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	spin_lock(&ksm_mmlist_lock);
 	ksm_scan.mm_slot = &ksm_mm_head;
 	spin_unlock(&ksm_mmlist_lock);
@@ -1280,7 +1280,7 @@ static int try_to_merge_with_ksm_page(st
 	struct vm_area_struct *vma;
 	int err = -EFAULT;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, rmap_item->address);
 	if (!vma)
 		goto out;
@@ -1296,7 +1296,7 @@ static int try_to_merge_with_ksm_page(st
 	rmap_item->anon_vma = vma->anon_vma;
 	get_anon_vma(vma->anon_vma);
 out:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return err;
 }
 
@@ -2110,7 +2110,7 @@ static void cmp_and_merge_page(struct pa
 	if (ksm_use_zero_pages && (checksum == zero_checksum)) {
 		struct vm_area_struct *vma;
 
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		vma = find_mergeable_vma(mm, rmap_item->address);
 		if (vma) {
 			err = try_to_merge_one_page(vma, page,
@@ -2122,7 +2122,7 @@ static void cmp_and_merge_page(struct pa
 			 */
 			err = 0;
 		}
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		/*
 		 * In case of failure, the page was not really empty, so we
 		 * need to continue. Otherwise we're done.
@@ -2285,7 +2285,7 @@ next_mm:
 	}
 
 	mm = slot->mm;
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	if (ksm_test_exit(mm))
 		vma = NULL;
 	else
@@ -2319,7 +2319,7 @@ next_mm:
 					ksm_scan.address += PAGE_SIZE;
 				} else
 					put_page(*page);
-				up_read(&mm->mmap_sem);
+				mmap_read_unlock(mm);
 				return rmap_item;
 			}
 			put_page(*page);
@@ -2357,10 +2357,10 @@ next_mm:
 
 		free_mm_slot(slot);
 		clear_bit(MMF_VM_MERGEABLE, &mm->flags);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		mmdrop(mm);
 	} else {
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		/*
 		 * up_read(&mm->mmap_sem) first because after
 		 * spin_unlock(&ksm_mmlist_lock) run, the "mm" may
@@ -2560,8 +2560,8 @@ void __ksm_exit(struct mm_struct *mm)
 		clear_bit(MMF_VM_MERGEABLE, &mm->flags);
 		mmdrop(mm);
 	} else if (mm_slot) {
-		down_write(&mm->mmap_sem);
-		up_write(&mm->mmap_sem);
+		mmap_write_lock(mm);
+		mmap_write_unlock(mm);
 	}
 }
 
--- a/mm/madvise.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/madvise.c
@@ -289,12 +289,12 @@ static long madvise_willneed(struct vm_a
 	 */
 	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
 	get_file(file);
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	offset = (loff_t)(start - vma->vm_start)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 	vfs_fadvise(file, offset, end - start, POSIX_FADV_WILLNEED);
 	fput(file);
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	return 0;
 }
 
@@ -770,7 +770,7 @@ static long madvise_dontneed_free(struct
 	if (!userfaultfd_remove(vma, start, end)) {
 		*prev = NULL; /* mmap_sem has been dropped, prev is stale */
 
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		vma = find_vma(current->mm, start);
 		if (!vma)
 			return -ENOMEM;
@@ -852,13 +852,13 @@ static long madvise_remove(struct vm_are
 	get_file(f);
 	if (userfaultfd_remove(vma, start, end)) {
 		/* mmap_sem was not released by userfaultfd_remove() */
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 	}
 	error = vfs_fallocate(f,
 				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				offset, end - start);
 	fput(f);
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	return error;
 }
 
@@ -1089,7 +1089,7 @@ int do_madvise(unsigned long start, size
 
 	write = madvise_need_mmap_write(behavior);
 	if (write) {
-		if (down_write_killable(&current->mm->mmap_sem))
+		if (mmap_write_lock_killable(current->mm))
 			return -EINTR;
 
 		/*
@@ -1105,11 +1105,11 @@ int do_madvise(unsigned long start, size
 		 * model.
 		 */
 		if (!mmget_still_valid(current->mm)) {
-			up_write(&current->mm->mmap_sem);
+			mmap_write_unlock(current->mm);
 			return -EINTR;
 		}
 	} else {
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 	}
 
 	/*
@@ -1159,9 +1159,9 @@ int do_madvise(unsigned long start, size
 out:
 	blk_finish_plug(&plug);
 	if (write)
-		up_write(&current->mm->mmap_sem);
+		mmap_write_unlock(current->mm);
 	else
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 
 	return error;
 }
--- a/mm/memcontrol.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/memcontrol.c
@@ -5564,9 +5564,9 @@ static unsigned long mem_cgroup_count_pr
 {
 	unsigned long precharge;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	walk_page_range(mm, 0, mm->highest_vm_end, &precharge_walk_ops, NULL);
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	precharge = mc.precharge;
 	mc.precharge = 0;
@@ -5849,7 +5849,7 @@ static void mem_cgroup_move_charge(void)
 	atomic_inc(&mc.from->moving_account);
 	synchronize_rcu();
 retry:
-	if (unlikely(!down_read_trylock(&mc.mm->mmap_sem))) {
+	if (unlikely(!mmap_read_trylock(mc.mm))) {
 		/*
 		 * Someone who are holding the mmap_sem might be waiting in
 		 * waitq. So we cancel all extra charges, wake up all waiters,
@@ -5868,7 +5868,7 @@ retry:
 	walk_page_range(mc.mm, 0, mc.mm->highest_vm_end, &charge_walk_ops,
 			NULL);
 
-	up_read(&mc.mm->mmap_sem);
+	mmap_read_unlock(mc.mm);
 	atomic_dec(&mc.from->moving_account);
 }
 
--- a/mm/memory.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/memory.c
@@ -1592,7 +1592,7 @@ int vm_insert_pages(struct vm_area_struc
 	if (addr < vma->vm_start || end_addr >= vma->vm_end)
 		return -EFAULT;
 	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		BUG_ON(down_read_trylock(&vma->vm_mm->mmap_sem));
+		BUG_ON(mmap_read_trylock(vma->vm_mm));
 		BUG_ON(vma->vm_flags & VM_PFNMAP);
 		vma->vm_flags |= VM_MIXEDMAP;
 	}
@@ -1650,7 +1650,7 @@ int vm_insert_page(struct vm_area_struct
 	if (!page_count(page))
 		return -EINVAL;
 	if (!(vma->vm_flags & VM_MIXEDMAP)) {
-		BUG_ON(down_read_trylock(&vma->vm_mm->mmap_sem));
+		BUG_ON(mmap_read_trylock(vma->vm_mm));
 		BUG_ON(vma->vm_flags & VM_PFNMAP);
 		vma->vm_flags |= VM_MIXEDMAP;
 	}
@@ -4643,7 +4643,7 @@ int __access_remote_vm(struct task_struc
 	void *old_buf = buf;
 	int write = gup_flags & FOLL_WRITE;
 
-	if (down_read_killable(&mm->mmap_sem))
+	if (mmap_read_lock_killable(mm))
 		return 0;
 
 	/* ignore errors, just check how much was successfully transferred */
@@ -4694,7 +4694,7 @@ int __access_remote_vm(struct task_struc
 		buf += bytes;
 		addr += bytes;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	return buf - old_buf;
 }
@@ -4751,7 +4751,7 @@ void print_vma_addr(char *prefix, unsign
 	/*
 	 * we might be running from an atomic context so we cannot sleep
 	 */
-	if (!down_read_trylock(&mm->mmap_sem))
+	if (!mmap_read_trylock(mm))
 		return;
 
 	vma = find_vma(mm, ip);
@@ -4770,7 +4770,7 @@ void print_vma_addr(char *prefix, unsign
 			free_page((unsigned long)buf);
 		}
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 }
 
 #if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
--- a/mm/mempolicy.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/mempolicy.c
@@ -405,10 +405,10 @@ void mpol_rebind_mm(struct mm_struct *mm
 {
 	struct vm_area_struct *vma;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		mpol_rebind_policy(vma->vm_policy, new);
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 }
 
 static const struct mempolicy_operations mpol_ops[MPOL_MAX] = {
@@ -932,7 +932,7 @@ static int lookup_node(struct mm_struct
 		put_page(p);
 	}
 	if (locked)
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 	return err;
 }
 
@@ -965,10 +965,10 @@ static long do_get_mempolicy(int *policy
 		 * vma/shared policy at addr is NULL.  We
 		 * want to return MPOL_DEFAULT in this case.
 		 */
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		vma = find_vma_intersection(mm, addr, addr+1);
 		if (!vma) {
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 			return -EFAULT;
 		}
 		if (vma->vm_ops && vma->vm_ops->get_policy)
@@ -1027,7 +1027,7 @@ static long do_get_mempolicy(int *policy
  out:
 	mpol_cond_put(pol);
 	if (vma)
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 	if (pol_refcount)
 		mpol_put(pol_refcount);
 	return err;
@@ -1136,7 +1136,7 @@ int do_migrate_pages(struct mm_struct *m
 	if (err)
 		return err;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	/*
 	 * Find a 'source' bit set in 'tmp' whose corresponding 'dest'
@@ -1217,7 +1217,7 @@ int do_migrate_pages(struct mm_struct *m
 		if (err < 0)
 			break;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	if (err < 0)
 		return err;
 	return busy;
@@ -1340,12 +1340,12 @@ static long do_mbind(unsigned long start
 	{
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
-			down_write(&mm->mmap_sem);
+			mmap_write_lock(mm);
 			task_lock(current);
 			err = mpol_set_nodemask(new, nmask, scratch);
 			task_unlock(current);
 			if (err)
-				up_write(&mm->mmap_sem);
+				mmap_write_unlock(mm);
 		} else
 			err = -ENOMEM;
 		NODEMASK_SCRATCH_FREE(scratch);
@@ -1382,7 +1382,7 @@ up_out:
 			putback_movable_pages(&pagelist);
 	}
 
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 mpol_out:
 	mpol_put(new);
 	return err;
--- a/mm/migrate.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/migrate.c
@@ -1573,7 +1573,7 @@ static int add_page_for_migration(struct
 	unsigned int follflags;
 	int err;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	err = -EFAULT;
 	vma = find_vma(mm, addr);
 	if (!vma || addr < vma->vm_start || !vma_migratable(vma))
@@ -1626,7 +1626,7 @@ out_putpage:
 	 */
 	put_page(page);
 out:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return err;
 }
 
@@ -1751,7 +1751,7 @@ static void do_pages_stat_array(struct m
 {
 	unsigned long i;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
 		unsigned long addr = (unsigned long)(*pages);
@@ -1778,7 +1778,7 @@ set_status:
 		status++;
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 }
 
 /*
--- a/mm/mincore.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/mincore.c
@@ -284,9 +284,9 @@ SYSCALL_DEFINE3(mincore, unsigned long,
 		 * Do at most PAGE_SIZE entries per iteration, due to
 		 * the temporary buffer size.
 		 */
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		retval = do_mincore(start, min(pages, PAGE_SIZE), tmp);
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 
 		if (retval <= 0)
 			break;
--- a/mm/mlock.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/mlock.c
@@ -686,7 +686,7 @@ static __must_check int do_mlock(unsigne
 	lock_limit >>= PAGE_SHIFT;
 	locked = len >> PAGE_SHIFT;
 
-	if (down_write_killable(&current->mm->mmap_sem))
+	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 
 	locked += current->mm->locked_vm;
@@ -705,7 +705,7 @@ static __must_check int do_mlock(unsigne
 	if ((locked <= lock_limit) || capable(CAP_IPC_LOCK))
 		error = apply_vma_lock_flags(start, len, flags);
 
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 	if (error)
 		return error;
 
@@ -742,10 +742,10 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 	len = PAGE_ALIGN(len + (offset_in_page(start)));
 	start &= PAGE_MASK;
 
-	if (down_write_killable(&current->mm->mmap_sem))
+	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 	ret = apply_vma_lock_flags(start, len, 0);
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 
 	return ret;
 }
@@ -811,14 +811,14 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 
-	if (down_write_killable(&current->mm->mmap_sem))
+	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 
 	ret = -ENOMEM;
 	if (!(flags & MCL_CURRENT) || (current->mm->total_vm <= lock_limit) ||
 	    capable(CAP_IPC_LOCK))
 		ret = apply_mlockall_flags(flags);
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 	if (!ret && (flags & MCL_CURRENT))
 		mm_populate(0, TASK_SIZE);
 
@@ -829,10 +829,10 @@ SYSCALL_DEFINE0(munlockall)
 {
 	int ret;
 
-	if (down_write_killable(&current->mm->mmap_sem))
+	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 	ret = apply_mlockall_flags(0);
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 	return ret;
 }
 
--- a/mm/mmap.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/mmap.c
@@ -206,7 +206,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	bool downgraded = false;
 	LIST_HEAD(uf);
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	origbrk = mm->brk;
@@ -280,9 +280,9 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 success:
 	populate = newbrk > oldbrk && (mm->def_flags & VM_LOCKED) != 0;
 	if (downgraded)
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 	else
-		up_write(&mm->mmap_sem);
+		mmap_write_unlock(mm);
 	userfaultfd_unmap_complete(mm, &uf);
 	if (populate)
 		mm_populate(oldbrk, newbrk - oldbrk);
@@ -290,7 +290,7 @@ success:
 
 out:
 	retval = origbrk;
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return retval;
 }
 
@@ -2849,7 +2849,7 @@ int __do_munmap(struct mm_struct *mm, un
 	detach_vmas_to_be_unmapped(mm, vma, prev, end);
 
 	if (downgrade)
-		downgrade_write(&mm->mmap_sem);
+		mmap_write_downgrade(mm);
 
 	unmap_region(mm, vma, prev, start, end);
 
@@ -2871,7 +2871,7 @@ static int __vm_munmap(unsigned long sta
 	struct mm_struct *mm = current->mm;
 	LIST_HEAD(uf);
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	ret = __do_munmap(mm, start, len, &uf, downgrade);
@@ -2881,10 +2881,10 @@ static int __vm_munmap(unsigned long sta
 	 * it to 0 before return.
 	 */
 	if (ret == 1) {
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		ret = 0;
 	} else
-		up_write(&mm->mmap_sem);
+		mmap_write_unlock(mm);
 
 	userfaultfd_unmap_complete(mm, &uf);
 	return ret;
@@ -2932,7 +2932,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	if (pgoff + (size >> PAGE_SHIFT) < pgoff)
 		return ret;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	vma = find_vma(mm, start);
@@ -2995,7 +2995,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 			prot, flags, pgoff, &populate, NULL);
 	fput(file);
 out:
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	if (populate)
 		mm_populate(ret, populate);
 	if (!IS_ERR_VALUE(ret))
@@ -3095,12 +3095,12 @@ int vm_brk_flags(unsigned long addr, uns
 	if (!len)
 		return 0;
 
-	if (down_write_killable(&mm->mmap_sem))
+	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
 	ret = do_brk_flags(addr, len, flags, &uf);
 	populate = ((mm->def_flags & VM_LOCKED) != 0);
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	userfaultfd_unmap_complete(mm, &uf);
 	if (populate && !ret)
 		mm_populate(addr, len);
@@ -3144,8 +3144,8 @@ void exit_mmap(struct mm_struct *mm)
 		(void)__oom_reap_task_mm(mm);
 
 		set_bit(MMF_OOM_SKIP, &mm->flags);
-		down_write(&mm->mmap_sem);
-		up_write(&mm->mmap_sem);
+		mmap_write_lock(mm);
+		mmap_write_unlock(mm);
 	}
 
 	if (mm->locked_vm) {
@@ -3572,7 +3572,7 @@ int mm_take_all_locks(struct mm_struct *
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
 
-	BUG_ON(down_read_trylock(&mm->mmap_sem));
+	BUG_ON(mmap_read_trylock(mm));
 
 	mutex_lock(&mm_all_locks_mutex);
 
@@ -3652,7 +3652,7 @@ void mm_drop_all_locks(struct mm_struct
 	struct vm_area_struct *vma;
 	struct anon_vma_chain *avc;
 
-	BUG_ON(down_read_trylock(&mm->mmap_sem));
+	BUG_ON(mmap_read_trylock(mm));
 	BUG_ON(!mutex_is_locked(&mm_all_locks_mutex));
 
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
--- a/mm/mmu_notifier.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/mmu_notifier.c
@@ -708,9 +708,9 @@ int mmu_notifier_register(struct mmu_not
 {
 	int ret;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	ret = __mmu_notifier_register(subscription, mm);
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_register);
--- a/mm/mprotect.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/mprotect.c
@@ -538,7 +538,7 @@ static int do_mprotect_pkey(unsigned lon
 
 	reqprot = prot;
 
-	if (down_write_killable(&current->mm->mmap_sem))
+	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 
 	/*
@@ -628,7 +628,7 @@ static int do_mprotect_pkey(unsigned lon
 		prot = reqprot;
 	}
 out:
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 	return error;
 }
 
@@ -658,7 +658,7 @@ SYSCALL_DEFINE2(pkey_alloc, unsigned lon
 	if (init_val & ~PKEY_ACCESS_MASK)
 		return -EINVAL;
 
-	down_write(&current->mm->mmap_sem);
+	mmap_write_lock(current->mm);
 	pkey = mm_pkey_alloc(current->mm);
 
 	ret = -ENOSPC;
@@ -672,7 +672,7 @@ SYSCALL_DEFINE2(pkey_alloc, unsigned lon
 	}
 	ret = pkey;
 out:
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 	return ret;
 }
 
@@ -680,9 +680,9 @@ SYSCALL_DEFINE1(pkey_free, int, pkey)
 {
 	int ret;
 
-	down_write(&current->mm->mmap_sem);
+	mmap_write_lock(current->mm);
 	ret = mm_pkey_free(current->mm, pkey);
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 
 	/*
 	 * We could provie warnings or errors if any VMA still
--- a/mm/mremap.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/mremap.c
@@ -696,7 +696,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	if (!new_len)
 		return ret;
 
-	if (down_write_killable(&current->mm->mmap_sem))
+	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 
 	if (flags & (MREMAP_FIXED | MREMAP_DONTUNMAP)) {
@@ -788,9 +788,9 @@ out:
 		locked = false;
 	}
 	if (downgraded)
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 	else
-		up_write(&current->mm->mmap_sem);
+		mmap_write_unlock(current->mm);
 	if (locked && new_len > old_len)
 		mm_populate(new_addr + old_len, new_len - old_len);
 	userfaultfd_unmap_complete(mm, &uf_unmap_early);
--- a/mm/msync.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/msync.c
@@ -57,7 +57,7 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 	 * If the interval [start,end) covers some unmapped address ranges,
 	 * just ignore them, but return -ENOMEM at the end.
 	 */
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, start);
 	for (;;) {
 		struct file *file;
@@ -88,12 +88,12 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 		if ((flags & MS_SYNC) && file &&
 				(vma->vm_flags & VM_SHARED)) {
 			get_file(file);
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 			error = vfs_fsync_range(file, fstart, fend, 1);
 			fput(file);
 			if (error || start >= end)
 				goto out;
-			down_read(&mm->mmap_sem);
+			mmap_read_lock(mm);
 			vma = find_vma(mm, start);
 		} else {
 			if (start >= end) {
@@ -104,7 +104,7 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 		}
 	}
 out_unlock:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 out:
 	return error ? : unmapped_error;
 }
--- a/mm/nommu.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/nommu.c
@@ -172,11 +172,11 @@ static void *__vmalloc_user_flags(unsign
 	if (ret) {
 		struct vm_area_struct *vma;
 
-		down_write(&current->mm->mmap_sem);
+		mmap_write_lock(current->mm);
 		vma = find_vma(current->mm, (unsigned long)ret);
 		if (vma)
 			vma->vm_flags |= VM_USERMAP;
-		up_write(&current->mm->mmap_sem);
+		mmap_write_unlock(current->mm);
 	}
 
 	return ret;
@@ -1542,9 +1542,9 @@ int vm_munmap(unsigned long addr, size_t
 	struct mm_struct *mm = current->mm;
 	int ret;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	ret = do_munmap(mm, addr, len, NULL);
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 	return ret;
 }
 EXPORT_SYMBOL(vm_munmap);
@@ -1631,9 +1631,9 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 {
 	unsigned long ret;
 
-	down_write(&current->mm->mmap_sem);
+	mmap_write_lock(current->mm);
 	ret = do_mremap(addr, old_len, new_len, flags, new_addr);
-	up_write(&current->mm->mmap_sem);
+	mmap_write_unlock(current->mm);
 	return ret;
 }
 
@@ -1705,7 +1705,7 @@ int __access_remote_vm(struct task_struc
 	struct vm_area_struct *vma;
 	int write = gup_flags & FOLL_WRITE;
 
-	if (down_read_killable(&mm->mmap_sem))
+	if (mmap_read_lock_killable(mm))
 		return 0;
 
 	/* the access must start within one of the target process's mappings */
@@ -1728,7 +1728,7 @@ int __access_remote_vm(struct task_struc
 		len = 0;
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	return len;
 }
--- a/mm/oom_kill.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/oom_kill.c
@@ -569,7 +569,7 @@ static bool oom_reap_task_mm(struct task
 {
 	bool ret = true;
 
-	if (!down_read_trylock(&mm->mmap_sem)) {
+	if (!mmap_read_trylock(mm)) {
 		trace_skip_task_reaping(tsk->pid);
 		return false;
 	}
@@ -600,7 +600,7 @@ static bool oom_reap_task_mm(struct task
 out_finish:
 	trace_finish_task_reaping(tsk->pid);
 out_unlock:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	return ret;
 }
--- a/mm/process_vm_access.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/process_vm_access.c
@@ -104,12 +104,12 @@ static int process_vm_rw_single_vec(unsi
 		 * access remotely because task/mm might not
 		 * current/current->mm
 		 */
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		pinned_pages = pin_user_pages_remote(task, mm, pa, pinned_pages,
 						     flags, process_pages,
 						     NULL, &locked);
 		if (locked)
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 		if (pinned_pages <= 0)
 			return -EFAULT;
 
--- a/mm/ptdump.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/ptdump.c
@@ -126,13 +126,13 @@ void ptdump_walk_pgd(struct ptdump_state
 {
 	const struct ptdump_range *range = st->range;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	while (range->start != range->end) {
 		walk_page_range_novma(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 	/* Flush out the last page */
 	st->note_page(st, 0, -1, 0);
--- a/mm/swapfile.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/swapfile.c
@@ -2104,7 +2104,7 @@ static int unuse_mm(struct mm_struct *mm
 	struct vm_area_struct *vma;
 	int ret = 0;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->anon_vma) {
 			ret = unuse_vma(vma, type, frontswap,
@@ -2114,7 +2114,7 @@ static int unuse_mm(struct mm_struct *mm
 		}
 		cond_resched();
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return ret;
 }
 
--- a/mm/userfaultfd.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/userfaultfd.c
@@ -228,7 +228,7 @@ static __always_inline ssize_t __mcopy_a
 	 * feature is not supported.
 	 */
 	if (zeropage) {
-		up_read(&dst_mm->mmap_sem);
+		mmap_read_unlock(dst_mm);
 		return -EINVAL;
 	}
 
@@ -315,7 +315,7 @@ retry:
 		cond_resched();
 
 		if (unlikely(err == -ENOENT)) {
-			up_read(&dst_mm->mmap_sem);
+			mmap_read_unlock(dst_mm);
 			BUG_ON(!page);
 
 			err = copy_huge_page_from_user(page,
@@ -326,7 +326,7 @@ retry:
 				err = -EFAULT;
 				goto out;
 			}
-			down_read(&dst_mm->mmap_sem);
+			mmap_read_lock(dst_mm);
 
 			dst_vma = NULL;
 			goto retry;
@@ -346,7 +346,7 @@ retry:
 	}
 
 out_unlock:
-	up_read(&dst_mm->mmap_sem);
+	mmap_read_unlock(dst_mm);
 out:
 	if (page) {
 		/*
@@ -485,7 +485,7 @@ static __always_inline ssize_t __mcopy_a
 	copied = 0;
 	page = NULL;
 retry:
-	down_read(&dst_mm->mmap_sem);
+	mmap_read_lock(dst_mm);
 
 	/*
 	 * If memory mappings are changing because of non-cooperative
@@ -583,7 +583,7 @@ retry:
 		if (unlikely(err == -ENOENT)) {
 			void *page_kaddr;
 
-			up_read(&dst_mm->mmap_sem);
+			mmap_read_unlock(dst_mm);
 			BUG_ON(!page);
 
 			page_kaddr = kmap(page);
@@ -612,7 +612,7 @@ retry:
 	}
 
 out_unlock:
-	up_read(&dst_mm->mmap_sem);
+	mmap_read_unlock(dst_mm);
 out:
 	if (page)
 		put_page(page);
@@ -652,7 +652,7 @@ int mwriteprotect_range(struct mm_struct
 	/* Does the address range wrap, or is the span zero-sized? */
 	BUG_ON(start + len <= start);
 
-	down_read(&dst_mm->mmap_sem);
+	mmap_read_lock(dst_mm);
 
 	/*
 	 * If memory mappings are changing because of non-cooperative
@@ -686,6 +686,6 @@ int mwriteprotect_range(struct mm_struct
 
 	err = 0;
 out_unlock:
-	up_read(&dst_mm->mmap_sem);
+	mmap_read_unlock(dst_mm);
 	return err;
 }
--- a/mm/util.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/mm/util.c
@@ -481,10 +481,10 @@ int account_locked_vm(struct mm_struct *
 	if (pages == 0 || !mm)
 		return 0;
 
-	down_write(&mm->mmap_sem);
+	mmap_write_lock(mm);
 	ret = __account_locked_vm(mm, pages, inc, current,
 				  capable(CAP_IPC_LOCK));
-	up_write(&mm->mmap_sem);
+	mmap_write_unlock(mm);
 
 	return ret;
 }
@@ -501,11 +501,11 @@ unsigned long vm_mmap_pgoff(struct file
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret) {
-		if (down_write_killable(&mm->mmap_sem))
+		if (mmap_write_lock_killable(mm))
 			return -EINTR;
 		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
 				    &populate, &uf);
-		up_write(&mm->mmap_sem);
+		mmap_write_unlock(mm);
 		userfaultfd_unmap_complete(mm, &uf);
 		if (populate)
 			mm_populate(ret, populate);
--- a/net/ipv4/tcp.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/net/ipv4/tcp.c
@@ -1798,11 +1798,11 @@ static int tcp_zerocopy_receive(struct s
 
 	tp = tcp_sk(sk);
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 
 	vma = find_vma(current->mm, address);
 	if (!vma || vma->vm_start > address || vma->vm_ops != &tcp_vm_ops) {
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 		return -EINVAL;
 	}
 	zc->length = min_t(unsigned long, zc->length, vma->vm_end - address);
@@ -1883,7 +1883,7 @@ static int tcp_zerocopy_receive(struct s
 						   zc);
 	}
 out:
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	if (length) {
 		WRITE_ONCE(tp->copied_seq, seq);
 		tcp_rcv_space_adjust(sk);
--- a/net/xdp/xdp_umem.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/net/xdp/xdp_umem.c
@@ -290,10 +290,10 @@ static int xdp_umem_pin_pages(struct xdp
 	if (!umem->pgs)
 		return -ENOMEM;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	npgs = pin_user_pages(address, umem->npgs,
 			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	if (npgs != umem->npgs) {
 		if (npgs >= 0) {
--- a/virt/kvm/async_pf.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/virt/kvm/async_pf.c
@@ -59,11 +59,11 @@ static void async_pf_execute(struct work
 	 * mm and might be done in another context, so we must
 	 * access remotely.
 	 */
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
 			&locked);
 	if (locked)
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 
 	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
 		kvm_arch_async_page_present(vcpu, apf);
--- a/virt/kvm/kvm_main.c~mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites
+++ a/virt/kvm/kvm_main.c
@@ -1632,7 +1632,7 @@ unsigned long kvm_host_page_size(struct
 	if (kvm_is_error_hva(addr))
 		return PAGE_SIZE;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	vma = find_vma(current->mm, addr);
 	if (!vma)
 		goto out;
@@ -1640,7 +1640,7 @@ unsigned long kvm_host_page_size(struct
 	size = vma_kernel_pagesize(vma);
 
 out:
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	return size;
 }
@@ -1893,7 +1893,7 @@ static kvm_pfn_t hva_to_pfn(unsigned lon
 	if (npages == 1)
 		return pfn;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	if (npages == -EHWPOISON ||
 	      (!async && check_user_page_hwpoison(addr))) {
 		pfn = KVM_PFN_ERR_HWPOISON;
@@ -1914,7 +1914,7 @@ static kvm_pfn_t hva_to_pfn(unsigned lon
 		pfn = KVM_PFN_ERR_FAULT;
 	}
 exit:
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	return pfn;
 }
 
_

Patches currently in -mm which might be from walken@google.com are

mmap-locking-api-initial-implementation-as-rwsem-wrappers.patch
mmu-notifier-use-the-new-mmap-locking-api.patch
dma-reservations-use-the-new-mmap-locking-api.patch
mmap-locking-api-use-coccinelle-to-convert-mmap_sem-rwsem-call-sites.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch
mmap-locking-api-convert-nested-write-lock-sites.patch
mmap-locking-api-add-mmap_read_trylock_non_owner.patch
mmap-locking-api-add-mmap_lock_initializer.patch
mmap-locking-api-add-mmap_assert_locked-and-mmap_assert_write_locked.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock.patch
mmap-locking-api-convert-mmap_sem-api-comments.patch
mmap-locking-api-convert-mmap_sem-comments.patch
