From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 065/131] khugepaged: allow to collapse a page
 shared across fork
Date: Wed, 03 Jun 2020 16:00:20 -0700
Message-ID: <20200603230020.0ZpQAslEu%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXAW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:00:22 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com

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

[yang.shi@linux.alibaba.com: remove error message when checking external pins]
  Link: http://lkml.kernel.org/r/1589317383-9595-1-git-send-email-yang.shi@linux.alibaba.com
[cai@lca.pw: fix set-but-not-used warning]
  Link: http://lkml.kernel.org/r/20200521145644.GA6367@ovpn-112-192.phx2.redhat.com
Link: http://lkml.kernel.org/r/20200416160026.16538-6-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
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

 mm/khugepaged.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

--- a/mm/khugepaged.c~khugepaged-allow-to-collapse-a-page-shared-across-fork
+++ a/mm/khugepaged.c
@@ -526,6 +526,17 @@ static void release_pte_pages(pte_t *pte
 	}
 }
 
+static bool is_refcount_suitable(struct page *page)
+{
+	int expected_refcount;
+
+	expected_refcount = total_mapcount(page);
+	if (PageSwapCache(page))
+		expected_refcount += compound_nr(page);
+
+	return page_count(page) == expected_refcount;
+}
+
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long address,
 					pte_t *pte)
@@ -578,11 +589,17 @@ static int __collapse_huge_page_isolate(
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
@@ -669,7 +686,6 @@ static void __collapse_huge_page_copy(pt
 		} else {
 			src_page = pte_page(pteval);
 			copy_user_highpage(page, src_page, address, vma);
-			VM_BUG_ON_PAGE(page_mapcount(src_page) != 1, src_page);
 			release_pte_page(src_page);
 			/*
 			 * ptl mostly unnecessary, but preempt has to
@@ -1221,11 +1237,23 @@ static int khugepaged_scan_pmd(struct mm
 		}
 
 		/*
-		 * cannot use mapcount: can't collapse if there's a gup pin.
-		 * The page must only be referenced by the scanned process
-		 * and page swap cache.
+		 * Check if the page has any GUP (or other external) pins.
+		 *
+		 * Here the check is racy it may see totmal_mapcount > refcount
+		 * in some cases.
+		 * For example, one process with one forked child process.
+		 * The parent has the PMD split due to MADV_DONTNEED, then
+		 * the child is trying unmap the whole PMD, but khugepaged
+		 * may be scanning the parent between the child has
+		 * PageDoubleMap flag cleared and dec the mapcount.  So
+		 * khugepaged may see total_mapcount > refcount.
+		 *
+		 * But such case is ephemeral we could always retry collapse
+		 * later.  However it may report false positive if the page
+		 * has excessive GUP pins (i.e. 512).  Anyway the same check
+		 * will be done again later the risk seems low.
 		 */
-		if (page_count(page) != 1 + PageSwapCache(page)) {
+		if (!is_refcount_suitable(page)) {
 			result = SCAN_PAGE_COUNT;
 			goto out_unmap;
 		}
_
