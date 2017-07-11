From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:46 -0700
Message-ID: <20170711192346.iW32U6Z-m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933716AbdGKTXr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mgorman@suse.de, mm-commits@vger.kernel.org, steve.capper@arm.com, vbabka@suse.cz, will.deacon@arm.com


The patch titled
     Subject: mm/migrate.c: stabilise page count when migrating transparent hugepages
has been removed from the -mm tree.  Its filename was
     mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: mm/migrate.c: stabilise page count when migrating transparent hugepages

When migrating a transparent hugepage, migrate_misplaced_transhuge_page
guards itself against a concurrent fastgup of the page by checking that
the page count is equal to 2 before and after installing the new pmd.

If the page count changes, then the pmd is reverted back to the original
entry, however there is a small window where the new (possibly writable)
pmd is installed and the underlying page could be written by userspace. 
Restoring the old pmd could therefore result in loss of data.

This patch fixes the problem by freezing the page count whilst updating
the page tables, which protects against a concurrent fastgup without the
need to restore the old pmd in the failure case (since the page count can
no longer change under our feet).

Link: http://lkml.kernel.org/r/1497349722-6731-4-git-send-email-will.deacon@arm.com
Signed-off-by: Will Deacon <will.deacon@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN mm/migrate.c~mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages mm/migrate.c
--- a/mm/migrate.c~mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages
+++ a/mm/migrate.c
@@ -1916,7 +1916,6 @@ int migrate_misplaced_transhuge_page(str
 	int page_lru = page_is_file_cache(page);
 	unsigned long mmun_start = address & HPAGE_PMD_MASK;
 	unsigned long mmun_end = mmun_start + HPAGE_PMD_SIZE;
-	pmd_t orig_entry;
 
 	/*
 	 * Rate-limit the amount of data that is being migrated to a node.
@@ -1959,8 +1958,7 @@ int migrate_misplaced_transhuge_page(str
 	/* Recheck the target PMD */
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	ptl = pmd_lock(mm, pmd);
-	if (unlikely(!pmd_same(*pmd, entry) || page_count(page) != 2)) {
-fail_putback:
+	if (unlikely(!pmd_same(*pmd, entry) || !page_ref_freeze(page, 2))) {
 		spin_unlock(ptl);
 		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
@@ -1982,7 +1980,6 @@ fail_putback:
 		goto out_unlock;
 	}
 
-	orig_entry = *pmd;
 	entry = mk_huge_pmd(new_page, vma->vm_page_prot);
 	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
@@ -1999,15 +1996,7 @@ fail_putback:
 	set_pmd_at(mm, mmun_start, pmd, entry);
 	update_mmu_cache_pmd(vma, address, &entry);
 
-	if (page_count(page) != 2) {
-		set_pmd_at(mm, mmun_start, pmd, orig_entry);
-		flush_pmd_tlb_range(vma, mmun_start, mmun_end);
-		mmu_notifier_invalidate_range(mm, mmun_start, mmun_end);
-		update_mmu_cache_pmd(vma, address, &entry);
-		page_remove_rmap(new_page, true);
-		goto fail_putback;
-	}
