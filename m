From: akpm@linux-foundation.org
Subject: [merged]
 mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:01:32 -0800
Message-ID: <569e961c.ramVMiw07FdTnGEL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbcASUBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle PTE-mapped tail pages in gerneric fast gup implementaiton
has been removed from the -mm tree.  Its filename was
     mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: handle PTE-mapped tail pages in gerneric fast gup implementaiton

With new refcounting we are going to see THP tail pages mapped with PTE. 
Generic fast GUP rely on page_cache_get_speculative() to obtain reference
on page.  page_cache_get_speculative() always fails on tail pages, because
->_count on tail pages is always zero.

Let's handle tail pages in gup_pte_range().

New split_huge_page() will rely on migration entries to freeze page's
counts.  Recheck PTE value after page_cache_get_speculative() on head page
should be enough to serialize against split.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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

 mm/gup.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/gup.c~mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton mm/gup.c
--- a/mm/gup.c~mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton
+++ a/mm/gup.c
@@ -1097,7 +1097,7 @@ static int gup_pte_range(pmd_t pmd, unsi
 		 * for an example see gup_get_pte in arch/x86/mm/gup.c
 		 */
 		pte_t pte = READ_ONCE(*ptep);
-		struct page *page;
+		struct page *head, *page;
 
 		/*
 		 * Similar to the PMD case below, NUMA hinting must take slow
@@ -1109,15 +1109,17 @@ static int gup_pte_range(pmd_t pmd, unsi
 
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
+		head = compound_head(page);
 
-		if (!page_cache_get_speculative(page))
+		if (!page_cache_get_speculative(head))
 			goto pte_unmap;
 
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
-			put_page(page);
+			put_page(head);
 			goto pte_unmap;
 		}
 
+		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 
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

