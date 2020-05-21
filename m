From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:24:34 -0700
Message-ID: <20200521032434.xePFvqney%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728137AbgEUDYg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:24:36 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, dbueso@suse.de, hughd@google.com, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, ldufour@linux.ibm.com, Liam.Howlett@oracle.com, mm-commits@vger.kernel.org, peterz@infradead.org, rientjes@google.com, vbabka@suse.cz, walken@google.com, willy@infradead.org, yinghan@google.com


The patch titled
     Subject: mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix
has been added to the -mm tree.  Its filename is
     mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -243,9 +243,9 @@ static int dmirror_range_fault(struct dm
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
@@ -684,7 +684,7 @@ static int dmirror_migrate(struct dmirro
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
-	down_read(&mm->mmap_sem);
+	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
 		vma = find_vma(mm, addr);
 		if (!vma || addr < vma->vm_start ||
@@ -711,7 +711,7 @@ static int dmirror_migrate(struct dmirro
 		dmirror_migrate_finalize_and_map(&args, dmirror);
 		migrate_vma_finalize(&args);
 	}
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 
 	/* Return the migrated data for verification. */
@@ -731,7 +731,7 @@ static int dmirror_migrate(struct dmirro
 	return ret;
 
 out:
-	up_read(&mm->mmap_sem);
+	mmap_read_unlock(mm);
 	mmput(mm);
 	return ret;
 }
@@ -823,9 +823,9 @@ static int dmirror_range_snapshot(struct
 
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

squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-vmalloc-track-which-page-table-levels-were-modified-fix.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2-fix.patch
mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations-fix.patch
padata-initialize-earlier-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-rejects.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
