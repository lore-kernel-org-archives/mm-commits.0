From: akpm@linux-foundation.org
Subject: [merged] mm-fix-the-incorrect-hugepages-count.patch removed from
 -mm tree
Date: Mon, 15 Aug 2016 13:40:23 -0700
Message-ID: <57b228b7.zixknFE9bt7vJJ2C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbcHOUkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 16:40:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix incorrect hugepages count during mem hotplug
has been removed from the -mm tree.  Its filename was
     mm-fix-the-incorrect-hugepages-count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

