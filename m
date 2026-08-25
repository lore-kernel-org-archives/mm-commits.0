Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3A733C188
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622310; cv=none; b=jYChQOGPPgwSh/Orwq6gd+5zSJx6tnbwTm5aPtapeAsBlBor4bJU/BkQhyxsCjjLTB9X43/Lz5NeI0pk4uEVcrDiXWuddUUYxgNVjl2WDude4RyDoULYpY0QvrFrZpCcchMhwid5C0HGC+UX8qgW9FdqdwNJqcC6W0GIl+MW+B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622310; c=relaxed/simple;
	bh=dKTnjDdq2yDJX5kGIU9OcrHutzjJGauTxPiJNB4xfW8=;
	h=Date:To:From:Subject:Message-Id; b=Xfdd4nzxOfhqwnQ+cSJXGeYeR8xICqbQ/hZPXDFK2ZGiOzwuGcszXGHZwYSK/jrp9BSabmk9NK7FgAYodV48mUTTbS642enTx3b9rSFoKjoqcfw3vQW9L1A8CLOFzk44UPp81GOP2nQ1HS6iTHrzx/zvKUHC5YT7v7WirQjdvUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i6ehF79y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i6ehF79y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E1F1F00A3A;
	Tue, 25 Aug 2026 01:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622308;
	bh=j0u3p6ehpusZoGNnm1g8PP6sUFpvYXXWpgj4tNQ06ZI=;
	h=Date:To:From:Subject;
	b=i6ehF79yoDxOFU94I0ja79QlglDCH+U2B9ZEFOUft1N2X6LeHCov7M5dqlXU7fRd9
	 hAJ0O9bCjeJm49yKp5/XHT1Vlqjw7r+AYSQZlETvmPlCRQyN11fD3UJUXuEE6tYevT
	 nFziWV6cXg869mU3JarPG6wHanfWDy6rgtMcx8HU=
Date: Mon, 24 Aug 2026 18:45:08 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-promote-mapped-executable-folios-after-first-usage.patch removed from -mm tree
Message-Id: <20260825014508.D0E1F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mglru: promote mapped executable folios after first usage
has been removed from the -mm tree.  Its filename was
     mm-mglru-promote-mapped-executable-folios-after-first-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: mglru: promote mapped executable folios after first usage
Date: Mon, 20 Jul 2026 19:12:02 +0800

Classical LRU protects mapped executable file folios through commit
8cab4754d24a0 ("vmscan: make mapped executable pages the first class
citizen") and commit c909e99364c8 ("vmscan: activate executable pages
after first usage"), giving executable code a better chance to stay in
memory, avoiding IO thrashing and improving workload performance.

However, MGLRU's protection of mapped executable file folios is less
reliable.  Although shrink_folio_list() checks references, the access flag
of mapped executable file folios may have already been checked and cleared
by lru_gen_look_around() or walk_mm().  Additionally, folio_update_gen()
or lru_gen_set_refs() only sets the 'PG_referenced' flag for mapped
executable file folios, which causes shrink_folio_list() to ignore the
first usage of these mapped executable file folios and reclaim them
easily.

Follow the classical LRU's logic, promoting mapped executable file folios
after their first usage in folio_update_gen() and lru_gen_set_refs(),
giving executable code a better chance to stay in memory.

On my 32-core Arm machine, with the memcg limit set to 2G, running 'make
-j32' to build kernel showed some improvement in sys time.

base			patched
9248.543s		7861.579s

Link: https://lore.kernel.org/f57d94b1d85bb3d620d89bb739128f0d929bf9c6.1784509721.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

--- a/mm/vmscan.c~mm-mglru-promote-mapped-executable-folios-after-first-usage
+++ a/mm/vmscan.c
@@ -841,10 +841,16 @@ enum folio_references {
  * with PG_active set. In contrast, the aging (page table walk) path uses
  * folio_update_gen().
  */
-static bool lru_gen_set_refs(struct folio *folio)
+static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 {
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
+		/* Activate file-backed executable folios after first usage. */
+		if (is_exec_file_folio(folio, vma_flags)) {
+			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+			return true;
+		}
+
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
 		return false;
 	}
@@ -857,7 +863,7 @@ static bool lru_gen_set_refs(struct foli
 	return true;
 }
 #else
-static bool lru_gen_set_refs(struct folio *folio)
+static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 {
 	return false;
 }
@@ -892,7 +898,7 @@ static enum folio_references folio_check
 		if (!referenced_ptes)
 			return FOLIOREF_RECLAIM;
 
-		return lru_gen_set_refs(folio) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
+		return lru_gen_set_refs(folio, &vma_flags) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
 	}
 
 	referenced_folio = folio_test_clear_referenced(folio);
@@ -3208,14 +3214,19 @@ static bool positive_ctrl_err(struct ctr
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int gen)
+static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma_flags)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
 
 	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
 
-	/* see the comment on LRU_REFS_FLAGS */
-	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
+	/*
+	 * See the comment on LRU_REFS_FLAGS, and activate file-backed
+	 * executable folios after first usage to avoid typical IO
+	 * thrashing from reclaiming.
+	 */
+	if (!folio_test_referenced(folio) && !folio_test_workingset(folio) &&
+	    !is_exec_file_folio(folio, vma_flags)) {
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
 		return -1;
 	}
@@ -3448,8 +3459,8 @@ static bool suitable_to_scan(int total,
 	return young * n >= total;
 }
 
-static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
-			      int new_gen, bool dirty)
+static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
+		struct folio *folio, int new_gen, bool dirty)
 {
 	int old_gen;
 
@@ -3462,10 +3473,10 @@ static void walk_update_folio(struct lru
 		folio_mark_dirty(folio);
 
 	if (walk) {
-		old_gen = folio_update_gen(folio, new_gen);
+		old_gen = folio_update_gen(folio, new_gen, &vma->flags);
 		if (old_gen >= 0 && old_gen != new_gen)
 			update_batch_size(walk, folio, old_gen, new_gen);
-	} else if (lru_gen_set_refs(folio)) {
+	} else if (lru_gen_set_refs(folio, &vma->flags)) {
 		old_gen = folio_lru_gen(folio);
 		if (old_gen >= 0 && old_gen != new_gen)
 			folio_activate(folio);
@@ -3538,7 +3549,7 @@ restart:
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, args->vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3551,7 +3562,7 @@ restart:
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, args->vma, last, gen, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3629,7 +3640,7 @@ static void walk_pmd_range_locked(pud_t
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3643,7 +3654,7 @@ next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, vma, last, gen, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4278,7 +4289,7 @@ bool lru_gen_look_around(struct page_vma
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4290,7 +4301,7 @@ bool lru_gen_look_around(struct page_vma
 		young += nr;
 	}
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, vma, last, gen, dirty);
 
 	lazy_mmu_mode_disable();
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs.patch

