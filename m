From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-hugetlb-return-immediately-for-hugetlb-page-in-=5F=5Fdele?=
 =?US-ASCII?Q?te=5Ffrom=5Fpage=5Fcache.patch?= removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:01 -0700
Message-ID: <20170711192301.QbIZe2M1v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933570AbdGKTXC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm: hugetlb: return immediately for hugetlb page in __delete_from_page_cache()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: return immediately for hugetlb page in __delete_from_page_cache()

We avoid calling __mod_node_page_state(NR_FILE_PAGES) for hugetlb page
now, but it's not enough because later code doesn't handle hugetlb
properly.  Actually in our testing, WARN_ON_ONCE(PageDirty(page)) at the
end of this function fires for hugetlb, which makes no sense.  So we
should return immediately for hugetlb pages.

Link: http://lkml.kernel.org/r/1496305019-5493-3-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache mm/filemap.c
--- a/mm/filemap.c~mm-hugetlb-return-immediately-for-hugetlb-page-in-__delete_from_page_cache
+++ a/mm/filemap.c
@@ -239,14 +239,16 @@ void __delete_from_page_cache(struct pag
 	/* Leave page->index set: truncation lookup relies upon it */
 
 	/* hugetlb pages do not participate in page cache accounting. */
-	if (!PageHuge(page))
-		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
+	if (PageHuge(page))
+		return;
+
+	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
 	if (PageSwapBacked(page)) {
 		__mod_node_page_state(page_pgdat(page), NR_SHMEM, -nr);
 		if (PageTransHuge(page))
 			__dec_node_page_state(page, NR_SHMEM_THPS);
 	} else {
-		VM_BUG_ON_PAGE(PageTransHuge(page) && !PageHuge(page), page);
+		VM_BUG_ON_PAGE(PageTransHuge(page), page);
 	}
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


