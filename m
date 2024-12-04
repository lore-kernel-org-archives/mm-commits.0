Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA3F23918D
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352782; cv=none; b=BFr0H3kBlSyOnvEqftwubxHGwm9z/ZcUfrUprJOWS8JMg0mklExWot6CAPpZRzPiIBKXlmW7C9Oc59xnVFtbF30T1iqwl1hzLKAw09XdL7knD/q7zLZyuCzZW/A30K/s3Ad1CIGjSdKIyEUiDyNRwylzJkFBZZ6S8NKZ8F9j8dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352782; c=relaxed/simple;
	bh=2aUw+iQQin/3V4gAIE2qlHk0vP47iBAvMd8DTa71u7M=;
	h=Date:To:From:Subject:Message-Id; b=Tv4neL3hl6dK9Ur6t1X8xCR5holmIDcfY9piQ0FpQzT9xlkJpTzLVNDFjWFnsEobdtVKB3wCuoIrjdV7r5UNgc+lckuEV4GU2+HA3t6WkXDUxFoWE/tnXJNUYCSVu5l42A2aHRsgFlssWkKOH4m+fEofzBVQrKjkgB2fo+5+u+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GwVAwwfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GwVAwwfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991EFC4CECD;
	Wed,  4 Dec 2024 22:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733352781;
	bh=2aUw+iQQin/3V4gAIE2qlHk0vP47iBAvMd8DTa71u7M=;
	h=Date:To:From:Subject:From;
	b=GwVAwwfQY/Xkd9IeTPOhqWRbP0jiyGEn3YGY9SyUFv0IY9itLWHrOlhH9zo5+j7Yl
	 mbzWXOIyrsJwzo+WUvPfcvLQvmJvlKWTE3avVoKgHf02fMvrgCwAsYfxIRoajDSHvP
	 7BJre7RwQHd8wxylh0iGQjvPTe8OSIQOV63Mf9ck=
Date: Wed, 04 Dec 2024 14:53:01 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch added to mm-unstable branch
Message-Id: <20241204225301.991EFC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: recheck pmd state in retract_page_tables()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch

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
@@ -947,17 +947,10 @@ static int hugepage_vma_revalidate(struc
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
@@ -971,6 +964,17 @@ static int find_pmd_or_thp_or_none(struc
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
@@ -1720,7 +1724,7 @@ static void retract_page_tables(struct a
 		pmd_t *pmd, pgt_pmd;
 		spinlock_t *pml;
 		spinlock_t *ptl;
-		bool skipped_uffd = false;
+		bool success = false;
 
 		/*
 		 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
@@ -1757,6 +1761,19 @@ static void retract_page_tables(struct a
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
@@ -1770,20 +1787,20 @@ static void retract_page_tables(struct a
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

mm-pgtable-make-ptep_clear-non-atomic.patch
mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch

