Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4B7142E86
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854732; cv=none; b=Nmo8KPG5IyK6kxI5AMXz9NUZcbVRo1MD2VS86dOqll2q5CssC2eBBG2l5GzQ/AoPQvfdeqhd/9Tyi46fJCybxzlfcr4yKKDHwNiDgwWQx8rb7kYmXSg8e3rbCeeraRcY20XSf+I+fVep/h2QE4tdlKeppuJ3tb7kqytFNBmtPYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854732; c=relaxed/simple;
	bh=lFPkp8RfUtb/NZlcJCvpGrUZejuZau/xFAAKITu+Mpw=;
	h=Date:To:From:Subject:Message-Id; b=qggYwB3IyxP4IyzNZQukQ97fM4WDtbUJ7QHgEmqQ4ECI2Jl3IYVpAoyWDlWWNrQVilsVZyDifqHYXVNzUPVC0gZeEBOKch0DtLdqISda6lLRrtEGa1ukqQvgCwNW76jkGDC/ZT8ZxnBuaXZ/B+UUyAYB7ATshFfMSUg1lUTELsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dWYtaLmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dWYtaLmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E15C4CECF;
	Wed,  6 Nov 2024 00:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854732;
	bh=lFPkp8RfUtb/NZlcJCvpGrUZejuZau/xFAAKITu+Mpw=;
	h=Date:To:From:Subject:From;
	b=dWYtaLmVe6n6SjU6U5TQEVSU7VADpVN8OBsHvmuG20ZQnMHLnMTkvH7sao7t2gYAZ
	 13F1T3Ty9/qxQXTOrLg06It1zuwqQaRaToJ4cKSWZGZOQ0aXwaVZAnZaPWpeONntfy
	 jc1spAiVIAnfdEIrrtaFMre3qiAOomSronCvrB/I=
Date: Tue, 05 Nov 2024 16:58:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch removed from -mm tree
Message-Id: <20241106005852.A1E15C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: collapse_pte_mapped_thp() use pte_offset_map_rw_nolock()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-collapse_pte_mapped_thp-use-pte_offset_map_rw_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


