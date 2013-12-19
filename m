From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address.patch removed from -mm tree
Date: Thu, 19 Dec 2013 11:54:09 -0800
Message-ID: <52b34ee1.rfd5/ljIJaCCqA1v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3LSTyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:54:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, kirill.shutemov@linux.intel.com, guohanjun@huawei.com, wujianguo@huawei.com

Subject: [merged] mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address.patch removed from -mm tree
To: wujianguo@huawei.com,guohanjun@huawei.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,qiuxishi@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:54:09 -0800


The patch titled
     Subject: mm/hugetlb: check for pte NULL pointer in __page_check_address()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/hugetlb: check for pte NULL pointer in __page_check_address()

In __page_check_address(), if address's pud is not present,
huge_pte_offset() will return NULL, we should check the return value.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: qiuxishi <qiuxishi@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/rmap.c~mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address mm/rmap.c
--- a/mm/rmap.c~mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address
+++ a/mm/rmap.c
@@ -600,7 +600,11 @@ pte_t *__page_check_address(struct page
 	spinlock_t *ptl;
 
 	if (unlikely(PageHuge(page))) {
+		/* when pud is not present, pte will be NULL */
 		pte = huge_pte_offset(mm, address);
+		if (!pte)
+			return NULL;
+
 		ptl = huge_pte_lockptr(page_hstate(page), mm, pte);
 		goto check;
 	}
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch

