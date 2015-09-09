From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:46:23 -0700
Message-ID: <55f08c8f.U5/qGr5s9kRFk2g0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbbIITqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: alloc_huge_page handle areas hole punched by fallocate
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: alloc_huge_page handle areas hole punched by fallocate

Areas hole punched by fallocate will not have entries in the
region/reserve map.  However, shared mappings with min_size subpool
reservations may still have reserved pages.  alloc_huge_page needs to
handle this special case and do the proper accounting.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   54 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate
+++ a/mm/hugetlb.c
@@ -1733,34 +1733,58 @@ static struct page *alloc_huge_page(stru
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
-	long chg, commit;
+	long map_chg, map_commit;
+	long gbl_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg;
 
 	idx = hstate_index(h);
 	/*
-	 * Processes that did not create the mapping will have no
-	 * reserves and will not have accounted against subpool
-	 * limit. Check that the subpool limit can be made before
-	 * satisfying the allocation MAP_NORESERVE mappings may also
-	 * need pages and subpool limit allocated allocated if no reserve
-	 * mapping overlaps.
+	 * Examine the region/reserve map to determine if the process
+	 * has a reservation for the page to be allocated.  A return
+	 * code of zero indicates a reservation exists (no change).
 	 */
-	chg = vma_needs_reservation(h, vma, addr);
-	if (chg < 0)
+	map_chg = gbl_chg = vma_needs_reservation(h, vma, addr);
+	if (map_chg < 0)
 		return ERR_PTR(-ENOMEM);
-	if (chg || avoid_reserve)
-		if (hugepage_subpool_get_pages(spool, 1) < 0) {
+
+	/*
+	 * Processes that did not create the mapping will have no
+	 * reserves as indicated by the region/reserve map. Check
+	 * that the allocation will not exceed the subpool limit.
+	 * Allocations for MAP_NORESERVE mappings also need to be
+	 * checked against any subpool limit.
+	 */
+	if (map_chg || avoid_reserve) {
+		gbl_chg = hugepage_subpool_get_pages(spool, 1);
+		if (gbl_chg < 0) {
 			vma_end_reservation(h, vma, addr);
 			return ERR_PTR(-ENOSPC);
 		}
 
+		/*
+		 * Even though there was no reservation in the region/reserve
+		 * map, there could be reservations associated with the
+		 * subpool that can be used.  This would be indicated if the
+		 * return value of hugepage_subpool_get_pages() is zero.
+		 * However, if avoid_reserve is specified we still avoid even
+		 * the subpool reservations.
+		 */
+		if (avoid_reserve)
+			gbl_chg = 1;
+	}
+
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
 	if (ret)
 		goto out_subpool_put;
 
 	spin_lock(&hugetlb_lock);
-	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, chg);
+	/*
+	 * glb_chg is passed to indicate whether or not a page must be taken
+	 * from the global free pool (global change).  gbl_chg == 0 indicates
+	 * a reservation exists for the allocation.
+	 */
+	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, gbl_chg);
 	if (!page) {
 		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
@@ -1776,8 +1800,8 @@ static struct page *alloc_huge_page(stru
 
 	set_page_private(page, (unsigned long)spool);
 
-	commit = vma_commit_reservation(h, vma, addr);
-	if (unlikely(chg > commit)) {
+	map_commit = vma_commit_reservation(h, vma, addr);
+	if (unlikely(map_chg > map_commit)) {
 		/*
 		 * The page was added to the reservation map between
 		 * vma_needs_reservation and vma_commit_reservation.
@@ -1797,7 +1821,7 @@ static struct page *alloc_huge_page(stru
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
 out_subpool_put:
-	if (chg || avoid_reserve)
+	if (map_chg || avoid_reserve)
 		hugepage_subpool_put_pages(spool, 1);
 	vma_end_reservation(h, vma, addr);
 	return ERR_PTR(-ENOSPC);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


