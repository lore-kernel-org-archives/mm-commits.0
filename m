From: akpm@linux-foundation.org
Subject: +
 khugepaged-allow-to-collapse-a-page-shared-across-fork.patch added to -mm
 tree
Date: Thu, 16 Apr 2020 21:43:42 -0700
Message-ID: <20200417044342.XDUNPAv1v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgDQEnp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 00:43:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com


The patch titled
     Subject: khugepaged: allow to collapse a page shared across fork
has been added to the -mm tree.  Its filename is
     khugepaged-allow-to-collapse-a-page-shared-across-fork.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-allow-to-collapse-a-page-shared-across-fork.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-allow-to-collapse-a-page-shared-across-fork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: allow to collapse a page shared across fork

The page can be included into collapse as long as it doesn't have extra
pins (from GUP or otherwise).

Logic to check the refcount is moved to a separate function.  For pages in
swap cache, add compound_nr(page) to the expected refcount, in order to
handle the compound page case.  This is in preparation for the following
patch.

VM_BUG_ON_PAGE() was removed from __collapse_huge_page_copy() as the
invariant it checks is no longer valid: the source can be mapped multiple
times now.

Link: http://lkml.kernel.org/r/20200416160026.16538-6-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

--- a/mm/khugepaged.c~khugepaged-allow-to-collapse-a-page-shared-across-fork
+++ a/mm/khugepaged.c
@@ -526,6 +526,24 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
+static bool is_refcount_suitable(struct page *page)
+{
+	int expected_refcount, refcount;
+
+	refcount = page_count(page);
+	expected_refcount = total_mapcount(page);
+	if (PageSwapCache(page))
+		expected_refcount += compound_nr(page);
+
+	if (IS_ENABLED(CONFIG_DEBUG_VM) && expected_refcount > refcount) {
+		pr_err("expected_refcount (%d) > refcount (%d)\n",
+				expected_refcount, refcount);
+		dump_page(page, "Unexpected refcount");
+	}
+
+	return page_count(page) == expected_refcount;
+}
+
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long address,
 					pte_t *pte)
@@ -578,11 +596,17 @@ static int __collapse_huge_page_isolate(
 		}
 
 		/*
-		 * cannot use mapcount: can't collapse if there's a gup pin.
-		 * The page must only be referenced by the scanned process
-		 * and page swap cache.
+		 * Check if the page has any GUP (or other external) pins.
+		 *
+		 * The page table that maps the page has been already unlinked
+		 * from the page table tree and this process cannot get
+		 * an additinal pin on the page.
+		 *
+		 * New pins can come later if the page is shared across fork,
+		 * but not from this process. The other process cannot write to
+		 * the page, only trigger CoW.
 		 */
-		if (page_count(page) != 1 + PageSwapCache(page)) {
+		if (!is_refcount_suitable(page)) {
 			unlock_page(page);
 			result = SCAN_PAGE_COUNT;
 			goto out;
@@ -669,7 +693,6 @@ static void __collapse_huge_page_copy(pt
 		} else {
 			src_page = pte_page(pteval);
 			copy_user_highpage(page, src_page, address, vma);
-			VM_BUG_ON_PAGE(page_mapcount(src_page) != 1, src_page);
 			release_pte_page(src_page);
 			/*
 			 * ptl mostly unnecessary, but preempt has to
@@ -1220,12 +1243,8 @@ static int khugepaged_scan_pmd(struct mm
 			goto out_unmap;
 		}
 
-		/*
-		 * cannot use mapcount: can't collapse if there's a gup pin.
-		 * The page must only be referenced by the scanned process
-		 * and page swap cache.
-		 */
-		if (page_count(page) != 1 + PageSwapCache(page)) {
+		/* Check if the page has any GUP (or other external) pins */
+		if (!is_refcount_suitable(page)) {
 			result = SCAN_PAGE_COUNT;
 			goto out_unmap;
 		}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

khugepaged-add-self-test.patch
khugepaged-do-not-stop-collapse-if-less-than-half-ptes-are-referenced.patch
khugepaged-drain-all-lru-caches-before-scanning-pages.patch
khugepaged-drain-lru-add-pagevec-after-swapin.patch
khugepaged-allow-to-collapse-a-page-shared-across-fork.patch
khugepaged-allow-to-collapse-pte-mapped-compound-pages.patch
thp-change-cow-semantics-for-anon-thp.patch
khugepaged-introduce-max_ptes_shared-tunable.patch
