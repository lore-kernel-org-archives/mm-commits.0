From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch added
 to -mm tree
Date: Wed, 14 Aug 2013 16:21:15 -0700
Message-ID: <520c10eb.SqhfxPtrRlcvUrQR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280Ab3HNXVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 19:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, dhillf@gmail.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: + mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,dhillf@gmail.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 16:21:15 -0700


The patch titled
     Subject: mm, hugetlb: return a reserved page to a reserved pool if failed
has been added to the -mm tree.  Its filename is
     mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch
mm-vmalloc-remove-useless-variable-in-vmap_block.patch
mm-vmalloc-use-well-defined-find_last_bit-func.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
linux-next.patch

