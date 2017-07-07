From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:10:29 -0700
Message-ID: <20170707191029.JaPAmlgXS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbdGGTKw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, steve.capper@arm.com, will.deacon@arm.com


The patch titled
     Subject: mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages

When operating on hugepages with DEBUG_VM enabled, the GUP code checks the
compound head for each tail page prior to calling
page_cache_add_speculative.  This is broken, because on the fast-GUP path
(where we don't hold any page table locks) we can be racing with a
concurrent invocation of split_huge_page_to_list.

split_huge_page_to_list deals with this race by using page_ref_freeze to
freeze the page and force concurrent GUPs to fail whilst the component
pages are modified.  This modification includes clearing the compound_head
field for the tail pages, so checking this prior to a successful call to
page_cache_add_speculative can lead to false positives: In fact,
page_cache_add_speculative *already* has this check once the page refcount
has been successfully updated, so we can simply remove the broken calls to
VM_BUG_ON_PAGE.

Link: http://lkml.kernel.org/r/20170522133604.11392-2-punit.agrawal@arm.com
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/gup.c~mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages mm/gup.c
--- a/mm/gup.c~mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages
+++ a/mm/gup.c
@@ -1426,7 +1426,6 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 	head = pmd_page(orig);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
@@ -1465,7 +1464,6 @@ static int gup_huge_pud(pud_t orig, pud_
 	head = pud_page(orig);
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
@@ -1503,7 +1501,6 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 	head = pgd_page(orig);
 	page = head + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
_

Patches currently in -mm which might be from will.deacon@arm.com are

mm-page_ref-ensure-page_ref_unfreeze-is-ordered-against-prior-accesses.patch
mm-migrate-stabilise-page-count-when-migrating-transparent-hugepages.patch
frv-cmpxchg-implement-cmpxchg64.patch

