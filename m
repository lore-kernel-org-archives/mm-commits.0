Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A7843173
	for <mm-commits@vger.kernel.org>; Thu,  2 Jan 2025 23:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735862284; cv=none; b=FpY9neILPgi0yP4bHvy+PB7m+teYnk5ISajfOWLR4QNCRjbdnmHhN7q6Sv5GXeTfZ95F9vzweiCA3wFNRAYoVPZkRi5cHuFAZjuVzyUWI9azxkHszCw34kFCWb5IvbF9JMyqNdUlfFZ/VyRHr9CW7uAd1Y2ZZFZudQf8Hw/VjtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735862284; c=relaxed/simple;
	bh=zUgjGkzbjFtl9cM7mCLqRstFXZ+v3GbxEv5fyzl+r/s=;
	h=Date:To:From:Subject:Message-Id; b=h60o9cQNYARRq00Fpn6s3hhyZ7ZS2T1sLY0yTqBcmAsZHGCImM+azT5sQfVcFKed5cnjIF8Q0zKt6tkdBYUsJrMEGitraG4W1HJ4hUNfIaFFod6hGsfHQE/Z3k0363VbTsNuD1qet/CaBbn6hQz5tPuJ9filvRC/T7zcGpSw038=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q5XFBatQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q5XFBatQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D77FC4CED0;
	Thu,  2 Jan 2025 23:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735862284;
	bh=zUgjGkzbjFtl9cM7mCLqRstFXZ+v3GbxEv5fyzl+r/s=;
	h=Date:To:From:Subject:From;
	b=q5XFBatQzfpY7GotN0cnKsClrkUjEH0hL9g0980do7ukGlZ0rpcMZGgwL5JRvJA0j
	 CZQpNgP6IgwZgoIGI0ZJ2YMVKXC+333uUBDYpC+6SciYsYFXx3aSP5Qj0bcL1URcx6
	 qjV2pKUmmTkq8qCTQkDHHN6ViVDiSShPJIeRpbIQ=
Date: Thu, 02 Jan 2025 15:58:03 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,stevensd@chromium.org,kasong@tencent.com,kaleshsingh@google.com,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-pte-mapped-large-folios.patch added to mm-unstable branch
Message-Id: <20250102235804.8D77FC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: fix PTE-mapped large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-fix-pte-mapped-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-pte-mapped-large-folios.patch

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
@@ -3431,29 +3431,55 @@ static bool suitable_to_scan(int total,
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
@@ -3482,19 +3508,23 @@ restart:
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
 
@@ -3508,13 +3538,15 @@ static void walk_pmd_range_locked(pud_t
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
 
@@ -3567,20 +3599,23 @@ static void walk_pmd_range_locked(pud_t
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
@@ -4115,9 +4150,11 @@ static void lru_gen_age_node(struct pgli
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
@@ -4128,7 +4165,7 @@ bool lru_gen_look_around(struct page_vma
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
-	int old_gen, new_gen = lru_gen_from_seq(max_seq);
+	int gen = lru_gen_from_seq(max_seq);
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
@@ -4182,24 +4219,21 @@ bool lru_gen_look_around(struct page_vma
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

mm-mglru-clean-up-workingset.patch
mm-mglru-optimize-deactivation.patch
mm-mglru-rework-aging-feedback.patch
mm-mglru-rework-type-selection.patch
mm-mglru-rework-refault-detection.patch
mm-mglru-rework-workingset-protection.patch
mm-mglru-fix-pte-mapped-large-folios.patch

