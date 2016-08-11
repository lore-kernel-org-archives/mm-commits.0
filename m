From: akpm@linux-foundation.org
Subject: [patch 1/7] mm/hugetlb: fix incorrect hugepages count during mem
 hotplug
Date: Thu, 11 Aug 2016 15:32:55 -0700
Message-ID: <57acfd17.sSLI+fIeLApXvXE1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbcHKWc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 18:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhongjiang@huawei.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com

From: zhong jiang <zhongjiang@huawei.com>
Subject: mm/hugetlb: fix incorrect hugepages count during mem hotplug

When memory hotplug operates, free hugepages will be freed if the movable
node is offline.  Therefore, /proc/sys/vm/nr_hugepages will be incorrect.

Fix it by reducing max_huge_pages when the node is offlined.

n-horiguchi@ah.jp.nec.com said:

: dissolve_free_huge_page intends to break a hugepage into buddy, and the
: destination hugepage is supposed to be allocated from the pool of the
: destination node, so the system-wide pool size is reduced.  So adding
: h->max_huge_pages-- makes sense to me.

Link: http://lkml.kernel.org/r/1470624546-902-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/hugetlb.c~mm-fix-the-incorrect-hugepages-count mm/hugetlb.c
--- a/mm/hugetlb.c~mm-fix-the-incorrect-hugepages-count
+++ a/mm/hugetlb.c
@@ -1448,6 +1448,7 @@ static void dissolve_free_huge_page(stru
 		list_del(&page->lru);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+		h->max_huge_pages--;
 		update_and_free_page(h, page);
 	}
 	spin_unlock(&hugetlb_lock);
_
