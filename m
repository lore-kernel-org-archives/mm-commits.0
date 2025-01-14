Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0D323C6EC
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837000; cv=none; b=Y98wfdUYx/Khf6VtCaWAAPTvQNaAQjZXKvCPmjbglCnNKHrCQ0ppmyYYluK9i2jnI5jBjSU5Mc2t7poIUDoV0xT2NJmK/Y5m4NhIaG5EoS+4PaAS+YCKp2Lk8jCJZGY3SkpEeoraoMv6/SSn3PBWweUZwGEfAN9M53pUlE0sYD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837000; c=relaxed/simple;
	bh=WLTh9+o1WrNIub8UhD//8kk5NKQurAKDdLK3acv5hBg=;
	h=Date:To:From:Subject:Message-Id; b=n5M5PhMTyarDqW9O5YNxL5B+PoxeuTPy3vy3I0QlKHFEs54h6+JfuyDHksywpMnTMLwBbiD05IM2sCt57ql2qmFD9WshaLhq8jtZjNXJIyNb3tU4EVptUiTZhbsqbpu5GqCet7O7yfl55ugrAnHeBTmrzWfO4lU9yqKKoNEKEYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JV8Lkw02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JV8Lkw02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2620C4CEDD;
	Tue, 14 Jan 2025 06:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836999;
	bh=WLTh9+o1WrNIub8UhD//8kk5NKQurAKDdLK3acv5hBg=;
	h=Date:To:From:Subject:From;
	b=JV8Lkw02Y/JhZZ97RQM4Ral0hY5krdRMXkWIIxlwGk8pVjk1RSjY72vrnKZd/GvmT
	 haYacDCrZBbTKx95qQl5+9bqMt6al6dJdKSTsh+Ie+5woTdytsEnUSdVxVGr22UESU
	 dU1jmZqq44AMAMdbY6HMNIEdozrDAUM4CiPba92g=
Date: Mon, 13 Jan 2025 22:43:19 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-zap_nonpresent_ptes.patch removed from -mm tree
Message-Id: <20250114064319.D2620C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce zap_nonpresent_ptes()
has been removed from the -mm tree.  Its filename was
     mm-introduce-zap_nonpresent_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Dan Carpenter <dan.carpenter@linaro.org>
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


