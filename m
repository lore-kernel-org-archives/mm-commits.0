Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DCF7949B
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YFWZaTnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25E5C433C9;
	Thu, 21 Dec 2023 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197811;
	bh=YV2lwvg+ZTuOzXIeAIoFgLPhGPiwPkLcPu+adeCwyrc=;
	h=Date:To:From:Subject:From;
	b=YFWZaTnliMRp9pKR+ueF/wuWsZOJv/JF20T126cxdOAh3Sf7+ZOKJp2ufNyd6othA
	 5NS7/HHuMXK+2aUMDz8cdA/1zakAiKg9vlerjVvn2wFnJKouhFyG/3pHAyNmz/3g0a
	 zQi0mcI+n6E1fRcMdWh8TorokLYREGXW9hyGQF0Y=
Date: Thu, 21 Dec 2023 14:30:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte.patch added to mm-unstable branch
Message-Id: <20231221223011.D25E5C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: page_try_dup_anon_rmap() -> folio_try_dup_anon_rmap_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte.patch

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
Subject: mm/memory: page_try_dup_anon_rmap() -> folio_try_dup_anon_rmap_pte()
Date: Wed, 20 Dec 2023 23:45:00 +0100

Let's convert copy_nonpresent_pte().  While at it, perform some more folio
conversion.

Link: https://lkml.kernel.org/r/20231220224504.646757-37-david@redhat.com
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

 mm/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte
+++ a/mm/memory.c
@@ -785,6 +785,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 	unsigned long vm_flags = dst_vma->vm_flags;
 	pte_t orig_pte = ptep_get(src_pte);
 	pte_t pte = orig_pte;
+	struct folio *folio;
 	struct page *page;
 	swp_entry_t entry = pte_to_swp_entry(orig_pte);
 
@@ -829,6 +830,7 @@ copy_nonpresent_pte(struct mm_struct *ds
 		}
 	} else if (is_device_private_entry(entry)) {
 		page = pfn_swap_entry_to_page(entry);
+		folio = page_folio(page);
 
 		/*
 		 * Update rss count even for unaddressable pages, as
@@ -839,10 +841,10 @@ copy_nonpresent_pte(struct mm_struct *ds
 		 * for unaddressable pages, at some point. But for now
 		 * keep things as they are.
 		 */
-		get_page(page);
+		folio_get(folio);
 		rss[mm_counter(page)]++;
 		/* Cannot fail as these pages cannot get pinned. */
-		BUG_ON(page_try_dup_anon_rmap(page, false, src_vma));
+		folio_try_dup_anon_rmap_pte(folio, page, src_vma);
 
 		/*
 		 * We do not preserve soft-dirty information, because so
@@ -956,7 +958,7 @@ copy_present_pte(struct vm_area_struct *
 		 * future.
 		 */
 		folio_get(folio);
-		if (unlikely(page_try_dup_anon_rmap(page, false, src_vma))) {
+		if (unlikely(folio_try_dup_anon_rmap_pte(folio, page, src_vma))) {
 			/* Page may be pinned, we have to copy. */
 			folio_put(folio);
 			return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
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

