Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF97A172BD5
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006283; cv=none; b=nEFDCMBYAM/jm+sWrs43ZTM3dS0WZaJmN5Gja8KhQjHjuTIEFXlPXy3qGUUYpzsoRwwvwhOkjefD/XWL5oBKRVLJlCf402xnWu0248zu6x82jAsEe+afNx/XE3206wmkRRcZbIEY+4U+HERsEp0acD+kHERsYoAqbvP15F2zzaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006283; c=relaxed/simple;
	bh=1IgqcTpq0obD9fmX6hEESZBE1viXg6xnaRfO298jGpw=;
	h=Date:To:From:Subject:Message-Id; b=WOMjPw/bQUohnc5mMvhYJrLspgwVX1lIhNKQOBFHJaJEfM8cTWQTA3DStFz9dfccWu1EhK1AwVS+IUmXC/mRn8/wJjcSSYvXtw+9skPNlB0D6Gw8m3skyXk7w37gtL7SQbv5xs1tjE07BCaGkvUuv59d3+/RjVBWtzelQNJvcqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VBd0lAan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VBd0lAan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACB1C4CED6;
	Thu, 16 Jan 2025 05:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006283;
	bh=1IgqcTpq0obD9fmX6hEESZBE1viXg6xnaRfO298jGpw=;
	h=Date:To:From:Subject:From;
	b=VBd0lAanKjQcH/1LIP6//zzfNu4ky+ihJZUA7bRTwC8N/a6+ey1onc5g9CP/FHNQN
	 7VdkO59Pe0rGZ68BKksyLZp/Dm3VrtPsoaP41mflU/Hxi+MAFx6tVsFEqrhAxc3TKQ
	 jf3P0l9zQiIrORxUxRlJUJQqq8Qkg17TnuvEvzEw=
Date: Wed, 15 Jan 2025 21:44:43 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,stevensd@chromium.org,kasong@tencent.com,kaleshsingh@google.com,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-fix-pte-mapped-large-folios.patch removed from -mm tree
Message-Id: <20250116054443.9ACB1C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: fix PTE-mapped large folios
has been removed from the -mm tree.  Its filename was
     mm-mglru-fix-pte-mapped-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: fix PTE-mapped large folios
Date: Mon, 30 Dec 2024 21:35:38 -0700

Count the accessed bits from PTEs mapping the same large folio as one
access rather than multiple accesses.

The last patch changed how folios accessed through page tables are
promoted: rather than getting promoted after the accessed bit is cleared
for the first time, a folio only gets promoted thereafter.  Counting the
accessed bits from the same large folio as multiple accesses can cause
that folio to be promoted prematurely, which in turn can cause
overprotection of single-use large folios.

This patch reduced the sys time of the kernel compilation by 95% CI [2,
5]% on Altra M128-30 with 3GB DRAM, 12GB zram, 16KB THPs and -j32.

Link: https://lkml.kernel.org/r/20241231043538.4075764-8-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Barry Song <v-songbaohua@oppo.com>
Tested-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  108 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 71 insertions(+), 37 deletions(-)

--- a/mm/vmscan.c~mm-mglru-fix-pte-mapped-large-folios
+++ a/mm/vmscan.c
@@ -3423,29 +3423,55 @@ static bool suitable_to_scan(int total,
 	return young * n >= total;
 }
 
+static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
+			      int new_gen, bool dirty)
+{
+	int old_gen;
+
+	if (!folio)
+		return;
+
+	if (dirty && !folio_test_dirty(folio) &&
+	    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
+	      !folio_test_swapcache(folio)))
+		folio_mark_dirty(folio);
+
+	if (walk) {
+		old_gen = folio_update_gen(folio, new_gen);
+		if (old_gen >= 0 && old_gen != new_gen)
+			update_batch_size(walk, folio, old_gen, new_gen);
+	} else if (lru_gen_set_refs(folio)) {
+		old_gen = folio_lru_gen(folio);
+		if (old_gen >= 0 && old_gen != new_gen)
+			folio_activate(folio);
+	}
+}
+
 static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
 {
 	int i;
+	bool dirty;
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned long addr;
 	int total = 0;
 	int young = 0;
+	struct folio *last = NULL;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
-	int old_gen, new_gen = lru_gen_from_seq(max_seq);
+	int gen = lru_gen_from_seq(max_seq);
 	pmd_t pmdval;
 
-	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval,
-				       &ptl);
+	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
 	if (!pte)
 		return false;
+
 	if (!spin_trylock(ptl)) {
 		pte_unmap(pte);
-		return false;
+		return true;
 	}
 
 	if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
@@ -3474,19 +3500,23 @@ restart:
 		if (!ptep_clear_young_notify(args->vma, addr, pte + i))
 			continue;
 
-		young++;
-		walk->mm_stats[MM_LEAF_YOUNG]++;
+		if (last != folio) {
+			walk_update_folio(walk, last, gen, dirty);
 
-		if (pte_dirty(ptent) && !folio_test_dirty(folio) &&
-		    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
-		      !folio_test_swapcache(folio)))
-			folio_mark_dirty(folio);
+			last = folio;
+			dirty = false;
+		}
 
-		old_gen = folio_update_gen(folio, new_gen);
-		if (old_gen >= 0 && old_gen != new_gen)
-			update_batch_size(walk, folio, old_gen, new_gen);
+		if (pte_dirty(ptent))
+			dirty = true;
+
+		young++;
+		walk->mm_stats[MM_LEAF_YOUNG]++;
 	}
 
+	walk_update_folio(walk, last, gen, dirty);
+	last = NULL;
+
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
 		goto restart;
 
@@ -3500,13 +3530,15 @@ static void walk_pmd_range_locked(pud_t
 				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
 {
 	int i;
+	bool dirty;
 	pmd_t *pmd;
 	spinlock_t *ptl;
+	struct folio *last = NULL;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
-	int old_gen, new_gen = lru_gen_from_seq(max_seq);
+	int gen = lru_gen_from_seq(max_seq);
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3559,20 +3591,23 @@ static void walk_pmd_range_locked(pud_t
 		if (!pmdp_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
-		walk->mm_stats[MM_LEAF_YOUNG]++;
+		if (last != folio) {
+			walk_update_folio(walk, last, gen, dirty);
 
-		if (pmd_dirty(pmd[i]) && !folio_test_dirty(folio) &&
-		    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
-		      !folio_test_swapcache(folio)))
-			folio_mark_dirty(folio);
+			last = folio;
+			dirty = false;
+		}
 
-		old_gen = folio_update_gen(folio, new_gen);
-		if (old_gen >= 0 && old_gen != new_gen)
-			update_batch_size(walk, folio, old_gen, new_gen);
+		if (pmd_dirty(pmd[i]))
+			dirty = true;
+
+		walk->mm_stats[MM_LEAF_YOUNG]++;
 next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
+	walk_update_folio(walk, last, gen, dirty);
+
 	arch_leave_lazy_mmu_mode();
 	spin_unlock(ptl);
 done:
@@ -4107,9 +4142,11 @@ static void lru_gen_age_node(struct pgli
 bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
 	int i;
+	bool dirty;
 	unsigned long start;
 	unsigned long end;
 	struct lru_gen_mm_walk *walk;
+	struct folio *last = NULL;
 	int young = 1;
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
@@ -4120,7 +4157,7 @@ bool lru_gen_look_around(struct page_vma
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
-	int old_gen, new_gen = lru_gen_from_seq(max_seq);
+	int gen = lru_gen_from_seq(max_seq);
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
@@ -4174,24 +4211,21 @@ bool lru_gen_look_around(struct page_vma
 		if (!ptep_clear_young_notify(vma, addr, pte + i))
 			continue;
 
-		young++;
+		if (last != folio) {
+			walk_update_folio(walk, last, gen, dirty);
 
-		if (pte_dirty(ptent) && !folio_test_dirty(folio) &&
-		    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
-		      !folio_test_swapcache(folio)))
-			folio_mark_dirty(folio);
-
-		if (walk) {
-			old_gen = folio_update_gen(folio, new_gen);
-			if (old_gen >= 0 && old_gen != new_gen)
-				update_batch_size(walk, folio, old_gen, new_gen);
-		} else if (lru_gen_set_refs(folio)) {
-			old_gen = folio_lru_gen(folio);
-			if (old_gen >= 0 && old_gen != new_gen)
-				folio_activate(folio);
+			last = folio;
+			dirty = false;
 		}
+
+		if (pte_dirty(ptent))
+			dirty = true;
+
+		young++;
 	}
 
+	walk_update_folio(walk, last, gen, dirty);
+
 	arch_leave_lazy_mmu_mode();
 
 	/* feedback from rmap walkers to page table walkers */
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-fix-memory-loads-ordering.patch

