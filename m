From: akpm@linux-foundation.org
Subject: +
 mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages-v5.patch
 added to -mm tree
Date: Mon, 19 Jun 2017 15:08:00 -0700
Message-ID: <59484b40.onc1NQepOxneuYpY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55540 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752335AbdFSWIH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2017 18:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: punit.agrawal@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages-v5
has been added to the -mm tree.  Its filename is
     mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages-v5

fix arm64 ltp failure (pth_str01, pth_str03)
(https://lkml.org/lkml/2017/6/5/332)

Link: http://lkml.kernel.org/r/20170619170145.25577-5-punit.agrawal@arm.com
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
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

 mm/gup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/gup.c~mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages-v5 mm/gup.c
--- a/mm/gup.c~mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages-v5
+++ a/mm/gup.c
@@ -1431,7 +1431,7 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(page);
+	head = compound_head(pmd_page(orig));
 	if (!page_cache_add_speculative(head, refs)) {
 		*nr -= refs;
 		return 0;
@@ -1469,7 +1469,7 @@ static int gup_huge_pud(pud_t orig, pud_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(page);
+	head = compound_head(pud_page(orig));
 	if (!page_cache_add_speculative(head, refs)) {
 		*nr -= refs;
 		return 0;
@@ -1506,7 +1506,7 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 		refs++;
 	} while (addr += PAGE_SIZE, addr != end);
 
-	head = compound_head(page);
+	head = compound_head(pgd_page(orig));
 	if (!page_cache_add_speculative(head, refs)) {
 		*nr -= refs;
 		return 0;
_

Patches currently in -mm which might be from punit.agrawal@arm.com are

mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages.patch
mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages-v5.patch
mm-hugetlb-add-size-parameter-to-huge_pte_offset.patch
mm-hugetlb-allow-architectures-to-override-huge_pte_clear.patch
mm-hugetlb-introduce-set_huge_swap_pte_at-helper.patch
mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4.patch
mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41.patch
mm-rmap-use-correct-helper-when-poisoning-hugepages.patch

