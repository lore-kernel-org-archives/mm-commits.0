Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCC739847
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 20:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714077539; cv=none; b=AGC5/CAy4mFGl0Mlsqj5VWlcpeOcsC/NfHczEO6tDDDBzns2DH5FvbkWY1+cX392Q4MxBluIgo6MBz0xmos56BCBq9Eu2xA+CzIIfoxc9NYu0gWuFiXt8NmcKJ9Azy3Wk6XVjt3qwWN0FK8tRqmE7pDO7+c8Ip+9GfeSfOXaLlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714077539; c=relaxed/simple;
	bh=BiPB8Jomvv4ojya++IJCcuVHzt88ipYkePRNiwc9UfE=;
	h=Date:To:From:Subject:Message-Id; b=hF5oJsfTP6hHdJOVhXLMNGaSdnQRBXzMlW/z1vQvXNJQSPuhcTZcWgX4l0aMuuPGjQaPrGWTSJr2v0cnYYjmFNXcDCqIlyIIUbxuA6VXTHk1CK/s4sp2EN0dB0vDDKyiUqdr++lhB5vtSPB3maNEbW+VVb4RvOlUx6r0rFxWbrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oC0mNv0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oC0mNv0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749AAC113CC;
	Thu, 25 Apr 2024 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714077538;
	bh=BiPB8Jomvv4ojya++IJCcuVHzt88ipYkePRNiwc9UfE=;
	h=Date:To:From:Subject:From;
	b=oC0mNv0Li4/DxZL3FL+yaPpzhUs/Mxw4on6d6aY0h20TeV+zoMCxg7Hz9SrcfdqYO
	 qrV0YLZKk8CFTGT2tjx/LdLx7YH6LJw4c5mjg8QTeNOzY8lGj5W51aXBkLXi1bwYcH
	 TMJCDkVzVEVIHWauoKdaXglxt7e7EsIqSAA9zQKc=
Date: Thu, 25 Apr 2024 13:38:57 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,shy828301@gmail.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,fengwei.yin@intel.com,david@redhat.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-avoid-split-pmd-mapped-thp-during-shrink_folio_list.patch removed from -mm tree
Message-Id: <20240425203858.749AAC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: avoid split PMD-mapped THP during shrink_folio_list()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-split-pmd-mapped-thp-during-shrink_folio_list.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/vmscan: avoid split PMD-mapped THP during shrink_folio_list()
Date: Mon, 22 Apr 2024 13:52:13 +0800

When the user no longer requires the pages, they would use
madvise(MADV_FREE) to mark the pages as lazy free.  IMO, they would not
typically rewrite to the given range.

At present, PMD-mapped THPs that are marked as lazyfree during
shrink_folio_list() are unconditionally split, which may be
unnecessary.  If the THP and its PMD are both marked as clean, and
there are no unexpected references, then we can attempt to remove the
PMD mapping from it.  This change will improve the efficiency of memory
reclamation in this case.

On an Intel i5 CPU, reclaiming 1GiB of PMD-mapped THPs using
mem_cgroup_force_empty() results in the following runtimes in seconds
(shorter is better):

--------------------------------------------
|     Old       |      New       |  Change  |
--------------------------------------------
|   0.683426    |    0.049197    |  -92.80% |
--------------------------------------------

Link: https://lkml.kernel.org/r/20240422055213.60231-1-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 
 include/linux/rmap.h    |    2 
 mm/huge_memory.c        |   88 ++++++++++++++++++++++++++++++++++++++
 mm/rmap.c               |    6 ++
 mm/vmscan.c             |    7 +++
 5 files changed, 105 insertions(+)

--- a/include/linux/huge_mm.h~mm-vmscan-avoid-split-pmd-mapped-thp-during-shrink_folio_list
+++ a/include/linux/huge_mm.h
@@ -36,6 +36,8 @@ bool move_huge_pmd(struct vm_area_struct
 int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		    pmd_t *pmd, unsigned long addr, pgprot_t newprot,
 		    unsigned long cp_flags);
+bool discard_trans_pmd(struct vm_area_struct *vma, unsigned long addr,
+		       struct folio *folio);
 
 vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
 vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
--- a/include/linux/rmap.h~mm-vmscan-avoid-split-pmd-mapped-thp-during-shrink_folio_list
+++ a/include/linux/rmap.h
@@ -100,6 +100,8 @@ enum ttu_flags {
 					 * do a final flush if necessary */
 	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
 					 * caller holds it */
+	TTU_LAZYFREE_THP	= 0x100, /* avoid splitting PMD-mapped THPs
+					  * that are marked as lazyfree. */
 };
 
 #ifdef CONFIG_MMU
--- a/mm/huge_memory.c~mm-vmscan-avoid-split-pmd-mapped-thp-during-shrink_folio_list
+++ a/mm/huge_memory.c
@@ -1810,6 +1810,94 @@ static inline void zap_deposited_table(s
 	mm_dec_nr_ptes(mm);
 }
 
+bool discard_trans_pmd(struct vm_area_struct *vma, unsigned long addr,
+		       struct folio *folio)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct mmu_notifier_range range;
+	int ref_count, map_count;
+	struct mmu_gather tlb;
+	pmd_t *pmdp, orig_pmd;
+	struct page *page;
+	bool ret = false;
+	spinlock_t *ptl;
+
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_FOLIO(folio_test_swapbacked(folio), folio);
+	VM_WARN_ON_FOLIO(!folio_test_pmd_mappable(folio), folio);
+
+	/* Perform best-effort early checks before acquiring the PMD lock */
+	if (folio_ref_count(folio) != folio_mapcount(folio) + 1 ||
+	    folio_test_dirty(folio))
+		return false;
+
+	pmdp = mm_find_pmd(mm, addr);
+	if (unlikely(!pmdp))
+		return false;
+	if (pmd_dirty(*pmdp))
+		return false;
+
+	tlb_gather_mmu(&tlb, mm);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
+				addr & HPAGE_PMD_MASK,
+				(addr & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
+
+	ptl = pmd_lock(mm, pmdp);
+	orig_pmd = *pmdp;
+	if (unlikely(!pmd_present(orig_pmd) || !pmd_trans_huge(orig_pmd)))
+		goto out;
+
+	page = pmd_page(orig_pmd);
+	if (unlikely(page_folio(page) != folio))
+		goto out;
+
+	orig_pmd = pmdp_huge_get_and_clear(mm, addr, pmdp);
+	tlb_remove_pmd_tlb_entry(&tlb, pmdp, addr);
+
+	/*
+	 * Syncing against concurrent GUP-fast:
+	 * - clear PMD; barrier; read refcount
+	 * - inc refcount; barrier; read PMD
+	 */
+	smp_mb();
+
+	ref_count = folio_ref_count(folio);
+	map_count = folio_mapcount(folio);
+
+	/*
+	 * Order reads for folio refcount and dirty flag
+	 * (see comments in __remove_mapping()).
+	 */
+	smp_rmb();
+
+	/*
+	 * If the PMD or folio is redirtied at this point, or if there are
+	 * unexpected references, we will give up to discard this folio
+	 * and remap it.
+	 *
+	 * The only folio refs must be one from isolation plus the rmap(s).
+	 */
+	if (ref_count != map_count + 1 || folio_test_dirty(folio) ||
+	    pmd_dirty(orig_pmd)) {
+		set_pmd_at(mm, addr, pmdp, orig_pmd);
+		goto out;
+	}
+
+	folio_remove_rmap_pmd(folio, page, vma);
+	zap_deposited_table(mm, pmdp);
+	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+	folio_put(folio);
+	ret = true;
+
+out:
+	spin_unlock(ptl);
+	mmu_notifier_invalidate_range_end(&range);
+
+	return ret;
+}
+
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
--- a/mm/rmap.c~mm-vmscan-avoid-split-pmd-mapped-thp-during-shrink_folio_list
+++ a/mm/rmap.c
@@ -1631,6 +1631,12 @@ static bool try_to_unmap_one(struct foli
 	if (flags & TTU_SYNC)
 		pvmw.flags = PVMW_SYNC;
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (flags & TTU_LAZYFREE_THP)
+		if (discard_trans_pmd(vma, address, folio))
+			return true;
+#endif
+
 	if (flags & TTU_SPLIT_HUGE_PMD)
 		split_huge_pmd_address(vma, address, false, folio);
 
--- a/mm/vmscan.c~mm-vmscan-avoid-split-pmd-mapped-thp-during-shrink_folio_list
+++ a/mm/vmscan.c
@@ -1260,6 +1260,13 @@ retry:
 
 			if (folio_test_pmd_mappable(folio))
 				flags |= TTU_SPLIT_HUGE_PMD;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			if (folio_test_anon(folio) && !was_swapbacked &&
+			    (flags & TTU_SPLIT_HUGE_PMD))
+				flags |= TTU_LAZYFREE_THP;
+#endif
+
 			/*
 			 * Without TTU_SYNC, try_to_unmap will only begin to
 			 * hold PTL from the first present PTE within a large
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-madvise-introduce-clear_young_dirty_ptes-batch-helper.patch
mm-arm64-override-clear_young_dirty_ptes-batch-helper.patch
mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch.patch
mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch

