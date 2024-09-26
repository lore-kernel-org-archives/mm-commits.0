Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397FE13CABC
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727382760; cv=none; b=BnlsauBEDN+OzdtnKm7dOBw4NoADEoPJAz7zlpSsCJwKg/d+XjhB7aM6dSEEaUv2fJ5PJrFryN01+Doh3jmXkZEbT7o75n12rrVHIaCzqMfN2t5KuPOSubtOSIYbWn5maQs/FyKmaMM7pTY6bY3NGlnI9LzN2DeUypWT0IqVGDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727382760; c=relaxed/simple;
	bh=RYbEFE28Y3HtumUVrlMK4DnT4gPdfoHg9pF1SOAwbeM=;
	h=Date:To:From:Subject:Message-Id; b=GcllNb1BdleRrWbGKPr7HeKbTGye0yD7igQLbAHa0UfBiMtZgYE14+PoqaP8T0Erv8pl022jCYCAH7dXqW5jYD5pBwVGm9OmND8ev0J8V4ZnBnz5j9M5oWV/PLaBdXU6RqUM9u/odg+ydll9DlL5O5AmGP9nA+daIb85fuouVIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I10Zr8GC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I10Zr8GC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3BFC4CEC5;
	Thu, 26 Sep 2024 20:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727382760;
	bh=RYbEFE28Y3HtumUVrlMK4DnT4gPdfoHg9pF1SOAwbeM=;
	h=Date:To:From:Subject:From;
	b=I10Zr8GC3fOLFT4ngrze23+A05wWomRNaI+p4mJHcfJ5tu/qs7qHDhoPsIiH2b1IE
	 /Poe8gdaw9RQDoobYE8+y4k1M40ds/xELkbvl82mJRbSkms+Vn5TA3wAB+4Tx1ohMV
	 gSFEy7avYpO4Uz8L/tGiiwwIMX6QeT30SAjvhWpc=
Date: Thu, 26 Sep 2024 13:32:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch added to mm-unstable branch
Message-Id: <20240926203240.0F3BFC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: collapse_pte_mapped_thp() use pte_offset_map_rw_nolock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: khugepaged: collapse_pte_mapped_thp() use pte_offset_map_rw_nolock()
Date: Thu, 26 Sep 2024 14:46:20 +0800

In collapse_pte_mapped_thp(), we may modify the pte and pmd entry after
acquiring the ptl, so convert it to using pte_offset_map_rw_nolock().  At
this time, the pte_same() check is not performed after the PTL held.  So
we should get pgt_pmd and do pmd_same() check after the ptl held.

Link: https://lkml.kernel.org/r/055e42db68da00ac8ecab94bd2633c7cd965eb1c.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock
+++ a/mm/khugepaged.c
@@ -1608,7 +1608,7 @@ int collapse_pte_mapped_thp(struct mm_st
 	if (userfaultfd_armed(vma) && !(vma->vm_flags & VM_SHARED))
 		pml = pmd_lock(mm, pmd);
 
-	start_pte = pte_offset_map_nolock(mm, pmd, haddr, &ptl);
+	start_pte = pte_offset_map_rw_nolock(mm, pmd, haddr, &pgt_pmd, &ptl);
 	if (!start_pte)		/* mmap_lock + page lock should prevent this */
 		goto abort;
 	if (!pml)
@@ -1616,6 +1616,9 @@ int collapse_pte_mapped_thp(struct mm_st
 	else if (ptl != pml)
 		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
 
+	if (unlikely(!pmd_same(pgt_pmd, pmdp_get_lockless(pmd))))
+		goto abort;
+
 	/* step 2: clear page table and adjust rmap */
 	for (i = 0, addr = haddr, pte = start_pte;
 	     i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE, pte++) {
@@ -1648,7 +1651,6 @@ int collapse_pte_mapped_thp(struct mm_st
 		nr_ptes++;
 	}
 
-	pte_unmap(start_pte);
 	if (!pml)
 		spin_unlock(ptl);
 
@@ -1661,14 +1663,19 @@ int collapse_pte_mapped_thp(struct mm_st
 	/* step 4: remove empty page table */
 	if (!pml) {
 		pml = pmd_lock(mm, pmd);
-		if (ptl != pml)
+		if (ptl != pml) {
 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+			if (unlikely(!pmd_same(pgt_pmd, pmdp_get_lockless(pmd)))) {
+				flush_tlb_mm(mm);
+				goto unlock;
+			}
+		}
 	}
 	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
 	pmdp_get_lockless_sync();
+	pte_unmap_unlock(start_pte, ptl);
 	if (ptl != pml)
-		spin_unlock(ptl);
-	spin_unlock(pml);
+		spin_unlock(pml);
 
 	mmu_notifier_invalidate_range_end(&range);
 
@@ -1688,6 +1695,7 @@ abort:
 		folio_ref_sub(folio, nr_ptes);
 		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
 	}
+unlock:
 	if (start_pte)
 		pte_unmap_unlock(start_pte, ptl);
 	if (pml && pml != ptl)
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-introduce-pte_offset_map_rorw_nolock.patch
powerpc-assert_pte_locked-use-pte_offset_map_ro_nolock.patch
mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch
mm-khugepaged-__collapse_huge_page_swapin-use-pte_offset_map_ro_nolock.patch
arm-adjust_pte-use-pte_offset_map_rw_nolock.patch
mm-handle_pte_fault-use-pte_offset_map_rw_nolock.patch
mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch
mm-copy_pte_range-use-pte_offset_map_rw_nolock.patch
mm-mremap-move_ptes-use-pte_offset_map_rw_nolock.patch
mm-page_vma_mapped_walk-map_pte-use-pte_offset_map_rw_nolock.patch
mm-userfaultfd-move_pages_pte-use-pte_offset_map_rw_nolock.patch
mm-multi-gen-lru-walk_pte_range-use-pte_offset_map_rw_nolock.patch
mm-pgtable-remove-pte_offset_map_nolock.patch

