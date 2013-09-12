From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:09 -0700
Message-ID: <52321989.b+pDBKbDZPYLcPtz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, dhillf@gmail.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,dhillf@gmail.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:09 -0700


The patch titled
     Subject: mm, hugetlb: return a reserved page to a reserved pool if failed
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: return a reserved page to a reserved pool if failed

If we fail with a reserved page, just calling put_page() is not
sufficient, because put_page() invoke free_huge_page() at last step and it
doesn't know whether a page comes from a reserved pool or not.  So it
doesn't do anything related to reserved count.  This makes reserve count
lower than how we need, because reserve count already decrease in
dequeue_huge_page_vma().  This patch fix this situation.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed
+++ a/mm/hugetlb.c
@@ -572,6 +572,7 @@ retry_cpuset:
 				if (!vma_has_reserves(vma, chg))
 					break;
 
+				SetPagePrivate(page);
 				h->resv_huge_pages--;
 				break;
 			}
@@ -629,15 +630,20 @@ static void free_huge_page(struct page *
 	int nid = page_to_nid(page);
 	struct hugepage_subpool *spool =
 		(struct hugepage_subpool *)page_private(page);
+	bool restore_reserve;
 
 	set_page_private(page, 0);
 	page->mapping = NULL;
 	BUG_ON(page_count(page));
 	BUG_ON(page_mapcount(page));
+	restore_reserve = PagePrivate(page);
 
 	spin_lock(&hugetlb_lock);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
+	if (restore_reserve)
+		h->resv_huge_pages++;
+
 	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
 		/* remove the page from active list */
 		list_del(&page->lru);
@@ -2636,6 +2642,8 @@ retry_avoidcopy:
 	spin_lock(&mm->page_table_lock);
 	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
+		ClearPagePrivate(new_page);
+
 		/* Break COW */
 		huge_ptep_clear_flush(vma, address, ptep);
 		set_huge_pte_at(mm, address, ptep,
@@ -2747,6 +2755,7 @@ retry:
 					goto retry;
 				goto out;
 			}
+			ClearPagePrivate(page);
 
 			spin_lock(&inode->i_lock);
 			inode->i_blocks += blocks_per_huge_page(h);
@@ -2793,8 +2802,10 @@ retry:
 	if (!huge_pte_none(huge_ptep_get(ptep)))
 		goto backout;
 
-	if (anon_rmap)
+	if (anon_rmap) {
+		ClearPagePrivate(page);
 		hugepage_add_new_anon_rmap(page, vma, address);
+	}
 	else
 		page_dup_rmap(page);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

