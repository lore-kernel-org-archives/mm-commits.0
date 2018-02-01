From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:34:44 -0800
Message-ID: <20180201193444._5q-IC-dn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754673AbeBATez (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:34:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu


The patch titled
     Subject: mm, hugetlb: get rid of surplus page accounting tricks
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, hugetlb: get rid of surplus page accounting tricks

alloc_surplus_huge_page increases the pool size and the number of surplus
pages opportunistically to prevent from races with the pool size change. 
See d1c3fb1f8f29 ("hugetlb: introduce nr_overcommit_hugepages sysctl") for
more details.

The resulting code is unnecessarily hairy, cause code duplication and
doesn't allow to share the allocation paths.  Moreover pool size changes
tend to be very seldom so optimizing for them is not really reasonable. 
Simplify the code and allow to allocate a fresh surplus page as long as we
are under the overcommit limit and then recheck the condition after the
allocation and drop the new page if the situation has changed.  This
should provide a reasonable guarantee that an abrupt allocation requests
will not go way off the limit.

If we consider races with the pool shrinking and enlarging then we should
be reasonably safe as well.  In the first case we are off by one in the
worst case and the second case should work OK because the page is not yet
visible.  We can waste CPU cycles for the allocation but that should be
acceptable for a relatively rare condition.

Link: http://lkml.kernel.org/r/20180103093213.26329-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Reale <ar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   62 ++++++++++++++++++-------------------------------
 1 file changed, 23 insertions(+), 39 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-get-rid-of-surplus-page-accounting-tricks mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-get-rid-of-surplus-page-accounting-tricks
+++ a/mm/hugetlb.c
@@ -1540,62 +1540,46 @@ int dissolve_free_huge_pages(unsigned lo
 static struct page *__alloc_surplus_huge_page(struct hstate *h, gfp_t gfp_mask,
 		int nid, nodemask_t *nmask)
 {
-	struct page *page;
-	unsigned int r_nid;
+	struct page *page = NULL;
 
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	/*
-	 * Assume we will successfully allocate the surplus page to
-	 * prevent racing processes from causing the surplus to exceed
-	 * overcommit
-	 *
-	 * This however introduces a different race, where a process B
-	 * tries to grow the static hugepage pool while alloc_pages() is
-	 * called by process A. B will only examine the per-node
-	 * counters in determining if surplus huge pages can be
-	 * converted to normal huge pages in adjust_pool_surplus(). A
-	 * won't be able to increment the per-node counter, until the
-	 * lock is dropped by B, but B doesn't drop hugetlb_lock until
-	 * no more huge pages can be converted from surplus to normal
-	 * state (and doesn't try to convert again). Thus, we have a
-	 * case where a surplus huge page exists, the pool is grown, and
-	 * the surplus huge page still exists after, even though it
-	 * should just have been converted to a normal huge page. This
-	 * does not leak memory, though, as the hugepage will be freed
-	 * once it is out of use. It also does not allow the counters to
-	 * go out of whack in adjust_pool_surplus() as we don't modify
-	 * the node values until we've gotten the hugepage and only the
-	 * per-node value is checked there.
-	 */
 	spin_lock(&hugetlb_lock);
-	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
-		spin_unlock(&hugetlb_lock);
-		return NULL;
-	} else {
-		h->nr_huge_pages++;
-		h->surplus_huge_pages++;
-	}
+	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages)
+		goto out_unlock;
 	spin_unlock(&hugetlb_lock);
 
 	page = __hugetlb_alloc_buddy_huge_page(h, gfp_mask, nid, nmask);
+	if (!page)
+		goto out_unlock;
 
 	spin_lock(&hugetlb_lock);
-	if (page) {
+	/*
+	 * We could have raced with the pool size change.
+	 * Double check that and simply deallocate the new page
+	 * if we would end up overcommiting the surpluses. Abuse
+	 * temporary page to workaround the nasty free_huge_page
+	 * codeflow
+	 */
+	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
+		SetPageHugeTemporary(page);
+		put_page(page);
+		page = NULL;
+	} else {
+		int r_nid;
+
+		h->surplus_huge_pages++;
+		h->nr_huge_pages++;
 		INIT_LIST_HEAD(&page->lru);
 		r_nid = page_to_nid(page);
 		set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 		set_hugetlb_cgroup(page, NULL);
-		/*
-		 * We incremented the global counters already
-		 */
 		h->nr_huge_pages_node[r_nid]++;
 		h->surplus_huge_pages_node[r_nid]++;
-	} else {
-		h->nr_huge_pages--;
-		h->surplus_huge_pages--;
 	}
+
+out_unlock:
 	spin_unlock(&hugetlb_lock);
 
 	return page;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch
mm-unclutter-thp-migration.patch
net-netfilter-x_tablesc-remove-size-check.patch

