Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22DA53BE
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738008662; cv=none; b=CBZ3PzhXbPpln9r+9npUdAw5asvUuct6neVX6UHRPX7E93D09on/R/V+EA2HL8SIquga3942lvluNyzkOqG91PC+g2Q+Tq3LppMJm3xEb5U+oWMaTC6Z6G3miQNMa5h/Mchwsss9jPnX9lVIBfWUK2t+iyikq0rXQLkAIHM7l14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738008662; c=relaxed/simple;
	bh=iK7RcDBQkiTxLt4Jyvm2BWKi33dd95RjJIXFx4xH3bQ=;
	h=Date:To:From:Subject:Message-Id; b=iwQeQ21Zgbi95/t0/IKdOlVvdhNLajKQd4aOxrdVgQ8wjMC415CYB3iKJ2JI5VAFCoJSejDzYhYGbSiLrJbhmUmBIbtKPeMnGntIIstg0eg+8bfQe33s5NXhyRBi405Ec9W3SDSL1gLX+SW7I0Rmf0hTEy6mRbJ5/2wGjqzmUEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NN6gF2+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NN6gF2+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A10C4CED2;
	Mon, 27 Jan 2025 20:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738008662;
	bh=iK7RcDBQkiTxLt4Jyvm2BWKi33dd95RjJIXFx4xH3bQ=;
	h=Date:To:From:Subject:From;
	b=NN6gF2+epKGNn58EWlH1Mh0Wl0IgrfLSmr7/UQcA2W/qJDKzVPyxMwzYZUffJN6vQ
	 480vNiWvg3ftYLH3BWuIxh/DKlb3E/DI9AZ765IBs5DleM8P3A6uRHPfgcC2uLKwo6
	 hpIuu3MbPbxlmBg8EWsjxvAEMh4vwXbFnEUqznDY=
Date: Mon, 27 Jan 2025 12:11:01 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,peterz@infradead.org,npiggin@gmail.com,jannh@google.com,hughd@google.com,aneesh.kumar@kernel.org,akpm@linux-foundation.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables.patch added to mm-unstable branch
Message-Id: <20250127201102.45A10C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mmu_gather: move tlb flush for VM_PFNMAP/VM_MIXEDMAP vmas into free_pgtables()
has been added to the -mm mm-unstable branch.  Its filename is
     mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Mon, 27 Jan 2025 19:53:21 +0000

Commit b67fbebd4cf9 ("mmu_gather: Force tlb-flush VM_PFNMAP vmas") added a
forced tlbflush to tlb_vma_end(), which is required to avoid a race
between munmap() and unmap_mapping_range().  However it added some
overhead to other paths where tlb_vma_end() is used, but vmas are not
removed, e.g.  madvise(MADV_DONTNEED).

Fix this by moving the tlb flush out of tlb_end_vma() into
free_pgtables(), somewhat similar to the stable version of the original
commit: e.g.  stable commit 895428ee124a ("mm: Force TLB flush for PFNMAP
mappings before unlink_file_vma()").

Note, that if tlb->fullmm is set, no flush is required, as the whole mm is
about to be destroyed.

Link: https://lkml.kernel.org/r/20250127195321.35779-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |   51 ++++++++++++++++++++++++++++--------
 mm/memory.c               |    2 +
 2 files changed, 42 insertions(+), 11 deletions(-)

--- a/include/asm-generic/tlb.h~mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables
+++ a/include/asm-generic/tlb.h
@@ -58,6 +58,11 @@
  *    Defaults to flushing at tlb_end_vma() to reset the range; helps when
  *    there's large holes between the VMAs.
  *
+ *  - tlb_free_vma()
+ *
+ *    tlb_free_vma() marks the start of unlinking the vma and freeing
+ *    page-tables.
+ *
  *  - tlb_remove_table()
  *
  *    tlb_remove_table() is the basic primitive to free page-table directories
@@ -400,7 +405,10 @@ static inline void __tlb_reset_range(str
 	 * Do not reset mmu_gather::vma_* fields here, we do not
 	 * call into tlb_start_vma() again to set them if there is an
 	 * intermediate flush.
+	 *
+	 * Except for vma_pfn, that only cares if there's pending TLBI.
 	 */
+	tlb->vma_pfn = 0;
 }
 
 #ifdef CONFIG_MMU_GATHER_NO_RANGE
@@ -465,7 +473,12 @@ tlb_update_vma_flags(struct mmu_gather *
 	 */
 	tlb->vma_huge = is_vm_hugetlb_page(vma);
 	tlb->vma_exec = !!(vma->vm_flags & VM_EXEC);
-	tlb->vma_pfn  = !!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP));
+
+	/*
+	 * Track if there's at least one VM_PFNMAP/VM_MIXEDMAP vma
+	 * in the tracked range, see tlb_free_vma().
+	 */
+	tlb->vma_pfn |= !!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP));
 }
 
 static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
@@ -565,22 +578,38 @@ static inline void tlb_start_vma(struct
 
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
+static inline void tlb_free_vma(struct mmu_gather *tlb, struct vm_area_struct *vma)
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
+	if ((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) && tlb->vma_pfn)
 		tlb_flush_mmu_tlbonly(tlb);
-	}
 }
 
 /*
--- a/mm/memory.c~mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables
+++ a/mm/memory.c
@@ -378,6 +378,7 @@ void free_pgtables(struct mmu_gather *tl
 		if (unlikely(xa_is_zero(next)))
 			next = NULL;
 
+		tlb_free_vma(tlb, vma);
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
 		 * pgtables
@@ -403,6 +404,7 @@ void free_pgtables(struct mmu_gather *tl
 				next = mas_find(mas, ceiling - 1);
 				if (unlikely(xa_is_zero(next)))
 					next = NULL;
+				tlb_free_vma(tlb, vma);
 				if (mm_wr_locked)
 					vma_start_write(vma);
 				unlink_anon_vmas(vma);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mmu_gather-move-tlb-flush-for-vm_pfnmap-vm_mixedmap-vmas-into-free_pgtables.patch

