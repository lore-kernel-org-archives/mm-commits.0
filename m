From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failurec-recheck-pagehuge-after-hugetlb-page-migrate-successfully.patch removed from -mm tree
Date: Thu, 19 Dec 2013 11:54:01 -0800
Message-ID: <52b34ed9.GWM9yLziRWTecJGR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab3LSTyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:54:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, n-horiguchi@ah.jp.nec.com, wujianguo@huawei.com

Subject: [merged] mm-memory-failurec-recheck-pagehuge-after-hugetlb-page-migrate-successfully.patch removed from -mm tree
To: wujianguo@huawei.com,n-horiguchi@ah.jp.nec.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:54:01 -0800


The patch titled
     Subject: mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-recheck-pagehuge-after-hugetlb-page-migrate-successfully.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully

After a successful hugetlb page migration by soft offline, the source page
will either be freed into hugepage_freelists or buddy(over-commit page). 
If page is in buddy, page_hstate(page) will be NULL.  It will hit a NULL
pointer dereference in dequeue_hwpoisoned_huge_page().

[  890.677918] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000058
[  890.685741] IP: [<ffffffff81163761>]
dequeue_hwpoisoned_huge_page+0x131/0x1d0
[  890.692861] PGD c23762067 PUD c24be2067 PMD 0
[  890.697314] Oops: 0000 [#1] SMP

So check PageHuge(page) after call migrate_pages() successfully.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-recheck-pagehuge-after-hugetlb-page-migrate-successfully mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-recheck-pagehuge-after-hugetlb-page-migrate-successfully
+++ a/mm/memory-failure.c
@@ -1505,10 +1505,16 @@ static int soft_offline_huge_page(struct
 		if (ret > 0)
 			ret = -EIO;
 	} else {
-		set_page_hwpoison_huge_page(hpage);
-		dequeue_hwpoisoned_huge_page(hpage);
-		atomic_long_add(1 << compound_order(hpage),
-				&num_poisoned_pages);
+		/* overcommit hugetlb page will be freed to buddy */
+		if (PageHuge(page)) {
+			set_page_hwpoison_huge_page(hpage);
+			dequeue_hwpoisoned_huge_page(hpage);
+			atomic_long_add(1 << compound_order(hpage),
+					&num_poisoned_pages);
+		} else {
+			SetPageHWPoison(page);
+			atomic_long_inc(&num_poisoned_pages);
+		}
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch

