Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BBF2DECA5
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 23:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762386898; cv=none; b=lt/2tbowphlER84eq+aS7b9/3BbLpFU7ldsuhIj4MiX2GxO7oXM9q8TOUtNakcpNfTuGrHNGXgNsSYwzgaKrXxhPMy4ZldN4JjEtEo4vhqEax2GjfU9A3FJBuiwRPib/UTe8oYzXPcJbgnLp9uVrtP39hPR7BC+36r4oQ5cvmz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762386898; c=relaxed/simple;
	bh=Teys8Li1tXZek5m5qZzM8wemXYToCjxRchVQeJ2Hqmg=;
	h=Date:To:From:Subject:Message-Id; b=pkmW3NGDGeW0NkL9gZUJaCbf4YjDmjUqLozBjydp1moKgeNRJuAQUXbvgLr59RTPsCOxP8nGvz4HXFZdta79yFwTw+pdPoOby2Y4IAnpetr+4LPcWIruO3sO4P/7n8j6YmbkNfqnoKpiXoQB0m5LUOEXGtKGP0ux6A+bx4+k7vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yZgrU7r/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yZgrU7r/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0AFC4CEF5;
	Wed,  5 Nov 2025 23:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762386897;
	bh=Teys8Li1tXZek5m5qZzM8wemXYToCjxRchVQeJ2Hqmg=;
	h=Date:To:From:Subject:From;
	b=yZgrU7r/EBEQOnSJDuIosWswEEWEIisqqH2oMejWgNoIOI+5dDHDAFeJWTeOOMdzm
	 baVSCRkwLblrSOu9TQ1kUkdNGUCvoULIS0xq3kGh5SohxtGR4syMapVjUfq+Hh4ne0
	 em13U7fETN033jFiUOvj/tDngDh8dILN2OG+n+MY=
Date: Wed, 05 Nov 2025 15:54:57 -0800
To: mm-commits@vger.kernel.org,david@kernel.org,pedrodemargomes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-perform-a-range-walk-in-break_ksm.patch added to mm-unstable branch
Message-Id: <20251105235457.BE0AFC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: perform a range-walk in break_ksm
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-perform-a-range-walk-in-break_ksm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-perform-a-range-walk-in-break_ksm.patch

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

ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item.patch
revert-mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch
ksm-perform-a-range-walk-in-break_ksm.patch
ksm-replace-function-unmerge_ksm_pages-with-break_ksm.patch

