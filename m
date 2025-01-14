Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B0023A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836996; cv=none; b=jn2FR4dqy6KrRQNY+awXsYoEUuKxMrJ7fgZlG93C42iPBhN23JbVfEfiwFeSpDlrPSixOBiP9o+1yiEOw+j7o0BWIBF8IjqucudbOVFAPpPV91FHDvUq+FCK2r/lzTU58W8QrkM2UiduERsmHoABW3z+lPxJ1G9GwheKJJLcMbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836996; c=relaxed/simple;
	bh=mfBGbGqGG7SEgbaxf9rIYu1XkZFiq1Gg5cD+7xdsOmY=;
	h=Date:To:From:Subject:Message-Id; b=ihr4ja7hFp6pyPUAfAKb8kCsLZNkPGuk4DUswqmTi6wUcO16uqhRsFKznsVDGUU/zGxidS3OP5mASpz8DRTZI/CQ2pgYRFNZv+TkwhUyNIkYGzT3jF1tiXb8BjRZrklUoym27NanRR6Xk0Z+KbOXmT52sVZGDBfo/Ozk4SWvqZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mxdbjUVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mxdbjUVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFFFC4CEDD;
	Tue, 14 Jan 2025 06:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836996;
	bh=mfBGbGqGG7SEgbaxf9rIYu1XkZFiq1Gg5cD+7xdsOmY=;
	h=Date:To:From:Subject:From;
	b=mxdbjUVlCieihYQ43uOyjMosiqt9dB+ir34vY/jjm25iE4Bq9V0cSBuO/wQ2qhMDj
	 AR2pnfs1RbYEKef93GIGDdqppu9eSDMVg3+Q9baDSuzCmQSU3DHzy1iSumA77r1Mf/
	 zOIZ8HE1Jqbl6sU8AfXF2ZrFIzm0xb2WJAFhryX0=
Date: Mon, 13 Jan 2025 22:43:15 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch removed from -mm tree
Message-Id: <20250114064316.2DFFFC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: recheck pmd state in retract_page_tables()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: khugepaged: recheck pmd state in retract_page_tables()
Date: Wed, 4 Dec 2024 19:09:41 +0800

Patch series "synchronously scan and reclaim empty user PTE pages", v4.

Previously, we tried to use a completely asynchronous method to reclaim
empty user PTE pages [1].  After discussing with David Hildenbrand, we
decided to implement synchronous reclaimation in the case of
madvise(MADV_DONTNEED) as the first step.

So this series aims to synchronously free the empty PTE pages in
madvise(MADV_DONTNEED) case.  We will detect and free empty PTE pages in
zap_pte_range(), and will add zap_details.reclaim_pt to exclude cases
other than madvise(MADV_DONTNEED).

In zap_pte_range(), mmu_gather is used to perform batch tlb flushing and
page freeing operations.  Therefore, if we want to free the empty PTE page
in this path, the most natural way is to add it to mmu_gather as well. 
Now, if CONFIG_MMU_GATHER_RCU_TABLE_FREE is selected, mmu_gather will free
page table pages by semi RCU:

 - batch table freeing: asynchronous free by RCU
 - single table freeing: IPI + synchronous free

But this is not enough to free the empty PTE page table pages in paths
other that munmap and exit_mmap path, because IPI cannot be synchronized
with rcu_read_lock() in pte_offset_map{_lock}().  So we should let single
table also be freed by RCU like batch table freeing.

As a first step, we supported this feature on x86_64 and selectd the newly
introduced CONFIG_ARCH_SUPPORTS_PT_RECLAIM.

For other cases such as madvise(MADV_FREE), consider scanning and freeing
empty PTE pages asynchronously in the future.

Note: issues related to TLB flushing are not new to this series and are tracked
      in the separate RFC patch [3]. And more context please refer to this
      thread [4].

[1]. https://lore.kernel.org/lkml/cover.1718267194.git.zhengqi.arch@bytedance.com/
[2]. https://lore.kernel.org/lkml/cover.1727332572.git.zhengqi.arch@bytedance.com/
[3]. https://lore.kernel.org/lkml/20240815120715.14516-1-zhengqi.arch@bytedance.com/
[4]. https://lore.kernel.org/lkml/6f38cb19-9847-4f70-bbe7-06881bb016be@bytedance.com/


This patch (of 11):

In retract_page_tables(), the lock of new_folio is still held, we will be
blocked in the page fault path, which prevents the pte entries from being
set again.  So even though the old empty PTE page may be concurrently
freed and a new PTE page is filled into the pmd entry, it is still empty
and can be removed.

So just refactor the retract_page_tables() a little bit and recheck the
pmd state after holding the pmd lock.

Link: https://lkml.kernel.org/r/cover.1733305182.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/70a51804cd19d44ccaf031825d9fb6eaf92f2bad.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/process_addrs.rst |    4 ++
 mm/khugepaged.c                    |   45 ++++++++++++++++++---------
 2 files changed, 35 insertions(+), 14 deletions(-)

--- a/Documentation/mm/process_addrs.rst~mm-khugepaged-recheck-pmd-state-in-retract_page_tables
+++ a/Documentation/mm/process_addrs.rst
@@ -531,6 +531,10 @@ are extra requirements for accessing the
   new page table has been installed in the same location and filled with
   entries. Writers normally need to take the PTE lock and revalidate that the
   PMD entry still refers to the same PTE-level page table.
+  If the writer does not care whether it is the same PTE-level page table, it
+  can take the PMD lock and revalidate that the contents of pmd entry still meet
+  the requirements. In particular, this also happens in :c:func:`!retract_page_tables`
+  when handling :c:macro:`!MADV_COLLAPSE`.
 
 To access PTE-level page tables, a helper like :c:func:`!pte_offset_map_lock` or
 :c:func:`!pte_offset_map` can be used depending on stability requirements.
--- a/mm/khugepaged.c~mm-khugepaged-recheck-pmd-state-in-retract_page_tables
+++ a/mm/khugepaged.c
@@ -948,17 +948,10 @@ static int hugepage_vma_revalidate(struc
 	return SCAN_SUCCEED;
 }
 
-static int find_pmd_or_thp_or_none(struct mm_struct *mm,
-				   unsigned long address,
-				   pmd_t **pmd)
+static inline int check_pmd_state(pmd_t *pmd)
 {
-	pmd_t pmde;
-
-	*pmd = mm_find_pmd(mm, address);
-	if (!*pmd)
-		return SCAN_PMD_NULL;
+	pmd_t pmde = pmdp_get_lockless(pmd);
 
-	pmde = pmdp_get_lockless(*pmd);
 	if (pmd_none(pmde))
 		return SCAN_PMD_NONE;
 	if (!pmd_present(pmde))
@@ -972,6 +965,17 @@ static int find_pmd_or_thp_or_none(struc
 	return SCAN_SUCCEED;
 }
 
+static int find_pmd_or_thp_or_none(struct mm_struct *mm,
+				   unsigned long address,
+				   pmd_t **pmd)
+{
+	*pmd = mm_find_pmd(mm, address);
+	if (!*pmd)
+		return SCAN_PMD_NULL;
+
+	return check_pmd_state(*pmd);
+}
+
 static int check_pmd_still_valid(struct mm_struct *mm,
 				 unsigned long address,
 				 pmd_t *pmd)
@@ -1721,7 +1725,7 @@ static void retract_page_tables(struct a
 		pmd_t *pmd, pgt_pmd;
 		spinlock_t *pml;
 		spinlock_t *ptl;
-		bool skipped_uffd = false;
+		bool success = false;
 
 		/*
 		 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
@@ -1758,6 +1762,19 @@ static void retract_page_tables(struct a
 		mmu_notifier_invalidate_range_start(&range);
 
 		pml = pmd_lock(mm, pmd);
+		/*
+		 * The lock of new_folio is still held, we will be blocked in
+		 * the page fault path, which prevents the pte entries from
+		 * being set again. So even though the old empty PTE page may be
+		 * concurrently freed and a new PTE page is filled into the pmd
+		 * entry, it is still empty and can be removed.
+		 *
+		 * So here we only need to recheck if the state of pmd entry
+		 * still meets our requirements, rather than checking pmd_same()
+		 * like elsewhere.
+		 */
+		if (check_pmd_state(pmd) != SCAN_SUCCEED)
+			goto drop_pml;
 		ptl = pte_lockptr(mm, pmd);
 		if (ptl != pml)
 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
@@ -1771,20 +1788,20 @@ static void retract_page_tables(struct a
 		 * repeating the anon_vma check protects from one category,
 		 * and repeating the userfaultfd_wp() check from another.
 		 */
-		if (unlikely(vma->anon_vma || userfaultfd_wp(vma))) {
-			skipped_uffd = true;
-		} else {
+		if (likely(!vma->anon_vma && !userfaultfd_wp(vma))) {
 			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
 			pmdp_get_lockless_sync();
+			success = true;
 		}
 
 		if (ptl != pml)
 			spin_unlock(ptl);
+drop_pml:
 		spin_unlock(pml);
 
 		mmu_notifier_invalidate_range_end(&range);
 
-		if (!skipped_uffd) {
+		if (success) {
 			mm_dec_nr_ptes(mm);
 			page_table_check_pte_clear_range(mm, addr, pgt_pmd);
 			pte_free_defer(mm, pmd_pgtable(pgt_pmd));
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


