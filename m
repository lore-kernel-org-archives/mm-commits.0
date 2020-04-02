From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 147/155] hugetlb_cgroup: support noreserve
 mappings
Date: Wed, 01 Apr 2020 21:11:31 -0700
Message-ID: <20200402041131.AsrG1azep%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBELd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:11:33 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, almasrymina@google.com, gthelen@google.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org, torvalds@linux-foundation.org

From: Mina Almasry <almasrymina@google.com>
Subject: hugetlb_cgroup: support noreserve mappings

Support MAP_NORESERVE accounting as part of the new counter.

For each hugepage allocation, at allocation time we check if there is a
reservation for this allocation or not.  If there is a reservation for
this allocation, then this allocation was charged at reservation time, and
we don't re-account it.  If there is no reserevation for this allocation,
we charge the appropriate hugetlb_cgroup.

The hugetlb_cgroup to uncharge for this allocation is stored in
page[3].private.  We use new APIs added in an earlier patch to set this
pointer.

Link: http://lkml.kernel.org/r/20200211213128.73302-6-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb_cgroup-support-noreserve-mappings
+++ a/mm/hugetlb.c
@@ -1345,6 +1345,8 @@ static void __free_huge_page(struct page
 	clear_page_huge_active(page);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
+	hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
+					  pages_per_huge_page(h), page);
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
@@ -2281,6 +2283,7 @@ struct page *alloc_huge_page(struct vm_a
 	long gbl_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg;
+	bool deferred_reserve;
 
 	idx = hstate_index(h);
 	/*
@@ -2318,9 +2321,19 @@ struct page *alloc_huge_page(struct vm_a
 			gbl_chg = 1;
 	}
 
+	/* If this allocation is not consuming a reservation, charge it now.
+	 */
+	deferred_reserve = map_chg || avoid_reserve || !vma_resv_map(vma);
+	if (deferred_reserve) {
+		ret = hugetlb_cgroup_charge_cgroup_rsvd(
+			idx, pages_per_huge_page(h), &h_cg);
+		if (ret)
+			goto out_subpool_put;
+	}
+
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
 	if (ret)
-		goto out_subpool_put;
+		goto out_uncharge_cgroup_reservation;
 
 	spin_lock(&hugetlb_lock);
 	/*
@@ -2343,6 +2356,14 @@ struct page *alloc_huge_page(struct vm_a
 		/* Fall through */
 	}
 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
+	/* If allocation is not consuming a reservation, also store the
+	 * hugetlb_cgroup pointer on the page.
+	 */
+	if (deferred_reserve) {
+		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
+						  h_cg, page);
+	}
+
 	spin_unlock(&hugetlb_lock);
 
 	set_page_private(page, (unsigned long)spool);
@@ -2367,6 +2388,10 @@ struct page *alloc_huge_page(struct vm_a
 
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
+out_uncharge_cgroup_reservation:
+	if (deferred_reserve)
+		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
+						    h_cg);
 out_subpool_put:
 	if (map_chg || avoid_reserve)
 		hugepage_subpool_put_pages(spool, 1);
_
