From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:10:32 -0700
Message-ID: <20170707191032.rbIPGvJNq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbdGGTKx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:10:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, steve.capper@arm.com, will.deacon@arm.com


The patch titled
     Subject: mm, gup: ensure real head page is ref-counted when using hugepages
has been removed from the -mm tree.  Its filename was
     mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: mm, gup: ensure real head page is ref-counted when using hugepages

When speculatively taking references to a hugepage using
page_cache_add_speculative() in gup_huge_pmd(), it is assumed that the
page returned by pmd_page() is the head page.  Although normally true,
this assumption doesn't hold when the hugepage comprises of successive
page table entries such as when using contiguous bit on arm64 at PTE or
PMD levels.

This can be addressed by ensuring that the page passed to
page_cache_add_speculative() is the real head or by de-referencing the
head page within the function.

We take the first approach to keep the usage pattern aligned with
page_cache_get_speculative() where users already pass the appropriate
page, i.e., the de-referenced head.

Apply the same logic to fix gup_huge_[pud|pgd]() as well.

[punit.agrawal@arm.com: fix arm64 ltp failure]
  Link: http://lkml.kernel.org/r/20170619170145.25577-5-punit.agrawal@arm.com
Link: http://lkml.kernel.org/r/20170522133604.11392-3-punit.agrawal@arm.com
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/gup.c~mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages mm/gup.c
--- a/mm/gup.c~mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages
+++ a/mm/gup.c
@@ -1423,8 +1423,7 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		return __gup_device_huge_pmd(orig, addr, end, pages, nr);
 
 	refs = 0;
-	head = pmd_page(orig);
-	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
 		pages[*nr] = page;
 		(*nr)++;
@@ -1432,6 +1431,7 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
+	head = compound_head(pmd_page(orig));
 	if (!page_cache_add_speculative(head, refs)) {
 		*nr -= refs;
 		return 0;
@@ -1461,8 +1461,7 @@ static int gup_huge_pud(pud_t orig, pud_
 		return __gup_device_huge_pud(orig, addr, end, pages, nr);
 
 	refs = 0;
-	head = pud_page(orig);
-	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	do {
 		pages[*nr] = page;
 		(*nr)++;
@@ -1470,6 +1469,7 @@ static int gup_huge_pud(pud_t orig, pud_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
+	head = compound_head(pud_page(orig));
 	if (!page_cache_add_speculative(head, refs)) {
 		*nr -= refs;
 		return 0;
@@ -1498,8 +1498,7 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 
 	BUILD_BUG_ON(pgd_devmap(orig));
 	refs = 0;
-	head = pgd_page(orig);
-	page = head + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
+	page = pgd_page(orig) + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
 	do {
 		pages[*nr] = page;
 		(*nr)++;
@@ -1507,6 +1506,7 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
+	head = compound_head(pgd_page(orig));
 	if (!page_cache_add_speculative(head, refs)) {
 		*nr -= refs;
 		return 0;
_

Patches currently in -mm which might be from punit.agrawal@arm.com are


