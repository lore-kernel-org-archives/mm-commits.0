From: akpm@linux-foundation.org
Subject: +
 mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages.patch
 added to -mm tree
Date: Thu, 15 Jun 2017 13:31:49 -0700
Message-ID: <5942eeb5.jQkkQnPVtcGIe0Qs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35364 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752124AbdFOUbz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 16:31:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mgorman@suse.de, steve.capper@arm.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: stabilise page count when migrating transparent hugepages
has been added to the -mm tree.  Its filename is
     mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
