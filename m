Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEE11F540E
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352790; cv=none; b=XOUff03slKvxuSArr0V5Du23nOCF7l0z+uv6zXgizfH8LbKneKStaCkC7qxQsulHSjgimLZIHDqombD+0kcsQ4jCkCcKgvPh68W/WH9bRKvZ0VySpfZNXxijn0cCKi1IzM3Qz9V5CjNFLTjXCaITH/PwTrB4CNQI8WunsubAuHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352790; c=relaxed/simple;
	bh=VzbjK0QuEpgKL++VkxEW9wn9CzE9ZYS0u0dipYddpk4=;
	h=Date:To:From:Subject:Message-Id; b=JBPqkSE8RGQHt3FdSiKfKaefxun46y58gOhyusQfaopezK1VbJB7nvPS+GFOhcvrJGmfdXZLqusJGw6eetzBTDr5WhH/uPiBrNpmQhQAucdB3nrnxSyUlrQR/gXdQJSl3gC1+ZixW816rPpxax6JRzMr7mM/J03bCC4hWD4nNvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O2BcJk/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O2BcJk/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F128FC4CECD;
	Wed,  4 Dec 2024 22:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733352790;
	bh=VzbjK0QuEpgKL++VkxEW9wn9CzE9ZYS0u0dipYddpk4=;
	h=Date:To:From:Subject:From;
	b=O2BcJk/FhpSPl6EwkjA9kzxGIQF29H2eIJmf5BNkRQW7qfbmlgl4PFgl5tzqIqAis
	 MZpby6Fr8Hrf75W+UB4YNvlFbQjxHuXQsYgt0QrnzIsyqFo5cuY3IHCnVy6GT4WRMU
	 B6UPvVsXGhOLB4X4j/06fpOlR7uiNngZVTLBwAvc=
Date: Wed, 04 Dec 2024 14:53:09 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch added to mm-unstable branch
Message-Id: <20241204225309.F128FC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: do_zap_pte_range: return any_skipped information to the caller
has been added to the -mm mm-unstable branch.  Its filename is
     mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: do_zap_pte_range: return any_skipped information to the caller
Date: Wed, 4 Dec 2024 19:09:47 +0800

Let the caller of do_zap_pte_range() know whether we skip zap ptes or
reinstall uffd-wp ptes through any_skipped parameter, so that subsequent
commits can use this information in zap_pte_range() to detect whether the
PTE page can be reclaimed.

Link: https://lkml.kernel.org/r/59f33ec9f74e9f058ed319b0bfadd76b0f7adf9b.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-do_zap_pte_range-return-any_skipped-information-to-the-caller
+++ a/mm/memory.c
@@ -1501,7 +1501,7 @@ static __always_inline void zap_present_
 		struct vm_area_struct *vma, struct folio *folio,
 		struct page *page, pte_t *pte, pte_t ptent, unsigned int nr,
 		unsigned long addr, struct zap_details *details, int *rss,
-		bool *force_flush, bool *force_break)
+		bool *force_flush, bool *force_break, bool *any_skipped)
 {
 	struct mm_struct *mm = tlb->mm;
 	bool delay_rmap = false;
@@ -1527,8 +1527,8 @@ static __always_inline void zap_present_
 	arch_check_zapped_pte(vma, ptent);
 	tlb_remove_tlb_entries(tlb, pte, nr, addr);
 	if (unlikely(userfaultfd_pte_wp(vma, ptent)))
-		zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details,
-					      ptent);
+		*any_skipped = zap_install_uffd_wp_if_needed(vma, addr, pte,
+							     nr, details, ptent);
 
 	if (!delay_rmap) {
 		folio_remove_rmap_ptes(folio, page, nr, vma);
@@ -1552,7 +1552,7 @@ static inline int zap_present_ptes(struc
 		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
 		unsigned int max_nr, unsigned long addr,
 		struct zap_details *details, int *rss, bool *force_flush,
-		bool *force_break)
+		bool *force_break, bool *any_skipped)
 {
 	const fpb_t fpb_flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
 	struct mm_struct *mm = tlb->mm;
@@ -1567,15 +1567,17 @@ static inline int zap_present_ptes(struc
 		arch_check_zapped_pte(vma, ptent);
 		tlb_remove_tlb_entry(tlb, pte, addr);
 		if (userfaultfd_pte_wp(vma, ptent))
-			zap_install_uffd_wp_if_needed(vma, addr, pte, 1,
-						      details, ptent);
+			*any_skipped = zap_install_uffd_wp_if_needed(vma, addr,
+						pte, 1, details, ptent);
 		ksm_might_unmap_zero_page(mm, ptent);
 		return 1;
 	}
 
 	folio = page_folio(page);
-	if (unlikely(!should_zap_folio(details, folio)))
+	if (unlikely(!should_zap_folio(details, folio))) {
+		*any_skipped = true;
 		return 1;
+	}
 
 	/*
 	 * Make sure that the common "small folio" case is as fast as possible
@@ -1587,22 +1589,23 @@ static inline int zap_present_ptes(struc
 
 		zap_present_folio_ptes(tlb, vma, folio, page, pte, ptent, nr,
 				       addr, details, rss, force_flush,
-				       force_break);
+				       force_break, any_skipped);
 		return nr;
 	}
 	zap_present_folio_ptes(tlb, vma, folio, page, pte, ptent, 1, addr,
-			       details, rss, force_flush, force_break);
+			       details, rss, force_flush, force_break, any_skipped);
 	return 1;
 }
 
 static inline int zap_nonpresent_ptes(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
 		unsigned int max_nr, unsigned long addr,
-		struct zap_details *details, int *rss)
+		struct zap_details *details, int *rss, bool *any_skipped)
 {
 	swp_entry_t entry;
 	int nr = 1;
 
+	*any_skipped = true;
 	entry = pte_to_swp_entry(ptent);
 	if (is_device_private_entry(entry) ||
 		is_device_exclusive_entry(entry)) {
@@ -1660,7 +1663,7 @@ static inline int zap_nonpresent_ptes(st
 		WARN_ON_ONCE(1);
 	}
 	clear_not_present_full_ptes(vma->vm_mm, addr, pte, nr, tlb->fullmm);
-	zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details, ptent);
+	*any_skipped = zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details, ptent);
 
 	return nr;
 }
@@ -1669,7 +1672,8 @@ static inline int do_zap_pte_range(struc
 				   struct vm_area_struct *vma, pte_t *pte,
 				   unsigned long addr, unsigned long end,
 				   struct zap_details *details, int *rss,
-				   bool *force_flush, bool *force_break)
+				   bool *force_flush, bool *force_break,
+				   bool *any_skipped)
 {
 	pte_t ptent = ptep_get(pte);
 	int max_nr = (end - addr) / PAGE_SIZE;
@@ -1691,10 +1695,11 @@ static inline int do_zap_pte_range(struc
 
 	if (pte_present(ptent))
 		nr += zap_present_ptes(tlb, vma, pte, ptent, max_nr, addr,
-				       details, rss, force_flush, force_break);
+				       details, rss, force_flush, force_break,
+				       any_skipped);
 	else
 		nr += zap_nonpresent_ptes(tlb, vma, pte, ptent, max_nr, addr,
-					  details, rss);
+					  details, rss, any_skipped);
 
 	return nr;
 }
@@ -1705,6 +1710,7 @@ static unsigned long zap_pte_range(struc
 				struct zap_details *details)
 {
 	bool force_flush = false, force_break = false;
+	bool any_skipped = false;
 	struct mm_struct *mm = tlb->mm;
 	int rss[NR_MM_COUNTERS];
 	spinlock_t *ptl;
@@ -1725,7 +1731,7 @@ static unsigned long zap_pte_range(struc
 			break;
 
 		nr = do_zap_pte_range(tlb, vma, pte, addr, end, details, rss,
-				      &force_flush, &force_break);
+				      &force_flush, &force_break, &any_skipped);
 		if (unlikely(force_break)) {
 			addr += nr * PAGE_SIZE;
 			break;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-make-ptep_clear-non-atomic.patch
mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch

