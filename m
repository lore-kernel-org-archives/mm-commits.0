From: akpm@linux-foundation.org
Subject: [patch 087/127] mm/hugetlb: improve locking in
 dissolve_free_huge_pages()
Date: Fri, 07 Oct 2016 17:01:13 -0700
Message-ID: <57f83749.OnhzgjgpgAnuQsWw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932687AbcJHABP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, gerald.schaefer@de.ibm.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rui.teng@linux.vnet.ibm.com, schwidefsky@de.ibm.com, vbabka@suse.cz

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: mm/hugetlb: improve locking in dissolve_free_huge_pages()

For every pfn aligned to minimum_order, dissolve_free_huge_pages() will
call dissolve_free_huge_page() which takes the hugetlb spinlock, even if
the page is not huge at all or a hugepage that is in-use.

Improve this by doing the PageHuge() and page_count() checks already in
dissolve_free_huge_pages() before calling dissolve_free_huge_page().  In
dissolve_free_huge_page(), when holding the spinlock, those checks need to
be revalidated.

Link: http://lkml.kernel.org/r/20160926172811.94033-4-gerald.schaefer@de.ibm.com
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rui Teng <rui.teng@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-improve-locking-in-dissolve_free_huge_pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-improve-locking-in-dissolve_free_huge_pages
+++ a/mm/hugetlb.c
@@ -1476,14 +1476,20 @@ out:
 int dissolve_free_huge_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
+	struct page *page;
 	int rc = 0;
 
 	if (!hugepages_supported())
 		return rc;
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << minimum_order)
-		if (rc = dissolve_free_huge_page(pfn_to_page(pfn)))
-			break;
+	for (pfn = start_pfn; pfn < end_pfn; pfn += 1 << minimum_order) {
+		page = pfn_to_page(pfn);
+		if (PageHuge(page) && !page_count(page)) {
+			rc = dissolve_free_huge_page(page);
+			if (rc)
+				break;
+		}
+	}
 
 	return rc;
 }
_
