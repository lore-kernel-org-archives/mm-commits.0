Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1C83DB31F
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 23:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784588758; cv=none; b=nesSIZmB0JfL/0OssV18QGCgM3i5+TlUGq1QWZA3H69MNHoYXjvjwHEDdvQfgUTG2YP3jV1maK6zOuRZRNnQ+tw8n86YiJHMC5nAQLii12nfyuvw9Puidg4O1VKSLJoS0/0q6h+AnUOfhAYTNCLsIv8x0258abXAGjrSSEBfMzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784588758; c=relaxed/simple;
	bh=KvVcPVKpbkGoi+ZwQ4Uh4aQ3b/VveypQmZdR6lIhmeg=;
	h=Date:To:From:Subject:Message-Id; b=l5i6HDKdEqJisfJaBj/BH4qIBNQMXLS6Ilq8k6YDBKSDogVvYQtGmlRkIDH1KE5F9xDp0IWvckcYo4G5HX58zxtuFcs/qovuW0Z2BuVTUbk/oGd6PjaARkjtMfA2Z3VqzGq4LMMF157COSEbULODXm2wQtpECx7L7f4Fe/5Xi6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yzEGYVau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yzEGYVau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C9B1F000E9;
	Mon, 20 Jul 2026 23:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784588756;
	bh=PtuGO/xTNX1zlLHM1sYsEgjNHB4QWIjFHVvInJ3QDnI=;
	h=Date:To:From:Subject;
	b=yzEGYVauvwYXEoartwJNar2OLOpF2pbDV8FTJkQKcPftV4FWGGa7n5Liw39wIM7Nd
	 EJDq/vOOYX9rRDgMRnnWJ7pmwOPoGt5h2O0ttmr87JUMnUlo/35rCKi0QhpLSg1idI
	 2b1ScVMLwavIvQlj+GzV7wG17BS/xCr70BC4/uco=
Date: Mon, 20 Jul 2026 16:05:56 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-promote-mapped-executable-folios-after-first-usage.patch added to mm-new branch
Message-Id: <20260720230556.D7C9B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mglru: promote mapped executable folios after first usage
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-promote-mapped-executable-folios-after-first-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-promote-mapped-executable-folios-after-first-usage.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
@@ -3196,14 +3202,19 @@ static bool positive_ctrl_err(struct ctr
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
@@ -3436,8 +3447,8 @@ static bool suitable_to_scan(int total,
 	return young * n >= total;
 }
 
-static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
-			      int new_gen, bool dirty)
+static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
+		struct folio *folio, int new_gen, bool dirty)
 {
 	int old_gen;
 
@@ -3450,10 +3461,10 @@ static void walk_update_folio(struct lru
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
@@ -3526,7 +3537,7 @@ restart:
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, args->vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3539,7 +3550,7 @@ restart:
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, args->vma, last, gen, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3617,7 +3628,7 @@ static void walk_pmd_range_locked(pud_t
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3631,7 +3642,7 @@ next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, vma, last, gen, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4266,7 +4277,7 @@ bool lru_gen_look_around(struct page_vma
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4278,7 +4289,7 @@ bool lru_gen_look_around(struct page_vma
 		young += nr;
 	}
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, vma, last, gen, dirty);
 
 	lazy_mmu_mode_disable();
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic.patch
mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch
mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch
mm-mglru-promote-mapped-executable-folios-after-first-usage.patch

