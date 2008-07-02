From: akpm@linux-foundation.org
Subject: - spufs-convert-nopfn-to-fault.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:04 -0700
Message-ID: <200807020747.m627l4ZI005621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbYGBHrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:47:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, benh@kernel.crashing.org, jk@ozlabs.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     spufs: convert nopfn to fault
has been removed from the -mm tree.  Its filename was
     spufs-convert-nopfn-to-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spufs: convert nopfn to fault
From: Nick Piggin <npiggin@suse.de>

spufs: convert nopfn to fault

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c     |   98 ++++++++---------
 arch/powerpc/platforms/cell/spufs/sputrace.c |    8 -
 2 files changed, 54 insertions(+), 52 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~spufs-convert-nopfn-to-fault arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~spufs-convert-nopfn-to-fault
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -238,11 +238,13 @@ spufs_mem_write(struct file *file, const
 	return size;
 }
 
-static unsigned long spufs_mem_mmap_nopfn(struct vm_area_struct *vma,
-					  unsigned long address)
+static int
+spufs_mem_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct spu_context *ctx	= vma->vm_file->private_data;
-	unsigned long pfn, offset, addr0 = address;
+	unsigned long address = (unsigned long)vmf->virtual_address;
+	unsigned long pfn, offset;
+
 #ifdef CONFIG_SPU_FS_64K_LS
 	struct spu_state *csa = &ctx->csa;
 	int psize;
@@ -260,15 +262,15 @@ static unsigned long spufs_mem_mmap_nopf
 	}
 #endif /* CONFIG_SPU_FS_64K_LS */
 
-	offset = (address - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= LS_SIZE)
-		return NOPFN_SIGBUS;
+		return VM_FAULT_SIGBUS;
 
-	pr_debug("spufs_mem_mmap_nopfn address=0x%lx -> 0x%lx, offset=0x%lx\n",
-		 addr0, address, offset);
+	pr_debug("spufs_mem_mmap_fault address=0x%lx, offset=0x%lx\n",
+			address, offset);
 
 	if (spu_acquire(ctx))
-		return NOPFN_REFAULT;
+		return VM_FAULT_NOPAGE;
 
 	if (ctx->state == SPU_STATE_SAVED) {
 		vma->vm_page_prot = __pgprot(pgprot_val(vma->vm_page_prot)
@@ -283,12 +285,12 @@ static unsigned long spufs_mem_mmap_nopf
 
 	spu_release(ctx);
 
-	return NOPFN_REFAULT;
+	return VM_FAULT_NOPAGE;
 }
 
 
 static struct vm_operations_struct spufs_mem_mmap_vmops = {
-	.nopfn = spufs_mem_mmap_nopfn,
+	.fault = spufs_mem_mmap_fault,
 };
 
 static int spufs_mem_mmap(struct file *file, struct vm_area_struct *vma)
@@ -351,20 +353,19 @@ static const struct file_operations spuf
 #endif
 };
 
-static unsigned long spufs_ps_nopfn(struct vm_area_struct *vma,
-				    unsigned long address,
+static int spufs_ps_fault(struct vm_area_struct *vma,
+				    struct vm_fault *vmf,
 				    unsigned long ps_offs,
 				    unsigned long ps_size)
 {
 	struct spu_context *ctx = vma->vm_file->private_data;
-	unsigned long area, offset = address - vma->vm_start;
+	unsigned long area, offset = vmf->pgoff << PAGE_SHIFT;
 	int ret = 0;
 
-	spu_context_nospu_trace(spufs_ps_nopfn__enter, ctx);
+	spu_context_nospu_trace(spufs_ps_fault__enter, ctx);
 
-	offset += vma->vm_pgoff << PAGE_SHIFT;
 	if (offset >= ps_size)
-		return NOPFN_SIGBUS;
+		return VM_FAULT_SIGBUS;
 
 	/*
 	 * Because we release the mmap_sem, the context may be destroyed while
@@ -378,7 +379,7 @@ static unsigned long spufs_ps_nopfn(stru
 	 * pages to hand out to the user, but we don't want to wait
 	 * with the mmap_sem held.
 	 * It is possible to drop the mmap_sem here, but then we need
-	 * to return NOPFN_REFAULT because the mappings may have
+	 * to return VM_FAULT_NOPAGE because the mappings may have
 	 * hanged.
 	 */
 	if (spu_acquire(ctx))
@@ -386,14 +387,15 @@ static unsigned long spufs_ps_nopfn(stru
 
 	if (ctx->state == SPU_STATE_SAVED) {
 		up_read(&current->mm->mmap_sem);
-		spu_context_nospu_trace(spufs_ps_nopfn__sleep, ctx);
+		spu_context_nospu_trace(spufs_ps_fault__sleep, ctx);
 		ret = spufs_wait(ctx->run_wq, ctx->state == SPU_STATE_RUNNABLE);
-		spu_context_trace(spufs_ps_nopfn__wake, ctx, ctx->spu);
+		spu_context_trace(spufs_ps_fault__wake, ctx, ctx->spu);
 		down_read(&current->mm->mmap_sem);
 	} else {
 		area = ctx->spu->problem_phys + ps_offs;
-		vm_insert_pfn(vma, address, (area + offset) >> PAGE_SHIFT);
-		spu_context_trace(spufs_ps_nopfn__insert, ctx, ctx->spu);
+		vm_insert_pfn(vma, (unsigned long)vmf->virtual_address,
+					(area + offset) >> PAGE_SHIFT);
+		spu_context_trace(spufs_ps_fault__insert, ctx, ctx->spu);
 	}
 
 	if (!ret)
@@ -401,18 +403,18 @@ static unsigned long spufs_ps_nopfn(stru
 
 refault:
 	put_spu_context(ctx);
-	return NOPFN_REFAULT;
+	return VM_FAULT_NOPAGE;
 }
 
 #if SPUFS_MMAP_4K
-static unsigned long spufs_cntl_mmap_nopfn(struct vm_area_struct *vma,
-					   unsigned long address)
+static int spufs_cntl_mmap_fault(struct vm_area_struct *vma,
+					   struct vm_fault *vmf)
 {
-	return spufs_ps_nopfn(vma, address, 0x4000, 0x1000);
+	return spufs_ps_fault(vma, vmf, 0x4000, 0x1000);
 }
 
 static struct vm_operations_struct spufs_cntl_mmap_vmops = {
-	.nopfn = spufs_cntl_mmap_nopfn,
+	.fault = spufs_cntl_mmap_fault,
 };
 
 /*
@@ -1097,23 +1099,23 @@ static ssize_t spufs_signal1_write(struc
 	return 4;
 }
 
-static unsigned long spufs_signal1_mmap_nopfn(struct vm_area_struct *vma,
-					      unsigned long address)
+static int
+spufs_signal1_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 #if PAGE_SIZE == 0x1000
-	return spufs_ps_nopfn(vma, address, 0x14000, 0x1000);
+	return spufs_ps_fault(vma, vmf, 0x14000, 0x1000);
 #elif PAGE_SIZE == 0x10000
 	/* For 64k pages, both signal1 and signal2 can be used to mmap the whole
 	 * signal 1 and 2 area
 	 */
-	return spufs_ps_nopfn(vma, address, 0x10000, 0x10000);
+	return spufs_ps_fault(vma, vmf, 0x10000, 0x10000);
 #else
 #error unsupported page size
 #endif
 }
 
 static struct vm_operations_struct spufs_signal1_mmap_vmops = {
-	.nopfn = spufs_signal1_mmap_nopfn,
+	.fault = spufs_signal1_mmap_fault,
 };
 
 static int spufs_signal1_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1234,23 +1236,23 @@ static ssize_t spufs_signal2_write(struc
 }
 
 #if SPUFS_MMAP_4K
-static unsigned long spufs_signal2_mmap_nopfn(struct vm_area_struct *vma,
-					      unsigned long address)
+static int
+spufs_signal2_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 #if PAGE_SIZE == 0x1000
-	return spufs_ps_nopfn(vma, address, 0x1c000, 0x1000);
+	return spufs_ps_fault(vma, vmf, 0x1c000, 0x1000);
 #elif PAGE_SIZE == 0x10000
 	/* For 64k pages, both signal1 and signal2 can be used to mmap the whole
 	 * signal 1 and 2 area
 	 */
-	return spufs_ps_nopfn(vma, address, 0x10000, 0x10000);
+	return spufs_ps_fault(vma, vmf, 0x10000, 0x10000);
 #else
 #error unsupported page size
 #endif
 }
 
 static struct vm_operations_struct spufs_signal2_mmap_vmops = {
-	.nopfn = spufs_signal2_mmap_nopfn,
+	.fault = spufs_signal2_mmap_fault,
 };
 
 static int spufs_signal2_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1362,14 +1364,14 @@ DEFINE_SPUFS_ATTRIBUTE(spufs_signal2_typ
 		       spufs_signal2_type_set, "%llu\n", SPU_ATTR_ACQUIRE);
 
 #if SPUFS_MMAP_4K
-static unsigned long spufs_mss_mmap_nopfn(struct vm_area_struct *vma,
-					  unsigned long address)
+static int
+spufs_mss_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return spufs_ps_nopfn(vma, address, 0x0000, 0x1000);
+	return spufs_ps_fault(vma, vmf, 0x0000, 0x1000);
 }
 
 static struct vm_operations_struct spufs_mss_mmap_vmops = {
-	.nopfn = spufs_mss_mmap_nopfn,
+	.fault = spufs_mss_mmap_fault,
 };
 
 /*
@@ -1424,14 +1426,14 @@ static const struct file_operations spuf
 	.mmap	 = spufs_mss_mmap,
 };
 
-static unsigned long spufs_psmap_mmap_nopfn(struct vm_area_struct *vma,
-					    unsigned long address)
+static int
+spufs_psmap_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return spufs_ps_nopfn(vma, address, 0x0000, 0x20000);
+	return spufs_ps_fault(vma, vmf, 0x0000, 0x20000);
 }
 
 static struct vm_operations_struct spufs_psmap_mmap_vmops = {
-	.nopfn = spufs_psmap_mmap_nopfn,
+	.fault = spufs_psmap_mmap_fault,
 };
 
 /*
@@ -1484,14 +1486,14 @@ static const struct file_operations spuf
 
 
 #if SPUFS_MMAP_4K
-static unsigned long spufs_mfc_mmap_nopfn(struct vm_area_struct *vma,
-					  unsigned long address)
+static int
+spufs_mfc_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return spufs_ps_nopfn(vma, address, 0x3000, 0x1000);
+	return spufs_ps_fault(vma, vmf, 0x3000, 0x1000);
 }
 
 static struct vm_operations_struct spufs_mfc_mmap_vmops = {
-	.nopfn = spufs_mfc_mmap_nopfn,
+	.fault = spufs_mfc_mmap_fault,
 };
 
 /*
diff -puN arch/powerpc/platforms/cell/spufs/sputrace.c~spufs-convert-nopfn-to-fault arch/powerpc/platforms/cell/spufs/sputrace.c
--- a/arch/powerpc/platforms/cell/spufs/sputrace.c~spufs-convert-nopfn-to-fault
+++ a/arch/powerpc/platforms/cell/spufs/sputrace.c
@@ -182,10 +182,10 @@ struct spu_probe spu_probes[] = {
 	{ "spu_yield__enter", "ctx %p", spu_context_nospu_event },
 	{ "spu_deactivate__enter", "ctx %p", spu_context_nospu_event },
 	{ "__spu_deactivate__unload", "ctx %p spu %p", spu_context_event },
-	{ "spufs_ps_nopfn__enter", "ctx %p", spu_context_nospu_event },
-	{ "spufs_ps_nopfn__sleep", "ctx %p", spu_context_nospu_event },
-	{ "spufs_ps_nopfn__wake", "ctx %p spu %p", spu_context_event },
-	{ "spufs_ps_nopfn__insert", "ctx %p spu %p", spu_context_event },
+	{ "spufs_ps_fault__enter", "ctx %p", spu_context_nospu_event },
+	{ "spufs_ps_fault__sleep", "ctx %p", spu_context_nospu_event },
+	{ "spufs_ps_fault__wake", "ctx %p spu %p", spu_context_event },
+	{ "spufs_ps_fault__insert", "ctx %p spu %p", spu_context_event },
 	{ "spu_acquire_saved__enter", "ctx %p", spu_context_nospu_event },
 	{ "destroy_spu_context__enter", "ctx %p", spu_context_nospu_event },
 	{ "spufs_stop_callback__enter", "ctx %p spu %p", spu_context_event },
_

Patches currently in -mm which might be from npiggin@suse.de are

get_user_pages-fix-possible-page-leak-on-oom.patch
linux-next.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-nopfn-fix.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-cleanup.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-new-sysfs-interface-fix-2.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
hugetlb-introduce-pud_huge-s390-fix.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-override-default-huge-page-size-ia64-build.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

