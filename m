From: akpm@linux-foundation.org
Subject: [merged]
 sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:02:20 -0800
Message-ID: <569e964c.cBuVDqRqxt77TyvU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbcASUCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc, thp: remove infrastructure for handling splitting PMDs
has been removed from the -mm tree.  Its filename was
     sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: sparc, thp: remove infrastructure for handling splitting PMDs

With new refcounting we don't need to mark PMDs splitting. Let's drop
code to handle this.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |   16 ----------------
 arch/sparc/mm/fault_64.c            |    3 ---
 arch/sparc/mm/gup.c                 |    2 +-
 3 files changed, 1 insertion(+), 20 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_64.h~sparc-thp-remove-infrastructure-for-handling-splitting-pmds arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -681,13 +681,6 @@ static inline unsigned long pmd_trans_hu
 	return pte_val(pte) & _PAGE_PMD_HUGE;
 }
 
-static inline unsigned long pmd_trans_splitting(pmd_t pmd)
-{
-	pte_t pte = __pte(pmd_val(pmd));
-
-	return pmd_trans_huge(pmd) && pte_special(pte);
-}
-
 #define has_transparent_hugepage() 1
 
 static inline pmd_t pmd_mkold(pmd_t pmd)
@@ -734,15 +727,6 @@ static inline pmd_t pmd_mkwrite(pmd_t pm
 
 	return __pmd(pte_val(pte));
 }
-
-static inline pmd_t pmd_mksplitting(pmd_t pmd)
-{
-	pte_t pte = __pte(pmd_val(pmd));
-
-	pte = pte_mkspecial(pte);
-
-	return __pmd(pte_val(pte));
-}
 
 static inline pgprot_t pmd_pgprot(pmd_t entry)
 {
diff -puN arch/sparc/mm/fault_64.c~sparc-thp-remove-infrastructure-for-handling-splitting-pmds arch/sparc/mm/fault_64.c
--- a/arch/sparc/mm/fault_64.c~sparc-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/sparc/mm/fault_64.c
@@ -113,9 +113,6 @@ static unsigned int get_user_insn(unsign
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_trans_huge(*pmdp)) {
-		if (pmd_trans_splitting(*pmdp))
-			goto out_irq_enable;
-
 		pa  = pmd_pfn(*pmdp) << PAGE_SHIFT;
 		pa += tpc & ~HPAGE_MASK;
 
diff -puN arch/sparc/mm/gup.c~sparc-thp-remove-infrastructure-for-handling-splitting-pmds arch/sparc/mm/gup.c
--- a/arch/sparc/mm/gup.c~sparc-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/sparc/mm/gup.c
@@ -114,7 +114,7 @@ static int gup_pmd_range(pud_t pud, unsi
 		pmd_t pmd = *pmdp;
 
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
+		if (pmd_none(pmd))
 			return 0;
 		if (unlikely(pmd_large(pmd))) {
 			if (!gup_huge_pmd(pmdp, pmd, addr, next,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

