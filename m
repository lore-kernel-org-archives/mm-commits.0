Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8C71EB9FD
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119222; cv=none; b=idC29XNHhvnSpv/Kw7C9O+u7AevPHG+crs9ok3owccrpfjTEOTB0GzCEs/+G+hbcifAza6IB8ZGORgmIeHiw0WJnjummPG1CKHgu59CGZlG7f6AivQoF/JaIn00O86j/9puYBd92RHXSlo5MwMkzbQCOjmhqTotMK014Z6/ulWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119222; c=relaxed/simple;
	bh=1dV3bvl9CSdqXrei8Gs7RrADNvbmn05FQDw10eAa/Fw=;
	h=Date:To:From:Subject:Message-Id; b=NfIZd+WpYFV55iwJD0rx2+fvS+Px1ibxZMOodBxGOZnnErNyK9bDouN9NJdkgORewbQGOxbZai2ojdDvo3AI35IsAzR5mXJ58ECDgH/zPtmWgVS9F+6wUD5iUuldm1hq9hoOXMycXjwycp5+VNn+C7e1o7NFbc2TtOQtx4BlcjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=frYuBC2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="frYuBC2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FC9C4CEED;
	Tue, 13 May 2025 06:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119222;
	bh=1dV3bvl9CSdqXrei8Gs7RrADNvbmn05FQDw10eAa/Fw=;
	h=Date:To:From:Subject:From;
	b=frYuBC2chp+ktDUDAz2NeSC4FHWVdZRIWUqdkQqp5yuScLbiP312L3M5n5ww5RF8X
	 UnxIPJ7EzXFoUXe5SOeXydrxS73ol2RAXR+5agUJWN7g0SXGhMNsDS17njTFtWZQ+n
	 our1sU8O6d0UyREu7N4zEeRv4JU0nqE4JHVF2OJU=
Date: Mon, 12 May 2025 23:53:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,revest@google.com,linmiaohe@huawei.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,gavinguo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-adjust-try_to_migrate_one-and-split_huge_pmd_locked.patch removed from -mm tree
Message-Id: <20250513065342.82FC9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-adjust-try_to_migrate_one-and-split_huge_pmd_locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gavin Guo <gavinguo@igalia.com>
Subject: mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()
Date: Fri, 25 Apr 2025 18:38:58 +0800

Patch series "Clean up split_huge_pmd_locked() and remove unnecessary
folio pointers", v2.

The patch series enhances the folio verification by leveraging the
existing page_vma_mapped_walk() mechanism and removing redundant folio
pointer passing.


This patch (of 2):

split_huge_pmd_locked() currently performs redundant checks for migration
entries and folio validation that are already handled by the
page_vma_mapped_walk mechanism in try_to_migrate_one.

Specifically, page_vma_mapped_walk already ensures that:
- The folio is properly mapped in the given VMA area
- pmd_trans_huge, pmd_devmap, and migration entry validation are
  performed

To leverage page_vma_mapped_walk's work, moving TTU_SPLIT_HUGE_PMD
handling to the while loop checking and removing these duplicate checks
from split_huge_pmd_locked.

Link: https://lkml.kernel.org/r/20250425103859.825879-1-gavinguo@igalia.com
Link: https://lkml.kernel.org/r/20250425103859.825879-2-gavinguo@igalia.com
Link: https://lore.kernel.org/all/98d1d195-7821-4627-b518-83103ade56c0@redhat.com/
Link: https://lore.kernel.org/all/91599a3c-e69e-4d79-bac5-5013c96203d7@redhat.com/
Signed-off-by: Gavin Guo <gavinguo@igalia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Florent Revest <revest@google.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   21 ++-------------------
 mm/rmap.c        |   18 +++++++++---------
 2 files changed, 11 insertions(+), 28 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-adjust-try_to_migrate_one-and-split_huge_pmd_locked
+++ a/mm/huge_memory.c
@@ -3082,27 +3082,10 @@ static void __split_huge_pmd_locked(stru
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze, struct folio *folio)
 {
-	bool pmd_migration = is_pmd_migration_entry(*pmd);
-
-	VM_WARN_ON_ONCE(folio && !folio_test_pmd_mappable(folio));
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
-	VM_WARN_ON_ONCE(folio && !folio_test_locked(folio));
-	VM_BUG_ON(freeze && !folio);
-
-	/*
-	 * When the caller requests to set up a migration entry, we
-	 * require a folio to check the PMD against. Otherwise, there
-	 * is a risk of replacing the wrong folio.
-	 */
-	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) || pmd_migration) {
-		/*
-		 * Do not apply pmd_folio() to a migration entry; and folio lock
-		 * guarantees that it must be of the wrong folio anyway.
-		 */
-		if (folio && (pmd_migration || folio != pmd_folio(*pmd)))
-			return;
+	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
+	    is_pmd_migration_entry(*pmd))
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
-	}
 }
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
--- a/mm/rmap.c~mm-huge_memory-adjust-try_to_migrate_one-and-split_huge_pmd_locked
+++ a/mm/rmap.c
@@ -2292,13 +2292,6 @@ static bool try_to_migrate_one(struct fo
 		pvmw.flags = PVMW_SYNC;
 
 	/*
-	 * unmap_page() in mm/huge_memory.c is the only user of migration with
-	 * TTU_SPLIT_HUGE_PMD and it wants to freeze.
-	 */
-	if (flags & TTU_SPLIT_HUGE_PMD)
-		split_huge_pmd_address(vma, address, true, folio);
-
-	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
 	 * For hugetlb, it could be much worse if we need to do pud
 	 * invalidation in the case of pmd sharing.
@@ -2323,9 +2316,16 @@ static bool try_to_migrate_one(struct fo
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
+			if (flags & TTU_SPLIT_HUGE_PMD) {
+				split_huge_pmd_locked(vma, pvmw.address,
+						      pvmw.pmd, true, NULL);
+				ret = false;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
+			}
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 			subpage = folio_page(folio,
 				pmd_pfn(*pvmw.pmd) - folio_pfn(folio));
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
@@ -2337,8 +2337,8 @@ static bool try_to_migrate_one(struct fo
 				break;
 			}
 			continue;
-		}
 #endif
+		}
 
 		/* Unexpected PMD-mapped THP? */
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
_

Patches currently in -mm which might be from gavinguo@igalia.com are


