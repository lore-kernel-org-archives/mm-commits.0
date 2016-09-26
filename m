From: akpm@linux-foundation.org
Subject: + mm-hugetlb-improve-locking-in-dissolve_free_huge_pages.patch
 added to -mm tree
Date: Mon, 26 Sep 2016 15:42:04 -0700
Message-ID: <57e9a43c.UYkRrIFzpo18u3TZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46637 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757713AbcIZWmG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2016 18:42:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.cz, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rui.teng@linux.vnet.ibm.com, schwidefsky@de.ibm.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: improve locking in dissolve_free_huge_pages()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-improve-locking-in-dissolve_free_huge_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-improve-locking-in-dissolve_free_huge_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-improve-locking-in-dissolve_free_huge_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.cz>
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

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

mm-hugetlb-fix-memory-offline-with-hugepage-size-memory-block-size.patch
mm-hugetlb-check-for-reserved-hugepages-during-memory-offline.patch
mm-hugetlb-improve-locking-in-dissolve_free_huge_pages.patch

