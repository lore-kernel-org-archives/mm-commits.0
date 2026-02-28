Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEC92139C9
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 20:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772308948; cv=none; b=PLKrnY3B3aFM0i0ojaFEPwI/L5l2C3fizaMSopORgb/t5Ww2F1x0YcnDCTzrmIljxOZPf0AR7jseolukBylQN+21McU5FaAsP3YVlJTabxE4PlHJXk4g/2VXYEawDnycGUBC5xDyXkGMg9IycVdMphqfhXJTTAigIMYimikV/9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772308948; c=relaxed/simple;
	bh=sFkUB5ubSsAAOb6ou7CoJE3wB5fwPwX/l6hk+vyEejg=;
	h=Date:To:From:Subject:Message-Id; b=vBBWxsCYEoDz9UDXGVblsvlCHSLw7t5lmZEYjhgRzsWBp45UwdDcMWzf3XzStpABwMVEvRiVuNMekNAMesJEU1RrOX5u9YwrL8O9n+R1JlpGsvl4xpw+zkVrJU8Y9eDjfr9hPXKRI98tUJ1nN36aF055A921KtwopDQQwU2HOBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ppyU5aMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ppyU5aMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AA0C116D0;
	Sat, 28 Feb 2026 20:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772308947;
	bh=sFkUB5ubSsAAOb6ou7CoJE3wB5fwPwX/l6hk+vyEejg=;
	h=Date:To:From:Subject:From;
	b=ppyU5aMja6Q8T3KVrfpCZSMPe+GO834/rxOdSuxF47bHYOkz8hSYeLodhkTuihadW
	 kSFoSUNgilvOGlRPW4UhYAryX9aYGAExPPQmF86elern2+/W/z8M2IaBGwjT8OvTBr
	 BiyS/Dod0dnGdALG70SLg3tY8oichlEF8Lf+dY+w=
Date: Sat, 28 Feb 2026 12:02:27 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-batched-checking-of-the-young-flag-for-mglru.patch added to mm-new branch
Message-Id: <20260228200227.C2AA0C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: support batched checking of the young flag for MGLRU
has been added to the -mm mm-new branch.  Its filename is
     mm-support-batched-checking-of-the-young-flag-for-mglru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-batched-checking-of-the-young-flag-for-mglru.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: support batched checking of the young flag for MGLRU
Date: Fri, 27 Feb 2026 17:44:39 +0800

Use the batched helper test_and_clear_young_ptes_notify() to check and
clear the young flag to improve the performance during large folio
reclamation when MGLRU is enabled.

Meanwhile, we can also support batched checking the young and dirty flag
when MGLRU walks the mm's pagetable to update the folios' generation
counter.  Since MGLRU also checks the PTE dirty bit, use
folio_pte_batch_flags() with FPB_MERGE_YOUNG_DIRTY set to detect batches
of PTEs for a large folio.

Then we can remove the ptep_test_and_clear_young_notify() since it has no
users now.

Note that we also update the 'young' counter and 'mm_stats[MM_LEAF_YOUNG]'
counter with the batched count in the lru_gen_look_around() and
walk_pte_range().  However, the batched operations may inflate these two
counters, because in a large folio not all PTEs may have been accessed. 
(Additionally, tracking how many PTEs have been accessed within a large
folio is not very meaningful, since the mm core actually tracks
access/dirty on a per-folio basis, not per page).  The impact analysis is
as follows:

1. The 'mm_stats[MM_LEAF_YOUNG]' counter has no functional impact and
   is mainly for debugging.

2. The 'young' counter is used to decide whether to place the current
   PMD entry into the bloom filters by suitable_to_scan() (so that next
   time we can check whether it has been accessed again), which may set
   the hash bit in the bloom filters for a PMD entry that hasn't seen much
   access.  However, bloom filters inherently allow some error, so this
   effect appears negligible.

Link: https://lkml.kernel.org/r/f84233f95f209d59c3bc9c72a757af09337f0d40.1772185080.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 ++--
 mm/internal.h          |    6 -----
 mm/rmap.c              |   28 ++++++++++++------------
 mm/vmscan.c            |   44 +++++++++++++++++++++++++++++----------
 4 files changed, 50 insertions(+), 33 deletions(-)

--- a/include/linux/mmzone.h~mm-support-batched-checking-of-the-young-flag-for-mglru
+++ a/include/linux/mmzone.h
@@ -684,7 +684,7 @@ struct lru_gen_memcg {
 
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
-bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -706,7 +706,8 @@ static inline void lru_gen_init_lruvec(s
 {
 }
 
-static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw,
+		unsigned int nr)
 {
 	return false;
 }
--- a/mm/internal.h~mm-support-batched-checking-of-the-young-flag-for-mglru
+++ a/mm/internal.h
@@ -1851,10 +1851,4 @@ static inline int pmdp_test_and_clear_yo
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
-static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
-{
-	return test_and_clear_young_ptes_notify(vma, addr, ptep, 1);
-}
-
 #endif	/* __MM_INTERNAL_H */
--- a/mm/rmap.c~mm-support-batched-checking-of-the-young-flag-for-mglru
+++ a/mm/rmap.c
@@ -958,25 +958,21 @@ static bool folio_referenced_one(struct
 			return false;
 		}
 
+		if (pvmw.pte && folio_test_large(folio)) {
+			const unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
+			const unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
+			pte_t pteval = ptep_get(pvmw.pte);
+
+			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
+			ptes += nr;
+		}
+
 		if (lru_gen_enabled() && pvmw.pte) {
-			if (lru_gen_look_around(&pvmw))
+			if (lru_gen_look_around(&pvmw, nr))
 				referenced++;
 		} else if (pvmw.pte) {
-			if (folio_test_large(folio)) {
-				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
-				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
-				pte_t pteval = ptep_get(pvmw.pte);
-
-				nr = folio_pte_batch(folio, pvmw.pte,
-						     pteval, max_nr);
-			}
-
-			ptes += nr;
 			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
 				referenced++;
-			/* Skip the batched PTEs */
-			pvmw.pte += nr - 1;
-			pvmw.address += (nr - 1) * PAGE_SIZE;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -995,6 +991,10 @@ static bool folio_referenced_one(struct
 			page_vma_mapped_walk_done(&pvmw);
 			break;
 		}
+
+		/* Skip the batched PTEs */
+		pvmw.pte += nr - 1;
+		pvmw.address += (nr - 1) * PAGE_SIZE;
 	}
 
 	if (referenced)
--- a/mm/vmscan.c~mm-support-batched-checking-of-the-young-flag-for-mglru
+++ a/mm/vmscan.c
@@ -3479,6 +3479,7 @@ static bool walk_pte_range(pmd_t *pmd, u
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
+	unsigned int nr;
 	pmd_t pmdval;
 
 	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
@@ -3497,11 +3498,13 @@ static bool walk_pte_range(pmd_t *pmd, u
 
 	lazy_mmu_mode_enable();
 restart:
-	for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
+	for (i = pte_index(start), addr = start; addr != end; i += nr, addr += nr * PAGE_SIZE) {
 		unsigned long pfn;
 		struct folio *folio;
-		pte_t ptent = ptep_get(pte + i);
+		pte_t *cur_pte = pte + i;
+		pte_t ptent = ptep_get(cur_pte);
 
+		nr = 1;
 		total++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
@@ -3513,7 +3516,16 @@ restart:
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young_notify(args->vma, addr, pte + i))
+		if (folio_test_large(folio)) {
+			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
+
+			nr = folio_pte_batch_flags(folio, NULL, cur_pte, &ptent,
+						   max_nr, FPB_MERGE_YOUNG_DIRTY);
+			total += nr - 1;
+			walk->mm_stats[MM_LEAF_TOTAL] += nr - 1;
+		}
+
+		if (!test_and_clear_young_ptes_notify(args->vma, addr, cur_pte, nr))
 			continue;
 
 		if (last != folio) {
@@ -3526,8 +3538,8 @@ restart:
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
-		walk->mm_stats[MM_LEAF_YOUNG]++;
+		young += nr;
+		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
@@ -4171,7 +4183,7 @@ static void lru_gen_age_node(struct pgli
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
-bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 {
 	int i;
 	bool dirty;
@@ -4189,12 +4201,13 @@ bool lru_gen_look_around(struct page_vma
 	struct lruvec *lruvec;
 	struct lru_gen_mm_state *mm_state;
 	unsigned long max_seq;
+	pte_t *cur_pte;
 	int gen;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
-	if (!ptep_test_and_clear_young_notify(vma, addr, pte))
+	if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
 		return false;
 
 	if (spin_is_contended(pvmw->ptl))
@@ -4234,10 +4247,12 @@ bool lru_gen_look_around(struct page_vma
 
 	pte -= (addr - start) / PAGE_SIZE;
 
-	for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
+	for (i = 0, addr = start, cur_pte = pte; addr != end;
+	     i += nr, cur_pte += nr, addr += nr * PAGE_SIZE) {
 		unsigned long pfn;
-		pte_t ptent = ptep_get(pte + i);
+		pte_t ptent = ptep_get(cur_pte);
 
+		nr = 1;
 		pfn = get_pte_pfn(ptent, vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
@@ -4246,7 +4261,14 @@ bool lru_gen_look_around(struct page_vma
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young_notify(vma, addr, pte + i))
+		if (folio_test_large(folio)) {
+			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
+
+			nr = folio_pte_batch_flags(folio, NULL, cur_pte, &ptent,
+						   max_nr, FPB_MERGE_YOUNG_DIRTY);
+		}
+
+		if (!test_and_clear_young_ptes_notify(vma, addr, cur_pte, nr))
 			continue;
 
 		if (last != folio) {
@@ -4259,7 +4281,7 @@ bool lru_gen_look_around(struct page_vma
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
+		young += nr;
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-use-inline-helper-functions-instead-of-ugly-macros.patch
mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch
mm-rmap-add-a-zone_device-folio-warning-in-folio_referenced.patch
mm-add-a-batched-helper-to-clear-the-young-flag-for-large-folios.patch
mm-support-batched-checking-of-the-young-flag-for-mglru.patch
arm64-mm-implement-the-architecture-specific-test_and_clear_young_ptes.patch

