Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85720195FE8
	for <mm-commits@vger.kernel.org>; Sat, 26 Apr 2025 00:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745627247; cv=none; b=Vxd4B8vJfLGyHz0V80uOfpsBVe72VKjpAW2yqCM0pA/W6AHDuP1oTX601PIUMbOGtskdLALfZizuL39gjQjxX8KatlLr6h049KKrSWJm1D6WJh+pbVlppB4vgq6hQx4q1vZV6zyDs3fxxbgSJh6t9YY/EVMl4L+WLjVZxSoQP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745627247; c=relaxed/simple;
	bh=Wz4GHeov24ggMwnOAzeYzY/jzkkbsB4SftSaxFSoATg=;
	h=Date:To:From:Subject:Message-Id; b=KKThF8i2WtCJjEgGM81bKy2RXGs/3XqwwZ49VRPAjjHfZvCvdqUvQQ5Mp6FsK2/TYTsvFbCZwECiXMht4q3i5R1UeQzUmfhbrkzmtgfDXbAJIbEfBniuiupDMzbtjIr8WsX3V+Hcn/zEIBN6J1b8rfcHLM5re1dCuhVSWbI9qDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x1agf2K8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x1agf2K8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12B5C4CEE4;
	Sat, 26 Apr 2025 00:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745627246;
	bh=Wz4GHeov24ggMwnOAzeYzY/jzkkbsB4SftSaxFSoATg=;
	h=Date:To:From:Subject:From;
	b=x1agf2K8a74msndLuSbNCtreA1KLkZlmAkMpIPR4/JR20KuxO/nLLyIbanfG3/R7v
	 PPzu3C7K5ZzOHqIFvrt6xMpEXX2h3zBRKOmPsurwjw+q7TzcI+9GOpg1/OvuCm5FUB
	 nUidiRX/rPOnGdknw01Rt4gC2qecMq8dnfgRkGwI=
Date: Fri, 25 Apr 2025 17:27:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,revest@google.com,linmiaohe@huawei.com,hughd@google.com,gshan@redhat.com,david@redhat.com,gavinguo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-adjust-try_to_migrate_one-and-split_huge_pmd_locked.patch added to mm-unstable branch
Message-Id: <20250426002726.C12B5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-adjust-try_to_migrate_one-and-split_huge_pmd_locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-adjust-try_to_migrate_one-and-split_huge_pmd_locked.patch

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

mm-huge_memory-fix-dereferencing-invalid-pmd-migration-entry.patch
mm-huge_memory-adjust-try_to_migrate_one-and-split_huge_pmd_locked.patch
mm-huge_memory-remove-useless-folio-pointers-passing.patch

