From: akpm@linux-foundation.org
Subject: [merged]
 mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch
 removed from -mm tree
Date: Tue, 09 Jun 2020 17:39:26 -0700
Message-ID: <20200610003926.WrzVKUjWI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgFJAj2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:39:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap locking API: convert mmap_sem call sites missed by coccinelle
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mmap locking API: convert mmap_sem call sites missed by coccinelle

Convert the last few remaining mmap_sem rwsem calls to use the new mmap
locking API.  These were missed by coccinelle for some reason (I think
coccinelle does not support some of the preprocessor constructs in these
files ?)

[akpm@linux-foundation.org: convert linux-next leftovers]
[akpm@linux-foundation.org: more linux-next leftovers]
[akpm@linux-foundation.org: more linux-next leftovers]
Link: http://lkml.kernel.org/r/20200520052908.204642-6-walken@google.com
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

 arch/arm64/kvm/mmu.c                           |   14 +++++++-------
 arch/mips/mm/fault.c                           |   10 +++++-----
 arch/riscv/mm/pageattr.c                       |    4 ++--
 arch/x86/kvm/mmu/paging_tmpl.h                 |    8 ++++----
 drivers/staging/media/atomisp/pci/hmm/hmm_bo.c |    4 ++--
 drivers/vfio/pci/vfio_pci.c                    |    8 ++++----
 fs/proc/base.c                                 |    6 +++---
 lib/test_hmm.c                                 |   14 +++++++-------
 8 files changed, 34 insertions(+), 34 deletions(-)

--- a/arch/arm64/kvm/mmu.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/arch/arm64/kvm/mmu.c
@@ -1084,7 +1084,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	spin_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
@@ -1092,7 +1092,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 		stage2_unmap_memslot(kvm, memslot);
 
 	spin_unlock(&kvm->mmu_lock);
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -1848,11 +1848,11 @@ static int user_mem_abort(struct kvm_vcp
 	}
 
 	/* Let's check if we will get back a huge page backed by hugetlbfs */
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	vma = find_vma_intersection(current->mm, hva, hva + 1);
 	if (unlikely(!vma)) {
 		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 		return -EFAULT;
 	}
 
@@ -1879,7 +1879,7 @@ static int user_mem_abort(struct kvm_vcp
 	if (vma_pagesize == PMD_SIZE ||
 	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 
 	/* We need minimum second+third level pages */
 	ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
@@ -2456,7 +2456,7 @@ int kvm_arch_prepare_memory_region(struc
 	    (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
 	 * between them, so iterate over all of them to find out if we can map
@@ -2515,7 +2515,7 @@ int kvm_arch_prepare_memory_region(struc
 		stage2_flush_memslot(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	return ret;
 }
 
--- a/arch/mips/mm/fault.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/arch/mips/mm/fault.c
@@ -97,7 +97,7 @@ static void __kprobes __do_page_fault(st
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 retry:
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
@@ -190,7 +190,7 @@ good_area:
 		}
 	}
 
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	return;
 
 /*
@@ -198,7 +198,7 @@ good_area:
  * Fix it, but check if it's kernel or user first..
  */
 bad_area:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
@@ -250,14 +250,14 @@ out_of_memory:
 	 * We ran out of memory, call the OOM killer, and return the userspace
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
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
--- a/arch/riscv/mm/pageattr.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/arch/riscv/mm/pageattr.c
@@ -117,10 +117,10 @@ static int __set_memory(unsigned long ad
 	if (!numpages)
 		return 0;
 
-	down_read(&init_mm.mmap_sem);
+	mmap_read_lock(&init_mm);
 	ret =  walk_page_range_novma(&init_mm, start, end, &pageattr_ops, NULL,
 				     &masks);
-	up_read(&init_mm.mmap_sem);
+	mmap_read_unlock(&init_mm);
 
 	flush_tlb_kernel_range(start, end);
 
--- a/arch/x86/kvm/mmu/paging_tmpl.h~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/arch/x86/kvm/mmu/paging_tmpl.h
@@ -165,22 +165,22 @@ static int FNAME(cmpxchg_gpte)(struct kv
 		unsigned long pfn;
 		unsigned long paddr;
 
-		down_read(&current->mm->mmap_sem);
+		mmap_read_lock(current->mm);
 		vma = find_vma_intersection(current->mm, vaddr, vaddr + PAGE_SIZE);
 		if (!vma || !(vma->vm_flags & VM_PFNMAP)) {
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 			return -EFAULT;
 		}
 		pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 		paddr = pfn << PAGE_SHIFT;
 		table = memremap(paddr, PAGE_SIZE, MEMREMAP_WB);
 		if (!table) {
-			up_read(&current->mm->mmap_sem);
+			mmap_read_unlock(current->mm);
 			return -EFAULT;
 		}
 		ret = CMPXCHG(&table[index], orig_pte, new_pte);
 		memunmap(table);
-		up_read(&current->mm->mmap_sem);
+		mmap_read_unlock(current->mm);
 	}
 
 	return (ret != orig_pte);
--- a/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c
@@ -982,9 +982,9 @@ static int alloc_user_pages(struct hmm_b
 	}
 
 	mutex_unlock(&bo->mutex);
-	down_read(&current->mm->mmap_sem);
+	mmap_read_lock(current->mm);
 	vma = find_vma(current->mm, (unsigned long)userptr);
-	up_read(&current->mm->mmap_sem);
+	mmap_read_unlock(current->mm);
 	if (!vma) {
 		dev_err(atomisp_dev, "find_vma failed\n");
 		kfree(bo->page_obj);
--- a/drivers/vfio/pci/vfio_pci.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/drivers/vfio/pci/vfio_pci.c
@@ -1422,17 +1422,17 @@ static int vfio_pci_zap_and_vma_lock(str
 		mutex_unlock(&vdev->vma_lock);
 
 		if (try) {
-			if (!down_read_trylock(&mm->mmap_sem)) {
+			if (!mmap_read_trylock(mm)) {
 				mmput(mm);
 				return 0;
 			}
 		} else {
-			down_read(&mm->mmap_sem);
+			mmap_read_lock(mm);
 		}
 		if (mmget_still_valid(mm)) {
 			if (try) {
 				if (!mutex_trylock(&vdev->vma_lock)) {
-					up_read(&mm->mmap_sem);
+					mmap_read_unlock(mm);
 					mmput(mm);
 					return 0;
 				}
@@ -1454,7 +1454,7 @@ static int vfio_pci_zap_and_vma_lock(str
 			}
 			mutex_unlock(&vdev->vma_lock);
 		}
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		mmput(mm);
 	}
 }
--- a/fs/proc/base.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/fs/proc/base.c
@@ -2322,7 +2322,7 @@ proc_map_files_readdir(struct file *file
 	if (!mm)
 		goto out_put_task;
 
-	ret = down_read_killable(&mm->mmap_sem);
+	ret = mmap_read_lock_killable(mm);
 	if (ret) {
 		mmput(mm);
 		goto out_put_task;
@@ -2349,7 +2349,7 @@ proc_map_files_readdir(struct file *file
 		p = genradix_ptr_alloc(&fa, nr_files++, GFP_KERNEL);
 		if (!p) {
 			ret = -ENOMEM;
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 			mmput(mm);
 			goto out_put_task;
 		}
@@ -2358,7 +2358,7 @@ proc_map_files_readdir(struct file *file
 		p->end = vma->vm_end;
 		p->mode = vma->vm_file->f_mode;
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 
 	for (i = 0; i < nr_files; i++) {
--- a/lib/test_hmm.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle
+++ a/lib/test_hmm.c
@@ -245,9 +245,9 @@ static int dmirror_range_fault(struct dm
 		}
 
 		range->notifier_seq = mmu_interval_read_begin(range->notifier);
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		ret = hmm_range_fault(range);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		if (ret) {
 			if (ret == -EBUSY)
 				continue;
@@ -686,7 +686,7 @@ static int dmirror_migrate(struct dmirro
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
 		vma = find_vma(mm, addr);
 		if (!vma || addr < vma->vm_start ||
@@ -713,7 +713,7 @@ static int dmirror_migrate(struct dmirro
 		dmirror_migrate_finalize_and_map(&args, dmirror);
 		migrate_vma_finalize(&args);
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 
 	/* Return the migrated data for verification. */
@@ -733,7 +733,7 @@ static int dmirror_migrate(struct dmirro
 	return ret;
 
 out:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 	return ret;
 }
@@ -825,9 +825,9 @@ static int dmirror_range_snapshot(struct
 
 		range->notifier_seq = mmu_interval_read_begin(range->notifier);
 
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		ret = hmm_range_fault(range);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		if (ret) {
 			if (ret == -EBUSY)
 				continue;
_

Patches currently in -mm which might be from walken@google.com are
