From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:36:18 -0800
Message-ID: <54dd00b2.Iktxmt97wsIkDtsN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbBLTgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, james.hogan@imgtec.com, lcapitulino@redhat.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mhocko@suse.cz, nacc@linux.vnet.ibm.com, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, steve.capper@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: pmd_huge() returns true for non-present hugepage
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: pmd_huge() returns true for non-present hugepage

Migrating hugepages and hwpoisoned hugepages are considered as non-present
hugepages, and they are referenced via migration entries and hwpoison
entries in their page table slots.

This behavior causes race condition because pmd_huge() doesn't tell
non-huge pages from migrating/hwpoisoned hugepages.  follow_page_mask() is
one example where the kernel would call follow_page_pte() for such
hugepage while this function is supposed to handle only normal pages.

To avoid this, this patch makes pmd_huge() return true when pmd_none() is
true *and* pmd_present() is false.  We don't have to worry about mixing up
non-present pmd entry with normal pmd (pointing to leaf level pte entry)
because pmd_present() is true in normal pmd.

The same race condition could happen in (x86-specific) gup_pmd_range(),
where this patch simply adds pmd_present() check instead of pmd_huge(). 
This is because gup_pmd_range() is fast path.  If we have non-present
hugepage in this function, we will go into gup_huge_pmd(), then return 0
at flag mask check, and finally fall back to the slow path.

Fixes: 290408d4a2 ("hugetlb: hugepage migration core")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: <stable@vger.kernel.org>	[2.6.36+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c         |    2 +-
 arch/x86/mm/hugetlbpage.c |    8 +++++++-
 mm/hugetlb.c              |    2 ++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/gup.c~mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage
+++ a/arch/x86/mm/gup.c
@@ -172,7 +172,7 @@ static int gup_pmd_range(pud_t pud, unsi
 		 */
 		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
 			return 0;
-		if (unlikely(pmd_large(pmd))) {
+		if (unlikely(pmd_large(pmd) || !pmd_present(pmd))) {
 			/*
 			 * NUMA hinting faults need to be handled in the GUP
 			 * slowpath for accounting purposes and so that they
diff -puN arch/x86/mm/hugetlbpage.c~mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage
+++ a/arch/x86/mm/hugetlbpage.c
@@ -54,9 +54,15 @@ int pud_huge(pud_t pud)
 
 #else
 
+/*
+ * pmd_huge() returns 1 if @pmd is hugetlb related entry, that is normal
+ * hugetlb entry or non-present (migration or hwpoisoned) hugetlb entry.
+ * Otherwise, returns 0.
+ */
 int pmd_huge(pmd_t pmd)
 {
-	return !!(pmd_val(pmd) & _PAGE_PSE);
+	return !pmd_none(pmd) &&
+		(pmd_val(pmd) & (_PAGE_PRESENT|_PAGE_PSE)) != _PAGE_PRESENT;
 }
 
 int pud_huge(pud_t pud)
diff -puN mm/hugetlb.c~mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage
+++ a/mm/hugetlb.c
@@ -3679,6 +3679,8 @@ follow_huge_pmd(struct mm_struct *mm, un
 {
 	struct page *page;
 
+	if (!pmd_present(*pmd))
+		return NULL;
 	page = pte_page(*(pte_t *)pmd);
 	if (page)
 		page += ((address & ~PMD_MASK) >> PAGE_SHIFT);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

