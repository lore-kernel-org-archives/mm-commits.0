Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A914449B30
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 23:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784591214; cv=none; b=SaVYbKwh7PiyRg02ppBTKb2XbRrep6m1BQHX5FX+d2N9HjmhYeZpMqGrx6I+muXttnCReVfjPEIYrGcdz+AEj7GiskoGpMS9MBm8ZXVDbnHbjix/LSJKyed7REj9DbuPOmR5L9sB/hoPd5xClk8qe+kioRfmQvq6bFHq3GzisX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784591214; c=relaxed/simple;
	bh=8zbyP6EZlTnRLMRm464Fobkc+y0MkepftnkDlF3wRY4=;
	h=Date:To:From:Subject:Message-Id; b=ZoalMaKHIOhnScpxiDkeQGx+pgIfSgOnUruat63muh1JMgiTcUJDvTx6ma7WuCB6biH9UtywBTbIXfH+TIcn1ICR5s8gn0Ji8M0e+FUh7P6xXbl107UFK7q2gzfNeBc4N8gGG10bfbv22LwfW0mCI8qwaCWM4fl+ZD5PIMWvoTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yIR/IFUf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yIR/IFUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFB51F000E9;
	Mon, 20 Jul 2026 23:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784591213;
	bh=NLPGGsNxs6cvzHCkr2AxwcGWo3//PTVHqj3/hcINh1Y=;
	h=Date:To:From:Subject;
	b=yIR/IFUfthfckmz1zwyPHjSgKYyzxeZkOr/otF8u/6fF58qiUKpPetI/bWnNtI70J
	 KYNaoj1+lg2dyFbYbl+mIcTPux6ulPaNXC+vcu0UBBRiETUhv7gpf6Y0QCnG9/m43e
	 OfAHHlDR1ZDEPSb16QvvDXEzR3VnuWYYnqwZciIQ=
Date: Mon, 20 Jul 2026 16:46:52 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-batch-set-uffd-wp-markers-during-zapping.patch added to mm-new branch
Message-Id: <20260720234652.EDFB51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: batch set uffd-wp markers during zapping
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-batch-set-uffd-wp-markers-during-zapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-batch-set-uffd-wp-markers-during-zapping.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm/memory: batch set uffd-wp markers during zapping
Date: Mon, 20 Jul 2026 06:55:06 +0000

Enable batch setting of uffd-wp PTE markers.

The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
that nr through either folio_pte_batch() or swap_pte_batch(), therefore
batching is correct:

1) All PTEs belong to the same type of VMA: anonymous or non-anonymous,
   wp-armed or non-wp-armed.

2) All PTEs are either marked with uffd-wp or not marked with uffd-wp;
   the same applies to the pte_swp_uffd_any() check.

3) uffd_supports_wp_marker() is independent of the function parameters.

Use set_pte_at() in a loop instead of set_ptes(), because set_ptes()
cannot handle nonpresent to nonpresent conversion for nr_pages > 1.

Rename the helper to cond_install_uffd_wp_ptes().

Link: https://lore.kernel.org/20260720065508.2695106-3-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    5 ++-
 mm/memory.c   |   61 +++++++++++++++++++-----------------------------
 mm/rmap.c     |    2 -
 3 files changed, 29 insertions(+), 39 deletions(-)

--- a/mm/internal.h~mm-memory-batch-set-uffd-wp-markers-during-zapping
+++ a/mm/internal.h
@@ -280,8 +280,9 @@ void unmap_vmas(struct mmu_gather *tlb,
 
 #ifdef CONFIG_MMU
 
-bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t pte);
+bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte,
+		unsigned long nr_ptes);
 
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
--- a/mm/memory.c~mm-memory-batch-set-uffd-wp-markers-during-zapping
+++ a/mm/memory.c
@@ -1678,27 +1678,29 @@ static inline bool zap_drop_markers(stru
 }
 
 /**
- * pte_install_uffd_wp_if_needed - install uffd-wp marker after clearing a PTE
- * @vma: The VMA the page is mapped into.
- * @addr: Address the page is mapped at.
- * @ptep: Page table pointer for this entry.
+ * cond_install_uffd_wp_ptes - install uffd-wp markers after clearing PTEs
+ * @vma: The VMA the pages are mapped into.
+ * @addr: Address the first page of this batch is mapped at.
+ * @ptep: Page table pointer for the first entry of this batch.
  * @pte: Old value of the entry pointed to by @ptep.
+ * @nr_ptes: Number of entries to install.
  *
- * If the PTE was write-protected by uffd-wp in any form, arm a special PTE
- * to replace a none PTE. NOTE! This should only be called when the PTE is
+ * If the PTEs were write-protected by uffd-wp in any form, arm special PTEs
+ * to replace none PTEs. NOTE! This should only be called when the PTEs are
  * already cleared so we will never accidentally replace something valuable.
- * Meanwhile none PTEs also mean we are not demoting the PTE so a TLB flush is
- * not needed. E.g., when the PTE was cleared, the caller should have taken care
- * of the TLB flush.
+ * Meanwhile none PTEs also mean we are not demoting the PTEs so a TLB flush is
+ * not needed. E.g., when the PTEs were cleared, the caller should have taken
+ * care of the TLB flush.
  *
  * Must be called with the page table lock held so that no thread will see the
- * none PTE, and if they see it, they'll fault and serialize at the page table
+ * none PTEs, and if they see them, they'll fault and serialize at the page table
  * lock.
  *
- * Returns true if an uffd-wp PTE was installed, false otherwise.
+ * Returns true if uffd-wp PTEs were installed, false otherwise.
  */
-bool pte_install_uffd_wp_if_needed(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t pte)
+bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte,
+		unsigned long nr_ptes)
 {
 	bool arm_uffd_pte = false;
 
@@ -1728,13 +1730,19 @@ bool pte_install_uffd_wp_if_needed(struc
 	if (unlikely(pte_swp_uffd_any(pte)))
 		arm_uffd_pte = true;
 
-	if (unlikely(arm_uffd_pte)) {
+	if (likely(!arm_uffd_pte))
+		return false;
+
+	for (;;) {
 		set_pte_at(vma->vm_mm, addr, ptep,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		return true;
+		if (--nr_ptes == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
 	}
 
-	return false;
+	return true;
 }
 
 /*
@@ -1748,29 +1756,10 @@ zap_install_uffd_wp_if_needed(struct vm_
 			      unsigned long addr, pte_t *pte, int nr,
 			      struct zap_details *details, pte_t pteval)
 {
-	bool was_installed = false;
-
-	if (!uffd_supports_wp_marker())
-		return false;
-
-	/* Zap on anonymous always means dropping everything */
-	if (vma_is_anonymous(vma))
-		return false;
-
 	if (zap_drop_markers(details))
 		return false;
 
-	for (;;) {
-		/* the PFN in the PTE is irrelevant. */
-		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
-			was_installed = true;
-		if (--nr == 0)
-			break;
-		pte++;
-		addr += PAGE_SIZE;
-	}
-
-	return was_installed;
+	return cond_install_uffd_wp_ptes(vma, addr, pte, pteval, nr);
 }
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
--- a/mm/rmap.c~mm-memory-batch-set-uffd-wp-markers-during-zapping
+++ a/mm/rmap.c
@@ -2351,7 +2351,7 @@ static bool try_to_unmap_one(struct foli
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, 1);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch
mm-mprotect-drop-sub-from-batching-context.patch
arm64-make-huge_ptep_get-handled-unaligned-addresses.patch
mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-rmap-convert-page-folio-for-hwpoison-checks.patch
mm-rmap-add-try_to_unmap_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

