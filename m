Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4029B142E86
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854730; cv=none; b=FJRsk3M/l+TJo16D3jZaino5t/riuxusCX00LwDq9ktvmbQs8xpBAZkozt8wBbYAiMQloEFi7SDTawbwMT2uHq5wN2nYD2u0u7iAWBbEqS4+oi6Szlp2YVHKV/w4SFlbqX+gQso8JUo9RsIrMbV+b4dsnlv9otnkBos32bZBsI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854730; c=relaxed/simple;
	bh=TYg9piFWwzzg3agSPKsNnisH5IxLZMDJHeOrsxBX03k=;
	h=Date:To:From:Subject:Message-Id; b=SeLhMV03mOt8ac8w2ozG706/wZobElmJETZ/rgI9xSOYCUzt4dErPuMl/+561VSYXnR0mdGxLvOm2OEW+OoFPZoCdJjuPE8NK1RjNbhwLYPeUbQKrf1l77ad6R+6QYeakJp+/ggHKAWF91NVcYspB57qCKC4da6OGSeDqND9RPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kduLCFwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kduLCFwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31F8C4CECF;
	Wed,  6 Nov 2024 00:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854729;
	bh=TYg9piFWwzzg3agSPKsNnisH5IxLZMDJHeOrsxBX03k=;
	h=Date:To:From:Subject:From;
	b=kduLCFwjtaIr2sySWaD8vIFYB5ZYn/fBHQfJXY1LwsvQTLc0Im/KewD/S9t3Km69/
	 3F65eepNBPcDjUsjk+/J/fWUhkSJiD9VGOVv/CtJYMHW6HVqOvZ/M6ytEkYTAFHl2W
	 vWoU0nUpOM8vTb1ngnFOhdIR1zd4MbCZYD+sm6WE=
Date: Tue, 05 Nov 2024 16:58:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-adjust_pte-use-pte_offset_map_rw_nolock.patch removed from -mm tree
Message-Id: <20241106005849.C31F8C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm: adjust_pte() use pte_offset_map_rw_nolock()
has been removed from the -mm tree.  Its filename was
     arm-adjust_pte-use-pte_offset_map_rw_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: arm: adjust_pte() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:18 +0800

In do_adjust_pte(), we may modify the pte entry.  The corresponding pmd
entry may have been modified concurrently.  Therefore, in order to ensure
the stability if pmd entry, use pte_offset_map_rw_nolock() to replace
pte_offset_map_nolock(), and do pmd_same() check after holding the PTL.

All callers of update_mmu_cache_range() hold the vmf->ptl, so we can
determined whether split PTE locks is being used by doing the following,
just as we do elsewhere in the kernel.

	ptl != vmf->ptl

And then we can delete the do_pte_lock() and do_pte_unlock().

Link: https://lkml.kernel.org/r/0eaf6b69aeb2fe35092a633fed12537efe645303.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault-armv.c |   53 +++++++++++++++----------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

--- a/arch/arm/mm/fault-armv.c~arm-adjust_pte-use-pte_offset_map_rw_nolock
+++ a/arch/arm/mm/fault-armv.c
@@ -61,32 +61,8 @@ static int do_adjust_pte(struct vm_area_
 	return ret;
 }
 
-#if defined(CONFIG_SPLIT_PTE_PTLOCKS)
-/*
- * If we are using split PTE locks, then we need to take the page
- * lock here.  Otherwise we are using shared mm->page_table_lock
- * which is already locked, thus cannot take it.
- */
-static inline void do_pte_lock(spinlock_t *ptl)
-{
-	/*
-	 * Use nested version here to indicate that we are already
-	 * holding one similar spinlock.
-	 */
-	spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
-}
-
-static inline void do_pte_unlock(spinlock_t *ptl)
-{
-	spin_unlock(ptl);
-}
-#else /* !defined(CONFIG_SPLIT_PTE_PTLOCKS) */
-static inline void do_pte_lock(spinlock_t *ptl) {}
-static inline void do_pte_unlock(spinlock_t *ptl) {}
-#endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
-
 static int adjust_pte(struct vm_area_struct *vma, unsigned long address,
-	unsigned long pfn)
+		      unsigned long pfn, struct vm_fault *vmf)
 {
 	spinlock_t *ptl;
 	pgd_t *pgd;
@@ -94,6 +70,7 @@ static int adjust_pte(struct vm_area_str
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	pmd_t pmdval;
 	int ret;
 
 	pgd = pgd_offset(vma->vm_mm, address);
@@ -112,20 +89,33 @@ static int adjust_pte(struct vm_area_str
 	if (pmd_none_or_clear_bad(pmd))
 		return 0;
 
+again:
 	/*
 	 * This is called while another page table is mapped, so we
 	 * must use the nested version.  This also means we need to
 	 * open-code the spin-locking.
 	 */
-	pte = pte_offset_map_nolock(vma->vm_mm, pmd, address, &ptl);
+	pte = pte_offset_map_rw_nolock(vma->vm_mm, pmd, address, &pmdval, &ptl);
 	if (!pte)
 		return 0;
 
-	do_pte_lock(ptl);
+	/*
+	 * If we are using split PTE locks, then we need to take the page
+	 * lock here.  Otherwise we are using shared mm->page_table_lock
+	 * which is already locked, thus cannot take it.
+	 */
+	if (ptl != vmf->ptl) {
+		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+		if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
+			pte_unmap_unlock(pte, ptl);
+			goto again;
+		}
+	}
 
 	ret = do_adjust_pte(vma, address, pfn, pte);
 
-	do_pte_unlock(ptl);
+	if (ptl != vmf->ptl)
+		spin_unlock(ptl);
 	pte_unmap(pte);
 
 	return ret;
@@ -133,7 +123,8 @@ static int adjust_pte(struct vm_area_str
 
 static void
 make_coherent(struct address_space *mapping, struct vm_area_struct *vma,
-	unsigned long addr, pte_t *ptep, unsigned long pfn)
+	      unsigned long addr, pte_t *ptep, unsigned long pfn,
+	      struct vm_fault *vmf)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *mpnt;
@@ -160,7 +151,7 @@ make_coherent(struct address_space *mapp
 		if (!(mpnt->vm_flags & VM_MAYSHARE))
 			continue;
 		offset = (pgoff - mpnt->vm_pgoff) << PAGE_SHIFT;
-		aliases += adjust_pte(mpnt, mpnt->vm_start + offset, pfn);
+		aliases += adjust_pte(mpnt, mpnt->vm_start + offset, pfn, vmf);
 	}
 	flush_dcache_mmap_unlock(mapping);
 	if (aliases)
@@ -203,7 +194,7 @@ void update_mmu_cache_range(struct vm_fa
 		__flush_dcache_folio(mapping, folio);
 	if (mapping) {
 		if (cache_is_vivt())
-			make_coherent(mapping, vma, addr, ptep, pfn);
+			make_coherent(mapping, vma, addr, ptep, pfn, vmf);
 		else if (vma->vm_flags & VM_EXEC)
 			__flush_icache_all();
 	}
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


