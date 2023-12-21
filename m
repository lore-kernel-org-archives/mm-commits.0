Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAD078E85
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="004ab1io"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0E3C433C8;
	Thu, 21 Dec 2023 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197785;
	bh=ZRJdrtKLfgqEC7GTyVHkoGqEKXalyrh8uyie/1oPZY0=;
	h=Date:To:From:Subject:From;
	b=004ab1ioL3HTgVkmJ9/R1/EWj0XvR0Pd8y2UNItc3Abu/S5OgqJ6k9t/aLjBvAQcb
	 b5XvX88jq6CVha7T3xVRpqViZcYDrsuwrCTJRFp6U6AIXsj0NbI8Pv63K88EtNsbJo
	 SDi6pIqrZYRVT8uABnySTyQgJ7jZQMvS9pZuVGsU=
Date: Thu, 21 Dec 2023 14:29:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked.patch added to mm-unstable branch
Message-Id: <20231221222945.9C0E3C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: batch rmap operations in __split_huge_pmd_locked()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked.patch

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
Subject: mm/huge_memory: batch rmap operations in __split_huge_pmd_locked()
Date: Wed, 20 Dec 2023 23:44:39 +0100

Let's use folio_add_anon_rmap_ptes(), batching the rmap operations.

While at it, use more folio operations (but only in the code branch we're
touching), use VM_WARN_ON_FOLIO(), and pass RMAP_EXCLUSIVE instead of
manually setting PageAnonExclusive.

We should never see non-anon pages on that branch: otherwise, the existing
page_add_anon_rmap() call would have been flawed already.

Link: https://lkml.kernel.org/r/20231220224504.646757-16-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked
+++ a/mm/huge_memory.c
@@ -2398,6 +2398,7 @@ static void __split_huge_pmd_locked(stru
 		unsigned long haddr, bool freeze)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	struct folio *folio;
 	struct page *page;
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
@@ -2493,16 +2494,18 @@ static void __split_huge_pmd_locked(stru
 		uffd_wp = pmd_swp_uffd_wp(old_pmd);
 	} else {
 		page = pmd_page(old_pmd);
+		folio = page_folio(page);
 		if (pmd_dirty(old_pmd)) {
 			dirty = true;
-			SetPageDirty(page);
+			folio_set_dirty(folio);
 		}
 		write = pmd_write(old_pmd);
 		young = pmd_young(old_pmd);
 		soft_dirty = pmd_soft_dirty(old_pmd);
 		uffd_wp = pmd_uffd_wp(old_pmd);
 
-		VM_BUG_ON_PAGE(!page_count(page), page);
+		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
+		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
 		/*
 		 * Without "freeze", we'll simply split the PMD, propagating the
@@ -2519,11 +2522,18 @@ static void __split_huge_pmd_locked(stru
 		 *
 		 * See page_try_share_anon_rmap(): invalidate PMD first.
 		 */
-		anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
+		anon_exclusive = PageAnonExclusive(page);
 		if (freeze && anon_exclusive && page_try_share_anon_rmap(page))
 			freeze = false;
-		if (!freeze)
-			page_ref_add(page, HPAGE_PMD_NR - 1);
+		if (!freeze) {
+			rmap_t rmap_flags = RMAP_NONE;
+
+			folio_ref_add(folio, HPAGE_PMD_NR - 1);
+			if (anon_exclusive)
+				rmap_flags |= RMAP_EXCLUSIVE;
+			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
+						 vma, haddr, rmap_flags);
+		}
 	}
 
 	/*
@@ -2566,8 +2576,6 @@ static void __split_huge_pmd_locked(stru
 			entry = mk_pte(page + i, READ_ONCE(vma->vm_page_prot));
 			if (write)
 				entry = pte_mkwrite(entry, vma);
-			if (anon_exclusive)
-				SetPageAnonExclusive(page + i);
 			if (!young)
 				entry = pte_mkold(entry);
 			/* NOTE: this may set soft-dirty too on some archs */
@@ -2577,7 +2585,6 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_mksoft_dirty(entry);
 			if (uffd_wp)
 				entry = pte_mkuffd_wp(entry);
-			page_add_anon_rmap(page + i, vma, addr, RMAP_NONE);
 		}
 		VM_BUG_ON(!pte_none(ptep_get(pte)));
 		set_pte_at(mm, addr, pte, entry);
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

