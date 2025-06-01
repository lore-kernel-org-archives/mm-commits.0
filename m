Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAA61411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756845; cv=none; b=bs4PW+hB3jujyxQTpHv0iuui2oJUJsTJ2SSqIZRXgGxl3obHkhxtedbCyrymhwpinhVTHu2lhwB6gGdM99d5t6IR94kXqNyNEbDqA1vBdiWdKGEhZhcr0Cy9fT5xXJorWDzRQiv92j72G+nn37TRQ+PY0aupqeFqLECIMnKvZ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756845; c=relaxed/simple;
	bh=FZn06227g9EiojhbLdbfj67D7nF2lfuehA0q0L3CqVc=;
	h=Date:To:From:Subject:Message-Id; b=OEvRBFb+CaKhe1hcQTbkq/wmxPfH0tKipMbOHo1Sqjp0HsBh5uc23M9LSatBowts1gjPtg6qeOM6n25bRCShbi9BbaqhatdkA5zvMbO9NHU+1w+1h60sJWXomAqP0mheY3Fl8dMfNMsGTe00diHgpt8rPYf7Rqp8FRL8qosKzjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r5imDeca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r5imDeca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC51FC4CEED;
	Sun,  1 Jun 2025 05:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756844;
	bh=FZn06227g9EiojhbLdbfj67D7nF2lfuehA0q0L3CqVc=;
	h=Date:To:From:Subject:From;
	b=r5imDecakevjWp7F71QTxIkOdLXAuHaTAp1cJiMcdgKrEzcKzNCQYWyju7XzO4KkB
	 DAMfu/BvOxjMaoDVQufY7MjseO0+rj5hG1Y2R3m+Ict8M2MSXtQtwihuEDvJ/3IJUE
	 4E6R6ZueioboT943NAFIcSOPFpuuwhA6EhM5x+9c=
Date: Sat, 31 May 2025 22:47:24 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,peterz@infradead.org,npiggin@gmail.com,jannh@google.com,hughd@google.com,aneesh.kumar@kernel.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables.patch removed from -mm tree
Message-Id: <20250601054724.CC51FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mmu_gather: move tlb flush for VM_PFNMAP/VM_MIXEDMAP vmas into free_pgtables()
has been removed from the -mm tree.  Its filename was
     mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mmu_gather: move tlb flush for VM_PFNMAP/VM_MIXEDMAP vmas into free_pgtables()
Date: Thu, 22 May 2025 01:28:38 +0000

Commit b67fbebd4cf9 ("mmu_gather: Force tlb-flush VM_PFNMAP vmas") added a
forced tlbflush to tlb_vma_end(), which is required to avoid a race
between munmap() and unmap_mapping_range().  However it added some
overhead to other paths where tlb_vma_end() is used, but vmas are not
removed, e.g.  madvise(MADV_DONTNEED).

Fix this by moving the tlb flush out of tlb_end_vma() into new
tlb_flush_vmas() called from free_pgtables(), somewhat similar to the
stable version of the original commit: commit 895428ee124a ("mm: Force TLB
flush for PFNMAP mappings before unlink_file_vma()").

Note, that if tlb->fullmm is set, no flush is required, as the whole mm is
about to be destroyed.

Link: https://lkml.kernel.org/r/20250522012838.163876-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nick Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |   48 +++++++++++++++++++++++++++---------
 mm/memory.c               |    2 +
 mm/mmu_gather.c           |    1 
 3 files changed, 40 insertions(+), 11 deletions(-)

--- a/include/asm-generic/tlb.h~mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables
+++ a/include/asm-generic/tlb.h
@@ -58,6 +58,11 @@
  *    Defaults to flushing at tlb_end_vma() to reset the range; helps when
  *    there's large holes between the VMAs.
  *
+ *  - tlb_free_vmas()
+ *
+ *    tlb_free_vmas() marks the start of unlinking of one or more vmas
+ *    and freeing page-tables.
+ *
  *  - tlb_remove_table()
  *
  *    tlb_remove_table() is the basic primitive to free page-table directories
@@ -464,7 +469,12 @@ tlb_update_vma_flags(struct mmu_gather *
 	 */
 	tlb->vma_huge = is_vm_hugetlb_page(vma);
 	tlb->vma_exec = !!(vma->vm_flags & VM_EXEC);
-	tlb->vma_pfn  = !!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP));
+
+	/*
+	 * Track if there's at least one VM_PFNMAP/VM_MIXEDMAP vma
+	 * in the tracked range, see tlb_free_vmas().
+	 */
+	tlb->vma_pfn |= !!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP));
 }
 
 static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
@@ -548,22 +558,38 @@ static inline void tlb_start_vma(struct
 
 static inline void tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
 {
+	if (tlb->fullmm || IS_ENABLED(CONFIG_MMU_GATHER_MERGE_VMAS))
+		return;
+
+	/*
+	 * Do a TLB flush and reset the range at VMA boundaries; this avoids
+	 * the ranges growing with the unused space between consecutive VMAs,
+	 * but also the mmu_gather::vma_* flags from tlb_start_vma() rely on
+	 * this.
+	 */
+	tlb_flush_mmu_tlbonly(tlb);
+}
+
+static inline void tlb_free_vmas(struct mmu_gather *tlb)
+{
 	if (tlb->fullmm)
 		return;
 
 	/*
 	 * VM_PFNMAP is more fragile because the core mm will not track the
-	 * page mapcount -- there might not be page-frames for these PFNs after
-	 * all. Force flush TLBs for such ranges to avoid munmap() vs
-	 * unmap_mapping_range() races.
-	 */
-	if (tlb->vma_pfn || !IS_ENABLED(CONFIG_MMU_GATHER_MERGE_VMAS)) {
-		/*
-		 * Do a TLB flush and reset the range at VMA boundaries; this avoids
-		 * the ranges growing with the unused space between consecutive VMAs.
-		 */
+	 * page mapcount -- there might not be page-frames for these PFNs
+	 * after all.
+	 *
+	 * Specifically() there is a race between munmap() and
+	 * unmap_mapping_range(), where munmap() will unlink the VMA, such
+	 * that unmap_mapping_range() will no longer observe the VMA and
+	 * no-op, without observing the TLBI, returning prematurely.
+	 *
+	 * So if we're about to unlink such a VMA, and we have pending
+	 * TLBI for such a vma, flush things now.
+	 */
+	if (tlb->vma_pfn)
 		tlb_flush_mmu_tlbonly(tlb);
-	}
 }
 
 /*
--- a/mm/memory.c~mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables
+++ a/mm/memory.c
@@ -358,6 +358,8 @@ void free_pgtables(struct mmu_gather *tl
 {
 	struct unlink_vma_file_batch vb;
 
+	tlb_free_vmas(tlb);
+
 	do {
 		unsigned long addr = vma->vm_start;
 		struct vm_area_struct *next;
--- a/mm/mmu_gather.c~mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables
+++ a/mm/mmu_gather.c
@@ -424,6 +424,7 @@ static void __tlb_gather_mmu(struct mmu_
 #ifdef CONFIG_MMU_GATHER_PAGE_SIZE
 	tlb->page_size = 0;
 #endif
+	tlb->vma_pfn = 0;
 
 	__tlb_reset_range(tlb);
 	inc_tlb_flush_pending(tlb->mm);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


