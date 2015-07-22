From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
 added to -mm tree
Date: Wed, 22 Jul 2015 15:07:31 -0700
Message-ID: <55b01423.jGjHjxQ68ya8aq55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbGVWHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 18:07:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: alloc_huge_page handle areas hole punched by fallocate
has been added to the -mm tree.  Its filename is
     mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hugetlb-make-the-function-vma_shareable-bool.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch

