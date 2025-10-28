Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F102F2D7814
	for <mm-commits@vger.kernel.org>; Tue, 28 Oct 2025 22:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761691676; cv=none; b=M3iCQs/Xy7g/PvqH7Cy2g7saxJwMWO8ZUxGIKQDqnlwZi6Iyk2wRsLzxYAzItZVEdDfu+QT40LdgwbemY4vg5AkmoYN9Ysrm3KYMd/EMqKZ/6h8HF97Oh20FN9lQGr31K7jta7t9DYxLZBNDAXQRJ29UbHiAfvR/TlIpiqFcpYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761691676; c=relaxed/simple;
	bh=TajwnEVpezB6cBPl8BEqroQgywrLo4+p9PqER3b1cAg=;
	h=Date:To:From:Subject:Message-Id; b=UHFZQBhpVo49PrV1+yDjpbXQmc/zSckZJrCR91uyP7gKrF9VTfHmKIx0uHOXKwqx0777hgQdlNtllPGVMQPXUQMlq7c6+sgqx9n+ECDCQj2QTtkGBUzsB9yJE/f222UEEu7sYEuKzLwxaNp47KLeHCDnOIyNgO17NcQOrpLvtpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdAzMB7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdAzMB7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB58C4CEE7;
	Tue, 28 Oct 2025 22:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761691675;
	bh=TajwnEVpezB6cBPl8BEqroQgywrLo4+p9PqER3b1cAg=;
	h=Date:To:From:Subject:From;
	b=gdAzMB7uaHtXpc/AkNwOHJX/bo5gjBTwioBtwST0x3c4sdSq8ph+epdBL0Fbsh/9Y
	 +QX+LQlFSRYj15oA/Dhe++16pIe+OvYXHEZ3Y0BnP4xtkkdS3qxWeuSYuYmnkxG5mt
	 mGN3ITi4nXDJ+8ZV8dGR0b9pyDIdt3PQFCBL/ahk=
Date: Tue, 28 Oct 2025 15:47:54 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,david@redhat.com,chengming.zhou@linux.dev,pedrodemargomes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-perform-a-range-walk-in-break_ksm.patch added to mm-new branch
Message-Id: <20251028224755.6CB58C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: perform a range-walk in break_ksm
has been added to the -mm mm-new branch.  Its filename is
     ksm-perform-a-range-walk-in-break_ksm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-perform-a-range-walk-in-break_ksm.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Date: Tue, 28 Oct 2025 10:19:44 -0300

Make break_ksm() receive an address range and change break_ksm_pmd_entry()
to perform a range-walk and return the address of the first ksm page
found.

This change allows break_ksm() to skip unmapped regions instead of
iterating every page address.  When unmerging large sparse VMAs, this
significantly reduces runtime, as confirmed by benchmark test (see cover
letter).

Link: https://lkml.kernel.org/r/20251028131945.26445-3-pedrodemargomes@gmail.com
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   88 +++++++++++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 39 deletions(-)

--- a/mm/ksm.c~ksm-perform-a-range-walk-in-break_ksm
+++ a/mm/ksm.c
@@ -607,34 +607,54 @@ static inline bool ksm_test_exit(struct
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+struct break_ksm_arg {
+	unsigned long addr;
+};
+
+static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
-	struct page *page = NULL;
+	struct page *page;
 	spinlock_t *ptl;
-	pte_t *pte;
-	pte_t ptent;
-	int ret;
+	pte_t *start_ptep = NULL, *ptep, pte;
+	int ret = 0;
+	struct mm_struct *mm = walk->mm;
+	struct break_ksm_arg *private = (struct break_ksm_arg *) walk->private;
 
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte)
+	if (ksm_test_exit(walk->mm))
 		return 0;
-	ptent = ptep_get(pte);
-	if (pte_present(ptent)) {
-		page = vm_normal_page(walk->vma, addr, ptent);
-	} else if (!pte_none(ptent)) {
-		swp_entry_t entry = pte_to_swp_entry(ptent);
 
-		/*
-		 * As KSM pages remain KSM pages until freed, no need to wait
-		 * here for migration to end.
-		 */
-		if (is_migration_entry(entry))
-			page = pfn_swap_entry_to_page(entry);
+	if (signal_pending(current))
+		return -ERESTARTSYS;
+
+	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!start_ptep)
+		return 0;
+
+	for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {
+		pte = ptep_get(ptep);
+		page = NULL;
+		if (pte_present(pte)) {
+			page = vm_normal_page(walk->vma, addr, pte);
+		} else if (!pte_none(pte)) {
+			swp_entry_t entry = pte_to_swp_entry(pte);
+
+			/*
+			 * As KSM pages remain KSM pages until freed, no need to wait
+			 * here for migration to end.
+			 */
+			if (is_migration_entry(entry))
+				page = pfn_swap_entry_to_page(entry);
+		}
+		/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+		ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(pte);
+		if (ret) {
+			private->addr = addr;
+			goto out_unlock;
+		}
 	}
-	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
-	ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(ptent);
-	pte_unmap_unlock(pte, ptl);
+out_unlock:
+	pte_unmap_unlock(ptep, ptl);
 	return ret;
 }
 
@@ -661,9 +681,11 @@ static const struct mm_walk_ops break_ks
  * of the process that owns 'vma'.  We also do not want to enforce
  * protection keys here anyway.
  */
-static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
+static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, bool lock_vma)
 {
 	vm_fault_t ret = 0;
+	struct break_ksm_arg break_ksm_arg;
 	const struct mm_walk_ops *ops = lock_vma ?
 				&break_ksm_lock_vma_ops : &break_ksm_ops;
 
@@ -671,11 +693,10 @@ static int break_ksm(struct vm_area_stru
 		int ksm_page;
 
 		cond_resched();
-		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
-		if (WARN_ON_ONCE(ksm_page < 0))
+		ksm_page = walk_page_range_vma(vma, addr, end, ops, &break_ksm_arg);
+		if (ksm_page <= 0)
 			return ksm_page;
-		if (!ksm_page)
-			return 0;
+		addr = break_ksm_arg.addr;
 		ret = handle_mm_fault(vma, addr,
 				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
 				      NULL);
@@ -761,7 +782,7 @@ static void break_cow(struct ksm_rmap_it
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (vma)
-		break_ksm(vma, addr, false);
+		break_ksm(vma, addr, addr + 1, false);
 	mmap_read_unlock(mm);
 }
 
@@ -1072,18 +1093,7 @@ static void remove_trailing_rmap_items(s
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

