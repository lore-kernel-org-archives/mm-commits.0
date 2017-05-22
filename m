From: akpm@linux-foundation.org
Subject: +
 mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages.patch
 added to -mm tree
Date: Mon, 22 May 2017 14:00:34 -0700
Message-ID: <59235172.a0muPp/20i80kcGN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762661AbdEVVAg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2017 17:00:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, steve.capper@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages
has been added to the -mm tree.  Its filename is
     mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages.patch

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
Subject: mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages

Patch series "Support for contiguous pte hugepages", v3.

This patchset updates the hugetlb code to fix issues arising from
contiguous pte hugepages (such as on arm64).  These are the generic code
changes and the arm64 support based on these patches will be posted
separately.  The patches are based on v4.12-rc2.  Previous related
postings can be found at [0], [1] and [2].

The patches fall into two categories -

* Patches 1-2 address issues with gup

* Patches 3-6 relate to passing a size argument to hugepage helpers to
  disambiguate the size of the referred page. These changes are
  required to enable arch code to properly handle swap entries for
  contiguous pte hugepages.

  The changes to huge_pte_offset() (patch 3) touch multiple
  architectures but I've managed to minimise these changes for the
  other affected functions - huge_pte_clear() and set_huge_pte_at().

These patches gate the enabling of contiguous hugepages support on arm64
which has been requested for systems using !4k page granule.


This patch (of 6):

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
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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
@@ -1435,7 +1435,6 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 	head = pmd_page(orig);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
@@ -1474,7 +1473,6 @@ static int gup_huge_pud(pud_t orig, pud_
 	head = pud_page(orig);
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
@@ -1512,7 +1510,6 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 	head = pgd_page(orig);
 	page = head + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
_

Patches currently in -mm which might be from will.deacon@arm.com are

mm-gup-remove-broken-vm_bug_on_page-compound-check-for-hugepages.patch

