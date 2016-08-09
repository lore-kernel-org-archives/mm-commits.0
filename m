From: akpm@linux-foundation.org
Subject: + mm-fix-the-incorrect-hugepages-count.patch added to -mm tree
Date: Tue, 09 Aug 2016 15:51:07 -0700
Message-ID: <57aa5e5b.R159C/mWpG3I1pZC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbcHIWvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Aug 2016 18:51:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix incorrect hugepages count during mem hotplug
has been added to the -mm tree.  Its filename is
     mm-fix-the-incorrect-hugepages-count.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-the-incorrect-hugepages-count.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-the-incorrect-hugepages-count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm/hugetlb: fix incorrect hugepages count during mem hotplug

When memory hotplug operates, free hugepages will be freed if the movable
node is offline.  Therefore, /proc/sys/vm/nr_hugepages will be incorrect.

Fix it by reducing max_huge_pages when the node is offlined.

Link: http://lkml.kernel.org/r/1470624546-902-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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

mm-fix-the-incorrect-hugepages-count.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

