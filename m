From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:59 -0700
Message-ID: <5232197f.7LOedkezA3jxuVIC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab3ILToA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, dhillf@gmail.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,dhillf@gmail.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:59 -0700


The patch titled
     Subject: mm, hugetlb: protect reserved pages when soft offlining a hugepage
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: protect reserved pages when soft offlining a hugepage

Don't use the reserve pool when soft offlining a hugepage.  Check we have
free pages outside the reserve pool before we dequeue the huge page. 
Otherwise, we can steal other's reserve page.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage
+++ a/mm/hugetlb.c
@@ -955,10 +955,11 @@ static struct page *alloc_buddy_huge_pag
  */
 struct page *alloc_huge_page_node(struct hstate *h, int nid)
 {
-	struct page *page;
+	struct page *page = NULL;
 
 	spin_lock(&hugetlb_lock);
-	page = dequeue_huge_page_node(h, nid);
+	if (h->free_huge_pages - h->resv_huge_pages > 0)
+		page = dequeue_huge_page_node(h, nid);
 	spin_unlock(&hugetlb_lock);
 
 	if (!page)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

