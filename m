From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:01:26 -0800
Message-ID: <569e9616.95zHapE7X7PTI5ou%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044AbcASUB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: adjust conditions when we can reuse the page on WP fault
has been removed from the -mm tree.  Its filename was
     mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, thp: adjust conditions when we can reuse the page on WP fault

With new refcounting we will be able map the same compound page with PTEs
and PMDs.  It requires adjustment to conditions when we can reuse the page
on write-protection fault.

For PTE fault we can't reuse the page if it's part of huge page.

For PMD we can only reuse the page if nobody else maps the huge page or
it's part.  We can do it by checking page_mapcount() on each sub-page, but
it's expensive.

The cheaper way is to check page_count() to be equal 1: every mapcount
takes page reference, so this way we can guarantee, that the PMD is the
only mapping.

This approach can give false negative if somebody pinned the page, but
that doesn't affect correctness.

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

 include/linux/swap.h |    3 ++-
 mm/huge_memory.c     |   12 +++++++++++-
 mm/swapfile.c        |    3 +++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault include/linux/swap.h
--- a/include/linux/swap.h~mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault
+++ a/include/linux/swap.h
@@ -538,7 +538,8 @@ static inline int swp_swapcount(swp_entr
 	return 0;
 }
 
-#define reuse_swap_page(page)	(page_mapcount(page) == 1)
+#define reuse_swap_page(page) \
+	(!PageTransCompound(page) && page_mapcount(page) == 1)
 
 static inline int try_to_free_swap(struct page *page)
 {
diff -puN mm/huge_memory.c~mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault
+++ a/mm/huge_memory.c
@@ -1199,7 +1199,17 @@ int do_huge_pmd_wp_page(struct mm_struct
 
 	page = pmd_page(orig_pmd);
 	VM_BUG_ON_PAGE(!PageCompound(page) || !PageHead(page), page);
-	if (page_mapcount(page) == 1) {
+	/*
+	 * We can only reuse the page if nobody else maps the huge page or it's
+	 * part. We can do it by checking page_mapcount() on each sub-page, but
+	 * it's expensive.
+	 * The cheaper way is to check page_count() to be equal 1: every
+	 * mapcount takes page reference reference, so this way we can
+	 * guarantee, that the PMD is the only mapping.
+	 * This can give false negative if somebody pinned the page, but that's
+	 * fine.
+	 */
+	if (page_mapcount(page) == 1 && page_count(page) == 1) {
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
diff -puN mm/swapfile.c~mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault
+++ a/mm/swapfile.c
@@ -926,6 +926,9 @@ int reuse_swap_page(struct page *page)
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	if (unlikely(PageKsm(page)))
 		return 0;
+	/* The page is part of THP and cannot be reused */
+	if (PageTransCompound(page))
+		return 0;
 	count = page_mapcount(page);
 	if (count <= 1 && PageSwapCache(page)) {
 		count += page_swapcount(page);
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

