From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address.patch added
 to -mm tree
Date: Mon, 16 Dec 2013 15:01:50 -0800
Message-ID: <52af865e.a9FfkYQAY2SR6O87%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3LPXBv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 18:01:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, kirill.shutemov@linux.intel.com, guohanjun@huawei.com, wujianguo@huawei.com

Subject: + mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address.patch added to -mm tree
To: wujianguo@huawei.com,guohanjun@huawei.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,qiuxishi@huawei.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 15:01:50 -0800


The patch titled
     Subject: mm/hugetlb: check for pte NULL pointer in __page_check_address()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memory-failurec-recheck-pagehuge-after-hugetlb-page-migrate-successfully.patch
mm-hugetlb-check-for-pte-null-pointer-in-__page_check_address.patch

