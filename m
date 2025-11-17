Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA5E236435
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343281; cv=none; b=Ov/RQx2r/Flkrq25IhgQe2m1iyBIhuzTu0+6GfHcyAJamyznAPN8aouBfxxWHhn9aiTqkGF8AUJiiT+mlSW3UUWHR/vRZCgtSWDfKuA4lR92d1LPy0KTah8IcVCfM3WNuytfUCCe5yMIxsXTVwskZWLG6qlI5fDDMnP/4J6L4g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343281; c=relaxed/simple;
	bh=htUlQALvLSzdeipw5pM1KP8jGbSonB5iSjiv1mCMwws=;
	h=Date:To:From:Subject:Message-Id; b=MrBrst/9qB+mLjtep146cZRMYaoxGNJa+aGpAVOvnMpwtgbL5dQY+eWt2rCEmWitBj+XchLvmhaeIufHeo6g2oVJ4SQTw4onnGrorLM4TArpGfgUbisSmJA7qdjTaVgNaA2XJ+6BDY1es9ABWzv97nKyNGExwp5tjfJQoRFlSYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0bV9jyg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0bV9jyg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0290C4CEF5;
	Mon, 17 Nov 2025 01:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343280;
	bh=htUlQALvLSzdeipw5pM1KP8jGbSonB5iSjiv1mCMwws=;
	h=Date:To:From:Subject:From;
	b=0bV9jyg2uTL6S+G9KP7GDOqjzOk5yESmJvIgqhjVkVPqmKItSFa5Q9P/DOGm6x4I0
	 w3Hf5WSLNuDjatLWSCbS9M10q4Vn+4lGD14nR6SuTMaZfhODsFvaOmqIiNBrQqUN3p
	 mn/2GgvtetFH7blm56MwPOqpPygxhHy2ORVWZp34=
Date: Sun, 16 Nov 2025 17:34:40 -0800
To: mm-commits@vger.kernel.org,david@kernel.org,pedrodemargomes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-perform-a-range-walk-in-break_ksm.patch removed from -mm tree
Message-Id: <20251117013440.D0290C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: perform a range-walk in break_ksm
has been removed from the -mm tree.  Its filename was
     ksm-perform-a-range-walk-in-break_ksm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: ksm: perform a range-walk in break_ksm
Date: Wed, 5 Nov 2025 15:49:11 -0300

Make break_ksm() receive an address range and change break_ksm_pmd_entry()
to perform a range-walk and return the address of the first ksm page
found.

This change allows break_ksm() to skip unmapped regions instead of
iterating every page address.  When unmerging large sparse VMAs, this
significantly reduces runtime.

In a benchmark unmerging a 32 TiB sparse virtual address space where only
one page was populated, the runtime dropped from 9 minutes to less then 5
seconds.

Link: https://lkml.kernel.org/r/20251105184912.186329-3-pedrodemargomes@gmail.com
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   83 +++++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 40 deletions(-)

--- a/mm/ksm.c~ksm-perform-a-range-walk-in-break_ksm
+++ a/mm/ksm.c
@@ -607,35 +607,50 @@ static inline bool ksm_test_exit(struct
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
-	struct folio *folio = NULL;
+	unsigned long *found_addr = (unsigned long *) walk->private;
+	struct mm_struct *mm = walk->mm;
+	pte_t *start_ptep, *ptep;
 	spinlock_t *ptl;
-	pte_t *pte;
-	pte_t ptent;
-	int found;
+	int found = 0;
 
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte)
+	if (ksm_test_exit(walk->mm))
 		return 0;
-	ptent = ptep_get(pte);
-	if (pte_present(ptent)) {
-		folio = vm_normal_folio(walk->vma, addr, ptent);
-	} else if (!pte_none(ptent)) {
-		swp_entry_t entry = pte_to_swp_entry(ptent);
+	if (signal_pending(current))
+		return -ERESTARTSYS;
 
-		/*
-		 * As KSM pages remain KSM pages until freed, no need to wait
-		 * here for migration to end.
-		 */
-		if (is_migration_entry(entry))
-			folio = pfn_swap_entry_folio(entry);
+	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!start_ptep)
+		return 0;
+
+	for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {
+		pte_t pte = ptep_get(ptep);
+		struct folio *folio = NULL;
+
+		if (pte_present(pte)) {
+			folio = vm_normal_folio(walk->vma, addr, pte);
+		} else if (!pte_none(pte)) {
+			swp_entry_t entry = pte_to_swp_entry(pte);
+
+			/*
+			 * As KSM pages remain KSM pages until freed, no need to wait
+			 * here for migration to end.
+			 */
+			if (is_migration_entry(entry))
+				folio = pfn_swap_entry_folio(entry);
+		}
+		/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+		found = (folio && folio_test_ksm(folio)) ||
+			(pte_present(pte) && is_ksm_zero_pte(pte));
+		if (found) {
+			*found_addr = addr;
+			goto out_unlock;
+		}
 	}
-	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
-	found = (folio && folio_test_ksm(folio)) ||
-		(pte_present(ptent) && is_ksm_zero_pte(ptent));
-	pte_unmap_unlock(pte, ptl);
+out_unlock:
+	pte_unmap_unlock(ptep, ptl);
 	return found;
 }
 
@@ -662,7 +677,8 @@ static const struct mm_walk_ops break_ks
  * of the process that owns 'vma'.  We also do not want to enforce
  * protection keys here anyway.
  */
-static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
+static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, bool lock_vma)
 {
 	vm_fault_t ret = 0;
 	const struct mm_walk_ops *ops = lock_vma ?
@@ -672,11 +688,9 @@ static int break_ksm(struct vm_area_stru
 		int ksm_page;
 
 		cond_resched();
-		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
-		if (WARN_ON_ONCE(ksm_page < 0))
+		ksm_page = walk_page_range_vma(vma, addr, end, ops, &addr);
+		if (ksm_page <= 0)
 			return ksm_page;
-		if (!ksm_page)
-			return 0;
 		ret = handle_mm_fault(vma, addr,
 				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
 				      NULL);
@@ -762,7 +776,7 @@ static void break_cow(struct ksm_rmap_it
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (vma)
-		break_ksm(vma, addr, false);
+		break_ksm(vma, addr, addr + PAGE_SIZE, false);
 	mmap_read_unlock(mm);
 }
 
@@ -1073,18 +1087,7 @@ static void remove_trailing_rmap_items(s
 static int unmerge_ksm_pages(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end, bool lock_vma)
 {
-	unsigned long addr;
-	int err = 0;
-
-	for (addr = start; addr < end && !err; addr += PAGE_SIZE) {
-		if (ksm_test_exit(vma->vm_mm))
-			break;
-		if (signal_pending(current))
-			err = -ERESTARTSYS;
-		else
-			err = break_ksm(vma, addr, lock_vma);
-	}
-	return err;
+	return break_ksm(vma, start, end, lock_vma);
 }
 
 static inline
_

Patches currently in -mm which might be from pedrodemargomes@gmail.com are


