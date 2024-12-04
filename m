Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9471F541C
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 22:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352785; cv=none; b=O76uHtUNZ0ccCNCNyJ3X+SWpzeD2AzP3zsvvbNCcmLJ8o6GwTF5du8gtYaWaFMfjv5rs/oG6hvku8yaRgePphiFIPNC1jZQ090ahlzrQIkOESsNiRlJY//uTYUuMv1bSxW+Qq9RZSp72ovJQkDezu7J2OCWAZCTGCx244EsoNLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352785; c=relaxed/simple;
	bh=eMz6H359UptZiLApfLZ8QKglVvgJv77eWSuKw1uvKag=;
	h=Date:To:From:Subject:Message-Id; b=kK+6WIUMx2qOWPQ5YI5PwZ281rJtm2GXqSD9aIwSLJfINEAFm04R017eHPAikiTiqbdTlZpujibYyAv7EwqFS5wPO7saK1VIz8Jng01DJ7FkoPf2YNG2dGUKClycd8DE3HNnsaV6xt68RlM1ADyrB+NdYD1sqiWqYTXbOqE4iBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gRg4Ebva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gRg4Ebva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95475C4CECD;
	Wed,  4 Dec 2024 22:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733352784;
	bh=eMz6H359UptZiLApfLZ8QKglVvgJv77eWSuKw1uvKag=;
	h=Date:To:From:Subject:From;
	b=gRg4Ebva4inF62hVJoTNEzo52T31Xd5vB7UAQBNg17/0AwIgtMg/rMb9ISllmzFd7
	 6wJ99AvmlCDwkrMUQ3kXlOSEMWbxNUwqDpkFx1q1kdsJHj2hSOb96cIIRQ48+OIJNJ
	 tyO5Ybsr8G8UcUdsB4ZFYEJfipEFSWvKqyIPpiVc=
Date: Wed, 04 Dec 2024 14:53:04 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-zap_nonpresent_ptes.patch added to mm-unstable branch
Message-Id: <20241204225304.95475C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce zap_nonpresent_ptes()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-zap_nonpresent_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-zap_nonpresent_ptes.patch

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
Subject: mm: introduce zap_nonpresent_ptes()
Date: Wed, 4 Dec 2024 19:09:43 +0800

Similar to zap_present_ptes(), let's introduce zap_nonpresent_ptes() to
handle non-present ptes, which can improve code readability.

No functional change.

Link: https://lkml.kernel.org/r/009ca882036d9c7a9f815489cfeafe0bdb79d62d.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
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

 mm/memory.c |  136 ++++++++++++++++++++++++++------------------------
 1 file changed, 73 insertions(+), 63 deletions(-)

--- a/mm/memory.c~mm-introduce-zap_nonpresent_ptes
+++ a/mm/memory.c
@@ -1587,6 +1587,76 @@ static inline int zap_present_ptes(struc
 	return 1;
 }
 
+static inline int zap_nonpresent_ptes(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
+		unsigned int max_nr, unsigned long addr,
+		struct zap_details *details, int *rss)
+{
+	swp_entry_t entry;
+	int nr = 1;
+
+	entry = pte_to_swp_entry(ptent);
+	if (is_device_private_entry(entry) ||
+		is_device_exclusive_entry(entry)) {
+		struct page *page = pfn_swap_entry_to_page(entry);
+		struct folio *folio = page_folio(page);
+
+		if (unlikely(!should_zap_folio(details, folio)))
+			return 1;
+		/*
+		 * Both device private/exclusive mappings should only
+		 * work with anonymous page so far, so we don't need to
+		 * consider uffd-wp bit when zap. For more information,
+		 * see zap_install_uffd_wp_if_needed().
+		 */
+		WARN_ON_ONCE(!vma_is_anonymous(vma));
+		rss[mm_counter(folio)]--;
+		if (is_device_private_entry(entry))
+			folio_remove_rmap_pte(folio, page, vma);
+		folio_put(folio);
+	} else if (!non_swap_entry(entry)) {
+		/* Genuine swap entries, hence a private anon pages */
+		if (!should_zap_cows(details))
+			return 1;
+
+		nr = swap_pte_batch(pte, max_nr, ptent);
+		rss[MM_SWAPENTS] -= nr;
+		free_swap_and_cache_nr(entry, nr);
+	} else if (is_migration_entry(entry)) {
+		struct folio *folio = pfn_swap_entry_folio(entry);
+
+		if (!should_zap_folio(details, folio))
+			return 1;
+		rss[mm_counter(folio)]--;
+	} else if (pte_marker_entry_uffd_wp(entry)) {
+		/*
+		 * For anon: always drop the marker; for file: only
+		 * drop the marker if explicitly requested.
+		 */
+		if (!vma_is_anonymous(vma) && !zap_drop_markers(details))
+			return 1;
+	} else if (is_guard_swp_entry(entry)) {
+		/*
+		 * Ordinary zapping should not remove guard PTE
+		 * markers. Only do so if we should remove PTE markers
+		 * in general.
+		 */
+		if (!zap_drop_markers(details))
+			return 1;
+	} else if (is_hwpoison_entry(entry) || is_poisoned_swp_entry(entry)) {
+		if (!should_zap_cows(details))
+			return 1;
+	} else {
+		/* We should have covered all the swap entry types */
+		pr_alert("unrecognized swap entry 0x%lx\n", entry.val);
+		WARN_ON_ONCE(1);
+	}
+	clear_not_present_full_ptes(vma->vm_mm, addr, pte, nr, tlb->fullmm);
+	zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details, ptent);
+
+	return nr;
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1598,7 +1668,6 @@ static unsigned long zap_pte_range(struc
 	spinlock_t *ptl;
 	pte_t *start_pte;
 	pte_t *pte;
-	swp_entry_t entry;
 	int nr;
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
@@ -1611,8 +1680,6 @@ static unsigned long zap_pte_range(struc
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = ptep_get(pte);
-		struct folio *folio;
-		struct page *page;
 		int max_nr;
 
 		nr = 1;
@@ -1622,8 +1689,8 @@ static unsigned long zap_pte_range(struc
 		if (need_resched())
 			break;
 
+		max_nr = (end - addr) / PAGE_SIZE;
 		if (pte_present(ptent)) {
-			max_nr = (end - addr) / PAGE_SIZE;
 			nr = zap_present_ptes(tlb, vma, pte, ptent, max_nr,
 					      addr, details, rss, &force_flush,
 					      &force_break);
@@ -1631,67 +1698,10 @@ static unsigned long zap_pte_range(struc
 				addr += nr * PAGE_SIZE;
 				break;
 			}
-			continue;
-		}
-
-		entry = pte_to_swp_entry(ptent);
-		if (is_device_private_entry(entry) ||
-		    is_device_exclusive_entry(entry)) {
-			page = pfn_swap_entry_to_page(entry);
-			folio = page_folio(page);
-			if (unlikely(!should_zap_folio(details, folio)))
-				continue;
-			/*
-			 * Both device private/exclusive mappings should only
-			 * work with anonymous page so far, so we don't need to
-			 * consider uffd-wp bit when zap. For more information,
-			 * see zap_install_uffd_wp_if_needed().
-			 */
-			WARN_ON_ONCE(!vma_is_anonymous(vma));
-			rss[mm_counter(folio)]--;
-			if (is_device_private_entry(entry))
-				folio_remove_rmap_pte(folio, page, vma);
-			folio_put(folio);
-		} else if (!non_swap_entry(entry)) {
-			max_nr = (end - addr) / PAGE_SIZE;
-			nr = swap_pte_batch(pte, max_nr, ptent);
-			/* Genuine swap entries, hence a private anon pages */
-			if (!should_zap_cows(details))
-				continue;
-			rss[MM_SWAPENTS] -= nr;
-			free_swap_and_cache_nr(entry, nr);
-		} else if (is_migration_entry(entry)) {
-			folio = pfn_swap_entry_folio(entry);
-			if (!should_zap_folio(details, folio))
-				continue;
-			rss[mm_counter(folio)]--;
-		} else if (pte_marker_entry_uffd_wp(entry)) {
-			/*
-			 * For anon: always drop the marker; for file: only
-			 * drop the marker if explicitly requested.
-			 */
-			if (!vma_is_anonymous(vma) &&
-			    !zap_drop_markers(details))
-				continue;
-		} else if (is_guard_swp_entry(entry)) {
-			/*
-			 * Ordinary zapping should not remove guard PTE
-			 * markers. Only do so if we should remove PTE markers
-			 * in general.
-			 */
-			if (!zap_drop_markers(details))
-				continue;
-		} else if (is_hwpoison_entry(entry) ||
-			   is_poisoned_swp_entry(entry)) {
-			if (!should_zap_cows(details))
-				continue;
 		} else {
-			/* We should have covered all the swap entry types */
-			pr_alert("unrecognized swap entry 0x%lx\n", entry.val);
-			WARN_ON_ONCE(1);
+			nr = zap_nonpresent_ptes(tlb, vma, pte, ptent, max_nr,
+						 addr, details, rss);
 		}
-		clear_not_present_full_ptes(mm, addr, pte, nr, tlb->fullmm);
-		zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details, ptent);
 	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
 
 	add_mm_rss_vec(mm, rss);
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

