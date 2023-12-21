Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7481677F03
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VSbosMxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C745C433C7;
	Thu, 21 Dec 2023 22:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197801;
	bh=8Ex4lqND8/ZRxq0ev2hoV4BlNICVMS11GP+k4Nc7i/c=;
	h=Date:To:From:Subject:From;
	b=VSbosMxwtsa0qhD8GYMU0Wh1YBDFVOpW7W9zccyFdv5RcSCSkqbkXLrn5YPrtdsyZ
	 IWjbH3Gp7m5euLsm8PqA1bhIBcgc2uLEVNnzcMnLrPozQGLGuH8+Y+uilopsKstqKd
	 VJvz3ZkzmEzFhE6qYzf1I8d3Duqu554SYPPrfh9Q=
Date: Thu, 21 Dec 2023 14:30:00 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-page_remove_rmap-folio_remove_rmap_pte.patch added to mm-unstable branch
Message-Id: <20231221223001.3C745C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: page_remove_rmap() -> folio_remove_rmap_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-page_remove_rmap-folio_remove_rmap_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-page_remove_rmap-folio_remove_rmap_pte.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: page_remove_rmap() -> folio_remove_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:52 +0100

Let's convert zap_pte_range() and closely-related tlb_flush_rmap_batch(). 
While at it, perform some more folio conversion in zap_pte_range().

Link: https://lkml.kernel.org/r/20231220224504.646757-29-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |   23 +++++++++++++----------
 mm/mmu_gather.c |    2 +-
 2 files changed, 14 insertions(+), 11 deletions(-)

--- a/mm/memory.c~mm-memory-page_remove_rmap-folio_remove_rmap_pte
+++ a/mm/memory.c
@@ -1434,6 +1434,7 @@ static unsigned long zap_pte_range(struc
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = ptep_get(pte);
+		struct folio *folio;
 		struct page *page;
 
 		if (pte_none(ptent))
@@ -1459,21 +1460,22 @@ static unsigned long zap_pte_range(struc
 				continue;
 			}
 
+			folio = page_folio(page);
 			delay_rmap = 0;
-			if (!PageAnon(page)) {
+			if (!folio_test_anon(folio)) {
 				if (pte_dirty(ptent)) {
-					set_page_dirty(page);
+					folio_set_dirty(folio);
 					if (tlb_delay_rmap(tlb)) {
 						delay_rmap = 1;
 						force_flush = 1;
 					}
 				}
 				if (pte_young(ptent) && likely(vma_has_recency(vma)))
-					mark_page_accessed(page);
+					folio_mark_accessed(folio);
 			}
 			rss[mm_counter(page)]--;
 			if (!delay_rmap) {
-				page_remove_rmap(page, vma, false);
+				folio_remove_rmap_pte(folio, page, vma);
 				if (unlikely(page_mapcount(page) < 0))
 					print_bad_pte(vma, addr, ptent, page);
 			}
@@ -1489,6 +1491,7 @@ static unsigned long zap_pte_range(struc
 		if (is_device_private_entry(entry) ||
 		    is_device_exclusive_entry(entry)) {
 			page = pfn_swap_entry_to_page(entry);
+			folio = page_folio(page);
 			if (unlikely(!should_zap_page(details, page)))
 				continue;
 			/*
@@ -1500,8 +1503,8 @@ static unsigned long zap_pte_range(struc
 			WARN_ON_ONCE(!vma_is_anonymous(vma));
 			rss[mm_counter(page)]--;
 			if (is_device_private_entry(entry))
-				page_remove_rmap(page, vma, false);
-			put_page(page);
+				folio_remove_rmap_pte(folio, page, vma);
+			folio_put(folio);
 		} else if (!non_swap_entry(entry)) {
 			/* Genuine swap entry, hence a private anon page */
 			if (!should_zap_cows(details))
@@ -3220,10 +3223,10 @@ static vm_fault_t wp_page_copy(struct vm
 			 * threads.
 			 *
 			 * The critical issue is to order this
-			 * page_remove_rmap with the ptp_clear_flush above.
-			 * Those stores are ordered by (if nothing else,)
+			 * folio_remove_rmap_pte() with the ptp_clear_flush
+			 * above. Those stores are ordered by (if nothing else,)
 			 * the barrier present in the atomic_add_negative
-			 * in page_remove_rmap.
+			 * in folio_remove_rmap_pte();
 			 *
 			 * Then the TLB flush in ptep_clear_flush ensures that
 			 * no process can access the old page before the
@@ -3232,7 +3235,7 @@ static vm_fault_t wp_page_copy(struct vm
 			 * mapcount is visible. So transitively, TLBs to
 			 * old page will be flushed before it can be reused.
 			 */
-			page_remove_rmap(vmf->page, vma, false);
+			folio_remove_rmap_pte(old_folio, vmf->page, vma);
 		}
 
 		/* Free the old page.. */
--- a/mm/mmu_gather.c~mm-memory-page_remove_rmap-folio_remove_rmap_pte
+++ a/mm/mmu_gather.c
@@ -55,7 +55,7 @@ static void tlb_flush_rmap_batch(struct
 
 		if (encoded_page_flags(enc)) {
 			struct page *page = encoded_page_ptr(enc);
-			page_remove_rmap(page, vma, false);
+			folio_remove_rmap_pte(page_folio(page), page, vma);
 		}
 	}
 }
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-rename-hugepage_add-to-hugetlb_add.patch
mm-rmap-introduce-and-use-hugetlb_remove_rmap.patch
mm-rmap-introduce-and-use-hugetlb_add_file_rmap.patch
mm-rmap-introduce-and-use-hugetlb_try_dup_anon_rmap.patch
mm-rmap-introduce-and-use-hugetlb_try_share_anon_rmap.patch
mm-rmap-add-hugetlb-sanity-checks-for-anon-rmap-handling.patch
mm-rmap-convert-folio_add_file_rmap_range-into-folio_add_file_rmap_.patch
mm-memory-page_add_file_rmap-folio_add_file_rmap_.patch
mm-huge_memory-page_add_file_rmap-folio_add_file_rmap_pmd.patch
mm-migrate-page_add_file_rmap-folio_add_file_rmap_pte.patch
mm-userfaultfd-page_add_file_rmap-folio_add_file_rmap_pte.patch
mm-rmap-remove-page_add_file_rmap.patch
mm-rmap-factor-out-adding-folio-mappings-into-__folio_add_rmap.patch
mm-rmap-introduce-folio_add_anon_rmap_.patch
mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked.patch
mm-huge_memory-page_add_anon_rmap-folio_add_anon_rmap_pmd.patch
mm-migrate-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-swapfile-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-memory-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-rmap-remove-page_add_anon_rmap.patch
mm-rmap-remove-rmap_compound.patch
mm-rmap-introduce-folio_remove_rmap_.patch
kernel-events-uprobes-page_remove_rmap-folio_remove_rmap_pte.patch
mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd.patch
mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte.patch
mm-ksm-page_remove_rmap-folio_remove_rmap_pte.patch
mm-memory-page_remove_rmap-folio_remove_rmap_pte.patch
mm-migrate_device-page_remove_rmap-folio_remove_rmap_pte.patch
mm-rmap-page_remove_rmap-folio_remove_rmap_pte.patch
documentation-stop-referring-to-page_remove_rmap.patch
mm-rmap-remove-page_remove_rmap.patch
mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_.patch
mm-rmap-introduce-folio_try_dup_anon_rmap_.patch
mm-huge_memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pmd.patch
mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte.patch
mm-rmap-remove-page_try_dup_anon_rmap.patch
mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_.patch
mm-rmap-rename-compound_mapped-to-entirely_mapped.patch
mm-remove-one-last-reference-to-page_add__rmap.patch

