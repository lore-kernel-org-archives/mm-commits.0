Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F282877C3
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 22:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762296934; cv=none; b=DoZQtf10Grx87UfXHKKrzdga6hlvUtBrH9b/KXa2L0ubhAD8CLhtnb/7JbxsxM3OSyggCzOg0ZmOOth6bzjJ3WkV0f4Ha+xbFjbgtdwnKBmnU6VHi+VbHs7gGDWwbzF3vJdF/K1eW7Sfgd5vIyXTUyVlQels6REQO+Y4hvtDUuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762296934; c=relaxed/simple;
	bh=l4zXPQBsuUQzK3mOTAYErcHOb5LV3QOqU64ERrg/Wt4=;
	h=Date:To:From:Subject:Message-Id; b=ksyKzOeXSsXTgsO+FIbgCjd4NvdG1/BW9j43RUrUjDS4y27q1+o3Xw65nvJsJNa+8XygPi4v415hbty5wZ66hrB318tFQlZwUl89i3oFTaha2JbwP+Meiv60Q7XMaXSqoLFf8R7IX+AJ8jQM1EYVD9wn61GtC1f1xk+/IjwqgvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HFFi16k2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HFFi16k2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12948C4CEF7;
	Tue,  4 Nov 2025 22:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762296934;
	bh=l4zXPQBsuUQzK3mOTAYErcHOb5LV3QOqU64ERrg/Wt4=;
	h=Date:To:From:Subject:From;
	b=HFFi16k2FOAjD+87zqurwQSlXR044JdOGNrtWEV6f916WqYUwafgfg3biE48OF3Wq
	 bdlDyUn3RpbPqW8ktVhmDXyilyfZv+2RL6lvukmiZgt1G9CGjpuix6UBg6LVWAlMuX
	 p4hJS+kiWU9mzOtN5ookG8jm4IPJKZdvGy8NAmhk=
Date: Tue, 04 Nov 2025 14:55:33 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma.patch added to mm-new branch
Message-Id: <20251104225534.12948C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kill mm_wr_locked from unmap_vmas() and unmap_single_vma()
has been added to the -mm mm-new branch.  Its filename is
     mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kill mm_wr_locked from unmap_vmas() and unmap_single_vma()
Date: Tue, 4 Nov 2025 16:57:09 +0800

Kill mm_wr_locked since commit f8e97613fed2 ("mm: convert VM_PFNMAP
tracking to pfnmap_track() + pfnmap_untrack()") remove the user.

Link: https://lkml.kernel.org/r/20251104085709.2688433-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
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
@@ -2473,7 +2473,7 @@ static inline void zap_vma_pages(struct
 }
 void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		struct vm_area_struct *start_vma, unsigned long start,
-		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
+		unsigned long end, unsigned long tree_end);
 
 struct mmu_notifier_range;
 
--- a/mm/memory.c~mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma
+++ a/mm/memory.c
@@ -2026,8 +2026,7 @@ void unmap_page_range(struct mmu_gather
 
 static void unmap_single_vma(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr,
-		struct zap_details *details, bool mm_wr_locked)
+		unsigned long end_addr, struct zap_details *details)
 {
 	unsigned long start = max(vma->vm_start, start_addr);
 	unsigned long end;
@@ -2073,7 +2072,6 @@ static void unmap_single_vma(struct mmu_
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
  * @tree_end: The maximum index to check
- * @mm_wr_locked: lock flag
  *
  * Unmap all pages in the vma list.
  *
@@ -2088,8 +2086,7 @@ static void unmap_single_vma(struct mmu_
  */
 void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr, unsigned long tree_end,
-		bool mm_wr_locked)
+		unsigned long end_addr, unsigned long tree_end)
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
@@ -2105,8 +2102,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 		unsigned long start = start_addr;
 		unsigned long end = end_addr;
 		hugetlb_zap_begin(vma, &start, &end);
-		unmap_single_vma(tlb, vma, start, end, &details,
-				 mm_wr_locked);
+		unmap_single_vma(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
 		vma = mas_find(mas, tree_end - 1);
 	} while (vma && likely(!xa_is_zero(vma)));
@@ -2142,7 +2138,7 @@ void zap_page_range_single_batched(struc
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

mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch
mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch
mm-mprotect-convert-to-folio_can_map_prot_numa.patch
mm-huge_memory-use-folio_can_map_prot_numa-for-pmd-folio.patch
mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma.patch

