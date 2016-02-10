From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-fix-gigantic-page-initialization-allocation.patch removed from
 -mm tree
Date: Wed, 10 Feb 2016 11:35:47 -0800
Message-ID: <56bb9113.1WO+NPKVDbjaLUYN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbcBJTfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, jmarchan@redhat.com, kirill.shutemov@linux.intel.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix gigantic page initialization/allocation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-gigantic-page-initialization-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: fix gigantic page initialization/allocation

Attempting to preallocate 1G gigantic huge pages at boot time with
"hugepagesz=1G hugepages=1" on the kernel command line will prevent
booting with the following:

kernel BUG at mm/hugetlb.c:1218!

When mapcount accounting was reworked, the setting of
compound_mapcount_ptr in prep_compound_gigantic_page was overlooked.  As a
result, the validation of mapcount in free_huge_page fails.

The "BUG_ON" checks in free_huge_page were also changed to "VM_BUG_ON_PAGE"
to assist with debugging.

Fixes: 53f9263baba69 ("mm: rework mapcount accounting to enable 4k mapping of THPs")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Tested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-gigantic-page-initialization-allocation mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-gigantic-page-initialization-allocation
+++ a/mm/hugetlb.c
@@ -1214,8 +1214,8 @@ void free_huge_page(struct page *page)
 
 	set_page_private(page, 0);
 	page->mapping = NULL;
-	BUG_ON(page_count(page));
-	BUG_ON(page_mapcount(page));
+	VM_BUG_ON_PAGE(page_count(page), page);
+	VM_BUG_ON_PAGE(page_mapcount(page), page);
 	restore_reserve = PagePrivate(page);
 	ClearPagePrivate(page);
 
@@ -1286,6 +1286,7 @@ static void prep_compound_gigantic_page(
 		set_page_count(p, 0);
 		set_compound_head(p, page);
 	}
+	atomic_set(compound_mapcount_ptr(page), -1);
 }
 
 /*
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


