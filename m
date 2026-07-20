Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B504D235045
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 06:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784528791; cv=none; b=cKAHu3TOEd8yVDcGh8KGIqqmpBF5sqDWwO/EGurjFKJeWT5mkGx822GKxLDTkAp4fqeaUnxrZAN2ZG4SyvJJjXskB/gjS6a0GI7aaWew7OmAVbRRrlifmnWbdjvmE6DG29LlaOddMBhsih6ayGtjn4ZdMZX97n1lLPVa7PYowOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784528791; c=relaxed/simple;
	bh=GWYt5UnHtyYoNx48kgagzz1jik+1CI3WisvlPV5nXoo=;
	h=Date:To:From:Subject:Message-Id; b=fv22JAdm0Il5KiP+Q16hjrH+GAH5u70Twfg+Emm5x6N8HV4aVEoDPLc+ZO+k3kx/+O37ifqNYF8uU8TN6AI81kOKV+2rtmP312J0WNQXsnADkOBw6z9ixj9aqOeVxuOO+LksDlLe5qOdviPWthb2OHAayYdPg/d6+LYrpAYA4T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XXEZhYnA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XXEZhYnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CA61F00A3A;
	Mon, 20 Jul 2026 06:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784528788;
	bh=9SVOtVjx2q7luKOB7VzBsdtg4eyOrxn1mH0eI2UUyx0=;
	h=Date:To:From:Subject;
	b=XXEZhYnAKfTfOVSwDu6m0srZXIfaHbhS46T8jRXyWD8/txck8l0crSKZS9njoX4FT
	 hK/pqoS7C3nKExNsUBSa5nRwlxwFZPxLvwq5XdNTqvY53tSc5zSaTAqMhKd1vw9kbn
	 AmtIFCODkEz/sQJJUw+FNuoCPu5ZvBl7IKi6vo+s=
Date: Sun, 19 Jul 2026 23:26:27 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-promote-mapped-executable-folios-after-first-usage.patch removed from -mm tree
Message-Id: <20260720062627.E1CA61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mglru: promote mapped executable folios after first usage
has been removed from the -mm tree.  Its filename was
     mm-mglru-promote-mapped-executable-folios-after-first-usage.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: mglru: promote mapped executable folios after first usage
Date: Fri, 17 Jul 2026 18:05:34 +0800

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

While we are at it, introduce a new helper to check mapped executable file
folios.

Link: https://lore.kernel.org/7db4d1975cf04e3e48157f98bdf398565ee189a4.1784268206.git.baolin.wang@linux.alibaba.com
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

 mm/vmscan.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

--- a/mm/vmscan.c~mm-mglru-promote-mapped-executable-folios-after-first-usage
+++ a/mm/vmscan.c
@@ -268,6 +268,12 @@ static int sc_swappiness(struct scan_con
 }
 #endif
 
+static inline bool is_exec_file_folio(const struct folio *folio,
+		const vma_flags_t *vma_flags)
+{
+	return vma_flags_test(vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio);
+}
+
 static void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
@@ -835,11 +841,15 @@ enum folio_references {
  * with PG_active set. In contrast, the aging (page table walk) path uses
  * folio_update_gen().
  */
-static bool lru_gen_set_refs(struct folio *folio)
+static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 {
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+		/* Activate file-backed executable folios after first usage. */
+		if (is_exec_file_folio(folio, vma_flags))
+			return true;
+
 		return false;
 	}
 
@@ -851,7 +861,7 @@ static bool lru_gen_set_refs(struct foli
 	return true;
 }
 #else
-static bool lru_gen_set_refs(struct folio *folio)
+static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 {
 	return false;
 }
@@ -886,7 +896,7 @@ static enum folio_references folio_check
 		if (!referenced_ptes)
 			return FOLIOREF_RECLAIM;
 
-		return lru_gen_set_refs(folio) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
+		return lru_gen_set_refs(folio, &vma_flags) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
 	}
 
 	referenced_folio = folio_test_clear_referenced(folio);
@@ -914,7 +924,7 @@ static enum folio_references folio_check
 		/*
 		 * Activate file-backed executable folios after first usage.
 		 */
-		if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio))
+		if (is_exec_file_folio(folio, &vma_flags))
 			return FOLIOREF_ACTIVATE;
 
 		return FOLIOREF_KEEP;
@@ -2117,7 +2127,7 @@ static void shrink_active_list(unsigned
 			 * IO, plus JVM can create lots of anon VM_EXEC folios,
 			 * so we ignore them here.
 			 */
-			if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio)) {
+			if (is_exec_file_folio(folio, &vma_flags)) {
 				nr_rotated += folio_nr_pages(folio);
 				list_add(&folio->lru, &l_active);
 				continue;
@@ -3190,7 +3200,7 @@ static bool positive_ctrl_err(struct ctr
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int gen)
+static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma_flags)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
 
@@ -3198,10 +3208,15 @@ static int folio_update_gen(struct folio
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
+		/* Activate file-backed executable folios after first usage. */
+		if (is_exec_file_folio(folio, vma_flags))
+			goto promote;
+
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
 		return -1;
 	}
 
+promote:
 	do {
 		/* lru_gen_del_folio() has isolated this page? */
 		if (!(old_flags & LRU_GEN_MASK))
@@ -3430,8 +3445,8 @@ static bool suitable_to_scan(int total,
 	return young * n >= total;
 }
 
-static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
-			      int new_gen, bool dirty)
+static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
+		struct folio *folio, int new_gen, bool dirty)
 {
 	int old_gen;
 
@@ -3444,10 +3459,10 @@ static void walk_update_folio(struct lru
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
@@ -3520,7 +3535,7 @@ restart:
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, args->vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3533,7 +3548,7 @@ restart:
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, args->vma, last, gen, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3611,7 +3626,7 @@ static void walk_pmd_range_locked(pud_t
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3625,7 +3640,7 @@ next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, vma, last, gen, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4260,7 +4275,7 @@ bool lru_gen_look_around(struct page_vma
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4272,7 +4287,7 @@ bool lru_gen_look_around(struct page_vma
 		young += nr;
 	}
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, vma, last, gen, dirty);
 
 	lazy_mmu_mode_disable();
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic.patch

