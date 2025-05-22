Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD151E411C
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 20:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747945374; cv=none; b=XX5l/UhLPB46zNQ2DyI0B4EBL80Of3/Td8TJ1fLYEReojrx4fXY9WADPjKq3PF6ZTb/JsbTvncZoTH3rM3hu46WuAhleRjCsTuzOxOkX+V7I6LxAzULtMLRgTDxYyWm0pSewM2dM+PcJ/cdmRFGkxBOAzEZkA1SwxPNBruofZVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747945374; c=relaxed/simple;
	bh=g4Z9MBWgSW4dhf/j7npfh4qTpyb3KRDCJ6Ipiu8YXGg=;
	h=Date:To:From:Subject:Message-Id; b=ENjpd4FSUU/63RG/L41470XPEoBggbBD/AxTIJg6+ho/fVVTzhCTeLOBDSgYsNEsYh4K/k3tK2t8LVz1/ILWY2y4JSpZiFZBpfCMVXv/cS/tihHn1w3vbhDDpDlN8qDneb1WDxhFIA8f/9cM+Vi1w69sER+UP/Q0OroB50/AwrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oIgBa0wL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oIgBa0wL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B406C4CEED;
	Thu, 22 May 2025 20:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747945373;
	bh=g4Z9MBWgSW4dhf/j7npfh4qTpyb3KRDCJ6Ipiu8YXGg=;
	h=Date:To:From:Subject:From;
	b=oIgBa0wLmwSv9hCGBbYrhdfYYh3EqJbriiFpbRX64gTtMA9u+yfp1R68NGnoiJLLm
	 jVxF0OvZ4uNFndQ2wvQEek/ny12fEMVVuKrPJC8cwhY2cAtsHienhf+JfsWDF/R3EO
	 i/eORh9+ZG95b8s2niW/y1JzTytkXS0KxZD3qEK8=
Date: Thu, 22 May 2025 13:22:52 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,peterz@infradead.org,npiggin@gmail.com,jannh@google.com,hughd@google.com,aneesh.kumar@kernel.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables.patch added to mm-new branch
Message-Id: <20250522202253.7B406C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mmu_gather: move tlb flush for VM_PFNMAP/VM_MIXEDMAP vmas into free_pgtables()
has been added to the -mm mm-new branch.  Its filename is
     mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
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

mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables.patch

