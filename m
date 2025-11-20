Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406AC34D3AA
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675077; cv=none; b=GCU/iNJlWy4H4BKWj/hZCXtxEt8n48JxpyllRHZ1ORvWw+wapJA54uvjtVSElfbJVEm3dOriuDBzzyBRRc3N+WM2Bp9UwekXxgrcE8ksr9ZogHou20P6W04UxY8TnqaDB1aLxZDMMpIpFX4qdlW2p8N65ZO73H9ZMOFYiq0bTA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675077; c=relaxed/simple;
	bh=D9dHp2n2I3mrlLDyvfbv1pwpNOU0E+DuMVTPPMOLNzg=;
	h=Date:To:From:Subject:Message-Id; b=o6YwEc+JvDrPxzeL8X2q9DFSdnRWa9OGEV3UopL2rgcwlILbQIZrcNPdeFkgDFUdvmrriS6NatRpWKEv/1n/7ljhAdATEUaQlqgNxrfhLTiq8Urlv5PbUCcPS1ulpFPikEjJxsrR5OSf4dfgqKy2zZFIxs/bQ1dyW7ILHF+j1g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j+dQG//b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j+dQG//b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9D1C4CEF1;
	Thu, 20 Nov 2025 21:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675076;
	bh=D9dHp2n2I3mrlLDyvfbv1pwpNOU0E+DuMVTPPMOLNzg=;
	h=Date:To:From:Subject:From;
	b=j+dQG//bmm2mK35/3kL8AEYfr+2gJIstFN3crqQuCycYxOmk2KO8HP/1bmOASYHQz
	 mmrg9hrikUst59VKyvDlxZlxMkuGNXfSrVl/sXwOi3ergC6zYg8WmWxqpK/Ji3KcJG
	 EJBHfTRS8e4QgQKmR5ELitYaMXirAQ2Zp+fzxzJ4=
Date: Thu, 20 Nov 2025 13:44:36 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma.patch removed from -mm tree
Message-Id: <20251120214436.BA9D1C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kill mm_wr_locked from unmap_vmas() and unmap_single_vma()
has been removed from the -mm tree.  Its filename was
     mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kill mm_wr_locked from unmap_vmas() and unmap_single_vma()
Date: Tue, 4 Nov 2025 16:57:09 +0800

Kill mm_wr_locked since commit f8e97613fed2 ("mm: convert VM_PFNMAP
tracking to pfnmap_track() + pfnmap_untrack()") remove the user.

Link: https://lkml.kernel.org/r/20251104085709.2688433-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |    2 +-
 mm/memory.c                      |   12 ++++--------
 mm/mmap.c                        |    2 +-
 mm/vma.c                         |    5 ++---
 tools/testing/vma/vma_internal.h |    3 +--
 5 files changed, 9 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma
+++ a/include/linux/mm.h
@@ -2480,7 +2480,7 @@ static inline void zap_vma_pages(struct
 }
 void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		struct vm_area_struct *start_vma, unsigned long start,
-		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
+		unsigned long end, unsigned long tree_end);
 
 struct mmu_notifier_range;
 
--- a/mm/memory.c~mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma
+++ a/mm/memory.c
@@ -2023,8 +2023,7 @@ void unmap_page_range(struct mmu_gather
 
 static void unmap_single_vma(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr,
-		struct zap_details *details, bool mm_wr_locked)
+		unsigned long end_addr, struct zap_details *details)
 {
 	unsigned long start = max(vma->vm_start, start_addr);
 	unsigned long end;
@@ -2070,7 +2069,6 @@ static void unmap_single_vma(struct mmu_
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
  * @tree_end: The maximum index to check
- * @mm_wr_locked: lock flag
  *
  * Unmap all pages in the vma list.
  *
@@ -2085,8 +2083,7 @@ static void unmap_single_vma(struct mmu_
  */
 void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr, unsigned long tree_end,
-		bool mm_wr_locked)
+		unsigned long end_addr, unsigned long tree_end)
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
@@ -2102,8 +2099,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 		unsigned long start = start_addr;
 		unsigned long end = end_addr;
 		hugetlb_zap_begin(vma, &start, &end);
-		unmap_single_vma(tlb, vma, start, end, &details,
-				 mm_wr_locked);
+		unmap_single_vma(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
 		vma = mas_find(mas, tree_end - 1);
 	} while (vma && likely(!xa_is_zero(vma)));
@@ -2139,7 +2135,7 @@ void zap_page_range_single_batched(struc
 	 * unmap 'address-end' not 'range.start-range.end' as range
 	 * could have been expanded for hugetlb pmd sharing.
 	 */
-	unmap_single_vma(tlb, vma, address, end, details, false);
+	unmap_single_vma(tlb, vma, address, end, details);
 	mmu_notifier_invalidate_range_end(&range);
 	if (is_vm_hugetlb_page(vma)) {
 		/*
--- a/mm/mmap.c~mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma
+++ a/mm/mmap.c
@@ -1274,7 +1274,7 @@ void exit_mmap(struct mm_struct *mm)
 	tlb_gather_mmu_fullmm(&tlb, mm);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
-	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
+	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX);
 	mmap_read_unlock(mm);
 
 	/*
--- a/mm/vma.c~mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma
+++ a/mm/vma.c
@@ -483,8 +483,7 @@ void unmap_region(struct ma_state *mas,
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
-		   /* mm_wr_locked = */ true);
+	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
@@ -1228,7 +1227,7 @@ static inline void vms_clear_ptes(struct
 	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
 	update_hiwater_rss(vms->vma->vm_mm);
 	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
-		   vms->vma_count, mm_wr_locked);
+		   vms->vma_count);
 
 	mas_set(mas_detach, 1);
 	/* start and end may be different if there is no prev or next vma. */
--- a/tools/testing/vma/vma_internal.h~mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma
+++ a/tools/testing/vma/vma_internal.h
@@ -848,8 +848,7 @@ static inline void update_hiwater_vm(str
 
 static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		      struct vm_area_struct *vma, unsigned long start_addr,
-		      unsigned long end_addr, unsigned long tree_end,
-		      bool mm_wr_locked)
+		      unsigned long end_addr, unsigned long tree_end)
 {
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


