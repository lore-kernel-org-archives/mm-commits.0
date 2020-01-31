From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-page=5Fvma=5Fmappedc-explicitly-compare-pfn-for-normal-?=
 =?US-ASCII?Q?hugetlbfs-and-thp-page.patch?= removed from -mm tree
Date: Fri, 31 Jan 2020 15:18:17 -0800
Message-ID: <20200131231817.nUwWt3maO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXSS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:18:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_vma_mapped.c: explicitly compare pfn for normal, hugetlbfs and THP page
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mappedc-explicitly-compare-pfn-for-normal-hugetlbfs-and-thp-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm/page_vma_mapped.c: explicitly compare pfn for normal, hugetlbfs and THP page

When check_pte, pfn of normal, hugetlbfs and THP page need be compared. 
The current implementation apply comparison as

- normal 4K page: page_pfn <= pfn < page_pfn + 1
- hugetlbfs page:  page_pfn <= pfn < page_pfn + HPAGE_PMD_NR
- THP page: page_pfn <= pfn < page_pfn + HPAGE_PMD_NR

in pfn_in_hpage.  For hugetlbfs page, it should be page_pfn == pfn

Now, change pfn_in_hpage to pfn_is_match to highlight that comparison is
not only for THP and explicitly compare for these cases.

No impact upon current behavior, just make the code clear.  I think it
is important to make the code clear - comparing hugetlbfs page in range
page_pfn <= pfn < page_pfn + HPAGE_PMD_NR is confusing.

Link: http://lkml.kernel.org/r/1578737885-8890-1-git-send-email-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mappedc-explicitly-compare-pfn-for-normal-hugetlbfs-and-thp-page
+++ a/mm/page_vma_mapped.c
@@ -52,12 +52,16 @@ static bool map_pte(struct page_vma_mapp
 	return true;
 }
 
-static inline bool pfn_in_hpage(struct page *hpage, unsigned long pfn)
+static inline bool pfn_is_match(struct page *page, unsigned long pfn)
 {
-	unsigned long hpage_pfn = page_to_pfn(hpage);
+	unsigned long page_pfn = page_to_pfn(page);
+
+	/* normal page and hugetlbfs page */
+	if (!PageTransCompound(page) || PageHuge(page))
+		return page_pfn == pfn;
 
 	/* THP can be referenced by any subpage */
-	return pfn >= hpage_pfn && pfn - hpage_pfn < hpage_nr_pages(hpage);
+	return pfn >= page_pfn && pfn - page_pfn < hpage_nr_pages(page);
 }
 
 /**
@@ -108,7 +112,7 @@ static bool check_pte(struct page_vma_ma
 		pfn = pte_pfn(*pvmw->pte);
 	}
 
-	return pfn_in_hpage(pvmw->page, pfn);
+	return pfn_is_match(pvmw->page, pfn);
 }
 
 /**
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are
