Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAD215359A
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714666315; cv=none; b=UqZbiyB5zAdAeccWWLrlBiQXXBK5dZ7CHY0V2YaHLDb3tpW8LD6jakgvFcnABgPcbLXKeng9ymS1G0TKoZ13+3IiSMNIVzJZgaymlpO+oG/4opwrv+Wx43/R+4smmj28fgafkqYGW2buPhvIM4KgVnZcmduEuMvjJrV2AgD1p1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714666315; c=relaxed/simple;
	bh=/T+pkM8k1medLGOeJon8F6uhahjA6AN3/18A3lSel40=;
	h=Date:To:From:Subject:Message-Id; b=b9RIKyHhbxDJaOdUPDveNW0WX9UKTqrsPNNuznotnSN3yEq0qE1vYtclMxcGo0QeswwMOjGfAiyHyvvszGLru/pHDkPRX8TcXP1idifcpcBHi00XkjvrVeasGiQr5U0kBhJzlf4ooQmOSYPh+h7g5s7K7X4NDQoidVKurzT6WKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ic6FO0c8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ic6FO0c8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58608C32789;
	Thu,  2 May 2024 16:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714666314;
	bh=/T+pkM8k1medLGOeJon8F6uhahjA6AN3/18A3lSel40=;
	h=Date:To:From:Subject:From;
	b=ic6FO0c8B8/gduLxawCcgRAKQSf/5v1+MPmGqdm7tdLoYYbfKEMuMVm74HIx7CpC9
	 QZAvGdwpKBM/Os94AiXRn5C8rZbaceP1ypiAyzqSrGF7u3b0EMQykJ92uqlBkb0/SR
	 F0co0EpWwvFVReAfuuRVpXRbjk7G6TiQbImW2DjA=
Date: Thu, 02 May 2024 09:11:53 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,fengwei.yin@intel.com,david@redhat.com,21cnbao@gmail.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch added to mm-unstable branch
Message-Id: <20240502161154.58608C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: avoid split lazyfree THP during shrink_folio_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/vmscan: avoid split lazyfree THP during shrink_folio_list()
Date: Wed, 1 May 2024 12:27:00 +0800

When the user no longer requires the pages, they would use
madvise(MADV_FREE) to mark the pages as lazy free.  Subsequently, they
typically would not re-write to that memory again.

During memory reclaim, if we detect that the large folio and its PMD are
both still marked as clean and there are no unexpected references (such as
GUP), so we can just discard the memory lazily, improving the efficiency
of memory reclamation in this case.  On an Intel i5 CPU, reclaiming 1GiB
of lazyfree THPs using mem_cgroup_force_empty() results in the following
runtimes in seconds (shorter is better):

--------------------------------------------
|     Old       |      New       |  Change  |
--------------------------------------------
|   0.683426    |    0.049197    |  -92.80% |
--------------------------------------------

Link: https://lkml.kernel.org/r/20240501042700.83974-4-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: SeongJae Park <sj@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    9 ++++
 mm/huge_memory.c        |   73 ++++++++++++++++++++++++++++++++++++++
 mm/rmap.c               |    3 +
 3 files changed, 85 insertions(+)

--- a/include/linux/huge_mm.h~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list
+++ a/include/linux/huge_mm.h
@@ -411,6 +411,8 @@ static inline bool thp_migration_support
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze, struct folio *folio);
+bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
+			   pmd_t *pmdp, struct folio *folio);
 
 static inline void align_huge_pmd_range(struct vm_area_struct *vma,
 					unsigned long *start,
@@ -492,6 +494,13 @@ static inline void align_huge_pmd_range(
 					unsigned long *start,
 					unsigned long *end) {}
 
+static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
+					 unsigned long addr, pmd_t *pmdp,
+					 struct folio *folio)
+{
+	return false;
+}
+
 #define split_huge_pud(__vma, __pmd, __address)	\
 	do { } while (0)
 
--- a/mm/huge_memory.c~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list
+++ a/mm/huge_memory.c
@@ -2689,6 +2689,79 @@ static void unmap_folio(struct folio *fo
 	try_to_unmap_flush();
 }
 
+static bool __discard_trans_pmd_locked(struct vm_area_struct *vma,
+				       unsigned long addr, pmd_t *pmdp,
+				       struct folio *folio)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int ref_count, map_count;
+	pmd_t orig_pmd = *pmdp;
+	struct mmu_gather tlb;
+	struct page *page;
+
+	if (pmd_dirty(orig_pmd) || folio_test_dirty(folio))
+		return false;
+	if (unlikely(!pmd_present(orig_pmd) || !pmd_trans_huge(orig_pmd)))
+		return false;
+
+	page = pmd_page(orig_pmd);
+	if (unlikely(page_folio(page) != folio))
+		return false;
+
+	tlb_gather_mmu(&tlb, mm);
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
+		return false;
+	}
+
+	folio_remove_rmap_pmd(folio, page, vma);
+	zap_deposited_table(mm, pmdp);
+	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+	folio_put(folio);
+
+	return true;
+}
+
+bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
+			   pmd_t *pmdp, struct folio *folio)
+{
+	VM_WARN_ON_FOLIO(!folio_test_pmd_mappable(folio), folio);
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE(!IS_ALIGNED(addr, HPAGE_PMD_SIZE));
+
+	if (folio_test_anon(folio) && !folio_test_swapbacked(folio))
+		return __discard_trans_pmd_locked(vma, addr, pmdp, folio);
+
+	return false;
+}
+
 static void remap_page(struct folio *folio, unsigned long nr)
 {
 	int i = 0;
--- a/mm/rmap.c~mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list
+++ a/mm/rmap.c
@@ -1676,6 +1676,9 @@ static bool try_to_unmap_one(struct foli
 		}
 
 		if (!pvmw.pte && (flags & TTU_SPLIT_HUGE_PMD)) {
+			if (unmap_huge_pmd_locked(vma, range.start, pvmw.pmd,
+						  folio))
+				goto walk_done;
 			/*
 			 * We temporarily have to drop the PTL and start once
 			 * again from that now-PTE-mapped page table.
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-madvise-introduce-clear_young_dirty_ptes-batch-helper.patch
mm-arm64-override-clear_young_dirty_ptes-batch-helper.patch
mm-memory-add-any_dirty-optional-pointer-to-folio_pte_batch.patch
mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch
mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch
mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch
mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch

