From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
 removed from -mm tree
Date: Mon, 08 Jun 2020 20:16:47 -0700
Message-ID: <20200609031647.c7ZPvrWKW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDQu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch

This patch was dropped because it was folded into mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix

convert linux-next leftovers

Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

 arch/arm64/kvm/mmu.c |   14 +++++++-------
 lib/test_hmm.c       |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/arch/arm64/kvm/mmu.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix
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
 
--- a/lib/test_hmm.c~mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
